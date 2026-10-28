%STEP3_REPORT  Step 3 deliverable: convergence, mass balance, uncalibrated
%   power at 7500, torque curve 2000-8000, step-size and pipe checks.
P = params('quiet');

fprintf('\n===== STEP 3  engine_model =====\n');
fprintf('scheme: fixed crank step, explicit Euler (0-D) + lumped acoustic ladder (pipe)\n');

% ---------- base run -------------------------------------------------
opts = struct('max_revs',120,'quiet',true,'Nc',40);
M1 = engine_model(P, 7500, opts);

fprintf('\n  CONVERGENCE\n');
fprintf('    cycles to 1e-4 trapped-mass criterion : %d\n', M1.cycles);
fprintf('    final relative change                 : %.2e\n', M1.rel_change);
fprintf('    trapped mass at exhaust close         : %.6e kg\n', M1.m_trapped);
fprintf('    max pipe CFL                          : %.2f (limit 1.0)\n', M1.cfl_max);

fprintf('\n  MASS BALANCE over the converged cycle\n');
fprintf('    intake through the reed   : %.6e kg\n', M1.acc_reed);
fprintf('    discharge through stinger : %.6e kg\n', M1.acc_sting);
fprintf('    residual / intake         : %+.2e\n', M1.mass_bal);

fprintf('\n  UNCALIBRATED OPERATING POINT @ 7500 rpm\n');
fprintf('    indicated work            : %8.2f J/cycle\n', M1.W_i);
fprintf('    indicated power           : %8.1f W\n', M1.P_i);
fprintf('    friction torque           : %8.3f Nm\n', M1.T_fric);
fprintf('    brake power               : %8.1f W      (anchor 10400)\n', M1.P_b);
fprintf('    brake torque              : %8.2f Nm     (anchor 12.26 @7000)\n', M1.T_b);
fprintf('    BMEP                      : %8.2f bar\n', M1.BMEP/1e5);
fprintf('    IMEP                      : %8.2f bar\n', M1.IMEP/1e5);
fprintf('    delivery ratio            : %8.3f\n', M1.DR);
fprintf('    trapped fresh / delivered : %8.3f      (declared knob %.2f)\n', M1.eta_scav_eff, P.cal.eta_scav.value);
fprintf('    indicated efficiency      : %8.3f      (on trapped fuel)\n', M1.eta_i);
fprintf('    BSFC                      : %8.0f g/kWh\n', M1.BSFC);
fprintf('    peak cylinder pressure    : %8.2f bar\n', max(M1.p_cyl)/1e5);
fprintf('    peak cylinder temperature : %8.0f K\n', max(M1.T_cyl));

gap = 100*(M1.P_b - P.anchor.P_pk.value)/P.anchor.P_pk.value;
fprintf('\n  GAP TO THE ANCHOR (nothing tuned)\n');
fprintf('    brake power 10.4 kW : %+.1f%%\n', gap);
fprintf('    The priors happen to land close. That is NOT calibration: a +-10%%\n');
fprintf('    change in eta_scav moves P_b by ~5%%, so one anchor cannot pin it (D1).\n');

% ---------- plausibility --------------------------------------------
fprintf('\n  PLAUSIBILITY GATES\n');
flag = @(x,lo,hi) tern2(x>=lo && x<=hi);
fprintf('    BMEP   %6.2f bar   band 4-9     %s\n', M1.BMEP/1e5, flag(M1.BMEP/1e5,4,9));
fprintf('    DR     %6.3f       band 0.5-1.0 %s\n', M1.DR, flag(M1.DR,0.5,1.0));
fprintf('    BSFC   %6.0f g/kWh band 300-500 %s\n', M1.BSFC, flag(M1.BSFC,300,500));
p_trap = M1.m_trapped*287*M1.T_ec/(P.comp.Vc.value + P.geo.A_p.value*0.027);
fprintf('    p_trap %6.2f bar   band 1.1-1.8 %s\n', p_trap/1e5, flag(p_trap/1e5,1.1,1.8));
fprintf('    (trapped CR is 5.913 by construction; it cannot drift, the mass can)\n');

% ---------- step independence ---------------------------------------
P2 = P; P2.num.dtheta.value = 0.125;
o2 = opts; o2.dtheta = 0.125;
M2 = engine_model(P2, 7500, o2);
fprintf('\n  STEP-SIZE INDEPENDENCE\n');
fprintf('    dtheta 0.250 : P_b %8.1f W   m_trap %.4e   cycles %d\n', M1.P_b, M1.m_trapped, M1.cycles);
fprintf('    dtheta 0.125 : P_b %8.1f W   m_trap %.4e   cycles %d\n', M2.P_b, M2.m_trapped, M2.cycles);
fprintf('    delta P_b %.2f%%   delta m_trap %.2f%%\n', ...
    100*(M2.P_b-M1.P_b)/M1.P_b, 100*(M2.m_trapped-M1.m_trapped)/M1.m_trapped);

% ---------- pipe contribution ---------------------------------------
o3 = opts; o3.pipe = false;
M3 = engine_model(P, 7500, o3);
fprintf('\n  PIPE WAVE ACTION (the point of modelling it)\n');
fprintf('    pipe off : P_b %8.1f W   m_trap %.4e   DR %.3f\n', M3.P_b, M3.m_trapped, M3.DR);
fprintf('    pipe on  : P_b %8.1f W   m_trap %.4e   DR %.3f\n', M1.P_b, M1.m_trapped, M1.DR);
fprintf('    the return pulse raises trapped mass by %.1f%% and power by %.1f%%\n', ...
    100*(M1.m_trapped/M3.m_trapped-1), 100*(M1.P_b/M3.P_b-1));

% ---------- torque curve --------------------------------------------
fprintf('\n  TORQUE CURVE - UNCALIBRATED, 2000-8000 rpm\n');
fprintf('  %6s %9s %9s %8s %8s %8s %6s\n','rpm','P_b[W]','T_b[Nm]','BMEP','DR','BSFC','cyc');
fprintf('  %s\n', repmat('-',1,66));
sp = 2000:1000:8000; res = zeros(numel(sp),6);
for i = 1:numel(sp)
    Mi = engine_model(P, sp(i), opts);
    res(i,:) = [Mi.P_b, Mi.T_b, Mi.BMEP/1e5, Mi.DR, Mi.BSFC, Mi.cycles];
    fprintf('  %6d %9.0f %9.2f %8.2f %8.3f %8.0f %6d\n', sp(i), Mi.P_b, Mi.T_b, Mi.BMEP/1e5, Mi.DR, Mi.BSFC, Mi.cycles);
end
[mx,i1] = max(res(:,1)); [mt,i2] = max(res(:,2));
fprintf('  peak power %.0f W at %d rpm ; peak torque %.2f Nm at %d rpm\n', mx, sp(i1), mt, sp(i2));
fprintf('  catalogue: 10400 W at 7500, 12.26 Nm at 7000\n');

function s = tern2(ok)
if ok, s = 'ok'; else, s = 'FLAG'; end
end
