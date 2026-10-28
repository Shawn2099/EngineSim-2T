%STEP2_REPORT  Step 2 deliverable: port area vs crank angle + timing gate.
P  = params('quiet');
G  = port_geometry(P, 'table');
dth = P.num.dtheta.value;
k   = @(t) round(t/dth) + 1;          % nearest sample index for a crank angle

kBDC = k(180);
fprintf('\n  ---- spot checks the gate does not cover ----\n');
ie = k(G.events.exh.open);  it = k(G.events.tr.open);
fprintf('  sample before/after exhaust opening: %.3f deg %.3f mm2 | %.3f deg %.3f mm2\n', ...
    G.theta(ie-1), G.A_ex(ie-1), G.theta(ie), G.A_ex(ie));
fprintf('  sample before/after transfer open : %.3f deg %.3f mm2 | %.3f deg %.6f mm2\n', ...
    G.theta(it-1), G.A_tr(it-1), G.theta(it), G.A_tr(it));
fprintf('  (area must be 0 on the closed side and >0 on the open side)\n');
fprintf('  T3 open height at BDC: %.1f mm of %.1f mm  (floor 53 mm, piston stops at 50)\n', 50-38, 15);
fprintf('  A_win at BDC [T1..T5]: %s mm2  sum %.1f\n', ...
    mat2str(round(G.A_win(:,kBDC)')), sum(G.A_win(:,kBDC)));
fprintf('  A_ex + A_tr at BDC: %.1f mm2   (A_p = %.1f)\n', ...
    G.A_ex(kBDC)+G.A_tr(kBDC), P.geo.A_p.value*1e6);
fprintf('  workspace: G.theta(%d) G.A_ex G.A_tr G.A_win(%dx%d)\n', ...
    numel(G.theta), size(G.A_win,1), size(G.A_win,2));
