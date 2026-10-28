# RX135 through the ported Blair simulator (Prog.5.1) — results, **v2**
*After the VOLINC / CDT repair*

**Date:** 2026-10-29
**Deck run:** `sim\blair\RX135_PROXY.dat` — unchanged from v1
**Source deck:** `port\RX135_INPUT.dat`
**Model:** `sim\blair\blair_init.m` → `blair_run.m` (port of Blair, *Basic Design of
Two-Stroke Engines*, ch.5, "engine model No.1"), MATLAB R2026b.
**Sweep:** full throttle (THAR = 1.0), 3000–9000 rpm in 500 rpm steps, 13 points.
**Supersedes:** `RX135_RESULTS.md` (v1, `RX135_SWEEP.csv`). Both v1 files are preserved.

> ## ⚠ WHAT CHANGED, AND WHAT DID NOT
>
> **Changed — one line.** `blair_step.m` line 558 (was 536) now reads
> `VOLINC = CDT*CT1*FTDUCT*DTM*EXPAND/VC1`. Blair's printed line 1108 omits the discharge
> coefficient, so the **volume** accumulator `SR` (→ `SEFF`) and the **mass** accumulator
> `SCRATIO` (→ trapped mass) integrated flows differing by 1/CDT = 1/0.75. This was the real
> defect behind the +25 % SRv error that `CD_INVESTIGATION.md` chased through the Cd question.
> It is switchable: `m.VOLINC_AS_PRINTED = true` restores the printed line for the record.
> Evidence: `SRV_INVESTIGATION.md`, and `QUB400_VALIDATION.md` §1a.
>
> **Not changed — the inlet.** `IPO`/`IPFO`/`WIP`/`RTI`/`RBI` are still the documented QUB 400
> piston-port proxy block (`port\RX135_CASE_NOTES.md` §8). Prog.5.1 has no reed sub-model
> (Blair src 11055–11064). **Every number below still inherits that substitution**, and §5 of
> this report is about exactly that.
>
> Nothing was tuned. The deck, `BEFF` 0.85, `BDEG` 60°, `SCAV$` = SCRE and `TAF` 12.5 are all
> as delivered.

---

## 0. Repair verification

The repair was checked on Blair's own reference case **before** any RX135 number was believed.

| QUB 400 case A, 3000 rpm WOT SCRE, cycle 5 | power kW | BMEP bar | BSFC g/kWh | DR | SE | TE |
|---|---:|---:|---:|---:|---:|---:|
| Blair, Fig.5.9 | 12.20 | 6.14 | 464 | 0.854 | 0.818 | 0.504 |
| port, as printed (v1) | 13.826 | 6.962 | 424.9 | 0.8865 | 0.8877 | 0.5439 |
| **port, repaired (v2)** | **12.534** | **6.311** | **475.8** | **0.8999** | **0.8010** | **0.4915** |
| repaired ÷ published | **1.0274** | 1.0279 | 1.0254 | 1.0537 | 0.9792 | 0.9753 |

The repaired port lands **+2.7 %** on power, against **+13.3 %** before — the 12.5 kW the repair
was predicted to produce, against Blair's 12.2. Mean absolute error across the 16 published
Fig.5.9 quantities falls **8.71 % → 3.44 %**; the `check_qub400` score goes **17/46 → 31/46**
(case A 12/21 → 20/21, case B 5/16 → 9/16, case C 0/7 → 2/7). No case is made worse on its
case mean. The repair is real and it is not a re-fit to case A alone.

---

## 1. Full-throttle sweep, repaired port

| rpm | P raw kW | **P corrected kW** | torque Nm | bmep bar | bsfc g/kWh | DR | TE | SE | pmax bar | tmax K | cv |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|:--:|
| 3000 | 3.409 | **3.318** | 10.85 | 5.162 | 492.8 | 0.733 | 0.513 | 0.723 | 31.14 | 2566 | yes |
| 3500 | 4.669 | **4.544** | 12.74 | 6.059 | 509.1 | 0.889 | 0.491 | 0.810 | 35.29 | 2818 | yes |
| 4000 | 5.580 | **5.432** | 13.32 | 6.336 | 520.7 | 0.951 | 0.478 | 0.836 | 36.46 | 2887 | yes |
| 4500 | 6.177 | **6.012** | 13.11 | 6.234 | 530.3 | 0.953 | 0.471 | 0.826 | 36.26 | 2852 | yes |
| 5000 | 6.749 | **6.569** | 12.89 | 6.130 | 548.3 | 0.969 | 0.455 | 0.826 | 35.83 | 2856 | **no (a)** |
| 5500 | 7.378 | **7.181** | 12.81 | 6.093 | 540.0 | 0.948 | 0.461 | 0.815 | 35.88 | 2861 | yes |
| 6000 | 7.691 | **7.486** | 12.24 | 5.822 | 544.4 | 0.913 | 0.462 | 0.796 | 34.70 | 2811 | yes |
| 6500 | 7.698 | **7.492** | 11.31 | 5.379 | 566.0 | 0.877 | 0.455 | 0.775 | 32.75 | 2745 | yes |
| 7000 | 7.699 | **7.494** | 10.50 | 4.995 | 579.6 | 0.834 | 0.447 | 0.751 | 31.34 | 2709 | yes |
| **7500** | **7.797** | **7.590** | **9.93** | **4.722** | **568.8** | **0.774** | **0.457** | **0.718** | **30.17** | **2613** | **yes** |
| 8000 | 7.655 | **7.451** | 9.14 | 4.346 | 571.3 | 0.716 | 0.459 | 0.678 | 28.69 | 2515 | yes |
| 8500 | 7.377 | **7.180** | 8.29 | 3.942 | 595.5 | 0.676 | 0.446 | 0.645 | 27.03 | 2442 | yes |
| 9000 | 7.022 | **6.834** | 7.45 | 3.543 | 620.2 | 0.633 | 0.434 | 0.613 | 25.54 | 2386 | yes |

`P corrected` is defined in §2. Torque is derived: `T = P·1000/(2π·rpm/60)`, from the **raw**
power (the bias factor is not applied to the torque column, to avoid mixing conventions —
corrected torques are in §2).

### Supporting values at peak (7500 rpm, raw)

IMEP 5.375 bar, PMEP 0.278 bar, FMEP 0.375 bar, CE 0.353, SRv 0.872, SRmass 0.820, exhaust
flow ratio 0.820, peak-pressure angle 16.5° ATDC, 5 cycles. Fuel flow at `TAF` 12.5 is
4.44 kg/h — consistent with DR 0.774 on 132.1 cm³ at 7500 rpm.

### (a) The one flagged point: 5000 rpm

5000 rpm is the only point that did not meet the harness's 1 %/cycle test at the 5-cycle floor.
It is a **startup transient, not a limit cycle**:

| cycle | DR | TE | SE | BMEP bar | P kW |
|---:|---:|---:|---:|---:|---:|
| 3 | 0.9442 | 0.4242 | 0.8203 | 6.058 | 6.669 |
| 4 | 0.9794 | 0.4722 | 0.8273 | 6.198 | 6.823 |
| 5 | 0.9685 | 0.4547 | 0.8257 | 6.130 | 6.749 |
| 6 | 0.9741 | 0.4603 | 0.8270 | 6.199 | 6.824 |
| 7 | 0.9714 | 0.4582 | 0.8262 | 6.144 | 6.764 |

It converges by cycle 7 (last-cycle ΔP 0.89 %, ΔDR 0.29 %); cycle 7 differs from cycle 5 by
**0.22 %**. The reported value 6.749 kW is therefore good to ~0.2 %. **This is the only flagged
point in the sweep.** The v1 ±1.3 % limit cycle at 9000 rpm has **disappeared** — all twelve
other points now settle inside 5 cycles.

### (b) Peak location is now a real peak, not a grid coincidence

v1 flagged that its 7500 rpm peak beat 8000 rpm by 0.06 %, i.e. a plateau. That objection is
gone: 7500 is **+1.3 % over 7000** and **+1.9 % over 8000**, with a genuine local maximum at
7500 on either side. The 6500–7000 pair (7.698 / 7.699) is still a flat shelf, but the peak
itself is resolved.

---

## 2. Bias correction — one point, borrowed from another engine

**Read this before quoting the corrected column.**

The port over-predicts power on Blair's QUB 400 case A by **2.7 %** (12.534 vs 12.20 kW). The
corrected column is simply

```
P_corrected = P_raw / 1.0274        (and  BMEP_corrected = BMEP_raw / 1.0279)
```

**This is a one-point calibration, and it is borrowed from a different engine.** It is:

- **one point** — a single operating condition (3000 rpm, WOT, SCRE, one scavenging model) of a
  single reference engine;
- **a different engine** — QUB 400 is an 85 × 70 mm, 397 cm³, piston-ported, loop-scavenged
  research single with a tuned 90 mm transfer duct and an empty box. The RX135 is a 132 cm³
  reed-valve street engine at 7500 rpm;
- **not a correction for this engine's errors.** It removes the port's *global* bias only. It
  cannot remove the proxy-inlet error, which is RX135-specific and much larger (see §5);
- **applied at a fixed factor across the whole speed range**, although the residual error at
  3000 rpm (2.7 %) is not measured at 7500 rpm.

At 2.7 % the correction is almost cosmetic — it moves the peak from 7.797 to 7.590 kW. That is
the point: after the repair, **the raw number is close enough that the correction barely
matters**, and the honest uncertainty is in the inlet proxy, not in the bias.

Corrected torques: 10.56, 12.40, 12.97, 12.76, 12.55, 12.47, 11.91, 11.01, 10.22, **9.66**,
8.89, 8.07, 7.25 Nm at 3000→9000.

### v1 → v2: what the repair did to the RX135

| | v1 (as printed) | v2 (repaired) | change |
|---|---:|---:|---:|
| Peak power | 9.052 kW @ 7500 | **7.797 kW @ 7500** | **−13.9 %** |
| Peak BMEP | 5.48 bar | 4.72 bar | −13.9 % |
| BMEP at peak, corrected | 4.84 | 4.59 | — |
| DR at peak | 0.764 | 0.774 | **+1.3 %** |
| TE at peak | 0.526 | 0.457 | −13.1 % |
| SE at peak | 0.824 | 0.718 | −12.9 % |
| BSFC at peak | 484 | 569 | **+17.5 %** |
| Tmax max | 3104 K | 2887 K | −7.0 % |

**The power loss came from TE and SE, not from DR.** Delivery ratio is essentially unchanged
(+1–2 % at every speed) — as it must be, because DR is set by crankcase delivery through the
proxy inlet, which the repair does not touch. What the repair changed is the *relation between
delivered and trapped charge*: `SEFF = 1 − exp(MSC·SR + CSC)` is a function of the volume
scavenge ratio `SRv`, which fell by exactly the 0.75 that was missing. The model no longer
claims near-perfect displacement scavenging, so less of the delivered charge is trapped, and
power falls 14 %.

---

## 3. Comparison

### 3.1 Side by side

| Quantity | 0-D model | **Blair port v2 (proxy inlet)** | v1 (as printed) | Factory | Blair's band |
|---|---|---|---:|---|---|
| Peak power, raw | 7.9 kW @ 7500 | **7.797 kW @ 7500** | 9.05 kW @ 7500 | 10.4 kW @ 7500 (5-sp); 8.9 kW @ 6500 (4-sp) | — |
| Peak power, bias-corrected | — | **7.590 kW** | 7.99 kW | — | — |
| Peak torque | — | **13.32 Nm @ 4000** | 14.52 Nm @ 4000 | — | — |
| BMEP at peak | 4.2–4.8 bar | **4.72 bar** (4.59 corr.) | 5.48 | 6.30 (implied by 10.4 kW) | **4–9** ✓ |
| BSFC at peak | — | **569 g/kWh** | 484 | ≈405 (implied) | **300–500 ✗** |
| DR range | 0.53–0.62 | **0.63–0.97** | 0.63–0.96 | — | — |
| DR at peak | ≈0.58 | **0.774** | 0.764 | — | — |
| SE range | 0.77–0.80 | **0.61–0.84** | 0.74–0.91 | — | — |
| SE at peak | ≈0.78 | **0.718** | 0.824 | — | — |
| Peak-speed location | 7500 | **7500** (real peak) | 7500 (≡8000) | 7500 | — |
| Road: top of 4th | — | **7.24 kW raw / 7.04 corr. at 8700** | 8.79 | 8700 rpm @ 120 km/h | — |

Factory figures from `RX135_5S_VERIFIED_PARAMETERS.md` §11: 10.4 kW @ 7500 for the 5-speed
`4TL10`; 12 PS (8.9 kW) @ 6500 for the 4-speed. Our build is the 5-speed cylinder with the
4-speed pipe and carb, so the honest factory bracket is **8.9–10.4 kW**.

### 3.2 Against the 0-D model

**Power now agrees, and it agrees without correction.** 7.797 raw vs 7.9 kW is −1.3 %;
bias-corrected 7.590 is −3.9 %. Either way the two models are now within one model's
uncertainty. In v1 the agreement only appeared *after* dividing 9.05 by 1.133; now the
uncorrected port and the 0-D model land on the same number.

**BMEP now agrees.** 4.72 bar at peak (4.59 corrected) sits inside the 0-D model's 4.2–4.8 band
and inside Blair's 4–9 band. In v1 it was 5.48, above the 0-D range.

**Peak speed agrees.** Both put it at 7500 rpm, and — unlike v1 — the port's peak is a real
maximum rather than a plateau tie.

**DR still does not agree, and this is the important caveat.** 0.63–0.97 against 0.53–0.62.
At peak the port delivers 0.774 against the 0-D model's ≈0.58, i.e. **+33 %**. At 5000 rpm it
delivers 0.969, **+56 %** against the top of the 0-D range.

**So the power agreement is again a cancellation, not a convergence of physics.** The port
traps a smaller fraction of a larger delivered charge (DR 0.774 × TE 0.457 → SE 0.718); the 0-D
model traps a larger fraction of a smaller charge (DR ≈0.58 × high TE → SE ≈0.78). Two
different mechanisms, one answer. **Do not read 7.8 vs 7.9 kW as independent corroboration
until the trapped mass is right, and the trapped mass depends on the inlet.**

**SE now nearly agrees.** 0.718 vs ≈0.78 is the closest the two models have come on any
efficiency. That is the repair's main qualitative gain: v1's SE of 0.824 rising to 0.907 was
uniflow-class and indefensible for a loop-scavenged cylinder with a 45× damper box; 0.72–0.84
is a number this port layout could plausibly produce.

### 3.3 Against the road observation (~8700 rpm at 120 km/h in 4th)

Interpolating between 8500 and 9000 rpm: **7.24 kW raw / 7.04 kW corrected at 8700 rpm**, which
is **92.8 % of peak**. The model is therefore *consistent* with the observation — a bike can
hold 8700 rpm in 4th at 120 km/h while peaking at 7500, because the power only falls 7 % over
that 1200 rpm — but it does **not** place the power peak at 8700. v1 held 97 % there; v2 holds
93 %. The top end now falls away at a more believable rate, closer to what a non-tuned box
should do with 185.7° exhaust duration.

The reading is unchanged from v1: the road figure is a **top-speed-in-gear observation, set by
road load, not by the power peak**. It constrains the power *at* 8700 rpm (≈7 kW), not the
location of the maximum. `ps5`'s inference of an 8650–8850 rpm power peak is **not supported**
by either model.

### 3.4 Against Blair's bands

| Band | Range | v2 result | Verdict |
|---|---|---|---|
| BMEP | 4–9 bar | 3.54–6.34 bar over the sweep; 4.72 at peak | **inside throughout** ✓ |
| BSFC | 300–500 g/kWh | 493–620 g/kWh | **outside at 12 of 13 points** ✗ |

BMEP is now clean: every point from 3000 to 8000 rpm sits in 4.3–6.3 bar, and only 8500 and 9000
fall below 4 bar (3.94, 3.54) — normal for the top end of a broad-curve engine.

**BSFC is the repair's cost, and it is a genuine flag.** v1 ran 430–497 g/kWh, i.e. inside the
band but pinned at the inefficient end. v2 runs 493 g/kWh at 3000 rpm, rising broadly to
**620 g/kWh at 9000** with local dips at 5500 (540) and 7500 (569), and is above Blair's
500 g/kWh ceiling at every point except 3000 rpm.
The cause is direct: `BSFC ≈ const/(CE·TE)`, and TE fell from 0.526 to 0.457 at peak while CE
fell from 0.402 to 0.353. The model is now describing an engine that discards **54 % of the
charge it traps** at its power peak (TE 0.457).

Two things follow. First, this is the price of the repair: the scavenging model was previously
flattered, and correcting it exposes a low trapping efficiency. Second, BSFC here is **not
independent evidence** — `TAF` fixes AFR at exactly 12.5 by construction, so BSFC is just
1/(CE·TE) times a constant and carries no information the efficiencies do not already carry.
The QUB 400 calibration shows the same direction: its BSFC moved 424.9 → 475.8 g/kWh against a
published 464, i.e. from 8 % *under* to 2.5 % *over*. The RX135's 569 sits on the same side.

---

## 4. What this model now predicts for the RX135

**It predicts an engine of about 7.8 kW at 7500 rpm, and it says so without a correction
factor.**

That is the plain statement. Concretely, at full throttle:

- **Peak power 7.8 kW (7.6 kW bias-corrected) at 7500 rpm**, 9.9 Nm, BMEP 4.72 bar.
- **A broad, flat top end.** 7.69 kW at 6000, 7.80 at 7500, 7.66 at 8000 — within ±2 % over
  2000 rpm. 93 % of peak is still available at 8700 rpm.
- **Peak torque 13.3 Nm at 4000 rpm**, falling 25 % by 7500 and 44 % by 9000. A low-speed-biased
  torque curve, consistent with 185.7° exhaust / 131° transfer timing and a non-tuned box.
- **BMEP 4.7 bar at peak**, inside Blair's 4–9 band and inside the 0-D model's 4.2–4.8.
- **Efficiencies at peak: DR 0.774, TE 0.457, SE 0.718, CE 0.353.** Delivery ratio is high,
  trapping efficiency is mediocre, scavenging efficiency is plausible-but-unspectacular.
- **BSFC 569 g/kWh at peak**, above Blair's 500 ceiling.

Against the factory bracket of 8.9–10.4 kW for this build, the model is **12–25 % low**. Against
the 0-D model's 7.9 kW it is **within 1.3 %**. Against the road observation it is consistent:
≈7 kW available at 8700 rpm is enough for 120 km/h in 4th on a light 135.

---

## 5. What this model cannot predict, and why

**The inlet is still a proxy piston-port block, not a reed valve.** `IPO` = 60° BTDC,
`IPFO` = 0° ATDC, `WIP` = 40.2 mm, `RTI` = `RBI` = 0 — a 600 mm² rectangular window that is
**fully open at TDC**, when crankcase depression peaks, and that never closes against reverse
flow. A reed valve is a pressure-driven one-way valve with mass, stiffness, a seat, a stop
plate and a natural frequency. It is a fundamentally different boundary condition. This model
therefore **cannot**:

1. **Predict the crankcase pressure trace.** Nothing in the model represents reed dynamics, so
   the depression that actually drives delivery is not computed — it is assumed, through a
   fixed window.
2. **Predict reversion.** A reed shuts when the crankcase pressure exceeds the inlet pressure.
   The proxy hole stays open and lets charge back out of the crankcase. This is why DR is
   **0.63–0.97**, and why it is highest (0.969) at 5000 rpm where the proxy window is open
   longest per cycle. **The DR range is the least trustworthy output in this report.** The 0-D
   model says 0.53–0.62; the truth is probably between, near 0.65–0.75 at peak.
3. **Predict the reed's high-speed limit.** Reeds stop following the pressure signal at high
   rpm — they float and effectively reduce open area. The proxy has no such failure mode, which
   is part of why the model's top end is flatter than a real reed engine's.
4. **Predict inlet-tract or airbox tuning.** `LIP` = 90 mm is an unmeasured estimate and the
   airbox is absent. Any inlet resonance at 6000–8000 rpm is unrepresented.
5. **Predict part-throttle behaviour at all.** At part throttle the reed and the slide
   interact; a piston-port proxy with a throttle area ratio cannot reproduce that. Every number
   here is WOT.
6. **Place the power peak with confidence.** Because DR is set by an idealised hole, the
   *location* of the peak is weakly determined even though its *height* now looks reasonable.
   Treat 7500 rpm as "consistent with the factory rating", not as a prediction.
7. **Say anything about combustion phasing or detonation.** `BDEG` = 60° fixes heat release to
   start ~10° BTDC at every speed; the measured 19.5° BTDC static advance cannot be entered.
   Peak-pressure angle stays 16.5° ATDC by construction. Any conclusion about ignition timing
   or knock margin is void.
8. **Be trusted on BSFC.** With `TAF` fixing AFR at 12.5, BSFC is a restatement of CE and TE,
   not an independent prediction.

**What it can now be used for, with care:** the absolute power magnitude at WOT to roughly
±5 % *if* the proxy inlet happens to be a fair area match (it is an area match — 600 mm² seat —
but not a timing or directionality match); the shape of the torque curve; BMEP in the right
band; and the relative effect of geometry changes, since those enter the model the same way
they enter reality.

**What would settle it:** a reed-valve sub-model (Blair's Prog.5.2 / the 1996 book's reed
treatment, absent from Prog.5.1), or a measured crankcase pressure trace plus a measured reed
lift. Until one of those exists, **DR — and therefore the split between delivered and trapped
charge — is assumption, not result.**

---

## 6. Convergence flags

| Point | Status | Cause | Disposition |
|---|---|---|---|
| 5000 rpm | **flagged** | startup transient; needed 7 cycles to pass the 1 %/cycle test, not 5 | value good to 0.2 %; no action |
| all other 12 | converged | settled inside the 5-cycle floor | — |

- **No point errored and no point failed to return.** 13/13 returned.
- **The v1 limit cycle at 9000 rpm is gone.** v1 oscillated ±1.3 % over a two-cycle period and
  drifted 2.35 % from cycle 5 to 15; v2's 9000 rpm point converges inside the 5-cycle floor.
  The oscillation was a symptom of the `SR`/`SCRATIO` mismatch feeding back through `SEFF`, and
  removing it removed the instability.
- The 5000 rpm transient is the same mechanism in the other direction: `SRv` is largest there
  (proxy window open widest), so `SEFF` has furthest to travel from its initial value, and the
  fixed-point iteration takes two extra cycles.

---

## 7. Reproducing

| File | What it does |
|---|---|
| `sim\blair\RX135_PROXY.dat` | the deck as run (unchanged from v1) |
| `sim\blair\blair_step.m` | **repaired**: line 558 carries `CDT`; `m.VOLINC_AS_PRINTED = true` restores Blair's printed line 1108 |
| `sim\blair\run_rx135_sweep_v2.m` | the 13-point sweep + convergence forensics, writes `RX135_SWEEP_v2.csv` |
| `sim\blair\rx135_v2_calib.m` | the QUB 400 case A calibration, writes `rx135_v2_calib.txt` |
| `sim\blair\rx135_v2_check.m` | post-repair validation score + peak detail, writes `rx135_v2_check.txt` |
| `sim\blair\RX135_SWEEP_v2.csv` | full v2 result record, all interface fields |
| `sim\blair\SRV_INVESTIGATION.md` | why the VOLINC line is wrong and what the evidence is |
| `sim\blair\QUB400_VALIDATION.md` §1a | the repair's effect on the validation score |

```
cd C:\Users\malliath\Desktop\engine_sim\sim\blair
rx135_v2_calib      % 12.534 kW vs Blair 12.20 -> factor 1.0274
run_rx135_sweep_v2  % 13 points, writes RX135_SWEEP_v2.csv
rx135_v2_check      % validation score + bias-corrected table
```

`port\RX135_INPUT.dat` was not modified and still fails to load on exactly the seven NOT
AVAILABLE fields. v1 artefacts (`RX135_RESULTS.md`, `RX135_SWEEP.csv`) are preserved unaltered.

---

## 8. Bottom line

**Peak power 7.797 kW at 7500 rpm (7.590 kW bias-corrected), 9.93 Nm, BMEP 4.72 bar,
BSFC 569 g/kWh, with DR 0.774 / TE 0.457 / SE 0.718 at peak** — from a repaired port that now
reproduces its own reference case to +2.7 % on power and 3.44 % mean error, and from a run whose
inlet is still a documented piston-port proxy for a reed valve it cannot model.

The repair moved the RX135 down **13.9 %**, from 9.05 to 7.80 kW, and that movement came almost
entirely out of **SE and TE** (0.824 → 0.718, 0.526 → 0.457) while **DR stayed put** (0.764 →
0.774). That is the correct signature: the repair fixed the bookkeeping between the volume and
mass accumulators, not the inlet.

The result is that **the port and the 0-D model now agree on peak power (7.8 vs 7.9 kW), on
BMEP (4.7 vs 4.2–4.8 bar) and on peak speed (7500), and still disagree on delivery ratio
(0.77 vs 0.58 at peak).** The power agreement is a cancellation between a high-DR/low-TE model
and a low-DR/high-TE one, so it is *encouraging* but not independent confirmation; the physics
will not be settled until the inlet stops being a hole where a reed should be. Against the bike,
the model is consistent — it leaves ~7 kW at 8700 rpm, 93 % of peak, which is enough for
120 km/h in 4th — but it puts the peak at 7500 rpm, not 8700, and the factory rating agrees with
the model on that. The number I would defend is **7.8 ± 0.4 kW at 7500 rpm**; the number I would
not defend is the **DR of 0.63–0.97**, or the **BSFC of 569–620 g/kWh**.
