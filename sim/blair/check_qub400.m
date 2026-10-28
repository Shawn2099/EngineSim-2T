function out = check_qub400(results, varargin)
%CHECK_QUB400  Compare a QUB 400 model run against Blair's published results.
%
%   out = check_qub400(results)
%   out = check_qub400(results, 'verbose', false)
%   out = check_qub400([], 'selftest', true)                 % must be 100 %
%   out = check_qub400([], 'selftest', true, 'perturb', 'A:power')
%
% RESULTS is a struct array, one element per operating case:
%
%   results(k).case_id   'A' | 'B' | 'C'   (also accepts .case or .id)
%   results(k).rpm       case speed, informational
%   results(k).throttle  throttle area ratio, informational
%   results(k).values    struct of canonical fields (preferred)
%
% Canonical fields (flat fields on results(k) are accepted too):
%
%   rpm  dr  power_kW  bsfc_kgkWh  bmep_bar  imep_bar  pmep_bar  fmep_bar
%   pmax_bar  tmax_K  peak_angle_deg  se  te  ce  sr  srv
%   exhaust_flow_ratio  swept_volume_cm3  box_volume_ratio  pipe_area_ratio
%
% Aliases and unit variants are accepted - e.g. bsfc_g_kWh is divided by 1000,
% power_kw and power are both understood. See field_aliases().
%
% TOLERANCES (fixed by the validation brief)
%   power, bmep, bsfc, pmax   +/-5 % of published
%   dr, se, te                +/-5 percentage points, absolute (+/-0.05)
%   tmax                      +/-2 % of published
%   everything else           +/-10 % of published
%
% VERDICT
%   REPRODUCE  every scored target passes
%   CLOSE      >= 80 % of scored targets pass AND no target is further than
%              2x its tolerance from the published value
%   FAIL       otherwise, or no model output at all
%
% Targets with role 'reference' are measured bench data (the Fig.5.12 EXPT
% column). They are printed for correlation but never scored and never affect
% the verdict.
%
% 'selftest' synthesises a result set from the published values themselves and
% checks it. A perfect score proves the plumbing (field mapping, unit scaling,
% absolute vs relative tolerance, score aggregation) is correct before any
% physics is trusted. 'perturb' then plants a known error - e.g. 'A:power'
% scales case A power by 1.20 - and the checker must catch exactly that one
% target, which proves it is not a rubber stamp.

opts.selftest = false;
opts.verbose  = true;
opts.perturb  = '';

for k = 1:2:numel(varargin)
    name = lower(varargin{k});
    switch name
        case 'selftest', opts.selftest = logical(varargin{k+1});
        case 'verbose',  opts.verbose  = logical(varargin{k+1});
        case 'perturb',  opts.perturb  = char(varargin{k+1});
        otherwise
            error('check_qub400:opt', 'Unknown option "%s".', name);
    end
end

T = qub400_targets();

if opts.selftest
    results = synth_results(T, opts.perturb);
end

if opts.verbose
    print_policy();
end

% ------------------------------------------------------------------ compare
n = numel(T);

rows = repmat(struct( ...
    'id', 0, 'case_id', '', 'quantity', '', 'name', '', 'model', NaN, ...
    'published', 0, 'printed', '', 'unit', '', 'diff', NaN, 'pct', NaN, ...
    'tol_txt', '', 'tol_units', NaN, 'ratio', NaN, 'pass', false, ...
    'scored', false, 'status', '', 'role', '', 'conflict', '', ...
    'alt_value', NaN, 'figure', '', 'line', '', 'note', ''), 1, n);

if isempty(results)
    cids = {};
else
    cids = arrayfun(@(r) get_case_id(r), results, 'UniformOutput', false);
end

for k = 1:n
    t = T(k);
    [mval, have] = lookup_value(results, cids, t);

    r = rows(k);
    r.id        = t.id;
    r.case_id   = t.case_id;
    r.quantity  = t.quantity;
    r.name      = t.name;
    r.model     = mval;
    r.published = t.value;
    r.printed   = t.printed;
    r.unit      = t.unit;
    r.scored    = t.scored;
    r.role      = t.role;
    r.conflict  = t.conflict;
    r.alt_value = t.alt_value;
    r.figure    = t.figure;
    r.line      = t.line;
    r.note      = t.note;

    if strcmpi(t.tol_mode, 'abs')
        tol_u = t.tol / 100;                       % 5 -> 0.05 in own units
        r.tol_txt = sprintf('+/-%.3f abs', tol_u);
    else
        tol_u = abs(t.value) * t.tol / 100;
        r.tol_txt = sprintf('+/-%.1f%%', t.tol);
    end
    r.tol_units = tol_u;

    if ~have || ~isfinite(mval)
        r.status = 'NODATA';
        r.pass   = false;
    else
        r.diff = mval - t.value;
        if t.value ~= 0
            r.pct = 100 * r.diff / abs(t.value);
        else
            r.pct = NaN;
        end
        if tol_u > 0
            r.ratio = abs(r.diff) / tol_u;
        end
        r.pass = abs(r.diff) <= tol_u;
        if ~t.scored
            r.status = 'REF';
        elseif r.pass
            r.status = 'PASS';
        else
            r.status = 'FAIL';
        end
    end

    rows(k) = r;
end

% ------------------------------------------------------------------- scores
scored   = [rows.scored];
have_dat = scored & isfinite([rows.model]);
n_scored = sum(scored);
n_pass   = sum([rows.pass] & scored);
n_fail   = n_scored - n_pass;
n_data   = sum(have_dat);

frac = 0;
if n_scored > 0
    frac = n_pass / n_scored;
end

ratios = [rows.ratio];
ratios = ratios(scored & isfinite(ratios));
if isempty(ratios)
    worst_ratio = Inf;
    worst_id    = NaN;
else
    [worst_ratio, imax] = max(ratios);
    idx = find(scored & isfinite([rows.ratio]));
    worst_id = rows(idx(imax)).id;
end

% geometry gate (checklist section 7): FMEP and swept volume must hold before
% anything downstream is meaningful
gate_fail = false;
for k = 1:n
    if any(strcmp(rows(k).quantity, {'fmep', 'vs'})) && rows(k).scored ...
            && isfinite(rows(k).model) && ~rows(k).pass
        gate_fail = true;
    end
end

if n_scored == 0
    verdict = 'FAIL';
    reason  = 'no scored targets defined';
elseif n_data == 0
    verdict = 'FAIL';
    reason  = sprintf('no model output for any of the %d scored targets', n_scored);
elseif n_pass == n_scored
    verdict = 'REPRODUCE';
    reason  = sprintf('%d/%d scored targets within tolerance (100.0%%)', n_pass, n_scored);
elseif frac >= 0.80 && worst_ratio <= 2.0
    verdict = 'CLOSE';
    reason  = sprintf('%d/%d pass (%.1f%%), worst miss %.2fx tolerance (target %d)', ...
        n_pass, n_scored, 100 * frac, worst_ratio, worst_id);
else
    verdict = 'FAIL';
    reason  = sprintf('%d/%d pass (%.1f%%), worst miss %.2fx tolerance (target %d)', ...
        n_pass, n_scored, 100 * frac, worst_ratio, worst_id);
end

if gate_fail
    reason = [reason '; geometry gate failed (FMEP/swept volume) - check deck and units first'];
end

% -------------------------------------------------------------------- print
if opts.verbose
    case_ids = unique({rows.case_id}, 'stable');
    for c = 1:numel(case_ids)
        cid = case_ids{c};
        sel = strcmp({rows.case_id}, cid);
        sub = rows(sel);
        print_case(cid, sub);
    end
    print_summary(rows, n_scored, n_pass, n_fail, n_data, frac, worst_ratio, worst_id, verdict, reason);
end

% --------------------------------------------------------------------- out
out = struct();
out.rows        = rows;
out.verdict     = verdict;
out.reason      = reason;
out.n_targets   = n;
out.n_scored    = n_scored;
out.n_pass      = n_pass;
out.n_fail      = n_fail;
out.n_data      = n_data;
out.pass_frac   = frac;
out.worst_ratio = worst_ratio;
out.worst_id    = worst_id;
out.gate_fail   = gate_fail;
out.selftest    = opts.selftest;
out.perturb     = opts.perturb;
out.generated   = datestr(now, 'yyyy-mm-dd HH:MM:SS'); %#ok<TNOW1,DATST>
out.by_case     = by_case(rows);
end


% ===========================================================================
function print_policy()
fprintf('\n');
fprintf('TOLERANCE POLICY\n');
fprintf('  power, bmep, bsfc, pmax   +/-5%% of published\n');
fprintf('  dr, se, te                +/-5 percentage points, absolute (+/-0.05)\n');
fprintf('  tmax                      +/-2%% of published\n');
fprintf('  every other quantity      +/-10%% of published\n');
fprintf('\n');
end


function print_case(cid, rows)
[~, rpm, thr, label] = case_meta(cid);
fprintf('%s\n', label);
if ~isnan(rpm)
    fprintf('  %s, throttle area ratio %.2f, %d targets\n', ...
        sprintf('%g rpm', rpm), thr, numel(rows));
else
    fprintf('  %d targets\n', numel(rows));
end
fprintf('   #  Cs  %-23s %10s %10s %7s %9s %8s  %-12s %s\n', ...
    'Quantity', 'Model', 'Published', 'Unit', 'Diff', '%Err', 'Tolerance', 'Status');
fprintf('  %s\n', repmat('-', 1, 99));

for k = 1:numel(rows)
    r = rows(k);
    fprintf('  %3d  %-2s  %-23s %10s %10s %7s %9s %8s  %-12s %s\n', ...
        r.id, r.case_id, r.name, fmtnum(r.model, 10), fmtnum(r.published, 10), ...
        unit_disp(r.unit), fmtdiff(r.diff), fmtpct(r.pct), r.tol_txt, r.status);
end
fprintf('\n');
end


function print_summary(rows, n_scored, n_pass, n_fail, n_data, frac, worst_ratio, worst_id, verdict, reason)
fprintf('%s\n', repmat('=', 1, 101));
fprintf('SUMMARY\n');
fprintf('  targets defined        : %d\n', numel(rows));
fprintf('  scored (model)         : %d\n', n_scored);
fprintf('  reference (measured)   : %d  (reported only, not scored)\n', ...
    numel(rows) - n_scored);
fprintf('  reported by the model  : %d of %d\n', n_data, n_scored);
fprintf('  pass / fail            : %d / %d  (%.1f %% pass)\n', ...
    n_pass, n_fail, 100 * frac);

bc = by_case(rows);
for k = 1:numel(bc)
    fprintf('    case %-2s : %2d/%-2d pass\n', bc(k).case_id, bc(k).n_pass, bc(k).n_scored);
end

if isfinite(worst_ratio)
    w = rows([rows.id] == worst_id);
    fprintf('  worst miss             : target %d (%s, case %s) %.3g vs %.3g %s = %+.1f %%, %.2fx tolerance\n', ...
        w.id, w.name, w.case_id, w.model, w.published, unit_disp(w.unit), w.pct, worst_ratio);
end

% conflicts the tolerance is absorbing
fprintf('\n  book-internal conflicts carried as data:\n');
shown = false;
for k = 1:numel(rows)
    if ~isempty(rows(k).conflict) && isfinite(rows(k).alt_value)
        fprintf('    target %d (%s, case %s): %.4g primary, %.4g alternative - %s\n', ...
            rows(k).id, rows(k).name, rows(k).case_id, rows(k).published, ...
            rows(k).alt_value, rows(k).conflict);
        shown = true;
    end
end
if ~shown
    fprintf('    (none with a numeric alternative)\n');
end
fprintf('%s\n', repmat('=', 1, 101));
fprintf('VERDICT: %s - %s\n', verdict, reason);
fprintf('%s\n\n', repmat('=', 1, 101));
end


% ===========================================================================
function [mval, have] = lookup_value(results, cids, t)
%LOOKUP_VALUE  Pull one quantity out of the result set.
mval = NaN;
have = false;
if isempty(results)
    return
end

idx = find(strcmpi(cids, t.case_id));
if isempty(idx) && strcmpi(t.case_id, 'G')
    idx = 1:numel(results);        % engine geometry is speed independent
end

for i = idx
    [v, ok] = get_value(results(i), t.quantity);
    if ok
        mval = v;
        have = true;
        return
    end
end
end


function [v, ok] = get_value(r, q)
v  = NaN;
ok = false;
a  = field_aliases(q);

src = {};
if isfield(r, 'values') && isstruct(r.values)
    src{end+1} = r.values;
end
src{end+1} = r;

for s = 1:numel(src)
    for i = 1:size(a, 1)
        if isfield(src{s}, a{i, 1})
            v  = double(src{s}.(a{i, 1})) * a{i, 2};
            ok = isfinite(v);
            if ok
                return
            end
        end
    end
end
end


function a = field_aliases(q)
%FIELD_ALIASES  Accepted model field names and their scale to canonical units.
switch q
    case 'rpm'
        a = {'rpm', 1; 'engine_speed_rpm', 1; 'speed_rpm', 1};
    case 'dr'
        a = {'dr', 1; 'delivery_ratio', 1};
    case 'power'
        a = {'power_kW', 1; 'power_kw', 1; 'power', 1; 'power_W', 1e-3};
    case 'bsfc'
        a = {'bsfc_kgkWh', 1; 'bsfc_kgkwh', 1; 'bsfc', 1; ...
             'bsfc_gkWh', 1e-3; 'bsfc_g_kWh', 1e-3; 'bsfc_gkwh', 1e-3};
    case 'bmep'
        a = {'bmep_bar', 1; 'bmep', 1};
    case 'imep'
        a = {'imep_bar', 1; 'imep', 1};
    case 'pmep'
        a = {'pmep_bar', 1; 'pmep', 1};
    case 'fmep'
        a = {'fmep_bar', 1; 'fmep', 1};
    case 'pmax'
        a = {'pmax_bar', 1; 'pmax', 1; 'peak_pressure_bar', 1; 'peak_pressure', 1};
    case 'tmax'
        a = {'tmax_K', 1; 'tmax', 1; 'peak_temperature_K', 1; 'peak_temperature', 1};
    case 'peak_angle'
        a = {'peak_angle_deg', 1; 'peak_angle', 1; ...
             'peak_pressure_angle_deg', 1; 'peak_pressure_angle', 1};
    case 'se'
        a = {'se', 1; 'scavenging_efficiency', 1};
    case 'te'
        a = {'te', 1; 'trapping_efficiency', 1};
    case 'ce'
        a = {'ce', 1; 'charging_efficiency', 1};
    case 'sr'
        a = {'sr', 1; 'scavenge_ratio_mass', 1; 'scavenge_ratio', 1};
    case 'srv'
        a = {'srv', 1; 'scavenge_ratio_volume', 1; 'sr_volume', 1};
    case 'efr'
        a = {'exhaust_flow_ratio', 1; 'efr', 1};
    case 'vs'
        a = {'swept_volume_cm3', 1; 'vs_cm3', 1; 'swept_volume', 1};
    case 'box_ratio'
        a = {'box_volume_ratio', 1; 'box_ratio', 1};
    case 'area_ratio'
        a = {'pipe_area_ratio', 1; 'outlet_inlet_area_ratio', 1; 'area_ratio', 1};
    otherwise
        a = {q, 1};
end
end


function fn = canonical_field(q)
a  = field_aliases(q);
fn = a{1, 1};
end


function cid = get_case_id(r)
if isfield(r, 'case_id')
    cid = char(r.case_id);
elseif isfield(r, 'case')
    cid = char(r.case);
elseif isfield(r, 'id') && (ischar(r.id) || isstring(r.id))
    cid = char(r.id);
else
    cid = '';
end
end


% ===========================================================================
function R = synth_results(T, perturb)
%SYNTH_RESULTS  Feed the published values back in as if they were model output.
% This is what makes the self-test meaningful: every field mapping, unit scale
% and tolerance rule is exercised on data whose right answer is known.

case_ids = {'A', 'B', 'C', 'G'};

R = repmat(struct('case_id', '', 'rpm', NaN, 'throttle', NaN, ...
    'values', struct()), 1, numel(case_ids));

for k = 1:numel(case_ids)
    c    = case_ids{k};
    sel  = T(strcmp({T.case_id}, c) & [T.scored]);
    vals = struct();
    for j = 1:numel(sel)
        vals.(canonical_field(sel(j).quantity)) = sel(j).value;
    end
    R(k).case_id = c;
    if ~isempty(sel)
        R(k).rpm      = sel(1).case_rpm;
        R(k).throttle = sel(1).case_throttle;
    end
    R(k).values = vals;
end

if ~isempty(perturb)
    parts = strsplit(perturb, ':');
    if numel(parts) ~= 2
        error('check_qub400:perturb', 'perturb must look like ''A:power''.');
    end
    cid = upper(parts{1});
    q   = lower(parts{2});
    hit = false;
    for k = 1:numel(R)
        if strcmpi(R(k).case_id, cid)
            fn = canonical_field(q);
            if isfield(R(k).values, fn)
                R(k).values.(fn) = R(k).values.(fn) * 1.20;   % plant a 20 % error
                hit = true;
            end
        end
    end
    if ~hit
        error('check_qub400:perturb', 'Could not plant an error on %s.', perturb);
    end
end
end


% ===========================================================================
function bc = by_case(rows)
ids = unique({rows.case_id}, 'stable');
bc  = repmat(struct('case_id', '', 'n_targets', 0, 'n_scored', 0, ...
    'n_pass', 0, 'n_fail', 0), 1, numel(ids));
for k = 1:numel(ids)
    sel = strcmp({rows.case_id}, ids{k});
    bc(k).case_id   = ids{k};
    bc(k).n_targets = sum(sel);
    bc(k).n_scored  = sum(sel & [rows.scored]);
    bc(k).n_pass    = sum(sel & [rows.scored] & [rows.pass]);
    bc(k).n_fail    = bc(k).n_scored - bc(k).n_pass;
end
end


function [name, rpm, thr, label] = case_meta(cid)
switch upper(cid)
    case 'A'
        rpm = 3000; thr = 1.00;
        name = 'Case A';
        label = 'CASE A - 3000 rpm, full throttle (THAR = 1.0), 5th cycle, SCRE  [Fig.5.9]';
    case 'B'
        rpm = 3000; thr = 0.25;
        name = 'Case B';
        label = 'CASE B - 3000 rpm, quarter throttle (THAR = 0.25), 5th cycle, SCRE  [Fig.5.13]';
    case 'C'
        rpm = 5000; thr = 1.00;
        name = 'Case C';
        label = 'CASE C - 5000 rpm, full throttle, SCRE column  [Fig.5.12; RPM overridden from 3000]';
    case 'G'
        rpm = NaN; thr = NaN;
        name = 'Case G';
        label = 'CASE G - engine geometry and text consistency (speed independent)';
    otherwise
        rpm = NaN; thr = NaN;
        name = cid;
        label = sprintf('CASE %s', cid);
end
end


function s = fmtnum(v, w)
if ~isfinite(v)
    s = sprintf('%*s', w, '-');
else
    s = sprintf('%*.*g', w, 5, v);
end
end


function s = fmtdiff(v)
if ~isfinite(v)
    s = sprintf('%9s', '-');
else
    s = sprintf('%+9.4g', v);
end
end


function s = fmtpct(v)
if ~isfinite(v)
    s = sprintf('%8s', '-');
else
    s = sprintf('%+8.2f', v);
end
end


function s = unit_disp(u)
%UNIT_DISP  Blank out the placeholder unit for dimensionless quantities.
if isempty(u) || strcmp(u, '-')
    s = '';
else
    s = u;
end
end
