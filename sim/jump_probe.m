function R = jump_probe(P, band, opts)
%JUMP_PROBE  Scan eta_comb across a narrow band and locate the discontinuity.
%   R = jump_probe(P, band, opts) with opts.Nc, opts.dth, opts.max_revs.
%   Reports the largest step in brake power between adjacent eta values.
if nargin < 3, opts = struct(); end
if ~isfield(opts,'Nc'), opts.Nc = 40; end
if ~isfield(opts,'dth'), opts.dth = 0.25; end
if ~isfield(opts,'max_revs'), opts.max_revs = 90; end

n = numel(band);
R.eta = band(:); R.P = zeros(n,1); R.pt = zeros(n,1); R.DR = zeros(n,1);
for i = 1:n
    P2 = P;
    P2.cal.eta_comb.value = band(i);
    P2.num.dtheta.value = opts.dth;
    M = engine_model(P2, 7500, struct('max_revs',opts.max_revs,'quiet',true, ...
        'Nc',opts.Nc,'dtheta',opts.dth));
    R.P(i)  = M.P_b;
    R.DR(i) = M.DR;
    R.pt(i) = M.m_trapped*P.comb.R_gas.value*M.T_ec/ ...
              (P.comp.Vc.value + P.geo.A_p.value*0.027);
end
[d, i] = max(diff(R.P));
R.jump_at   = mean(band(i:i+1));
R.jump_size = d;
R.jump_rel  = d/max(R.P(i),1e-9);
end
