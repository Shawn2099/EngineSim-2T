% RX135_V2_CHECK  Post-repair QUB 400 validation score + RX135 peak detail.
clear; clc;
here = fileparts(mfilename('fullpath'));
if isempty(here), here = pwd; end
cd(here); addpath(here);

fid = fopen(fullfile(here,'rx135_v2_check.txt'),'w');
cleaner = onCleanup(@() fclose(fid));

deckq = 'C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat';

fprintf(fid,'=== QUB 400 validation score, REPAIRED port ===\n');
T = blair_validate(deckq, false);
fprintf(fid,'mean |model/Blair - 1| = %.1f %%   (as-printed port: 8.7 %%)\n', 100*mean(abs(T.ratio-1)));
% worst offenders by |ratio-1|
[~,ix] = sort(abs(T.ratio-1),'descend');
fprintf(fid,'\n%-24s %12s %12s %8s\n','quantity','model','Blair','ratio');
for k = ix(1:min(12,height(T)))'
    fprintf(fid,'%-24s %12.4g %12.4g %8.3f\n', T.quantity{k}, T.model(k), T.blair(k), T.ratio(k));
end
fprintf(fid,'\n');

fprintf(fid,'=== RX135 peak point detail (7500 rpm, repaired) ===\n');
mdl = blair_init(fullfile(here,'RX135_PROXY.dat'));
m = blair_run(mdl, 7500, 1.0);
r = m.results;
fn = fieldnames(r);
for k = 1:numel(fn)
    v = r.(fn{k});
    if isnumeric(v) && isscalar(v)
        fprintf(fid,'  %-20s %12.5g\n', fn{k}, v);
    end
end

fprintf(fid,'\n=== Bias-corrected sweep (factor 1.0274) ===\n');
S = readtable(fullfile(here,'RX135_SWEEP_v2.csv'));
f = 12.534/12.20;
fprintf(fid,'%6s %10s %12s %10s %10s\n','rpm','Praw_kW','Pcorr_kW','Tcorr_Nm','BMEPcorr');
for i = 1:height(S)
    fprintf(fid,'%6d %10.3f %12.3f %10.3f %10.3f\n', S.rpm(i), S.power_kW(i), ...
        S.power_kW(i)/f, S.power_kW(i)/f*1000/(2*pi*S.rpm(i)/60), S.bmep_bar(i)/1.0279);
end
[pk,ip] = max(S.power_kW);
fprintf(fid,'\npeak raw %.3f kW @ %d ; corrected %.3f kW\n', pk, S.rpm(ip), pk/f);
fprintf('\nwrote rx135_v2_check.txt\n');
