function png_file = plot_curve(mdl_table, opts)
%PLOT_CURVE  Plot a sweep table and save it as a PNG.
%
%   PNG = PLOT_CURVE(T) plots the table returned by sweep.m:
%     power, torque (derived from power and rpm), bmep, bsfc, and the
%     DR/TE/SE delivery ratios against engine speed, one line per throttle
%     setting. The figure is written to CONFIG.plot_dir (sim\blair\plots\)
%     and the PNG path is returned.
%
%   PNG = PLOT_CURVE(T, OPTS) with OPTS fields:
%     show      false (default) - leave the figure hidden; true shows it
%     prefix    'sweep' (default) - PNG filename prefix
%     dir       override the output directory
%     resolution 150 (default) - PNG resolution, dpi
%
%   WHAT IS PLOTTED
%     The six panels are power [kW], torque [N.m], bmep [bar],
%     bsfc [g/kWh], the efficiencies [%], and peak pressure/temperature.
%     Torque is computed, not carried in the table:
%         T [N.m] = P [kW] * 1000 / (2*pi*rpm/60)
%     Colour identifies the throttle area ratio; the caption of the figure
%     states the mapping. DR, TE and SE use solid, dashed and dotted lines
%     respectively inside the efficiency panel.
%
%   EFFICIENCY UNITS
%     Blair prints DR, SE, TE and CE as percentages, but the interface
%     contract does not fix the scale. If every efficiency value in the
%     table is <= 1.5 the values are treated as fractions and multiplied by
%     100 for display; otherwise they are assumed to be percent already.
%
%   FAILED POINTS
%     Rows with ok = false or NaN physics are skipped per series, so a
%     partially failed sweep still plots the points that worked.
%
%   See also SWEEP.

% -------------------------------------------------------------------------
% CONFIG - the only place in this file where a path appears.
% -------------------------------------------------------------------------
CONFIG = struct();
CONFIG.plot_dir   = fullfile(fileparts(mfilename('fullpath')), 'plots');
CONFIG.prefix     = 'sweep';
CONFIG.resolution = 150;
CONFIG.fig_size   = [80 60 1500 820];
CONFIG.required   = {'rpm', 'throttle', 'power_kW', 'bmep_bar', 'bsfc_gkWh', 'DR', 'SE', 'TE'};

% -------------------------------------------------------------------------
% 0. Arguments and validation
% -------------------------------------------------------------------------
if nargin < 2 || isempty(opts)
    opts = struct();
end
if ~isstruct(opts)
    error('blair:plot_curve:badInput', 'opts must be a struct, got %s.', class(opts));
end
def = struct('show', false, 'prefix', CONFIG.prefix, ...
             'dir', CONFIG.plot_dir, 'resolution', CONFIG.resolution);
fn = fieldnames(def);
for i = 1:numel(fn)
    if ~isfield(opts, fn{i}), opts.(fn{i}) = def.(fn{i}); end
end

if ~istable(mdl_table)
    error('blair:plot_curve:badInput', ...
        'Input must be the table returned by sweep.m, got %s.', class(mdl_table));
end
if height(mdl_table) == 0
    error('blair:plot_curve:empty', ...
        'The sweep table has no rows; nothing to plot. Run sweep() first.');
end

vars    = mdl_table.Properties.VariableNames;
missing = CONFIG.required(~ismember(CONFIG.required, vars));
if ~isempty(missing)
    error('blair:plot_curve:badTable', ...
        ['The table is missing required column(s): %s\n' ...
         'Pass the table returned by sweep.m unchanged, or add the columns.'], ...
        strjoin(missing, ', '));
end

rpm  = column_of(mdl_table, 'rpm');
thr  = column_of(mdl_table, 'throttle');
if any(rpm <= 0)
    error('blair:plot_curve:badTable', 'rpm must be positive to derive torque.');
end

% -------------------------------------------------------------------------
% 1. Series and grouping
% -------------------------------------------------------------------------
uthr = unique(thr(isfinite(thr)));
if isempty(uthr)
    error('blair:plot_curve:badTable', 'No finite throttle values in the table.');
end
colors = lines(max(numel(uthr), 1));
thr_labels = arrayfun(@(x) sprintf('thr %.2f', x), uthr, 'UniformOutput', false);

power  = column_of(mdl_table, 'power_kW');
torque = power * 1000 ./ (2*pi*rpm/60);
bmep   = column_of(mdl_table, 'bmep_bar');
bsfc   = column_of(mdl_table, 'bsfc_gkWh');

DR = column_of(mdl_table, 'DR');
SE = column_of(mdl_table, 'SE');
TE = column_of(mdl_table, 'TE');

fin   = [DR; SE; TE];
fin   = fin(isfinite(fin));
scale = 1;
if ~isempty(fin) && max(abs(fin)) <= 1.5
    scale = 100;    % fractions -> percent
end
DR = DR*scale; SE = SE*scale; TE = TE*scale;

pmax = column_of(mdl_table, 'pmax_bar');
tmax = column_of(mdl_table, 'tmax_K');

% -------------------------------------------------------------------------
% 2. Figure
% -------------------------------------------------------------------------
vis = 'off';
if opts.show, vis = 'on'; end
fig = figure('Color', 'w', 'Visible', vis, 'Position', CONFIG.fig_size, ...
             'Name', 'Blair sweep', 'NumberTitle', 'off');

% --- 1 power -------------------------------------------------------------
ax = subplot(2,3,1);
h  = plot_groups(ax, rpm, thr, power, uthr, colors, '-o', 1.5);
ylabel(ax, 'Power [kW]');
title(ax, 'Power');
grid(ax, 'on');
if numel(uthr) <= 6
    legend(ax, h, thr_labels, 'Location', 'northwest', 'FontSize', 8);
end

% --- 2 torque (derived) --------------------------------------------------
ax = subplot(2,3,2);
plot_groups(ax, rpm, thr, torque, uthr, colors, '-o', 1.5);
ylabel(ax, 'Torque [N.m]');
title(ax, 'Torque');
grid(ax, 'on');

% --- 3 bmep --------------------------------------------------------------
ax = subplot(2,3,3);
plot_groups(ax, rpm, thr, bmep, uthr, colors, '-o', 1.5);
ylabel(ax, 'BMEP [bar]');
title(ax, 'Brake mean effective pressure');
grid(ax, 'on');

% --- 4 bsfc --------------------------------------------------------------
ax = subplot(2,3,4);
plot_groups(ax, rpm, thr, bsfc, uthr, colors, '-o', 1.5);
ylabel(ax, 'BSFC [g/kWh]');
title(ax, 'Specific fuel consumption');
grid(ax, 'on');

% --- 5 delivery ratios ---------------------------------------------------
ax = subplot(2,3,5);
hold(ax, 'on');
for k = 1:numel(uthr)
    plot_one(ax, rpm, thr, DR, uthr(k), colors(k,:), '-',  1.5);
    plot_one(ax, rpm, thr, TE, uthr(k), colors(k,:), '--', 1.2);
    plot_one(ax, rpm, thr, SE, uthr(k), colors(k,:), ':',  1.4);
end
hold(ax, 'off');
ylabel(ax, 'DR / TE / SE [%]');
title(ax, 'Delivery ratios (colour = throttle)');
grid(ax, 'on');
hold(ax, 'on');
hd = plot(ax, nan, nan, 'k-',  'LineWidth', 1.5);
ht = plot(ax, nan, nan, 'k--', 'LineWidth', 1.2);
hs = plot(ax, nan, nan, 'k:',  'LineWidth', 1.4);
hold(ax, 'off');
legend(ax, [hd ht hs], {'DR', 'TE', 'SE'}, 'Location', 'best', 'FontSize', 8);

% --- 6 peak pressure / temperature --------------------------------------
ax = subplot(2,3,6);
if any(isfinite(pmax)) || any(isfinite(tmax))
    yyaxis(ax, 'left');
    plot_groups(ax, rpm, thr, pmax, uthr, colors, '-', 1.4);
    ylabel(ax, 'p_{max} [bar]');
    set(ax, 'YColor', [0 0 0]);
    yyaxis(ax, 'right');
    if any(isfinite(tmax))
        plot_groups(ax, rpm, thr, tmax, uthr, colors, '--', 1.2);
        ylabel(ax, 'T_{max} [K]');
        set(ax, 'YColor', [0.35 0.35 0.35]);
    end
    title(ax, 'Peak pressure / temperature');
    grid(ax, 'on');
else
    axis(ax, 'off');
    text(ax, 0.5, 0.5, 'no pmax / tmax data', 'Units', 'normalized', ...
        'HorizontalAlignment', 'center', 'Color', [0.4 0.4 0.4], 'FontSize', 11);
end

% --- caption -------------------------------------------------------------
ud     = mdl_table.Properties.UserData;
casenm = name_of_case(ud);
sgtitle(sprintf('%s   %d rpm x %d throttle   (%d point%s)', ...
    casenm, numel(ud_field(ud, 'rpm_list', unique(rpm))), ...
    numel(uthr), height(mdl_table), plural(height(mdl_table))), ...
    'Interpreter', 'none', 'FontSize', 13);

% -------------------------------------------------------------------------
% 3. Save
% -------------------------------------------------------------------------
outdir = char(opts.dir);
if exist(outdir, 'dir') ~= 7
    [ok, msg] = mkdir(outdir);
    if ~ok
        error('blair:plot_curve:mkdirFailed', ...
            'Could not create plot directory %s:\n  %s', outdir, msg);
    end
end

stamp    = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
png_file = fullfile(outdir, sprintf('%s_%s_%s.png', ...
    char(opts.prefix), casenm, stamp));

res = opts.resolution;
if exist('exportgraphics', 'file') == 2
    exportgraphics(fig, png_file, 'Resolution', res);
else
    print(fig, png_file, '-dpng', sprintf('-r%d', res));
end

if ~opts.show
    close(fig);
end

fprintf('  plot_curve: wrote %s\n', png_file);
end % plot_curve


% =========================================================================
% Plotting helpers
% =========================================================================
function h = plot_groups(ax, rpm, thr, y, uthr, colors, style, lw)
hold(ax, 'on');
h = gobjects(0);
for k = 1:numel(uthr)
    hk = plot_one(ax, rpm, thr, y, uthr(k), colors(k,:), style, lw);
    if ~isempty(hk)
        h(end+1) = hk; %#ok<AGROW>
    end
end
hold(ax, 'off');
if isempty(h)
    axis(ax, 'off');
    text(ax, 0.5, 0.5, 'no data', 'Units', 'normalized', ...
        'HorizontalAlignment', 'center', 'Color', [0.4 0.4 0.4], 'FontSize', 11);
    h = [];
end
end

function h = plot_one(ax, rpm, thr, y, tval, col, style, lw)
h = [];
m = group_mask(thr, tval) & isfinite(y) & isfinite(rpm);
if ~any(m)
    return
end
[xs, isrt] = sort(rpm(m));
ys = y(m);
ys = ys(isrt);
[xs, iu] = unique(xs, 'stable');        % one point per rpm at this throttle
ys = ys(iu);
h = plot(ax, xs, ys, style, 'Color', col, 'LineWidth', lw, 'MarkerSize', 4);
end

function m = group_mask(thr, tval)
if isnan(tval)
    m = isnan(thr);
else
    m = thr == tval;
end
end


% =========================================================================
% Table and text helpers
% =========================================================================
function v = column_of(t, name)
v = nan(height(t), 1);
if ismember(name, t.Properties.VariableNames)
    raw = t.(name);
    if isnumeric(raw) || islogical(raw)
        v = double(raw);
        v = v(:);
    end
end
end

function v = ud_field(ud, name, fallback)
v = fallback;
if isstruct(ud) && isfield(ud, name) && ~isempty(ud.(name))
    v = ud.(name);
end
end

function s = name_of_case(ud)
s = 'series';
if isstruct(ud) && isfield(ud, 'casepath') && ~isempty(ud.casepath)
    [~, s] = fileparts(char(ud.casepath));
    s = regexprep(s, '[^A-Za-z0-9_-]', '_');
    if isempty(s)
        s = 'series';
    end
end
end

function s = plural(n)
if n == 1, s = ''; else, s = 's'; end
end
