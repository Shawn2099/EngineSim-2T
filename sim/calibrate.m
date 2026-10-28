function C = calibrate(P, opts)
%CALIBRATE  Fit eta_comb to the power anchor, with an explicit physical bound.
%
%   C = calibrate(P)
%
%   Decision D1 (step 3) showed only ONE combination is identifiable from one
%   anchor: eta_comb x eta_comb x (pipe gain), with a_wave and T_fric pinned by
%   geometry and prior. So eta_comb is the single fitted knob and the others
%   are held. Fitting more than one to one number is arbitrary.
%
%   BOUND: eta_comb in [0.85, 0.98]. Combustion efficiency below 0.85 is not a
%   credible number for a carburetted SI engine - it means the model is using
%   eta_comb to absorb a structural error. If the fit lands on the bound with
%   residual, this function STOPS and says so instead of returning a number.
%
%   The structural error it is designed to catch is over-trapping: p_trap above
%   ~1.6 bar, which arrives as excess power that no combustion efficiency can
%   honestly remove.

if nargin < 2, opts = struct(); end
if ~isfield(opts,'quiet'), opts.quiet = true; end
if ~isfield(opts,'max_revs'), opts.max_revs = 100; end
if ~isfield(opts,'Nc'), opts.Nc = 40; end

target = P.anchor.P_pk.value;
lo = 0.85; hi = 0.98;

run_at = @(e) local_power(P, e, opts);

eta0 = P.cal.eta_comb.value;
P1 = run_at(eta0);
fprintf('\n  CALIBRATE  target P_b = %.0f W at %d rpm\n', target, P.anchor.N_pk.value);
fprintf('  prior eta_comb %.3f -> P_b %.0f W (residual %+.1f%%)\n', eta0, P1.P_b, 100*(P1.P_b-target)/target);

% the knob is monotonic in power, so a secant on the two bounds is enough
Plo = run_at(lo);
Phi = run_at(hi);
fprintf('  eta_comb %.2f -> P_b %.0f W ; eta_comb %.2f -> P_b %.0f W\n', lo, Plo.P_b, hi, Phi.P_b);

if Plo.P_b > target
    % even at the lower bound the model is too powerful
    slope = (Phi.P_b - Plo.P_b)/(hi-lo);
    eta_req = lo + (target - Plo.P_b)/slope;
    C.status  = 'STRUCTURAL';
    C.eta_comb_fitted = NaN;
    C.eta_comb_required = eta_req;
    C.residual = Plo.P_b - target;
    C.P_b = Plo.P_b;
    C.p_trap = Plo.p_trap;
    fprintf('\n  *** FIT BLOCKED BY THE BOUND ***\n');
    fprintf('  eta_comb would have to be %.3f to reach %.0f W, below the %.2f floor.\n', eta_req, target, lo);
    fprintf('  That is not a combustion efficiency, it is a structural error.\n');
    fprintf('  Evidence: p_trap = %.2f bar at the bound (target 1.3-1.6).\n', Plo.p_trap/1e5);
    fprintf('  The excess power comes from over-trapping in the pipe, not from combustion.\n');
    fprintf('  STOPPING. Do not absorb this into eta_comb.\n\n');
    return
end

% secant/bisection within the bounds (P is convex in eta, so iterate)
ea = lo; Pa = Plo.P_b;
eb = hi; Pb_ = Phi.P_b;
eta = lo + (target - Pa)/(Pb_ - Pa)*(hi-lo);
for it = 1:5
    M = run_at(eta);
    f = M.P_b - target;
    if abs(f) < 0.002*target, break; end
    if f < 0, ea = eta; Pa = M.P_b; else, eb = eta; Pb_ = M.P_b; end
    eta = ea + (target - Pa)/(Pb_ - Pa)*(eb-ea);
end
M = run_at(eta);
C.status = 'FITTED';
C.eta_comb_fitted = eta;
C.eta_comb_required = eta;
C.residual = M.P_b - target;
C.P_b = M.P_b;
C.p_trap = M.p_trap;
fprintf('  fitted eta_comb %.4f -> P_b %.0f W (residual %+.2f%%)\n', eta, M.P_b, 100*(M.P_b-target)/target);
end

function M = local_power(P, eta, opts)
P2 = P;
P2.cal.eta_comb.value = eta;
M = engine_model(P2, P.anchor.N_pk.value, ...
    struct('max_revs',opts.max_revs,'quiet',true,'Nc',opts.Nc));
Vt = P.comp.Vc.value + P.geo.A_p.value*0.027;
M.p_trap = M.m_trapped*P.comb.R_gas.value*M.T_ec/Vt;
end
