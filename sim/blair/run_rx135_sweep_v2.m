% RUN_RX135_SWEEP_V2  Full-throttle sweep of the RX135 proxy deck, REPAIRED port.
%
%   Identical to run_rx135_sweep.m except:
%     * runs on the repaired blair_step.m (VOLINC carries the CDT factor,
%       m.VOLINC_AS_PRINTED left false)
%     * writes RX135_SWEEP_v2.csv (the v1 record is preserved)
%     * re-runs every point that misses the 1 %/cycle test out to 15 cycles
%       and records the cycle history, so the convergence flag can be
%       classified rather than just reported
%
%   THE INLET IS STILL A PROXY (piston-port block, no reed model).

clear; clc;
here = fileparts(mfilename('fullpath'));
if isempty(here), here = pwd; end
cd(here); addpath(here);

deck = fullfile(here, 'RX135_PROXY.dat');

[C, meta] = load_case(deck);                                     %#ok<ASGLU>
mdl = blair_init(deck);
fprintf('Deck: %s\n', deck);
fprintf('VOLINC repaired: %d\n', ~(isfield(mdl,'VOLINC_AS_PRINTED') && mdl.VOLINC_AS_PRINTED));
fprintf('  FIPRT %.2f mm2   CYCV %.3f cm3   FEPRT %.2f   FTPRT %.2f\n', ...
    mdl.FIPRT, mdl.CYCV, mdl.FEPRT, mdl.FTPRT);

rpms = 3000:500:9000;
n    = numel(rpms);
S = struct('rpm',num2cell(rpms), 'power_kW',NaN, 'torque_Nm',NaN, ...
    'bmep_bar',NaN, 'bsfc_gkWh',NaN, 'DR',NaN, 'TE',NaN, 'SE',NaN, ...
    'CE',NaN, 'pmax_bar',NaN, 'tmax_K',NaN, 'imep_bar',NaN, ...
    'pmep_bar',NaN, 'fmep_bar',NaN, 'peak_angle_deg',NaN, ...
    'converged',false, 'cycles',NaN, 'ok',false, 'err','', 'secs',NaN);

fprintf('\nFull-throttle sweep (THAR = 1.0), inlet = PROXY, port REPAIRED\n');
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

T = struct2table(S);
writetable(T, fullfile(here,'RX135_SWEEP_v2.csv'));

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

%% ---- convergence forensics on the points that missed the test ----
fprintf('\n===== LONG RUNS AT THE NON-CONVERGED POINTS =====\n');
bad = rpms(~[S.converged] & ok);
if isempty(bad)
    fprintf('all points met the 1 %%/cycle test\n');
else
    fprintf('%3s %8s %8s %8s %8s %8s %8s\n','cyc','DR','TE','SE','BMEP','P[kW]','BSFC');
    for rpm = bad
        m = mdl; m.CYCLESTOP = 16;
        m = blair_run(m, rpm, 1.0);
        h = m.hist;
        fprintf('\n--- %d rpm, %d cycles (flag %d) ---\n', rpm, h.cycles(end), m.results.converged);
        for k = 1:numel(h.cycles)
            fprintf('%3d %8.4f %8.4f %8.4f %8.4f %8.4f %8.1f\n', h.cycles(k), h.DR(k), ...
                h.TE(k), h.SE(k), h.BMEP(k)/1e5, h.POWER(k), h.BSFC(k)*1000);
        end
        dP = 100*abs(h.POWER(end)-h.POWER(end-1))/abs(h.POWER(end));
        dD = 100*abs(h.DR(end)-h.DR(end-1))/abs(h.DR(end));
        d5 = 100*abs(h.POWER(end)-h.POWER(5))/abs(h.POWER(end));
        fprintf('last-cycle change: P %.3f %%  DR %.3f %%   |  cycle15 vs cycle5 power: %.2f %%\n', dP, dD, d5);
    end
end
