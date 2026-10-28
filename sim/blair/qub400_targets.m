function [T, G] = qub400_targets(which)
%QUB400_TARGETS  Published QUB 400 results, used to validate a MATLAB port.
%
%   T = qub400_targets()        all 53 published numeric targets
%   T = qub400_targets('A')     only case A (also 'B', 'C', 'G')
%   T = qub400_targets('graph') the graph-only list instead of the numeric set
%   [T, G] = qub400_targets()   T = 53 numeric targets, G = 5 graph-only items
%
%   Only numbers that are stated in the book's text or printed in a table are
%   scored targets. The five items that exist only as plots are returned in G
%   with approximate = true and no numeric value; they are never scored.
%
%   TARGET FIELDS
%     id          1..53, stable
%     case_id     'A' 3000 rpm, full throttle (THAR 1.0), 5th cycle   Fig.5.9
%                 'B' 3000 rpm, quarter throttle (THAR 0.25), 5th cycle Fig.5.13
%                 'C' 5000 rpm, full throttle, SCRE column           Fig.5.12
%                 'G' engine geometry / text consistency, speed independent
%     case_rpm    case speed (NaN for 'G')
%     case_throttle  throttle area ratio (NaN for 'G')
%     quantity    canonical key understood by check_qub400
%     name        display name
%     value       published value in canonical units (see .unit)
%     unit        canonical unit
%     printed     exactly as it appears in the book
%     tol         tolerance magnitude, in percent
%     tol_mode    'rel' -> tol is a percentage of the published value
%                 'abs' -> tol is percentage points, i.e. tol/100 expressed
%                          in the quantity's own units (used for DR/SE/TE:
%                          5 means +/-0.05, not +/-5% of 0.854)
%     cls         'printout' | 'table' | 'text'
%     role        'model'     -> the port must reproduce it (scored)
%                 'reference' -> measured bench data (reported, not scored)
%     figure      source figure
%     line        source line number(s) in
%                 references/text/Blair,_G.P._-_The_Basic_Design_of_Two-
%                 Stroke_Engines_(SAE).txt
%     conflict    set when the book gives two different values for the same run
%     alt_value   the other value in that conflict (NaN when there is none)
%     approximate false for every scored target
%     scored      true when role is 'model'
%
%   TOLERANCE POLICY (fixed by the validation brief, applied by tol_rule)
%     power, bmep, bsfc, pmax   5 % of published
%     dr, se, te                5 percentage points, absolute
%     tmax                      2 % of published
%     every other quantity      10 % of published
%
%   Published values are transcribed exactly as printed. They are NOT rounded
%   or "corrected". Where two sources disagree, both are kept: the primary is
%   in .value, the alternative in .alt_value, and the tolerance absorbs the
%   difference. See QUB400_VALIDATION.md section 7.

if nargin < 1 || isempty(which)
    which = 'all';
end

G = graph_only_targets();

if strcmpi(which, 'graph')
    T = G;
    return
end

spec = target_spec();
n = size(spec, 1);

T = repmat(struct( ...
    'id', 0, 'case_id', '', 'case_name', '', 'case_rpm', NaN, 'case_throttle', NaN, ...
    'quantity', '', 'name', '', 'value', 0, 'unit', '', 'printed', '', ...
    'tol', 0, 'tol_mode', '', 'cls', '', 'role', '', 'figure', '', ...
    'line', '', 'conflict', '', 'alt_value', NaN, 'note', '', ...
    'approximate', false, 'scored', false), 1, n);

for k = 1:n
    c = spec(k, :);
    q = c{3};
    [tol, mode] = tol_rule(q);
    [rpm, thr, cname] = case_info(c{2});

    T(k).id            = c{1};
    T(k).case_id       = c{2};
    T(k).case_name     = cname;
    T(k).case_rpm      = rpm;
    T(k).case_throttle = thr;
    T(k).quantity      = q;
    T(k).name          = c{4};
    T(k).value         = c{5};
    T(k).unit          = c{6};
    T(k).printed       = c{7};
    T(k).cls           = c{8};
    T(k).role          = c{9};
    T(k).figure        = c{10};
    T(k).line          = c{11};
    T(k).conflict      = c{12};
    T(k).alt_value     = c{13};
    T(k).note          = c{14};
    T(k).tol           = tol;
    T(k).tol_mode      = mode;
    T(k).approximate   = false;
    T(k).scored        = strcmpi(c{9}, 'model');
end

if ~strcmpi(which, 'all')
    keep = strcmpi({T.case_id}, which);
    if ~any(keep)
        error('qub400_targets:badCase', ...
            'Unknown case "%s" (expected A, B, C, G, all or graph).', which);
    end
    T = T(keep);
end
end


% ---------------------------------------------------------------------------
function [tol, mode] = tol_rule(q)
%TOL_RULE  The validation brief's tolerance policy, in one place.
switch q
    case {'power', 'bmep', 'bsfc', 'pmax'}
        tol = 5;   mode = 'rel';       % 5 % of published
    case {'dr', 'se', 'te'}
        tol = 5;   mode = 'abs';       % 5 percentage points = +/-0.05
    case 'tmax'
        tol = 2;   mode = 'rel';       % 2 % of published
    otherwise
        tol = 10;  mode = 'rel';       % everything else, 10 % of published
end
end


function [rpm, thr, cname] = case_info(c)
%CASE_INFO  Operating point carried by each case id.
switch upper(c)
    case 'A', rpm = 3000; thr = 1.00; cname = 'A: 3000 rpm, full throttle';
    case 'B', rpm = 3000; thr = 0.25; cname = 'B: 3000 rpm, quarter throttle';
    case 'C', rpm = 5000; thr = 1.00; cname = 'C: 5000 rpm, full throttle';
    case 'G', rpm = NaN;  thr = NaN;  cname = 'G: engine geometry / text';
    otherwise, rpm = NaN; thr = NaN;  cname = c;
end
end


% ---------------------------------------------------------------------------
function spec = target_spec()
%TARGET_SPEC  One row per published number.
%
%  columns:
%   1 id | 2 case | 3 quantity | 4 name | 5 value | 6 unit | 7 printed
%   8 cls | 9 role | 10 figure | 11 line | 12 conflict | 13 alt | 14 note

spec = {
% ---------------------------- CASE A - Fig.5.9 ----------------------------
1  'A' 'rpm'        'Engine speed'           3000  'rev/min' '3000' ...
   'printout' 'model' 'Fig.5.9' '10402' '' NaN ...
   'Input echo; exact match expected in practice.'

2  'A' 'dr'         'Delivery ratio'         0.854 '-'       '0.854' ...
   'printout' 'model' 'Fig.5.9' '10403' ...
   'Running text 10666 says 0.851 for the same run; 0.86 at 10652 is a rounding. Printed value used.' NaN ...
   'Program output. The 0.851 text value is a separate target (id 49).'

3  'A' 'power'      'Power'                  12.2  'kW'      '12.2' ...
   'printout' 'model' 'Fig.5.9' '10404' '' NaN ''

4  'A' 'bsfc'       'BSFC'                   0.464 'kg/kWh'  '0.464 (= 464 g/kWh)' ...
   'printout' 'model' 'Fig.5.9' '10405' '' NaN ''

5  'A' 'bmep'       'BMEP'                   6.14  'bar'     '6.14' ...
   'printout' 'model' 'Fig.5.9' '10406' '' NaN ''

6  'A' 'imep'       'IMEP'                   6.72  'bar'     '6.72' ...
   'printout' 'model' 'Fig.5.9' '10407' '' NaN ''

7  'A' 'pmep'       'PMEP'                   0.38  'bar'     '0.38' ...
   'printout' 'model' 'Fig.5.9' '10408' '' NaN ''

8  'A' 'fmep'       'FMEP'                   0.21  'bar'     '0.21' ...
   'printout' 'model' 'Fig.5.9' '10409' '' NaN ...
   'Geometry gate: code law is FMEP = 100*STM*RPM = 0.21 bar exactly (src 26342).'

9  'A' 'pmax'       'Peak pressure'          35.8  'bar'     '35.8' ...
   'printout' 'model' 'Fig.5.9' '10410' ...
   'Text 10628 quotes 35.7 bar, but that is the 5000 rpm Fig.5.12 value, not this run.' NaN ...
   'Measured 36.9 bar at 5000 rpm is the Fig.5.12 EXPT column (id 47).'

10 'A' 'tmax'       'Peak temperature'       2891  'K'       '2891' ...
   'printout' 'model' 'Fig.5.9' '10410' '' NaN ''

11 'A' 'peak_angle' 'Peak-pressure angle'    16.2  'deg ATDC' '=1 (decimals lost)' ...
   'text' 'model' 'Fig.5.9' '10410 / 10634-10635' '' NaN ...
   'Printout is OCR-damaged; 16.2 deg ATDC comes from the text and is the target.'

12 'A' 'se'         'Scavenging efficiency'  0.818 '-'       '0.818' ...
   'printout' 'model' 'Fig.5.9' '10421' '' NaN ''

13 'A' 'te'         'Trapping efficiency'    0.504 '-'       '0.504' ...
   'printout' 'model' 'Fig.5.9' '10422' '' NaN ''

14 'A' 'ce'         'Charging efficiency'    0.430 '-'       '0.430' ...
   'printout' 'model' 'Fig.5.9' '10423' '' NaN ''

15 'A' 'sr'         'Scavenge ratio (mass)'  0.874 '-'       '0.874' ...
   'printout' 'model' 'Fig.5.9' '10424' '' NaN ''

16 'A' 'srv'        'Scavenge ratio (vol)'   1.134 '-'       '1.134' ...
   'printout' 'model' 'Fig.5.9' '10425' '' NaN ''

17 'A' 'efr'        'Exhaust flow ratio'     0.876 '-'       '0.876' ...
   'printout' 'model' 'Fig.5.9' '10426' '' NaN ''

% ---------------------------- CASE B - Fig.5.13 ---------------------------
18 'B' 'rpm'        'Engine speed'           3000  'rev/min' '3000' ...
   'printout' 'model' 'Fig.5.13' '10694' '' NaN 'Input echo.'

19 'B' 'dr'         'Delivery ratio'         0.491 '-'       '0.491' ...
   'printout' 'model' 'Fig.5.13' '10695' '' NaN ''

20 'B' 'power'      'Power'                  7.6   'kW'      '7.6' ...
   'printout' 'model' 'Fig.5.13' '10690' '' NaN ''

21 'B' 'bsfc'       'BSFC'                   0.426 'kg/kWh'  '0.426' ...
   'printout' 'model' 'Fig.5.13' '10696' '' NaN ''

22 'B' 'bmep'       'BMEP'                   3.85  'bar'     '3.85' ...
   'printout' 'model' 'Fig.5.13' '10697' '' NaN ''

23 'B' 'imep'       'IMEP'                   4.26  'bar'     '4.26' ...
   'printout' 'model' 'Fig.5.13' '10691' '' NaN ''

24 'B' 'pmep'       'PMEP'                   0.20  'bar'     '0.21 (figure) / 0.20 (text)' ...
   'text' 'model' 'Fig.5.13' '10698 / 10732' ...
   'Figure line reads 0.21; text 10732 says 0.20 and 4.26-0.20-0.21=3.85 reproduces BMEP exactly.' 0.21 ...
   'Primary 0.20 taken from the arithmetic; 0.21 kept as alt_value. Both inside 10 % tol.'

25 'B' 'fmep'       'FMEP'                   0.21  'bar'     '0.21' ...
   'printout' 'model' 'Fig.5.13' '10699' '' NaN 'Friction constant, speed dependent only.'

26 'B' 'pmax'       'Peak pressure'          26.6  'bar'     '26.6' ...
   'printout' 'model' 'Fig.5.13' '10700' '' NaN ''

27 'B' 'tmax'       'Peak temperature'       2545  'K'       '2545' ...
   'printout' 'model' 'Fig.5.13' '10700' '' NaN ''

28 'B' 'se'         'Scavenging efficiency'  0.64  '-'       'not legible (text: 0.64)' ...
   'text' 'model' 'Fig.5.13' '10712-10721 / 10680' ...
   'Figure SE row destroyed by OCR; only the text value 0.64 survives.' NaN ...
   'Least reliable number in either printout (checklist 6.5).'

29 'B' 'te'         'Trapping efficiency'    0.569 '-'       '0.569' ...
   'printout' 'model' 'Fig.5.13' '10722' '' NaN ''

30 'B' 'ce'         'Charging efficiency'    0.283 '-'       '0.283' ...
   'printout' 'model' 'Fig.5.13' '10723' '' NaN ''

31 'B' 'sr'         'Scavenge ratio (mass)'  0.535 '-'       '0.535' ...
   'printout' 'model' 'Fig.5.13' '10724' '' NaN ''

32 'B' 'srv'        'Scavenge ratio (vol)'   0.735 '-'       '0.735' ...
   'printout' 'model' 'Fig.5.13' '10725' '' NaN ''

33 'B' 'efr'        'Exhaust flow ratio'     0.536 '-'       '0.536' ...
   'printout' 'model' 'Fig.5.13' '10726' '' NaN ''

% ------------- CASE C - Fig.5.12, SCRE column (the port's model) ----------
34 'C' 'power'      'Power'                  12.11 'kW'      '12.11' ...
   'table' 'model' 'Fig.5.12' '10532-10538 (col 3, SCRE)' '' NaN ...
   'RPM overridden to 5000 for this table; the deck says 3000.'

35 'C' 'imep'       'IMEP'                   6.68  'bar'     '6.68' ...
   'table' 'model' 'Fig.5.12' '10541-10547 (col 3, SCRE)' '' NaN ''

36 'C' 'bmep'       'BMEP'                   6.10  'bar'     '6.10' ...
   'table' 'model' 'Fig.5.12' '10550-10556 (col 3, SCRE)' '' NaN ''

37 'C' 'bsfc'       'BSFC'                   0.463 'kg/kWh'  '463 g/kWh' ...
   'table' 'model' 'Fig.5.12' '10559-10565 (col 3, SCRE)' '' NaN ''

38 'C' 'dr'         'Delivery ratio'         0.85  '-'       '0.85' ...
   'table' 'model' 'Fig.5.12' '10567-10573 (col 3, SCRE)' '' NaN ...
   'Printed to two decimals only; 5 percentage-point tol is generous by design.'

39 'C' 'te'         'Trapping efficiency'    0.51  '-'       '0.51' ...
   'table' 'model' 'Fig.5.12' '10582-10588 (col 3, SCRE)' '' NaN ...
   'Book concedes a 15 % TE gap against measured 0.60 at this point.'

40 'C' 'pmax'       'Peak pressure'          35.7  'bar'     '35.7' ...
   'table' 'model' 'Fig.5.12' '10598-10604 (col 3, SCRE)' '' NaN ...
   'Same number as the 35.7 quoted in text 10628 - this is where it belongs.'

% ------- CASE C - Fig.5.12, EXPT column (measured bench, not scored) ------
41 'C' 'power'      'Power [measured]'       12.4  'kW'      '12.4' ...
   'table' 'reference' 'Fig.5.12' '10532-10538 (col 1, EXPT)' '' NaN ...
   'Measured. Correlation reference only - never part of the verdict.'

42 'C' 'imep'       'IMEP [measured]'        6.80  'bar'     '6.80' ...
   'table' 'reference' 'Fig.5.12' '10541-10547 (col 1, EXPT)' '' NaN 'Measured.'

43 'C' 'bmep'       'BMEP [measured]'        6.24  'bar'     '6.24' ...
   'table' 'reference' 'Fig.5.12' '10550-10556 (col 1, EXPT)' '' NaN 'Measured.'

44 'C' 'bsfc'       'BSFC [measured]'        0.437 'kg/kWh'  '437 g/kWh' ...
   'table' 'reference' 'Fig.5.12' '10559-10565 (col 1, EXPT)' '' NaN 'Measured.'

45 'C' 'dr'         'Delivery ratio [measured]' 0.85 '-'    '0.85' ...
   'table' 'reference' 'Fig.5.12' '10567-10573 (col 1, EXPT)' '' NaN 'Measured.'

46 'C' 'te'         'Trapping eff. [measured]' 0.60 '-'     '0.60' ...
   'table' 'reference' 'Fig.5.12' '10582-10588 (col 1, EXPT)' '' NaN ...
   'Measured 0.60 vs calculated 0.51 - the book''s own admitted weak point.'

47 'C' 'pmax'       'Peak pressure [measured]' 36.9 'bar'    '36.9' ...
   'table' 'reference' 'Fig.5.12' '10598-10604 (col 1, EXPT)' '' NaN ...
   'Measured 36.9 vs calculated 35.7: "corresponds precisely" (10627-10635).'

% --------------------- Text-only, Case A operating point ------------------
48 'A' 'dr'         'Delivery ratio (text 0.86)' 0.86 '-'    '0.86' ...
   'text' 'model' 'text' '10652' ...
   'Text rounds 0.854 up to 0.86; a third value for the same run.' NaN ...
   'Separate target so the 5-point absolute tolerance is shown to absorb it.'

49 'A' 'dr'         'Delivery ratio (text 0.851)' 0.851 '-'  '0.851' ...
   'text' 'model' 'text' '10666' ...
   'Directly conflicts with the 0.854 printout for the same run.' NaN ''

50 'A' 'sr'         'Scavenge ratio (text)'  0.876 '-'       '0.876' ...
   'text' 'model' 'text' '10666-10667' '' NaN 'Text restatement of the Fig.5.9 value.'

51 'A' 'efr'        'Exhaust flow ratio (text)' 0.876 '-'   '0.876' ...
   'text' 'model' 'text' '10666-10667' '' NaN 'Text restatement of the Fig.5.9 value.'

% ------------------------ Case G - text / geometry ------------------------
52 'G' 'box_ratio'  'Silencer box / Vs'     25    '-'       'twenty-five times' ...
   'text' 'model' 'text' '9835' '' NaN ...
   'Stated ratio 25; VBOX 10000 cm3 / 397.0 cm3 = 25.2. 10 % tol covers the rounding.'

53 'G' 'area_ratio' 'Outlet/inlet pipe area' 1.0  '-'       'equal' ...
   'text' 'model' 'text' '9836' '' NaN ...
   'DIA.1 = DIA.2 = 38 mm, so the area ratio must be exactly 1.0.'
};
end


% ---------------------------------------------------------------------------
function G = graph_only_targets()
%GRAPH_ONLY_TARGETS  Figure content with no printed digits.
% Deliberately carries no numeric value: nothing here can be quoted, so these
% must never become pass/fail targets. They are listed so the validation report
% states plainly what was NOT checked.

G = repmat(struct('id', 0, 'case_id', '', 'quantity', '', 'name', '', ...
    'figure', '', 'line', '', 'approximate', true, 'note', ''), 1, 5);

G(1) = struct('id', 1, 'case_id', 'A', 'quantity', 'p_trace', ...
    'name', 'Cylinder / crankcase / exhaust-port pressure ratio vs crank angle', ...
    'figure', 'Fig.5.9', 'line', '10427-10428', 'approximate', true, ...
    'note', 'Trace only; the 17 numbers printed in the same figure are scored.');

G(2) = struct('id', 2, 'case_id', 'A', 'quantity', 'se_srv_trace', ...
    'name', 'SE and SRv vs crank angle from transfer opening, SCRE/YAM6/CD', ...
    'figure', 'Fig.5.10', 'line', '10454', 'approximate', true, ...
    'note', 'No printed digits.');

G(3) = struct('id', 3, 'case_id', 'A', 'quantity', 'sr_trace', ...
    'name', 'Scavenge ratio (mass and volume) vs crank angle, SCRE/YAM6/CD', ...
    'figure', 'Fig.5.11', 'line', '10499', 'approximate', true, ...
    'note', 'No printed digits.');

G(4) = struct('id', 4, 'case_id', 'B', 'quantity', 'partload_sweep', ...
    'name', 'BMEP, BSFC, TE, SE vs throttle area ratio, 3000 rpm, SCRE & YAM6', ...
    'figure', 'Figs.7.13, 7.14', 'line', '15130-15169', 'approximate', true, ...
    'note', 'Only part-load source for THAR other than 1.0 and 0.25; graphs only.');

G(5) = struct('id', 5, 'case_id', 'A', 'quantity', 'dr_trace', ...
    'name', 'Delivery ratio vs crank angle (lower half of the 5.9 screen)', ...
    'figure', 'Fig.5.9', 'line', '10360-10362', 'approximate', true, ...
    'note', 'No printed digits.');
end
