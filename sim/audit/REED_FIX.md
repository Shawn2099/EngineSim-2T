# Reed petal stiffness: 3EI/L³ → 8EI/L³

**Change** (the only code change): the cantilever tip stiffness used for the reed
petal was the **tip point-load** value `3EI/L³`. Blair's Eq. 6.3.10 treats the
petal as a **uniformly loaded** beam, giving `8EI/L³`:

    DEFL = P·b·L^4 / (8·E·I)      Blair, The Basic Design of Two-Stroke Engines,
                                  Eq. 6.3.10, p.288 (PDF p.154)

Modified:
- `sim/params.m:248` — `P.inlet.reed_k` 3 → 8 (comment cites the equation/page)
- `sim/engine_model.m:121` — `rk` 3 → 8 (same citation)

`k` at the 600 mm² baseline: **153.3 → 408.9 N/m** (2.67× stiffer).
Nothing else was re-tuned. `params('quiet')` passes 24/24 self-checks.

Artifacts: `reed_bracket_before.csv`, `reed_bracket_after.csv`,
`after/sweep_reed_A.csv`, `AFTER_stiff.csv`, `reed_bracket.m`, `reed_fix_curve.m`.

---

## 1. Baseline curve, 600 mm² / Cd 0.70 (Nc 60, tol 1e-4)

`AFTER.csv` (old 3EI) → `AFTER_stiff.csv` (8EI).

| rpm | P_b before | P_b after | Δ | DR b/a | SE b/a | TE b/a | BMEP b/a |
|---|---|---|---|---|---|---|---|
| 2000 | 989 | 872 | −11.8 % | 0.881 / 0.768 | 0.375 / 0.348 | 0.199 / 0.208 | 2.25 / 1.98 |
| 3000 | 2365 | 2024 | −14.4 % | 0.819 / 0.652 | 0.516 / 0.494 | 0.328 / 0.359 | 3.58 / 3.06 |
| 4000 | 3615 | 2970 | −17.8 % | 0.730 / 0.538 | 0.616 / 0.587 | 0.416 / 0.474 | 4.10 / 3.37 |
| 5000 | 5635 | 5247 | −6.9 % | 0.810 / 0.726 | 0.772 / 0.729 | 0.456 / 0.476 | 5.12 / 4.77 |
| 6000 | 5846 | 5396 | −7.7 % | 0.604 / 0.539 | 0.764 / 0.751 | 0.530 / 0.557 | 4.43 / 4.08 |
| 6500 | 6490 | 6068 | −6.5 % | 0.601 / 0.525 | 0.756 / 0.742 | 0.546 / 0.589 | 4.54 / 4.24 |
| 7000 | 7432 | 7139 | −3.9 % | 0.639 / 0.598 | 0.766 / 0.747 | 0.541 / 0.555 | 4.82 / 4.63 |
| 7500 | 7928 | 7720 | −2.6 % | 0.623 / 0.595 | 0.798 / 0.782 | 0.553 / 0.566 | 4.80 / 4.67 |
| 8000 | 7741 | 7587 | −2.0 % | 0.567 / 0.543 | 0.783 / 0.774 | 0.562 / 0.576 | 4.40 / 4.31 |
| 8500 | 7781 | 7605 | −2.3 % | 0.528 / 0.506 | 0.769 / 0.759 | 0.575 / 0.589 | 4.16 / 4.06 |

Peak brake power: **7928 W @7500 → 7720 W @7500 (−2.6 %)**. BSFC improves
441 → 432 g/kWh at 7500 because less fresh charge is short-circuited.

## 2. Reed bracket: area 500/600/700 mm² × Cd 0.6/0.7/0.8

Peak brake power over 4000/6000/7500/8500 rpm (Nc 40, tol 1e-3 — the audit
setting).

| area | Cd | peak before | peak after | Δ | DR7500 b/a | pinned % of open b/a |
|---|---|---|---|---|---|---|
| 500 | 0.6 | 6943 | 6660 | −4.1 % | 0.498 / 0.466 | 91 / 60 |
| 500 | 0.7 | 7450 | 7198 | −3.4 % | 0.560 / 0.527 | 90 / 61 |
| 500 | 0.8 | 7819 | 7571 | −3.2 % | 0.612 / 0.580 | 90 / 61 |
| 600 | 0.6 | 7434 | 7189 | −3.3 % | 0.558 / 0.526 | 90 / 61 |
| 600 | 0.7 | 7853 | 7618 | −3.0 % | 0.618 / 0.586 | 90 / 61 |
| 600 | 0.8 | 8064 | 7910 | −1.9 % | 0.666 / 0.634 | 90 / 59 |
| 700 | 0.6 | 7755 | 7530 | −2.9 % | 0.604 / 0.574 | 90 / 61 |
| 700 | 0.7 | 8046 | 7889 | −1.9 % | 0.661 / 0.630 | 90 / 60 |
| 700 | 0.8 | 8154 | 8060 | −1.1 % | 0.705 / 0.674 | 89 / 57 |

- Spread of peak power over the whole bracket: **17.4 % → 21.0 %**
- Cd 0.6→0.8 at 600 mm²: **8.5 % → 10.0 %**
- Area 500→700 at Cd 0.7: **8.0 % → 9.6 %**

`pinned % of open` = fraction of steps with the reed open that sit at the stop,
computed from the stored crankcase trace with the stiffness used in that run.

## 3. Existing reed sweeps in `sim/audit`

`after/sweep_reed_A.csv` vs `sweep_reed_A.csv` (Cd 0.70, peaks over 6000/7500/8500):

| area mm² | peak before | peak after | Δ | DR7500 b/a |
|---|---|---|---|---|
| 400 | 6797 | 6503 | −4.3 % | 0.482 / 0.450 |
| 500 | 7450 | 7198 | −3.4 % | 0.560 / 0.527 |
| 600 | 7853 | 7618 | −3.0 % | 0.618 / 0.586 |
| 700 | 8046 | 7889 | −1.9 % | 0.661 / 0.630 |
| 800 | 8120 | 8027 | −1.1 % | 0.692 / 0.662 |

P4 limit case, reed 200 mm² @7500 (Nc 60): **4488 → 4002 W**, DR 0.289 → 0.254.

## 4. Was the "<1 %" finding about pinning?

No. The <1 % result is the **revision-1** model (`sim/baseline/`), which had no
lift law at all — a constant-seat check valve and no stop. Re-measured there:
reed 400/600/800 = 10123/10228/10264 W (1.4 % total), Cd 0.6/0.8 = 10203/10245 W
(0.4 %). That model was inert because the reed was a fixed full-seat orifice, not
because a petal was pinned — there was no petal.

Revision 2 (lift law) was **never** inert to reed area: the bracket already
spanned 17.4 % before this fix. So the premise "reed area/Cd moved power by
under 1 %" is true only of revision 1.

## 5. Is the reed a real lever now?

Yes, with a caveat.

- The stop still dominates: pinning falls from ~90 % to ~60 % of the open event,
  it does not disappear. At the assumed geometry the full-lift curtain is
  `n·x_stop·w = 198 mm²` against a 600 mm² seat, and the VM22 venturi is 380 mm²;
  in series the inlet throat is ~175 mm² at full lift. The reed is the smallest
  orifice in the induction path, so induction **is** the limiting element in this
  model.
- Sensitivity is real but modestly changed by the fix: the 3×3 bracket is worth
  21 % of peak power (was 17 %), and the low-speed effect of the fix itself is
  large (−12 to −18 % at 2000–4000 rpm), so the reed matters much more at part
  load than at the power peak.
- Caveat: `engine_model.m` derives petal width from the seat area
  (`rw = A_s/(n·L)`), so "reed area" in these sweeps re-scales the petal
  planform. The 21 % spread is sensitivity to **petal geometry**, not to seat
  area alone. Measured petal dimensions are still needed to turn it into a
  physical lever.
