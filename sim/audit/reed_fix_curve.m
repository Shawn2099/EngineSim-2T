%REED_FIX_CURVE  Ten operating points with the corrected reed stiffness.
%   Mirrors audit_baseline.m settings (Nc 60, max_revs 180) so the output is
%   directly comparable with audit/AFTER.csv, which was recorded with the old
%   3EI/L^3 petal stiffness.
addpath('C:\Users\malliath\Desktop\engine_sim\sim');
outdir = 'C:\Users\malliath\Desktop\engine_sim\sim\audit';
csv = fullfile(outdir,'AFTER_stiff.csv');
speeds = [2000 3000 4000 5000 6000 6500 7000 7500 8000 8500];

hdr = {'rpm','P_b_W','T_b_Nm','BMEP_bar','DR','SE','TE','BSFC', ...
       'p_trap_bar','cycles','massbal','peak_p_bar','peak_T_K','eta_i'};

P = params('quiet');
Vt = P.comp.Vc.value + P.geo.A_p.value*0.027;
fprintf('reed_k = %.2f N/m\n', P.inlet.reed_k.value);

fid = fopen(csv,'w');
fprintf(fid,'%s\n', strjoin(hdr,','));
fclose(fid);

for i = 1:numel(speeds)
    N = speeds(i);
    M = engine_model(P, N, struct('max_revs',180,'quiet',true,'Nc',60));
    pt = M.m_trapped*P.comb.R_gas.value*M.T_ec/Vt;
    row = [N, M.P_b, M.T_b, M.BMEP/1e5, M.DR, M.SE, M.TE, M.BSFC, ...
           pt/1e5, M.cycles, M.mass_bal, max(M.p_cyl)/1e5, max(M.T_cyl), M.eta_i];
    fid = fopen(csv,'a');
    fprintf(fid,'%.10g,',row(1:end-1));
    fprintf(fid,'%.10g\n',row(end));
    fclose(fid);
    fprintf('%5d  P %7.0f W  BMEP %5.2f  DR %.3f  SE %.3f  TE %.3f  BSFC %4.0f  cyc %3d\n', ...
        N, M.P_b, M.BMEP/1e5, M.DR, M.SE, M.TE, M.BSFC, M.cycles);
end
fprintf('AFTER_stiff.csv written\n');
