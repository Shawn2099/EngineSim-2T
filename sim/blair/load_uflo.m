function [ABX, BX, meta] = load_uflo(uflo_path)
%LOAD_UFLO  Read the Blair unsteady-flow boundary table (file "UFLO").
%
%   ABX = LOAD_UFLO()          reads CONFIG.default_uflo (port\uflo.csv).
%   ABX = LOAD_UFLO(PATH)      reads PATH.
%   [ABX, BX] = LOAD_UFLO(..)  also returns the 41-element x axis.
%   [ABX, BX, META] = ...      also returns provenance and checks.
%
%   WHAT THE TABLE IS
%     ABX(I,J) = (A1+B1)/Xc, the non-dimensional superposition pressure
%     amplitude at a port, from Blair Fig.2.7, for gamma = 1.4 only.
%       I = 1..21   port-to-pipe area ratio AK = 0, 0.05, ... 1.00
%       J = 1..41   incoming amplitude   BX = B1/Xc = 0.60, 0.62, ... 1.40
%     Row I=1 is the BX axis itself; rows 2..21 are the twenty AK banks.
%     That is 861 numbers in total.
%
%   FILE LAYOUT AND THE 22-vs-21 ROW TRAP
%     The CSV has 22 rows of 41 comma-separated numbers. Row 1 is the BX
%     axis, and row 2 repeats it - by definition, since ABX(1,:) *is* BX.
%     The program wants 21 rows, so this reader drops the duplicate:
%
%         BX  = row 1                     (1x41)
%         ABX = [ row 1 ; rows 3..22 ]    (21x41)
%
%     If the file already has 21 rows and row 2 is not a copy of row 1, it
%     is taken as already-correct and used unchanged. Anything else is an
%     error: silently mis-slicing this table corrupts every port boundary
%     condition without any visible symptom.
%
%   INTERPOLATION NOTE
%     Blair's SUB PORT clamps AK at .95 and evaluates ABX(I+1,J+1) with
%     I up to 20 and J up to 41, i.e. it touches ABX(21,42) - outside this
%     matrix. The original relies on BASIC zero-filling that element. If
%     your port routine keeps that indexing, guard the J+1 access at
%     J = 41 (BX1 >= 1.40) rather than assuming a column 42 exists.
%
%   See also LOAD_CASE, BLAIR_INIT.

% -------------------------------------------------------------------------
% CONFIG - the only place in this file where a path appears.
% -------------------------------------------------------------------------
CONFIG = struct();
CONFIG.default_uflo = 'C:\Users\malliath\Desktop\engine_sim\port\uflo.csv';
CONFIG.n_ak   = 21;     % rows the program wants
CONFIG.n_bx   = 41;     % columns
CONFIG.ak     = 0:0.05:1.00;
CONFIG.bx     = 0.60:0.02:1.40;

% -------------------------------------------------------------------------
% 0. Input
% -------------------------------------------------------------------------
if nargin < 1 || isempty(uflo_path)
    uflo_path = CONFIG.default_uflo;
end
if ~(ischar(uflo_path) || isstring(uflo_path))
    error('blair:load_uflo:badInput', ...
        'uflo_path must be a char row vector or a string, got %s.', class(uflo_path));
end
uflo_path = char(uflo_path);
if exist(uflo_path, 'file') ~= 2
    error('blair:load_uflo:notFound', ...
        ['UFLO table not found:\n  %s\n' ...
         'Pass an explicit path, or edit CONFIG.default_uflo at the top of %s.'], ...
        uflo_path, mfilename);
end

% -------------------------------------------------------------------------
% 1. Parse: comma- or whitespace-separated numbers, blank lines ignored
% -------------------------------------------------------------------------
txt   = fileread(uflo_path);
lines = regexp(txt, '\r\n|\n|\r', 'split');

rows   = {};
rowlin = [];
for k = 1:numel(lines)
    s = strtrim(lines{k});
    if isempty(s)
        continue
    end
    parts = regexp(s, '[,;\s]+', 'split');
    parts = parts(~cellfun(@isempty, parts));
    v = str2double(parts);
    if any(isnan(v))
        bad = find(isnan(v), 1);
        error('blair:load_uflo:badNumber', ...
            ['Non-numeric field in %s at line %d, column %d: "%s".\n' ...
             'The table must be 41 numbers per row, comma- or space-separated.'], ...
            uflo_path, k, bad, parts{bad});
    end
    rows{end+1}   = v(:)'; %#ok<AGROW>
    rowlin(end+1) = k;     %#ok<AGROW>
end

if isempty(rows)
    error('blair:load_uflo:empty', 'No numeric data found in %s.', uflo_path);
end

ncol = cellfun(@numel, rows);
if any(ncol ~= CONFIG.n_bx)
    bad = find(ncol ~= CONFIG.n_bx, 1);
    error('blair:load_uflo:badWidth', ...
        ['Every row must have %d columns; row on line %d has %d.\n' ...
         'File: %s'], ...
        CONFIG.n_bx, rowlin(bad), ncol(bad), uflo_path);
end
M = vertcat(rows{:});
nrow = size(M, 1);

% -------------------------------------------------------------------------
% 2. Slice to the 21 x 41 the program expects
% -------------------------------------------------------------------------
dup   = (nrow >= 2) && isequal(size(M(1,:)), size(M(2,:))) && ...
        max(abs(M(1,:) - M(2,:))) <= 1e-9;
nAK   = CONFIG.n_ak;

if nrow == nAK && ~dup
    % Already in program layout: row 1 axis, rows 2..21 banks.
    ABX = M;
    dropped_duplicate = false;
elseif nrow == nAK + 1 && dup
    % Documented layout: drop the repeated axis row.
    ABX = M([1, 3:end], :);
    dropped_duplicate = true;
elseif nrow == nAK + 1 && ~dup
    error('blair:load_uflo:ambiguousLayout', ...
        ['%s has %d rows and row 2 is not a copy of row 1.\n' ...
         'Cannot tell whether row 2 is the duplicated BX axis or the first AK bank.\n' ...
         'Expected either 21 rows (axis + 20 banks) or 22 rows (axis + repeated axis + 20 banks).'], ...
        uflo_path, nrow);
else
    error('blair:load_uflo:badSize', ...
        ['%s has %d rows; expected %d (axis + 20 AK banks) or %d ' ...
         '(axis, repeated axis, 20 AK banks).'], ...
        uflo_path, nrow, nAK, nAK + 1);
end

if size(ABX, 1) ~= nAK || size(ABX, 2) ~= CONFIG.n_bx
    error('blair:load_uflo:badSize', ...
        'Internal slicing error: got %dx%d, expected %dx%d.', ...
        size(ABX,1), size(ABX,2), nAK, CONFIG.n_bx);
end
if ~all(isfinite(ABX(:)))
    error('blair:load_uflo:notFinite', 'The UFLO table in %s contains NaN or Inf.', uflo_path);
end

BX = ABX(1, :);                  % 41-element axis (row, mirrors ABX(1,:))

% -------------------------------------------------------------------------
% 3. Structural checks
% -------------------------------------------------------------------------
warns = {};

if any(diff(BX) <= 0)
    error('blair:load_uflo:badAxis', ...
        'The BX axis in %s is not strictly increasing (row 1).', uflo_path);
end
if numel(BX) ~= CONFIG.n_bx
    error('blair:load_uflo:badAxis', ...
        'The BX axis in %s has %d elements; expected %d.', uflo_path, numel(BX), CONFIG.n_bx);
end

if max(abs(BX(:) - CONFIG.bx(:))) > 1e-6
    warns{end+1} = sprintf(['BX axis differs from the documented 0.60:0.02:1.40 ' ...
        '(first %.4f, last %.4f). Interpolation indices assume a uniform 0.02 step.'], ...
        BX(1), BX(end));
end

% Every AK row must be monotonic in BX over the tabulated range, and the
% whole table should be O(1): these are pressure amplitude ratios.
if any(diff(ABX, 1, 2) < -1e-9, 'all')
    badrow = find(any(diff(ABX, 1, 2) < -1e-9, 2), 1);
    warns{end+1} = sprintf('ABX row %d is not monotonic in BX; check the source file', badrow);
end
if any(abs(ABX(:)) > 10)
    warns{end+1} = 'ABX contains values larger than 10 in magnitude; expected O(1) ratios';
end

% At B/Xc = 1.00 the table is 1.0 for every AK (a useful transcription check).
j1 = find(abs(BX - 1.0) < 1e-9, 1);
if ~isempty(j1) && max(abs(ABX(2:end, j1) - 1)) > 1e-3
    warns{end+1} = sprintf(['ABX(:, BX=1.00) should be 1.0 for every AK row; ' ...
        'largest deviation %.2e. Possible transcription damage.'], ...
        max(abs(ABX(2:end, j1) - 1)));
end

if ~isempty(warns)
    warning('blair:load_uflo:suspicious', ...
        'UFLO table loaded with %d warning(s) (%s):\n  %s', ...
        numel(warns), uflo_path, strjoin(warns, sprintf('\n  ')));
end

if nargout > 2
    meta = struct();
    meta.source            = uflo_path;
    meta.size              = size(ABX);
    meta.n_rows_in_file    = nrow;
    meta.dropped_duplicate = dropped_duplicate;
    meta.ak                = CONFIG.ak;        % 1x21, derived, not read from file
    meta.bx                = BX;
    meta.warnings          = warns;
end
end % load_uflo
