% engine_model_5s.m
% Simplified 0D analytic surrogate for Yamaha RX135 5-speed two-stroke.
% NOT a full thermodynamic model - used for sensitivity screening only.
% Inputs: P (struct from params_rx135_5s) + overrides via name-value.
% Returns metrics struct M.

function M = engine_model_5s(P, varargin)
% Apply overrides
for i = 1:2:numel(varargin)
    P.(varargin{i}) = varargin{i+1};
end

bore = P.bore_mm/1000; stroke = P.stroke_mm/1000;
Vd = pi/4*bore^2*stroke;          % displaced volume (m^3)
CR = P.compression_ratio;
if isnan(CR)
    CR = 9.5;                       % placeholder estimated (4-speed CR NOT FOUND)
    warning('compression_ratio NaN -> using estimated 9.5');
end
Vc = Vd/(CR-1);                    % clearance volume (m^3)
Vsquish = (P.squish_vol_cc/1e6);   % m^3 if provided
if ~isnan(Vsquish)
    Vc = Vsquish + (Vc - Vsquish);  % keep total; squish changes shape only here
end

% Port timing -> trapped charge fraction (very simplified)
% Later exhaust open -> better trapping; transfer timing affects scavenging.
eo = P.exhaust_open_deg; to = P.transfer_open_deg;
trap_frac = 0.55 + 0.002*(200 - eo) + 0.001*(130 - to);  % heuristic
trap_frac = min(max(trap_frac,0.45),0.75);

% Air mass per cycle (approx, at 7500 rpm)
rho_air = 1.2;                     % kg/m^3
m_air = rho_air * Vd * trap_frac;

% Fuel mass from carb main jet (empirical scaling; richer = more power up to a point)
mj = P.main_jet;
AFR = 12.5 - 0.02*(mj - 135);     % heuristic: higher jet -> richer
m_fuel = m_air / AFR;

% Lower heating value
LHV = 44e6;                        % J/kg gasoline
Qin = m_fuel * LHV;

% Indicated efficiency (two-stroke ~ 0.25-0.32)
eta_i = 0.27 + 0.005*(CR - 10.1) + 0.01*(eo - 190)/10;
% ignition timing effect (guarded)
if ~isnan(P.ignition_timing_deg)
    dt = P.ignition_timing_deg - 16;
    eta_i = eta_i + 0.004*dt - 0.0005*dt^2;
end
eta_i = min(max(eta_i,0.20),0.35);

P_ind = Qin * eta_i;               % J per cycle
N = P.power_rpm;                   % rpm
P_ind_W = P_ind * N/60;            % W (1 cycle/rev for 2-stroke single)
P_ind_kW = P_ind_W/1000;
P_ind_ps = P_ind_kW*1.3596;        % PS

% Torque
T_Nm = P_ind_W / (2*pi*N/60);

% Peak cylinder pressure (heuristic)
P_peak_bar = 35 + 2*(CR-10.1) + 0.5*(190-eo);

% Scavenging efficiency proxy
scav_eff = trap_frac * 100;

M.power_ps     = P_ind_ps;
M.torque_nm    = T_Nm;
M.scav_eff_pct = scav_eff;
M.peak_p_bar   = P_peak_bar;
M.AFR          = AFR;
M.eta_i        = eta_i;
end