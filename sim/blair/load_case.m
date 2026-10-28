function [case_data, meta] = load_case(casepath)
%LOAD_CASE  Read and validate a Blair Prog.5.1 case file.
%
%   CASE = LOAD_CASE()          reads the reference QUB 400 deck (CONFIG below).
%   CASE = LOAD_CASE(PATH)      reads PATH.
%   [CASE, META] = LOAD_CASE(..) also returns provenance: the source path,
%                               the line number of every value, and any
%                               non-fatal warnings.
%
%   FILE FORMAT
%     One VALUE per line. Everything from the first '!' to end of line is a
%     comment, so blank lines and comment-only lines are ignored. The
%     reference deck annotates each line as
%
%         VALUE ! NAME ! UNIT ! source-line-number
%
%     and that NAME column is cross-checked against the expected prompt
%     order. This matters: the deck is in *program prompt* order, which is
%     NOT the order of Fig.5.3 in Blair. Copying Fig.5.3 top-to-bottom
%     silently shifts TCR/CCR/TEXC and the last five combustion values.
%     See port/INPUT_FORMAT.md section 2.
%
%   RETURNED STRUCT (42 fields, Prog.5.1 prompt order)
%     BO ST CRL RPM TCR CCR TEXC                       engine
%     EPO EPFO NEP WEP RTE RBE                         exhaust port
%     TPO TPFO NTP WTP RTT RBT SCAV                    transfer port
%     IPO IPFO NIP WIP RTI RBI                         inlet port
%     LEP1 DEP1 LEP2 DEP2 VBOX SIL                     exhaust box silencer
%     LTP TRAR                                         transfer duct
%     LIP DIP THAR                                     inlet duct + load
%     NC NE BEFF BDEG TAF                              closed cycle
%
%   UNITS are as typed by the user: mm, deg crank, rev/min, cm^3, degC.
%   Two string fields are normalised:
%     SCAV  one of UNIFLOW | SCRE | YAM1 | YAM6 | CD | QUBCR (upper case)
%     SIL   'PLAIN BOX' (answer N) or 'ABSORPTION' (answer Y)
%
%   ERRORS are raised as blair:load_case:* and list EVERY offending line at
%   once, rather than stopping at the first one.
%
%   See also BLAIR_INIT, SWEEP.

% -------------------------------------------------------------------------
% CONFIG - the only place in this file where a path appears.
% -------------------------------------------------------------------------
CONFIG = struct();
CONFIG.default_case = 'C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat';
CONFIG.n_fields     = 42;
CONFIG.name_check   = true;   % cross-check the "! NAME !" comment column
CONFIG.strict_names = false;  % true = a name mismatch is an error, not a warning

% -------------------------------------------------------------------------
% 0. Input and file access
% -------------------------------------------------------------------------
if nargin < 1 || isempty(casepath)
    casepath = CONFIG.default_case;
end
if ~(ischar(casepath) || isstring(casepath))
    error('blair:load_case:badInput', ...
        'casepath must be a char row vector or a string, got %s.', class(casepath));
end
casepath = char(casepath);
if exist(casepath, 'file') ~= 2
    error('blair:load_case:notFound', ...
        ['Case file not found:\n  %s\n' ...
         'Pass an explicit path, or edit CONFIG.default_case at the top of %s.'], ...
        casepath, mfilename);
end

% -------------------------------------------------------------------------
% 1. Parse the line-oriented deck
% -------------------------------------------------------------------------
txt   = fileread(casepath);
lines = regexp(txt, '\r\n|\n|\r', 'split');

values  = cell(1, max(0, CONFIG.n_fields));
linenum = zeros(1, max(0, CONFIG.n_fields));
cmtname = cell(1, max(0, CONFIG.n_fields));
nval    = 0;

for k = 1:numel(lines)
    raw = lines{k};
    bang = find(raw == '!', 1);
    if isempty(bang)
        valpart = raw;
        cmt     = '';
    else
        valpart = raw(1:bang-1);
        cmt     = raw(bang+1:end);
    end

    v = strtrim(valpart);
    if isempty(v)
        continue    % blank line, or a comment-only line
    end

    nval = nval + 1;
    values{nval}  = local_unquote(v);
    linenum(nval) = k;
    cmtname{nval} = local_comment_name(cmt);
end

% -------------------------------------------------------------------------
% 2. Presence check - report every missing field, in prompt order
% -------------------------------------------------------------------------
S = local_field_spec();
if nval < numel(S)
    missing = {S(nval+1:end).name};
    error('blair:load_case:missingFields', ...
        ['Case file is incomplete.\n' ...
         '  File:    %s\n' ...
         '  Found:   %d value(s)\n' ...
         '  Required: %d (Prog.5.1 prompt order)\n' ...
         '  Missing: %s\n' ...
         'Each of the 42 inputs must be present, one VALUE per line.'], ...
        casepath, nval, numel(S), strjoin(missing, ', '));
end

n_ignored = nval - numel(S);

% -------------------------------------------------------------------------
% 3. Convert and range-check every field
% -------------------------------------------------------------------------
errs  = {};
warns = {};

case_data = struct();
for i = 1:numel(S)
    f   = S(i);
    raw = values{i};

    if strcmp(f.kind, 'num')
        v = str2double(raw);
        if isnan(v) || ~isreal(v)
            errs{end+1} = sprintf('line %d: %-5s = "%s" is not a number', ...
                linenum(i), f.name, raw); %#ok<AGROW>
            case_data.(f.name) = NaN;
            continue
        end
        if v < f.lo || v > f.hi
            errs{end+1} = sprintf('line %d: %-5s = %g %s is outside the valid range [%g, %g] %s', ...
                linenum(i), f.name, v, f.unit, f.lo, f.hi, f.unit); %#ok<AGROW>
        end
        case_data.(f.name) = v;
    else
        [v, ok, why] = local_string_field(f.name, raw);
        if ~ok
            errs{end+1} = sprintf('line %d: %s', linenum(i), why); %#ok<AGROW>
        end
        case_data.(f.name) = v;
    end
end

% -------------------------------------------------------------------------
% 4. Cross-field consistency (only meaningful if every value parsed)
% -------------------------------------------------------------------------
[cerr, cwarn] = local_cross_checks(case_data);
errs  = [errs,  cerr];
warns = [warns, cwarn];

% -------------------------------------------------------------------------
% 5. Cross-check the "! NAME !" comment column against prompt order
% -------------------------------------------------------------------------
if CONFIG.name_check
    ncmp = min(nval, numel(S));
    for i = 1:ncmp
        nm = local_norm_name(cmtname{i});
        if isempty(nm)
            continue    % no name in the comment; nothing to check
        end
        if ~strcmp(nm, local_norm_name(S(i).name))
            msg = sprintf(['line %d: comment names "%s" but prompt position %d is %s ' ...
                           '(possible field-order shift)'], ...
                          linenum(i), cmtname{i}, i, S(i).name);
            if CONFIG.strict_names
                errs{end+1} = msg; %#ok<AGROW>
            else
                warns{end+1} = msg; %#ok<AGROW>
            end
        end
    end
end

% -------------------------------------------------------------------------
% 6. Report
% -------------------------------------------------------------------------
if ~isempty(errs)
    msg = sprintf('Case file rejected: %s\n', casepath);
    msg = [msg, sprintf('  - %s\n', errs{:})];
    msg = [msg, sprintf('\nExpected %d values in Prog.5.1 prompt order; see port/INPUT_FORMAT.md.', ...
                        numel(S))];
    error('blair:load_case:invalid', '%s', msg);
end

if n_ignored > 0
    warns{end+1} = sprintf('%d extra value(s) after the 42 required fields were ignored', n_ignored);
end

if ~isempty(warns)
    warning('blair:load_case:suspicious', ...
        'Case file loaded with %d warning(s) (%s):\n  %s', ...
        numel(warns), casepath, strjoin(warns, sprintf('\n  ')));
end

if nargout > 1
    meta = struct();
    meta.source        = casepath;
    meta.n_values      = nval;
    meta.n_required    = numel(S);
    meta.line_numbers  = linenum(1:min(nval, numel(S)));
    meta.comment_names = cmtname(1:min(nval, numel(S)));
    meta.field_names   = {S.name};
    meta.warnings      = warns;
end
end % load_case


% =========================================================================
% Field specification: Prog.5.1 prompt order, with hard validity ranges.
% Ranges are deliberately generous physical bounds, not "typical values" -
% they exist to catch a misplaced decimal point or a shifted field, not to
% second-guess a design.
% =========================================================================
function S = local_field_spec()
S = struct('name', {}, 'kind', {}, 'lo', {}, 'hi', {}, 'unit', {});

S(end+1) = local_f('BO',   'num',   10,  300,  'mm');
S(end+1) = local_f('ST',   'num',   10,  300,  'mm');
S(end+1) = local_f('CRL',  'num',   20,  1000, 'mm');
S(end+1) = local_f('RPM',  'num',  100, 30000, 'rev/min');
S(end+1) = local_f('TCR',  'num', 1.01,   40,  '-');
S(end+1) = local_f('CCR',  'num', 1.01,   20,  '-');
S(end+1) = local_f('TEXC', 'num',  -50, 1500, 'degC');

S(end+1) = local_f('EPO',  'num',    0,  180, 'deg ATDC');
S(end+1) = local_f('EPFO', 'num',    0,  180, 'deg ATDC');
S(end+1) = local_f('NEP',  'num',    1,   24, 'count');
S(end+1) = local_f('WEP',  'num',    1,  300, 'mm');
S(end+1) = local_f('RTE',  'num',    0,  150, 'mm');
S(end+1) = local_f('RBE',  'num',    0,  150, 'mm');

S(end+1) = local_f('TPO',  'num',    0,  180, 'deg ATDC');
S(end+1) = local_f('TPFO', 'num',    0,  180, 'deg ATDC');
S(end+1) = local_f('NTP',  'num',    1,   24, 'count');
S(end+1) = local_f('WTP',  'num',    1,  300, 'mm');
S(end+1) = local_f('RTT',  'num',    0,  150, 'mm');
S(end+1) = local_f('RBT',  'num',    0,  150, 'mm');
S(end+1) = local_f('SCAV', 'str',  NaN,  NaN, '-');

S(end+1) = local_f('IPO',  'num',    0,  180, 'deg BTDC');
S(end+1) = local_f('IPFO', 'num',    0,  180, 'deg ATDC');
S(end+1) = local_f('NIP',  'num',    1,   24, 'count');
S(end+1) = local_f('WIP',  'num',    1,  300, 'mm');
S(end+1) = local_f('RTI',  'num',    0,  150, 'mm');
S(end+1) = local_f('RBI',  'num',    0,  150, 'mm');

S(end+1) = local_f('LEP1', 'num',    1, 5000, 'mm');
S(end+1) = local_f('DEP1', 'num',    1,  500, 'mm');
S(end+1) = local_f('LEP2', 'num',    1, 5000, 'mm');
S(end+1) = local_f('DEP2', 'num',    1,  500, 'mm');
S(end+1) = local_f('VBOX', 'num',    1,  1e7, 'cm3');
S(end+1) = local_f('SIL',  'str',  NaN,  NaN, '-');

S(end+1) = local_f('LTP',  'num',    1, 2000, 'mm');
S(end+1) = local_f('TRAR', 'num',  0.5,    5, '-');

S(end+1) = local_f('LIP',  'num',    1, 2000, 'mm');
S(end+1) = local_f('DIP',  'num',    1,  300, 'mm');
S(end+1) = local_f('THAR', 'num', 0.001,   1, '-');

S(end+1) = local_f('NC',   'num',  1.0,  1.7, '-');
S(end+1) = local_f('NE',   'num',  1.0,  1.7, '-');
S(end+1) = local_f('BEFF', 'num',    0,    1, '-');
S(end+1) = local_f('BDEG', 'num',    1,  180, 'deg');
S(end+1) = local_f('TAF',  'num',    5,   30, '-');
end

function f = local_f(name, kind, lo, hi, unit)
f = struct('name', name, 'kind', kind, 'lo', lo, 'hi', hi, 'unit', unit);
end


% =========================================================================
% String fields
% =========================================================================
function [v, ok, why] = local_string_field(name, raw)
ok  = true;
why = '';

switch name
    case 'SCAV'
        key = upper(regexprep(raw, '[\s_]', ''));
        switch key
            case 'UNIFLOW', v = 'UNIFLOW';
            case 'SCRE',    v = 'SCRE';
            case 'YAM1',    v = 'YAM1';
            case 'YAM6',    v = 'YAM6';
            case 'CD',      v = 'CD';
            case 'QUBCR',   v = 'QUBCR';
            otherwise
                ok  = false;
                v   = raw;
                why = sprintf(['SCAV = "%s" is not a valid scavenging type. ' ...
                               'Use one of UNIFLOW, SCRE, YAM1, YAM6, CD, QUBCR.'], raw);
        end

    case 'SIL'
        key = upper(regexprep(raw, '\s+', ' '));
        switch key
            case {'N', 'NO', 'PLAIN', 'BOX', 'PLAIN BOX'}
                v = 'PLAIN BOX';
            case {'Y', 'YES', 'ABSORPTION', 'ABSORPTIVE', 'ABSORPTION TYPE'}
                v = 'ABSORPTION';
            otherwise
                ok  = false;
                v   = raw;
                why = sprintf(['SIL = "%s" is not a valid silencer answer. ' ...
                               'Use N (plain box) or Y (absorption type).'], raw);
        end

    otherwise
        ok  = false;
        v   = raw;
        why = sprintf('unknown string field %s', name);
end
end


% =========================================================================
% Cross-field checks. Hard errors are reserved for physically impossible
% combinations; design-guidance observations are warnings.
% =========================================================================
function [errs, warns] = local_cross_checks(c)
errs  = {};
warns = {};

% --- connecting rod must be longer than the crank radius -----------------
if local_ok(c, {'CRL', 'ST'}) && c.CRL <= c.ST/2
    errs{end+1} = sprintf('CRL = %g mm must exceed the crank radius ST/2 = %g mm', ...
        c.CRL, c.ST/2);
end

% --- "fully open" cannot precede "opens" ---------------------------------
if local_ok(c, {'EPFO', 'EPO'}) && c.EPFO < c.EPO
    errs{end+1} = sprintf('EPFO = %g deg is before EPO = %g deg; the exhaust port cannot be fully open before it opens', ...
        c.EPFO, c.EPO);
end
if local_ok(c, {'TPFO', 'TPO'}) && c.TPFO < c.TPO
    errs{end+1} = sprintf('TPFO = %g deg is before TPO = %g deg; the transfer port cannot be fully open before it opens', ...
        c.TPFO, c.TPO);
end

% --- ports must fit round the bore ---------------------------------------
if local_ok(c, {'NEP', 'WEP', 'BO'}) && c.NEP*c.WEP > 1.02*pi*c.BO
    errs{end+1} = sprintf('NEP*WEP = %.1f mm exceeds the bore circumference %.1f mm', ...
        c.NEP*c.WEP, pi*c.BO);
end
if local_ok(c, {'NTP', 'WTP', 'BO'}) && c.NTP*c.WTP > 1.02*pi*c.BO
    errs{end+1} = sprintf('NTP*WTP = %.1f mm exceeds the bore circumference %.1f mm', ...
        c.NTP*c.WTP, pi*c.BO);
end
if local_ok(c, {'NIP', 'WIP', 'BO'}) && c.NIP*c.WIP > 1.02*pi*c.BO
    errs{end+1} = sprintf('NIP*WIP = %.1f mm exceeds the bore circumference %.1f mm', ...
        c.NIP*c.WIP, pi*c.BO);
end

% --- corner radii must fit the port width -------------------------------
if local_ok(c, {'RTE', 'WEP'}) && c.RTE >= c.WEP/2
    errs{end+1} = sprintf('RTE = %g mm does not fit in a port of width WEP = %g mm', ...
        c.RTE, c.WEP);
end
if local_ok(c, {'RTT', 'WTP'}) && c.RTT >= c.WTP/2
    errs{end+1} = sprintf('RTT = %g mm does not fit in a port of width WTP = %g mm', ...
        c.RTT, c.WTP);
end
if local_ok(c, {'RTI', 'WIP'}) && c.RTI >= c.WIP/2
    errs{end+1} = sprintf('RTI = %g mm does not fit in a port of width WIP = %g mm', ...
        c.RTI, c.WIP);
end

% --- exhaust should uncover before the transfer ports (warn only) --------
if local_ok(c, {'EPO', 'TPO'}) && c.TPO < c.EPO
    warns{end+1} = sprintf(['TPO = %g deg opens before EPO = %g deg. ' ...
        'That is unusual for a crankcase-scavenged engine; check the field order.'], ...
        c.TPO, c.EPO);
end

% --- calibration constants: flag values far outside the book's practice --
if local_ok(c, {'TRAR'}) && (c.TRAR < 0.8 || c.TRAR > 2.5)
    warns{end+1} = sprintf(['TRAR = %g is outside the usual design range 1.2-1.5 ' ...
        '(Blair section 5.1.2); the transfer duct is derived from it.'], c.TRAR);
end
if local_ok(c, {'BEFF'}) && (c.BEFF < 0.5 || c.BEFF > 0.95)
    warns{end+1} = sprintf(['BEFF = %g is far from the fitted range 0.80-0.85; ' ...
        'heat release is a calibration constant, not a measured efficiency.'], c.BEFF);
end
if local_ok(c, {'TAF'}) && (c.TAF > 20 || c.TAF < 8)
    warns{end+1} = sprintf('TAF = %g is an unusual trapped air-fuel ratio for a carburetted two-stroke', c.TAF);
end

% --- silencer box sanity -------------------------------------------------
if local_ok(c, {'VBOX', 'BO', 'ST'})
    sv = pi/4 * (c.BO/10)^2 * (c.ST/10);   % swept volume in cm^3
    if c.VBOX < 5*sv
        warns{end+1} = sprintf(['VBOX = %g cm3 is only %.1fx the swept volume %.0f cm3; ' ...
            'a plain expansion box is normally >= 20x (Blair section 5.1.3).'], ...
            c.VBOX, c.VBOX/sv, sv);
    end
end
if local_ok(c, {'DEP1', 'BO'}) && c.DEP1 > c.BO
    warns{end+1} = sprintf('DEP1 = %g mm is larger than the bore BO = %g mm', c.DEP1, c.BO);
end
if local_ok(c, {'DEP2', 'BO'}) && c.DEP2 > c.BO
    warns{end+1} = sprintf('DEP2 = %g mm is larger than the bore BO = %g mm', c.DEP2, c.BO);
end
end

function tf = local_ok(c, names)
tf = true;
for i = 1:numel(names)
    if ~isfield(c, names{i}) || ~isnumeric(c.(names{i})) || ~isfinite(c.(names{i}))
        tf = false;
        return
    end
end
end


% =========================================================================
% Small text helpers
% =========================================================================
function v = local_unquote(v)
% Strip one pair of matching surrounding quotes, if present.
if numel(v) >= 2
    if (v(1) == '"' && v(end) == '"') || (v(1) == '''' && v(end) == '''')
        v = strtrim(v(2:end-1));
    end
end
end

function nm = local_comment_name(cmt)
% Leading identifier of the comment, e.g.
%   "BO ! mm ! 9597"                  -> "BO"
%   "SIL$ (answer N = PLAIN BOX) ! -" -> "SIL$"
nm = '';
if isempty(cmt)
    return
end
parts = regexp(cmt, '!', 'split');
nm = regexp(strtrim(parts{1}), '^[A-Za-z0-9_$]+', 'match', 'once');
if isempty(nm)
    nm = '';
end
end

function nm = local_norm_name(nm)
% Compare names after removing '$' (SCAV$ vs SCAV) and case.
nm = upper(regexprep(nm, '[^A-Za-z0-9]', ''));
end
