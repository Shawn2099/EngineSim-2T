%AUDIT_CONSISTENCY  P1 mass, P2 energy, P3 bands, C1 clamps, C2 cross-coupling.
%   Model revision 2.
addpath('C:\Users\malliath\Desktop\engine_sim\sim');
outdir = 'C:\Users\malliath\Desktop\engine_sim\sim\audit';
P0 = params('quiet');
Vt = P0.comp.Vc.value + P0.geo.A_p.value*0.027;
opts = struct('max_revs',300,'quiet',true,'Nc',60,'tol',1e-3);
R = struct();

fprintf('\nP1 mass, P2 energy, P3 bands (Nc 60)\n');
fprintf('%6s %9s %9s %11s %7s %7s %6s %6s %7s %6s %6s\n', ...
    'rpm','P_b','BMEP','massbal','E_res','DR','SE','TE','BSFC','pmax','Tmax');
sp = [4000 6000 7500 8500];
P1=zeros(1,4); P2=zeros(1,4); P3=zeros(4,9); C1=zeros(4,4);
for i=1:4
    M = engine_model(P0,sp(i),opts);
    pt = M.m_trapped*P0.comb.R_gas.value*M.T_ec/Vt;
    P1(i)=M.mass_bal; P2(i)=M.energy_residual;
    P3(i,:)=[M.P_b M.BMEP/1e5 M.DR M.SE M.BSFC pt/1e5 max(M.p_cyl)/1e5 max(M.T_cyl) M.TE];
    C1(i,:)=[min(M.T_cyl) min(M.p_cyl) min(M.m_cyl) min(M.pipe_p)];
    fprintf('%6d %9.0f %9.2f %11.2e %7.1e %7.3f %6.3f %6.3f %7.0f %6.1f %6.0f\n', ...
        sp(i), M.P_b, M.BMEP/1e5, M.mass_bal, M.energy_residual, M.DR, M.SE, M.BSFC, ...
        pt/1e5, max(M.p_cyl)/1e5, max(M.T_cyl));
end
R.P1=P1; R.P2=P2; R.P3=P3; R.C1=C1; R.speeds=sp;

fprintf('\nC2 cross-coupling (exhaust top / CR / pipe length), 7500 rpm\n');
lv = struct('top',[26 30], 'CR',[9.5 11.5], 'L',[1100 1300]);
C = zeros(2,2,2);
for a=1:2
 for b=1:2
  for c=1:2
    P = P0;
    P.port.exh_top.value = lv.top(a)*1e-3;
    P.comp.Vc.value = P.geo.V_d.value/(lv.CR(b)-1);
    P.exh.core_L.value = lv.L(c)*1e-3;
    M = engine_model(P,7500,opts);
    C(a,b,c) = M.P_b;
    fprintf('  top %4.1f  CR %4.1f  L %5.0f -> %8.0f W\n', lv.top(a), lv.CR(b), lv.L(c), M.P_b);
  end
 end
end
d_top_L1 = C(2,1,1)-C(1,1,1);  d_top_L2 = C(2,1,2)-C(1,1,2);
d_CR_top1= C(1,2,1)-C(1,1,1);  d_CR_top2 = C(2,2,1)-C(2,1,1);
d_L_top1 = C(1,1,2)-C(1,1,1);  d_L_top2 = C(2,1,2)-C(2,1,1);
fprintf('  +4 mm exhaust top: %+.0f W at L=1100, %+.0f W at L=1300 -> sign %s\n', ...
    d_top_L1, d_top_L2, tern(sign(d_top_L1)==sign(d_top_L2)));
fprintf('  +2 CR:             %+.0f W at top=26, %+.0f W at top=30 -> sign %s\n', ...
    d_CR_top1, d_CR_top2, tern(sign(d_CR_top1)==sign(d_CR_top2)));
fprintf('  +200 mm pipe:      %+.0f W at top=26, %+.0f W at top=30 -> sign %s\n', ...
    d_L_top1, d_L_top2, tern(sign(d_L_top1)==sign(d_L_top2)));
R.C2 = C;
R.c2_effects = [d_top_L1 d_top_L2; d_CR_top1 d_CR_top2; d_L_top1 d_L_top2];

save(fullfile(outdir,'consistency_results.mat'),'R');
fprintf('\n  saved consistency_results.mat\n');

function s = tern(c)
if c, s='same'; else, s='FLIPS'; end
end
