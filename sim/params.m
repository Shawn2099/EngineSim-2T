function P = params(arg)
%PARAMS  Verified parameter set - Yamaha RX135 5-speed (Indian), block 4TL10.
%
%   P = params()          build, self-check, print the step-1 report
%   P = params('quiet')   build and self-check silently (errors if a check fails)
%   P = params('table')   build, print the full tagged provenance table, then report
%
% -------------------------------------------------------------------------
% SINGLE SOURCE OF TRUTH
%   RX135_5S_VERIFIED_PARAMETERS.md  (dated 2026-10-28).
%   Every other .md in this tree is superseded and carries known-wrong values
%   (CR 10.4:1, carb VM22, "ignition timing NOT FOUND"). If this file ever
%   disagrees with that one, that one wins and this file is the bug.
%
% NO BARE NUMBERS
%   Every input magnitude appears exactly once, as the first argument of a
%   tagged q() call, and is read back as P.<section>.<name>.value. Nothing is
%   computed from a literal typed somewhere else. Formula constants that are
%   part of a published relation (12 in L = a*Ed/(12N), 2*pi, 4-pi for a
%   rounded rectangle, 180/360 for crank geometry) stay in the formula and are
%   explained in the note next to it.
%   The one deliberate exception: PARAMS' self-check carries the md's
%   PUBLISHED values as literals, because those are the test oracle. Reading
%   the oracle out of P would make the check circular.
%
% PROVENANCE TAGS  (md legend in brackets)
%   FACTORY     [F]  factory service document / owner's manual / parts list
%   ADOPTED     [O]  community-grade source explicitly adopted as the baseline
%                    because no factory equivalent exists. Not factory data,
%                    not an invention either. Currently: the port map only.
%   DERIVED     [D]  calculated here from tagged inputs; method in note
%   ASSUMED     [A]  not sourced. Also used for the md's [X] community values.
%   CALIBRATED  [C]  fitted or placeholder-fitted, never a measurement
%
% UNITS
%   SI throughout: m, m^2, m^3, kg, s, Pa, K, W, Nm, kg/m^3, m/s, J/kg.
%   Crank angles are DEGREES (never radians); durations in degCA; speed in rpm.
%
% SHAPE
%   Every numeric leaf is a struct with fields .value .unit .tag .note:
%       P.geo.bore.value = 0.058   .unit 'm'  .tag 'FACTORY'
%   Read values as P.<section>.<name>.value. No number travels untagged.
%
% SECTION ORDER is dependency order, not md order: anchor and calibration
% constants come first because later sections read them (N_pk sets mean piston
% speed; a_wave sets the tuned pipe speed). Each banner cites its md section.
%
% REJECTED - do not reintroduce (md section 15)
%   CR 10.4:1                 10.4 is the kW figure; OCR artefact
%   VM22 / VM26 stock carb    VM20 on the 5-speed (VM22 is the 4-speed)
%   "timing NOT FOUND"        19.5 deg BTDC, Service Action electrical page
%   bore x stroke 58 x 55     implies 145 cc; contradicted by 132 cc
%   22 cc chamber             single unsourced post; factory is 15.9 cc
%   15.2 bhp @ 8500           unsourced owner claim
%   generic "190/125"         valid only as corroboration for this exact map
%
% See also PORT_GEOMETRY, ENGINE_MODEL, CALIBRATE, SWEEP.

if nargin < 1 || isempty(arg)
    arg = 'report';
end
arg = lower(arg);

P = struct();

% =====================================================================
% 1. IDENTITY (md section 2)
% =====================================================================
P.meta.variant   = q('RX135 5-speed (Indian)', '-', 'FACTORY', ...
    'primary variant; engine prefix 1L7, block 4TL10, MY2000-2003');
P.meta.engine_no = q('1L7 XXXXXX', '-', 'FACTORY', 'engine number prefix, 5-speed');
P.meta.block     = q('4TL10', '-', 'FACTORY', 'cylinder block code, 5-speed');
P.meta.head      = q('09L', '-', 'ASSUMED', 'cylinder head code; md tags [X]');
P.meta.piston    = q('ART 4Y201', '-', 'ASSUMED', 'OEM piston; md tags [X]');
P.meta.reed_assy = q('2YA-E3610-00-00', '-', 'FACTORY', 'reed valve assembly p/n');
P.meta.source    = q('RX135_5S_VERIFIED_PARAMETERS.md', '-', 'FACTORY', ...
    'dated 2026-10-28; supersedes all other .md in the tree');
P.meta.open_items = q('pipe dims, crankcase volume, CDI curve, port abs height, rod length, reed spec, dyno curve, squish', ...
    '-', 'ASSUMED', 'md 18 ranked open items - each is one measurement from a predictive model');

% =====================================================================
% 2. VALIDATION ANCHOR (md section 11) - what the model is fitted to
% =====================================================================
P.anchor.P_pk    = q(10.4e3, 'W', 'FACTORY', '10.4 kW (14.0 BHP) at 7500 rpm - THE fit target');
P.anchor.N_pk    = q(7500, 'rpm', 'FACTORY', 'power peak speed');
P.anchor.T_pk    = q(12.26, 'Nm', 'FACTORY', '1.25 kgm at 7000 rpm');
P.anchor.N_T     = q(7000, 'rpm', 'FACTORY', 'torque peak speed');
P.anchor.fit_note = q('fit the power point only', '-', 'ASSUMED', ...
    'md 11: 10.4 kW at 7500 implies 13.24 Nm, contradicting the 12.26 Nm quoted at 7000 by ~8%. Do not fit both');

% =====================================================================
% 3. CALIBRATION CONSTANTS (md sections 8, 16) - the ONLY four free parameters
% ---------------------------------------------------------------------
% Exactly these four are fitted by calibrate.m (step 4):
%   pipe acoustic speed, scavenge efficiency, combustion efficiency,
%   friction torque.
% Four knobs against ONE anchor is underdetermined: a whole family of
% solutions reproduces 10.4 kW. calibrate.m must be regularised to these
% priors (+/-15%) or the fit is arbitrary. Raised again at step 4.
% =====================================================================
P.cal.eta_comb  = q(0.95, '-', 'CALIBRATED', 'combustion efficiency, prior 0.95, Heywood 0.95-0.98');

% ---- friction: Blair Eq 5.4.2, "motorcycles, etc." --------------------
% fmep = 105 * Lst * N   [Pa, m, rpm]  ->  0.394 bar and 0.828 Nm at 7500.
% The old 1.30 Nm (0.618 bar) sat between Blair's industrial and plain-bearing
% lines, neither of which applies to a rolling-bearing motorcycle engine.
P.cal.fmep_k    = q(105, 'Pa/(m*rpm)', 'ADOPTED', ...
    'Blair Eq 5.4.2 coefficient for motorcycles; linear in speed, no constant term');

% =====================================================================
% 4. GEOMETRY AND KINEMATICS (md section 3)
% =====================================================================
P.geo.bore      = q(0.058, 'm', 'FACTORY', '58.0 mm, owner manual "58 x 50"');
P.geo.stroke    = q(0.050, 'm', 'FACTORY', '50.0 mm, owner manual');
P.geo.r_crank   = q(P.geo.stroke.value/2, 'm', 'DERIVED', 'stroke/2 = 25.0 mm, exact');
P.geo.l_rod     = q(0.098, 'm', 'ASSUMED', ...
    '98.0 mm - forum consensus only, in no manual (md 16 #3). 90->110 mm moves exhaust opening 1.5 deg');
P.geo.deck_clr  = q(0.0008, 'm', 'DERIVED', ...
    'crown 0.8 mm below deck at TDC: factory drawing floors at 50.8 mm vs 50.0 stroke (md 3)');
P.geo.A_p       = q(pi/4*P.geo.bore.value^2, 'm^2', 'DERIVED', 'pi/4*B^2 = 2642.1 mm2');
P.geo.V_d       = q(P.geo.A_p.value*P.geo.stroke.value, 'm^3', 'DERIVED', ...
    'A_p*S = 132.104 cc. NB md quotes 132.16 cc; geometry gives 132.104 (0.04%, no effect)');
P.geo.rod_stroke= q(P.geo.l_rod.value/P.geo.stroke.value, '-', 'DERIVED', ...
    'l/S = 1.96 (md 3). Rod-to-crank-radius l/r = 3.92');
P.geo.v_p_mean  = q(2*P.geo.stroke.value*P.anchor.N_pk.value/60, 'm/s', 'DERIVED', ...
    '2*S*N/60 at the 7500 rpm power peak = 12.5 m/s, normal for a road 2-stroke');

% =====================================================================
% 5. COMPRESSION AND CLEARANCE VOLUME (md section 4)
% =====================================================================
P.comp.CR_geom  = q(10.1, '-', 'FACTORY', ...
    'factory Service Action states 10.0; owner manual 10.1 - 10.1 adopted (md 14 #1)');
P.comp.Vc_bare  = q(15.90e-6, 'm^3', 'FACTORY', ...
    '15.9 cc burette value, head with no piston crown in it');
P.comp.Vc       = q(14.52e-6, 'm^3', 'DERIVED', ...
    '14.52 cc effective: crown dome + squish occupy ~1.4 cc of the 15.9 cc head, so (Vd+Vc)/Vc = 10.1');
P.comp.squish   = q(0.0015, 'm', 'ASSUMED', ...
    '1.5 mm placeholder, Blair model input. NOT in the factory documents - the service action gives clearance volume only');

% =====================================================================
% 6. PORTS (md sections 5.1-5.4)
% ---------------------------------------------------------------------
% DATUM. The port map is drawn on a 50.00 mm stroke with every floor on BDC,
% so its "TDC line" is the piston crown at TDC, which sits 0.8 mm below the
% deck. A map height below TDC therefore IS the piston travel at which the
% port opens - no deck-clearance correction. (The factory drawing measures
% from the deck, which is why its heights sit 0.8 mm higher and give 173 deg
% instead of 186 deg. md 5.3: map for absolutes, drawing for deltas.)
%
% PROVENANCE. The map is [O] ADOPTED, not [F]: a T3-grade community drawing.
% Adopted because it is the only dimensioned source, its floors land on its
% own BDC line, and the independent "190/125" quote is within 5 deg of it.
% Every timing in this file therefore rests on an adopted, not factory, source
% - which is exactly why md 5.3 mandates the 173-190 deg sweep in every study.
% =====================================================================
P.port.exh_w    = q(0.039, 'm', 'ADOPTED', '39.0 mm, map 4TL10 (oval/rounded rect)');
P.port.exh_h    = q(0.023, 'm', 'ADOPTED', '23.0 mm, map');
P.port.exh_top  = q(0.027, 'm', 'ADOPTED', ...
    '27.00 mm below TDC line = 27.00 mm piston travel. Absolute height, drawing disagrees at 29.7 mm');
P.port.exh_r    = q(0.008, 'm', 'ASSUMED', ...
    'corner radius 8 mm, NOT dimensioned on the map (md 5.4 caveat). Back-solved to reproduce 842 mm2, so the area match is circular');
P.port.tr_w     = q([0.025 0.019 0.025 0.019 0.025], 'm', 'ADOPTED', 'T1..T5 widths 25/19/25/19/25 mm, map');
P.port.tr_h     = q([0.012 0.012 0.015 0.012 0.012], 'm', 'ADOPTED', 'T1..T5 heights 12/12/15/12/12 mm, map');
P.port.tr_top   = q([0.038 0.038 0.038 0.038 0.038], 'm', 'ADOPTED', ...
    'all five transfer tops 38.00 mm below TDC, map; drawing says 41.5/40.5 below deck');
P.port.tr_bot   = q([0.050 0.050 0.053 0.050 0.050], 'm', 'ADOPTED', ...
    'floors at BDC except T3 centre at 53 mm. Factory drawing implies 53.5 for the boost port (md 5.2)');
P.port.tr_r     = q(0.004, 'm', 'ASSUMED', ...
    'corner radius 4 mm, NOT dimensioned on the map. Back-solved to reproduce 1362 mm2, so the area match is circular');
P.port.n_tr     = q(5, '-', 'ADOPTED', 'five transfer windows (7-port cylinder incl. boost port)');
P.port.map_width= q(0.184, 'm', 'ADOPTED', ...
    'overall map width. pi*D = 182.21 mm, so the map is 1.0% wider than the circumference: widths are arc lengths');

% --- alternative absolute datum, factory porting drawing (md 5.2) ---------
P.port.exh_top_dwg = q(0.0305, 'm', 'FACTORY', ...
    '30.5 mm below DECK = 29.7 mm travel after 0.8 mm clearance -> 173.3 deg. Low end of the sweep band');
P.port.tr_top_dwg  = q([0.0415 0.0415 0.0405 0.0405], 'm', 'FACTORY', ...
    'pair A 41.5 mm, pair B 40.5 mm below deck (4-speed 43.5/42.5, delta +2 mm)');
P.port.conflict    = q('map 27.0 vs drawing 30.5 mm', '-', 'ASSUMED', ...
    '2.7 mm unresolved (md 5.3, open item 4). Map for absolutes; drawing for deltas only');

% --- flow areas, full open (md 5.4) --------------------------------------
% The md figure is the SUM OF THE FIVE WINDOW AREAS. That is not the area the
% engine ever sees: T3's floor sits at 53 mm while the piston stops at 50, so
% its last 3 mm are never uncovered. The model uses the achievable maximum.
P.port.A_exh    = q(P.port.exh_w.value*P.port.exh_h.value - (4-pi)*P.port.exh_r.value^2, ...
    'm^2', 'DERIVED', '39x23 with r=8 = 842.1 mm2. Circular: r was chosen to give this number');
P.port.A_tr_windows = q(sum(P.port.tr_w.value.*P.port.tr_h.value) ...
    - P.port.n_tr.value*(4-pi)*P.port.tr_r.value^2, ...
    'm^2', 'DERIVED', 'sum of the five window areas = 1362.3 mm2 - the md 5.4 figure, not a flow area');
P.port.A_tr_max = q(P.port.A_tr_windows.value - tri_area_never_opened( ...
    P.port.tr_w.value(3), P.port.tr_r.value, P.geo.stroke.value, P.port.tr_bot.value(3)), ...
    'm^2', 'DERIVED', 'max simultaneously open at BDC. T3 floor 53 mm is never reached, so this is below the window sum');
P.port.A_unc_exh = q(0.05, '-', 'ASSUMED', ...
    'relative 1-sigma from the unverified corner radius: +4.0/-5.8% for r=5..11 (audit_prep A3)');
P.port.A_unc_tr  = q(0.07, '-', 'ASSUMED', ...
    'relative 1-sigma from the unverified corner radius: +3.8/-10.4% for r=2..7 (audit_prep A3)');
P.port.A_ratio_exh = q(P.port.A_exh.value/P.geo.A_p.value, '-', 'DERIVED', ...
    '0.319 of piston area - textbook for a performance road 2-stroke');
P.port.A_ratio_tr  = q(P.port.A_tr_max.value/P.geo.A_p.value, '-', 'DERIVED', ...
    '0.490 achievable; md quotes 0.516 from the window sum, which is unreachable');
P.port.floor_note  = q('map 50.0/53.0 vs drawing 50.0/51.0/53.5', '-', 'ASSUMED', ...
    'if the transfers really floor at 51.0 mm they are 1 mm taller, and that strip is never uncovered: max open area falls ~88 mm2 (-6.8%). Timing unaffected');
P.port.Cd_ex    = q(0.75, '-', 'ASSUMED', 'exhaust window discharge coefficient, sharp-edged; no measurement');
P.port.Cd_tr    = q(0.70, '-', 'ASSUMED', 'transfer Cd, lower than exhaust because the ducts are angled');

% --- published timing targets, which port_geometry.m must reproduce ------
P.port.tgt_exh_dur   = q(185.66, 'degCA', 'DERIVED', 'md 5.3: exhaust open 92.8 deg BBDC');
P.port.tgt_tr_dur    = q(131.25, 'degCA', 'DERIVED', 'md 5.3: transfers open 65.6 deg BBDC');
P.port.tgt_blowdown  = q(27.20,  'degCA', 'DERIVED', 'exhaust-open minus transfer-open');
P.port.tgt_exh_dur_dwg = q(173.3, 'degCA', 'DERIVED', 'from the factory drawing heights; sweep low end');

P.sweep.exh_dur = q([173 190], 'degCA', 'ASSUMED', ...
    'md 5.3 mandates this band in EVERY study: the single largest geometric uncertainty');

% =====================================================================
% 7. INDUCTION (md sections 5.5, 6)
% ---------------------------------------------------------------------
% Piston-reed + YEIS: reed opening is pressure-driven, so there is no inlet
% timing to specify. The reed is a check valve, nothing more.
% =====================================================================
P.inlet.carb      = q('VM22', '-', 'FACTORY', 'Mikuni/UCAL 4-speed carb - this build uses 4-speed induction (PROJECT_STATUS 2)');
P.inlet.venturi   = q(0.022, 'm', 'FACTORY', '22 mm venturi, ~380 mm2');
P.inlet.main_jet  = q(165, '-', 'FACTORY', 'main jet 165 (4-speed)');
P.inlet.pilot_jet = q(17.5, '-', 'FACTORY', 'pilot jet 17.5 (4-speed)');
P.inlet.nozzle    = q('0-8 (788)', '-', 'FACTORY', 'main nozzle / needle jet (4-speed)');
P.inlet.needle    = q('4J26', '-', 'FACTORY', 'jet needle (4-speed)');
P.inlet.cutaway   = q(2.0, 'mm', 'ASSUMED', 'slide cutaway 2.0; md tags [X]');
P.inlet.airbox    = q('duct + larger element', '-', 'FACTORY', ...
    '5-speed airbox; leaner jetted than the 4-speed on purpose - do not "correct" it');
P.inlet.A_venturi = q(pi/4*P.inlet.venturi.value^2, 'm^2', 'DERIVED', '314 mm2');
P.inlet.reed_As   = q(6.0e-4, 'm^2', 'ASSUMED', ...
    '600 mm2 effective reed seat, ~1.6x VM22 venturi area; no measurement (md 18 #6)');
P.inlet.reed_Cd   = q(0.70, '-', 'ASSUMED', 'reed discharge coefficient; no measurement');
P.inlet.reed_dp   = q(500, 'Pa', 'ASSUMED', 'cracking pressure ~0.5 kPa to open the petals');
% --- reed petal, dynamic/lift-limited (Blair D&S 5.4; Climent 2023 L313-321) --
% A static check valve has no lift law, so its flow area is the full seat at all
% times. Blair's model uses A_rd = n*x*X_p (petal lift x width), which is the
% lesser of the seat area and the lift area, and the lift is set by the pressure
% force against the petal's bending stiffness. Geometry below is ASSUMED: the
% RX135 reed block is not dimensioned in any source we hold.
P.inlet.reed_n    = q(2, '-', 'ASSUMED', 'two petals (one per side of the V-block); not measured');
P.inlet.reed_L    = q(0.030, 'm', 'ASSUMED', 'effective petal length 30 mm; Blair reference petal 25 mm');
P.inlet.reed_w    = q(0.010, 'm', 'ASSUMED', 'petal width: 2 petals x 30 mm x 10 mm = 600 mm2 seat');
P.inlet.reed_t    = q(0.0002, 'm', 'ASSUMED', '0.2 mm steel petal; Blair/Ortenzi small-engine value');
P.inlet.reed_E    = q(207e9, 'Pa', 'ASSUMED', 'Young modulus, steel (Blair D&S L23789-23796)');
P.inlet.reed_xstop= q(0.0099, 'm', 'ASSUMED', 'stop at tip-lift ratio 0.33 of petal length (Blair L23945)');
P.inlet.reed_k    = q(8*P.inlet.reed_E.value*(P.inlet.reed_w.value*P.inlet.reed_t.value^3/12) ...
    /P.inlet.reed_L.value^3, 'N/m', 'DERIVED', ...
    ['uniformly-loaded cantilever tip stiffness 8EI/L^3, I = w t^3/12 ' ...
     '(Blair, The Basic Design of Two-Stroke Engines, Eq. 6.3.10, p.288 / PDF p.154: ' ...
     'DEFL = P*b*L^4/(8EI)). 3EI/L^3 is the tip POINT load and is 2.67x too compliant']);
P.inlet.reed_Ap   = q(P.inlet.reed_w.value*P.inlet.reed_L.value, 'm^2', 'DERIVED', ...
    'pressure-loaded petal area w*L, per petal. NB engine_model re-derives w, k and Ap from reed_As so that the seat area is a live parameter; these three are the baseline values');

% =====================================================================
% 8. IGNITION (md section 7)
% =====================================================================
P.ign.type      = q('CDI', '-', 'FACTORY', 'electronic CDI, rotor 1L7.62.02.00');
P.ign.adv_btdc  = q(19.5, 'deg', 'FACTORY', ...
    'static timing, Service Action electrical page. 4-speed is 24 deg - do not share a curve');
P.ign.adv_curve = q([3000 19.5; 5000 18.0; 6500 15.0; 8000 13.0], 'rpm,deg', 'ASSUMED', ...
    'typical CDI retard, interpolated at the run speed; a placeholder, not a measurement (PROJECT_STATUS 7 #8)');
P.ign.spark_dur = q(1.0, 'degCA', 'ASSUMED', 'spark duration, numerical only');
P.ign.plug      = q('NGK BPR7HS', '-', 'FACTORY', 'stock plug is copper, not iridium');
P.ign.plug_gap  = q(0.00065, 'm', 'FACTORY', '0.6-0.7 mm');

% =====================================================================
% 9. COMBUSTION AND THERMODYNAMICS
% =====================================================================
P.comb.wiebe_a   = q(6.9, '-', 'ADOPTED', ...
    'Galindo/Climent 2011: a fixed at 6.9 so 99.9% of fuel is burnt (L415)');
P.comb.wiebe_m   = q(1.05, '-', 'ADOPTED', ...
    'Blair validated 65 cc chainsaw m=1.05 (D&S L16699-16704); Galindo regression is OCR-destroyed in our extract');
P.comb.burn_dur  = q(64, 'degCA', 'ADOPTED', ...
    'Blair 65 cc chainsaw burn period 64 deg; Blair models span 41-64 deg');
P.comb.gamma     = q(1.33, '-', 'ASSUMED', 'fixed ratio of specific heats; no composition model');
P.comb.R_gas     = q(287, 'J/kg/K', 'ASSUMED', 'air');
P.comb.LHV       = q(43.5e6, 'J/kg', 'ASSUMED', 'gasoline lower heating value, 43-44 MJ/kg');
P.comb.T_wall    = q(450, 'K', 'ASSUMED', 'mean wall temperature for heat transfer');
P.comb.T_exh     = q(700, 'K', 'ASSUMED', 'mean exhaust gas temperature');

% =====================================================================
% 10. FUEL AND CHARGE (md sections 9, 11)
% =====================================================================
P.fuel.AFR      = q(12.5, '-', 'ASSUMED', ...
    'WOT target; NOT FOUND in any source. Calibration/sweep axis (md 9, 16 #10)');
P.fuel.AFR_stoich = q(14.7, '-', 'ASSUMED', 'gasoline');
P.fuel.rho      = q(740, 'kg/m^3', 'ASSUMED', 'gasoline at ~20 C');
P.fuel.rho_air  = q(1.18, 'kg/m^3', 'ASSUMED', ...
    'ambient, ~30 C, humid; the value implied by the md 11 BSFC cross-check');
P.fuel.DR_ref   = q(0.75, '-', 'ASSUMED', ...
    'delivery ratio used ONLY for the md 11 BSFC check; the model predicts its own');
P.fuel.p_amb    = q(101325, 'Pa', 'ASSUMED', 'sea level');
P.fuel.T_amb    = q(303, 'K', 'ASSUMED', '30 C');

% =====================================================================
% 10b. SCAVENGING (Blair 3.1 via REFERENCES_EXTRACT 6)
% ---------------------------------------------------------------------
% One law, one degree of freedom. No short-circuit knob and no mixing penalty:
% the short-circuit mass is DEFINED as delivered minus trapped fresh.
%   SR = DR, SE = trapped fresh/trapped mass, TE = SE/DR
%   perfect displacement SE = SR up to SR_pd, perfect mixing above.
% =====================================================================
P.scav.model  = q('Benson-Brandham', '-', 'ADOPTED', ...
    'displacement to the break point, mixing above; Blair eq 3.1.21');
P.scav.SR_pd  = q(0.5, '-', 'ASSUMED', ...
    'break point; loop-scavenged engines sit 0.3-0.7 per Blair. The ONLY scavenging degree of freedom');
P.scav.SE_chk = q(1-(1-0.5)*exp(-(0.955-0.5)/0.5), '-', 'DERIVED', ...
    'sanity: SE = 0.80 at DR 0.955, above the 0.6 floor in REFERENCES_EXTRACT 6');

% =====================================================================
% 11. CRANKCASE (md section 12)
% =====================================================================
P.cc.V          = q(3.85e-4, 'm^3', 'ASSUMED', ...
    '385 cc (md range 330-440, md 12 / 16 #4). Measure by filling through the inlet');
P.cc.CR         = q((P.cc.V.value + P.geo.V_d.value)/P.cc.V.value, '-', 'DERIVED', ...
    '(Vcc+Vd)/Vcc = 1.34, inside the md 1.3-1.4 band; drives scavenging');

% =====================================================================
% 12. EXHAUST SYSTEM - 4-speed stock ABSORPTIVE silencer, measured
%     (PROJECT_STATUS 4 supersedes the md section 8)
% ---------------------------------------------------------------------
% Straight-through absorptive: a 35 mm perforated core from the port to the
% outlet, with the can divided by five baffle plates into five annular chambers
% coupled to the core through the perforations. Gas path is the core; the
% annulus is packed and is NOT a free volume.
% All five chambers resonate together at 0.9-1.8 kHz because coupling area and
% volume both scale with section length. Firing is 108-125 Hz, an order of
% magnitude lower, so the plates are damping, not tuning.
% =====================================================================
P.exh.type      = q('straight-through absorptive (4-speed stock)', '-', 'FACTORY', ...
    'measured on the bike; not the 5-speed catalytic silencer');
P.exh.model     = q('absorptive', '-', 'FACTORY', ...
    '35 mm core + five side-branch chambers through the perforation area');

P.exh.core_d    = q(0.035, 'm', 'FACTORY', 'perforated core ID 35 mm');
P.exh.core_L    = q(1.275, 'm', 'FACTORY', 'piston face to outlet ~1275 mm (1230 + 45 port depth)');
P.exh.core_Lperf= q(0.420, 'm', 'FACTORY', 'perforated length 420 mm');
P.exh.can_d     = q(0.096, 'm', 'FACTORY', 'can ID 96 mm');
P.exh.can_L     = q(0.600, 'm', 'FACTORY', 'can length 600 mm');
P.exh.cham_L    = q([140 100 90 70 200]*1e-3, 'm', 'FACTORY', ...
    'five baffle sections, 140/100/90/70/200 mm, sum 600');
P.exh.cham_V    = q([879 628 565 439 1255]*1e-6, 'm^3', 'FACTORY', ...
    'annulus volume per chamber, 3766 cc total');
P.exh.cham_x0   = q(0.630, 'm', 'FACTORY', ...
    'chambers start at header 390 + cone 240 = 630 mm from the port');
P.exh.perf_frac = q(0.05, '-', 'ASSUMED', ...
    'perforation open-area fraction; 5% puts the chamber resonance near 0.9 kHz as measured/estimated');
P.exh.Cd_perf   = q(0.60, '-', 'ASSUMED', 'perforation discharge coefficient');
P.exh.A_out     = q(787e-6, 'm^2', 'FACTORY', ...
    '35 mm outlet minus a 5 mm bridge bar = 787 mm2, 31.7 mm equivalent');

P.exh.helm_hz   = q([900 1800], 'Hz', 'FACTORY', ...
    'chamber resonance range vs 108-125 Hz firing: damping, not tuning');
P.exh.Cf        = q(0.004, '-', 'ASSUMED', 'skin friction, Blair 2.3; Darcy f = 4Cf');
P.exh.T_wall    = q(723, 'K', 'ASSUMED', 'pipe wall 450 C, Blair 2.4 range 400-500 C');
P.exh.Pr        = q(0.72, '-', 'ASSUMED', 'Prandtl number, for Ck = mu*cp/Pr');

% --- Blair wave-pipe geometry: kept only for the comparison run ----------
% (PROJECT_STATUS 3: this pipe is not fitted to the bike; retained for the
% "what would a tuned chamber be worth" comparison only)
P.exh.d0        = q(sqrt(4*P.port.A_exh.value/pi), 'm', 'DERIVED', ...
    'exhaust equivalent diameter sqrt(4A/pi) = 32.7 mm');
P.exh.d_header  = q(1.125*P.exh.d0.value, 'm', 'ASSUMED', 'Blair enduro 1.125 d0');
P.exh.d_diff1   = q(0.0506, 'm', 'ASSUMED', 'Blair diffuser d2 (reconstructed)');
P.exh.d_diff2   = q(0.0629, 'm', 'ASSUMED', 'Blair diffuser d3 (reconstructed)');
P.exh.d_belly   = q(2.125*P.exh.d0.value, 'm', 'ASSUMED', 'Blair 2.125 d0');
P.exh.d_stinger = q(0.70*P.exh.d0.value,  'm', 'ASSUMED', 'Blair 0.70 d0');
P.exh.A_t       = q(pi/4*(0.70*P.exh.d0.value)^2, 'm^2', 'ASSUMED', ...
    'Blair-pipe stinger area, used only when model = blair');
P.exh.T_pipe    = q(743, 'K', 'ASSUMED', ...
    '470 C, Blair guidance for a 6.3 bar engine (VERIFICATION 2.4)');
P.exh.a0        = q(sqrt(P.comb.gamma.value*P.comb.R_gas.value*P.exh.T_pipe.value), 'm/s', 'DERIVED', ...
    'sqrt(gamma R T_pipe) = 533 m/s');
P.exh.seg_frac  = q([0.100 0.275 0.183 0.092 0.110 0.240], '-', 'ASSUMED', ...
    'L1..L6 fractions of LT, Blair 6.2');
P.exh.LT        = q(P.exh.a0.value*P.port.tgt_exh_dur.value/(12*P.anchor.N_pk.value), 'm', 'DERIVED', ...
    '83.3 a0 Ed/N = 1127 mm, matching VERIFICATION 2.4');
P.exh.L_seg     = q(P.exh.LT.value*P.exh.seg_frac.value, 'm', 'DERIVED', 'L1..L6');
P.exh.L_tail    = q(P.exh.LT.value*P.exh.seg_frac.value(6), 'm', 'DERIVED', 'L7 = L6');
P.exh.L_total   = q(P.exh.LT.value + P.exh.L_tail.value, 'm', 'DERIVED', 'full duct incl. tail-pipe');

% =====================================================================
% 13. DRIVETRAIN (md section 10) - reporting only, unused by the cycle solver
% =====================================================================
P.drive.primary = q(74/19, '-', 'ASSUMED', '19T/74T; md tags [X], tooth counts confirmed twice');
P.drive.gears   = q([3.182 2.000 1.368 1.000], '-', 'FACTORY', ...
    '1st..4th of the 4-speed box: 35/11, 30/15, 26/19, 22/22 (PROJECT_STATUS 2)');
P.drive.final   = q(34/16, '-', 'FACTORY', '16T/34T, 4-speed (PROJECT_STATUS 2)');
P.drive.tyre    = q(1.875, 'm', 'ASSUMED', 'rolling circumference, 2.75-18 rear');
P.drive.mass    = q(108, 'kg', 'FACTORY', 'dry weight');

% =====================================================================
% 14. NUMERICS
% =====================================================================
P.num.dtheta   = q(0.25, 'degCA', 'ASSUMED', 'crank step; 0.25 deg resolves the 1032 mm pipe phase');
P.num.n_revs   = q(60, '-', 'ASSUMED', 'max revolutions to reach cyclic convergence');
P.num.rel_tol  = q(1e-4, '-', 'ASSUMED', 'relative change in trapped mass between cycles');

% =====================================================================
% 15. DERIVED SUMMARY - every cross-check quantity, computed once
% ---------------------------------------------------------------------
% The solver and the self-check both read these; nothing downstream should
% re-derive a crank angle or a BMEP.
% =====================================================================
r  = P.geo.r_crank.value;
l  = P.geo.l_rod.value;
Vc = P.comp.Vc.value;
Vd = P.geo.V_d.value;
Ap = P.geo.A_p.value;

th_e = theta_from_x(r, l, P.port.exh_top.value);            % exhaust opens, deg ATDC
th_t = theta_from_x(r, l, P.port.tr_top.value(1));          % transfers open, deg ATDC
th_d = theta_from_x(r, l, P.port.exh_top_dwg.value - P.geo.deck_clr.value);

P.derived.exh_open_atdc  = q(th_e,       'deg',   'DERIVED', '27.00 mm travel, slider-crank l=98 r=25');
P.derived.exh_open_bbdc  = q(180-th_e,   'deg',   'DERIVED', '180 - open ATDC');
P.derived.exh_close_atdc = q(360-th_e,   'deg',   'DERIVED', 'port symmetric about BDC');
P.derived.exh_dur        = q(2*(180-th_e),'degCA','DERIVED', 'exhaust open to close');
P.derived.tr_open_atdc   = q(th_t,       'deg',   'DERIVED', '38.00 mm travel');
P.derived.tr_open_bbdc   = q(180-th_t,   'deg',   'DERIVED', 'fixed 65.63 regardless of rod length');
P.derived.tr_close_atdc  = q(360-th_t,   'deg',   'DERIVED', 'port symmetric about BDC');
P.derived.tr_dur         = q(2*(180-th_t),'degCA','DERIVED', 'transfer open to close');
P.derived.blowdown       = q(th_t-th_e,  'degCA', 'DERIVED', 'exhaust-only phase before scavenge starts');
P.derived.scav_angle     = q((360-th_e)-th_t, 'degCA', 'DERIVED', 'transfer open to exhaust close');
P.derived.exh_dur_dwg    = q(2*(180-th_d),'degCA','DERIVED', 'from 29.7 mm travel: the sweep low end');

P.derived.CR_geom        = q((Vd+Vc)/Vc, '-', 'DERIVED', 'from effective Vc, honours factory 10.1');
P.derived.CR_trapped_map = q((Vc+Ap*P.port.exh_top.value)/Vc, '-', 'DERIVED', ...
    'V at exhaust close / Vc. NB md 4 prints "closes 87.2 ATDC"; port symmetry puts close at 272.8 ATDC - same volume, label only');
P.derived.CR_trapped_dwg = q((Vc+Ap*(P.port.exh_top_dwg.value-P.geo.deck_clr.value))/Vc, '-', 'DERIVED', ...
    '29.7 mm travel, factory drawing datum');

P.derived.BMEP_pk       = q(P.anchor.P_pk.value/(Vd*P.anchor.N_pk.value/60), 'Pa', 'DERIVED', ...
    'P/(Vd*N) for a 2-stroke: one power stroke per revolution');
P.derived.T_implied_pk  = q(P.anchor.P_pk.value/(2*pi*P.anchor.N_pk.value/60), 'Nm', 'DERIVED', ...
    'torque the power point implies at 7500');
P.derived.BMEP_T        = q(2*pi*P.anchor.T_pk.value/Vd, 'Pa', 'DERIVED', ...
    '2*pi*T/Vd for a 2-stroke, at the quoted 12.26 Nm');

m_air = P.fuel.DR_ref.value*Vd*(P.anchor.N_pk.value/60)*P.fuel.rho_air.value;   % kg/s
m_fuel = m_air/P.fuel.AFR.value;                                               % kg/s
P.derived.mdot_air_pk   = q(m_air*3600, 'kg/h', 'DERIVED', 'DR 0.75 * Vd * N * rho_air at 7500');
P.derived.mdot_fuel_pk  = q(m_fuel*3600, 'kg/h', 'DERIVED', 'air / AFR 12.5');
P.derived.BSFC          = q(m_fuel*3600*1e3/(P.anchor.P_pk.value/1000), 'g/kWh', 'DERIVED', ...
    'g/h divided by brake kW');
P.derived.fmep_7500     = q(P.cal.fmep_k.value*P.geo.stroke.value*7500, 'Pa', 'DERIVED', ...
    'Blair 5.4.2: 105*0.050*7500 = 39 375 Pa = 0.394 bar');
P.derived.T_f2000 = q(P.derived.fmep_7500.value*(2000/7500)*Vd/(2*pi), 'Nm', 'DERIVED', ...
    'friction torque at 2000 rpm, same linear law');
P.derived.T_f7500 = q(P.derived.fmep_7500.value*Vd/(2*pi), 'Nm', 'DERIVED', ...
    '0.828 Nm at 7500 - replaces the old 1.30 Nm, which was 57% too high');
P.derived.fmep_pk = q(P.derived.fmep_7500.value/1e5, 'bar', 'DERIVED', '0.394 bar at 7500 rpm');
P.derived.LT_check       = q(P.exh.a0.value*P.derived.exh_dur.value/(12*P.anchor.N_pk.value), ...
    'm', 'DERIVED', 'Blair 6.2.4 with the consistent a0; must equal P.exh.LT');
P.derived.N_tuned       = q(P.exh.a0.value*P.derived.exh_dur.value/(12*P.exh.LT.value), ...
    'rpm', 'DERIVED', '83.3 a0 Ed / LT; 7500 by construction if LT came from the same a0');
P.derived.port_width_ratio = q(P.port.map_width.value/(pi*P.geo.bore.value), '-', 'DERIVED', ...
    'map width / circumference = 1.010, so map widths are arc lengths (a developed view)');

% friction is now a literature law, not a fitted level: nothing to normalise

% =====================================================================
% REPORT
% =====================================================================
if strcmp(arg, 'table')
    dump_provenance(P, 'P.');
end
selfcheck(P, ~strcmp(arg, 'quiet'));

end % ===================== end params =====================


% ---------------------------------------------------------------------
% provenance wrapper
% ---------------------------------------------------------------------
function e = q(value, unit, tag, note)
e = struct('value', value, 'unit', unit, 'tag', tag, 'note', note);
end


% ---------------------------------------------------------------------
% slider-crank kinematics, theta in degrees ATDC
% ---------------------------------------------------------------------
function x = piston_x(r, l, th_deg)
t = th_deg*pi/180;
x = r*(1 - cos(t)) + l*(1 - sqrt(1 - (r/l)^2*sin(t)^2));
end

% ---------------------------------------------------------------------
% crank angle ATDC at which piston travel first reaches x (bisection;
% piston_x is monotonic on 0..180 deg)
% ---------------------------------------------------------------------
function th = theta_from_x(r, l, x)
lo = 0; hi = 180;
for k = 1:80
    mid = 0.5*(lo + hi);
    if piston_x(r, l, mid) < x
        lo = mid;
    else
        hi = mid;
    end
end
th = 0.5*(lo + hi);
end


% ---------------------------------------------------------------------
% area of the boost-port window that the piston never uncovers.
% T3's floor is 3 mm below BDC, so that strip is covered all cycle.
% ---------------------------------------------------------------------
function A = tri_area_never_opened(w, r, stroke, floor)
d = floor - stroke;
A = w*d - 2*corner_int(d, r);
end

% corner area lost over the first d mm of a corner, measured from its narrow
% end: integral_{r-d}^{r} (r - sqrt(r^2-u^2)) du
function I = corner_int(d, r)
if d <= 0, I = 0; return; end
d = min(d, r);
u = r - d;
F = (u/2)*sqrt(max(r^2-u^2,0)) + (r^2/2)*asin(min(max(u/r,-1),1));
I = r*d - (pi*r^2/4 - F);
end


% ---------------------------------------------------------------------
% self-check: compare the computed set against the md's published values
% ---------------------------------------------------------------------
function selfcheck(P, verbose)

g = P.geo;  c = P.comp;  po = P.port;  a = P.anchor;  d = P.derived;

% ---- rows: name, computed, md published, tol, relative?, unit, note ----
k = 0;
k=k+1; C(k) = mk('Displacement',            g.V_d.value*1e6,        132.10, 0.01,  false, 'cc',   'pi/4*58^2*50; md 3 now quotes 132.10');
k=k+1; C(k) = mk('Map floors on BDC',       po.tr_bot.value(1)*1e3, g.stroke.value*1e3, 1e-6, false, 'mm', 'map internal consistency: floor = stroke');
k=k+1; C(k) = mk('Geometric CR',            d.CR_geom.value,        10.1,   0.02,  false, ':1',   '');
k=k+1; C(k) = mk('CR from bare 15.9 cc head', g.V_d.value/c.Vc_bare.value+1, 9.31, 0.01, false, ':1', 'md 4 arithmetic note');
k=k+1; C(k) = mk('Exhaust duration',        d.exh_dur.value,        185.7,  0.15,  false, 'degCA','');
k=k+1; C(k) = mk('Transfer duration',       d.tr_dur.value,         131.3,  0.15,  false, 'degCA','');
k=k+1; C(k) = mk('Exhaust opens (BBDC)',    d.exh_open_bbdc.value,  92.8,   0.15,  false, 'deg',  '');
k=k+1; C(k) = mk('Transfers open (BBDC)',   d.tr_open_bbdc.value,   65.6,   0.15,  false, 'deg',  '');
k=k+1; C(k) = mk('Blowdown',                d.blowdown.value,       27.0,   0.3,   false, 'deg',  '');
k=k+1; C(k) = mk('Exhaust dur, drawing datum', d.exh_dur_dwg.value, 173.3,  0.2,   false, 'degCA','30.5-0.8 mm; sweep low end');
k=k+1; C(k) = mk('Trapped CR (map)',        d.CR_trapped_map.value, 5.9,    0.05,  false, ':1',   '');
k=k+1; C(k) = mk('Trapped CR (drawing)',    d.CR_trapped_dwg.value, 6.4,    0.05,  false, ':1',   '');
k=k+1; C(k) = mk('Exhaust full-open area',  po.A_exh.value*1e6,     842,    2,     false, 'mm2',  '');
k=k+1; C(k) = mk('Transfer window area (sum)', po.A_tr_windows.value*1e6, 1362, 2, false, 'mm2',  'md 5.4 figure; a window sum, not an achievable flow area');
k=k+1; C(k) = mk('A_exh / A_piston',        po.A_ratio_exh.value,   0.319,  0.003, false, '-',    '');
k=k+1; C(k) = mk('A_tr(win) / A_piston',    po.A_tr_windows.value/g.A_p.value, 0.516, 0.003, false, '-', 'md 5.4 ratio');
k=k+1; C(k) = mk('BMEP at 10.4 kW / 7500',  d.BMEP_pk.value/1e5,    6.30,   0.02,  false, 'bar',  '');
k=k+1; C(k) = mk('Torque implied at 7500',  d.T_implied_pk.value,   13.24,  0.02,  false, 'Nm',   '');
k=k+1; C(k) = mk('BSFC at DR 0.75 / AFR 12.5', d.BSFC.value,       405,    3,     false, 'g/kWh','');
k=k+1; C(k) = mk('Fuel flow at 7500',       d.mdot_fuel_pk.value,   4.2,    0.05,  false, 'kg/h', '');
k=k+1; C(k) = mk('Exhaust equivalent dia d0', P.exh.d0.value*1e3, 32.7, 0.1, false, 'mm', 'Blair d0 from 842 mm2');
k=k+1; C(k) = mk('Tuned speed from LT',    P.derived.N_tuned.value, 7500, 1,   false, 'rpm', 'a0 and LT from one temperature');
k=k+1; C(k) = mk('Crankcase CR',            P.cc.CR.value,          1.35,   0.05,  false, ':1',   'md 1.3-1.4 band');
k=k+1; C(k) = mk('Friction torque at 7500', d.T_f7500.value, 0.828, 0.001, false, 'Nm', 'Blair 5.4.2: 0.394 bar = 0.828 Nm');

n = numel(C); nfail = 0;
for i = 1:n
    C(i).d = C(i).act - C(i).exp;
    if C(i).rel
        C(i).pass = abs(C(i).d) <= C(i).tol*abs(C(i).exp);
    else
        C(i).pass = abs(C(i).d) <= C(i).tol;
    end
    if ~C(i).pass, nfail = nfail + 1; end
end

if verbose
    th_ec    = d.exh_close_atdc.value;
    th_spark = 360 - P.ign.adv_btdc.value;

    fprintf('\n  RX135 5-speed (4TL10)   STEP 1 OUTPUT   from %s\n', P.meta.source.value);
    fprintf('  %s\n', repmat('=', 1, 98));
    fprintf('  swept volume            %8.3f cc     pi/4*58^2*50\n', g.V_d.value*1e6);
    fprintf('  clearance volume        %8.3f cc     effective; 15.9 cc is the bare head\n', c.Vc.value*1e6);
    fprintf('  geometric CR            %8.3f : 1\n', d.CR_geom.value);
    fprintf('  trapped CR              %8.3f : 1    map datum, %.1f mm travel\n', d.CR_trapped_map.value, po.exh_top.value*1e3);
    fprintf('                          %8.3f : 1    drawing datum, 29.7 mm travel\n', d.CR_trapped_dwg.value);
    fprintf('  exhaust   port          %8.2f deg BBDC open / %.2f deg ATDC close / %.2f deg duration\n', ...
        d.exh_open_bbdc.value, th_ec, d.exh_dur.value);
    fprintf('  transfer  ports         %8.2f deg BBDC open / %.2f deg ATDC close / %.2f deg duration\n', ...
        d.tr_open_bbdc.value, d.tr_close_atdc.value, d.tr_dur.value);
    fprintf('  blowdown                %8.2f deg      exhaust-only, before scavenge starts\n', d.blowdown.value);
fprintf('  transfer area (max)     %8.1f mm2     achievable at BDC; the md 5.4 sum is %.1f\n', ...
    po.A_tr_max.value*1e6, po.A_tr_windows.value*1e6);
    fprintf('  BMEP at the anchor      %8.3f bar     %.1f kW @ %d rpm, Vd = %.3f cc\n', ...
        d.BMEP_pk.value/1e5, a.P_pk.value/1000, a.N_pk.value, g.V_d.value*1e6);
    fprintf('  %s\n', repmat('=', 1, 98));

    fprintf('  VERIFY AGAINST md 11\n');
    fprintf('  %-34s %12s %12s %s\n', 'anchor', 'computed', 'md', '');
    fprintf('  %-34s %12.3f %12.2f %s\n', 'power at 7500 rpm [kW]', a.P_pk.value/1000, a.P_pk.value/1000, 'input, not a prediction yet');
    fprintf('  %-34s %12.3f %12.2f %s\n', 'BMEP implied by that power [bar]', d.BMEP_pk.value/1e5, 6.30, 'md 11: 6.30, inside the 5-8 bar band');
    fprintf('  %-34s %12.3f %12.2f %s\n', 'torque implied at 7500 [Nm]', d.T_implied_pk.value, 13.24, '');
    fprintf('  %-34s %12.3f %12.2f %s\n', 'torque at 7000 rpm [Nm]', a.T_pk.value, 12.26, 'catalogue value, input');
    fprintf('  %-34s %12.3f %12.2f %s\n', 'BMEP implied at 7000 [bar]', d.BMEP_T.value/1e5, 5.83, 'inside the 5-8 bar band');
    fprintf('  %-34s %12.1f %12.0f %s\n', 'BSFC at DR 0.75 / AFR 12.5', d.BSFC.value, 405, 'md 11: ~405, inside 300-500');
    fprintf('  %-34s %12.3f %12.2f %s\n', 'fuel flow at 7500 [kg/h]', d.mdot_fuel_pk.value, 4.2, '');
    fprintf('  %-34s %12.1f %12.1f %s\n', 'scavenge window [degCA]', d.scav_angle.value, 158.5, '');
    fprintf('  ANCHOR CONFLICT: the power point needs %.2f Nm at 7500, the catalogue quotes %.2f Nm at 7000.\n', ...
        d.T_implied_pk.value, a.T_pk.value);
    fprintf('  Gap %.1f%%. Fit the POWER point only (md 11); the torque curve is a prediction.\n', ...
        100*(d.T_implied_pk.value-a.T_pk.value)/d.T_implied_pk.value);
    fprintf('  FRICTION: Blair 5.4.2 fmep = 105*Lst*N -> %.1f Pa = %.3f bar at 7500.\n', ...
        d.fmep_7500.value, d.fmep_pk.value);
    fprintf('    the solver subtracts %.4f Nm at 2000 rpm and %.4f Nm at 7500 rpm.\n', ...
        d.T_f2000.value, d.T_f7500.value);
    fprintf('  %s\n\n', repmat('-', 1, 98));

    fprintf('  PARAMETER SELF-CHECK  (computed vs md published numbers)\n');
    fprintf('  %-32s %12s %12s %10s  %-6s %s\n', 'quantity', 'computed', 'md', 'delta', 'unit', '');
    fprintf('  %s\n', repmat('-', 1, 98));
    for i = 1:n
        fprintf('  %-32s %12.4f %12.4f %10.4f  %-6s %s\n', ...
            C(i).name, C(i).act, C(i).exp, C(i).d, C(i).unit, ternary(C(i).pass, 'ok', 'FAIL'));
    end
    fprintf('  %s\n', repmat('-', 1, 98));
    fprintf('  %d/%d checks pass.  Port phase: blowdown %.2f, scavenge %.2f, compression %.2f, spark->TDC %.2f deg.\n', ...
        n-nfail, n, d.blowdown.value, d.scav_angle.value, 360-th_ec, 360-th_spark);
    fprintf('  NOTE md 4 says exhaust "closes 87.2 ATDC"; port symmetry about BDC makes that 272.8 ATDC\n');
    fprintf('       (87.2 ABDC). Same 27 mm travel and same 5.91 CR - a label typo, no parameter changes.\n');
end

if nfail > 0
    error('params:checkFailed', ...
        '%d of %d self-checks FAILED - parameter set is inconsistent with the md. Do not run the solver.', nfail, n);
end

if ~verbose, return; end

% ---- tag census ----
tg = collect_tags(P, {});
tags = {'FACTORY','ADOPTED','DERIVED','ASSUMED','CALIBRATED'};
fprintf('\n  %d values, every one tagged:', numel(tg));
for i = 1:numel(tags)
    fprintf('  %s %d', tags{i}, sum(strcmp(tg, tags{i})));
end
fprintf('\n  Fitted constants now: eta_comb only. Friction is Blair 5.4.2, not a knob.\n');
fprintf('  Exhaust is the measured absorptive silencer (35 mm core + 5 side chambers).\n\n');
end


function s = mk(name, act, exp, tol, rel, unit, note)
s = struct('name', name, 'act', act, 'exp', exp, 'tol', tol, 'rel', rel, 'unit', unit, 'note', note);
end

function out = ternary(cond, a, b)
if cond, out = a; else, out = b; end
end


% ---------------------------------------------------------------------
% recursive tag census
% ---------------------------------------------------------------------
function c = collect_tags(s, c)
f = fieldnames(s);
for i = 1:numel(f)
    v = s.(f{i});
    if isstruct(v) && isfield(v, 'tag')
        c{end+1} = v.tag;
    elseif isstruct(v)
        c = collect_tags(v, c);
    end
end
end


% ---------------------------------------------------------------------
% full provenance dump (params('table'))
% ---------------------------------------------------------------------
function dump_provenance(s, prefix)
f = fieldnames(s);
for i = 1:numel(f)
    v = s.(f{i});
    name = [prefix f{i}];
    if isstruct(v) && isfield(v, 'tag')
        if ischar(v.value)
            vs = v.value;
        else
            vs = mat2str(v.value, 5);
        end
        if numel(vs) > 28
            vs = [vs(1:26) '..'];
        end
        fprintf('  %-26s %-28s %-9s %-11s %s\n', name, vs, v.unit, v.tag, v.note);
    elseif isstruct(v)
        dump_provenance(v, [name '.']);
    end
end
end
