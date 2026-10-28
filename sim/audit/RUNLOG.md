# Run log — RX135 model revision 2

| time | phase | change | key numbers |
|---|---|---|---|
| 2026-10-28 | §1 read | read all 7 documents + 3 model files; wrote `audit/UNDERSTANDING.md` | DR 0.957 @7500, SE_actual 1.000, Tmax 3654 K |
| 2026-10-28 | §3 baseline | copied `params/port_geometry/engine_model` to `sim/baseline/`; 10 points to `audit/BASELINE.csv` | peak 10434 W @8500, DR 1.63 @2000 |
| 2026-10-28 | D1c | fresh species now leaves with the outflow | SE 1.000 → 0.83 @7500 |
| 2026-10-28 | D1a | VM22 venturi wired in series with reed; carb corrected 20→22 mm | DR 0.93 → 0.59-ish |
| 2026-10-28 | D1b | reed petal lift law (Blair A_rd = n·x·w) | DR 0.587 @7500, BMEP 4.58 |
| 2026-10-28 | D2 | Wiebe a=6.9, m=1.05, 64° | Tmax 2371→3026 K @7500 |
| 2026-10-28 | D3 | exhaust Cd map f(k,Π) | DR 0.623, BSFC 441 |
| 2026-10-28 | D4 | found: single-cycle convergence stops mid-transient; 6000 rpm limit cycle | 7700: 158 cycles at 1e-6 |
| 2026-10-28 | D4 fix | 20-cycle block-mean convergence; pipe sub-stepping to CFL≤0.4; warm pipe start | cycles 41–96 |
| 2026-10-28 | bug | block-mean reused `m1`, corrupting mass balance | 24 → 1e-14 |
| 2026-10-28 | sweeps | 8 OAT sweeps, 93 points | max adjacent step 5.45 % (reed 400), 15 reversals ≤1.7 % |
| 2026-10-28 | grid | G1 2.4/13.5/4.9 %, G2 7.9/15.2/2.2 % | FAIL; pipe only (core <1 %) |
| 2026-10-28 | checks | P1 1e-14, P2 9e-4, P4 9/9 ok, C1 no clamp, C2 no sign flip | |
| 2026-10-28 | §11 | built `exp_ab.m`, `exp_set.m`, `gearing.m`; null test exactly 0 | E5 +18.6 % |
| 2026-10-28 | report | `audit/AUDIT_REPORT_v2.md`, `FINAL_REPORT_v2.md` | 6/13 checks pass |
