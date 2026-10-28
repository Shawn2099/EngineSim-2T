function T = audit_sweep(name, P0, values, outdir)
%AUDIT_SWEEP  One-parameter-at-a-time sweep with incremental CSV persistence.
%   T = audit_sweep(name, P0, values, outdir)
%
%   Resumable: rows already present in <outdir>\sweep_<name>.csv are skipped.
%   Three speeds (6000/7500/8500). "Peak" is the maximum over that grid and
%   "peak rpm" is the grid point it occurs at - a grid maximum, not a fitted
%   peak. A peak at the 8500 edge is reported as "at grid edge" by the report.
%
%   Model revision 2: block-mean convergence, tol 1e-3, Nc 40.

if nargin < 4, outdir = fullfile(fileparts(mfilename('fullpath'))); end
if ~exist(outdir,'dir'), mkdir(outdir); end
csv = fullfile(outdir, sprintf('sweep_%s.csv', name));
mat = fullfile(outdir, sprintf('sweep_%s.mat', name));

hdr = {'param','value','peakP','peakN','P6000','P7500','P8500', ...
       'BMEP7500','DR7500','SE7500','BSFC7500','ptrap7500','cyc7500','mb7500'};
speeds = [6000 7500 8500];
opts = struct('max_revs',200,'quiet',true,'Nc',40,'tol',1e-3);

done = [];
if exist(csv,'file')
    A = readmatrix(csv,'NumHeaderLines',1);
    if ~isempty(A), done = A(:,2); end
    fprintf('  [%s] resuming, %d of %d values on disk\n', name, numel(done), numel(values));
else
    fid = fopen(csv,'w'); fprintf(fid,'%s\n', strjoin(hdr,',')); fclose(fid);
end

Vt = P0.comp.Vc.value + P0.geo.A_p.value*0.027;

for i = 1:numel(values)
    v = values(i);
    if any(abs(done - v) < 1e-12), continue; end
    P = audit_set(P0, name, v);
    Pk = -inf; Pn = NaN; cyc = NaN; mb = NaN;
    row = [v Pk Pn NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
    for s = 1:numel(speeds)
        M = engine_model(P, speeds(s), opts);
        if ~isfinite(M.P_b) || ~isfinite(M.m_trapped) || M.m_trapped <= 0
            error('audit_sweep:numeric', '%s = %g at %d rpm gave non-finite output', name, v, speeds(s));
        end
        row(3+s) = M.P_b;
        if M.P_b > Pk, Pk = M.P_b; Pn = speeds(s); end
        if speeds(s) == 7500
            pt = M.m_trapped*P.comb.R_gas.value*M.T_ec/Vt;
            row(2) = Pk; row(3) = Pn;
            row(7) = M.BMEP/1e5; row(8) = M.DR; row(9) = M.SE;
            row(10) = M.BSFC; row(11) = pt/1e5;
            row(12) = M.cycles; row(13) = M.mass_bal;
        end
    end
    row(2) = Pk; row(3) = Pn;
    fid = fopen(csv,'a');
    fprintf(fid,'%s',name); fprintf(fid,',%.10g',row); fprintf(fid,'\n'); fclose(fid);
    fprintf('  %-10s %7.2f  peak %7.0f @%5d  P7500 %7.0f  DR %.3f  cyc %3d\n', ...
        name, v, Pk, Pn, row(5), row(8), row(12));
end

A = readmatrix(csv,'NumHeaderLines',1);
T = array2table(A,'VariableNames',hdr);
save(mat,'T');
fprintf('  [%s] %d rows -> %s\n', name, height(T), csv);
end

function P = audit_set(P, name, v)
switch name
    case 'exh_top'
        P.port.exh_top.value = v*1e-3;
    case 'tr_top'
        P.port.tr_top.value = v*1e-3*ones(1,5);
    case 'CR'
        P.comp.Vc.value = P.geo.V_d.value/(v-1);
        P.comp.CR_geom.value = v;
    case 'pipe_L'
        P.exh.core_L.value = v*1e-3;
    case 'ign'
        P.ign.adv_curve.value = [3000 v; 5000 v; 6500 v; 8000 v];
        P.ign.adv_btdc.value = v;
    case 'AFR'
        P.fuel.AFR.value = v;
    case 'reed_A'
        P.inlet.reed_As.value = v*1e-6;
    case 'cc_vol'
        P.cc.V.value = v*1e-6;
        P.cc.CR.value = (P.cc.V.value + P.geo.V_d.value)/P.cc.V.value;
    otherwise
        error('audit_sweep:unknown','unknown sweep %s', name);
end
end
