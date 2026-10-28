% RUN_RX135_SWEEP  Full-throttle speed sweep of the RX135 proxy deck.
%
%   Deck:  sim\blair\RX135_PROXY.dat  (= port\RX135_INPUT.dat with the seven
%          NOT AVAILABLE fields replaced by the documented proxy block of
%          RX135_CASE_NOTES.md s8).  THE INLET IS A PROXY - there is no reed
%          model in Prog.5.1.  Nothing here tunes anything.
%
%   Writes RX135_SWEEP.csv in this folder.  One row per 500 rpm, 3000-9000,
%   throttle THAR = 1.0 (full).  Each point is run to the model's own
%   convergence test (blair_run), and a throwing point is caught and reported
%   rather than aborting the sweep.

clear; clc;
here = fileparts(mfilename('fullpath'));
if isempty(here), here = pwd; end
cd(here);
addpath(here);

deck = fullfile(here, 'RX135_PROXY.dat');

% ---- 1. Load and report the loader's view of the deck -------------------
lastwarn('');
[C, meta] = load_case(deck);
[wmsg, wid] = lastwarn;
fprintf('Deck: %s\n', deck);
if isempty(wmsg)
    fprintf('Loader warnings: (none)\n');
else
    fprintf('Loader warnings: %s\n', wmsg);
end

% ---- 2. Initialise and print the derived geometry -----------------------
mdl = blair_init(deck);
fprintf('\nDerived geometry from blair_init:\n');
fprintf('  swept volume        %8.2f cm3\n', pi/4*(C.BO/10)^2*(C.ST/10));
fprintf('  HEOT / EXHT         %8.3f / %8.3f mm\n', mdl.HEOT, mdl.EXHT);
fprintf('  HTOT / TRHT         %8.3f / %8.3f mm\n', mdl.HTOT, mdl.TRHT);
fprintf('  FEPRT               %8.2f mm2\n', mdl.FEPRT);
fprintf('  FTPRT               %8.2f mm2\n', mdl.FTPRT);
fprintf('  FTDUCT / DTDUCT     %8.2f mm2 / %6.2f mm\n', mdl.FTDUCT, mdl.DTDUCT);
fprintf('  CYCV                %8.3f cm3\n', mdl.CYCV);
fprintf('  FIPRT (inlet proxy) %8.2f mm2\n', mdl.FIPRT);
fprintf('  meshes KE1/KE2/KT/KI: %d / %d / %d / %d\n', mdl.KE1, mdl.KE2, mdl.KT, mdl.KI);

% ---- 3. Sweep ------------------------------------------------------------
rpms = 3000:500:9000;
n    = numel(rpms);
S = struct('rpm',num2cell(rpms), 'power_kW',NaN, 'torque_Nm',NaN, ...
    'bmep_bar',NaN, 'bsfc_gkWh',NaN, 'DR',NaN, 'TE',NaN, 'SE',NaN, ...
    'CE',NaN, 'pmax_bar',NaN, 'tmax_K',NaN, 'imep_bar',NaN, ...
    'pmep_bar',NaN, 'fmep_bar',NaN, 'peak_angle_deg',NaN, ...
    'converged',false, 'cycles',NaN, 'ok',false, 'err','', 'secs',NaN);

fprintf('\nFull-throttle sweep (THAR = 1.0), inlet = PROXY\n');
fprintf('%s\n', repmat('-', 1, 108));
fprintf('%6s %9s %9s %8s %8s %7s %7s %7s %8s %7s %4s %6s\n', ...
    'rpm','P[kW]','T[Nm]','BMEP','BSFC','DR','TE','SE','pmax','Tmax','cv','cyc');
fprintf('%s\n', repmat('-', 1, 108));

for i = 1:n
    t0 = tic;
    try
        mr = blair_run(mdl, rpms(i), 1.0);
        r  = mr.results;
        S(i).power_kW   = r.power_kW;
        S(i).torque_Nm  = r.power_kW*1000/(2*pi*rpms(i)/60);
        S(i).bmep_bar   = r.bmep_bar;
        S(i).bsfc_gkWh  = r.bsfc_gkWh;
        S(i).DR         = r.DR;
        S(i).TE         = r.TE;
        S(i).SE         = r.SE;
        S(i).CE         = r.CE;
        S(i).pmax_bar   = r.pmax_bar;
        S(i).tmax_K     = r.tmax_K;
        S(i).imep_bar   = r.imep_bar;
        S(i).pmep_bar   = r.pmep_bar;
        S(i).fmep_bar   = r.fmep_bar;
        S(i).peak_angle_deg = r.peak_angle_deg;
        S(i).converged  = logical(r.converged);
        S(i).cycles     = r.cycles;
        S(i).ok         = true;
        S(i).secs       = toc(t0);
        fprintf('%6d %9.3f %9.3f %8.3f %8.1f %7.4f %7.4f %7.4f %8.2f %7.1f %4d %6d\n', ...
            rpms(i), S(i).power_kW, S(i).torque_Nm, S(i).bmep_bar, ...
            S(i).bsfc_gkWh, S(i).DR, S(i).TE, S(i).SE, S(i).pmax_bar, ...
            S(i).tmax_K, S(i).converged, S(i).cycles);
    catch err
        S(i).err = sprintf('%s: %s', err.identifier, err.message);
        S(i).secs = toc(t0);
        fprintf('%6d   FAILED  %s\n', rpms(i), S(i).err);
    end
end
fprintf('%s\n', repmat('-', 1, 108));

% ---- 4. Save -------------------------------------------------------------
T = struct2table(S);
writetable(T, fullfile(here,'RX135_SWEEP.csv'));

ok = [S.ok];
fprintf('\n%d/%d points returned, %d converged, %d failed.\n', ...
    nnz(ok), n, nnz([S.converged]), n-nnz(ok));
if all(ok)
    [pk, ip] = max([S.power_kW]);
    fprintf('Peak power %.3f kW at %d rpm (%.3f Nm, BMEP %.2f bar, BSFC %.0f g/kWh)\n', ...
        pk, S(ip).rpm, S(ip).torque_Nm, S(ip).bmep_bar, S(ip).bsfc_gkWh);
    fprintf('  at peak: DR %.4f  TE %.4f  SE %.4f  pmax %.2f bar  Tmax %.0f K\n', ...
        S(ip).DR, S(ip).TE, S(ip).SE, S(ip).pmax_bar, S(ip).tmax_K);
end
if any(~ok)
    fprintf('FAILED POINTS:\n');
    for i = find(~ok)'
        fprintf('  %d rpm: %s\n', S(i).rpm, S(i).err);
    end
end
