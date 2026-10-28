%AUDIT_GRID  G1 grid independence, G2 step independence, G4 determinism.
%   Model revision 2 (block-mean convergence, tol 1e-3).
addpath('C:\Users\malliath\Desktop\engine_sim\sim');
outdir = 'C:\Users\malliath\Desktop\engine_sim\sim\audit';
P0 = params('quiet');
speeds = [4000 6000 7500];
opts = struct('max_revs',300,'quiet',true,'tol',1e-3);

fprintf('\nG1  grid independence (Nc 20/40/80)\n');
fprintf('%6s %8s %10s %8s %6s\n','Nc','rpm','P_b','DR','cyc');
G = zeros(3,3); DRg = zeros(3,3); cyc = zeros(3,3);
Ncs = [20 40 80];
for i = 1:3
    for j = 1:3
        o = opts; o.Nc = Ncs(i);
        M = engine_model(P0, speeds(j), o);
        G(i,j) = M.P_b; DRg(i,j) = M.DR; cyc(i,j) = M.cycles;
        fprintf('%6d %8d %10.0f %8.3f %6d\n', Ncs(i), speeds(j), M.P_b, M.DR, M.cycles);
    end
end
spread_g = (max(G,[],1)-min(G,[],1))./mean(G,1);
fprintf('   spread: %.2f%% %.2f%% %.2f%% -> %s\n', 100*spread_g, tern(all(spread_g<=0.02)));

fprintf('\nG2  step independence (dt 0.125/0.25/0.5)\n');
dts = [0.125 0.25 0.5];
S = zeros(3,3);
for i = 1:3
    for j = 1:3
        o = opts; o.dtheta = dts(i);
        M = engine_model(P0, speeds(j), o);
        S(i,j) = M.P_b;
        fprintf('%6.3f %8d %10.0f  cyc %3d\n', dts(i), speeds(j), M.P_b, M.cycles);
    end
end
spread_s = (max(S,[],1)-min(S,[],1))./mean(S,1);
fprintf('   spread: %.2f%% %.2f%% %.2f%% -> %s\n', 100*spread_s, tern(all(spread_s<=0.02)));

fprintf('\nG4  determinism (same input twice)\n');
M1 = engine_model(P0,7500,opts);
M2 = engine_model(P0,7500,opts);
d = max(abs([M1.P_b-M2.P_b, M1.DR-M2.DR, M1.m_trapped-M2.m_trapped]));
fprintf('   P_b %.6f vs %.6f  max diff %.3e -> %s\n', M1.P_b, M2.P_b, d, tern(d<=1e-9));

R.G=G; R.DR=DRg; R.cyc=cyc; R.spread_G=spread_g;
R.S=S; R.spread_S=spread_s; R.det=d;
save(fullfile(outdir,'grid_results.mat'),'R');

function s = tern(c)
if c, s='PASS'; else, s='FAIL'; end
end
