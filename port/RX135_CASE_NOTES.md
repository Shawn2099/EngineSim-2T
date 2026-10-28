# RX135 case file — notes, provenance and extrapolation register

**File under discussion:** `port\RX135_INPUT.dat` (42 entries, Prog.5.1 prompt order).
**Configuration:** RX135 **4TL10 5-speed cylinder and `09L` head** with the **4-speed VM22 carb,
4-speed absorptive exhaust and 4-speed gearbox**. This is the hybrid build of
`sim\PROJECT_STATUS.md` §2, not a stock 5-speed (which had a cat-con and a VM20) and not a
stock 4-speed (different porting, CR 9.9).
**Sources used:** `sim\RX135_5S_VERIFIED_PARAMETERS.md` (cited as *md*), `sim\PROJECT_STATUS.md`
(cited as *ps*), `port\INPUT_FORMAT.md`, `port\blair_prog51_basic.txt`, and Blair's text
(*Basic Design of Two-Stroke Engines*, chapter 5 and §3.5.4).
**Date:** 2026-10-29.

---

## 0. Headline

| | Count |
|---|---|
| **Directly measured** (off the engine, a measured drawing, or a factory dimension) | **11** |
| **Derived** (arithmetic on measured inputs, shown in §4) | **8** |
| **Calibration constants** — no measurement can supply them; Blair's own values adopted | **9** |
| **Assumed geometry** — no measurement exists, a value is adopted and flagged | **7** |
| **NOT AVAILABLE** — no defensible value; deck entry left as text, run blocked | **7** |
| **Total** | **42** |

Read as the three categories asked for: **11 measured, 8 derived, 7 missing** — with the
remaining 16 neither measured nor derived but carrying a documented non-measurement basis
(9 model constants + 7 assumptions). Nothing in the deck is an unsourced invention: every
entry is either measured, arithmetic on measured values, one of Blair's published constants,
or explicitly labelled NOT AVAILABLE.

The deck **does not run as it stands**, and that is the point of §5: five of the seven missing
fields are the inlet port, which has no physical counterpart on a reed-valve engine.

---

## 1. The 42 fields

Status key: **M** measured · **D** derived · **C** calibration constant · **A** assumed ·
**NA** not available.

| # | Field | Value | Units | Source | Status |
|---|---|---|---|---|---|
| 1 | `BO` | 58.0 | mm | md3 [F], datum of the port map | M |
| 2 | `ST` | 50.0 | mm | md3 [F] | M |
| 3 | `CRL` | 98.0 | mm | md3 [X] community consensus, in no manual | **A** |
| 4 | `RPM` | 7500 | rev/min | md11 [F] rated-power speed — a run point | M |
| 5 | `TCR` | 5.91 | – | §4.1 | **D** |
| 6 | `CCR` | 1.343 | – | ps7 #6, Vcc 385 cc; md12 tags the range [A] | **A** |
| 7 | `TEXC` | 470 | °C | ps9; md8 [A]; book 400–650 | C |
| 8 | `EPO` | 87.17 | deg ATDC | §4.2, from 92.83° BBDC | **D** |
| 9 | `EPFO` | 180 | deg ATDC | exhaust floor on BDC (map) | **D** |
| 10 | `NEP` | 1 | count | md5.1, map confirmed on the barrel (ps5) | M |
| 11 | `WEP` | 39.0 | mm | md5.1 | M |
| 12 | `RTE` | 8.0 | mm | md5.4 — not dimensioned, back-solved | **A** |
| 13 | `RBE` | 8.0 | mm | md5.4 — same | **A** |
| 14 | `TPO` | 114.37 | deg ATDC | §4.2, from 65.63° BBDC | **D** |
| 15 | `TPFO` | 180 | deg ATDC | floors on BDC | **D** |
| 16 | `NTP` | 5 | count | md5.1 (25/19/25/19/25) | M |
| 17 | `WTP` | 19.9 | mm | §4.3 | **D** |
| 18 | `RTT` | 4.0 | mm | md5.4 — not dimensioned, back-solved | **A** |
| 19 | `RBT` | 4.0 | mm | md5.4 — same | **A** |
| 20 | `SCAV$` | `SCRE` | – | §6 — a selector, not a measurement | C |
| 21 | `IPO` | **NOT AVAILABLE** | deg BTDC | §5.1 | **NA** |
| 22 | `IPFO` | **NOT AVAILABLE** | deg ATDC | §5.1 | **NA** |
| 23 | `NIP` | 1 | count | §5.2 — lumped single aperture | **A** |
| 24 | `WIP` | **NOT AVAILABLE** | mm | §5.1 | **NA** |
| 25 | `RTI` | **NOT AVAILABLE** | mm | §5.1 | **NA** |
| 26 | `RBI` | **NOT AVAILABLE** | mm | §5.1 | **NA** |
| 27 | `LEP1` | 390 | mm | ps4 header length | M |
| 28 | `DEP1` | 46.0 | mm | ps4 header ID | M |
| 29 | `LEP2` | 420 | mm | ps4 perforated core length | M |
| 30 | `DEP2` | 31.7 | mm | §4.4, 787 mm² → Ø | **D** |
| 31 | `VBOX` | 5332 | cm³ | §4.5 | **D** |
| 32 | `SIL$` | `ABSORPTION` | – | ps4 — perforated core, packed annulus | M |
| 33 | `LTP` | **NOT AVAILABLE** | mm | §5.3 | **NA** |
| 34 | `TRAR` | 1.35 | – | md5.1.2 range 1.2–1.5; QUB 400 value | C |
| 35 | `LIP` | **NOT AVAILABLE** | mm | §5.4 | **NA** |
| 36 | `DIP` | 22.0 | mm | md6 [F] VM22 venturi | M |
| 37 | `THAR` | 1.0 | – | full-throttle run (book 1.0) | C |
| 38 | `NC` | 1.25 | – | Blair §4.3.1, same for all four reference engines | C |
| 39 | `NE` | 1.35 | – | Blair §4.3.1 | C |
| 40 | `BEFF` | 0.85 | – | QUB 400 value — the only box-silencer fit in the book | C |
| 41 | `BDEG` | 60.0 | deg | QUB 400 value (book 50–60) | C |
| 42 | `TAF` | 12.5 | – | md9 [A] "≈12.5 at WOT" | C |

### Where the verified data gave no direct answer (the task's explicit list)

| Question | Fields affected | What was done | Confidence |
|---|---|---|---|
| Port **areas** from the map | 11, 17, 12/13, 18/19 | Blair's `PAREA` rebuilt from the map's widths and heights; corner radii and upsweep angles are the two missing inputs, both assumed (§4.3) | 4/5 (exhaust), 3/5 (`WTP`: method exact, angles assumed) |
| **Duct diameters** for the box silencer | 28, 30, 31 | Header ID taken measured; outlet derived from the measured 787 mm²; box volume from the measured envelope minus the header (§4.4, §4.5) | 4/5 |
| **Scavenge model selector** | 20 | `SCRE`, chosen on porting layout and on Blair's own score, with YAM1/YAM6 as a documented band (§6) | 3/5 |
| Inlet port block | 21–26 | five of six NOT AVAILABLE (§5) | 1/5 |
| Duct lengths | 33, 35 | both NOT AVAILABLE (§5) | 1/5 |
| Corner radii | 12, 13, 18, 19 | 8 mm / 4 mm from the drawing, back-solved to the md's areas — circular, as md5.4 says | 3/5 |
| Con rod, crankcase volume | 3, 6 | community value / Blair's reference crankcase CR | 2/5 |

---

## 2. Why the deck is not directly runnable — and proof that it is otherwise complete

`sim\blair\load_case.m` splits each line at the first `!`, skips the empty value part (so a line
beginning with `!` is a comment), requires exactly 42 values in prompt order, and range-checks
each one. Comment-only lines in this deck therefore start with `!`, not `#`.

Run through the ported model, the deck as delivered fails with exactly the seven intended
entries and nothing else:

```
Case file rejected: port\RX135_INPUT.dat
 - line 47: IPO   = "NOT AVAILABLE" is not a number      line 59: LTP = "NOT AVAILABLE" ...
 - line 48: IPFO  = "NOT AVAILABLE" is not a number      line 61: LIP = "NOT AVAILABLE" ...
 - line 50: WIP   = "NOT AVAILABLE" is not a number
 - line 51: RTI   = "NOT AVAILABLE" is not a number
 - line 52: RBI   = "NOT AVAILABLE" is not a number
Expected 42 values in Prog.5.1 prompt order
```

Everything else passes the loader's type and range checks, and with the §8 proxies substituted
`blair_init` completes and derives the geometry the notes claim:

| Quantity | Model value | Notes say |
|---|---|---|
| `HEOT` piston travel at exhaust opening | 27.000 mm | 27.00 (map) |
| `EXHT` exhaust port height | 23.000 mm | 23.00 (map) |
| `HTOT` / `TRHT` transfer travel / height | 37.998 / 12.002 mm | 38.00 / 12.00 (map) |
| `FEPRT` exhaust full-open area | 842.06 mm² | 842 mm² |
| `FTPRT` transfer full-open area | 1125.5 mm² | 1125 mm² (§4.3) |
| `FTDUCT` / `DTDUCT` transfer duct | 1519.4 mm² / Ø43.98 mm | §4.3 |
| `CYCV` clearance volume | 14.529 cc | 14.52 cc (md4) |
| `TCR` implied by `CYCV` | 5.910 | 5.91 (§4.1) |
| `NINT` meshes (header / outlet / transfer / inlet) | 14 / 15 / 3 / 6 | §8 |

So the case file is complete apart from the seven fields that genuinely have no value, and the
seven are exactly the ones §5 explains.

---

## 3. Fields that are used but cannot be entered at all

Two measured quantities from the engine brief have **no field** in Prog.5.1 and are therefore
absent from the deck. Neither can be worked around:

| Quantity | Our value | Why it cannot be entered |
|---|---|---|
| **Ignition timing** | 19.5° BTDC static (md7 [F]) | Prog.5.1 has no ignition input. `BDEG` fixes the heat-release window: `IGN = 360 − BDEG/6`, so with BDEG = 60 the release starts at 10° BTDC regardless of the real spark. A 19.5° static advance would need `BDEG ≈ 117°`, i.e. a 19.5° burn — meaningless. Our measured advance is unusable by this program. |
| **YEIS volume, airbox duct** | not measured | Upstream of `DIP` the model sees atmosphere. Physically our inlet terminates in the airbox, so `LIP` is longer than the metal tract and ends in a compliance. |

`CRL = 98` is used but is *unverified* (§4.6); `TCR`, `CCR`, `TEXC` are the only ways the
compression and gas state enter.

---

## 4. The derivations, in full

### 4.1 `TCR` = 5.91 (trapped compression ratio)

`Vc = 132.104/9.1 = 14.517 cc` (effective clearance volume, md4: 14.52 cc honours the factory's
10.1:1 against a 15.9 cc bare head).
`V_trapped = Vc + A_p·x`, with `x` = piston travel at exhaust closure = 27.00 mm (symmetric with
opening) and `A_p = 2642.1 mm²`:

```
V_trapped = 14.517 + 2642.1 × 27.0 / 1000 = 14.517 + 71.336 = 85.853 cc
TCR       = 85.853 / 14.517 = 5.914
```

Sensitivity: at the factory drawing's 29.7 mm travel (173.3° duration) TCR = **6.40** — the
md's "5.9 (map) / 6.4 (drawing)" pair, reproduced. This is the largest single lever on
trapped mass, so it should travel with the exhaust-duration sweep.

### 4.2 `EPO`, `TPO`, `EPFO`, `TPFO`

Port heights are measured below the TDC *line*, and the map draws the stroke as 50.00 mm, so a
map height **is** the piston travel — no deck clearance is applied (params.m §6 note).

```
exhaust   top 27.00 mm → travel 27.00 at 87.17° ATDC = 92.83° BBDC, duration 185.66°
transfer  top 38.00 mm → travel 38.00 at 114.37° ATDC = 65.63° BBDC, duration 131.25°
blowdown 27.21°
```

`EPFO = TPFO = 180` because every port floor except the boost port sits on BDC, so the windows
reach full height exactly at BDC. Blair then uses `EXHT = 23.00 mm` and `TRHT = 12.00 mm`,
which reproduce the map's 23 mm and 12 mm port heights exactly — a useful consistency check.

Consequence of `TPFO = 180`: the boost port (25 × 15, floor at 53 mm) is never fully uncovered;
Blair's single `TRHT` applies 12 mm to all five, which is exactly the boost port's exposed
height at BDC, so the model is right at the one crank angle that matters.

### 4.3 `WTP` = 19.9 mm — the transfer effective width (the biggest port derivation)

`WTP` is not the map's average width. Blair: *"the effective port area is the exposed port
height multiplied by the cosine of the upsweep angle and the effective port width"*, and the
averaging rule is `sum(W·cos U)/NTP` (src 9809–9811; worked example 2×28.6·cos5° + 30·cos55°,
÷3 = 24.7 mm). The map dimensions **arc** widths (its 184 mm overall width against πD = 182.2 mm
proves widths are arcs) and gives **no upsweep angles**. Blair §3.5.4 supplies the band by
port type: main port ≤ 10°, side ports 15–25°, rear/boost port 50–60°.

Our five windows, laid out by type — 25 (main), 19 (side), 25 (boost), 19 (side), 25 (main):

```
WTP = [25·cos10° + 19·cos20° + 25·cos55° + 19·cos20° + 25·cos10°] / 5
    = [24.62 + 17.85 + 14.34 + 17.85 + 24.62] / 5 = 99.29 / 5 = 19.86 → 19.9 mm
```

Resulting full-open area, `FTPRT = 5(WTP·TRHT − (2−π/2)(RTT²+RBT²))` = **1125 mm²** = 0.426 of
piston area (this is the number the ported model computes from the deck, not a hand figure);
the transfer duct that follows is `TRAR·FTPRT` = 1519 mm², Ø44.0 mm.

**Reconciliation with the md's 1294 mm².** 1294 mm² is the *geometric window area* (arc width ×
height, maximum simultaneously exposed) and is the right number for a time–area or 1-D duct
calculation. Blair's `FTPRT` is the *projected* flow area through the window, which must carry
the upsweep cosine. The two differ by 13 %, and that 13 % is the cosine — not a disagreement
about the port map. Three ways of treating the same map, for the sweep:

| Treatment | `WTP` | `FTPRT` | ratio to piston |
|---|---|---|---|
| cos = 1 (ignore upsweep; = the md's geometric figure) | 22.6 | 1288 mm² | 0.487 |
| **Blair §3.5.4 type-specific bands (used)** | **19.9** | **1125 mm²** | **0.426** |
| the project's scalar 0.65 "typical projection" (ps5) | 14.7 | 813 mm² | 0.308 |

Supporting reasoning, and one honest warning:

1. The method is Blair's own worked example applied to his own published angle bands — nothing in the arithmetic is fitted to our result.
2. The chosen value sits between the two other defensible treatments of the same map, so it is not an extreme choice.
3. **The result puts this cylinder outside Blair's port-width guideline, and that is a property of the engine, not an error in the input.** `WR = NTP·WTP/BO` (Eq.3.5.1) is, in Blair's words, *"difficult to raise much in excess of 1.25 for loop and cross scavenged engines"*. The QUB 400 is 1.08. Ours is **5 × 19.9 / 58 = 1.71**, and **1.95** on the raw arc widths — which is exactly the 1.95 that ps5 quotes, and ps5's correction to 1.27 is obtained by applying a scalar 0.65 to it, i.e. by fitting to Blair's 1.25 rather than deriving from this cylinder's angles. Neither 1.71 nor 1.95 should be "corrected" here; it goes in the extrapolation register (§9 #6).
4. It is self-consistent with the port *timing*: Blair also notes that the higher `WR` is, *"the lower can be the port timings to flow a desired scavenge ratio, SR, at the design speed"*, and this cylinder needs only 131° of transfer duration to feed 7500 rpm. Wide-and-short is a coherent design, not a drawing error.

### 4.4 `DEP2` = 31.7 mm — outlet equivalent diameter

The outlet is a Ø35 mm bore with a ~5 mm flat bridge across it (ps4, measured):
`A = π/4·35² − 35·5 ≈ 962 − 175 = 787 mm²`; `d_eq = √(4·787/π) = 31.66 mm`.
Entering **35.0** instead would give 962 mm², **+22 %**, and would destroy the best piece of
design evidence in the whole exhaust: 787/842 = 0.935, i.e. the outlet is deliberately matched
to the exhaust port area (32.7 mm vs 31.7 mm equivalent).

### 4.5 `VBOX` = 5332 cm³ — box volume

Measured envelope (ps4): header 390 × Ø46 = **648 cm³**; cone 240, Ø46→96 = **989 cm³**;
can 600 × Ø96 = **4343 cm³**. Total **5980 cm³** = 45.3 × swept volume.

Prog.5.1 has one lumped box fed by one pipe. The header is the pipe, so it stays in
`LEP1`/`DEP1` with its measured dimensions; the cone has no representation anywhere in 5.1, so
its volume goes into the box rather than being thrown away:

```
VBOX = 5980 − 648 = 5332 cm³   (= 40.4 × swept)
```

The alternative — pipe length 630 mm at a volume-equivalent Ø57.5 mm, box 4343 cm³ — is volume
identical, keeps the reflection *phase* right, but replaces the measured 46 mm header with a
derived diameter and changes the port/pipe area ratio from 0.51 to 0.32. Both are defensible;
the one used keeps every measured dimension in the field that corresponds to it. Sweep it:
**4170 cm³** is the true free gas volume (annulus 3766 + core bore 404) and **5980 cm³** is the
whole envelope.

### 4.6 `CRL` = 98 mm

Community consensus, in no manual (md §16 #3, conflict 8). Retained because the sensitivity is
known: rod 90→110 mm moves exhaust opening 1.5° and duration 3.0°. It enters `PISTPOS` and
therefore every port timing in the deck. **A caliper on a stock rod closes it.**

---

## 5. Fields that are NOT AVAILABLE, and what would supply each

### 5.1 The inlet block — `IPO`, `IPFO`, `WIP`, `RTI`, `RBI`

This engine has **piston-reed induction**: carb → reed cage → crankcase, with no window in the
cylinder wall that the piston uncovers. md5.5 is explicit — *"no inlet port timing is required;
reed opening is pressure-driven, not crank-driven"* — and `INPUT_FORMAT.md` §8 records that
reed induction is *outside* Prog.5.1's model (src 11055–11064). Blair's model instead computes
the inlet area from `PISTPOS(IPO)`, so the five fields above describe a window our engine does
not have. Any number typed into them is a fabrication.

| Field | What would supply it |
|---|---|
| `IPO`, `IPFO` | Nothing on the engine. A reed has no opening crank angle. The only honest route is a different program (Blair's *Design & Simulation* reed model, or the project's own `engine_model.m`), or the proxy of §8 used and declared. |
| `WIP` | A dimensioned reed-cage aperture (width across the seat) plus a chosen `IPO`. Measure with the cage off: seat width, seat length, petal width, stop height. The assumed 600 mm² seat (ps3) is the current stand-in. |
| `RTI`, `RBI` | The cage aperture's corner radii — not in any source we hold; calipers with the cage off. Moot unless `IPO` is solved first. |

Why it matters: the inlet is the single largest driver of delivery ratio, and `DR` is the single
largest driver of power. This is the weakest link in the whole case file, not the exhaust.

`NIP = 1` is kept because the model lumps the aperture anyway; the real block may have two
windows behind two petals (`reed_n = 2` in params.m), which changes nothing once the total
`NIP·WIP·INHT` area is fixed.

### 5.2 `NIP` = 1

See above: an assumption about how to lump a reed block, not a measurement.

### 5.3 `LTP` — transfer duct length

Nothing dimensioned. The factory porting drawing gives "reference depths 63.8 mm, 90.8 mm"
(md5.2) but never says what they are measured to. If 90.8 mm is deck→crankcase mouth, then the
path from the transfer window centre (44.8 mm below the deck) is ~46 mm — that is where the
proxy comes from, and it is an *identification* of an unexplained dimension, not a measurement.
**Measure it** with a silicone or foam cast of one transfer duct, or a sectioned scrap barrel.

### 5.4 `LIP` — inlet tract length

Never measured. For this engine it should be reed seat → venturi (cage + manifold), roughly
90 mm. **Measure it** along the tract axis with the carb and manifold fitted.

---

## 6. `SCAV$` — the selector, and why `SCRE`

`SCAV$` is not a property of the engine; it picks one of six `(MSC,CSC)` pairs measured on
Blair's single-cycle rig (Fig.3.14). There is no measurement that can choose it — only the
porting layout. Prog.5.1 also fails silently if the string does not match exactly.

| Candidate | `MSC` | `CSC` | SE at SR = 0.7 | Why / why not |
|---|---|---|---|---|
| **`SCRE`** | −1.6709 | 0.1899 | 0.651 | **chosen** — Schnürle loop, "good scavenging"; the model Blair validates the QUB 400 box-silencer case with |
| `YAM1` | −1.6993 | 0.3053 | 0.575 | Yamaha rig type, slightly worse than SCRE |
| `YAM6` | −1.3516 | 0.1435 | 0.572 | the *worst* loop type ("from SCRE to YAM6 … 8 % power, 9 % BSFC") |
| `QUBCR`, `UNIFLOW`, `CD` | — | — | — | cross-flow or uniflow, wrong architecture |

Our cylinder is a five-window + boost-port Schnürle with a YEIS bottle: a well-developed loop
layout, but 14 % of its effective transfer width sits in a 55°-upswept boost port that a 3-port
`SCRE` curve knows nothing about. `YAM6` is the pessimistic bound (the worst of Blair's loop
types, and the type Zhang chose for a Yamaha MT-110S). **Run both**: Blair's own spread is
12.1 → 11.2 kW, i.e. **−8 % power and +9 % BSFC**.
That is the second-largest modelling uncertainty in the case file after the inlet block.

---

## 7. Task 3 — which exhaust model fits, and what to type into it

### 7.1 Prog.5.1 fits. Prog.5.2 does not.

| | Prog.5.1 | Prog.5.2 |
|---|---|---|
| Represents | one lumped box, one inlet pipe, one outlet pipe (Fig.5.2a) | six tapered pipe segments: header, diffuser, belly, baffle cone, stinger (Fig.5.2b) |
| Our exhaust | header 390 × Ø46, divergent cone 46→96, can Ø96 × 600 with a Ø35 core and a bridge-restricted outlet | **no belly, no baffle cone, no stinger** — the 96 mm "belly" is packed and perforated, the outlet is a 35 mm perforated core |
| Absorption | explicit: `SIL$ = "ABSORPTION"` drops the exhaust-port reflection coefficient `AK` from 0.9/0.75 to **0.6** (prog51 line 168) | no equivalent switch |
| Fields that would have to be invented | 2 (where the box begins, and the outlet diameter) | **12** (`LP01…LP56`, `DEP1…DEP6`), because a silencer has none of the features they describe |

Three further reasons, in order of weight:

1. **Our silencer is an absorber, and 5.1 has an absorber switch.** `SIL$ = ABSORPTION` is the
   only place in either program where the model is told the exhaust damps rather than tunes.
   ps4 measured a perforated Ø35 core, a packed annulus and five baffle plates — absorption.
2. **5.1's box class brackets our case.** Blair's two box-silencer validations are the QUB 400
   (box = 25 × swept, outlet area = inlet area) and a chainsaw (box = 5 × swept, outlet =
   41 % of inlet area). Ours is **45 × swept with the outlet at 47 % of the header area** — the
   chainsaw's restriction with the QUB's volume. Neither exact combination is in the book, but
   the program has been exercised on both axes and at 6500–16 000 rpm (the saw).
3. **5.2 has already failed on this exhaust.** ps6: the wave-pipe solver had two stable modes
   and the answer moved with segment count (10.2 / 10.0 / 12.2 kW at fixed parameters). Feeding
   a silencer to a tuned-pipe program produces a tuned answer for something that is not tuned.

### 7.2 What to enter if 5.1 is used

| Field | Value | Why |
|---|---|---|
| `SIL$` | `ABSORPTION` | measured absorption type → `AK = 0.6` at the exhaust port |
| `LEP1` | 390 mm | measured header |
| `DEP1` | 46.0 mm | measured header ID |
| `LEP2` | 420 mm | measured perforated core, used as the outlet pipe |
| `DEP2` | **31.7 mm** | 787 mm² free area, not Ø35 |
| `VBOX` | **5332 cm³** | 5980 measured − 648 header; cone 989 + can 4343 |

**Box volume: 5332 cm³** (40.4 × swept). Total measured envelope **5980 cm³** (45.3 × swept) is
the number to quote as "silencer volume"; the difference between the two is the header, which
is in `LEP1`. Sweep 4170 / 5332 / 5980.

**Outlet area: 787 mm², and it is 787 for a reason.** Ø35 minus a 5 mm bridge = 787 mm² =
Ø31.7 mm equivalent, against a header of 1662 mm² (47 %) and an exhaust port of 842 mm² (94 %).
The outlet is matched to the port on purpose. Typing `35.0` gives 962 mm² and silently deletes
that match — a 22 % area error on the one restriction that sets the whole system's back-pressure.

### 7.3 What 5.1 will and will not reproduce

Check on the entered numbers: with `a = √(1.4·287·743) = 546 m/s`, box 5.33 L, outlet 31.7 mm
× 420 mm (`L_eff = 0.42 + 0.85·0.0317 = 0.447 m`),

```
Helmholtz   f = (a/2π)·√(A/(V·L_eff)) = 50 Hz
outlet λ/4  546/(4 × 0.447)           = 306 Hz
firing      108 Hz @ 6500, 125 @ 7500, 147 @ 8850 rpm
```

Both resonances sit outside the firing band, so the box is a compliance and the core is an
inertance: the model will add back-pressure and damping, and will **not** manufacture a tuned
peak. That is the correct behaviour for this silencer and is the opposite of what a wave-pipe
model does with the same numbers. For reference, the fitted duct is 1230 mm (+45 mm of port
depth): Blair's tuned length `aE/12N` puts it at **6870 rpm** (6630 rpm on 1275 mm) and the
quarter-wave at **6380 rpm**, whereas the cylinder's 185.7° of exhaust duration would ask for
1127 mm at 7500 rpm (ps5). **The hardware is tuned ~10 % below the speed the porting asks for**,
so the pipe cannot be what sets this engine's peak — consistent with the road-test peak of
≈8650–8850 rpm (ps5) being set by port timing and crankcase, not by the exhaust.

**The honest limit:** 5.1 has one volume and one outlet. It cannot represent five chambers, a
perforated core, or a packed annulus, so it is a first-order *damper*, not a silencer model.
The five chambers (140/100/90/70/200 mm) resonate as side branches at 0.9–1.8 kHz (ps4) — an
order of magnitude above 108–147 Hz, so their absence costs the engine calculation little while
costing a noise prediction everything. Keep 5.1 for power, use nothing here for noise.

---

## 8. Runnable proxy deck (documented placeholders)

Substitute only these seven lines, then run. Each is a placeholder and must not appear in a
published result.

| Field | Proxy | Basis, and how to replace it |
|---|---|---|
| `IPO` | 60 deg BTDC | the book's own QUB 400 inlet timing (Fig.5.3), used as the nearest documented stand-in for a reed's open period. **No physical basis for this engine.** Replace only with a reed model, not a measurement. |
| `IPFO` | 0 deg ATDC | fully open at TDC, as QUB 400 |
| `WIP` | 40.2 mm | `600 mm² / 14.92 mm` effective height, i.e. area-matched to the assumed reed seat (ps3). Replace with a measured cage aperture once `IPO` exists. |
| `RTI`, `RBI` | 0 mm | rectangular cage aperture assumed |
| `LTP` | 46.0 mm | 90.8 mm drawing depth − 44.8 mm window centre. Replace with a duct cast. |
| `LIP` | 90.0 mm | cage ~40 + manifold ~50 mm, a bare estimate. Replace with a tape measure. |

With the proxies the deck runs: inlet port 600 mm² × 120° duration, 3 meshes in the transfer
duct, 14 in the header, 15 in the outlet pipe, 6 in the inlet pipe.

---

## 9. Task 4 — where this engine sits outside Blair's validated envelope

Blair's Chapter 5 validation set is four engines: **QUB 400** (397 cc, loop, piston port, box
silencer, 6.7 trapped CR, 3000–5000 rpm), a **chainsaw** (101 cc, diaphragm carb, 5 × swept
box, 41 % outlet, 6500–16 000 rpm), and two **tuned-pipe** engines, a Husqvarna and a 125 GP.
Ours differs on the following, roughly in order of consequence.

| # | Field(s) / feature | Ours | Nearest validated case | Why it is extrapolation |
|---|---|---|---|---|
| 1 | **Induction: `IPO`, `IPFO`, `NIP`, `WIP`, `RTI`, `RBI`** | piston-reed + YEIS, no crank-driven inlet event | necessarily piston- or disc-controlled in all four, because 5.1 has no reed sub-model at all | Prog.5.1 computes the inlet area from `PISTPOS(IPO)` and has no reed law (src 11055–11064). 6 of 42 fields are unrepresentable; `DR`, and therefore power, rests on a proxy. **Largest single extrapolation in the file.** |
| 2 | **Exhaust type** (whole `LEP1…SIL$` block) | absorptive, perforated Ø35 core, packed annulus, 5 baffle chambers, Ø31.7 outlet | QUB 400: empty box, outlet = inlet area. Chainsaw: empty box, 41 % outlet | No validated case has a *perforated, packed* box, and none has 45 × swept with a 47 % outlet together. 5.1 treats the box as a single compliance, so the core's distributed coupling and the chamber resonances are absent. |
| 3 | **Exhaust duration 185.7° with a silencer** | 185.7° (map) | QUB 400: 168° with a box. 125 GP: ~190° **with a chamber** | Blair's long-duration engines all have expansion chambers to exploit them. Ours is raced-timed porting driving a damper — a combination the book never models. Expect the model to under-predict the top end and over-predict blowdown losses. Sweep 173–190° (md5.3) before believing any of it. |
| 4 | **Combustion constants at 7500 rpm** — `BEFF`, `BDEG` | 0.85 / 60°, from QUB 400 | fitted at 3000–5000 rpm, 6.7 trapped CR | `BDEG` is in crank degrees, so a fixed 60° is 3.3 ms at 3000 rpm but **1.33 ms at 7500** and 1.13 ms at 8850. Real burn duration is closer to constant in ms, so the model's burn is short and late at our speed. `BEFF` absorbs whatever the difference in wall heat loss and residual fraction is between a 6.7 trapped-CR research engine and our 5.91 / 10.1 geometric engine — silently. |
| 5 | **Ignition timing** | 19.5° BTDC static (measured) | `BDEG` phasing only | Not enterable (§3). The release always starts near 10° BTDC. Our measured 19.5° is discarded. |
| 6 | **Transfer porting** — `NTP`, `WTP`, `TRHT` | 5 windows + boost; WR = 5 × 19.9 / 58 = **1.71** effective (1.95 on raw arcs); 1125 mm² = **1.34 ×** the exhaust port area | QUB 400: 6 ports, WR = 6 × 15.3 / 85 = **1.08**; transfer area **0.76 ×** exhaust | Blair: WR is "difficult to raise much in excess of 1.25 for loop and cross scavenged engines" — we are 37 % over, and our transfer/exhaust area ratio is 1.76 × the QUB's. Also the single-`TRHT` lumping cannot represent a boost port 3 mm taller and 55°-upswept. `DR` is more sensitive to `WTP` here than in any validated case. |
| 7 | **Crankcase** — `CCR` | 1.343 from an **assumed** 385 cc | QUB 400: 1.45 | Never measured. Crankcase CR sets the delivery ratio directly; the md's 330–440 cc band is CCR 1.30–1.40, i.e. ±4 % about the adopted 1.343, and DR moves almost 1:1. |
| 8 | **Speed** — `RPM` | 7500–8850 rpm | QUB 400 3000–5000; saw 6500–16000 | The speed itself is inside the saw's band, but not with a 132 cc engine and a 45 × box. `LMESH = 30 mm` is fixed: at 8850 rpm the 10th harmonic of firing (1.47 kHz, λ = 371 mm) is only ~12 meshes long, so the sharpest part of the pulse is under-resolved. |
| 9 | **Compression** — `TCR` | 5.91 trapped, 10.1 geometric | QUB 400: 6.7 trapped | Trapped CR is 12 % lower while the geometric CR is much higher — a large trapped-volume fraction and a squish band, neither of which 5.1 models. |
| 10 | **Carburation** — `DIP`, `THAR`, `LIP` | VM22 slide carb at `THAR` = 1.0, airbox + YEIS upstream | saw: diaphragm carb, `THAR` = 0.75 at "full throttle" | `THAR` = 1.0 means the model's throttle offers *no* restriction, so part-load behaviour is unvalidated; the airbox compliance upstream is absent entirely (`LIP` ends in atmosphere). |
| 11 | **Friction** (not a field) | `FMEP = 100·Lst·N` = 0.375 bar @ 7500 rpm | Blair's built-in law, not changeable | The project's own Blair Eq.5.4.2 motorcycle line gives 105·Lst·N = 0.394 bar. 5 % — small, but it is a fixed bias the user cannot remove. |
| 12 | **Build identity** | 5-speed `4TL10` cylinder + `09L` head + 4-speed VM22 + 4-speed pipe + 4-speed box | no such build exists | Nobody has validated this combination. The single-pipe argument (ps5: required tuned length 1103 mm @ 6500 / 1127 mm @ 7500, 2 % apart) is evidence that the *parts* are consistent, not that the *build* is validated. |

**Inside the envelope, for balance:** bore/stroke/rod geometry, `TRAR = 1.35` (mid-range of
1.2–1.5), `NC`/`NE`, the friction law's functional form, the scavenging equations themselves,
and the exhaust-port area ratio 0.319 of piston (QUB 400: 0.304).

---

## 10. What to sweep before trusting a number

| Axis | Range | Why |
|---|---|---|
| Exhaust duration (`EPO`) | 173–190° → `EPO` 93.5–85.0° ATDC | md5.3: the largest geometric uncertainty; it also moves `TCR` (5.9 ↔ 6.4) |
| `SCAV$` | `SCRE` ↔ `YAM6` | 8 % power / 9 % BSFC by Blair's own comparison |
| `VBOX` | 4170 / 5332 / 5980 cm³ | packed annulus vs gross envelope |
| `WTP` treatment | 19.9 ↔ 22.6 ↔ 14.7 mm | upsweep cosine: 1125 / 1288 / 813 mm² |
| `CRL` | 90–110 mm | 3° of duration, and it is unverified |
| `CCR` | 1.30–1.40 (440–330 cc) | never measured, DR moves almost 1:1 |
| `TEXC` | 400–650 °C | the book's full calibration range |
| Inlet proxy `IPO` | 50–80° BTDC | the fabricated field; nothing calibrates it |

---

## 11. Measurements that would move the case file from "documented" to "predictive"

1. **Reed cage aperture** — seat width × length, petal width, stop height, and a crankcase
   pressure trace while running. This is the only way the inlet block stops being a proxy.
2. **Transfer duct cast** — one duct, silicone or foam, gives `LTP` and `TRAR` together.
3. **Crankcase volume** — fill through the inlet with the engine assembled and the piston at BDC.
4. **Exhaust port top edge** — depth gauge to the cylinder top face, head off; settles the
   27.0 vs 29.7 mm question and removes the 17° duration band.
5. **Upsweep angles and plan angles** of the five windows — settles `WTP` and the cosine.
6. **Inlet tract length** — tape measure, carb fitted.
7. **Ignition advance with a strobe** at 3000/5000/7000 rpm — for a program that can use it.
