% sensitivity_study_4s.m
addpath(fileparts(mfilename('fullpath')));
addpath('C:\Users\malliath\Desktop\engine_sim\Yamaha_RX135_India\matlab');
P0 = params_rx135_4s();
M0 = engine_model_4s(P0);

fields = fieldnames(P0.sweep);
nP = numel(fields);
results = table('Size',[0 6],'VariableTypes',{'string','double','double','double','double','double'},...
    'VariableNames',{'param','base','low','high','dPower_low_pct','dPower_high_pct'});

figure('Name','RX135 4s sensitivity');
tiledlayout(nP,1);

for k = 1:nP
    f = fields{k};
    rngv = P0.sweep.(f);
    lo = rngv(1); hi = rngv(2); n = rngv(3);
    vals = linspace(lo, hi, n);
    pw = zeros(size(vals));
    for i = 1:n
        M = engine_model_4s(P0, f, vals(i));
        pw(i) = M.power_ps;
    end
    dLow  = (pw(1)   - M0.power_ps)/M0.power_ps*100;
    dHigh = (pw(end) - M0.power_ps)/M0.power_ps*100;
    results = [results; {string(f), P0.(f), lo, hi, dLow, dHigh}]; %#ok<AGROW>

    nexttile;
    plot(vals, pw, '-o','LineWidth',1.5); grid on;
    hold on; plot(P0.(f), M0.power_ps, 'r*','MarkerSize',10);
    xlabel(f); ylabel('Power (PS)');
    title(sprintf('%s  (base %.3g,  %+.1f%% / %+.1f%%)', f, P0.(f), dLow, dHigh));
end

figure('Name','Tornado - power (4s)');
names = cellstr(results.param);
low  = results.dPower_low_pct;
high = results.dPower_high_pct;
[~,ord] = sort(max(abs(low),abs(high)),'descend');
names = names(ord); low = low(ord); high = high(ord);
barh(categorical(names), [low high]);
xlabel('% change in power vs baseline'); title('OAT sensitivity (RX135 4s surrogate)');
legend('low','high','Location','best'); grid on;

outDir = fileparts(mfilename('fullpath'));
save(fullfile(outDir,'sensitivity_results_4s.mat'),'P0','M0','results');
writetable(results, fullfile(outDir,'sensitivity_results_4s.csv'));
fprintf('\nBaseline: %.2f PS @ %d rpm, %.2f Nm\n', M0.power_ps, P0.power_rpm, M0.torque_nm);
disp(results);
