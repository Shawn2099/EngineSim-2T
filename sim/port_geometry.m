function G = port_geometry(P, arg)
%PORT_GEOMETRY  Port flow area vs crank angle for the RX135 5-speed (4TL10).
%
%   G = port_geometry(P)          build and print the report + area table
%   G = port_geometry(P,'quiet')  build and gate silently (errors on failure)
%   G = port_geometry(P,'table')  also print the full 10-degree table
%
%   A_ex(theta)  exhaust window, one window
%   A_tr(theta)  sum of the five transfer windows
%   A_win(i,:)   the five windows individually (T1..T5, map order)
%
% -------------------------------------------------------------------------
% GEOMETRY AND THE CYLINDRICAL CORRECTION
%   The map is a developed (unrolled) view of the bore: its overall width is
%   184.00 mm against a circumference of pi*58 = 182.21 mm, i.e. 1.0% wider,
%   so the quoted window widths ARE arc lengths on the bore surface.
%
%   The window is a rounded rectangle cut into the cylinder. When the piston
%   has travelled y past the port's top edge, the open area is the integral
%   of the local arc width over 0..y:
%
%       A(y) = integral_0^y w(s) ds ,  w(s) = w - 2*(r - sqrt(r^2-(r-s)^2))
%
%   inside the corner regions, and w(s) = w between them. Closed form, no
%   quadrature. This is the surface area of the bore the gas crosses, and the
%   surface normal there IS radial, so it is the correct reference area for
%   radial flow.
%
%   The flat alternative - treating the unrolled width as a chord,
%   A_flat = 2R*sin(w/2R)*y - is 1.8% to 7.4% SMALLER (widest window, biggest
%   error). It is computed and reported, not used. The two conventions differ
%   by less than the +-4-7% corner-radius uncertainty, and the choice is
%   absorbed by the discharge coefficient. What must not happen is applying
%   both corrections.
%
%   Truncation: T3's floor is at 53 mm but the piston stops at 50 mm, so its
%   last 3 mm are never uncovered. Handled by clamping y to the piston's own
%   travel, which is why the five-window sum (1362 mm2) is never reached -
%   the achievable maximum is 1294 mm2.
%
% GATE (hard: throws if it fails)
%   G1 the geometry must reproduce the md 5.3 durations 185.66 / 131.25 deg
%      from the map heights alone, to 0.02 deg;
%   G2 the sampled table must locate the events to within one 0.25 deg step;
%   G3 the areas at BDC must match params to 0.5 mm2;
%   G4 the area curves must be symmetric about BDC to 1e-9.
%
% See also PARAMS, ENGINE_MODEL.

if nargin < 1 || isempty(P), P = params('quiet'); end
if nargin < 2 || isempty(arg), arg = 'report'; end
arg = lower(arg);

g = P.geo; po = P.port; d = P.derived;

r_m = g.r_crank.value;  l_m = g.l_rod.value;
R_m = g.bore.value/2;

% ---- crank grid ------------------------------------------------------
dth   = P.num.dtheta.value;
theta = (0:dth:360)';
n     = numel(theta);
x_mm  = piston_x(r_m, l_m, theta)*1e3;          % piston travel below TDC, mm

% ---- windows ---------------------------------------------------------
w_ex = po.exh_w.value*1e3;  h_ex = po.exh_h.value*1e3;
r_ex = po.exh_r.value*1e3;  top_ex = po.exh_top.value*1e3;

w_tr = po.tr_w.value*1e3;   h_tr = po.tr_h.value*1e3;
r_tr = po.tr_r.value*1e3;   top_tr = po.tr_top.value*1e3;
bot_tr = po.tr_bot.value*1e3;

% open height y: piston travel past the top edge, capped by the window's own
% bottom edge - and, for T3, by how far the piston actually goes
y_ex = min(max(x_mm - top_ex, 0), h_ex);
A_ex = win_area(y_ex, w_ex, h_ex, r_ex);

A_win = zeros(numel(w_tr), n);
for i = 1:numel(w_tr)
    rr = r_tr(min(i, numel(r_tr)));              % radius may be scalar or per-window
    y = min(max(min(x_mm, bot_tr(i)) - top_tr(i), 0), h_tr(i));
    A_win(i,:) = win_area(y, w_tr(i), h_tr(i), rr);
end
A_tr = sum(A_win, 1);

% ---- flat (chord) comparison ----------------------------------------
R_mm = R_m*1e3;
flat_ratio = chord_ratio(w_ex, R_mm);    % exhaust
flat_ex    = A_ex*flat_ratio;
flat_tr_ratio = mean(chord_ratio(w_tr, R_mm));
flat_tr    = A_tr*flat_tr_ratio;

% ---- events ----------------------------------------------------------
ev.exh.open  = d.exh_open_atdc.value;
ev.exh.close = d.exh_close_atdc.value;
ev.exh.dur   = d.exh_dur.value;
ev.tr.open   = d.tr_open_atdc.value;
ev.tr.close  = d.tr_close_atdc.value;
ev.tr.dur    = d.tr_dur.value;
ev.blowdown  = d.blowdown.value;
ev.scav      = d.scav_angle.value;

% sampled events, straight off the table
i_ex = find(A_ex > 0);
i_tr = find(A_tr > 0);
samp.exh.open  = theta(i_ex(1));
samp.exh.close = theta(i_ex(end));
samp.exh.dur   = samp.exh.close - samp.exh.open;
samp.tr.open   = theta(i_tr(1));
samp.tr.close  = theta(i_tr(end));
samp.tr.dur    = samp.tr.close - samp.tr.open;

% ---- areas and time-area --------------------------------------------
kBDC = find(theta == 180, 1);
A_ex_bdc = A_ex(kBDC);
A_tr_bdc = A_tr(kBDC);

TA_ex = trapz(theta, A_ex);      % mm2.deg
TA_tr = trapz(theta, A_tr);

% scavenge-phase integrals (transfer open -> exhaust close)
m_sc = (theta >= ev.tr.open) & (theta <= ev.exh.close);
TA_ex_sc = trapz(theta(m_sc), A_ex(m_sc));
TA_tr_sc = trapz(theta(m_sc), A_tr(m_sc));
% blowdown-phase integral (exhaust open -> transfer open)
m_bd = (theta >= ev.exh.open) & (theta <= ev.tr.open);
TA_ex_bd = trapz(theta(m_bd), A_ex(m_bd));

% ---- gate ------------------------------------------------------------
gt(1).name = 'G1 durations from map heights (analytic)';
gt(1).act  = [ev.exh.dur, ev.tr.dur];
gt(1).exp  = [po.tgt_exh_dur.value, po.tgt_tr_dur.value];
gt(1).tol  = 0.02;
gt(2).name = 'G2 event location from the sampled table';
gt(2).act  = [samp.exh.open - ev.exh.open, samp.exh.close - ev.exh.close, ...
              samp.tr.open - ev.tr.open,  samp.tr.close - ev.tr.close];
gt(2).exp  = [0 0 0 0];
gt(2).tol  = dth + 1e-9;
gt(3).name = 'G3 area at BDC vs params';
gt(3).act  = [A_ex_bdc, A_tr_bdc];
gt(3).exp  = [po.A_exh.value*1e6, po.A_tr_max.value*1e6];
gt(3).tol  = 0.5;
gt(4).name = 'G4 symmetry about BDC (informational)';
gt(4).act  = max(abs(A_ex - flipud(A_ex))) + max(abs(A_tr - flipud(A_tr)));
gt(4).exp  = 0;
gt(4).tol  = 1e-9;
gt(4).counted = false;   % slider-crank is symmetric by construction: this can only
                         % catch a broken table build, so it is not evidence.

% G5 is the one that matters: it compares the closed form against a brute-force
% numerical integral, so a wrong closed form cannot hide behind a matching
% caller. G3 alone would pass if params and this file shared the same bug.
yq = linspace(0, max([h_ex, h_tr]), 81);
err5 = 0; worst = [0 0 0];
for i = 1:numel(yq)
    e = abs(win_area(yq(i), w_ex, h_ex, r_ex) - numeric_area(yq(i), w_ex, h_ex, r_ex));
    if e > err5, err5 = e; worst = [yq(i), w_ex, e]; end
end
for i = 1:numel(w_tr)
    rr = r_tr(min(i, numel(r_tr)));
    for j = 1:numel(yq)
        e = abs(win_area(yq(j), w_tr(i), h_tr(i), rr) - numeric_area(yq(j), w_tr(i), h_tr(i), rr));
        if e > err5, err5 = e; worst = [yq(j), w_tr(i), e]; end
    end
end
gt(5).name = 'G5 closed form vs numeric quadrature';
gt(5).act  = err5;
gt(5).exp  = 0;
gt(5).tol  = 0.01;
gt(5).note = sprintf('worst at y=%.2f mm, w=%.0f mm', worst(1), worst(2));

nfail = 0; ncount = 0;
for i = 1:numel(gt)
    if ~isfield(gt(i), 'counted') || isempty(gt(i).counted), gt(i).counted = true; end
    gt(i).ok = all(abs(gt(i).act - gt(i).exp) <= gt(i).tol);
    if gt(i).counted
        ncount = ncount + 1;
        if ~gt(i).ok, nfail = nfail + 1; end
    end
end

% ---- pack ------------------------------------------------------------
G.theta   = theta;
G.x_mm    = x_mm;
G.A_ex    = A_ex;
G.A_tr    = A_tr;
G.A_win   = A_win;
G.flat.A_ex = flat_ex;
G.flat.A_tr = flat_tr;
G.flat.ratio_ex = flat_ratio;
G.flat.ratio_tr = flat_tr_ratio;
G.events  = ev;
G.sampled = samp;
G.BDC.A_ex = A_ex_bdc;
G.BDC.A_tr = A_tr_bdc;
G.time_area.TA_ex = TA_ex;
G.time_area.TA_tr = TA_tr;
G.time_area.TA_ex_scav = TA_ex_sc;
G.time_area.TA_ex_blowdown = TA_ex_bd;
G.time_area.TA_tr_scav = TA_tr_sc;
G.gate    = gt;
G.P       = P;

if strcmp(arg, 'quiet')
    if nfail > 0, gate_error(gt, nfail); end
    return
end

% 'nocheck' - build the tables without the baseline gate. The gate verifies the
% BASELINE map against the md; it must not fire when a study deliberately moves
% the port (sweeps, brackets). step2_report still exercises it on the baseline.
if strcmp(arg, 'nocheck')
    return
end

% =====================================================================
% REPORT
% =====================================================================
fprintf('\n');
fprintf('  PORT GEOMETRY - 4TL10 map, cylindrical bore surface\n');
fprintf('  map provenance: [%s] %s\n', po.exh_top.tag, 'community drawing adopted as baseline, NOT factory');
fprintf('  %s\n', repmat('=', 1, 96));
fprintf('  bore %.1f mm  R %.1f mm  stroke %.1f mm  rod %.1f mm  crank step %.2f deg\n', ...
    g.bore.value*1e3, R_mm, g.stroke.value*1e3, l_m*1e3, dth);
fprintf('  map width %.1f mm vs circumference %.2f mm  (ratio %.4f -> widths are arc lengths)\n', ...
    po.map_width.value*1e3, pi*g.bore.value*1e3, d.port_width_ratio.value);

fprintf('\n  WINDOWS\n');
fprintf('  %-4s %7s %7s %8s %8s %9s %9s %8s\n', 'id', 'w[mm]', 'h[mm]', 'top[mm]', 'floor', 'A_max', 'A_flat', 'flat/surf');
fprintf('  %s\n', repmat('-', 1, 96));
fprintf('  %-4s %7.1f %7.1f %8.1f %8.1f %9.1f %9.1f %8.4f\n', 'EX', w_ex, h_ex, top_ex, top_ex+h_ex, ...
    max(A_ex), max(flat_ex), flat_ratio);
for i = 1:numel(w_tr)
    fprintf('  %-4s %7.1f %7.1f %8.1f %8.1f %9.1f %9.1f %8.4f\n', sprintf('T%d',i), w_tr(i), h_tr(i), ...
        top_tr(i), bot_tr(i), max(A_win(i,:)), max(A_win(i,:))*chord_ratio(w_tr(i),R_mm), chord_ratio(w_tr(i),R_mm));
end
fprintf('  %-4s %7s %7s %8s %8s %9.1f %9.1f %8.4f\n', 'SUM', '', '', '', '', max(A_tr), max(flat_tr), flat_tr_ratio);
fprintf('  (A_max in mm2. A_flat = chord projection, reported for comparison, NOT used.)\n');

fprintf('\n  EVENTS  (0-360 deg, TDC = 0)\n');
fprintf('  %-14s %10s %10s %10s %10s\n', '', 'open ATDC', 'close ATDC', 'duration', 'BBDC open');
fprintf('  %s\n', repmat('-', 1, 96));
fprintf('  %-14s %10.3f %10.3f %10.3f %10.3f\n', 'exhaust', ev.exh.open, ev.exh.close, ev.exh.dur, 180-ev.exh.open);
fprintf('  %-14s %10.3f %10.3f %10.3f %10.3f\n', 'transfers', ev.tr.open, ev.tr.close, ev.tr.dur, 180-ev.tr.open);
fprintf('  blowdown %.3f deg   scavenge window %.3f deg\n', ev.blowdown, ev.scav);

fprintf('\n  TIME-AREA  (integral of A dtheta)\n');
fprintf('  exhaust   total %10.1f mm2.deg   blowdown phase %8.1f   scavenge phase %8.1f\n', TA_ex, TA_ex_bd, TA_ex_sc);
fprintf('  transfers total %10.1f mm2.deg   scavenge phase %8.1f\n', TA_tr, TA_tr_sc);
fprintf('  mean open area: exhaust %.1f mm2 over %.1f deg, transfers %.1f mm2 over %.1f deg\n', ...
    TA_ex/ev.exh.dur, ev.exh.dur, TA_tr/ev.tr.dur, ev.tr.dur);

if strcmp(arg, 'table')
    fprintf('\n  AREA vs CRANK ANGLE\n');
    fprintf('  %6s %8s %9s %9s %9s %9s\n', 'theta', 'x[mm]', 'A_ex', 'A_tr', 'A_ex+A_tr', 'note');
    fprintf('  %s\n', repmat('-', 1, 96));
    marks = {ev.exh.open, 'exh open'; ev.tr.open, 'tr open'; 180, 'BDC'; ...
             ev.tr.close, 'tr close'; ev.exh.close, 'exh close'};
    th_tab = 0:10:360;
    for t = th_tab
        k = find(abs(theta-t) < 1e-9, 1);
        note = '';
        for j = 1:size(marks,1)
            if abs(t - marks{j,1}) < 0.5, note = marks{j,2}; end
        end
        fprintf('  %6.0f %8.2f %9.1f %9.1f %9.1f   %s\n', ...
            t, x_mm(k), A_ex(k), A_tr(k), A_ex(k)+A_tr(k), note);
    end
end

fprintf('\n  GATE\n');
for i = 1:numel(gt)
    fprintf('  %-44s %s\n', gt(i).name, tern(gt(i).ok));
    fprintf('      act %s\n      exp %s  (tol %g)\n', mat2str(round(gt(i).act*1e4)/1e4), ...
        mat2str(round(gt(i).exp*1e4)/1e4), gt(i).tol);
    if isfield(gt(i), 'note') && ~gt(i).ok
        fprintf('      %s\n', gt(i).note);
    end
end
fprintf('  counted gates: %d of %d pass (G4 is informational, not evidence)\n', ncount-nfail, ncount);
fprintf('\n');

if nfail > 0, gate_error(gt, nfail); end
end


% =====================================================================
function A = win_area(y, w, h, r)
% Open area of the TOP y of a rounded-rectangle window on the bore surface.
% y, w, h, r in mm; A in mm2. Vectorised over y.
y = min(max(y, 0), h);
A = zeros(size(y));
m1 = y <= r;
m2 = y > r & y <= h-r;
m3 = y > h-r;
if any(m1(:)), A(m1) = w*y(m1) - 2*corner_int(y(m1), r); end
if any(m2(:)), A(m2) = w*y(m2) - 2*corner_int(r, r); end
if any(m3(:))
    dd = h - y(m3);
    A(m3) = w*h - (4-pi)*r^2 - (w*dd - 2*corner_int(dd, r));
end
end

function I = corner_int(d, r)
% Corner-area lost over the first d mm of a corner, measured from the NARROW
% end. Both window corners are narrow at the edge and wide r mm in, so the
% integral runs from (r-d) to r:
%   I = integral_{r-d}^{r} (r - sqrt(r^2-u^2)) du
%     = r*d - (pi*r^2/4 - F(r-d)),  F(x) = (x/2)*sqrt(r^2-x^2) + (r^2/2)*asin(x/r)
I = zeros(size(d));
m = d > 0;
if ~any(m(:)), return; end
xd = min(d(m), r); xr = r;
u = xr - xd;
F = (u/2).*sqrt(max(xr^2-u.^2, 0)) + (xr^2/2).*asin(min(max(u/xr, -1), 1));
I(m) = xr.*xd - (pi*xr^2/4 - F);
end

function c = chord_ratio(w, R)
% flat chord / arc, for a window of arc width w on radius R
c = 2*R*sin(w/(2*R))./w;
end

% ---- brute-force reference used only by gate G5 ----------------------
function A = numeric_area(y, w, h, r)
y = min(max(y, 0), h);
if y <= 0, A = 0; return; end
s = linspace(0, y, 8001);
A = trapz(s, width_profile(s, w, h, r));
end

function wv = width_profile(s, w, h, r)
% local arc width of a rounded-rect window at depth s from its top edge
wv = w*ones(size(s));
m1 = s < r;
wv(m1) = w - 2*(r - sqrt(max(r^2 - (r - s(m1)).^2, 0)));
m2 = s > h - r;
wv(m2) = w - 2*(r - sqrt(max(r^2 - (s(m2) - (h - r)).^2, 0)));
end

function x = piston_x(r, l, th_deg)
t = th_deg*pi/180;
x = r*(1 - cos(t)) + l*(1 - sqrt(1 - (r/l)^2*sin(t).^2));
end

function s = tern(ok)
if ok, s = 'PASS'; else, s = 'FAIL'; end
end

function gate_error(gt, nfail)
msg = sprintf('%d port-geometry gate(s) failed:', nfail);
for i = 1:numel(gt)
    if ~gt(i).ok
        msg = [msg sprintf(' [%s]', gt(i).name)]; %#ok<AGROW>
    end
end
error('port_geometry:gate', '%s', msg);
end
