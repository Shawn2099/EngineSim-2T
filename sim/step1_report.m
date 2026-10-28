%STEP1_REPORT  Step 1 deliverable check: build the parameter set and print it.
%   Leaves P in the base workspace for inspection by the next steps.

P = params();

fprintf('\nworkspace readback (what the solver will consume):\n');
fprintf('  P.geo.V_d.value             = %.6e m3    (%s)\n', P.geo.V_d.value, P.geo.V_d.tag);
fprintf('  P.comp.Vc.value             = %.6e m3    (%s)\n', P.comp.Vc.value, P.comp.Vc.tag);
fprintf('  P.port.exh_top.value        = %.4f m         (%s)\n', P.port.exh_top.value, P.port.exh_top.tag);
fprintf('  P.derived.exh_open_atdc     = %.4f deg       (%s)\n', P.derived.exh_open_atdc.value, P.derived.exh_open_atdc.tag);
fprintf('  P.derived.tr_open_atdc      = %.4f deg       (%s)\n', P.derived.tr_open_atdc.value, P.derived.tr_open_atdc.tag);
fprintf('  P.derived.CR_trapped_map    = %.4f : 1       (%s)\n', P.derived.CR_trapped_map.value, P.derived.CR_trapped_map.tag);
fprintf('  P.cal.eta_comb.value        = %.2f              (%s)\n', P.cal.eta_comb.value, P.cal.eta_comb.tag);
fprintf('  P.scav.SR_pd.value          = %.2f              (%s)\n', P.scav.SR_pd.value, P.scav.SR_pd.tag);
fprintf('  P.exh.core_d.value          = %.3f m          (%s)\n', P.exh.core_d.value, P.exh.core_d.tag);
fprintf('  P.exh.A_out.value           = %.3e m2   (%s)\n', P.exh.A_out.value, P.exh.A_out.tag);
fprintf('  P.cal.fmep_k.value          = %.0f Pa/(m*rpm)   (%s)\n', P.cal.fmep_k.value, P.cal.fmep_k.tag);
fprintf('  P.derived.fmep_pk.value     = %.3f bar         (%s)\n', P.derived.fmep_pk.value, P.derived.fmep_pk.tag);
fprintf('  P.derived.T_f7500.value     = %.4f Nm        (%s)\n', P.derived.T_f7500.value, P.derived.T_f7500.tag);
