# RX135 model — final report v2

Date: 2026-10-28. Model revision 2. Every number is a run from this session; raw data in
`sim\audit\` and `sim\experiments\`.

---

## 1. What changed, and why

Each change is a bug fix or a cited physics change. No parameter was adjusted to hit a target.

### 1.1 Coding bugs (no physics)

| # | Change | Before → after |
|---|---|---|
| B1 | **Fresh-charge species was never advected out.** `mf` grew until capped by `cyl.m`, so the trapped charge was 100 % fresh at every point while the model *reported* SE from an unconnected algebra. | SE 1.000 → 0.375–0.80 |
| B2 | **TE was `SE/DR`**, which assumes trapped mass = reference mass. It is not (0.43). | TE 0.835 → 0.553 at 7500 |
| B3 | **`P.inlet.A_venturi` was defined and never used.** The induction path was 600 mm² of nothing. | VM22 venturi (380 mm²) in series with the reed |
| B4 | **The reed had no lift law** — a constant 600 mm² check valve that closed at 13.5° ATDC (Blair measured 86–122°). | lift-limited petal |
| B5 | **The reed seat area was inert** (400–800 mm² all gave 7853 W). | planform derived from seat; 6797–8120 W |
| B6 | **Convergence was a single cycle-to-cycle change**, which a monotonic drift satisfies by accident (7700 rpm: stopped at cycle 79 of 158). | 20-cycle block mean |
| B7 | **The pipe was stepped once per crank step**, reaching CFL 1.0 at low speed. | sub-stepped to CFL ≤ 0.4 |
| B8 | Block-mean edit reused `m1`, corrupting the mass balance. | residual 24 → 1e−14 |
| B9 | `params.m` carried the **5-speed carb (VM20) and 5-speed gearbox** on a 4-speed build. | VM22; 3.182/2.000/1.368/1.000, final 16/34 |

### 1.2 Physics changes, with citation

| # | Change | Citation |
|---|---|---|
| P1 | Wiebe **a = 6.9, m = 1.05, burn 64°** | a: Galindo/Climent 2011, `CombCorrel2S` L415 ("fixed to 6.9, so 99.9 % burnt"); m and duration: Blair D&S L16699–16704 (65 cc chainsaw, a=5, m=1.05, 64°). The Galindo regression for m is OCR-destroyed in our extract, so Blair's measured value was used instead. |
| P2 | **Exhaust Cd = f(area ratio k, pressure ratio Π)** | Blair D&S A2.4–A2.7, L12114–12223 (measured k = 0.127/0.437/0.716/0.824, Cd 0.79–0.84 falling to 0.40–0.70); level from Zhang 1995 Table 4.1 (0.75 normal, 0.90 reverse inlet). Applied to the exhaust only — transfer Cd is not in the literature and does not inherit exhaust values. |
| P3 | **Reed lift law** A_rd = n·x·w, x from Δp and the petal bending stiffness | Blair D&S §5.4, L23764–23769; Climent 2023 L313–321 (mass-spring-damper form). Petal geometry is ASSUMED (2 petals, 30 × 10 mm, 0.2 mm steel, stop at 0.33 L) — the RX135 reed is not dimensioned in any source we hold. |
| P4 | **Carburettor venturi in series with the reed** | Zhang 1995 Table 4.1; standard series-orifice relation 1/A² = 1/A₁² + 1/A₂² |

Not changed: friction (Blair 5.4.2), η_comb (0.95), Woschni, port geometry, exhaust geometry.

---

## 2. Before / after at ten operating points

`sim\audit\BASELINE.csv` → `sim\audit\AFTER.csv`.

| rpm | P_b W | T Nm | BMEP bar | DR | TE | SE | BSFC | p_trap bar | peak rpm |
|---|---|---|---|---|---|---|---|---|---|
| | *before → after* | | | | | | | | |
| 2000 | 2871 → 989 | 13.71 → 4.72 | 6.52 → 2.25 | 1.629 → 0.881 | 0.322 → 0.199 | 1.00 → 0.375 | 849 → 1333 | 1.262 → 1.099 | 8500 → 7500 |
| 3000 | 4870 → 2365 | 15.50 → 7.53 | 7.37 → 3.58 | 1.281 → 0.819 | 0.439 → 0.328 | 1.00 → 0.516 | 591 → 778 | 1.343 → 1.303 | |
| 4000 | 6762 → 3615 | 16.14 → 8.63 | 7.68 → 4.10 | 1.409 → 0.730 | 0.397 → 0.416 | 1.00 → 0.616 | 624 → 605 | 1.353 → 1.275 | |
| 5000 | 7389 → 5635 | 14.11 → 10.76 | 6.71 → 5.12 | 1.228 → 0.810 | 0.390 → 0.456 | 1.00 → 0.772 | 622 → 538 | 1.202 → 1.292 | |
| 6000 | 8792 → 5846 | 13.99 → 9.30 | 6.66 → 4.43 | 1.186 → 0.604 | 0.394 → 0.530 | 1.00 → 0.764 | 605 → 464 | 1.187 → 1.206 | |
| 6500 | 9351 → 6490 | 13.74 → 9.54 | 6.53 → 4.54 | 1.113 → 0.601 | 0.411 → 0.546 | 1.00 → 0.756 | 579 → 450 | 1.187 → 1.254 | |
| 7000 | 9786 → 7432 | 13.35 → 10.14 | 6.35 → 4.82 | 1.025 → 0.639 | 0.433 → 0.541 | 1.00 → 0.766 | 549 → 450 | 1.174 → 1.302 | |
| 7500 | 10101 → 7928 | 12.86 → 10.09 | 6.12 → 4.80 | 0.957 → 0.623 | 0.448 → 0.553 | 1.00 → 0.798 | 532 → 441 | 1.143 → 1.274 | 7500 |
| 8000 | 10270 → 7741 | 12.26 → 9.24 | 5.83 → 4.40 | 0.894 → 0.567 | 0.459 → 0.562 | 1.00 → 0.783 | 521 → 439 | 1.107 → 1.235 | |
| 8500 | 10434 → 7781 | 11.72 → 8.74 | 5.58 → 4.16 | 0.806 → 0.528 | 0.489 → 0.575 | 1.00 → 0.769 | 492 → 432 | 1.097 → 1.229 | |

Power fell because delivery ratio fell. The old 10.4 kW came from delivering **1.63× the
reference mass** at 2000 rpm and 0.96× at 7500 — the error D1 named. The old SE = 1.000 was
not a scavenging result at all.

---

## 3. Acceptance criteria

| Criterion | Target | Model | Verdict |
|---|---|---|---|
| DR at peak | 0.50–0.75 | 0.528 (8500), 0.623 (7500) | **PASS** |
| TE at peak | 0.60–0.80 | 0.575 (8500), 0.553 (7500) | **FAIL** (short by 0.03–0.05) |
| SE at exhaust close | 0.55–0.80 | 0.769 (8500), 0.798 (7500) | **PASS** |
| BMEP at peak | 4.0–9.0 bar | 4.16 (8500), 4.80 (7500) | **PASS** |
| BSFC at peak | 300–500 g/kWh | 432 (8500), 441 (7500) | **PASS** |
| Peak power rpm | 8650–8850 ±5 % | model peak **7500**; power at 8500 is 98 % of peak | **FAIL** |
| Grid independence | <2 % (Nc 20/40/80, dt 0.125/0.25/0.5) | 2.4–13.5 % (Nc), 2.2–15.2 % (dt) | **FAIL** |
| Smoothness | no step >5 %, no peak move >200 rpm | 1 step 5.45 %, 15 reversals ≤1.7 %, 8 peak flips | **FAIL** |
| Mass balance | <1e−8 | 1e−14 at 4000–8500; **−9e−2 at 2000, −4.5e−3 at 3000** | **PASS above 4000, FAIL below** |
| Determinism | bit-identical | 0.0e+00 | **PASS** |
| No routine clamp | report count | none engaged (min T 465 K vs 150 K floor) | **PASS** |

**6 pass, 5 fail.**

### Why TE misses

TE = SE · (m_trapped/m_ref) / DR. At 7500: 0.798 × 0.426 / 0.623 = 0.546. The trapped-mass
ratio 0.426 is set by V_ec/V_d = 0.647, p_trap 1.27 bar and T_ec 511 K. To reach TE 0.60 at
the same SE, DR would have to fall to 0.57 — a 9 % reduction. That is inside the uncertainty
of the **assumed reed geometry**, which is the single largest unknown in the model. I did not
adjust it to close the gap.

### Why the peak speed misses

The model peaks at 7500 and is flat to 8700 (7781 W at 8500 vs 7928 at 7500, −1.9 %). The
observed 8650–8850 rpm comes from top speed (gearing.m: 120 km/h = 8828 rpm in 4th), not from
a measured power peak. The model is consistent with the bike reaching that speed — it still
makes 98 % of peak power there — but it does not place the *maximum* there.

### Why grid independence fails

With the pipe disabled, dt changes power by <1 % (4000: 4032 vs 3908; 6000: 0.1 %; 7500:
0.35 %). All of the grid dependence is in the exhaust ladder, and it is worst at 6000 rpm,
which sits on the pipe's quarter-wave (6380). The pipe uses a first-order Rusanov flux; its
numerical diffusion, and hence the wave phasing, depends on the mesh. Fixing this needs a
second-order flux (MUSCL-Hancock) or ~4× finer meshes — a solver rewrite, not a bug fix.

---

## 4. Remaining error budget (as % of power)

| Source | Size | Evidence |
|---|---|---|
| Pipe discretisation | **5–13 %** near 6000 rpm, 5 % at 7500, <2 % at 8500 | G1: 6458/6092/5641 at 6000 |
| Scavenging model (single zone, partial double count) | **±10 %** | SE 0.375 vs law 0.766 at 2000; they agree at 7500 |
| Reed petal geometry (ASSUMED) | **±8 %** | reed area 400→800 moves peak power 6797→8120 W |
| Exhaust Cd map | ±5 % | constant 0.75 vs map changes DR by ~4 % |
| Wiebe / heat transfer / friction | ±5 % combined | Climent: heat transfer alone is worth 12 % of trapped mass |
| **Total (RSS)** | **≈ ±16 %** | dominated by the first two |

For comparison, the literature's honest band for an uncalibrated model of this class is
8–13 % on power (WAVE UAV, `ACCURACY_TARGETS` §1.4) and 10 % worst-point with full 1-D gas
dynamics and a measured pipe (`Z95`). This model is at the pessimistic end of that, without
a dyno anchor.

---

## 5. Verdict

**For stock-vs-proposed comparisons this model is usable in the range 6000–8500 rpm with
parameter changes within ±10 % of baseline, provided both runs use identical numerics
(Nc 60, dt 0.25, block-mean convergence) and the comparison is a *difference* against the
same baseline. It is not usable for absolute power prediction, not usable below 4000 rpm
(mass balance does not close, SE collapses to 0.38), and not usable for large changes
(E5, +18.6 %) or for any claim about the *location* of the power peak.**

The reason is the ±16 % error budget: differences smaller than that are not resolvable, and
the two dominant terms (pipe discretisation, scavenging) both scale with the change.

Where it is genuinely useful: direction and approximate size of small changes to AFR, CR,
port timing, reed area and exhaust length. The eight sweeps are smooth and monotone enough for
that (max adjacent step 5.45 %, all reversals ≤1.7 % except the physical MBT reversal).

---

## 6. Measurements that would most improve it, ranked

1. **Reed petal geometry** — length, width, thickness, count, stop height, material. It sets
   the high-speed breathing and therefore the peak speed, and it is currently two assumed
   numbers away from being a free parameter. One caliper and 10 minutes.
2. **A dynamometer pull on this build (10 points, 4000–9000).** Anchors friction and the peak
   speed together; the brief's "one external measurement" is currently inferred from top
   speed, not measured.
3. **Cylinder pressure trace at 7000 and 8500 rpm.** The only way to separate Wiebe error from
   scavenging error; without it, combustion and trapping absorb each other.
4. **Transfer port widths with the barrel off.** Tests the Cpb = 1.95 vs Blair's 1.25 limit.
   If the real transfers are ~90 mm wide, the whole port map is non-stock and every timing
   sweep is around a wrong baseline.
5. **Exhaust-port pressure trace.** Separates a scavenging error from a pipe error — the
   single most confounded pair in this model.
6. **Crankcase / transfer-duct pressure trace.** Validates the pump and the Δp across the
   transfer port, which is where the low-speed collapse shows up.
7. **A trapped-mass or SE measurement (skip-cycle).** The only defence against a pressure
   match concealing a trapped-mass error (Climent: 2 % pressure, 12 % trapped mass).
