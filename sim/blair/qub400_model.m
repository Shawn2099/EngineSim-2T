function r = qub400_model(inp, over)
%QUB400_MODEL  Adapter: the Blair Prog.5.1 port for the QUB 400 harness.
%
%   r = qub400_model(inp, over)
%
%   Called by run_qub400.m once per published operating point. It is a thin
%   bridge ONLY: it writes the deck fields into a case file, calls
%   BLAIR_INIT / BLAIR_RUN, and renames the results into the checker's
%   canonical fields. No physics lives here.
%
% INPUTS
%   inp   struct from qub400_load_input: the 42 deck entries in Prog.5.1
%         prompt order, in deck units (mm, deg, rev/min, cm^3, degC).
%   over  struct: .case_id  'A'|'B'|'C'
%                 .rpm      overrides inp.RPM
%                 .throttle overrides inp.THAR
%                 .scav     overrides inp.SCAV   (ignored if empty)
%                 .cycles   cycles Blair should run (default 7, see below)
%
% OUTPUT
%   r.values  the canonical fields check_qub400.m scores:
%             power_kW bsfc_kgkWh bmep_bar imep_bar pmep_bar fmep_bar
%             pmax_bar tmax_K peak_angle_deg dr se te ce sr srv
%             exhaust_flow_ratio swept_volume_cm3
%
% WHY A CASE FILE IN A TEMP DIRECTORY
%   BLAIR_INIT's contract is a case path (load_case). Writing the deck back
%   out is the least surprising way to honour it, and it keeps this adapter
%   free of a second copy of the input parser. The file is named after the
%   case id and deleted afterwards.
%
% SEE ALSO BLAIR_INIT, BLAIR_RUN, RUN_QUB400.

if nargin < 2 || isempty(over)
    over = struct();
end

% ---- the deck, written in the "value ! TAG" form load_case reads ----------
here  = fileparts(mfilename('fullpath'));
order = {'BO','ST','CRL','RPM','TCR','CCR','TEXC', ...
         'EPO','EPFO','NEP','WEP','RTE','RBE', ...
         'TPO','TPFO','NTP','WTP','RTT','RBT','SCAV', ...
         'IPO','IPFO','NIP','WIP','RTI','RBI', ...
         'LEP1','DEP1','LEP2','DEP2','VBOX','SIL', ...
         'LTP','TRAR','LIP','DIP','THAR', ...
         'NC','NE','BEFF','BDEG','TAF'};

deck = inp;
if isfield(over, 'rpm')      && ~isempty(over.rpm),      deck.RPM  = over.rpm;      end
if isfield(over, 'throttle') && ~isempty(over.throttle), deck.THAR = over.throttle; end
if isfield(over, 'scav')     && ~isempty(over.scav),     deck.SCAV = over.scav;     end

cid = 'X';
if isfield(over, 'case_id') && ~isempty(over.case_id)
    cid = char(over.case_id);
end
fn = fullfile(tempdir, sprintf('qub400_case_%s.dat', cid));
fid = fopen(fn, 'w');
if fid < 0
    error('qub400_model:file', 'cannot write %s', fn);
end
for k = 1:numel(order)
    nm = order{k};
    v  = deck.(nm);
    if ischar(v)
        fprintf(fid, '%s ! %s ! - ! adapter\n', v, nm);
    else
        fprintf(fid, '%.12g ! %s ! - ! adapter\n', v, nm);
    end
end
fclose(fid);
cleaner = onCleanup(@() delete_if_exists(fn));

mdl = blair_init(fn);

% Blair's run length. run_qub400 asks for 5 cycles; Prog.5.1's own CYCLESTOP
% is 7, which yields five COMPLETE cycles plus a partial sixth, and the fifth
% is the one Fig.5.9/5.13 report. BLAIR_RUN already stops at the first
% converged cycle but never before the fifth, so leaving CYCLESTOP alone
% reproduces Blair and a smaller .cycles cannot make it report an earlier one.
if isfield(over, 'cycles') && ~isempty(over.cycles) && over.cycles > 5
    mdl.CYCLESTOP = min(over.cycles, 19);
    mdl.CYCLEP    = mdl.CYCLESTOP + 10;
end

mdl = blair_run(mdl);

res = mdl.results;
v = struct();
v.power_kW           = res.power_kW;
v.bsfc_kgkWh         = res.bsfc_gkWh/1000;
v.bmep_bar           = res.bmep_bar;
v.imep_bar           = res.imep_bar;
v.pmep_bar           = res.pmep_bar;
v.fmep_bar           = res.fmep_bar;
v.pmax_bar           = res.pmax_bar;
v.tmax_K             = res.tmax_K;
v.peak_angle_deg     = res.peak_angle_deg;
v.dr                 = res.DR;
v.se                 = res.SE;
v.te                 = res.TE;
v.ce                 = res.CE;
v.sr                 = res.sr;
v.srv                = res.srv;
v.exhaust_flow_ratio = res.exhaust_flow_ratio;
v.swept_volume_cm3   = res.swept_volume_cm3;

r = struct('case_id', cid, 'rpm', deck.RPM, 'throttle', deck.THAR, 'values', v);

end


function delete_if_exists(fn)
if exist(fn, 'file') == 2
    delete(fn);
end
end
