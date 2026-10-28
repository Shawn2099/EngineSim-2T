%AUDIT_BASELINE  Record the unmodified model at 10 operating points.
%   Writes sim\audit\BASELINE.csv incrementally (one row per completed point),
%   so an interrupted run loses at most one point.
addpath('C:\Users\malliath\Desktop\engine_sim\sim');
outdir = 'C:\Users\malliath\Desktop\engine_sim\sim\audit';
csv = fullfile(outdir,'BASELINE.csv');
speeds = [2000 3000 4000 5000 6000 6500 7000 7500 8000 8500];

hdr = {'rpm','P_b_W','T_b_Nm','BMEP_bar','DR','SE_law','SE_actual','TE_law', ...
       'TE_actual','BSFC','p_trap_bar','cycles','massbal','peak_p_bar', ...
       'peak_T_K','eta_i','T_ec_K'};

P = params('quiet');
Vt = P.comp.Vc.value + P.geo.A_p.value*0.027;

fid = fopen(csv,'w');
fprintf(fid,'%s\n', strjoin(hdr,','));
fclose(fid);

for i = 1:numel(speeds)
    N = speeds(i);
    M = engine_model(P, N, struct('max_revs',180,'quiet',true,'Nc',60));
    pt = M.m_trapped*P.comb.R_gas.value*M.T_ec/Vt;
    se_a = M.m_fresh_ign/max(M.m_trapped,1e-12);
    te_a = M.m_fresh_ign/max(M.m_air,1e-12);
    row = [N, M.P_b, M.T_b, M.BMEP/1e5, M.DR, M.SE, se_a, M.TE, te_a, ...
           M.BSFC, pt/1e5, M.cycles, M.mass_bal, max(M.p_cyl)/1e5, ...
           max(M.T_cyl), M.eta_i, M.T_ec];
    fid = fopen(csv,'a');
    fprintf(fid,'%.10g,',row(1:end-1));
    fprintf(fid,'%.10g\n',row(end));
    fclose(fid);
    fprintf('%5d  P %7.0f W  BMEP %5.2f  DR %.3f  SE %.3f/%.3f  BSFC %4.0f  cyc %3d\n', ...
        N, M.P_b, M.BMEP/1e5, M.DR, M.SE, se_a, M.BSFC, M.cycles);
end
fprintf('BASELINE.csv written (%d points)\n', numel(speeds));
