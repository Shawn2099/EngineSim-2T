%AUDIT_PREP  Checks the four md edits against arithmetic and the source inventory.
%   Nothing here is taken from the md on trust. Every number is recomputed.

P = params('quiet');
fprintf('===== A. THE FOUR md CLAIMS =====\n\n');

% ---- A1. displacement 132.16 -> 132.10 -------------------------------
Vd = pi/4*58^2*50/1000;
fprintf('A1 displacement\n');
fprintf('   pi/4*58^2*50            = %.6f cc\n', Vd);
fprintf('   md new value            = 132.10  (delta %.5f cc, %.4f%%)\n', Vd-132.10, 100*(Vd-132.10)/132.10);
fprintf('   md old value            = 132.16  (delta %.5f cc, %.4f%%)\n', Vd-132.16, 100*(Vd-132.16)/132.16);
fprintf('   stated "132"            = 132      (delta %.4f cc)\n\n', Vd-132);

% ---- A2. exhaust close 87.2 ATDC -> 272.8 ATDC -----------------------
r = 25; l = 98;
xo = @(t) r*(1-cosd(t)) + l*(1-sqrt(1-(r/l)^2*sind(t).^2));
te = fzero(@(t) xo(t)-27, [0 180]);
fprintf('A2 exhaust close phase\n');
fprintf('   opens  at %.4f deg ATDC = %.4f BBDC\n', te, 180-te);
fprintf('   closes at %.4f deg ATDC = %.4f ABDC  (port symmetric about BDC)\n', 360-te, 360-te-180);
fprintf('   travel at both events  = %.4f mm : %.4f mm\n', xo(te), xo(360-te));
fprintf('   md old label "87.2 ATDC" is the OPENING event, not the closing one\n');
fprintf('   volume/CR identical either way: %.3f cc, CR %.4f\n\n', 14.52+pi/4*58^2*27/1000, (14.52+pi/4*58^2*27/1000)/14.52);

% ---- A3. corner radius: is +/-3-5% honest? ---------------------------
fprintf('A3 corner-radius sensitivity of the published areas\n');
exh = @(r_) 39*23 - (4-pi)*r_.^2;
tr  = @(r_) (25*12+19*12+25*15+19*12+25*12) - 5*(4-pi)*r_.^2;
fprintf('   exhaust base r=8  -> %.2f mm2; r=5..11 -> %.2f .. %.2f  (%+.1f%% .. %+.1f%%)\n', ...
    exh(8), exh(5), exh(11), 100*(exh(5)/842-1), 100*(exh(11)/842-1));
fprintf('   transfer base r=4 -> %.2f mm2; r=2..7  -> %.2f .. %.2f  (%+.1f%% .. %+.1f%%)\n', ...
    tr(4), tr(2), tr(7), 100*(tr(2)/1362-1), 100*(tr(7)/1362-1));
fprintf('   so "3-5%%" is right for exhaust, and slightly optimistic for transfers at r=7\n\n');

% ---- A4. is the map really a bore unrolling? -------------------------
fprintf('A4 map width vs circumference\n');
fprintf('   map overall width 184.00 mm ; pi*D = %.2f mm ; ratio %.4f\n', pi*58, 184/(pi*58));
fprintf('   -> widths are arc lengths to within %.1f%%, i.e. the map IS a developed view\n\n', 100*abs(1-184/(pi*58)));

% =====================================================================
fprintf('===== B. AUDIT OF MY OWN STEP-1 ARTEFACT =====\n\n');

% ---- B1. T3 can never fully open -------------------------------------
[At3full, ~] = win_area(15, 25, 15, 4);
[At3bdc,  ~] = win_area(50-38, 25, 15, 4);        % piston reaches 50 mm, T3 floor is 53
Atr_full = tr(4);
Atr_max  = Atr_full - At3full + At3bdc;
fprintf('B1 transfer area: "full open" is unreachable\n');
fprintf('   T3 window 25x15 r=4        full area = %.2f mm2\n', At3full);
fprintf('   T3 at BDC (12 of 15 mm)    open area = %.2f mm2  (loss %.2f mm2)\n', At3bdc, At3full-At3bdc);
fprintf('   sum of 5 windows (md 1362)          = %.2f mm2\n', Atr_full);
fprintf('   max simultaneously open at BDC      = %.2f mm2  (%.2f%% less)\n', Atr_max, 100*(1-Atr_max/Atr_full));
fprintf('   ratio to piston area: md 0.516 vs achievable %.4f\n\n', Atr_max/(pi/4*58^2));

% ---- B2. port floors vs the factory drawing --------------------------
fprintf('B2 map floors vs factory drawing (drawing minus 0.8 mm deck clearance)\n');
map_floor   = [50.0 53.0];
dwg_floor   = [50.8 51.8 54.3] - 0.8;
fprintf('   factory floors minus deck = %.1f / %.1f / %.1f mm below TDC\n', dwg_floor);
fprintf('   map floors                = %.1f / %.1f mm below TDC\n', map_floor);
fprintf('   -> main floor agrees exactly; the factory has an intermediate 51.0 mm floor the map\n');
fprintf('      does not show, and the boost-port floor differs by %.1f mm\n\n', abs(53.0-dwg_floor(3)));

% ---- B3. rod-length sensitivity claim (md says 1.5 deg over 90..110) --
fprintf('B3 md claim: rod 90->110 mm moves exhaust opening by 1.5 deg\n');
for ll = [90 98 110]
    tt = fzero(@(t) (25*(1-cosd(t)) + ll*(1-sqrt(1-(25/ll)^2*sind(t).^2))) - 27, [0 180]);
    fprintf('   l=%3d mm -> opens %.4f ATDC, duration %.4f deg\n', ll, tt, 2*(180-tt));
end
d90  = 2*(180-fzero(@(t) (25*(1-cosd(t)) + 90*(1-sqrt(1-(25/90)^2*sind(t).^2)))  - 27, [0 180]));
d110 = 2*(180-fzero(@(t) (25*(1-cosd(t)) + 110*(1-sqrt(1-(25/110)^2*sind(t).^2))) - 27, [0 180]));
fprintf('   claim = 1.5 deg ; actual %.4f deg\n\n', abs(d110-d90));

% ---- B4. md 4-speed derivation (33 mm -> 157.5 deg) ------------------
fprintf('B4 md 13 4-speed derivation: 27+6=33 mm travel -> 157.5 deg exhaust\n');
t4 = fzero(@(t) xo(t)-33, [0 180]);
fprintf('   l=98: 33 mm -> %.4f deg (md says 157.5)\n', 2*(180-t4));
t4b = fzero(@(t) xo(t)-40, [0 180]);
fprintf('   40 mm travel -> %.4f deg transfers (md says 119.5)\n\n', 2*(180-t4b));

% ---- B5. tolerance adequacy: what error would each check catch? ------
fprintf('B5 tolerance adequacy of my self-check (how wrong must a value be to fail?)\n');
rows = { 'Displacement',        132.10, 0.001, 'rel'; ...
         'Crankcase CR',        1.35,   0.05,  'abs'; ...
         'Exhaust area',        842,    2,     'abs'; ...
         'Exhaust duration',    185.7,  0.15,  'abs' };
for i = 1:size(rows,1)
    if strcmp(rows{i,4},'rel'), tol = rows{i,3}*rows{i,2}; else, tol = rows{i,3}; end
    fprintf('   %-20s must be off by >%8.4f to fail  (= %.3f%% of value)\n', ...
        rows{i,1}, tol, 100*tol/rows{i,2});
end
fprintf('\n');

% ---- B6. circular vs independent checks ------------------------------
fprintf('B6 which checks can actually fail for a WRONG SOURCE (vs a coding slip)?\n');
fprintf('   independent oracles: displacement (58,50 -> 132.10), CR 10.1, bare head 15.9 -> 9.31\n');
fprintf('   circular by construction: durations, trapped CR, areas, BSFC, pipe L, tuned rpm,\n');
fprintf('                             crankcase CR (all derived from the same inputs they test)\n\n');

% ---- B7. friction laws (input to decision 2) -------------------------
fprintf('B7 friction representation, matched at the 7500 rpm anchor\n');
Vd_m3 = pi/4*58^2*50/1e9;
N = (2000:1000:9000)';
Tconst = 1.30*ones(size(N));
phi = @(n) 0.30 + 0.06*n/1000;                  % bar, assumed shape
Tshaped = 1.30*phi(N)/phi(7500);
fprintf('     rpm   T_const   T_shaped   delta(Nm)   delta(%% of 12.26)\n');
for i = 1:numel(N)
    fprintf('   %5d   %7.3f   %8.3f   %8.3f   %8.2f\n', N(i), Tconst(i), Tshaped(i), ...
        Tconst(i)-Tshaped(i), 100*(Tconst(i)-Tshaped(i))/12.26);
end

% ---- local functions --------------------------------------------------
function [A, Aflat] = win_area(y, w, h, r)
% Open area of the TOP y mm of a rounded-rect window on the bore surface.
% A     = cylindrical surface area  (arc width * height, corners rounded)
% Aflat = chord-projected area, i.e. treating the unrolled width as a flat chord
y = min(max(y,0), h);
A = integral_of_width(y, w, h, r);
R = 29; dfi = w/R; chord = 2*R*sin(dfi/2);
Aflat = A * chord/w;
end

function A = integral_of_width(y, w, h, r)
if y <= 0, A = 0; return; end
if y <= r
    A = w*y - 2*corner_int(y, r);
elseif y <= h-r
    A = w*y - 2*corner_int(r, r);
else
    d = h - y;
    A = w*h - (4-pi)*r^2 - (w*d - 2*corner_int(d, r));
end
end

function I = corner_int(d, r)
% integral_0^d (r - sqrt(r^2-(r-s)^2)) ds
if d <= 0, I = 0; return; end
u = r - d;
F = @(x) (x/2)*sqrt(max(r^2-x^2,0)) + (r^2/2)*asin(min(max(x/r,-1),1));
I = r*d - (pi*r^2/4 - F(u));
end
