% RX135_DIAGNOSTICS  Two checks that qualify the sweep numbers:
%   (a) does the port reproduce Blair's own QUB 400 reference case?
%   (b) do the points that missed the 1 %/cycle test settle if run longer?

clear; clc;
here = fileparts(mfilename('fullpath'));
if isempty(here), here = pwd; end
cd(here); addpath(here);

%% (a) Port fidelity against Blair Fig.5.9 (QUB 400, 3000 rpm, WOT)
fprintf('\n===== (a) PORT FIDELITY: QUB 400 reference case =====\n');
T = blair_validate('C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat', true);
fprintf('mean |model/Blair - 1| = %.1f %%\n', 100*mean(abs(T.ratio-1)));

%% (b) convergence at the points bailed out at the 5-cycle floor
fprintf('\n===== (b) LONG RUNS AT THE NON-CONVERGED POINTS =====\n');
deck = fullfile(here, 'RX135_PROXY.dat');
base = blair_init(deck);

for rpm = [4000 6000 6500 9000]
    m = base;
    m.CYCLESTOP = 16;                 % up to 15 completed cycles
    m = blair_run(m, rpm, 1.0);
    h = m.hist;
    fprintf('\n--- %d rpm, %d cycles (converged flag %d) ---\n', rpm, h.cycles(end), m.results.converged);
    fprintf('%3s %8s %8s %8s %8s %8s %8s\n','cyc','DR','TE','SE','BMEP','P[kW]','BSFC');
    for k = 1:numel(h.cycles)
        fprintf('%3d %8.4f %8.4f %8.4f %8.4f %8.4f %8.1f\n', h.cycles(k), h.DR(k), ...
            h.TE(k), h.SE(k), h.BMEP(k)/1e5, h.POWER(k), h.BSFC(k)*1000);
    end
    % cycle-to-cycle drift over the last two cycles, and vs the reported 5th
    dP = 100*abs(h.POWER(end)-h.POWER(end-1))/abs(h.POWER(end));
    dD = 100*abs(h.DR(end)-h.DR(end-1))/abs(h.DR(end));
    d5 = 100*abs(h.POWER(end)-h.POWER(5))/abs(h.POWER(end));
    fprintf('last-cycle change: P %.3f %%  DR %.3f %%   |  cycle15 vs cycle5 power: %.2f %%\n', dP, dD, d5);
end
