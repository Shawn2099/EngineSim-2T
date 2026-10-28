%DECISIONS  Resolves the two step-1 flags with numbers.
%   D1 calibration conditioning: what a single anchor can and cannot identify.
%   D2 friction representation: how much a constant-torque law biases shape.
%
% The reduced form used for D1 is a device for exposing the conditioning of the
% fit, NOT the deliverable solver. Its one structural claim - that eta_comb and
% eta_scav are perfectly collinear - is model-independent: both enter as a
% product, so their Jacobian columns are proportional at every speed.

P = params('quiet');
Vd  = P.geo.V_d.value;
rho = P.fuel.rho_air.value;
fprintf('===== D1  CALIBRATION CONDITIONING =====\n\n');

% ---- reduced form ----------------------------------------------------
k0  = [P.cal.eta_comb.value; P.cal.eta_scav.value; P.cal.a_wave.value; P.cal.T_fric.value];
lbl = {'eta_comb','eta_scav','a_wave','T_fric'};
unit= {'-','-','m/s','Nm'};
band = 1200;                                    % ASSUMED delivery bandwidth, rpm
Nt   = @(a) a*P.derived.exh_dur.value/(12*P.exh.L_acoustic.value);
% gain normalised so the priors reproduce the anchor exactly
Gref = (P.anchor.P_pk.value + 2*pi*(P.anchor.N_pk.value/60)*k0(4)) / ...
       (k0(1)*k0(2)*Vd*(P.anchor.N_pk.value/60));
Pb = @(N,k) k(1)*k(2)*Gref*exp(-((N-Nt(k(3))).^2)/(2*band^2))*Vd*(N/60) ...
            - 2*pi*(N/60)*k(4);
fprintf('reduced form: P_b = eta_comb*eta_scav*GMEP(N;a_wave)*Vd*N - 2*pi*N*T_fric\n');
fprintf('  GMEP at the tune point %.3f bar, bandwidth %.0f rpm (assumed)\n', Gref/1e5, band);
fprintf('  check: P_b(7500, priors) = %.4f W  (anchor %.0f W)\n\n', Pb(7500,k0), P.anchor.P_pk.value);

% ---- 1. sensitivity of the anchor to each knob ----------------------
fprintf('  anchor power sensitivity (central differences, 1%% step)\n');
fprintf('  %-10s %14s %16s %14s\n', 'knob', 'dP/dk', 'dP for 1%% change', 'change in P');
for i = 1:4
    dk = 1e-2*abs(k0(i));
    kp = k0; km = k0; kp(i) = kp(i)+dk; km(i) = km(i)-dk;
    J(i) = (Pb(7500,kp) - Pb(7500,km))/(2*dk);
    fprintf('  %-10s %14.3e %16.3f %13.3f W\n', lbl{i}, J(i), J(i)*dk, J(i)*dk);
end
fprintf('\n');

% ---- 2. exact collinearity of eta_comb and eta_scav -----------------
% cosine between the two columns = (J1*J2)/(|J1||J2|)
cos12 = (J(1)*J(2))/(abs(J(1))*abs(J(2)));
fprintf('  cos(angle) between the eta_comb and eta_scav columns = %.15f\n', cos12);
fprintf('  -> they are the SAME direction: only their product can ever be fitted.\n');
fprintf('     scaling eta_comb by s and eta_scav by 1/s leaves every prediction untouched:\n');
kA = k0;  kB = k0;  kB(1) = k0(1)*1.2;  kB(2) = k0(2)/1.2;
fprintf('     %.3f*%.3f  vs  %.3f*%.3f   -> P_b = %.9f vs %.9f W\n', ...
    kA(1),kA(2),kB(1),kB(2), Pb(7500,kA), Pb(7500,kB));
fprintf('     parameters differ by 20%%, predictions by %.2e W\n\n', abs(Pb(7500,kA)-Pb(7500,kB)));

% ---- 3. rank as anchors are added -----------------------------------
spd = {[7500], [7500 7000], [7500 7000 5000], [7500 7000 5000 9000]};
fprintf('  what extra anchors buy (finite-difference Jacobian rows)\n');
fprintf('  %-6s %8s %10s %10s %10s %10s %6s\n','n','rank','s1','s2','s3','s4','null');
for n = 1:numel(spd)
    Ns = spd{n};  A = zeros(numel(Ns),4);
    for r = 1:numel(Ns)
        for i = 1:4
            dk = 1e-2*abs(k0(i));
            kp = k0; km = k0; kp(i) = kp(i)+dk; km(i) = km(i)-dk;
            A(r,i) = (Pb(Ns(r),kp) - Pb(Ns(r),km))/(2*dk);
        end
    end
    s = svd(A);
    s = [s; zeros(4-numel(s),1)];
    rk = sum(s > 1e-6*max(s));
    fprintf('  %-6d %8d %10.3e %10.3e %10.3e %10.3e %6d\n', n, rk, s(1), s(2), s(3), s(4), 4-rk);
    if n == 3
        fprintf('         weakest direction is %.3f%% of the strongest -> effectively unidentifiable\n', ...
            100*s(3)/s(1));
    end
end
fprintf('  rank never reaches 4: the eta_comb/eta_scav direction is unidentifiable\n');
fprintf('  at ANY number of operating points. Four speeds, three identifiable.\n\n');

% ---- 4. stability of the two schemes under a 1% anchor error ---------
fprintf('  response to a +1%% anchor error (104 W)\n');
dy = 0.01*P.anchor.P_pk.value;
% (a) pinned scheme: fit eta_scav only, other three held
dEta_free = dy/J(2);
fprintf('   pinned scheme (eta_comb, a_wave, T_fric held): d(eta_scav) = %+.5f (%.3f%%)\n', ...
    dEta_free, 100*dEta_free/k0(2));
% (b) all four free, minimum-norm solution
dmin = J'*(dy/(J*J'));                       % min-norm parameter change
fprintf('   all four free, min-norm: dk = [%s]\n', num2str(dmin','%+.5f  '));
fprintf('     that puts the whole error into whichever knob has the largest column -\n');
fprintf('     an artefact of scaling, not physics.\n');
% (c) regularised: Tikhonov toward priors, 1% prior sigma
% scale by the prior sigmas first, or the condition number just measures the
% fact that m/s and Nm are different units
sig = 0.01*abs(k0(:));
Js  = (J(:).*sig)';                 % 1x4, non-dimensional (unit-safe)
Lam = diag(1./sig.^2);
dreg = (J'*J + Lam)\(J'*dy);
dreg_s = dreg./sig;                 % in prior-sigma units
fprintf('   regularised to 1%% priors: dk = [%s]\n', num2str(dreg','%+.5f  '));
fprintf('     largest move = %.2f sigma (%.2f%% of prior)\n', ...
    max(abs(dreg_s)), 100*max(abs(dreg)./k0));
fprintf('\n  CONDITION (non-dimensionalised by the prior sigmas)\n');
fprintf('    J''J     : rank 1 of 4 at one anchor -> infinite condition, 3 null directions\n');
fprintf('    J''J + I : %.3g. Finite, but the spread only says the data outweighs the\n', cond(Js'*Js + eye(4)));
fprintf('              prior along the one observable direction. It is not instability.\n');
fprintf('    The operational number is the one above: 1%% anchor error -> 0.91%% in eta_scav.\n\n');

% =====================================================================
fprintf('===== D2  FRICTION REPRESENTATION =====\n\n');
Tref = P.cal.T_fric.value;
phi  = @(n) P.cal.fric_a.value + P.cal.fric_b.value*n/1000;
N = (2000:1000:9000)';
Tconst = Tref*ones(size(N));
Tshape = Tref*phi(N)/phi(7500);
Tprop  = Tref*N/7500;
Tpk    = P.anchor.T_pk.value;

fprintf('  three laws, all matched to T_f = %.2f Nm at 7500\n', Tref);
fprintf('  %6s %10s %10s %10s %12s %12s\n','rpm','constant','shaped','proportional','const-shape','const-prop');
for i = 1:numel(N)
    fprintf('  %6d %10.3f %10.3f %10.3f %12.3f %12.3f\n', N(i), Tconst(i), Tshape(i), Tprop(i), ...
        Tconst(i)-Tshape(i), Tconst(i)-Tprop(i));
end
fprintf('\n  at the 3000 rpm end: constant overstates friction by %.3f Nm = %.2f%% of peak torque\n', ...
    Tconst(2)-Tshape(2), 100*(Tconst(2)-Tshape(2))/Tpk);
fprintf('  at the 5000 rpm end: %.3f Nm = %.2f%%\n', Tconst(4)-Tshape(4), 100*(Tconst(4)-Tshape(4))/Tpk);

% peak shift: dT_b/dN = 0 with an indicated curve of curvature c
c = 1.0/1000^2;                                  % 1 Nm drop per 1000 rpm, assumed
dfun = @(n) Tref*phi(n)/phi(7500);
h = 1; dTf = @(f,n) (f(n+h)-f(n-h))/(2*h);
shift_shape = -dTf(dfun,7500)/(2*c);
shift_const = 0;
shift_prop  = -(Tref/7500)/(2*c);
fprintf('\n  indicated-curve peak shift for a 1 Nm/1000rpm curvature:\n');
fprintf('    constant %+.1f rpm | shaped %+.1f rpm | proportional %+.1f rpm\n', ...
    shift_const, shift_shape, shift_prop);
fprintf('    i.e. at most %.2f%% of the peak speed; on the road (5th, ~95 km/h at 7500) < 1 km/h\n\n', ...
    100*abs(shift_prop)/7500);

fprintf('  anchor inconsistency for scale: 10.4 kW at 7500 needs 13.24 Nm, catalogue says 12.26\n');
fprintf('    gap %.2f Nm. The friction-law bias (%.2f Nm) is %.0f%% of that gap.\n\n', ...
    P.anchor.P_pk.value/(2*pi*125) - Tpk, Tconst(2)-Tshape(2), ...
    100*(Tconst(2)-Tshape(2))/(P.anchor.P_pk.value/(2*pi*125) - Tpk));

fprintf('  DECISION: use the shaped law T_f(N) = T_fric * phi(N)/phi(7500), one fitted level.\n');
fprintf('  It costs no extra fitted parameter, removes a %.1f%% low-speed bias, and moves the\n', ...
    100*(Tconst(2)-Tshape(2))/Tpk);
fprintf('  predicted peak by %.0f rpm. A constant law would bias every low-speed sweep row.\n', abs(shift_shape));
