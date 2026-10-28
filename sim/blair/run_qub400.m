function run_qub400()
%RUN_QUB400  Validation driver for a MATLAB port of Blair's Prog.5.1 (QUB 400).
%
%   run_qub400()
%
%   1. loads port/QUB400_INPUT.dat            (42 entries: 40 numeric + 2 strings)
%   2. runs the three published operating points
%        Case A  3000 rpm, THAR = 1.00, SCRE, 5th cycle   Fig.5.9
%        Case B  3000 rpm, THAR = 0.25, SCRE, 5th cycle   Fig.5.13
%        Case C  5000 rpm, THAR = 1.00, SCRE             Fig.5.12 (RPM overridden)
%   3. compares each against qub400_targets.m with check_qub400.m
%   4. always runs the checker self-test and a planted-error test
%   5. writes sim/blair/QUB400_VALIDATION.md
%
%   MODEL CONTRACT
%   If a file qub400_model.m exists on the path it is called once per case:
%
%       r = qub400_model(inp, over)
%
%       inp   struct from qub400_load_input: BO, ST, CRL, RPM, TCR, CCR, TEXC,
%             EPO..., SCAV, LEP1..., VBOX, SIL, LTP, TRAR, LIP, DIP, THAR,
%             NC, NE, BEFF, BDEG, TAF  (all in deck units: mm, bar, deg, -)
%       over  struct: case_id, rpm, throttle, scav, cycles
%             over.rpm and over.throttle OVERRIDE inp.RPM / inp.THAR
%       r     scalar struct, any of:
%               r.values.power_kW, .bsfc_kgkWh, .bmep_bar, .imep_bar,
%               .pmep_bar, .fmep_bar, .pmax_bar, .tmax_K, .peak_angle_deg,
%               .dr, .se, .te, .ce, .sr, .srv, .exhaust_flow_ratio,
%               .swept_volume_cm3, .box_volume_ratio, .pipe_area_ratio
%             Flat fields on r itself are accepted as well as fields under
%             r.values. Aliases and unit variants are listed in check_qub400.
%
%   If qub400_model.m is absent the driver still completes: it validates the
%   checker against the published values and writes a report that says the
%   physics is not present. That is deliberate - a checker that cannot pass
%   its own self-test must never be used to judge a model.

here = fileparts(mfilename('fullpath'));
addpath(here);

fprintf('\n');
fprintf('%s\n', repmat('=', 1, 101));
fprintf('QUB 400 VALIDATION HARNESS  -  Blair, The Basic Design of Two-Stroke Engines\n');
fprintf('%s\n\n', repmat('=', 1, 101));

% ------------------------------------------------------------------ 1. deck
deck = fullfile(here, '..', '..', 'port', 'QUB400_INPUT.dat');
inp  = qub400_load_input(deck);

fprintf('INPUT DECK  %s\n', inp.file);
fprintf('  %d entries: %d numeric + %d strings  (Prog.5.1 expects 40 + 2)\n', ...
    inp.n_entries, inp.n_numeric, inp.n_strings);
fprintf('  bore %.1f mm, stroke %.1f mm, rod %.1f mm, CR %.2f, CCR %.2f, TEXC %g C\n', ...
    inp.BO, inp.ST, inp.CRL, inp.TCR, inp.CCR, inp.TEXC);
fprintf('  ports: exhaust %g deg ATDC (%.1f mm wide), transfer %g deg ATDC (%d x %.1f mm)\n', ...
    inp.EPO, inp.WEP, inp.TPO, inp.NTP, inp.WTP);
fprintf('  inlet %g deg BTDC, %.1f mm;  scavenging model "%s";  A/F %g;  nc %.2f / ne %.2f\n', ...
    inp.IPO, inp.WIP, inp.SCAV, inp.TAF, inp.NC, inp.NE);
fprintf('  boxes: LEP1 %g / DEP1 %g / LEP2 %g / DEP2 %g / VBOX %g cm3, SIL "%s"\n\n', ...
    inp.LEP1, inp.DEP1, inp.LEP2, inp.DEP2, inp.VBOX, inp.SIL);

if inp.n_entries ~= 42
    warning('run_qub400:deck', 'Deck has %d entries, expected 42.', inp.n_entries);
end
if ~strcmp(inp.SCAV, 'SCRE')
    warning('run_qub400:scav', ...
        'SCAV$ is "%s". Prog.5.1 only reproduces Figs.5.9/5.13 when it is SCRE.', inp.SCAV);
end

% -------------------------------------------------------------- 2. targets
T = qub400_targets();
G = qub400_targets('graph');

% ----------------------------------------------------------------- 3. cases
cases = struct( ...
    'id',       {'A', 'B', 'C'}, ...
    'rpm',      {3000, 3000, 5000}, ...
    'throttle', {1.00, 0.25, 1.00});

% ----------------------------------------------------------------- 4. model
physics   = false;
model_err = '';
results   = [];

if exist('qub400_model', 'file') == 2
    fprintf('MODEL  qub400_model.m found - running the three cases\n');
    R = repmat(struct('case_id', '', 'rpm', NaN, 'throttle', NaN, ...
        'values', struct()), 1, numel(cases));
    try
        for k = 1:numel(cases)
            over = struct('case_id', cases(k).id, 'rpm', cases(k).rpm, ...
                'throttle', cases(k).throttle, 'scav', inp.SCAV, 'cycles', 5);
            r = qub400_model(inp, over);
            R(k) = pack_result(r, cases(k));
            fprintf('  case %s done (%.1f s)\n', cases(k).id, 0);
        end
        results = R;
        physics = true;
    catch err
        model_err = err.message;
        physics   = false;
        fprintf('  MODEL FAILED: %s\n', model_err);
    end
else
    fprintf('MODEL  qub400_model.m not found - physics not present.\n');
    fprintf('       Running the checker in self-test mode only.\n');
end
fprintf('\n');

% ------------------------------------------------------------- 5. self-test
self = check_qub400([], 'selftest', true, 'verbose', false);
neg  = check_qub400([], 'selftest', true, 'perturb', 'A:power', 'verbose', false);

self_ok = strcmp(self.verdict, 'REPRODUCE') && self.n_pass == self.n_scored;
neg_fail = neg.rows(~[neg.rows.pass] & [neg.rows.scored]);
neg_ids  = [neg_fail.id];
neg_ok   = numel(neg_ids) == 1 && neg_ids(1) == 3 && strcmp(neg.verdict, 'FAIL');

fprintf('CHECKER SELF-TEST\n');
fprintf('  published values fed back as model output : %d/%d pass, verdict %s  [%s]\n', ...
    self.n_pass, self.n_scored, self.verdict, ternary(self_ok, 'OK', 'BROKEN'));
fprintf('  planted 20%% error on case A power          : %d/%d pass, caught target %s, verdict %s  [%s]\n', ...
    neg.n_pass, neg.n_scored, mat2str(neg_ids), neg.verdict, ternary(neg_ok, 'OK', 'BROKEN'));
fprintf('\n');

% ------------------------------------------------------------- 6. real check
if physics
    out = check_qub400(results, 'verbose', true);
else
    out = check_qub400([], 'verbose', false);
end

% ---------------------------------------------------------------- 7. report
md_file = fullfile(here, 'QUB400_VALIDATION.md');
write_report(md_file, inp, T, G, self, neg, self_ok, neg_ok, out, physics, model_err, cases);

fprintf('Report written: %s\n', md_file);
fprintf('VERDICT: %s - %s\n\n', out.verdict, out.reason);
end


% ===========================================================================
function S = pack_result(r, c)
%PACK_RESULT  Normalise whatever the model returned into the checker's schema.
% One scalar struct per case with a .values struct inside, so that results(k)
% concatenation cannot fail on field-set mismatches.

v = struct();
meta = {'case_id', 'case', 'id', 'rpm', 'throttle', 'values'};

if isfield(r, 'values') && isstruct(r.values)
    v = r.values;
end

f = fieldnames(r);
for i = 1:numel(f)
    if any(strcmp(f{i}, meta))
        continue
    end
    if ~isfield(v, f{i})
        v.(f{i}) = r.(f{i});
    end
end

S = struct('case_id', c.id, 'rpm', c.rpm, 'throttle', c.throttle, 'values', v);
end


function s = ternary(cond, a, b)
if cond
    s = a;
else
    s = b;
end
end


% ===========================================================================
function write_report(fn, inp, T, G, self, neg, self_ok, neg_ok, out, physics, model_err, cases)
%WRITE_REPORT  Build QUB400_VALIDATION.md.

md = {};
md{end+1} = '# QUB 400 - validation report';
md{end+1} = '';
md{end+1} = sprintf('Generated %s by `run_qub400.m`.', datestr(now, 'yyyy-mm-dd HH:MM:SS')); %#ok<TNOW1,DATST>
md{end+1} = '';
md{end+1} = 'Reference: G.P. Blair, *The Basic Design of Two-Stroke Engines* (SAE).';
md{end+1} = 'Source line numbers (`src NNNNN`) refer to';
md{end+1} = '`references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`.';
md{end+1} = '';

% ---------------------------------------------------------------- verdict
md{end+1} = '## 1. Verdict';
md{end+1} = '';

if strcmp(out.verdict, 'REPRODUCE')
    md{end+1} = sprintf('**VERDICT: REPRODUCE** - %s.', out.reason);
elseif strcmp(out.verdict, 'CLOSE')
    md{end+1} = sprintf('**VERDICT: CLOSE** - %s.', out.reason);
else
    md{end+1} = sprintf('**VERDICT: FAIL** - %s.', out.reason);
end
md{end+1} = '';

if ~physics
    md{end+1} = 'No model output was produced this run: `qub400_model.m` is not present on the';
    md{end+1} = 'path, so none of the scored targets could be evaluated. The FAIL above is a';
    md{end+1} = 'statement about the absence of physics, not about wrong physics.';
    md{end+1} = '';
    if ~isempty(model_err)
        md{end+1} = sprintf('The model was found but raised: `%s`.', model_err);
        md{end+1} = '';
    end
    md{end+1} = 'The harness itself is validated - see sec.5. A later run with the physics in place';
    md{end+1} = 'needs no change to the checker, only to `qub400_model.m`.';
    md{end+1} = '';
end

md{end+1} = '| Metric | Value |';
md{end+1} = '|---|---|';
md{end+1} = sprintf('| Published targets defined | %d |', out.n_targets);
md{end+1} = sprintf('| Scored targets (model must reproduce) | %d |', out.n_scored);
md{end+1} = sprintf('| Reference targets (measured, not scored) | %d |', out.n_targets - out.n_scored);
md{end+1} = sprintf('| Targets reported by the model | %d of %d |', out.n_data, out.n_scored);
md{end+1} = sprintf('| Pass / fail | %d / %d |', out.n_pass, out.n_fail);
md{end+1} = sprintf('| Pass fraction | %.1f %% |', 100 * out.pass_frac);
if isfinite(out.worst_ratio)
    md{end+1} = sprintf('| Worst miss | %.2fx tolerance (target %d) |', out.worst_ratio, out.worst_id);
else
    md{end+1} = '| Worst miss | not evaluable |';
end
md{end+1} = '';

% -------------------------------------------------------------- inventory
md{end+1} = '## 2. Targets captured';
md{end+1} = '';
md{end+1} = sprintf('%d numeric targets are captured: %d are scored against the model and %d are', ...
    numel(T), sum([T.scored]), numel(T) - sum([T.scored]));
md{end+1} = 'measured reference values reported for correlation. They are all stated in text or';
md{end+1} = 'printed in a table - none is read off a graph. A further list of graph-only';
md{end+1} = sprintf('items (%d) is kept separately because no digit from them can be quoted.', numel(G));
md{end+1} = '';
md{end+1} = '| Case | Operating point | Targets | Scored | Reference | Source |';
md{end+1} = '|---|---|---:|---:|---:|---|';
labels = {'A', 'B', 'C', 'G'};
descr = { ...
    '3000 rpm, full throttle (THAR 1.0), 5th cycle', ...
    '3000 rpm, quarter throttle (THAR 0.25), 5th cycle', ...
    '5000 rpm, full throttle, SCRE column', ...
    'engine geometry / text consistency, speed independent'};
figs = {'Fig.5.9', 'Fig.5.13', 'Fig.5.12', 'text 9835-9836'};
for k = 1:numel(labels)
    sel = strcmp({T.case_id}, labels{k});
    n_t = sum(sel);
    n_s = sum(sel & [T.scored]);
    md{end+1} = sprintf('| %s | %s | %d | %d | %d | %s |', ...
        labels{k}, descr{k}, n_t, n_s, n_t - n_s, figs{k});
end
md{end+1} = sprintf('| **Total** | | **%d** | **%d** | **%d** | |', ...
    numel(T), sum([T.scored]), numel(T) - sum([T.scored]));
md{end+1} = '';

md{end+1} = 'Graph-only, flagged approximate and never scored:';
md{end+1} = '';
md{end+1} = '| # | Content | Figure | src |';
md{end+1} = '|---|---|---|---|';
for k = 1:numel(G)
    md{end+1} = sprintf('| %d | %s | %s | %s |', G(k).id, G(k).name, G(k).figure, G(k).line);
end
md{end+1} = '';

% ------------------------------------------------------------------ inputs
md{end+1} = '## 3. Input deck';
md{end+1} = '';
md{end+1} = sprintf('`QUB400_INPUT.dat` loaded: **%d entries, %d numeric + %d strings** (Prog.5.1', ...
    inp.n_entries, inp.n_numeric, inp.n_strings);
md{end+1} = 'expects 40 numeric + 2 strings; the 48-entry figure belongs to Prog.5.2).';
md{end+1} = '';
md{end+1} = '| Datum | Value |';
md{end+1} = '|---|---|';
md{end+1} = sprintf('| Bore / stroke / con-rod | %.1f / %.1f / %.1f mm |', inp.BO, inp.ST, inp.CRL);
md{end+1} = sprintf('| Trapped CR / crankcase CR | %.2f / %.2f |', inp.TCR, inp.CCR);
md{end+1} = sprintf('| Exhaust port opens / fully open | %g / %g deg ATDC |', inp.EPO, inp.EPFO);
md{end+1} = sprintf('| Transfer port opens / fully open | %g / %g deg ATDC |', inp.TPO, inp.TPFO);
md{end+1} = sprintf('| Inlet port opens / fully open | %g deg BTDC / %g deg ATDC |', inp.IPO, inp.IPFO);
md{end+1} = sprintf('| Transfer pipe / inlet pipe | %g / %g mm |', inp.LTP, inp.LIP);
md{end+1} = sprintf('| Silencer box | LEP1 %g, DEP1 %g, LEP2 %g, DEP2 %g, VBOX %g cm3, SIL "%s" |', ...
    inp.LEP1, inp.DEP1, inp.LEP2, inp.DEP2, inp.VBOX, inp.SIL);
md{end+1} = sprintf('| Combustion | nc %.2f, ne %.2f, BE %.2f, period %g deg, A/F %g |', ...
    inp.NC, inp.NE, inp.BEFF, inp.BDEG, inp.TAF);
md{end+1} = sprintf('| Scavenging model | `%s` |', inp.SCAV);
md{end+1} = '';
md{end+1} = 'Case overrides applied by the driver (the deck itself only carries one speed and one throttle):';
md{end+1} = '';
md{end+1} = '| Case | RPM | THAR | Scavenging | Cycles |';
md{end+1} = '|---|---:|---:|---|---:|';
for k = 1:numel(cases)
    md{end+1} = sprintf('| %s | %d | %.2f | %s | 5 |', ...
        cases(k).id, cases(k).rpm, cases(k).throttle, inp.SCAV);
end
md{end+1} = '';
md{end+1} = 'Case C is the Fig.5.12 table at 5000 rpm: the deck says 3000, so RPM is overridden.';
md{end+1} = 'Scavenging model No.1 (Eq. 5.1.11) is the one the book uses for all three cases';
md{end+1} = '(src 15090-15092, code comment 27728-27729); this report assumes the port uses it.';
md{end+1} = '';

% --------------------------------------------------------------- tolerance
md{end+1} = '## 4. Tolerance policy';
md{end+1} = '';
md{end+1} = '| Quantity | Tolerance |';
md{end+1} = '|---|---|';
md{end+1} = '| power, bmep, bsfc, pmax | +/-5 % of published |';
md{end+1} = '| dr, se, te | +/-5 percentage points, absolute (+/-0.05) |';
md{end+1} = '| tmax | +/-2 % of published |';
md{end+1} = '| everything else (imep, pmep, fmep, ce, sr, srv, efr, rpm, peak angle, geometry) | +/-10 % of published |';
md{end+1} = '';
md{end+1} = 'DR, SE and TE are absolute because a 5 % relative band on 0.5 would be +/-0.025,';
md{end+1} = 'which the book''s own rounding (two or three decimals) cannot support.';
md{end+1} = '';

% ---------------------------------------------------------------- selftest
md{end+1} = '## 5. Checker self-test';
md{end+1} = '';
md{end+1} = 'Two tests, both run every time. The first proves the harness plumbing is right;';
md{end+1} = 'the second proves it is not a rubber stamp.';
md{end+1} = '';
md{end+1} = '### 5.1 Positive - published values fed back as model output';
md{end+1} = '';
md{end+1} = sprintf('- Result: **%d/%d scored targets pass (%.1f %% pass), verdict `%s`** - %s.', ...
    self.n_pass, self.n_scored, 100 * self.pass_frac, self.verdict, ternary(self_ok, 'PASS', 'FAIL'));
md{end+1} = '- This exercises every field mapping, unit scale and tolerance rule with a known answer.';
md{end+1} = '- The conflict cases are exercised too: feeding the printout''s 0.854 delivery ratio';
md{end+1} = '  against the text''s 0.851 and 0.86 must pass on the +/-0.05 absolute band, and';
md{end+1} = '  feeding PMEP 0.20 against the figure''s 0.21 must pass on the +/-10 % band.';
md{end+1} = '';
md{end+1} = '### 5.2 Negative - 20 % error planted on case A power';
md{end+1} = '';
md{end+1} = sprintf('- Result: **%d/%d pass, verdict `%s`, failure(s) on target %s** - %s.', ...
    neg.n_pass, neg.n_scored, neg.verdict, mat2str([neg.rows(~[neg.rows.pass] & [neg.rows.scored]).id]), ...
    ternary(neg_ok, 'PASS', 'FAIL'));
md{end+1} = '- The checker must flag exactly the planted target and nothing else. A checker that';
md{end+1} = '  still reports 100 % here would be measuring nothing.';
md{end+1} = '';
md{end+1} = sprintf('Self-test status: **%s**', ternary(self_ok && neg_ok, 'PASS', 'FAIL'));
md{end+1} = '';

% ------------------------------------------------------------ model result
md{end+1} = '## 6. Model vs published';
md{end+1} = '';

if ~physics
    md{end+1} = 'No model result to show. All scored targets are recorded as `NODATA` below, so the';
    md{end+1} = 'tables double as the specification the port has to satisfy.';
    md{end+1} = '';
end

case_ids = unique({out.rows.case_id}, 'stable');
for c = 1:numel(case_ids)
    md = [md, md_case(out, case_ids{c})]; %#ok<AGROW>
end

% --------------------------------------------------------------- conflicts
md{end+1} = '## 7. Book-internal conflicts (recorded, not resolved)';
md{end+1} = '';
md{end+1} = 'The published values are transcribed as printed. Where the book contradicts itself,';
md{end+1} = 'both numbers are kept as targets and the tolerance absorbs the difference.';
md{end+1} = '';
md{end+1} = '| Quantity | Case | Primary | Alternative | Treatment |';
md{end+1} = '|---|---|---|---|---|';
md{end+1} = '| Delivery ratio | A | **0.854** (printout 10403) | **0.851** (text 10666), **0.86** (text 10652) | All three are targets (ids 2, 48, 49). +/-0.05 absolute covers a 0.009 spread. |';
md{end+1} = '| PMEP | B | **0.20** (text 10732) | **0.21** (figure 10698) | 0.20 chosen because 4.26 - 0.20 - 0.21 = 3.85 reproduces the printed BMEP exactly; 0.21 kept as `alt_value`; +/-10 % covers both. |';
md{end+1} = '| Peak pressure | A vs C | **35.8** (3000 rpm, 10410) | **35.7** (5000 rpm, 10628/10598) | Not a conflict - different operating points. Both kept; the 0.1 bar coincidence is a trap. |';
md{end+1} = '| Scavenging efficiency | B | **0.64** (text 10680) | figure row destroyed (10712-10721) | Single surviving source; flagged as the least reliable number in either printout. |';
md{end+1} = '| Trapping efficiency | C | **0.51** calculated | **0.60** measured | 15 % apart, conceded by the book (10582-10584). Only the calculated value is scored; the measured one is a reference row. |';
md{end+1} = '';
md{end+1} = 'Two further source defects are carried in the data rather than "fixed":';
md{end+1} = '';
md{end+1} = '- Peak-pressure angle in Fig.5.9 prints as `=1` (decimals lost). The target is 16.2 deg ATDC from';
md{end+1} = '  the text at 10634-10635 (id 11).';
md{end+1} = '- Fig.5.12 SEFF and CEFF rows each lost one of seven values and cannot be re-assigned. They';
md{end+1} = '  are deliberately **not** targets; scavenging efficiency is validated on Cases A and B only.';
md{end+1} = '';

% --------------------------------------------------------------- procedure
md{end+1} = '## 8. How to read the verdict';
md{end+1} = '';
md{end+1} = '| Verdict | Condition |';
md{end+1} = '|---|---|';
md{end+1} = '| `REPRODUCE` | every scored target is inside its tolerance |';
md{end+1} = '| `CLOSE` | at least 80 % of scored targets pass, and no target is further than 2x its tolerance from the published value |';
md{end+1} = '| `FAIL` | otherwise, or no model output at all |';
md{end+1} = '';
md{end+1} = 'The verdict is computed on scored targets only. Reference rows (the Fig.5.12 EXPT';
md{end+1} = 'column) are printed with their error but never change the verdict - the model is';
md{end+1} = 'judged against what the book''s program calculated, and correlated against what was';
md{end+1} = 'measured.';
md{end+1} = '';
md{end+1} = 'If the geometry gate fails (FMEP != 100*STM*RPM, or swept volume != 397.0 cm3) the';
md{end+1} = 'reason line says so: the deck or the units are wrong and no downstream channel means';
md{end+1} = 'anything (QUB400_CHECKLIST.md sec.7).';
md{end+1} = '';

% ------------------------------------------------------------------- files
md{end+1} = '## 9. Files';
md{end+1} = '';
md{end+1} = '| File | Role |';
md{end+1} = '|---|---|';
md{end+1} = '| `qub400_targets.m` | the 53 published targets + the graph-only list |';
md{end+1} = '| `check_qub400.m` | comparison, tolerances, self-test, verdict |';
md{end+1} = '| `qub400_load_input.m` | parses the 42-entry deck into a struct |';
md{end+1} = '| `run_qub400.m` | driver; writes this report |';
md{end+1} = '| `qub400_model.m` | the port - **not present yet** |';
md{end+1} = '';
md{end+1} = '## 10. Not checked';
md{end+1} = '';
md{end+1} = 'The five graph-only figures listed in sec.2, plus everything the book does not state:';
md{end+1} = 'torque, swept volume as a printed number, clearance volume, crankcase volume,';
md{end+1} = 'absolute air and fuel mass flows, measured exhaust temperature, and ignition timing.';
md{end+1} = 'TE at 5000 rpm is the book''s own admitted weak point (calculated 0.51 vs measured';
md{end+1} = '0.60); a 15 % TE discrepancy there is expected, not a porting bug.';
md{end+1} = '';

fid = fopen(fn, 'w');
if fid < 0
    error('run_qub400:write', 'Cannot write %s', fn);
end
fprintf(fid, '%s\n', md{:});
fclose(fid);
end


% ---------------------------------------------------------------------------
function md = md_case(out, cid)
%MD_CASE  One markdown table for one operating case.

rows = out.rows(strcmp({out.rows.case_id}, cid));
switch upper(cid)
    case 'A'
        head = '### Case A - 3000 rpm, full throttle (THAR 1.0), 5th cycle  [Fig.5.9]';
    case 'B'
        head = '### Case B - 3000 rpm, quarter throttle (THAR 0.25), 5th cycle  [Fig.5.13]';
    case 'C'
        head = '### Case C - 5000 rpm, full throttle, SCRE column  [Fig.5.12]';
    otherwise
        head = '### Case G - engine geometry and text consistency';
end

md = {head, ''};

if strcmpi(cid, 'C')
    md{end+1} = 'Measured **EXPT** rows are marked `REF` and are not scored.';
    md{end+1} = '';
end

md{end+1} = '| # | Quantity | Model | Published | Diff | %Err | Tolerance | Status | src |';
md{end+1} = '|---:|---|---:|---:|---:|---:|---|---|---|';

for k = 1:numel(rows)
    r = rows(k);
    md{end+1} = sprintf('| %d | %s | %s | %s | %s | %s | %s | **%s** | %s |', ...
        r.id, r.name, num_or_dash(r.model, 5), pub_display(r), ...
        num_or_dash(r.diff, 4, true), pct_or_dash(r.pct), ...
        r.tol_txt, r.status, r.line);
end
md{end+1} = '';

% footnotes for conflicts and provenance
noted = false;
for k = 1:numel(rows)
    r = rows(k);
    if ~isempty(r.conflict) || ~isempty(r.note) && contains(lower(r.note), 'gate')
        if ~noted
            md{end+1} = 'Notes:';
            md{end+1} = '';
            noted = true;
        end
        if ~isempty(r.conflict) && isfinite(r.alt_value)
            md{end+1} = sprintf('- **%s (id %d)**: %s (alternative %.4g).', ...
                r.name, r.id, r.conflict, r.alt_value);
        elseif ~isempty(r.conflict)
            md{end+1} = sprintf('- **%s (id %d)**: %s', r.name, r.id, r.conflict);
        else
            md{end+1} = sprintf('- **%s (id %d)**: %s', r.name, r.id, r.note);
        end
    end
end
if noted
    md{end+1} = '';
end
end


function s = pub_display(r)
%PUB_DISPLAY  The published value exactly as printed, with units when needed.
s = r.printed;
if isempty(s)
    s = num_or_dash(r.published, 5);
end
if ~strcmp(r.unit, '-') && ~any(isletter(s))
    s = [s ' ' r.unit];
end
end


function s = num_or_dash(v, sig, signed)
if nargin < 3
    signed = false;
end
if ~isfinite(v)
    s = '-';
elseif signed
    s = sprintf('%+.*g', sig, v);
else
    s = sprintf('%.*g', sig, v);
end
end


function s = pct_or_dash(v)
if ~isfinite(v)
    s = '-';
else
    s = sprintf('%+.2f', v);
end
end
