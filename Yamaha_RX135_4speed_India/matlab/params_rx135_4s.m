% params_rx135_4s.m
% Verified parameter dataset (4-speed, Indian market) for Yamaha RX135
% Source: Yamaha_RX135_4speed_India/RX135_4speed_India_research.md

function P = params_rx135_4s()
P = struct();

%% --- Engine geometry (STOCK) ---
P.bore_mm          = 58;          % STOCK (T1) - same bore/stroke family
P.stroke_mm        = 50;
P.displacement_cc  = 132;
P.n_cyl            = 1;
P.compression_ratio= NaN;         % NOT FOUND for 4-speed (measure)
P.conn_rod_mm      = 98;          % community consensus UNVERIFIED (T3/T4)
P.piston_comp_h_mm = NaN;
P.gudgeon_pin_d_mm= NaN;
P.deck_height_mm   = NaN;
P.squish_vol_cc    = NaN;
P.head_vol_cc      = NaN;
P.crankcase_vol_cc = NaN;

%% --- Port timing (STOCK) - generic/unverified ---
P.exhaust_open_deg = 190;         % generic, UNVERIFIED
P.transfer_open_deg= 125;         % generic, UNVERIFIED
P.inlet_open_deg   = 95;          % generic (BTDC), UNVERIFIED
P.exhaust_height_mm= NaN;
P.transfer_height_mm=NaN;
P.inlet_height_mm  = NaN;

%% --- Carburetion (STOCK 4-speed early) ---
P.carb_type        = 'VM22? (4TL 01 assy)';
P.main_jet         = 165;         % STOCK (T3) 4-speed early
P.pilot_jet        = 17.5;        % STOCK (T3) 4-speed early
P.needle           = NaN;         % NOT FOUND
P.throttle_cutaway = NaN;         % NOT FOUND
P.float_height_mm  = NaN;

%% --- Ignition (STOCK) ---
P.spark_plug       = 'BR8HS';     % STOCK (T1)
P.ignition_timing_deg = NaN;      % NOT FOUND
P.cdi_type         = '4TL';       % STOCK (T1)

%% --- Drivetrain (STOCK 4-speed) ---
P.gear_ratios      = [3.182 2.000 1.368 1.000]; % STOCK (T1) xbhp #89
P.final_drive_front= 16;          % STOCK (T1) sprocket teeth
P.final_drive_rear = 34;          % STOCK (T1) sprocket teeth
P.tyre_front       = '2.75-18';   % STOCK (T1)
P.tyre_rear        = '3.00-18';   % STOCK (T1)

%% --- Performance (STOCK 4-speed, verified) ---
P.power_ps         = 12;          % STOCK (T1) factory
P.power_rpm        = 6500;
P.torque_nm        = 12.3;        % STOCK (T1) factory
P.torque_rpm       = 5500;

%% --- Sensitivity study ranges ---
P.sweep = struct();
P.sweep.exhaust_open_deg  = [170 210 9];
P.sweep.transfer_open_deg = [110 140 7];
P.sweep.compression_ratio = [8.5  11.0 6];
P.sweep.squish_vol_cc     = [1.0  6.0  6];
P.sweep.main_jet          = [155  175  5];
P.sweep.ignition_timing_deg= [12   22   5];
end