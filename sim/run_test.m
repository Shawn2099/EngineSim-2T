P = params('quiet');
M = engine_model(P, 7500, struct('max_revs', 15, 'quiet', false));
fprintf('\nRESULT: Pi=%.1f W (%.2f kW) Pb=%.1f W Tb=%.2f Nm BMEP=%.2f bar DR=%.3f eta_i=%.3f BSFC=%.1f g/kWh massbal=%.2e converged=%d cycles=%d\n', ...
    M.P_i, M.P_i/1000, M.P_b, M.T_b, M.BMEP/1e5, M.DR, M.eta_i, M.BSFC, M.mass_bal, M.converged, M.cycles);