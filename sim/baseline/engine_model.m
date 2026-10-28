function M = engine_model(P, N, opts)
%ENGINE_MODEL  Crank-angle-resolved 0-D fill-and-empty model, RX135 5-speed.
%
%   M = engine_model(P)              run at the anchor speed and report
%   M = engine_model(P, N)           run at N rpm
%   M = engine_model(P, N, opts)     options:
%        .pipe     true (default) | false  exhaust wave model. false replaces
%                  the pipe with a constant-pressure boundary at the port
%        .quiet    suppress per-cycle progress
%        .max_revs default P.num.n_revs
%        .tol      default P.num.rel_tol
%        .dtheta   default P.num.dtheta (degCA)
%        .Nc       pipe cells, default 60
%
%   Returns M with the converged cycle: power (indicated and brake), torque,
%   BMEP, delivery ratio, trapped mass, mass balance, per-step history.
%
% -------------------------------------------------------------------------
% SCHEME  (chosen, not inherited)
%   Fixed crank-angle step, explicit forward Euler on the 0-D states, and a
%   first-order Rusanov (local Lax-Friedrichs) finite-volume solver on the
%   quasi-1D pipe with the p*dA/dx area source retained, so the diffuser and
%   baffle cones reflect properly instead of behaving like a straight tube.
%
%   Why explicit: the 0-D system is NOT the stiff part. The fastest 0-D
%   timescale is cylinder blowdown, tau = m/mdot ~ 1.2e-4/0.17 ~ 7e-4 s,
%   which is ~126 steps at 0.25 degCA. The pipe sets the step.
%
%   Stability limit at 0.25 degCA and 7500 rpm:
%     dt      = 0.25/(6*7500)   = 5.556e-6 s
%     dx      = 1.032/60        = 17.2 mm
%     a_max   = sqrt(g*R*T)     = 617 m/s  (T = 1000 K)
%     CFL     = (|u|+a)*dt/dx   = 0.20      (limit 1.0; 0.5 used as margin)
%   At 2000 rpm dt is 3.75x larger and CFL rises to 0.75 - still inside the
%   limit, and the run reports the maximum CFL it actually reached.
%
%   Verified by halving the step: see step3_report.m.
%
% PHYSICS
%   cylinder   single zone, V(theta) slider-crank, Vc = 14.52 cc
%   crankcase  second zone, V = Vcc_min + Ap*(S-x), adiabatic
%   reed       pressure-driven check valve, compressible orifice + cracking dp
%   transfers  A_tr(theta) table * Cd_tr, with scavenge efficiency applied as
%              an explicit short-circuit fraction (1-eta) - the area table does
%              NOT do the scavenging
%   exhaust    A_ex(theta) * Cd_ex into the pipe's first cell
%   pipe       quasi-1D Euler, 4 segments (header, diffuser taper, belly,
%              baffle taper), stinger as the outlet orifice
%   combustion Wiebe, ignition 19.5 deg BTDC, eta_comb from P.cal
%   heat       Woschni, mean piston speed + combustion term
%
% UNITS  SI everywhere: m, kg, s, Pa, K, W, Nm. Angles in degrees.
%
% See also PARAMS, PORT_GEOMETRY, CALIBRATE, SWEEP.

if nargin < 2 || isempty(N), N = P.anchor.N_pk.value; end
if nargin < 3, opts = struct(); end
opts = def(opts, 'pipe', true);
opts = def(opts, 'quiet', false);
opts = def(opts, 'max_revs', P.num.n_revs.value);
opts = def(opts, 'tol', P.num.rel_tol.value);
opts = def(opts, 'dtheta', P.num.dtheta.value);
opts = def(opts, 'Nc', 60);

% ---- constants from the parameter set --------------------------------
R    = P.comb.R_gas.value;
gam  = P.comb.gamma.value;
cp   = gam*R/(gam-1);
cv   = R/(gam-1);
Ap   = P.geo.A_p.value;
Vd   = P.geo.V_d.value;
Vc   = P.comp.Vc.value;
rr   = P.geo.r_crank.value;
ll   = P.geo.l_rod.value;
S    = P.geo.stroke.value;
Vcc  = P.cc.V.value;                    % crankcase volume at BDC (minimum)
VccT = Vcc + Vd;                        % at TDC
Twall= P.comb.T_wall.value;
Tamb = P.fuel.T_amb.value;
pamb = P.fuel.p_amb.value;
LHV  = P.comb.LHV.value;
AFR  = P.fuel.AFR.value;
etaC = P.cal.eta_comb.value;
rho_amb = P.fuel.rho_air.value;
SR_pd = P.scav.SR_pd.value;
th_ign = 360 - P.ign.adv_btdc.value;   % deg ATDC; must come from the parameter set
m_ref  = rho_amb*Vd;                     % reference mass for DR/SR

dth  = opts.dtheta;
dt   = dth/(6*N);                       % s per crank step
nst  = round(360/dth);

% port area tables on the same grid.
% port_geometry is a geometry tool and returns mm^2; the gas model is SI.
P.num.dtheta.value = dth;
G = port_geometry(P, 'nocheck');
A_ex_tab = G.A_ex(1:nst)*1e-6;          % m^2
A_tr_tab = G.A_tr(1:nst)*1e-6;          % m^2
assert(max(A_ex_tab) > 1e-6 && max(A_ex_tab) < 1e-2, ...
    'engine_model: exhaust area table is not in m^2 (got max %.3e)', max(A_ex_tab));
assert(max(A_tr_tab) > 1e-6 && max(A_tr_tab) < 1e-2, ...
    'engine_model: transfer area table is not in m^2 (got max %.3e)', max(A_tr_tab));

Cd_ex = P.port.Cd_ex.value;
Cd_tr = P.port.Cd_tr.value;

% friction: Blair 5.4.2, fmep = 105*Lst*N, linear in speed, no constant term
Tfric = P.cal.fmep_k.value*S*N*Vd/(2*pi);

% ---- pipe ------------------------------------------------------------
PP = pipe_init(P, gam, R, pamb, Tamb, opts.Nc);

% ---- initial state ---------------------------------------------------
cyl.m  = pamb*1.4*Vc/(R*800);            % clearance volume, 1.4 bar, 800 K
cyl.T  = 800;
cyl.mf = 0;
cc.m   = pamb*VccT/(R*Tamb);
cc.T   = Tamb;

phi_ign  = 1e6;                          % "burn finished"
mf_ign   = 0;
mf_ign_last = 0;
th_prev  = -dth;
th_ign   = 360 - adv_at(P.ign.adv_curve.value, N);   % deg ATDC, curve interpolated
SR_run   = 0;                            % running scavenge ratio within the event
kappa    = 1;                            % dSE/dSR; only used when transfer flow > 0
m_trap   = 1e-5;                         % initialised so the first cycle is well defined
p_ec     = 1.2e5; V_ec = Vc + Ap*0.027; T_ec = 500;   % ref state for Woschni
Sp       = 2*S*N/60;

if ~opts.quiet
    fprintf('  engine_model: N=%d rpm, dtheta=%.2f deg, dt=%.3e s, %d pipe cells, CFL limit %.2f\n', ...
        N, dth, dt, opts.Nc, (617*dt/min(PP.xi)));
end

kEC = round(272.83/dth) + 1;
m_prev = NaN;
cflmax = 0;
conv = false;

% per-cycle accumulators
for cyc = 1:opts.max_revs
    acc.reed = 0; acc.sting = 0; acc.ex = 0; acc.tr = 0; acc.work = 0;
    acc.Qin = 0; acc.Qwall = 0; acc.Hex = 0; acc.Hin = 0;
    SR_run = 0;                          % scavenge ratio restarts each cycle
    m0 = cyl.m + cc.m + sum(PP.m) + sum(PP.sm);
    hist_p = zeros(nst,1); hist_T = zeros(nst,1); hist_pcc = zeros(nst,1);
    hist_m = zeros(nst,1); hist_tr = zeros(nst,1); hist_ex = zeros(nst,1);

    for k = 1:nst
        th = (k-1)*dth;
        x  = piston_x(rr, ll, th);
        V  = Vc + Ap*x;
        dxdt = dxdtheta(rr, ll, th)*(6*N)*pi/180;  % m/rad * rad/s
        dVdt = Ap*dxdt;

        Vcc_now = Vcc + Ap*(S - x);
        dVcc    = -Ap*dxdt;

        % --- states
        mc = cyl.m;  Tc = cyl.T;
        mcc = cc.m;  Tcc = cc.T;
        pc  = mc*R*Tc/V;
        pcc = mcc*R*Tcc/Vcc_now;

        % --- pipe boundary state
        if opts.pipe
            [p_pipe, T_pipe] = pipe_first(PP, gam, R);
        else
            p_pipe = pamb; T_pipe = Tamb;
        end

        % --- reed valve (check valve with cracking pressure)
        dp = pamb - pcc;
        if dp > P.inlet.reed_dp.value
            mdot_reed = orif(P.inlet.reed_As.value, pamb, Tamb, pcc, Tcc, ...
                             P.inlet.reed_Cd.value, R, gam);
        else
            mdot_reed = 0;
        end

        % --- transfer port
        mdot_tr = orif(A_tr_tab(k)*Cd_tr, pcc, Tcc, pc, Tc, 1.0, R, gam);

        % --- exhaust port
        if opts.pipe
            mdot_ex = orif(A_ex_tab(k)*Cd_ex, pc, Tc, p_pipe, T_pipe, 1.0, R, gam);
        else
            mdot_ex = orif(A_ex_tab(k)*Cd_ex, pc, Tc, pamb, Tamb, 1.0, R, gam);
        end

        % --- combustion
        if th_prev < th_ign && th >= th_ign   % ignition from the parameter set
            phi_ign = 0;
            mf_ign  = cyl.mf;
            mf_ign_last = cyl.mf;
        end
        th_prev = th;
        if phi_ign < 1e5, phi_ign = phi_ign + dth; end
        [xb, dxb] = wiebe(phi_ign, P.comb.wiebe_a.value, P.comb.wiebe_m.value, P.comb.burn_dur.value);
        Qcomb = etaC*(mf_ign/(1+AFR))*LHV*dxb*(6*N);

        % --- wall heat transfer
        Aw = 2*Ap + pi*P.geo.bore.value*x;
        p_mot = p_ec*(V_ec/V)^gam;
        w = 2.28*Sp + 3.24e-3*(Vd*T_ec/(p_ec*V_ec))*max(pc - p_mot, 0);
        Qwall = -woschni(P.geo.bore.value, pc, Tc, w)*Aw*(Tc - Twall);

        % --- cylinder mass and energy
        tr_in  = max(mdot_tr,0);
        tr_out = max(-mdot_tr,0);
        ex_in  = max(-mdot_ex,0);
        ex_out = max(mdot_ex,0);
        % Blair scavenging state, integrated within the cycle. The retention
        % applied to the incoming charge at any instant is dSE/dSR at the
        % running scavenge ratio, so integral(kappa dSR) = SE(DR) exactly.
        % No cycle-to-cycle lag, hence no fixed-point iteration to fold.
        if tr_in > 0
            kappa  = dSEdSR(SR_run, SR_pd);
            SR_run = SR_run + tr_in*dt/m_ref;
        end
        ret    = kappa*tr_in;
        shrt   = (1-kappa)*tr_in;

        dm_c = ret - tr_out + ex_in - ex_out;
        % The short-circuit fraction never mixes: it traverses the cylinder at
        % T_cc and leaves through the exhaust port into the pipe (added there).
        % So it does not appear in the cylinder's energy balance at all.
        h_in = ret*cp*Tcc + ex_in*cp*T_pipe;
        h_out= tr_out*cp*Tc + ex_out*cp*Tc;
        dT_c = (Qcomb + Qwall - pc*dVdt + h_in - h_out - cv*Tc*dm_c)/(mc*cv);

        % fresh-mass bookkeeping: Blair - no mixing penalty, the short-circuit
        % is already removed at the port and is defined as delivered - trapped.
        dmf = ret - mf_ign*dxb*(6*N);

        % --- crankcase
        dm_cc = mdot_reed - mdot_tr;
        h_in_cc  = max(mdot_reed,0)*cp*Tamb + max(-mdot_tr,0)*cp*Tc;
        h_out_cc = max(mdot_tr,0)*cp*Tcc + max(-mdot_reed,0)*cp*Tcc;
        dT_cc = (-pcc*dVcc + h_in_cc - h_out_cc - cv*Tcc*dm_cc)/(mcc*cv);

        % --- pipe
        mdot_pipe = mdot_ex + shrt;          % short-circuit goes out the port too
        if mdot_pipe > 1e-12 && mdot_ex > 0
            T_pipe_in = (mdot_ex*Tc + shrt*Tcc)/mdot_pipe;
        else
            T_pipe_in = Tc;
        end
        if opts.pipe
            [PP, cfl] = pipe_step(PP, dt, gam, R, mdot_pipe, T_pipe_in, pamb, Tamb, ...
                                  P.exh.Cf.value, P.exh.T_wall.value, P.exh.Pr.value);
            cflmax = max(cflmax, cfl);
            mdot_sting = PP.mdot_out;
        else
            mdot_sting = mdot_pipe;
        end

        % --- integrate (explicit Euler)
        cyl.m  = max(mc  + dm_c*dt,  1e-12);
        cyl.T  = max(Tc  + dT_c*dt,  150);
        cyl.mf = max(min(cyl.mf + dmf*dt, cyl.m), 0);
        cc.m   = max(mcc + dm_cc*dt, 1e-12);
        cc.T   = max(Tcc + dT_cc*dt, 150);

        % --- accumulate
        acc.work = acc.work + pc*dVdt*dt;      % indicated work = integral p dV
        acc.reed = acc.reed + mdot_reed*dt;
        acc.tr   = acc.tr   + mdot_tr*dt;
        acc.ex   = acc.ex   + ex_out*dt;
        acc.sting= acc.sting+ mdot_sting*dt;
        % energy accounting (diagnostic only)
        acc.Qin   = acc.Qin   + Qcomb*dt;
        acc.Qwall = acc.Qwall - Qwall*dt;                    % positive heat loss
        acc.Hex   = acc.Hex   + (ex_out*cp*Tc + shrt*cp*Tcc + tr_out*cp*Tc)*dt;
        acc.Hin   = acc.Hin   + (ex_in*cp*T_pipe + (ret+shrt)*cp*Tcc)*dt;

        hist_p(k) = pc; hist_T(k) = Tc; hist_pcc(k) = pcc;
        hist_m(k) = mc; hist_tr(k) = mdot_tr; hist_ex(k) = mdot_ex;

        % Woschni reference at exhaust close
        if k == kEC
            p_ec = pc; V_ec = V; T_ec = Tc;
            m_trap = cyl.m; T_trap = Tc;
        end
    end

    m1 = cyl.m + cc.m + sum(PP.m) + sum(PP.sm);

    % Blair scavenging law (REFERENCES_EXTRACT 6). DR from the cycle just
    % completed sets TE for the NEXT cycle - lagged by one cycle, which is
    % exact at convergence and avoids a fixed-point solve inside the step.
    m_air_c = acc.reed*AFR/(1+AFR);
    SR_c = m_air_c/(rho_amb*Vd);
    if SR_c <= 1e-9
        SE_c = 0;
    elseif SR_c <= SR_pd
        SE_c = SR_c;                                   % perfect displacement
    else
        SE_c = 1 - (1-SR_pd)*exp(-(SR_c-SR_pd)/(1-SR_pd));   % mixing blend
    end
    TE_c = SE_c/max(SR_c,1e-9);
    DR_last = SR_c; SE_last = SE_c; TE_last = TE_c;

    if k == nst
        rel = abs(m_trap - m_prev)/max(m_trap,1e-12);
    end
    if ~isnan(m_prev) && rel < opts.tol
        conv = true; cycles = cyc; break
    end
    m_prev = m_trap;
    if ~opts.quiet && mod(cyc,5)==0
        fprintf('    cycle %2d: trapped %.6e kg, change %.2e, P_i %.1f W\n', ...
            cyc, m_trap, rel, acc.work*N/60);
    end
end
if exist('cycles','var')~=1, cycles = opts.max_revs; end

% ---- results ---------------------------------------------------------
Wi = acc.work;                       % J per cycle
Pi = Wi*N/60;                        % W
Tfn = Tfric;                         % Nm at this speed
Pb = Pi - 2*pi*Tfn*N/60;
Tb = Pb/(2*pi*N/60);

m_air = acc.reed*AFR/(1+AFR);
DR = m_air/(rho_amb*Vd);

M.N        = N;
M.pipe     = opts.pipe;
M.cycles   = cycles;
M.converged= conv;
M.m_trapped= m_trap;
M.m_prev   = m_prev;
M.rel_change = rel;
M.W_i      = Wi;
M.P_i      = Pi;
M.P_b      = Pb;
M.T_b      = Tb;
M.BMEP     = Pb/(Vd*N/60);
M.IMEP     = Wi/Vd;
M.T_fric   = Tfn;
M.DR       = DR;
M.SE       = SE_last;                 % trapped fresh / trapped mass (Blair)
M.TE       = TE_last;                 % trapped fresh / delivered fresh
M.m_air    = m_air;
M.m_fresh_ign = mf_ign_last;                 % trapped fresh charge at ignition
M.m_fuel_ign  = mf_ign_last/(1+AFR);
M.m_fuel_cycle= acc.reed/(1+AFR);            % fuel delivered per cycle
M.Q_in     = M.m_fuel_ign*LHV;
M.eta_i    = Wi/max(M.Q_in,1e-12);
M.BSFC     = M.m_fuel_cycle*N/60*3600*1e3/max(Pb/1000,1e-9);   % g/h per kW
M.eta_scav_eff = mf_ign_last/max(acc.reed,1e-12);   % trapped fresh / delivered fresh
M.m_reed   = acc.reed;
M.m_sting  = acc.sting;
M.m_ex     = acc.ex;
M.m_tr     = acc.tr;
M.mass_bal = (acc.reed - acc.sting - (m1-m0))/max(acc.reed,1e-12);
M.acc_reed = acc.reed;  M.acc_sting = acc.sting;
M.pipe_m0 = m0 - cyl.m - cc.m;   % not exact after the loop; kept for diagnosis only
M.pipe_m1 = sum(PP.m);
M.pipe_p  = pipe_pressures(PP, gam, R);
[~, Tt] = pipe_pressures(PP, gam, R);
M.pipe_T_mean = sum(PP.m.*Tt)/max(sum(PP.m),1e-12);
M.cfl_max  = cflmax;
M.Q_in_cycle = acc.Qin;
M.Q_wall   = acc.Qwall;
M.H_ex     = acc.Hex;
M.H_in     = acc.Hin;
M.energy_residual = (acc.Qin + acc.Hin - Wi - acc.Qwall - acc.Hex)/max(acc.Qin,1e-9);
M.theta    = ((0:nst-1)')*dth;
M.p_cyl    = hist_p;
M.T_cyl    = hist_T;
M.p_cc     = hist_pcc;
M.m_cyl    = hist_m;
M.mdot_tr  = hist_tr;
M.mdot_ex  = hist_ex;
M.dt       = dt;
M.p_ec     = p_ec; M.T_ec = T_ec;

if nargin < 3 || ~isfield(opts,'quiet') || ~opts.quiet
    fprintf('  converged in %d cycles (tol %.1e, final change %.2e)\n', cycles, opts.tol, rel);
    fprintf('  mass balance residual %.3e of intake\n', M.mass_bal);
end
end


% =====================================================================
% helpers
% =====================================================================
function s = def(s, f, v)
if ~isfield(s, f), s.(f) = v; end
end

function x = piston_x(r, l, th)
t = th*pi/180;
x = r*(1-cos(t)) + l*(1 - sqrt(1-(r/l)^2*sin(t)^2));
end

function d = dxdtheta(r, l, th)
t = th*pi/180;
s2 = (r/l)^2*sin(t)^2;
d = r*sin(t) + (r^2*sin(t)*cos(t))/(l*sqrt(max(1-s2,1e-12)));
end

function mdot = orif(A, p1, T1, p2, T2, Cd, R, gam)
% compressible nozzle, signed: positive = 1 -> 2
mdot = 0;
if A <= 0 || p1 <= 0 || p2 <= 0, return; end
if p1 >= p2
    pu = p1; Tu = T1; pd = p2; sgn = 1;
else
    pu = p2; Tu = T2; pd = p1; sgn = -1;
end
rg = pd/pu;
if rg >= 1, return; end
rcrit = (2/(gam+1))^(gam/(gam-1));
if rg > rcrit
    phi = sqrt(2*gam/(gam-1)*(rg^(2/gam) - rg^((gam+1)/gam)));
else
    phi = sqrt(gam*(2/(gam+1))^((gam+1)/(gam-1)));
end
mdot = sgn*Cd*A*pu/sqrt(R*Tu)*phi;
end

function s = dSEdSR(SR, SR_pd)
% dSE/dSR of the Benson-Brandham blend, evaluated at the running SR.
% Displacement region has slope 1; mixing region slope exp(-(SR-SR_pd)/(1-SR_pd)).
% Integrating this over the scavenge event returns SE(DR) exactly, which is
% what makes it a legitimate crank-angle state rather than a loss factor.
if SR <= SR_pd
    s = 1;
else
    s = exp(-(SR-SR_pd)/(1-SR_pd));
end
s = min(max(s,0),1);
end

function SE = SE_of_SR(SR, SR_pd)
if SR <= 0
    SE = 0;
elseif SR <= SR_pd
    SE = SR;
else
    SE = 1 - (1-SR_pd)*exp(-(SR-SR_pd)/(1-SR_pd));
end
end

function a = adv_at(curve, N)
% ignition advance from the CDI curve, held constant outside its ends
a = interp1(curve(:,1), curve(:,2), N, 'linear', 'extrap');
a = min(max(a, curve(end,2)), curve(1,2));
end

function [xb, dxb] = wiebe(phi, a, m, dur)
if phi <= 0, xb = 0; dxb = 0; return; end
z = phi/dur;
if z >= 1, xb = 1; dxb = 0; return; end
e = exp(-a*z^(m+1));
xb = 1-e;
dxb = a*(m+1)/dur * z^m * e;
end

function h = woschni(B, p, T, w)
% Woschni 1967; p in Pa, T in K, B in m, w in m/s -> W/m2/K
pk = max(p,1)/1000;
h = 3.26*B^(-0.2)*pk^0.8*T^(-0.55)*max(w,1)^0.8;
end

function [pp, TT] = pipe_pressures(PP, gam, R)
pp = max((gam-1)*PP.E./PP.vol, 500);
rho = PP.m./PP.vol;
TT = pp./(rho*R);
end

function [p, T] = pipe_first(PP, gam, R)
rho = PP.m(1)/PP.vol(1);
p   = max((gam-1)*PP.E(1)/PP.vol(1), 500);
T   = p/(rho*R);
end

function PP = pipe_init(P, gam, R, pamb, Tamb, Nc)
% Two exhaust models.
%  'absorptive' (default) - the MEASURED 4-speed stock silencer: a 35 mm core
%      from the port to the outlet, with the five baffle chambers attached as
%      side-branch volumes through the perforation area. There is no wave field
%      in the chambers, and the core is constant-area, so the model is
%      well-posed and single-valued.
%  'blair' - the tuned wave pipe, kept only for the comparison run.
if strcmpi(P.exh.model.value, 'blair')
    [vol, A, d, Af, Lf, xi] = geom_blair(P, Nc);
    PP.sV = []; PP.sLink = []; PP.sA = []; PP.sm = []; PP.sE = [];
    A_sting = P.exh.A_t.value;
else
    [vol, A, d, Af, Lf, xi, sV, sLink, sA] = geom_absorptive(P, Nc);
    PP.sV = sV; PP.sLink = sLink; PP.sA = sA;
    PP.sm = pamb*sV/(R*Tamb);
    PP.sE = pamb/(gam-1)*sV;
    A_sting = P.exh.A_out.value;
end
Nc = numel(vol);
PP.Nc  = Nc;
PP.vol = vol(:); PP.A = A(:); PP.d = d(:);
PP.Af  = Af(:);  PP.Lf = Lf(:); PP.xi = xi(:);
PP.A_sting = A_sting;
PP.Cd_sting = 0.85;
PP.Cd_perf  = P.exh.Cd_perf.value;
PP.m   = pamb*PP.vol/(R*Tamb);
PP.E   = pamb/(gam-1)*PP.vol;
PP.mdot = zeros(Nc+1,1);
PP.mdot_out = 0;
end

function [vol, A, d, Af, Lf, xi, sV, sLink, sA] = geom_absorptive(P, Nc)
dc = P.exh.core_d.value;
L  = P.exh.core_L.value;
A0 = pi/4*dc^2;
dx = L/Nc;
vol = A0*dx*ones(Nc,1);
A   = A0*ones(Nc,1);
d   = dc*ones(Nc,1);
xi  = dx*ones(Nc,1);
Af  = A0*ones(Nc+1,1);
Af(Nc+1) = P.exh.A_out.value;
Lf  = dx*ones(Nc+1,1);

% side-branch chambers: volume, axial link, perforation coupling area
sV  = P.exh.cham_V.value(:);
Lc  = P.exh.cham_L.value(:);
x0  = P.exh.cham_x0.value;
xs  = x0 + cumsum(Lc) - 0.5*Lc;
sLink = min(max(round(xs/dx), 1), Nc);
sA  = P.exh.perf_frac.value * pi*dc*Lc;
end

function [vol, A, d, Af, Lf, xi] = geom_blair(P, Nc)
LT = P.exh.LT.value;
sf = P.exh.seg_frac.value;
d1 = P.exh.d_header.value; d2 = P.exh.d_diff1.value;
d3 = P.exh.d_diff2.value;  d4 = P.exh.d_belly.value;
d7 = P.exh.d_stinger.value;
L = [LT*sf, LT*sf(6)];
dx = sum(L)/Nc;
xc = ((1:Nc)'-0.5)*dx;
e1 = L(1); e2 = e1+L(2); e3 = e2+L(3); e4 = e3+L(4); e5 = e4+L(5); e6 = e5+L(6);
A = zeros(Nc,1);
for i = 1:Nc
    x = xc(i);
    if x <= e1,      dd = d1;
    elseif x <= e2,  dd = d1 + (x-e1)/(e2-e1)*(d2-d1);
    elseif x <= e3,  dd = d2 + (x-e2)/(e3-e2)*(d3-d2);
    elseif x <= e4,  dd = d3 + (x-e3)/(e4-e3)*(d4-d3);
    elseif x <= e5,  dd = d4;
    elseif x <= e6,  dd = d4 + (x-e5)/(e6-e5)*(d7-d4);
    else,            dd = d7;
    end
    A(i) = pi/4*dd^2;
end
vol = A*dx;
d   = sqrt(4*A/pi);
xi  = dx*ones(Nc,1);
Af  = zeros(Nc+1,1); Lf = dx*ones(Nc+1,1);
Af(1) = A(1); Af(Nc+1) = A(Nc);
Af(2:Nc) = 0.5*(A(1:Nc-1)+A(2:Nc));
end

function [PP, cfl] = pipe_step(PP, dt, gam, R, mdot_in, T_cyl, pamb, Tamb, Cf, Tw, Pr)
% One explicit step of the lumped acoustic ladder, WITH wall losses.
%   wall friction : dmdot/dt -= (4Cf/(2 dh)) |mdot| mdot /(rho A)   [Blair 2.3]
%   wall heat     : Nu = Cf*Re/2, Ch = Ck*Nu/d, dQ = pi*d*Ch*dx*(Tw-Ts)*dt
%                                                                  [Blair 2.4]
% Blair computes heat transfer ~12x larger than friction for the same element,
% so omitting it (as the first version did) leaves the pulse undamped.
Nc = PP.Nc;
m = PP.m; E = PP.E; md = PP.mdot; A = PP.A; vol = PP.vol;
dcell = PP.d; Af = PP.Af; Lf = PP.Lf; xi = PP.xi;
cp = gam*R/(gam-1);
fD = 4*Cf;                      % Darcy from skin friction

rho = max(m./vol, 1e-9);
p   = max((gam-1)*E./vol, 500);
T   = p./(rho*R);
c   = sqrt(gam*p./rho);

% ---- interior faces: momentum with inertia and Darcy friction
k  = 2:Nc;
rhof = 0.5*(rho(k-1)+rho(k));
dhf  = sqrt(4*Af(k)/pi);
md_new = md;
md_new(k) = md(k) + dt*( Af(k)./Lf(k).*(p(k-1)-p(k)) ...
    - (fD./(2*dhf)).*abs(md(k)).*md(k)./(rhof.*Af(k)) );

% ---- boundary faces (algebraic)
md_new(1) = mdot_in;
TL = T(end);
md_new(Nc+1) = orif(PP.A_sting, p(end), TL, pamb, Tamb, PP.Cd_sting, R, gam);

% ---- mass
dm = (md_new(1:Nc) - md_new(2:Nc+1))*dt;
m  = max(m + dm, 1e-12);

% ---- energy, upwind face enthalpies
h = zeros(Nc+1,1);
if md_new(1) >= 0, h(1) = cp*T_cyl;     else, h(1) = cp*T(1);   end
for j = 2:Nc
    if md_new(j) >= 0, h(j) = cp*T(j-1); else, h(j) = cp*T(j); end
end
if md_new(Nc+1) >= 0, h(Nc+1) = cp*T(Nc); else, h(Nc+1) = cp*Tamb; end
dE = (md_new(1:Nc).*h(1:Nc) - md_new(2:Nc+1).*h(2:Nc+1))*dt;
E  = max(E + dE, 1e-9);

% ---- wall heat transfer (Blair 2.4)
uc   = 0.5*(md_new(1:Nc) + md_new(2:Nc+1))./(rho.*A);   % cell gas velocity
mu   = 1.716e-5*(T/273.15).^0.7;                        % Sutherland, simplified
Re   = rho.*abs(uc).*dcell./mu;
Nu   = Cf*Re/2;                                          % Blair's relation
Ck   = mu*cp/Pr;                                         % conductivity
Ch   = Ck.*Nu./dcell;                                    % W/m2/K
dQ   = pi*dcell.*Ch.*xi.*(Tw - T)*dt;
E    = max(E + dQ, 1e-9);

PP.m = m; PP.E = E; PP.mdot = md_new; PP.mdot_out = md_new(Nc+1);

% ---- side-branch chambers (absorptive silencer) ----------------------
% Each chamber exchanges mass with the core cell it is attached to, through
% the perforation area. No wave field inside the chamber.
if ~isempty(PP.sV)
    Cd_p = PP.Cd_perf;
    for i = 1:numel(PP.sV)
        li = PP.sLink(i);
        rho_c = m(li)/vol(li);
        p_c   = (gam-1)*E(li)/vol(li);
        T_c   = p_c/(rho_c*R);
        rho_s = PP.sm(i)/PP.sV(i);
        p_s   = (gam-1)*PP.sE(i)/PP.sV(i);
        T_s   = p_s/(rho_s*R);
        ms = orif(PP.sA(i), p_c, T_c, p_s, T_s, Cd_p, R, gam);
        dm_s = ms*dt;
        if dm_s >= 0                      % core -> chamber
            h_s = cp*T_c;
            m(li) = max(m(li) - dm_s, 1e-12);
            E(li) = max(E(li) - ms*cp*T_c*dt, 1e-9);
        else                              % chamber -> core
            h_s = cp*T_s;
            m(li) = m(li) + (-dm_s);
            E(li) = E(li) + (-ms)*cp*T_s*dt;
        end
        PP.sm(i) = max(PP.sm(i) + dm_s, 1e-12);
        PP.sE(i) = max(PP.sE(i) + ms*h_s*dt, 1e-9);
    end
end

PP.m = m; PP.E = E;
u = md_new(1:Nc)./(rho.*A);
cfl = max((abs(u)+c).*dt./xi);
end

