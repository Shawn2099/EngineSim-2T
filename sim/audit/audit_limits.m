%AUDIT_LIMITS  P4 robustness: extreme values must return a result or a clean
%   error - never NaN, Inf, negative power or a silent clamp fallback.
addpath('C:\Users\malliath\Desktop\engine_sim\sim');
addpath('C:\Users\malliath\Desktop\engine_sim\sim\audit');
outdir = 'C:\Users\malliath\Desktop\engine_sim\sim\audit';
P0 = params('quiet');

cases = {
  'port top 34 mm',   'exh_top', 34
  'CR 13',            'CR',      13
  'AFR 10',           'AFR',     10
  'reed 200 mm2',     'reed_A',  200
  'port top 22 mm',   'exh_top', 22
  'CR 8',             'CR',      8
  'AFR 18',           'AFR',     18
  'pipe 800 mm',      'pipe_L',  800
  'pipe 1800 mm',     'pipe_L',  1800
};

fprintf('\nP4  robustness at the edges\n');
fprintf('%-18s %10s %9s %9s %8s %8s %s\n','case','P_b','BMEP','p_trap','DR','cyc','verdict');
out = {};
for i = 1:size(cases,1)
    nm = cases{i,1}; P = P0;
    try
        P = audit_set_local(P, cases{i,2}, cases{i,3});
        M = engine_model(P,7500,struct('max_revs',300,'quiet',true,'Nc',60,'tol',1e-3));
        pt = M.m_trapped*P.comb.R_gas.value*M.T_ec/ ...
             (P.comp.Vc.value + P.geo.A_p.value*0.027);
        ok = all(isfinite([M.P_b M.BMEP M.DR pt])) && M.P_b > 0 && M.mass_bal < 1e-6;
        fprintf('%-18s %10.0f %9.2f %9.3f %8.3f %8d %s\n', nm, M.P_b, M.BMEP/1e5, pt/1e5, ...
            M.DR, M.cycles, tern(ok,'ok','VIOLATION'));
        out(end+1,:) = {nm, M.P_b, M.BMEP/1e5, pt/1e5, M.DR, M.cycles, tern(ok,'ok','VIOLATION')};
    catch err
        fprintf('%-18s %10s %9s %9s %8s %8s %s\n', nm,'-','-','-','-','-', 'clean error');
        out(end+1,:) = {nm, NaN, NaN, NaN, NaN, NaN, ['error: ' err.identifier]};
    end
end
save(fullfile(outdir,'limits_results.mat'),'out');

function P = audit_set_local(P, name, v)
switch name
    case 'exh_top', P.port.exh_top.value = v*1e-3;
    case 'CR',      P.comp.Vc.value = P.geo.V_d.value/(v-1); P.comp.CR_geom.value = v;
    case 'AFR',     P.fuel.AFR.value = v;
    case 'reed_A',  P.inlet.reed_As.value = v*1e-6;
    case 'pipe_L',  P.exh.core_L.value = v*1e-3;
end
end

function s = tern(c,a,b)
if c, s=a; else, s=b; end
end
