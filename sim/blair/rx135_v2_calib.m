% RX135_V2_CALIB  One-point calibration of the repaired port.
%
% Runs Blair's own QUB 400 case A (3000 rpm, WOT, SCRE, cycle 5) twice:
% once with the repaired VOLINC (CDT included, the default) and once with
% the as-printed VOLINC, so the bias factor is measured on the repaired code
% and the repair itself is visible in the same table.
%
% Writes rx135_v2_calib.txt in this folder.

clear; clc;
here = fileparts(mfilename('fullpath'));
if isempty(here), here = pwd; end
cd(here); addpath(here);

fid = fopen(fullfile(here,'rx135_v2_calib.txt'),'w');
if fid < 0, error('cannot open output'); end
cleaner = onCleanup(@() fclose(fid));

deck = 'C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat';

fprintf(fid, '=== QUB 400 case A, 3000 rpm WOT SCRE, 5 cycles ===\n');
fprintf(fid, 'published (Fig.5.9): power 12.20 kW, BMEP 6.14 bar, DR 0.854, SE 0.818, TE 0.504\n\n');
fprintf(fid, '%-22s %9s %9s %9s %8s %8s %8s\n','variant','P[kW]','BMEP','BSFC','DR','SE','TE');
fprintf(fid, '%s\n', repmat('-',1,86));

out = struct();
for v = {'repaired','as_printed'}
    tag = v{1};
    mdl = blair_init(deck);
    if strcmp(tag,'as_printed')
        mdl.VOLINC_AS_PRINTED = true;
    end
    m = blair_run(mdl, 3000, 1.0);
    r = m.results;
    out.(tag) = r;
    fprintf(fid, '%-22s %9.3f %9.3f %9.1f %8.4f %8.4f %8.4f\n', ...
        tag, r.power_kW, r.bmep_bar, r.bsfc_gkWh, r.DR, r.SE, r.TE);
    fprintf('%-22s %9.3f %9.3f %9.1f %8.4f %8.4f %8.4f\n', ...
        tag, r.power_kW, r.bmep_bar, r.bsfc_gkWh, r.DR, r.SE, r.TE);
end

fprintf(fid, '%s\n', repmat('-',1,86));
Ppub = 12.20;
f_rep = out.repaired.power_kW / Ppub;
f_old = out.as_printed.power_kW / Ppub;
fprintf(fid, '\nPOWER BIAS vs Blair''s 12.20 kW\n');
fprintf(fid, '  repaired   : %.3f kW  ->  factor %.4f  (%+.1f %%)\n', ...
    out.repaired.power_kW, f_rep, 100*(f_rep-1));
fprintf(fid, '  as-printed : %.3f kW  ->  factor %.4f  (%+.1f %%)\n', ...
    out.as_printed.power_kW, f_old, 100*(f_old-1));
fprintf(fid, '  repair effect on QUB 400 power: %+.1f %%\n', 100*(out.repaired.power_kW/out.as_printed.power_kW-1));

fprintf(fid, '\nOther repaired-vs-published ratios:\n');
fprintf(fid, '  BMEP %.4f   BSFC %.4f   DR %.4f   SE %.4f   TE %.4f\n', ...
    out.repaired.bmep_bar/6.14, out.repaired.bsfc_gkWh/464, ...
    out.repaired.DR/0.854, out.repaired.SE/0.818, out.repaired.TE/0.504);

fprintf(fid, '\nBIAS FACTORS TO USE (repaired code):\n');
fprintf(fid, '  power  divide by %.4f\n', f_rep);
fprintf(fid, '  bmep   divide by %.4f\n', out.repaired.bmep_bar/6.14);

save(fullfile(here,'rx135_v2_calib.mat'),'out','f_rep','f_old');
fprintf('\nwrote %s\n', fullfile(here,'rx135_v2_calib.txt'));
