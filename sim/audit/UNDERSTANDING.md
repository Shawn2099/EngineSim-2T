# Understanding the RX135 model — written before any code change

Date: 2026-10-28. Basis: full read of `PROJECT_STATUS.md`, `VERIFICATION_vs_LITERATURE.md`,
`REFERENCES_EXTRACT.md`, `EXTRACT_CONSTANTS.md`, `EXTRACT_METHODS.md`, `ACCURACY_TARGETS.md`,
`SMALL_ENGINE_BEST_PRACTICE.md`, and the three model files. Numbers below are from a live run
(`params('quiet')`, `engine_model(P,7500,Nc=60)`), not from memory.

---

## 1. What the model is

A crank-angle-resolved, single-zone, filling-and-emptying model of a crankcase-scavenged,
piston-ported, loop-scavenged SI two-stroke, coupled to a lumped acoustic exhaust model.

Four control volumes:

| Volume | State | Driven by |
|---|---|---|
| cylinder | m, T, m_fresh | slider-crank volume, port orifices, Wiebe, Woschni |
| crankcase | m, T | piston-driven volume Vcc + Ap(S−x), reed in, transfer out |
| exhaust core | Nc cells, m and E per cell | quasi-1D momentum + energy, wall friction and heat |
| 5 side chambers | m, E each | orifice through the perforation area |

Two-stroke cycle, one power stroke per revolution. Fixed crank step 0.25°, explicit Euler,
marched cycle after cycle until trapped mass repeats to 1e-4.

---

## 2. Equations implemented, and where each comes from

| Item | Implementation | Source | Status |
|---|---|---|---|
| Piston kinematics | slider-crank, `piston_x`, `dxdtheta` | standard | ours, exact |
| Cylinder volume | Vc + Ap·x | — | ours |
| Port area A(θ) | rounded-rectangle window on the bore surface, closed form | map (ADOPTED) | ours, gated G1–G5 |
| Orifice flow | compressible nozzle with sonic branch, `orif` | Zhang 1995 eq. 3.115 form; Blair | **cited form, constant Cd** |
| Cylinder energy | dT = (Q − p dV + h_in − h_out − cv T dm)/(m cv) | open-system first law | standard |
| Crankcase energy | same form | Zhang CV2 | standard |
| Combustion | Wiebe `1−exp(−a z^(m+1))`, a=5, m=2, 45° | **we chose it; no source** | **wrong** (D2) |
| Heat transfer | Woschni 1967 `3.26 B^-0.2 p^0.8 T^-0.55 w^0.8` | Woschni via Heywood; Woschni–Anisits via Theotokatos | cited form, constants from Heywood |
| Friction | `fmep = 105·Lst·N` | Blair D&S Eq. 5.4.2 | cited, adopted |
| Exhaust core | Rusanov FV, p·dA/dx source, Darcy friction, Blair 2.4 wall heat | Blair §§2.3–2.4 | cited form |
| Silencer | 35 mm core + 5 side-branch chambers via perforations | measured geometry + our lumping | **ours (ASSUMED coupling)** |
| Scavenging | Benson–Brandham blend, `kappa = dSE/dSR` applied as a retention fraction on the transfer inflow | Blair Eq. 3.1.21 | **cited law, but wired as a loss factor** (see D1c) |
| Reed | check valve: opens when `p_amb − p_cc > 500 Pa`, constant 600 mm², Cd 0.70 | **ours** | **wrong** (D1b) |
| Ignition | 4-point CDI curve, linear interpolation | placeholder | ASSUMED |

---

## 3. What the model produces now (Nc = 60, 7500 rpm, 22 cycles)

```
P_b        10101 W        BMEP 6.12 bar      BSFC 532 g/kWh
DR         0.957          SE 0.800 (reported)  TE 0.835 (reported)
p_trap     1.142 bar      T_ec 511 K          peak p 36 bar   peak T 3654 K
crankcase swing 0.46 bar  mass balance 1.1e-14
```

---

## 4. The three defects I believe dominate

### D1a — The carburettor is not in the model at all

`P.inlet.A_venturi` (314 mm², VM20) is defined in `params.m` and **never read** by
`engine_model.m`. The only inlet restriction is the reed seat, 600 mm². The induction path is
therefore 600 mm² of nothing, and the crankcase fills to near-ambient every cycle.

Evidence: delivered air 1.492e-4 kg against a reference mass 1.559e-4 kg → DR 0.957. Blair's
measured 65 cc chainsaw runs DR 0.53. Removing the carburettor removes the one restriction
that sets the delivery ceiling at part-open and at high speed.

### D1b — The reed is a static check valve with no lift law

It is open from 217.5° to 373.5° (156° of crank) and **closes at 13.5° ATDC**. Blair's measured
RD350LC reed closes at 86° ATDC at 5430 rpm and 122° ATDC at 9150 rpm. A 72–108° error in the
closing point is not a small simplification: it sets how much charge the crankcase traps and
how the pump interacts with the exhaust wave.

### D1c — The fresh-charge species is not advected, so SE is always 1.0 and the scavenging law is cosmetic

This is worse than D1a/D1b and was not in the brief. `cyl.mf` is integrated as

```
dmf = ret − mf_ign·dxb·(6N)          % in by retention, out by burn — nothing else
cyl.mf = max(min(cyl.mf + dmf*dt, cyl.m), 0)
```

Fresh mass is never removed when mass leaves through the exhaust port or back through the
transfer port. It therefore grows until it hits the `cyl.m` cap. At exhaust closure
**m_fresh_ign = m_trapped = 6.685e-5 kg exactly** → the cylinder is 100 % fresh, SE = 1.000.

Meanwhile the model *reports* SE = 0.800, because `M.SE` is taken from the Benson–Brandham
algebra (`SE_c` from `SR_c`) and has no connection to the cylinder composition. The two
numbers differ by 0.2 and nothing in the output flags it. Actual TE from composition is
0.448, reported TE is 0.835.

Consequence: the scavenging law does not control the trapped charge. It is a parallel
calculation used only for reporting. Any calibration or sensitivity study that trusts
SE/TE is reading a number that does not describe the gas in the cylinder.

### D2 — Wiebe is a=5, m=2, 45°

Blair's validated 65 cc chainsaw: a=5, m=1.05, 64°. The effective exponent here is m+1 = 3
against Blair's 2.05. Coupled with D1c (too much charge, peak T 3654 K > 3000 K) the burn is
too fast and too hot.

### D3 — Cd is constant

`Cd_ex = 0.75`, `Cd_tr = 0.70`, and the reed 0.70, all independent of area ratio k and pressure
ratio. Our exhaust k = 842/962 = 0.88 (port area / 35 mm core area) — at the top of Blair's
measured range (0.127–0.824), where he says the constant-Cd error is worst (up to 20 % mass flow).

### D4 — the cliff

Sensitivity 3.2 %/degree at 185.7° exhaust duration but 0.2 %/degree at 179.6°, with a 19.5 %
jump between. Suspects: the reed open/closed switch (a hard `if dp > 500`), the transfer
`max(mdot,0)` split, or the `max(T,150)` floor. To be located, not guessed.

---

## 5. Order of work

1. D1c first — it is a coding bug and it invalidates every SE/TE number on record.
2. D1a — wire the venturi (unwired parameter, coding bug).
3. D1b — dynamic/lift-dependent reed (physics change, cited).
4. D3 — variable Cd (physics change, cited).
5. D2 — Wiebe (physics change, cited).
6. Locate D4, then re-run the full audit and write v2.

No parameter will be adjusted to hit a target. If DR cannot be brought into 0.50–0.75 by these
mechanisms, the report will say which measurement is missing rather than add a factor.
