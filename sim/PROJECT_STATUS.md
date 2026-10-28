# RX135 project — status and handoff

> **2026-10-28, revision 2.** The model has been reworked. Read `FINAL_REPORT_v2.md` and
> `audit\AUDIT_REPORT_v2.md` first; §6 below (model status) is superseded. The main change:
> delivery ratio was ~2x too high because the carburettor was not in the model, the reed had
> no lift law, and the fresh-charge species was never advected. DR is now 0.53-0.62 at
> 6000-8500 rpm, SE 0.77-0.80, BSFC 432-464 g/kWh. Peak power is 7.9 kW at 7500 rpm and the
> curve is flat to 8700.

**Date:** 2026-10-28
**Configuration being modelled:** RX135 **5-speed cylinder (4TL10)** with the **4-speed exhaust** fitted.
This is *not* a stock 5-speed (which came with the catalytic silencer) and not a stock 4-speed.
**Read this file first.** It supersedes `RX135_5S_VERIFIED_PARAMETERS.md` §8 (exhaust);
everything else in that file stands.

---

## 1. Where we are

| Deliverable | State |
|---|---|
| Verified parameter set | ✅ done, checked against Blair / Heywood / factory documents |
| Port geometry (`A(θ)`, timing, areas) | ✅ done, gate passes 5/5 |
| Parametric model (`params.m`) | ✅ 24/24 self-checks pass |
| Cycle model (`engine_model.m`) | ⚠ runs, but the wave-pipe solver is not viable — replaced by a lumped stub |
| Calibration | ⛔ blocked: the anchor does not describe this build |
| Pipe design (if a chamber is ever built) | ✅ spec written, Blair-based |
| Stock exhaust model | ⬜ waiting on one measurement — the outlet bore |

**Key decision taken:** accept the factory 5-speed port map as correct. This was settled
empirically (see §5), not by argument.

---

## 2. Configuration and anchors

| | Value | Source |
|---|---|---|
| Cylinder | 5-speed `4TL10` | factory |
| Head | **5-speed `09L`** → CR 10.1, chamber 15.9 cc | factory |
| Carburettor | **4-speed VM22**, main 165, pilot 17.5, needle 4J26 | factory |
| Exhaust | 4-speed stock absorptive, measured (see §4) | user measurement |
| Gearbox | **4-speed** — 3.182 / 2.000 / 1.368 / 1.000, final 16/34 | factory |
| Observed top speed | **~120 km/h "barely touched"** | user road test |
| Rated power (stock 5s, cat-con) | 10.4 kW @ 7500 rpm | owner's manual |
| Rated torque (stock 5s) | 12.26 Nm @ 7000 rpm | owner's manual |
| Rated power (stock 4s) | 8.9 kW (12 PS) @ 6500 rpm | Yamaha archive |

This is a **hybrid build**: 5-speed top end, 4-speed induction / exhaust / gearbox. It is
neither a stock 4-speed nor a stock 5-speed, so no factory power figure applies directly.

---

## 3. Engine data (verified)

### Geometry
| Parameter | Value | Tag |
|---|---|---|
| Bore × stroke | 58.0 × 50.0 mm | factory |
| Displacement | 132.10 cc | derived |
| Connecting rod | 98 mm | **unverified** (community; no manual) |
| Deck clearance | 0.8 mm | derived from factory porting drawing |
| Piston area | 2642 mm² | derived |

### Compression
| Parameter | Value | Tag |
|---|---|---|
| Geometric CR | 10.1 : 1 (factory service action: 10.0) | factory |
| Bare head volume | 15.9 cc | factory |
| Effective clearance volume | 14.52 cc | derived |
| **Trapped CR** | **5.91** | derived (exhaust closes 27 mm down) |

### Ports — **CONFIRMED against the user's cylinder**
The port map matches the barrel in the bike. This is no longer a drawing or an assumption —
it is ground truth for this engine.

| Parameter | Value |
|---|---|
| Exhaust | 39 × 23 mm, top 27.0 mm below TDC, opens **92.83° BBDC**, **185.66°** duration |
| Exhaust full-open area | 842 mm² (0.319 × piston) |
| Transfers | 5 windows 25/19/25/19/25 mm, tops 38.0 mm below TDC, open **65.63° BBDC**, **131.25°** |
| Transfer max exposed area | **1294 mm²** (window sum 1362; 3 mm of the centre window never uncovered) |
| Blowdown | 27.2° |
| Time–area | exhaust 103 038, blowdown 5 653, transfers 112 880 mm²·deg |

### Induction
**4-speed carburettor: VM22** (22 mm venturi, ~380 mm²); main **165**; pilot **17.5**;
needle **4J26**; nozzle **0-8 (788)**; cutaway 2.0; reed valve `2YA-E3610-00-00`.
*(The 5-speed's VM20 with 135 / 15 / 5ZF6 / 0-3 does not apply to this build.)*
Reed model: 600 mm², Cd 0.70, cracking 500 Pa — **all assumed**.

### Ignition
Static **19.5° BTDC** (factory). CDI `1L7.30.02.00`. Plug NGK BPR7HS, gap **0.6–0.7 mm**.
Advance curve above idle: **not found** — a typical CDI retard is used as placeholder.

### Drivetrain
Primary 19/74; gears 3.182 / 2.000 / 1.368 / 1.091 / 0.917; final 15/38; dry mass 108 kg;
tyres 2.75-18 / 3.00-18; wheelbase 1245 mm.

### Friction — corrected this session
```
Blair Eq. 5.4.2 ("motorcycles, etc."):  fmep = 105 · Lst · N
at 7500 rpm: 0.394 bar  ->  0.828 Nm
```
The model previously used 1.30 Nm (0.618 bar) — **57 % too high**, and it was sitting between
Blair's industrial and plain-bearing lines, which do not apply. Correction approved.

---

## 4. Exhaust — measured (4-speed stock pipe)

| Part | Dimension | Volume |
|---|---|---|
| Header (bend pipe) | 390 mm long, **46 mm ID** (50 mm OD) | 0.65 L |
| Front cone | 240 mm, 46 → 96 mm ID | 0.99 L |
| Can | 600 mm long, **96 mm ID** (100 mm OD) | 4.34 L |
| **Perforated core** | **Ø35 mm, 420 mm long**, ~8 mm holes, solid bands at 25 mm (end) and 50 mm (mid) | 0.40 L |
| **Outlet** | **Ø35 mm, with a ~5 mm flat bridge bar across it** | ~787 mm² free |
| **Total** | **1230 mm** (+ ~45 mm port depth → LT ≈ **1275 mm**) | — |

Internal can sections (from the annotated photo): **140 / 100 / 90 / 70 / 200 mm** — these
are **baffle plates** with a central hole, and the perforated core passes through them.
So the annulus is divided into **five separate chambers**:

| Chamber | Length | Annulus volume |
|---|---|---|
| 1 | 140 mm | 879 cc |
| 2 | 100 mm | 628 cc |
| 3 | 90 mm | 565 cc |
| 4 | 70 mm | 439 cc |
| 5 | 200 mm | 1255 cc |
| **Total annulus** | 600 mm | **3766 cc** |
| Plus core bore (35 mm × 420 mm) | | 404 cc |
| **Total gas volume** | | **≈ 4.17 L** |

**Acoustic role of the chambers.** Each chamber is a side-branch resonator coupled to the
core through the perforations. Because both the coupling area and the volume scale with
section length, **all five resonate at the same frequency** — 0.9 kHz at 5 % open area,
1.3 kHz at 10 %, up to 1.8 kHz at 20 %. The firing frequency is 108 Hz (6500 rpm) and
125 Hz (7500 rpm), an order of magnitude below.

So the plates are a **distributed high-frequency absorber** (hiss and mechanical noise),
not a low-frequency tuning element. Their effect on the engine is damping, not tuning.

**This is an absorption silencer, not a plenum.** The annulus between the 35 mm
core and the 96 mm can is packed (visible in the tail photo), so it is not a free
acoustic volume. **The gas path is the 35 mm core.**

Effective outlet: 35 mm circle minus a 5 mm bridge = **787 mm² ≈ 31.7 mm equivalent**,
which is almost exactly the exhaust port's equivalent diameter (32.7 mm). The outlet
is deliberately matched to the port.

**Corrected characterisation (supersedes the earlier "5.98 L compliance" note):**

| | Earlier (wrong) | Corrected |
|---|---|---|
| Model | 5.98 L lumped volume | **35 mm pipe, ~1275 mm long, distributed absorption** |
| Quarter-wave | — | 542/(4×1.275) = **6380 rpm** |
| Blair with 5s porting | — | **~7500 rpm** |

The quarter-wave figure matches the 4-speed's 6500 rpm rating, and Blair's
tuned-length with the 5-speed's 186° exhaust matches the 7500 rpm the bike actually
pulls. Both agree with observation, which the plenum model could not explain.

---

## 5. Verifications that closed open questions

**The port map is factory-correct — proved by road test.**
Same pipe, two cylinders. Blair's relation gives `peak_5s / peak_4s = 185.7 / 157.5 = 1.179`.
The equivalent 4-speed figure is `rpm_observed / 1.179`. Against the factory 4-speed rating of
6500 rpm, that implies ~7660 rpm for this bike — close to the observed top-speed rpm below.
A **2–4 % match**, from a measurement, with no fitting.

**Peak speed validated after the gearbox was corrected.**
The bike has a **4-speed** gearbox (4th = 1.000, final 16/34, overall 8.276). At "barely
touching 120 km/h" in 4th:

| Tyre | 120 km/h needs |
|---|---|
| 2.75-18 | **8827 rpm** |
| 3.00-18 | **8643 rpm** |

So the engine reaches **~8650–8850 rpm**, not 7500. The cycle model puts peak power at
**~9000 rpm** — a **2–4 % match**. The earlier "pulls at 7500" was where the engine *feels*
strongest, not where it stops.

*Note: this only worked out after the gearbox was identified as 4-speed. The first speed/rpm
table used the 5-speed ratios and wrongly implied a 7500 rpm ceiling at 95 km/h.*

**One pipe serves both variants.** Blair's required tuned length:
- 4-speed @ 6500 with 157.5° → **1103 mm**
- 5-speed @ 7500 with 185.7° → **1127 mm**

2 % apart. The port-timing ratio (1.179) matches the speed ratio (1.154). Three independent
factory data points agree.

**Reinterpreted, no longer contradictions**
- `Cpb = 1.95` (transfer width / bore): Blair's limit of 1.25 uses *effective* width, not arc
  length. At a typical 0.65 projection it is ~1.27. **Definition mismatch, not an error.**
- Time–area is +48 % / +81 % over a 6.3 bar requirement. Real, but it means the cylinder is
  **sized for a better exhaust than it got** — ports good for ~10 bar, plenum delivering ~6.3.
  That is a coherent factory match, and it explains why the engine still pulls to 7500.

**Confirmed against the literature**
| Check | Ours | Reference | Verdict |
|---|---|---|---|
| BSFC | 405 g/kWh @ 6.30 bar | Blair: 435 @ 6.28 bar | ✅ |
| Crankcase CR | 1.343 | Blair reference engine: 1.35 | ✅ |
| Burn duration | 45° CA | Blair models: 41–64° | ✅ |
| Combustion efficiency | 0.95 | Heywood 0.95–0.98 | ✅ |
| BMEP | 6.30 bar | Blair classes: 4 / 8 / 9 / 11 | ✅ |
| Exhaust width / bore | 0.672 | ring-support limit ~0.65–0.70 | ✅ at limit |
| Silencer volume | 45× swept | Blair: ≥12–15× for silencing | ✅ |
| Pipe length formula | `83.3·a0·θ/N` | Blair Eq. 6.2.4 | ✅ identical |

---

## 6. Model status

| Item | State |
|---|---|
| Discretisation | 0.25° crank step, explicit; CFL 0.20 at 7500 rpm |
| Convergence | 25–39 cycles to 1e-4 trapped mass |
| Mass balance | closes to 1e-15 |
| **Wave pipe** | **abandoned** — two stable modes, answer depends on segment count (Nc 40/80/240 → 10.2/10.0/12.2 kW at fixed parameters) |
| Replacement | lumped volume + inlet + outlet restriction (pending outlet bore) |
| Calibration | blocked — no valid anchor for this build |

**Model defects found and fixed during the work:** ignition advance not wired in;
unit slips (g/Wh, m/rad); mm² vs m²; circular self-checks; κ updated once per cycle as a
boundary condition instead of integrated as a state.

---

## 7. Open items — now closed with research-derived values

No further measurements required to run the model. Every remaining hole is filled with a
documented literature value and tagged, so it can be replaced later if a measurement appears.

| # | Item | Adopted value | Basis |
|---|---|---|---|
| 1 | Outlet bore | **Ø35 mm, 5 mm bridge** | measured |
| 2 | Outlet type | **absorptive, perforated core** | measured |
| 3 | Port heights | **map (27.0 mm) — CONFIRMED** | matches the user's cylinder |
| 4 | Transfer widths | **map (113 mm) — CONFIRMED** | same |
| 5 | Connecting rod | **98 mm** | community consensus. Blair's comparable 125 uses 110 mm; the difference is 3° of duration and does not change any conclusion |
| 6 | Crankcase volume | **385 cc → CR 1.34** | Blair's reference engine: 1.35 |
| 7 | Squish clearance | **1.5 mm** | Blair's model input. **Not in the factory documents** — the service action gives clearance volume only (15.9 cc 5s / 17.7 cc 4s), not squish |
| 8 | Ignition curve | **19.5° @3k, 18° @5k, 15° @6.5k, 13° @8k** | typical CDI retard; a placeholder, not a measurement |
| 9 | Anchor for this build | **7500 rpm confirmed; power unknown** | road test. Do not borrow the stock 5-speed 10.4 kW |

**Note on squish:** it has no direct effect in a 0-D thermodynamic model. It changes
turbulence and burn rate, which enter through the combustion calibration constant, and the
clearance volume is already fixed at 15.9 cc (bare head) / 14.52 cc (effective). So 1.5 mm is
adequate and cannot mislead the result. It only matters if turbulence or knock is modelled later.

**Still worth measuring eventually** (improves, does not unblock): actual peak power of this
build; ignition advance with a strobe; rod length with the crank out.

---

## 8. Files

| File | Contents |
|---|---|
| `sim\PROJECT_STATUS.md` | this file — start here |
| `sim\RX135_5S_VERIFIED_PARAMETERS.md` | full parameter set with provenance tags (exhaust §8 superseded) |
| `sim\VERIFICATION_vs_LITERATURE.md` | 23 parameters checked against Blair/Heywood, with verdicts |
| `sim\REFERENCES_EXTRACT.md` | time-area, pipe design, scavenging framework — all with page refs |
| `sim\params.m` | parameter struct, self-checking |
| `sim\data\` | port map images |
| `references\` | Blair ×2, Heywood, Pulkrabek, 8 papers; extracted text in `%TEMP%\opencode\refs\` |

---

## 9. Next actions on return

1. Apply the friction correction (1.30 → 0.828 Nm) and pipe temperature (530 → 470 °C) to `params.m`.
2. Add the measured exhaust to `params.m` as a lumped object: inlet 46 mm, volume 5.98 L, outlet `?`.
3. Re-run with the lumped stub — the two-mode behaviour should disappear by construction; verify
   that segment-count variation no longer moves the answer.
4. Check the model reproduces the **peak shift** (5s + 4s pipe should peak ~18 % higher than
   4s + same pipe). This is testable on the bike and does not depend on absolute power.
5. Only then consider a calibration target — and it must be measured on this build, not borrowed
   from the stock 5-speed.
