# RX135 through the ported Blair simulator (Prog.5.1) — results

**Date:** 2026-10-29
**Deck run:** `sim\blair\RX135_PROXY.dat`
**Source deck:** `port\RX135_INPUT.dat`
**Model:** `sim\blair\blair_init.m` → `blair_run.m` (port of Blair, *Basic Design of
Two-Stroke Engines*, ch.5, "engine model No.1"), MATLAB R2026b.
**Sweep:** full throttle (THAR = 1.0), 3000–9000 rpm in 500 rpm steps, 13 points.

> ## ⚠ THE INLET IS A PROXY
>
> Five of the seven NOT AVAILABLE fields — `IPO`, `IPFO`, `WIP`, `RTI`, `RBI` — describe a
> piston-port window that **does not exist on this engine**. The RX135 is reed-valve, and
> Prog.5.1 has no reed sub-model (Blair src 11055–11064). They were filled with the
> documented proxy block of `port\RX135_CASE_NOTES.md` §8:
>
> | Field | Proxy | Basis |
> |---|---|---|
> | `IPO` | 60° BTDC | QUB 400 piston-port timing, used as the nearest documented stand-in |
> | `IPFO` | 0° ATDC | QUB 400 |
> | `WIP` | 40.2 mm | 600 mm² assumed reed seat ÷ 14.92 mm effective height |
> | `RTI`, `RBI` | 0 mm | rectangular aperture assumed |
> | `LTP` | 46.0 mm | 90.8 mm drawing depth − 44.8 mm window centre |
> | `LIP` | 90.0 mm | cage ≈40 + manifold ≈50 mm, unmeasured |
>
> **Every number below inherits that substitution.** The inlet is the largest single driver
> of delivery ratio and therefore of power (notes §5.1). Nothing was tuned: the deck was
> run as delivered plus the documented proxies, and the model's own calibration constants
> (`BEFF` 0.85, `BDEG` 60°, `SCAV$` SCRE, `TAF` 12.5) were left at their case-file values.

---

## 1. Full-throttle sweep

| rpm | power kW | torque Nm | bmep bar | bsfc g/kWh | DR | TE | SE | pmax bar | tmax K | converged |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|:--:|
| 3000 | 3.906 | 12.432 | 5.913 | 429.9 | 0.733 | 0.580 | 0.829 | 33.97 | 2854 | yes |
| 3500 | 5.128 | 13.991 | 6.654 | 462.0 | 0.886 | 0.540 | 0.896 | 37.62 | 3046 | yes |
| 4000 | 6.083 | 14.522 | 6.907 | 473.6 | 0.943 | 0.521 | 0.914 | 38.61 | 3104 | **no** (a) |
| 4500 | 6.781 | 14.390 | 6.844 | 475.4 | 0.938 | 0.518 | 0.907 | 38.51 | 3090 | yes |
| 5000 | 7.370 | 14.075 | 6.695 | 495.7 | 0.956 | 0.503 | 0.907 | 37.99 | 3079 | yes |
| 5500 | 8.022 | 13.929 | 6.625 | 490.2 | 0.936 | 0.511 | 0.900 | 37.84 | 3073 | yes |
| 6000 | 8.615 | 13.712 | 6.522 | 478.7 | 0.900 | 0.520 | 0.886 | 37.36 | 3057 | **no** (a) |
| 6500 | 8.753 | 12.860 | 6.116 | 489.6 | 0.863 | 0.512 | 0.869 | 35.63 | 3031 | **no** (a) |
| 7000 | 8.891 | 12.129 | 5.769 | 494.0 | 0.821 | 0.508 | 0.851 | 34.21 | 3000 | yes |
| **7500** | **9.052** | **11.525** | **5.481** | **484.0** | **0.764** | **0.526** | **0.824** | **33.14** | **2914** | **yes** |
| 8000 | 9.047 | 10.799 | 5.136 | 476.9 | 0.706 | 0.537 | 0.791 | 31.77 | 2833 | yes |
| 8500 | 8.830 | 9.920 | 4.718 | 492.0 | 0.669 | 0.524 | 0.761 | 29.89 | 2762 | yes |
| 9000 | 8.725 | 9.258 | 4.403 | 497.2 | 0.631 | 0.523 | 0.737 | 28.85 | 2742 | **no** (a,b) |

Torque is derived: `T = P·1000 / (2π·rpm/60)`. `pmax` is peak cylinder pressure [bar],
`tmax` peak cycle temperature [K], from the last completed cycle.
`DR` delivery ratio, `TE` trapping efficiency, `SE` scavenging efficiency,
`bmep` brake mean effective pressure, `bsfc` brake specific fuel consumption.

Supporting values at peak (7500 rpm): IMEP 6.13 bar, PMEP 0.276 bar, FMEP 0.375 bar,
CE 0.402, peak-pressure angle 16.8° ATDC. Fuel flow 4.38 kg/h at the deck's `TAF` = 12.5,
i.e. 54.8 kg/h air — consistent with DR 0.764 on 132.1 cm³ at 7500 rpm.

### Convergence (a)

**No point errored and no point failed to return.** Four of thirteen did not satisfy the
harness's 1 %/cycle test (`blair_run` `CONFIG.tol = 1e-2` on DR, IMEP, PMEP, BMEP) before
hitting the 5-cycle floor, so they were re-run to 15 cycles:

| rpm | last-cycle ΔP | ΔDR | P at cycle 5 | P at final cycle | verdict |
|---:|---:|---:|---:|---:|---|
| 4000 | 0.10 % | 0.31 % | 6.083 | 6.077 | settled at cycle 6 |
| 6000 | 0.45 % | 0.38 % | 8.615 | 8.577 | settled, ≈0.5 % drift |
| 6500 | 0.18 % | 0.14 % | 8.753 | 8.738 | settled, ≈0.2 % drift |
| 9000 | 0.37 % | 0.14 % | 8.725 | 8.525 | **limit cycle (b)** |

So three of the four reported values are stable to ≤ 0.5 %, and the flag is the harness's
5-cycle minimum, not a diverging solution. The fourth (9000 rpm) is the limit cycle below.

### (b) 9000 rpm is a limit cycle

The 9000 rpm point oscillates rather than converging: P = 8.728, 8.513, 8.725, 8.493
at cycles 3–6, i.e. a ±1.3 % two-cycle oscillation, and cycle 15 differs from cycle 5 by
2.35 %. The 9000 rpm row should be read as 8.7 ± 0.2 kW. This is the only point where the
reported number is not settled.

---

## 2. The port's own accuracy — read this before believing any absolute value

The same harness run on Blair's **QUB 400** reference case (3000 rpm, WOT, SCRE, cycle 5,
published in Fig.5.9) gives:

| | port | Blair | ratio |
|---|---:|---:|---:|
| Power | 13.83 kW | 12.20 kW | **1.133** |
| BMEP | 6.96 bar | 6.14 bar | 1.134 |
| IMEP | 7.58 bar | 6.72 bar | 1.128 |
| BSFC | 425 g/kWh | 464 g/kWh | 0.916 |
| DR | 0.887 | 0.854 | 1.038 |
| SE | 0.888 | 0.818 | 1.085 |
| TE | 0.544 | 0.504 | 1.079 |
| pmax | 38.9 bar | 35.8 bar | 1.087 |
| Tmax | 3071 K | 2891 K | 1.062 |

Mean absolute error across 16 quantities: **8.7 %**. `QUB400_VALIDATION.md` scores the port
at 17/46 targets inside tolerance — a **FAIL**.

**This matters for the headline.** The port over-predicts power on its own reference case by
13.3 %, consistently across power, IMEP and BMEP. Applying the same bias to 9.052 kW gives
**7.99 kW** — which lands on the 0-D model's 7.9 kW to within 1.1 %. That agreement is a
property of the two errors, not of the engine, but it is the correct way to use an
uncalibrated port.

---

## 3. Comparison with what we already know

### 3.1 Side by side

| Quantity | 0-D model | Blair port (proxy inlet) | Factory | Blair's band |
|---|---|---|---|---|
| Peak power | 7.9 kW @ 7500 | **9.05 kW @ 7500** | 10.4 kW @ 7500 (5-sp); 8.9 kW @ 6500 (4-sp) | — |
| Peak power, bias-corrected | — | 7.99 kW | — | — |
| BMEP at peak | 4.2–4.8 bar | 5.48 bar | 6.30 bar (implied by 10.4 kW) | 4–9 bar |
| BSFC at peak | — | 484 g/kWh | ≈405 g/kWh (implied) | 300–500 |
| DR range | 0.53–0.62 | 0.63–0.96 | — | — |
| DR at peak | ≈0.58 | 0.764 | — | — |
| SE range | 0.77–0.80 | 0.74–0.91 | — | — |
| SE at peak | ≈0.78 | 0.824 | — | — |
| Peak-speed location | 7500 | 7500 (7500≡8000) | 7500 | — |
| Road: top of 4th | — | 8.79 kW at 8700 rpm | 8700 rpm @ 120 km/h | — |

Factory figures from `RX135_5S_VERIFIED_PARAMETERS.md` §11: 10.4 kW @ 7500 for the 5-speed
`4TL10`; 12 PS (8.9 kW) @ 6500 for the 4-speed. Our build is the 5-speed cylinder with the
4-speed pipe and carb, so the honest factory bracket is **8.9–10.4 kW**.

### 3.2 Where the two models agree

1. **Peak power, once the port's known bias is removed.** 9.05 → 7.99 kW vs 7.9 kW. A 1.1 %
   agreement. Uncorrected, they differ by 15 %.
2. **Peak-speed location: both put it at 7500 rpm.** The road observation does not.
3. **The top end is flat, not peaky.** The port holds 97 % of peak power at 8700 rpm; the
   0-D model's curve is likewise broad. Neither model manufactures a tuned-pipe spike.
4. **SE is in the same place at peak**: 0.824 vs 0.78 (5.6 % apart) — the only efficiency
   on which the two models are close without correction.

### 3.3 Where they diverge

1. **Delivery ratio — the big one.** 0.764 at peak and 0.96 mid-range vs 0.53–0.62. The
   port delivers 25–55 % more charge. This is almost entirely the proxy inlet: a 600 mm²
   piston-port window open 120°, fully open at TDC when crankcase depression peaks, with no
   reed lag, no reed reversion and no airbox restriction. A reed block is a pressure-driven
   one-way valve; the proxy is an idealised hole that is never shut when it matters.
2. **BMEP.** 5.48 vs 4.2–4.8 bar. Follows directly from the DR divergence.
3. **Shape of the torque curve.** The port peaks at 4000 rpm (14.5 Nm) and falls 36 % by
   9000; the 0-D model's BMEP range implies a flatter, lower curve.
4. **Peak-speed location against the road.** The bike reaches ~8700 rpm at 120 km/h in 4th;
   the model's peak is 7500–8000. The model is not *inconsistent* with the observation (at
   8700 rpm it still makes 97 % of peak, so drag-limited top speed in 4th is reachable),
   but it does not reproduce a power peak at 8650–8850 as `ps5` inferred.

### 3.4 Which is more plausible, and why

**On BMEP and power, the Blair port is more plausible than the 0-D model.** 5.48 bar sits
inside Blair's 4–9 bar band and closer to the factory-implied 6.30 bar than the 0-D model's
4.2–4.8, which is low for a 132 cm³ two-stroke at its rated speed. Blair's own validated
loop-scavenged reference (QUB 400) made 6.14 bar BMEP at 3000 rpm with a *lower* trapped CR
(6.7) and an *empty* box; a 5.5 bar peak at 7500 rpm for a hotter-timed cylinder is
unremarkable. The 0-D model's 7.9 kW is below even the 4-speed's factory 8.9 kW.

**On DR and SE, neither is trustworthy, and the port's numbers are the less defensible.**
DR 0.96 and SE 0.91 at 5000 rpm are uniflow-class figures from a loop-scavenged engine with
a 45× damper box; Blair's own QUB 400 achieved SE 0.818 at DR 0.854. An SE of 0.91 with
TE 0.503 means 48 % of the delivered charge short-circuits while the cylinder still fills to
91 % — the model is reporting near-perfect displacement scavenging that this port layout and
silencer cannot produce. The 0-D model's 0.53–0.62 is at the other extreme, below the QUB
400's 0.854 and below what a reed-valve 125 typically achieves at its torque peak (0.65–0.80).
**The truth is almost certainly between the two, near 0.70 at peak, falling to ~0.65 at
9000 rpm** — and only a reed model or a measured crankcase pressure trace would settle it.

**On peak speed, the port agrees with the factory (7500) and disagrees with the road (8700).**
The factory rating is the stronger evidence: the road figure is a top-speed-in-gear
observation, which is set by road load, not by the power peak. A flat 8.7–9.0 kW from 6000
to 9000 rpm is exactly the shape that lets a bike pull 8700 rpm in 4th while peaking at 7500.
So this is not a contradiction, but it does mean **the port cannot be used to place the power
peak at 8700**, and `ps5`'s inference of an 8650–8850 rpm peak is not supported here.

**Blair's bands:** BMEP 4.40–6.91 bar over the sweep — inside 4–9 throughout. BSFC
430–497 g/kWh — inside 300–500, but pinned against the *upper* (inefficient) limit for the
whole sweep. A model that puts a 132 cm³ two-stroke at 484 g/kWh at its power peak and
429 g/kWh at 3000 rpm is describing a thirsty engine, and the fuel-flow check (AFR exactly
12.5 by construction, since `TAF` fixes it) means the BSFC is just 1/TE × a combustion
efficiency — it is not independent evidence.

---

## 4. Physically implausible, or suspect

1. **DR 0.956 / SE 0.907 at 5000 rpm.** Highest delivery ratio in the sweep at the *lowest*
   trapping quality — an SE of 0.91 from a loop-scavenged, box-damped cylinder. Uniflow-class
   scavenging. **Artefact of the proxy inlet** (no reed check, no reversion). Flagged.
2. **BSFC minimum at 3000 rpm (430 g/kWh), not at the torque peak.** Real two-strokes are
   most efficient near peak torque. Here BSFC tracks 1/TE, and TE is highest at 3000 rpm
   (0.580) — itself a low-speed artefact of a reed-less inlet that cannot lose charge back
   out of the crankcase at low speed. Flagged.
3. **Flat power top: 8.62 kW at 6000 → 9.05 at 7500 → 8.73 at 9000 (±2.6 % over 3000 rpm).**
   A cylinder with 185.7° exhaust duration and a non-tuned box should fall away faster above
   8000. The flattening occurs because DR falls almost exactly as fast as FMEP rises. The
   notes predicted the opposite failure ("under-predict the top end"); the model instead
   under-predicts the *fall-off*. Flagged as a shape error, direction uncertain.
4. **Torque peak at 4000 rpm (14.52 Nm).** Very low for 185.7° exhaust / 131° transfer
   timing. Consistent with (3): the box is absorbing the tuning, so filling is set by the
   crankcase, not by port timing.
5. **"Peak at 7500 rpm" is a grid coincidence.** 9.052 kW at 7500 vs 9.047 kW at 8000 — a
   0.005 kW difference, i.e. 0.06 %. Do **not** read 7500 as a resonance; the true peak of
   this curve is a plateau spanning 7500–8000, and it coincides with the deck's `RPM` field
   only because that is where the grid is sampled.
6. **`converged` is not a clean yes/no across the sweep.** Four points hit the 5-cycle floor;
   the 9000 rpm point is a ±1.3 % limit cycle (±2.35 % against cycle 5). Only 9 of 13 points
   met the 1 %/cycle test as the harness defines it.
7. **Burn phasing is fixed and wrong for this engine.** `BDEG` = 60° gives a heat release
   starting ~10° BTDC at every speed — the measured 19.5° BTDC static advance cannot be
   entered (notes §3). Peak-pressure angle stays 15.6–16.9° ATDC across 3000–9000 rpm,
   which is a model artefact, not a result. Any conclusion about combustion phasing or
   detonation margin from this run is void.
8. **Tmax 3104 K at 4000 rpm.** At the top of the SI range, though only 1 % above the port's
   own QUB 400 value (3071 K), so it is a port bias rather than a RX135 property. Not a
   hard flag.
9. **Not flagged:** pmax 28.9–38.6 bar is consistent with TCR 5.91 (motoring ≈13 bar) and
   pmax/BMEP ≈ 5.1–5.6, normal for SI. Fuel flow, air flow and AFR are mutually consistent.
   Geometry (`EXHT` 23.00 mm, `TRHT` 12.00 mm, `HEOT` 27.00 mm, `FEPRT` 842 mm²,
   `FTPRT` 1125 mm², `CYCV` 14.53 cm³) reproduces the case notes exactly.

---

## 5. Limitations, in order of consequence

1. **The inlet is a proxy (all conclusions).** `IPO`/`IPFO`/`WIP`/`RTI`/`RBI` are QUB 400
   piston-port values and an area-matched seat, not this engine. DR, TE, SE, BMEP, power and
   BSFC all rest on it. Only a reed model or a measured crankcase pressure trace removes it.
2. **The port over-predicts its own validation case by 13.3 % on power.** Uncalibrated. All
   absolute powers carry that systematic bias; the bias-corrected peak is 7.99 kW.
3. **`LTP` = 46 mm and `LIP` = 90 mm are proxies** (transfer duct cast, inlet tract length
   never measured).
4. **`SCAV$` = SCRE is a selector, not a measurement.** Blair's own spread to YAM6 is −8 %
   power / +9 % BSFC (notes §6), i.e. 8.3 kW / 528 g/kWh.
5. **`CCR` = 1.343 from an unmeasured 385 cm³ crankcase.** DR moves almost 1:1 with it.
6. **`CRL` = 98 mm unverified**; `TCR` 5.91 vs 6.40 depending on the 27.0/29.7 mm exhaust
   height question, which is ±8 % of trapped mass.
7. **This build has never been validated as a build** — 5-speed cylinder, 4-speed pipe and
   carb. Blair's four reference engines are all piston- or disc-ported.

---

## 6. Reproducing

| File | What it does |
|---|---|
| `sim\blair\RX135_PROXY.dat` | the deck as run: `port\RX135_INPUT.dat` with the 7 proxy lines substituted, nothing else changed |
| `sim\blair\run_rx135_sweep.m` | the 13-point sweep, writes `RX135_SWEEP.csv` |
| `sim\blair\rx135_diagnostics.m` | QUB 400 fidelity check + the 15-cycle convergence runs |
| `sim\blair\RX135_SWEEP.csv` | full result record, all interface fields |

```
cd C:\Users\malliath\Desktop\engine_sim\sim\blair
run_rx135_sweep
rx135_diagnostics
```

The original `port\RX135_INPUT.dat` was not modified and still fails to load on exactly the
seven NOT AVAILABLE fields, as documented in the case notes §2.

---

## 7. Bottom line

**Peak power 9.05 kW at 7500 rpm, 11.53 Nm, BMEP 5.48 bar, BSFC 484 g/kWh, with DR 0.764 /
TE 0.526 / SE 0.824 at peak — from a run whose inlet is a documented proxy and whose port
over-predicts its own reference case by 13.3 % on power.** Bias-corrected that is 7.99 kW, and
the two models then agree to 1 %; so the defensible reading is that the true peak is
8–9 kW at 7500 rpm, above the 0-D model's 7.9 and inside the factory's 8.9–10.4 kW bracket.
The proxy's inflated DR (0.76–0.96 against the 0-D model's 0.53–0.62) and its SE of 0.91 are
the parts of this run I would not defend, and they are the parts that exist only because
Prog.5.1 has no reed valve.
