# RX135 — 5-speed cylinder with 4-speed absorptive exhaust

**Build modelled:** 4TL10 cylinder/head, 4-speed stock straight-through absorptive silencer.
This is **not** a stock 5-speed (catalytic silencer) and **not** a stock 4-speed.
Run date 2026-10-28. Every number below comes from a run in this session.

---

## 1. What changed from the previous state

| Item | Was | Now | Source |
|---|---|---|---|
| Friction | 1.30 Nm (0.618 bar) | **0.828 Nm (0.394 bar)** at 7500, linear in speed | Blair Eq. 5.4.2, "motorcycles, etc.": fmep = 105·Lst·N |
| Exhaust | wave ladder / lumped stub | **35 mm perforated core + five side-branch chambers** | measured on the bike |
| Ignition | flat 19.5° | **19.5 / 18 / 15 / 13° @ 3k/5k/6.5k/8k**, interpolated | ASSUMED, typical CDI retard |
| Squish | absent | **1.5 mm** | ASSUMED, Blair model input |
| Rod | 98 mm | **98 mm, ASSUMED** | community; Blair's comparable 125 uses 110 |
| Crankcase | 385 cc, CR 1.34 | unchanged | Blair reference 1.35 |
| Ports | factory map | unchanged, 185.66° / 131.25° | accepted by road test |

The friction correction **removes** 0.472 Nm: it moves the model *away* from any power anchor, which is the honest direction.

## 2. Exhaust model

- Core: 35 mm ID, 1275 mm piston face → outlet, constant area.
- Five baffle chambers attached as side branches at their measured axial positions, coupled through the perforation area (5 % open, Cd 0.60).
- Outlet: 787 mm² (Ø35 minus a 5 mm bridge = 31.7 mm equivalent).
- Wall friction (Cf 0.004 → Darcy 0.016) and wall heat transfer (Nu = Cf·Re/2, Tw = 450 °C) both active.

Chamber resonance 0.9–1.8 kHz against 108–125 Hz firing: the plates are damping, not tuning. That is now a modelled outcome, not an assumption — see §4.

## 3. Well-posedness (acceptance test for the solver)

| variation | P_b | p_trap |
|---|---|---|
| Nc 20 | 10295 | 1.185 |
| Nc 40 | 10228 | 1.188 |
| Nc 80 | 10135 | 1.184 |
| dt 0.125° | 10090 | 1.146 |
| dt 0.25° | 10228 | 1.188 |
| dt 0.5° | 10269 | 1.137 |

**Spread over Nc: 1.6 %. Over dt: 1.8 %.** Both inside the 2 % requirement. **Single-valued: no two-mode behaviour at any setting.** Mass balance closes to **−1.6e−14** of intake; convergence in 9 cycles at 1e−4.

The blocker from the previous session is resolved: the wave ladder is gone and the model is now grid-independent.

## 4. Uncalibrated torque curve — 5-speed porting (185.66°)

| rpm | P_b [W] | T_b [Nm] | BMEP | DR | SE | BSFC |
|---|---|---|---|---|---|---|
| 2000 | 2376 | 11.34 | 5.39 | 1.251 | 0.889 | 788 |
| 2500 | 3208 | 12.25 | 5.83 | 1.192 | 0.875 | 695 |
| 3000 | 4685 | 14.91 | 7.09 | 1.249 | 0.888 | 598 |
| 3500 | 5371 | 14.65 | 6.97 | 1.235 | 0.885 | 602 |
| 4000 | 6612 | 15.79 | 7.51 | 1.393 | 0.916 | 631 |
| 4500 | 6911 | 14.66 | 6.97 | 1.339 | 0.907 | 652 |
| 5000 | 7641 | 14.59 | 6.94 | 1.260 | 0.891 | 617 |
| 5500 | 8371 | 14.53 | 6.91 | 1.233 | 0.884 | 606 |
| 6000 | 8606 | 13.70 | 6.51 | 1.189 | 0.874 | 620 |
| 6500 | 9275 | 13.63 | 6.48 | 1.104 | 0.851 | 579 |
| 7000 | 9910 | 13.52 | 6.43 | 1.083 | 0.844 | 572 |
| 7500 | 10228 | 13.02 | 6.19 | 0.915 | 0.782 | 502 |
| 8000 | 10610 | 12.66 | 6.02 | 0.822 | 0.737 | 464 |
| 8500 | 10503 | 11.80 | 5.61 | 0.813 | 0.733 | 492 |
| 9000 | 10723 | 11.38 | — | — | — | — |

**Peak power 10 723 W @ 9000 rpm. Peak torque 15.79 Nm @ 4000 rpm.** There is no power peak below 9000.

## 5. Uncalibrated torque curve — 4-speed porting (157.0°)

| rpm | P_b [W] | T_b [Nm] | DR | p_trap |
|---|---|---|---|---|
| 3500 | 5748 | 15.68 | 1.284 | 1.509 |
| 4000 | 6261 | 14.95 | 1.386 | 1.393 |
| 4500 | 6729 | 14.28 | 1.197 | 1.334 |
| 5000 | 7616 | 14.55 | 1.124 | 1.384 |
| 5500 | 8260 | 14.34 | 1.060 | 1.383 |
| 6000 | 8815 | 14.03 | 0.991 | 1.372 |
| 6500 | 9046 | 13.29 | 0.839 | 1.366 |
| 7000 | 9538 | 13.01 | 0.775 | 1.378 |
| 7500 | 9885 | 12.59 | 0.659 | 1.442 |
| 8000 | 10211 | 12.19 | — | — |
| 9000 | 11208 | 11.89 | — | — |
| 9500 | 11021 | 11.08 | — | — |

**Peak power 11 208 W @ 9000 rpm.**

## 6. The peak-shift validation — **FAILED, and the reason matters**

Prediction: `peak_5s / peak_4s = 185.7 / 157.5 = 1.179`, i.e. the 4 s should peak ~18 % lower.

| | measured in model |
|---|---|
| 5 s peak | 10 723 W @ 9000 rpm |
| 4 s peak | 11 208 W @ 9000 rpm |
| ratio | **0.957** (predicted 1.179) |

**The model reproduces no shift at all**; both variants peak at the same speed, and the 4 s porting makes slightly *more* power, not less.

**Diagnosis, measured not asserted:** switching the pipe off entirely gives **10 695 W at 7500**, against **10 228 W with it fitted — the pipe costs 4.4 %.** An absorptive silencer has no baffle cone, so there is no positive return pulse; it cannot supercharge at any speed. With no tuning mechanism there is nothing to shift, so the 1.179 prediction — which is a *tuned expansion chamber* relation — does not apply to this hardware.

The 4 s porting makes more power simply because the exhaust closes earlier (157° vs 186°), trapping a larger fraction of the charge. Compression ratio, not pipe tuning.

This is a real finding about the build: **with this silencer the 5 s cylinder has no tuned peak.** Its power rises monotonically to 9000 rpm, which is not what a road 2-stroke does and is not what the bike does on the road (it pulls to 7500).

## 7. Sanity bands — all reported, none excused

| Criterion | Required | 5 s @ 7500 | Verdict |
|---|---|---|---|
| BMEP at peak | 4–9 bar | 6.19 (range 5.4–7.5) | ✅ |
| BSFC | 300–500 g/kWh | **502** (464–788 across the range) | ❌ |
| Delivery ratio | 0.5–1.0 | **0.915** at 7500; **1.08–1.39 below 7000** | ❌ |
| Trapped pressure | 1.1–1.6 bar | **1.188** (4 s: 1.44) | ✅ |
| SE at exhaust close | >0.6 | **0.782** (0.73–0.92) | ✅ |
| Peak power | any, but state implication | 10.7 kW @ 9000 | see below |

**Three of six pass.** The two failures are one error: the model delivers more charge than the cylinder can use at low and mid speed (DR up to 1.39, BSFC 600–790 g/kWh). This is the same oversize-port signature established earlier — transfer width ratio Cpb = 1.95 against Blair's practical limit of 1.25, and +81 % transfer time-area.

**What the peak power implies:** 10.7 kW is very close to the stock 5-speed's 10.4 kW, but at **9000 rpm instead of 7500**. Read correctly, the model says this build makes the right power at the wrong speed — consistent with a cylinder built for a tuned chamber being fed by a silencer that cannot deliver one. It does **not** validate the model against the 10.4 kW anchor, which belongs to a different exhaust.

## 8. Assumptions carried

- Rod 98 mm (community; unverified).
- Squish 1.5 mm (Blair placeholder; no effect in a 0-D model).
- Ignition curve 19.5/18/15/13° (typical CDI retard; not measured).
- Crankcase 385 cc, CR 1.34 (Blair reference 1.35; not measured).
- Reed 600 mm², Cd 0.70, cracking 500 Pa.
- Perforation 5 % open, Cd 0.60.
- Combustion efficiency 0.95 (Heywood 0.95–0.98).
- AFR 12.5, DR reference 1.18 kg/m³.
- Scavenging: Blair Benson–Brandham, break point SR_pd = 0.5.

## 9. What this model can and cannot predict

**Can:**
- Compare exhaust systems on the same cylinder (it correctly prices the absorptive silencer as a net loss).
- Compare port timings on the same pipe (it shows the 4 s timing traps more charge).
- Show trends in trapped pressure, delivery ratio and scavenging efficiency.
- Reproduce the port geometry and its time-area to the factory map.

**Cannot:**
- Predict the power peak of this build. With no tuned pipe there is no peak in the model below 9000 rpm, and the bike pulls to 7500. **The single biggest gap is that the model has no high-speed breathing limit** — DR falls too slowly, so power keeps climbing.
- Predict absolute power to better than the DR/BSFC failures in §7, which say the port flow is ~40 % too generous.
- Validate against 10.4 kW: that anchor belongs to a catalytic-silencer bike.

## 10. What would close the gap

1. **Measure the actual peak power and speed of this build** (one dyno pull). Everything downstream is guesswork without it.
2. **Measure the transfer widths** (barrel off, 30 min). Cpb = 1.95 is over the mechanical limit and is the likely cause of DR > 1 and BSFC > 600.
3. Only then consider whether the pipe needs a reflecting element — but the measurement in §6 says the silencer is absorptive, so a tuned peak may simply not exist on this bike.
