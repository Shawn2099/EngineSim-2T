# Port-timing geometry (Blair) — implement in MATLAB Symbolic Math / fzero

Given a measured port top-edge height H (mm from cylinder head / TDC plane),
crank radius r = stroke/2, connecting rod length l (mm), the crank angle θ
(degrees, from TDC, downward stroke) at which the piston uncovers the port
solves:

    s(θ) = r*(1 - cos θ) + l - sqrt(l^2 - r^2*sin^2 θ)   [mm]
    s(θ) = H

Port duration (deg) = 360 - 2*θ_open   (opening on downstroke, closing on upstroke).
Exhaust/transfer timing reported as "open duration" (e.g. 190° exhaust) maps to
θ_open = (360 - duration)/2.

MATLAB implementation:

    function th = port_open_angle(H, r, l)
        % H, r, l in mm; returns degrees from TDC
        f = @(th) r*(1-cosd(th)) + l - sqrt(l^2 - r^2*sind(th)^2) - H;
        th = fzero(f, [10 170]);   % opening occurs on downstroke
    end

Notes:
- r = stroke/2 = 25 mm (RX135, stroke 50).
- l = connecting rod length (NOT FOUND -> use 98 mm consensus; measure).
- H must be measured from the cylinder head gasket face (TDC plane) to the top
  edge of the port, for each of: exhaust, transfer (upper), inlet (if piston-ported).
- Squish volume / combustion chamber volume are separate; measure with burette.

Sensitivity: small errors in H (~0.5 mm) change θ_open by ~2-3°, which the
surrogate shows is significant (transfer timing ±2.6% power per 15°).
