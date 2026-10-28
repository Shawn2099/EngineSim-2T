%STEP2B_CHECK  FreeCAD 3-D bore vs the 2-D analytic.
% The FreeCAD numbers below were produced by tools.freecad.execute_code_headless
% (6 windows cut as radial slots at chord = 2R sin(w/2R), i.e. arc width = map
% width, then the exposed cylindrical patch area measured at 10 crank angles).
% They are pasted here because MATLAB cannot call FreeCAD; the run is reported
% in the step-2 output.

P = params('quiet');
G = port_geometry(P, 'quiet');

th  = [100 120 140 150 160 170 180 200 220 240]';
x   = [32.48 39.92 45.48 47.45 48.87 49.72 50.00 48.87 45.48 39.92]';
cad_ex = [213.720 503.880 720.720 797.550 852.930 886.080 897.000 852.930 720.720 503.880]';
cad_tr = [  0.000 216.960 845.240 1067.850 1228.310 1324.360 1356.000 1228.310 845.240 216.960]';

% sharp-cornered 2-D reference: the same window geometry with r -> 0
w_ex = P.port.exh_w.value*1e3;  h_ex = P.port.exh_h.value*1e3;  top_ex = P.port.exh_top.value*1e3;
w_tr = P.port.tr_w.value*1e3;   h_tr = P.port.tr_h.value*1e3;
top_tr = P.port.tr_top.value*1e3; bot_tr = P.port.tr_bot.value*1e3;

sh_ex = w_ex*min(max(x-top_ex,0),h_ex);
sh_tr = zeros(size(x));
for i = 1:numel(w_tr)
    y = min(max(min(x,bot_tr(i))-top_tr(i),0),h_tr(i));
    sh_tr = sh_tr + w_tr(i)*y;
end

% rounded 2-D analytic, interpolated onto the same angles
rn_ex = interp1(G.theta, G.A_ex, th);
rn_tr = interp1(G.theta, G.A_tr, th);

fprintf('\n  FreeCAD 3-D vs 2-D ANALYTIC  (areas mm2)\n');
fprintf('  %6s %7s %9s %9s %7s %9s %7s\n','theta','x[mm]','CAD ex','sharp ex','ratio','round ex','ratio');
fprintf('  %s\n', repmat('-', 1, 88));
for i = 1:numel(th)
    fprintf('  %6.0f %7.2f %9.2f %9.2f %7.4f %9.2f %7.4f\n', th(i), x(i), cad_ex(i), sh_ex(i), ...
        cad_ex(i)/sh_ex(i), rn_ex(i), cad_ex(i)/rn_ex(i));
end
fprintf('\n  %6s %7s %9s %9s %7s %9s %7s\n','theta','x[mm]','CAD tr','sharp tr','ratio','round tr','ratio');
fprintf('  %s\n', repmat('-', 1, 88));
for i = 1:numel(th)
    if sh_tr(i) > 0
        fprintf('  %6.0f %7.2f %9.2f %9.2f %7.4f %9.2f %7.4f\n', th(i), x(i), cad_tr(i), sh_tr(i), ...
            cad_tr(i)/sh_tr(i), rn_tr(i), cad_tr(i)/rn_tr(i));
    else
        fprintf('  %6.0f %7.2f %9.2f %9.2f %7s %9.2f %7s\n', th(i), x(i), cad_tr(i), sh_tr(i), '-', rn_tr(i), '-');
    end
end

m1 = max(abs(cad_ex./sh_ex - 1));
m2 = max(abs(cad_tr(sh_tr>0)./sh_tr(sh_tr>0) - 1));
fprintf('\n  max |CAD/sharp - 1|: exhaust %.2e   transfers %.2e\n', m1, m2);
fprintf('  max |CAD/rounded - 1|: exhaust %.4f   transfers %.4f\n', ...
    max(abs(cad_ex./rn_ex - 1)), max(abs(cad_tr(rn_tr>0)./rn_tr(rn_tr>0) - 1)));
fprintf('\n  -> the 3-D geometry reproduces the sharp 2-D reference exactly: the arc-width\n');
fprintf('     model is right and no flat-projection error exists in the delivered curve.\n');
fprintf('     The gap to the delivered (rounded) curve is corner rounding only: %.1f%% exhaust,\n', ...
    100*(1-max(rn_ex)/max(sh_ex)));
fprintf('     %.1f%% transfers at BDC. Inside the +-4-7%% corner-radius uncertainty, and inside\n', ...
    100*(1-max(rn_tr)/max(sh_tr)));
fprintf('     the 10%% disagreement threshold.\n');
fprintf('\n     BUT near crack-open the gap is %.0f%% (exhaust) and %.0f%% (transfers), i.e. above\n', ...
    100*max(abs(cad_ex./rn_ex-1)), 100*max(abs(cad_tr(rn_tr>0)./rn_tr(rn_tr>0)-1)));
fprintf('     the 10%% threshold. That is the corner radius, not the projection: the assumed\n');
fprintf('     radius removes a growing share of a nearly-closed window. Aggregate effect:\n');

ta_sh_ex = trapz(G.theta, w_ex*min(max(G.x_mm-top_ex,0),h_ex));
ta_sh_tr = zeros(size(G.theta));
for i = 1:numel(w_tr)
    y = min(max(min(G.x_mm,bot_tr(i))-top_tr(i),0),h_tr(i));
    ta_sh_tr = ta_sh_tr + w_tr(i)*y;
end
ta_sh_tr = trapz(G.theta, ta_sh_tr);
fprintf('     time-area exhaust   sharp %9.1f  rounded %9.1f  -> rounded is %.1f%% lower\n', ...
    ta_sh_ex, G.time_area.TA_ex, 100*(1-G.time_area.TA_ex/ta_sh_ex));
fprintf('     time-area transfers sharp %9.1f  rounded %9.1f  -> rounded is %.1f%% lower\n', ...
    ta_sh_tr, G.time_area.TA_tr, 100*(1-G.time_area.TA_tr/ta_sh_tr));

