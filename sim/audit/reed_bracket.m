function T = reed_bracket(tag, kconst, outcsv)
%REED_BRACKET  Reed seat area x reed Cd bracket, before/after the petal
%stiffness fix.
%
%   T = reed_bracket('before', 3)
%   T = reed_bracket('after',  8)
%
%   Grid: reed_As = 500/600/700 mm2, reed_Cd = 0.6/0.7/0.8, speeds
%   4000/6000/7500/8500 rpm, Nc 40, tol 1e-3 (the audit setting).
%
%   kconst is used ONLY for the lift diagnostic below; the simulation itself
%   reads its stiffness from params.m / engine_model.m. Pass the multiplier
%   that is in the model for this run so the diagnostic matches it.
%
%   Columns: tag,A_mm2,Cd,P4000,P6000,P7500,P8500,peakP,peakN,BMEP7500,
%            DR7500,SE7500,TE7500,BSFC7500,cycle7500,pinfrac7500,
%            openfrac7500,lift_max_ratio7500,Ard_mean_ratio7500

if nargin < 3 || isempty(outcsv)
    outcsv = fullfile(fileparts(mfilename('fullpath')), sprintf('reed_bracket_%s.csv', tag));
end

areas  = [500 600 700];
cds    = [0.6 0.7 0.8];
speeds = [4000 6000 7500 8500];
opts   = struct('quiet',true,'Nc',40,'max_revs',200,'tol',1e-3);

P0 = params('quiet');
pamb = P0.fuel.p_amb.value;

hdr = {'tag','A_mm2','Cd','P4000','P6000','P7500','P8500','peakP','peakN', ...
       'BMEP7500','DR7500','SE7500','TE7500','BSFC7500','cycle7500', ...
       'pinfrac7500','openfrac7500','lift_max_ratio7500','Ard_mean_ratio7500'};
fid = fopen(outcsv,'w');
fprintf(fid,'%s\n', strjoin(hdr,','));
fclose(fid);
fid = fopen(outcsv,'a');

T = [];
for a = 1:numel(areas)
    for c = 1:numel(cds)
        P = P0;
        P.inlet.reed_As.value = areas(a)*1e-6;
        P.inlet.reed_Cd.value = cds(c);

        row = [areas(a) cds(c) NaN(1,4) -inf NaN NaN(1,6)];
        for s = 1:numel(speeds)
            M = engine_model(P, speeds(s), opts);
            if ~isfinite(M.P_b) || ~isfinite(M.m_trapped) || M.m_trapped <= 0
                error('reed_bracket:numeric','%s %g mm2 Cd %.1f at %d rpm gave non-finite output', ...
                    tag, areas(a), cds(c), speeds(s));
            end
            row(2+s) = M.P_b;
            if M.P_b > row(7), row(7) = M.P_b; row(8) = speeds(s); end
            if speeds(s) == 7500
                row(9)  = M.BMEP/1e5;
                row(10) = M.DR;
                row(11) = M.SE;
                row(12) = M.TE;
                row(13) = M.BSFC;
                row(14) = M.cycles;
                % --- lift diagnostic from the stored crankcase trace ---------
                rL  = P.inlet.reed_L.value;
                rn  = P.inlet.reed_n.value;
                rt  = P.inlet.reed_t.value;
                rE  = P.inlet.reed_E.value;
                rAs = P.inlet.reed_As.value;
                rw  = rAs/(rn*rL);
                rI  = rw*rt^3/12;
                rk  = kconst*rE*rI/rL^3;
                rAp = rAs/rn;
                xst = P.inlet.reed_xstop.value;
                dp  = pamb - M.p_cc(:);
                open = dp > P.inlet.reed_dp.value;
                x   = min(max(dp,0)*rAp/rk, xst);
                Ard = min(rn*x*rw, rAs);
                row(15) = mean(open & x >= 0.999*xst);
                row(16) = mean(open);
                row(17) = max(x)/xst;
                row(18) = mean(Ard(open))/rAs;
            end
        end
        vals = sprintf('%.10g,', row); vals(end) = [];
        fprintf(fid,'%s,%s\n', tag, vals);
        fprintf('  %s A=%3d Cd=%.1f  peak %6.0f @%4d  P7500 %6.0f  DR %.3f  SE %.3f  TE %.3f  pin %.2f  liftmax %.2f  Ard/As %.2f\n', ...
            tag, areas(a), cds(c), row(7), row(8), row(5), row(10), row(11), row(12), row(15), row(17), row(18));
        T = [T; row]; %#ok<AGROW>
    end
end
fclose(fid);
fprintf('  [%s] %d rows -> %s\n', tag, size(T,1), outcsv);
end
