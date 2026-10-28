% params_rx135_5s.m
% Verified parameter dataset (5-speed, Indian market) for Yamaha RX135
% Source: Yamaha_RX135_India/RX135_India_research.md
% Values tagged STOCK/MODIFIED/UNKNOWN; NOT-FOUND entries are NaN.
% Use this as the single source of truth for the sensitivity study.

function P = params_rx135_5s()
P = struct();

%% --- Engine geometry (STOCK, verified) ---
P.bore_mm          = 58;          % STOCK (T1) - verified
P.stroke_mm        = 50;          % STOCK (T1) - verified
P.displacement_cc  = 132;         % STOCK (T1) - verified (132 cc)
P.n_cyl            = 1;
P.compression_ratio= 10.1;        % STOCK (T1) xbhp #89 - verified
P.conn_rod_mm      = 98;          % STOCK? community consensus, UNVERIFIED (T3/T4). NOT FOUND in manual.
P.piston_comp_h_mm = NaN;         % NOT FOUND - measure
P.gudgeon_pin_d_mm= NaN;         % NOT FOUND - measure
P.deck_height_mm   = NaN;         % NOT FOUND - measure
P.squish_vol_cc    = NaN;         % NOT FOUND - measure (target of study)
P.head_vol_cc      = NaN;         % NOT FOUND - measure
P.crankcase_vol_cc = NaN;         % NOT FOUND - measure

%% --- Port timing (STOCK) ---
% Generic published values; variant-unverified (T3/T4). Derive from port-map PNGs.
P.exhaust_open_deg = 190;         % generic, UNVERIFIED for RX135 5s
P.transfer_open_deg= 125;         % generic, UNVERIFIED for RX135 5s
P.inlet_open_deg   = 95;          % generic (BTDC), UNVERIFIED
P.exhaust_height_mm= NaN;         % NOT FOUND - measure from port map
P.transfer_height_mm=NaN;         % NOT FOUND - measure from port map
P.inlet_height_mm  = NaN;         % NOT FOUND - measure

%% --- Carburetion (STOCK 5-speed) ---
P.carb_type        = 'VM22 oval bore';
P.main_jet         = 135;         % STOCK (T3) xbhp #89
P.pilot_jet        = 15;          % STOCK (T3) xbhp #89
P.needle           = '5FP16';     % STOCK (T3) xbhp #89
P.throttle_cutaway = '2.0';       % STOCK (T3) xbhp #89
P.float_height_mm  = NaN;         % NOT FOUND

%% --- Ignition (STOCK) ---
P.spark_plug       = 'BR8HS';     % STOCK (T1) parts cat
P.ignition_timing_deg = NaN;      % NOT FOUND - measure with timing light
P.cdi_type         = '4TL';       % STOCK (T1) parts cat

%% --- Drivetrain (STOCK 5-speed) ---
P.gear_ratios      = [3.182 2.000 1.368 1.091 0.917]; % STOCK (T1) xbhp #89
P.primary_drive    = 3.182;       % (included in 1st? verify) - see research
P.final_drive_front= 15;          % STOCK (T1) sprocket teeth
P.final_drive_rear = 38;          % STOCK (T1) sprocket teeth
P.tyre_front       = '2.75-18';   % STOCK (T1)
P.tyre_rear        = '3.00-18';   % STOCK (T1)

%% --- Performance (STOCK, verified) ---
P.power_ps         = 14;          % STOCK (T1) xbhp #89
P.power_rpm        = 7500;
P.torque_nm        = 12.25;       % STOCK (T1) xbhp #89
P.torque_rpm       = 7000;

%% --- Sensitivity study ranges ---
% Each row: [min, max, n_steps] for a one-at-a-time sweep.
% UNVERIFIED/generic values are swept wider.
P.sweep = struct();
P.sweep.exhaust_open_deg  = [170 210 9];
P.sweep.transfer_open_deg = [110 140 7];
P.sweep.compression_ratio = [9.0  11.5 6];
P.sweep.squish_vol_cc     = [1.0  6.0  6];   % placeholder until measured
P.sweep.main_jet          = [125  145  5];
P.sweep.ignition_timing_deg= [12   22   5];   % placeholder until measured

end