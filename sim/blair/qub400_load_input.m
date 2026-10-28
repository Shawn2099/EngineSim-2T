function inp = qub400_load_input(fn)
%QUB400_LOAD_INPUT  Parse the 42-entry QUB 400 input deck (Prog.5.1 order).
%
%   inp = qub400_load_input()          uses ../../port/QUB400_INPUT.dat
%   inp = qub400_load_input(fn)        explicit path
%
%   Each deck line is  "value ! TAG ! unit ! source-line".
%   Values become fields named after TAG (SCAV$ -> inp.SCAV, SIL$ -> inp.SIL).
%   Strings are kept as char, numbers as double.
%
%   inp.n_entries    number of entries read          (expected 42)
%   inp.n_numeric    numeric entries                 (expected 40)
%   inp.n_strings    string entries                  (expected 2: SCAV, SIL)
%   inp.tags         cell array of tags, deck order
%   inp.units        cell array of units, deck order
%   inp.src          cell array of book line refs, deck order
%   inp.raw          n x 4 cell of the tokenised lines
%   inp.file         file actually read
%
%   The deck is in PROMPT order, not Fig.5.3 order. Block 1 is TCR, CCR,
%   TEXC and block 9 is NC, NE, BEFF, BDEG, TAF - see QUB400_CHECKLIST.md 0.2.

if nargin < 1 || isempty(fn)
    here = fileparts(mfilename('fullpath'));
    fn   = fullfile(here, '..', '..', 'port', 'QUB400_INPUT.dat');
end
if ~exist(fn, 'file')
    error('qub400_load_input:noFile', 'Input deck not found: %s', fn);
end

expected = {'BO','ST','CRL','RPM','TCR','CCR','TEXC', ...
            'EPO','EPFO','NEP','WEP','RTE','RBE', ...
            'TPO','TPFO','NTP','WTP','RTT','RBT','SCAV', ...
            'IPO','IPFO','NIP','WIP','RTI','RBI', ...
            'LEP1','DEP1','LEP2','DEP2','VBOX','SIL', ...
            'LTP','TRAR','LIP','DIP','THAR', ...
            'NC','NE','BEFF','BDEG','TAF'};

fid = fopen(fn, 'r');
if fid < 0
    error('qub400_load_input:open', 'Cannot open %s', fn);
end
cleanup = onCleanup(@() fclose(fid));

lines = {};
while true
    ln = fgetl(fid);
    if ~ischar(ln)
        break
    end
    if isempty(ln)
        continue
    end
    if double(ln(1)) == 65279                    % strip UTF-8 BOM
        ln = ln(2:end);
    end
    ln = strtrim(ln);
    if isempty(ln) || ln(1) == '#' || ln(1) == '%'
        continue
    end
    lines{end+1} = ln; %#ok<AGROW>
end

n = numel(lines);
inp = struct();
inp.file      = fn;
inp.n_entries = n;
inp.tags      = cell(1, n);
inp.units     = cell(1, n);
inp.src       = cell(1, n);
inp.raw       = cell(n, 4);
inp.n_numeric = 0;
inp.n_strings = 0;

for k = 1:n
    parts = strsplit(lines{k}, '!');
    if numel(parts) < 2
        error('qub400_load_input:parse', 'Line %d has no "!" separator: %s', k, lines{k});
    end
    val  = strtrim(parts{1});
    tagf = strtrim(parts{2});
    unit = '';
    src  = '';
    if numel(parts) >= 3, unit = strtrim(parts{3}); end
    if numel(parts) >= 4, src  = strtrim(parts{4}); end

    tag = regexp(tagf, '^[A-Za-z0-9_$]+', 'match', 'once');
    if isempty(tag)
        error('qub400_load_input:parse', 'Line %d has no tag: %s', k, lines{k});
    end
    tag = strrep(tag, '$', '');          % SCAV$ -> SCAV, SIL$ -> SIL

    num = str2double(val);
    if isnan(num) && ~strcmpi(val, 'nan')
        inp.(tag) = val;
        inp.n_strings = inp.n_strings + 1;
    else
        inp.(tag) = num;
        inp.n_numeric = inp.n_numeric + 1;
    end

    inp.tags{k}  = tag;
    inp.units{k} = unit;
    inp.src{k}   = src;
    inp.raw(k, :) = {val, tagf, unit, src};
end

if n ~= numel(expected)
    warning('qub400_load_input:count', ...
        'Deck has %d entries; Prog.5.1 expects %d.', n, numel(expected));
elseif ~isequal(inp.tags, expected)
    warning('qub400_load_input:order', ...
        'Deck tags are not in the expected Prog.5.1 prompt order.');
end

inp.expected_entries = numel(expected);
end
