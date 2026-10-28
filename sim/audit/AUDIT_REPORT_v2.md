# RX135 model audit v2 — after the D1/D2/D3/D4 work

Date: 2026-10-28. Every number below is a model run from this session. Raw data:
`sweep_*.csv`, `grid_results.mat`, `limits_results.mat`, `consistency_results.mat`,
`BASELINE.csv` (before), `AFTER.csv` (after).

Baseline for "before" = the unmodified model in `sim\baseline\`.

---

## 1. Summary

| | |
|---|---|
| Checks executed | 13 |
| **Passed** | **6** — G4, P1, P2, P4, C1, C2 |
| **Failed** | **7** — S1, S2, S3, G1, G2, G3, P3 |

**Worst offenders, ranked by what they cost you in a stock-vs-proposed comparison:**

1. **G1/G2 — the pipe is grid-dependent at 6000 rpm (5–15 %).** The 0-D core is fine
   (dt changes power by <1 % with the pipe off); the exhaust ladder is not.
2. **G3 — convergence needs >100 cycles at 1e-4** (158 at 7700 rpm) and the cycle map
   sits on a ±0.4 % limit cycle at 6000, so a point-value residual cannot be driven to
   1e-6. Results are block means over 20 cycles.
3. **S3 — the power peak is flat between 7500 and 8500**, so "peak rpm" flips between the
   two grid points on a 0.5 % power difference. Peak-rpm is not a resolvable metric.
4. **P3 — 3021 K peak temperature at 7500** (constant γ, no dissociation) and poor
   low-speed behaviour (BMEP 2.25 bar, BSFC 1333 g/kWh at 2000 rpm).
5. **S1/S2 — small non-monotonicities remain** (≤1.7 % in the pipe sweep, ≤0.2 % in
   crankcase volume), consistent with the limit cycle rather than with a cliff.

---

## 2. Findings table

| ID | Check | Parameter | Values | What happened | Why it matters | Cause |
|---|---|---|---|---|---|---|
| F1 | G1 | Nc | 20/40/80 @4000/6000/7500 | spread 2.4 / 13.5 / 4.9 % | the answer depends on the mesh near the pipe's quarter-wave | first-order Rusanov pipe; 20 cells = 64 mm cells on a 1.275 m duct |
| F2 | G2 | dt | 0.125/0.25/0.5 | spread 7.9 / 15.2 / 2.2 % | same | pipe temporal resolution (now sub-stepped to CFL≤0.4; residual is spatial) |
| F3 | G3 | convergence | 6000/7700 rpm | 116 / 158 cycles at 1e-4; ±0.4 % limit cycle | results are 20-cycle block means, not fixed points | slow pipe/chamber mean-state transient + beating |
| F4 | S3 | peak rpm | all sweeps | 8 flips between 7500 and 8500 | peak location is set by <0.6 % power differences | flat-topped curve |
| F5 | S1 | reed area | 400→450 mm² | +5.45 % in one 50 mm² step | steep but monotone; the only >5 % step | lift-area ∝ seat area at small seats |
| F6 | S2 | pipe length | 1050–1400 | 7 reversals, max 1.7 % | small oscillation about a rising trend | limit-cycle noise + weak absorption |
| F7 | P3 | Tmax | 7500 rpm | 3021 K | above the 3000 K plausibility limit | constant γ=1.33, no dissociation, no variable cp |
| F8 | P3 | BMEP/BSFC | 2000 rpm | 2.25 bar / 1333 g/kWh | far outside 4–9 bar and 300–800 | scavenging is very poor at low speed (SE 0.375, TE 0.199) |
| F9 | C2 | coupling | top × CR × pipe | no sign flips (all same) | one-at-a-time is now valid locally | — |

---

## 3. Minimum reproduction commands

G1 (grid):
```matlab
P = params('quiet');
for Nc = [20 40 80]
  M = engine_model(P,6000,struct('quiet',true,'Nc',Nc,'max_revs',300,'tol',1e-3));
  fprintf('%d %8.0f\n', Nc, M.P_b);
end
% -> 6458 / 6092 / 5641 at tol 1e-3; 6500 / 6090 / 5666 at tol 1e-4
```

G2 (step):
```matlab
P = params('quiet');
for dth = [0.125 0.5]
  M = engine_model(P,6000,struct('quiet',true,'dtheta',dth,'Nc',60,'max_revs',300,'tol',1e-3));
  fprintf('%.3f %8.0f\n', dth, M.P_b);
end
```

G3 (convergence):
```matlab
P = params('quiet');
M = engine_model(P,7700,struct('quiet',true,'Nc',60,'max_revs',300,'tol',1e-6));
fprintf('%d cycles, converged %d, beat %.1e\n', M.cycles, M.converged, M.m_beat);
% -> 158 cycles
```

S3 (flat peak):
```matlab
P = params('quiet');
for N = [7500 8500]
  M = engine_model(P,N,struct('quiet',true,'Nc',60,'max_revs',300,'tol',1e-3));
  fprintf('%d %8.1f\n', N, M.P_b);
end
% -> 7928.3 / 7780.9  (1.9 % apart; the peak is between them)
```

---

## 4. Safe operating region (where S1/S2/S3 all pass)

| Parameter | Baseline | Smooth + monotone (S1/S2 clear) | Where S3 fires |
|---|---|---|---|
| exhaust port top | 27.0 mm | **26.5 – 32.0 mm** (24–26.5 has ≤0.6 % wiggles) | 26.0→26.5 |
| transfer port top | 38.0 mm | **36.0 – 39.5 mm** | 37.5→38.0 |
| CR | 10.1 | **9.5 – 11.5** | 11.5→12.0 |
| pipe length | 1275 mm | **none — 7 reversals**, but all ≤1.7 % | 1100, 1175 |
| ignition | curve | **14 – 24°** (below 14 is the physical MBT climb) | 20→21 |
| AFR | 12.5 | **11.0 – 15.0** | 11.5→12.0 |
| reed area | 600 mm² | **450 – 800 mm²** | 500→550 |
| crankcase volume | 385 cc | **400 – 500 cc** (≤0.15 % wiggles below) | none |

**Operating-point region:** the model is best behaved at **6000–8500 rpm**. Below 4000 rpm
the scavenging collapses (SE 0.375 at 2000) and BMEP/BSFC leave the bands.

**Parameter-change region:** keep proposed changes within ±10 % of baseline and within the
ranges above. The largest experiment (E5, +18.6 % peak power) is outside it.

---

## 5. Coding bugs found and fixed

| # | Bug | Before | After |
|---|---|---|---|
| B1 | Fresh-charge species never left the cylinder; `mf` grew until capped by `cyl.m` | SE = **1.000** at every point (cylinder 100 % fresh) while the model *reported* 0.80 from an unconnected algebra | SE from composition; 0.375–0.80 |
| B2 | `M.TE` was `SE/DR`, which assumes trapped mass = reference mass | TE 0.835 at 7500 (actual 0.448) | TE 0.553 (composition) |
| B3 | `P.inlet.A_venturi` defined and never used | 600 mm² of nothing on the inlet | VM22 venturi in series with the reed |
| B4 | Reed was a constant 600 mm² check valve | closed at 13.5° ATDC (Blair: 86–122°) | lift-limited petal, A_rd = n·x·w |
| B5 | Reed seat area inert (400–800 all gave 7853 W) | dead parameter | planform derived from seat; 6797–8120 W |
| B6 | Convergence was single-cycle | stopped mid-transient (7700: cycle 79 of 158) | 20-cycle block mean |
| B7 | Pipe stepped once per crank step, CFL→1.0 | power depended on dt by 20 % | sub-stepped to CFL ≤0.4 |
| B8 | Block-mean convergence reused `m1`, corrupting the mass balance | mass balance reported **24** | 1e-14 |
| B9 | `params.m` carried 5-speed carb (VM20) and 5-speed gearbox on a 4-speed build | wrong inlet area, wrong gearing | VM22, 4-speed 3.182/2.000/1.368/1.000, 16/34 |

**Physics changes, each cited (changelog):**

| # | Change | Citation |
|---|---|---|
| P1 | Wiebe a=6.9, m=1.05, 64° | Galindo/Climent 2011 L415 (a); Blair D&S L16699-16704 (m, duration) |
| P2 | Exhaust Cd = f(k, Π) | Blair D&S A2.4–A2.7, L12114–12223; Zhang Table 4.1 baseline |
| P3 | Reed petal lift law | Blair D&S §5.4, A_rd = n·x·X_p, L23764–23769; Climent 2023 L313–321 |
| P4 | Carb venturi in series | Zhang 4.1; standard series-orifice relation |
| P5 | Pipe and chambers initialised at T_exh | numerical initial condition only |

**Before/after at the 10 operating points** (`BASELINE.csv` → `AFTER.csv`):

| rpm | P_b before | P_b after | DR before | DR after | BSFC before | BSFC after | SE after |
|---|---|---|---|---|---|---|---|
| 2000 | 2871 | 989 | 1.629 | 0.881 | 849 | 1333 | 0.375 |
| 3000 | 4870 | 2365 | 1.281 | 0.819 | 591 | 778 | 0.516 |
| 4000 | 6762 | 3615 | 1.409 | 0.730 | 624 | 605 | 0.616 |
| 5000 | 7389 | 5635 | 1.228 | 0.810 | 622 | 538 | 0.772 |
| 6000 | 8792 | 5846 | 1.186 | 0.604 | 605 | 464 | 0.764 |
| 6500 | 9351 | 6490 | 1.113 | 0.601 | 579 | 450 | 0.756 |
| 7000 | 9786 | 7432 | 1.025 | 0.639 | 549 | 450 | 0.766 |
| 7500 | 10101 | 7928 | 0.957 | 0.623 | 532 | 441 | 0.798 |
| 8000 | 10270 | 7741 | 0.894 | 0.567 | 521 | 439 | 0.783 |
| 8500 | 10434 | 7781 | 0.806 | 0.528 | 492 | 432 | 0.769 |

Power fell because delivery ratio fell from ~1.0 to 0.5–0.6. The old 10.4 kW was produced
by delivering 1.6× the reference mass at 2000 rpm — the error D1 identified.

---

## 6. Not tested / limits of this audit

- **P1 mass balance fails below 4000 rpm.** At 2000 rpm it is −9.0e−2 and at 3000 −4.5e−3
  (the P1 table above is at 4000–8500, where it is 1e−14). At low speed the stored mass in
  the pipe and the 3.7 L of chambers is still drifting at the 20-cycle convergence point, so
  those two points are not at steady state and should not be quoted.
- **C1 clamp activity** is inferred from state minima (min T 465 K vs a 150 K floor; min p
  88 kPa vs 500 Pa), not from counters inside the solver. No clamp engaged in any run, but
  the count is not instrumented.
- **The scavenging law is still partially double-counted.** The retained/short-circuit split
  (`kappa`) and the species advection both remove fresh charge. At 7500 they agree closely
  (SE 0.798 vs law 0.787); at 2000 they diverge (0.375 vs 0.766). A two-zone cylinder is the
  correct fix and was not attempted.
- **Peak power/rpm** are grid maxima over 4000/6000/7500/8500, not fitted peaks.
- **G1/G2 were not driven below 2 %.** Doing so needs a second-order pipe flux or ~4× finer
  meshes; that is a solver rewrite, not a bug fix.
