function mdl_table = sweep(casepath, rpm_list, throttle_list, opts)
%SWEEP  Run the Blair model over a speed x throttle grid, with checkpointing.
%
%   T = SWEEP(CASEPATH, RPM_LIST, THROTTLE_LIST)
%
%   Calls blair_run once per operating point and returns a MATLAB table with
%   one row per point. Every point is written to a checkpoint file
%   immediately, so an interrupted sweep resumes where it stopped.
%
%   INPUTS
%     casepath       path to a Prog.5.1 case file (see load_case.m).
%                    [] uses CONFIG.default_case.
%     rpm_list       numeric vector of engine speeds [rev/min], e.g. 2000:500:7000
%     throttle_list  numeric vector of throttle area ratios THAR, 0..1,
%                    e.g. [1 0.5 0.25]. Each value is passed to blair_run
%                    as its throttle argument, unchanged.
%     opts           optional struct, fields:
%                      resume       true  - reuse matching checkpoint (default)
%                      checkpoint   path, or '' to disable checkpointing
%                      csv          path, or '' to skip the CSV copy
%                      verbose      true  - print one line per point (default)
%                      retry_failed true  - on resume, retry points that
%                                           failed previously (default)
%                      validate_case true - run load_case() first (default)
%
%   ORDER OF ROWS
%     Throttle is the outer loop, speed the inner loop, so every throttle
%     setting occupies one contiguous block of rows (one curve per throttle
%     in plot_curve). Point i is (throttle_list(k), rpm_list(j)).
%
%   TABLE COLUMNS
%     rpm, throttle, power_kW, bmep_bar, imep_bar, pmep_bar, fmep_bar,
%     bsfc_gkWh, DR, SE, TE, CE, pmax_bar, tmax_K, converged, cycles, ok
%
%     rpm and throttle are the *requested* values, not results.
%     ok is true when blair_run returned normally for that point; a failed
%     point keeps NaN physics, so plotting and statistics skip it naturally.
%     converged is logical; cycles is the cycle count Blair used.
%
%   RESUME SEMANTICS
%     The checkpoint is keyed on the case path, the case file's size and
%     timestamp, the two grids, and this file's CONFIG.file_version. If the
%     case file or the grid changes, the checkpoint is not reused (and the
%     old file is left alone until the new sweep first writes). A failed
%     point is retried on the next call unless opts.retry_failed is false.
%
%   ERRORS
%     blair:sweep:noPhysics   blair_init/blair_run not on the path
%     blair:sweep:badCase     load_case rejected the deck
%     blair:sweep:initFailed  blair_init threw
%     blair:sweep:badResults  blair_run returned something without .results
%                             (interface violation - stops the sweep)
%
%   See also BLAIR_INIT, BLAIR_RUN, LOAD_CASE, PLOT_CURVE.

% -------------------------------------------------------------------------
% CONFIG - the only place in this file where paths appear.
% -------------------------------------------------------------------------
CONFIG = struct();
CONFIG.dir             = fileparts(mfilename('fullpath'));
CONFIG.default_case    = 'C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat';
CONFIG.checkpoint_file = fullfile(CONFIG.dir, 'sweep_checkpoint.mat');
CONFIG.csv_file        = fullfile(CONFIG.dir, 'sweep_results.csv');
CONFIG.file_version    = 1;
CONFIG.result_fields   = { ...
    'power_kW', 'bmep_bar', 'imep_bar', 'pmep_bar', 'fmep_bar', ...
    'bsfc_gkWh', 'DR', 'SE', 'TE', 'CE', 'pmax_bar', 'tmax_K', ...
    'converged', 'cycles'};

% -------------------------------------------------------------------------
% 0. Arguments
% -------------------------------------------------------------------------
if nargin < 1
    casepath = [];
end
if nargin < 2 || isempty(rpm_list)
    error('blair:sweep:badInput', 'rpm_list is required (e.g. 2000:500:7000).');
end
if nargin < 3 || isempty(throttle_list)
    error('blair:sweep:badInput', 'throttle_list is required (e.g. [1 0.5 0.25]).');
end
if nargin < 4 || isempty(opts)
    opts = struct();
end
if ~isstruct(opts)
    error('blair:sweep:badInput', 'opts must be a struct, got %s.', class(opts));
end
opts = local_defaults(opts, CONFIG);

if isempty(casepath)
    casepath = CONFIG.default_case;
end
casepath = local_resolve(casepath);

rpm_list      = local_numeric_list(rpm_list,      'rpm_list',      100, 30000);
throttle_list = local_numeric_list(throttle_list, 'throttle_list', 0,   1);
if any(throttle_list <= 0)
    error('blair:sweep:badInput', ...
        'throttle_list must be > 0; THAR = 0 is a closed inlet, not an operating point.');
end

% -------------------------------------------------------------------------
% 1. Preconditions: physics present, case valid
% -------------------------------------------------------------------------
local_require_physics();

if opts.validate_case && exist('load_case', 'file') == 2
    try
        load_case(casepath);
    catch err
        error('blair:sweep:badCase', ...
            'load_case rejected %s:\n%s', casepath, err.message);
    end
end

% -------------------------------------------------------------------------
% 2. Build the grid (throttle outer, speed inner)
% -------------------------------------------------------------------------
nR      = numel(rpm_list);
nT      = numel(throttle_list);
thr_vec = kron(throttle_list(:), ones(nR, 1));   % throttle outer
rpm_vec = repmat(rpm_list(:), nT, 1);            % speed fastest
npts    = nR * nT;

sig = struct();
sig.casepath   = casepath;
sig.case_stamp = local_stamp(casepath);
sig.rpm        = rpm_list(:)';
sig.throttle   = throttle_list(:)';
sig.version    = CONFIG.file_version;

if opts.resume
    state = local_load_state(opts.checkpoint, sig, npts, rpm_vec, thr_vec, opts.verbose);
else
    state = local_fresh_state(sig, npts, rpm_vec, thr_vec);
end
if any(state.done)
    fprintf('  sweep: resuming - %d of %d point(s) already done in\n         %s\n', ...
        nnz(state.done), npts, opts.checkpoint);
end

% -------------------------------------------------------------------------
% 3. Initialise the model once, then loop the grid
% -------------------------------------------------------------------------
try
    mdl = blair_init(casepath);
catch err
    error('blair:sweep:initFailed', ...
        'blair_init failed for %s:\n  %s', casepath, err.message);
end
if ~isstruct(mdl)
    error('blair:sweep:badResults', ...
        'blair_init must return a struct (got %s).', class(mdl));
end

missing_total = {};
t_start       = tic;

for i = 1:npts
    retry = opts.retry_failed && state.done(i) && ~state.ok(i);
    if state.done(i) && ~retry
        continue
    end

    t_pt = tic;
    try
        mdl = blair_run(mdl, rpm_vec(i), thr_vec(i));
        if ~isfield(mdl, 'results') || ~isstruct(mdl.results)
            error('blair:sweep:badResults', ...
                ['blair_run must return mdl with a .results struct.\n' ...
                 'See the interface contract at the top of sweep.m.']);
        end
        [res, missing] = local_extract(mdl.results, CONFIG.result_fields);
        missing_total  = union(missing_total, missing);
        ok  = true;
        msg = '';
    catch err
        if strncmp(err.identifier, 'blair:sweep:', 12)
            rethrow(err)         % interface violation, not a bad operating point
        end
        res = local_empty_result(CONFIG.result_fields);
        ok  = false;
        msg = err.message;
        % blair_run may have left the model half-updated; start from clean.
        try
            mdl = blair_init(casepath);
        catch
            % keep going; the next point will report its own failure
        end
    end

    state.results{i}  = res;
    state.messages{i} = msg;
    state.done(i)     = true;
    state.ok(i)       = ok;
    state.stamp{i}    = char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss'));

    local_save_state(opts.checkpoint, state);

    if opts.verbose
        if ok
            fprintf('  [%3d/%3d] %6.0f rpm  thr %5.2f  ->  %7.2f kW  bmep %6.2f bar  (%4.1f s)\n', ...
                i, npts, rpm_vec(i), thr_vec(i), ...
                local_get(res, 'power_kW'), local_get(res, 'bmep_bar'), toc(t_pt));
        else
            fprintf('  [%3d/%3d] %6.0f rpm  thr %5.2f  ->  FAILED: %s\n', ...
                i, npts, rpm_vec(i), thr_vec(i), local_short(msg));
        end
    end
end

% -------------------------------------------------------------------------
% 4. Assemble the table
% -------------------------------------------------------------------------
nf     = numel(CONFIG.result_fields);
M      = nan(npts, nf);
for i = 1:npts
    r = state.results{i};
    if isempty(r)
        continue
    end
    for j = 1:nf
        v = local_get(r, CONFIG.result_fields{j});
        if isfinite(v)
            M(i, j) = v;
        end
    end
end

data  = {rpm_vec, thr_vec};
names = {'rpm', 'throttle'};
ic    = 0;
for j = 1:nf
    fname = CONFIG.result_fields{j};
    names{end+1} = fname; %#ok<AGROW>
    if strcmp(fname, 'converged')
        ic = j;                                  % computed after the loop
        data{end+1} = false(npts, 1);            %#ok<AGROW>
    else
        data{end+1} = M(:, j);                   %#ok<AGROW>
    end
end
if ic > 0
    data{2 + ic} = (M(:, ic) == 1);              % NaN -> false
end
data{end+1} = logical(state.ok(:));
names{end+1} = 'ok';

mdl_table = table(data{:}, 'VariableNames', names);
mdl_table.Properties.UserData = struct( ...
    'casepath',      casepath, ...
    'rpm_list',      rpm_list(:), ...
    'throttle_list', throttle_list(:), ...
    'n_points',      npts, ...
    'checkpoint',    opts.checkpoint, ...
    'created',       char(datetime('now')));

% -------------------------------------------------------------------------
% 5. Side outputs and report
% -------------------------------------------------------------------------
if ~isempty(opts.csv)
    try
        writetable(mdl_table, opts.csv);
    catch err
        warning('blair:sweep:csvFailed', 'Could not write %s:\n  %s', opts.csv, err.message);
    end
end

nok = nnz(state.ok);
if opts.verbose
    fprintf('  sweep: %d/%d point(s) ok in %.1f s\n', nok, npts, toc(t_start));
    if ~isempty(opts.checkpoint)
        fprintf('  sweep: checkpoint  %s\n', opts.checkpoint);
    end
    if ~isempty(opts.csv)
        fprintf('  sweep: table       %s\n', opts.csv);
    end
end

if ~isempty(missing_total)
    warning('blair:sweep:missingField', ...
        ['mdl.results is missing %d field(s) required by the contract:\n  %s\n' ...
         'Those columns are NaN in the returned table.'], ...
        numel(missing_total), strjoin(missing_total, ', '));
end
if nok < npts
    failed = find(~state.ok);
    warning('blair:sweep:pointsFailed', ...
        '%d of %d point(s) failed; their physics columns are NaN. First failure:\n  %d rpm, thr %.2f: %s', ...
        numel(failed), npts, rpm_vec(failed(1)), thr_vec(failed(1)), ...
        local_short(state.messages{failed(1)}));
end
end % sweep


% =========================================================================
% Checkpoint I/O
% =========================================================================
function state = local_load_state(file, sig, npts, rpm_vec, thr_vec, verbose)
state = local_fresh_state(sig, npts, rpm_vec, thr_vec);

if isempty(file) || exist(file, 'file') ~= 2
    return
end

try
    S = load(file);
catch err
    if verbose
        fprintf('  sweep: checkpoint unreadable (%s); starting fresh\n', err.message);
    end
    return
end
if ~isfield(S, 'state_v1') || ~isstruct(S.state_v1)
    if verbose
        fprintf('  sweep: checkpoint has no state_v1; starting fresh\n');
    end
    return
end

old = S.state_v1;
if ~isfield(old, 'signature') || ~local_same_sig(old.signature, sig)
    if verbose
        fprintf(['  sweep: checkpoint belongs to a different case or grid; ' ...
                 'starting fresh (the old file is overwritten on the first point)\n']);
    end
    return
end
if ~isfield(old, 'done') || numel(old.done) ~= npts || ...
        ~isfield(old, 'results') || numel(old.results) ~= npts
    if verbose
        fprintf('  sweep: checkpoint is malformed or from another grid size; starting fresh\n');
    end
    return
end

state = old;
if ~isfield(state, 'ok') || numel(state.ok) ~= npts
    state.ok = false(1, npts);
end
if ~isfield(state, 'messages') || numel(state.messages) ~= npts
    state.messages = repmat({''}, 1, npts);
end
if ~isfield(state, 'stamp') || numel(state.stamp) ~= npts
    state.stamp = repmat({''}, 1, npts);
end
end

function state = local_fresh_state(sig, npts, rpm_vec, thr_vec)
state = struct();
state.signature = sig;
state.done      = false(1, npts);
state.ok        = false(1, npts);
state.results   = repmat({[]}, 1, npts);
state.messages  = repmat({''}, 1, npts);
state.stamp     = repmat({''}, 1, npts);
state.rpm       = rpm_vec(:)';
state.throttle  = thr_vec(:)';
state.created   = char(datetime('now'));
end

function local_save_state(file, state)
if isempty(file)
    return
end
state_v1 = state;
tmp = [file '.tmp'];
try
    save(tmp, 'state_v1', '-v7');
    movefile(tmp, file, 'f');
catch err
    warning('blair:sweep:checkpointFailed', ...
        'Could not write checkpoint %s:\n  %s', file, err.message);
end
end

function tf = local_same_sig(a, b)
tf = false;
need = {'casepath', 'case_stamp', 'rpm', 'throttle', 'version'};
for i = 1:numel(need)
    if ~isfield(a, need{i}) || ~isfield(b, need{i})
        return
    end
end
tf = strcmp(a.casepath, b.casepath) && ...
     isequal(a.case_stamp, b.case_stamp) && ...
     isequaln(a.rpm, b.rpm) && ...
     isequaln(a.throttle, b.throttle) && ...
     isequal(a.version, b.version);
end


% =========================================================================
% Result extraction
% =========================================================================
function [res, missing] = local_extract(r, fields)
missing = {};
res     = struct();
for j = 1:numel(fields)
    f = fields{j};
    if isfield(r, f) && (isnumeric(r.(f)) || islogical(r.(f))) && isscalar(r.(f)) && ~isempty(r.(f))
        v = double(r.(f));
        if strcmp(f, 'converged')
            v = double(logical(v));
        end
        res.(f) = v;
    else
        res.(f) = NaN;
        missing{end+1} = f; %#ok<AGROW>
    end
end
end

function res = local_empty_result(fields)
res = struct();
for j = 1:numel(fields)
    res.(fields{j}) = NaN;
end
end

function v = local_get(r, f)
v = NaN;
if isstruct(r) && isfield(r, f) && (isnumeric(r.(f)) || islogical(r.(f))) && ...
        isscalar(r.(f)) && ~isempty(r.(f))
    v = double(r.(f));
end
end

function s = local_short(msg)
s = strtrim(regexprep(char(msg), '\s+', ' '));
if numel(s) > 110
    s = [s(1:107) '...'];
end
end


% =========================================================================
% Input helpers
% =========================================================================
function opts = local_defaults(opts, CONFIG)
d = struct( ...
    'resume',        true, ...
    'checkpoint',    CONFIG.checkpoint_file, ...
    'csv',           CONFIG.csv_file, ...
    'verbose',       true, ...
    'retry_failed',  true, ...
    'validate_case', true);

fn = fieldnames(d);
for i = 1:numel(fn)
    if ~isfield(opts, fn{i})
        opts.(fn{i}) = d.(fn{i});
    end
end
if ~ischar(opts.checkpoint) && ~isstring(opts.checkpoint)
    error('blair:sweep:badInput', 'opts.checkpoint must be a path or '''' to disable it.');
end
if ~ischar(opts.csv) && ~isstring(opts.csv)
    error('blair:sweep:badInput', 'opts.csv must be a path or '''' to skip it.');
end
opts.checkpoint = char(opts.checkpoint);
opts.csv        = char(opts.csv);
opts.resume        = logical(opts.resume);
opts.verbose       = logical(opts.verbose);
opts.retry_failed  = logical(opts.retry_failed);
opts.validate_case = logical(opts.validate_case);
end

function v = local_numeric_list(v, name, lo, hi)
if ~isnumeric(v) || ~isvector(v) || isempty(v)
    error('blair:sweep:badInput', '%s must be a non-empty numeric vector.', name);
end
v = double(v(:))';
if any(~isfinite(v))
    error('blair:sweep:badInput', '%s contains NaN or Inf.', name);
end
if any(v < lo | v > hi)
    error('blair:sweep:badInput', ...
        '%s has values outside [%g, %g].', name, lo, hi);
end
v = unique(v, 'stable');
end

function p = local_resolve(p)
if ~(ischar(p) || isstring(p))
    error('blair:sweep:badInput', 'casepath must be a char row vector or a string.');
end
p = char(p);
d = dir(p);
if isempty(d)
    % allow a bare name that sits next to this function
    alt = fullfile(fileparts(mfilename('fullpath')), p);
    d = dir(alt);
    if isempty(d)
        error('blair:sweep:notFound', 'Case file not found:\n  %s', p);
    end
end
p = fullfile(d(1).folder, d(1).name);   % absolute, stable across cwd changes
end

function s = local_stamp(p)
d = dir(p);
if isempty(d)
    error('blair:sweep:notFound', 'Case file not found:\n  %s', p);
end
s = struct('bytes', d.bytes, 'datenum', d.datenum);
end

function local_require_physics()
missing = {};
for f = {'blair_init', 'blair_run'}
    if exist(f{1}, 'file') ~= 2
        missing{end+1} = f{1}; %#ok<AGROW>
    end
end
if ~isempty(missing)
    error('blair:sweep:noPhysics', ...
        ['%s not found on the MATLAB path.\n' ...
         'The physics layer (blair_init.m, blair_run.m) is written separately.\n' ...
         'Run this from sim\\blair, or addpath() the folder that holds them:\n' ...
         '    cd(''%s'')\n' ...
         '    addpath(''%s'')'], ...
        strjoin(missing, ' and '), fileparts(mfilename('fullpath')), ...
        fileparts(mfilename('fullpath')));
end
end
