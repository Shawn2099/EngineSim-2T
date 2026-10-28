% rx135_5speed_params.m
% Yamaha RX135 5-speed (Indian) - engine parameters for MATLAB simulation.
% Source: rx135 5speed/Yamaha_RX135_5Speed_Parameters.md
% All angles in degrees unless noted. NOT FOUND values are left as NaN
% and MUST be measured/filled before running the model.

function P = rx135_5speed_params()
    % --- Identity ---
    P.name        = 'Yamaha RX135 5-speed (Indian)';
    P.model_years = [2000 2003];          % T1 (Wikipedia)
    P.engine_code_prefix = '1L7';          % T3
    P.cyl_block_code     = '4TL10';       % T3
    P.head_code          = '09L';         % T3
    P.carb_code          = '4TL4 20';     % T3 (Mikuni/UCAL Mikuni VM22, oval venturi)
    P.piston_code        = 'ART 4Y201';   % T3

    % --- Geometry (T1/T3) ---
    P.bore        = 58.0;   % mm  (T1 owner's manual + T3)
    P.stroke      = 50.0;   % mm  (T1)
    P.disp_cc     = 132.0;  % cc  (T1)
    P.conn_rod_mm = 98.0;   % mm  (T3/T4 community consensus; NOT in T1 manual; VERIFY)
    P.crank_throw = 25.0;   % mm  (= stroke/2, exact)
    P.gudgeon_pin_d = NaN;  % mm  NOT FOUND
    P.piston_comp_h = NaN;  % mm  NOT FOUND
    P.deck_height_tdc = NaN;% mm  NOT FOUND
    P.base_gasket_t  = NaN; % mm  NOT FOUND
    P.head_gasket_t  = NaN; % mm  NOT FOUND

    % --- Compression (T1) ---
    P.CR_geometric = 10.4;  % :1 (factory owner's manual)
    P.CR_trapped   = NaN;   % NOT FOUND (derive from port timing)
    P.chamber_cc   = NaN;   % cc NOT FOUND (~22 cc cited T4 unsourced; do not use)
    P.squish_clear = NaN;   % mm NOT FOUND
    P.squish_band  = NaN;   % mm NOT FOUND

    % --- Performance targets (T1/T4) ---
    P.power_bhp    = 14.0;  % BHP @ 7500 rpm (T1 owner's manual)
    P.power_rpm    = 7500;  % rpm
    P.torque_kgm   = 1.25;  % kgm @ 7000 rpm (T1) = 12.26 Nm
    P.torque_rpm   = 7000;  % rpm
    P.top_speed_kmh= 130;   % km/h (T4)
    P.zero60_s     = 3.5;   % s (T4)

    % --- Port timing (NOT FOUND - placeholders, must be measured) ---
    % Angles in crank degrees. Opening measured BTDC from TDC for exhaust;
    % transfer opening measured ATDC from TDC (or from BDC). Fill from port map.
    P.exhaust_open_BTDC  = NaN;   % deg  NOT FOUND
    P.exhaust_close_ATDC = NaN;   % deg  NOT FOUND
    P.exhaust_duration   = NaN;   % crank deg NOT FOUND (generic quote 190 deg, unverified)
    P.transfer_open_ATDC = NaN;   % deg  NOT FOUND
    P.transfer_close_BTDC= NaN;   % deg  NOT FOUND
    P.transfer_duration  = NaN;   % crank deg NOT FOUND (generic quote 125 deg, unverified)
    P.inlet_type         = 'piston reed + YEIS, 7-port';  % T1

    % --- Induction (T3) ---
    P.carb_venturi_mm = 22;     % mm (oval venturi)
    P.main_jet        = 135;
    P.pilot_jet       = 15.0;
    P.needle_jet      = '#5ZF6';
    P.slide_cutaway   = 2.0;
    P.needle_clip     = NaN;    % NOT FOUND
    P.float_height_mm = NaN;   % NOT FOUND
    P.air_screw_turns = NaN;   % NOT FOUND
    P.air_filter      = 'Washable PU foam (wet)';

    % --- Ignition (T1/T3/T4) ---
    P.cdi_magneto_pn  = '4TL-H5500-00-00';   % T1 (4TL1) shared 4&5 speed (T3)
    P.cdi_unit_pn     = '2YA-H5540-00-00';   % T1 (superseded 1M1-3002-00)
    P.spark_plug      = 'BPR 7HS (NGK) or equivalent';  % T1
    P.spark_plug_gap  = NaN;   % mm NOT FOUND
    P.ignition_type   = NaN;   % not legible in captured manual
    P.static_timing_deg_BTDC = NaN;  % NOT FOUND (owner reports ~12 deg, T4)
    P.static_timing_mm_BTDC  = NaN;  % NOT FOUND
    P.advance_curve   = NaN;   % NOT FOUND

    % --- Exhaust (T3) ---
    P.exhaust_type    = 'Catalytic hot-tube silencer (stock); never chrome OE';
    P.exhaust_mass_add_kg = 13;  % to 15 kg vs chrome (T3)
    P.exhaust_pipe_pn = NaN;   % 5-speed p/n not published (4-speed: 36LE-4611-00-00)
    P.exhaust_muffler_pn = NaN; % 5-speed p/n not published (4-speed: 36LE-4710-10-00)

    % --- Fuel & lubrication (T1) ---
    P.fuel_tank_L     = 10.5;   % L
    P.reserve_L       = NaN;     % NOT FOUND (manual garbled)
    P.gearbox_oil_L   = 0.65;   % L (Multigrade 20W/40)
    P.twot_oil_tank_L = NaN;    % NOT FOUND
    P.fork_oil_ml     = NaN;    % NOT FOUND
    P.autolube        = true;
    P.premix_ratio_ml_per_L = 45; % ml/L (owner-reported range 40-50; use mid)

    % --- Drivetrain (T3) ---
    P.primary_teeth   = [19 74];   % pinion/bell
    P.final_drive     = [15 38];   % front/rear sprocket teeth
    P.gear_ratios     = [35/11, 30/15, 26/19, 24/22, 22/24];  % 1..5

    % --- Dimensions (T1) ---
    P.length_mm = 1965;
    P.width_mm  = 780;
    P.height_mm = 1040;
    P.wheelbase_mm = NaN;   % NOT FOUND in capture
    P.ground_clearance_mm = 136;
    P.seat_height_mm = 765; % T4 (bikeinfobd)
    P.kerb_weight_kg = 116; % wet (T4); dry NOT FOUND in capture
    P.dry_weight_kg = NaN;  % NOT FOUND

    % --- Tyres (T1) ---
    P.tyre_front = '2.75 x 18 - 4PR (ribbed)';
    P.tyre_rear  = '3.00 x 18 - 6PR (universal)';

    % --- Brakes (T4) ---
    P.brake_front_mm = 130;  % drum
    P.brake_rear_mm  = 130;  % drum

    % --- Service (T1) ---
    P.chain_slack_mm = [20 30];
    P.carbon_remove_km = 5000;
    P.spark_plug_replace_km = 10000;
    P.service_interval_km = 3000;
end
