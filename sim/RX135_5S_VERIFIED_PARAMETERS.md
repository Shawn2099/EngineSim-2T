# Yamaha RX135 (Indian) — Verified Parameter Set for Engine Simulation

**Status:** consolidated, re-verified from every source in this folder. **Supersedes** all earlier
`.md` datasets in `Yamaha_RX135_India/`, `Yamaha_RX135_India_5Speed/`, `Yamaha_RX135_4speed_India/`
and `rx135 5speed/`. Where those files conflict with this one, this one is correct and the reason is
recorded in §14.

**Primary variant:** RX135 **5-speed** (engine prefix `1L7`, block `4TL10`, model years 2000–2003).
**Secondary variant:** RX135 4-speed (derived, §13) — only the engine differs; the user has confirmed
the rest of the vehicle is the same.

**Date compiled:** 2026-10-28

---

## 0. Tag legend

| Tag | Meaning |
|---|---|
| `[F]` | Factory: Escorts Yamaha service document, owner's manual, parts catalogue, Yamaha official archive (T1) |
| `[S]` | Secondary published source (T2) |
| `[X]` | Forum / community / video (T3–T4) — never allowed to override `[F]` |
| `[D]` | Derived by calculation from tagged inputs (method shown) |
| `[A]` | Assumed / not sourced — must be replaced by measurement or calibrated |
| `[C]` | Calibration constant — fitted to the anchor point, not a physical measurement |
| `[O]` | **Adopted** — a community-grade source (T3) explicitly chosen as the modelling baseline when no factory equivalent exists. Not factory data, but not an invention either. Currently used only for the port map. |

---

## 1. Critical corrections — read before using any older file

1. **Compression ratio is 10.1:1, not 10.4:1.**
   10.4 is the **maximum power in kW**. The owner's manual technical-specification page reads
   `Maximum Power (kW) 10.4 at 7,500 rpm`. The same page's compression line gives ~10.1:1, and the
   factory Service Action states **10:1 (earlier 9.9:1)** with **clearance volume 15.9 cc (earlier
   17.7 cc)**. An OCR capture of the manual produced the string "Compression Ratio 10.4:4", which is
   how the wrong value entered the older datasets. 10.4:1 is rejected (§15).

2. **Carburettor on the 5-speed is VM20, not VM22.**
   Factory table, "MIXING BODY ASSY (VENTURI SIZE)": 5-speed = **VM20**, 4-speed = **VM22**. The
   forum claim of "VM22 with oval venturi" is a T3 error (§15).

3. **Ignition timing is known: 19.5° BTDC (5-speed), 24° BTDC (4-speed).**
   Every earlier dataset listed this as NOT FOUND. It is on the Service Action electrical page.

4. **Port geometry has two factory-grade sources that disagree by 2.7 mm.** Resolution and the
   reasoning are in §5.3 — do not take a port height from either source without reading that section.

5. **The 4-speed is now buildable.** Its port timing is derivable from the 5-speed map plus the
   factory's measured deltas (+6 mm exhaust, +2 mm transfers). §13.

---

## 2. Engine identity — verify against the actual machine

| Item | Value | Tag |
|---|---|---|
| Engine type | Air-cooled, 2-stroke, single cylinder, piston-reed inlet, 7-port, Torque Induction, YEIS | [F] |
| Engine number prefix (5-speed) | `1L7 XXXXXX` | [F]/[X] |
| Engine number prefix (4-speed) | `1L5` (chrome silencer) / `4TL` (cat-con) | [X] |
| Cylinder block code | 5-speed `4TL10`; 4-speed `4TL00` | [F] |
| Cylinder head code | 5-speed `09L`; 4-speed `4TL00` (chrome) / `4TL5` (cat) | [X] |
| Piston | OEM ART `4Y201` (both variants) | [X] |
| Parts catalogue lines | 4-speed `4TL1`/`4TL4`; 5-speed `4TL6` | [F] |
| Model years (Indian) | 5-speed 2000–2003; 4-speed 1998–2005 in three sub-revisions (YEIS 98–00, cat-con 01–03, mini-cat 03–05) | [F]/[X] |
| Cylinder head p/n | 5-speed `1L7.52.00.01`; 4-speed `1L5.52.00.10` | [F] |
| Piston ring set p/n | 5-speed STD `1L7.66.01.00`, +0.25 `1L7.66.02.00`, +0.50 `1L7.66.03.00`; 4-speed `1L5.64.04.00` / `1L5.64.05.00` / `1L5.64.06.00` | [F] |
| Crankshaft | Same assembly across RX135 / RXG / 5-speed / RX-Z (`2YA-XE1400-00` in 4TL1 catalogue) | [F]/[X] |
| Reed valve assy p/n | `2YA-E3610-00-00` | [F] |

> Note on part numbers: the Service Action document prints codes in the form `1L7.xx.xx.00`. They are
> reproduced exactly as printed. Only the parts-catalogue numbers (`xxxx-xxxxx-00-00`) have been
> cross-checked against a catalogue page.

---

## 3. Geometry and kinematics

| Parameter | Value | Unit | Tag | Note |
|---|---|---|---|---|
| Bore | 58.0 | mm | [F] | owner's manual "58×50" |
| Stroke | 50.0 | mm | [F] | |
| Displacement | **132.10** (stated 132) | cc | [F]/[D] | π/4·B²·S = 132.104. The 132.16 / 132.157 figure quoted on xbhp is a rounding slip — do not use it |
| Crank radius (throw) | 25.0 | mm | [D] | stroke/2, exact |
| Connecting rod length (c-c) | **98.0** | mm | [X] | community consensus, **not** in any manual. §16 |
| Rod/stroke ratio | 1.96 | – | [D] | |
| Piston area | 2642 | mm² | [D] | |
| Deck clearance (piston crown below cylinder top face at TDC) | **0.8** | mm | [D] | from factory porting drawing: port bottoms at 50.8 mm below deck with 50.0 stroke |
| Piston compression height | NOT FOUND | mm | – | not needed once deck clearance is known |
| Gudgeon pin Ø | NOT FOUND | mm | – | not needed for the gas-exchange model |
| Base gasket thickness | NOT FOUND | mm | – | folded into deck clearance |
| Head gasket | `4TL-E1181-00-00` | – | [F] | |
| Mean piston speed at 7500 rpm | 12.5 | m/s | [D] | normal for a road 2-stroke |

**Port timing sensitivity to rod length is small but not negligible:** 90 → 110 mm moves exhaust
*opening* by 1.5° and the *duration* by **3.0°** (both ends move). The model consumes durations, so use
the 3.0° figure when judging the risk. The unverified 98 mm still ranks below the port-height
uncertainty; it affects only second-order piston motion apart from this.

---

## 4. Compression and thermodynamics

| Parameter | Value | Unit | Tag |
|---|---|---|---|
| Geometric compression ratio (5-speed) | **10.1** (factory service action: 10.0) | :1 | [F] |
| Geometric compression ratio (4-speed) | 9.9 | :1 | [F] |
| Head clearance volume (5-speed) | **15.9** | cc | [F] |
| Head clearance volume (4-speed) | 17.7 | cc | [F] |
| Effective clearance volume used in model | **14.52** | cc | [D] |
| Trapped compression ratio (from exhaust close) | **5.9** (map) / 6.4 (factory-drawing heights) | :1 | [D] |
| Squish clearance | NOT FOUND | mm | – |
| Squish band width | NOT FOUND | mm | – |
| Chamber / dome shape | NOT FOUND (photo required) | – | – |

**Arithmetic note (important):** 15.9 cc against 132.10 cc gives 9.31:1, not 10.1:1. The 10.1:1 figure
is only reproducible with an effective clearance volume of 14.52 cc, i.e. the piston crown occupies
≈1.4 cc of the 15.9 cc measured head volume. That is physically sensible (crown dome + squish band).
**Use 14.52 cc as the model's clearance volume to honour the factory's 10.1:1**, and treat the
15.9 cc as the bare-head burette value.

Trapped CR calculation: `V_exhclose = Vc + A_p·x_exhclose`, `CR_trapped = V_exhclose / Vc`.
With Vc = 14.52 cc, A_p = 26.42 cm², x = 27 mm → 5.91:1.

---

## 5. Port and gas-exchange geometry

### 5.1 Dimensioned port map (user-supplied, `4TL10 – RX135/Z 5 Speed Port Map (With Dimensions)`)

**Provenance `[O]` — adopted, not factory.** This is a T3-grade community drawing, not a Yamaha print.
It is adopted as the baseline because it is the only dimensioned source, because it is internally
consistent (port floors on its own BDC line), and because an independent quote ("190° / 125°")
reproduces it. It is used for **absolute** positions only; the factory drawing in §5.2 supplies the
deltas. Do not upgrade this to `[F]` on the strength of its self-consistency.

Datum: **TDC line, with stroke drawn as 50.00 mm**. Self-consistent: port floors sit on the BDC line.

| Feature | Width | Height | Top edge below TDC | Bottom edge |
|---|---|---|---|---|
| Exhaust (single, oval/rounded-rect) | 39.0 mm | 23.0 mm | **27.00 mm** | 50.0 mm (BDC) |
| Transfer 1 | 25.0 mm | 12.0 mm | 38.00 mm | 50.0 mm |
| Transfer 2 | 19.0 mm | 12.0 mm | 38.00 mm | 50.0 mm |
| Transfer 3 (centre) | 25.0 mm | 15.0 mm | 38.00 mm | 53.0 mm (runs past BDC) |
| Transfer 4 | 19.0 mm | 12.0 mm | 38.00 mm | 50.0 mm |
| Transfer 5 | 25.0 mm | 12.0 mm | 38.00 mm | 50.0 mm |
| Overall map width | 184.00 mm | – | – | – |
| Two lower shapes | 20.00 mm | 29.00 mm | (11.00 mm apart) | ambiguous — see §16 |

### 5.2 Factory porting drawing (Service Action, "PORTING DIFFERENCES RX135 5 SPEED vs 4 SPEED")

Dimensioned from `SURFACE (TOP OF CYLINDER)`. Bracketed values = 1L5 (4-speed).

| Feature | 5-speed | 4-speed | Factory note |
|---|---|---|---|
| Exhaust port top | **30.5 mm** | 36.5 mm | "height increased by 6 mm" |
| Transfer tops (pair A) | **41.5 mm** | 43.5 mm | "height increased by 2 mm" |
| Transfer tops (pair B) | **40.5 mm** | 42.5 mm | "height increased by 2 mm" |
| 7th port | – | – | "height increased by 2 mm" |
| Port floors | 50.8 / 51.8 / 54.3 mm | same | |
| Reference depths | 63.8 mm, 90.8 mm | same | |

Converting the floors to the map's TDC datum (subtract the 0.8 mm deck clearance) gives **50.0 / 51.0 /
53.5 mm**, against the map's **50.0 / 53.0**. So the map is missing the 51.0 mm intermediate floor and is
0.5 mm low on the boost-port floor. If the drawing is right, those two windows are ~1 mm taller at the
bottom — and that extra strip is *never uncovered by the piston*, so it does not change timing or flow.
Recorded for completeness; no parameter change.

### 5.3 Conflict and resolution — the 2.7 mm problem

Converting both sources to crank angle (r = 25, l = 98, deck clearance 0.8 mm):

| Source | Exhaust top → travel | Exhaust duration | Transfer duration | Blowdown |
|---|---|---|---|---|
| Port map (27.0 mm from TDC) | 27.0 mm | **185.7°** | **131.3°** | 27° |
| Factory drawing (30.5 mm below deck) | 29.7 mm | 173.3° | 115–121° | 29° |
| Independent quote "190° exhaust / 125° transfer" | – | 190° | 125° | – |

**Resolution — use the map for absolute positions, the drawing for deltas.**

Reasoning:
1. The map is corroborated by the "190°/125°" figure — it lands within 4.3° / 6.3° of it. That is
   corroboration, not a reproduction; the agreement is too close to be meaningless and too loose to
   call confirmation.
2. Applying the factory *deltas* to the map gives the 4-speed: exhaust 157.5°, transfers 119.5°,
   blowdown 19°. That is a sensible 6500 rpm engine making 12 PS.
3. Applying the factory *absolute* heights gives a 4-speed with 143.8° exhaust — implausibly low for
   a rated 6500 rpm, 12 PS engine. So the drawing's absolute heights are almost certainly referenced
   to a different feature (duct edge / gasket face) rather than the bore-side window edge.
4. The map's own port floors land exactly on its BDC line, so it is internally consistent.

**Baseline adopted:** exhaust opens 92.8° BBDC (185.7°), transfers open 65.6° BBDC (131.3°),
blowdown 27°. **Sweep the exhaust duration over 173–190° in every study** — this 17° band is the
single largest remaining geometric uncertainty and the model should quantify it rather than hide it.

### 5.4 Derived flow areas (full open, projected)

| Feature | Area | Ratio to piston area |
|---|---|---|
| Exhaust (39×23, corner radius 8) | **842 mm²** | 0.319 |
| Exhaust (if 20.5 mm tall, factory) | 745 mm² | 0.282 |
| Transfers, **sum of all five window areas** | 1362 mm² | 0.516 |
| Transfers, **maximum simultaneously exposed** | **1294 mm²** | 0.490 |

The distinction matters: the centre window (25 × 15) has its floor at 53 mm while the piston crown stops
at BDC (50 mm), so **3 mm of that window is never uncovered**. 1362 mm² is a window-area sum, not a flow
area. The 1294 mm² figure is the one the solver must use, and it is 5.0 % lower. Likewise if the factory
drawing's 51.0 mm floor is right, another ~88 mm² of a second window is dead, taking the maximum to
≈1206 mm².

Sanity: exhaust/piston 0.32 and transfer/piston 0.52 are textbook values for a performance-oriented
road 2-stroke.

**Caveat on these areas:** the corner radii used (8 mm exhaust, 4 mm transfers) are **assumed from the
drawing**, not dimensioned on it. The areas are therefore only as good as that assumption. Measured
sensitivity: exhaust r = 5–11 mm gives +4.0 / −5.8 %; transfers r = 2–7 mm gives **+3.8 / −10.4 %** — so
the transfer areas are the less certain of the two, and ±3–5 % is too optimistic for them. This is a
consistency check, not independent evidence. The genuine evidence that the map is a real stock drawing is
(a) its port floors land on its own BDC line, and (b) the "190°/125°" figure lands within 4.3° / 6.3°.

### 5.5 Inlet

Piston-reed + YEIS. **No inlet port timing is required** — reed opening is pressure-driven, not
crank-driven. Model the reed as a check valve with an assumed discharge coefficient. This removes
"inlet timing" from the gap list entirely (earlier datasets wrongly listed it as a missing parameter).

---

## 6. Induction

| Parameter | 5-speed | 4-speed | Tag |
|---|---|---|---|
| Carburettor | Mikuni/UCAL **VM20** | Mikuni **VM22** | [F] |
| Venturi | 20 mm | 22 mm | [F] |
| Main jet | **135** | 165 | [F] |
| Pilot jet | **15** | 17.5 | [F] |
| Main nozzle / needle jet | **0-3 (267)** | 0-8 (788) | [F] |
| Needle | **5ZF6** | 4J26 | [F] |
| Slide cutaway | 2.0 | 2.0 | [X] |
| Air filter | Washable PU foam; 5-speed has **airbox duct** and **larger element** | no duct, smaller element | [F] |
| Carb assy p/n | `1L7.56.01.00` | `1L5.65.00.00` | [F] |
| Needle clip position | NOT FOUND | NOT FOUND | – |
| Float height | NOT FOUND | NOT FOUND | – |
| Air-screw turns | NOT FOUND | NOT FOUND | – |

The 5-speed is leaner-jetted on a smaller carb with a bigger airbox — deliberate emissions tuning.
Do not "correct" this to VM22/165 in the model.

---

## 7. Ignition

| Parameter | 5-speed | 4-speed | Tag |
|---|---|---|---|
| Static ignition timing | **19.5° BTDC** | 24° BTDC | [F] |
| Ignition type | Electronic CDI | Electronic CDI | [F] |
| Rotor / base assy | `1L7.62.02.00` / `1L7.62.03.00` | `1L5.62.05.00` / `1L5.62.03.00` | [F] |
| Pulser coil | `1L7.62.04.00` | `1L5.62.06.00` | [F] |
| Ignition coil | `1L7.30.03.00` (vendor INEL) | `1L1.30.31.00` (vendor MORIC) | [F] |
| CDI unit | `1L7.30.02.00` | `1M1-30.02.00` | [F] |
| Spark plug | NGK BPR7HS | NGK BPR7HS | [F] |
| Plug gap | **0.6–0.7 mm** | 0.7–0.8 mm | [F] |
| Advance curve above idle | **NOT FOUND** | NOT FOUND | – |
| Battery | 12 V 2.5 Ah | same | [F] |

The 5-speed runs **4.5° less static advance** than the 4-speed despite higher CR. That is consistent
with a faster-burning, higher-turbulence chamber and is a real design signal — do not model both with
one timing curve.

---

## 8. Exhaust system

| Parameter | Value | Tag |
|---|---|---|
| Type | Catalytic-converter "hot-tube" silencer (stock); the 5-speed **never** came with a chrome silencer as OE | [F]/[X] |
| Muffler assy p/n | 5-speed `1L7.13.01.00` | [F] |
| Catalyser | Fitted, with heat protectors | [F] |
| Header length / ID | NOT FOUND | – |
| Diffuser cone angles / lengths | NOT FOUND | – |
| Belly Ø / length | NOT FOUND | – |
| Baffle cone angle / length | NOT FOUND | – |
| Stinger ID / length | NOT FOUND | – |

**Placeholder pipe (reverse-engineered, not measured).** Using `L ≈ a·E_d/(12·N)` with a = 500 m/s,
N = 7500 rpm:

| Exhaust duration | Acoustic length | Header 25% | Diffuser 35% | Belly 15% | Baffle 25% |
|---|---|---|---|---|---|
| 173° | 963 mm | 241 | 337 | 144 | 241 |
| 186° | 1032 mm | 258 | 361 | 155 | 258 |

This is `[A]`/`[C]`: the *tuning rpm* is correct by construction, the *shape* is invented. The stock
cat-con is heavily restricted, so expect it to behave softer and more low-end-biased than a clean
chamber. Treat `a` as a calibration constant.

---

## 9. Lubrication and fuel

| Parameter | Value | Tag |
|---|---|---|
| Lubrication | Autolube, separate oil pump, 1.2 L tank | [F] |
| 2T oil | YAMALUBE 2T or JASO FC / API TC | [F] |
| Gearbox oil | Multigrade 20W/40, 0.65 L | [F] |
| Fuel tank | 10.5 L (reserve 1.5 L) | [F] |
| Fuel octane | NOT FOUND | – |
| Premix if pump disabled | 40–50 ml 2T per litre (owner-reported) | [X] |
| AFR target | NOT FOUND (model as calibration constant, ~12.5 at WOT) | [A] |

Maintenance data from the owner's manual §VI (not simulation inputs, but they define the real-world
boundary conditions):

| Item | Value | Tag |
|---|---|---|
| Fuel reserve | 1.5 L | [F] |
| Chain slack | 20–30 mm | [F] |
| Tyre pressure (cold) | F 1.4 kg/cm²; R 1.4 solo / 1.6 two-up | [F] |
| Decarbonise cylinder head, piston ring **and exhaust port** | every 5000 km | [F] |
| Spark plug replacement | every 10 000 km | [F] |
| Break-in | 1000 km, no high speed | [F] |

> The 5000 km exhaust-port decarbonisation interval is worth remembering: carbon growth in the
> exhaust port and the cat-con is a real, progressive change in the gas-exchange geometry of this
> engine. A stock high-mileage bike is not the same engine as a freshly decoked one — a legitimate
> sweep axis once the model works.

---

## 10. Drivetrain and vehicle (identical between variants except gearing)

| Parameter | 5-speed | 4-speed | Tag |
|---|---|---|---|
| Primary reduction | 19 T / 74 T = 3.895 | same | [X] |
| 1st | 35/11 = 3.182 | same | [F] |
| 2nd | 30/15 = 2.000 | same | [F] |
| 3rd | 26/19 = 1.368 | same | [F] |
| 4th | 24/22 = **1.091** | 23/23 = **1.000** | [F] |
| 5th | 22/24 = **0.917** | – | [F] |
| Final drive | 15 / 38 | 16 / 34 | [X] |
| Tyres | F 2.75×18 4PR, R 3.00×18 6PR | F 2.75×18, R 2.75×18 | [F] |
| Dry weight | 108 kg | 106 kg | [F]/[X] |
| Overall L×W×H | 1965 × 780 × 1040 mm | 1965 × 740 × 1050 mm | [F] |
| Wheelbase | 1245 mm | 1240 mm | [F] |
| Ground clearance | 136 mm | 145 mm | [F] |
| Frame | Double cradle | same | [F] |

Gear tooth counts are confirmed twice: by the factory gear-teeth diagram and by the xbhp teardown post.

---

## 11. Validation anchors

| Quantity | 5-speed | Tag | Consistency |
|---|---|---|---|
| Maximum power | **10.4 kW (14.0 BHP) @ 7500 rpm** | [F] | |
| Maximum torque | **1.25 kgm = 12.26 Nm @ 7000 rpm** | [F] | |
| Implied BMEP at peak power | 6.30 bar | [D] | normal 5–8 bar ✅ |
| Implied BSFC at AFR 12.5, DR 0.75 | ~405 g/kWh | [D] | normal 350–450 ✅ |
| Implied fuel flow at 7500 | ~4.2 kg/h ≈ 5.7 L/h | [D] | ≈23 km/L at 130 km/h, matches 25–35 claims ✅ |
| 0–60 km/h / top speed | 3.5 s / 130 km/h | [X] | |
| 4-speed power | 12.0 PS (8.9 kW) @ 6500 rpm, 12.3 Nm @ 5500 rpm | [F] | |

**Internal inconsistency to be aware of:** 10.4 kW at 7500 rpm requires 13.24 Nm at 7500, but peak
torque is quoted as 12.26 Nm at 7000. The two published points are ~8% inconsistent (rounded catalogue
figures). The same applies to the 4-speed (12.0 PS at 6500 needs 12.97 Nm vs 12.3 stated).
**Do not fit the model to both points** — fit to the power point and accept the torque curve shape as
a prediction, or fit to a real dyno curve if one ever becomes available.

---

## 12. Derived quantities needed by the solver

| Quantity | Value | Basis |
|---|---|---|
| Clearance volume (effective) | 14.52 cc | CR 10.1 |
| Trapped CR | 5.9 | exhaust closes at 272.8° ATDC (87.2° ABDC) |
| Crankcase volume | **NOT FOUND — assume 330–440 cc (crankcase CR 1.3–1.4)** | [A] |
| Exhaust opens | 92.8° BBDC | map |
| Transfers open | 65.6° BBDC | map |
| Blowdown | 27.0° | derived |
| Exhaust full-open area | 842 mm² | map |
| Transfer full-open area | 1294 mm² max simultaneously exposed (1362 mm² window sum) | map |
| Pipe acoustic length | 1032 mm (tuned 7500 rpm) | [A]/[C] |
| Ignition | 19.5° BTDC static | [F] |

---

## 13. 4-speed dataset (derived)

Derived by applying the factory's measured deltas to the 5-speed map. Legitimate derivation, not a
guess — but it inherits the map's absolute-height uncertainty.

| Parameter | 4-speed value | Basis |
|---|---|---|
| Exhaust port top | 27.0 + 6.0 = **33.0 mm** below TDC | factory +6 mm |
| Transfer tops | 38.0 + 2.0 = **40.0 mm** | factory +2 mm |
| Exhaust opens | **78.7° BBDC → 157.5° duration** | derived |
| Transfers open | **59.8° BBDC → 119.5° duration** | derived |
| Blowdown | **18.8°** | derived |
| CR | **9.9:1** | factory |
| Head volume | 17.7 cc | factory |
| Carb | VM22, main 165, pilot 17.5, needle 4J26, nozzle 0-8 (788) | factory |
| Ignition | **24° BTDC** | factory |
| Plug gap | 0.7–0.8 mm | factory |
| Gearbox | 4-speed, 4th = 1.000 | factory |
| Final drive | 16/34 | forum |
| Exhaust | Chrome silencer or cat-con depending on sub-revision | factory |

Cross-check: 157° exhaust at a 6500 rpm rating is coherent (typical 155–170°), which supports the
resolution in §5.3.

---

## 14. Conflict log

| # | Conflict | Sources | Resolution |
|---|---|---|---|
| 1 | CR 10.1 vs 10.4 vs 10.0 | owner's manual (10.1), OCR capture (10.4), service action (10.0) | **10.1** adopted. 10.4 is the kW figure; OCR artefact. Service action's 10.0 is the same value rounded down. |
| 2 | Carb VM22 oval vs VM20 | forum (VM22 oval), factory table (VM20) | **VM20** — factory table wins. |
| 3 | Chamber volume 22 cc vs 15.9 cc | Facebook (22 cc), factory (15.9 cc) | **15.9 cc** — factory. |
| 4 | Exhaust port top 27.0 vs 30.5 mm | port map, factory drawing | **27.0 mm** (map) — see §5.3. Sweep 173–190°. |
| 5 | Power 14 BHP @ 7500 vs 15.2 @ 8500 | manual/forum vs Facebook | **10.4 kW @ 7500** — factory. |
| 6 | 4-speed power 12 PS @ 6500 vs 12 BHP @ 7500 | Yamaha archive vs bikeinfobd | **12 PS @ 6500** — Yamaha official. |
| 7 | Bore × stroke 58×50 vs 58×55 | all factory sources vs bikeinfobd | **58×50** — 58×55 would be 145 cc. |
| 8 | Rod length 98 mm | forums only | Retained as `[X]`, flagged unverified. Low impact (§3). |
| 9 | Rear tyre 2.75 vs 3.00 (4-speed) | bikeinfobd vs RX-King platform | Unresolved; not used by the engine model. |
| 10 | Plug gap | — | Now resolved by factory: 0.6–0.7 (5s), 0.7–0.8 (4s). |

---

## 15. Rejected values (do not use)

| Value | Why rejected |
|---|---|
| CR **10.4:1** | 10.4 is the power in kW; contradicted by the factory's own 15.9 cc chamber |
| CR 10.1:1 from bikeinfobd "both variants" | Correct for 5-speed only; 4-speed is 9.9:1 |
| Carb **VM26** stock | Indian stock is VM20 (5s) / VM22 (4s) |
| Carb **VM22 oval** for 5-speed | Factory table says VM20 |
| Chamber volume 22 cc | Single unsourced Facebook post |
| Bore × stroke 58 × 55 | Implies 145 cc, contradicts 132 cc |
| "14 bhp @ 6500" | 5-speed is at 7500 |
| "15.2 bhp @ 8500, 13.5 Nm @ 8000" | Unsourced owner claim |
| Generic "190°/125°" as if it were *any* RX | It matches the 4TL10 5-speed map specifically — usable as corroboration for the 5-speed only |
| RX100 port heights 28/30/32 mm | Different cylinder (RX100), 50 mm bore |
| RX-King 135 figures (17.5–18.5 PS) | Indonesian engine, out of scope |
| "NGK iridium" as stock plug | Factory specifies BPR7HS copper |
| "98 mm rod is factory data" | It is forum consensus, not in any manual |
| Port timing values from ported builds | Modified engines |

---

## 16. Assumptions register (what the model must calibrate or the user must measure)

| # | Item | Current handling | Impact if wrong |
|---|---|---|---|
| 1 | Exhaust pipe geometry | Placeholder, tuned to 7500 rpm | **High** — the only real blocker left |
| 2 | Exhaust port absolute height | Map (27 mm) baseline, sweep 173–190° | High (±8° duration ≈ ±150 rpm) |
| 3 | Rod length 98 mm | Accepted | Low for timing, medium for kinematics |
| 4 | Crankcase volume | Assumed 330–440 cc | Medium (crankcase CR drives scavenging) |
| 5 | Ignition advance curve | 19.5° static + assumed CDI curve | Medium |
| 6 | Reed Cd and opening pressure | Assumed | Low-medium |
| 7 | Squish / chamber shape | Not modelled | Low-medium |
| 8 | Two lower port-map shapes (20×29, 11 apart) | Unresolved — probably piston/reed windows | Low (reed is pressure-driven) |
| 9 | Combustion efficiency, scavenge efficiency, friction | `[C]` calibration constants | Absorbed by calibration |
| 10 | Fuel octane, AFR target | Assumed | Low-medium |

---

## 17. Source inventory (what was actually used)

**Factory (T1)**
- Escorts Yamaha **Service Action YMEL-SERV 2543, 22 Nov 2000, "RX135 (5 SPEED) — Main Difference Points w.r.t 4 Speed Model"**, 17 pp — local: `rx135_5s_vs_4s_difference_manual_screenshots/` and `Yamaha_RX135_India/manuals/specs_manual/page_1.jpg`. Source of CR, chamber volumes, porting deltas, carb jetting, ignition timing, plug gap, gear teeth, airbox.
- **Escorts Yamaha RX-135 5-Speed Owner's Manual**, 19 pp — local: `Yamaha_RX135_India/manuals/5speed_manual/`. §VIII technical specifications (p. 22), capacities (p. 24), periodic maintenance.
- **RX135 4TL1 Parts Catalogue** — local: `rx135_parts_catalogue_4TL1.pdf` (4 copies in the tree), also `https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf`.
- **4TL6 Parts Catalogue (5-speed)** — local: `Yamaha_RX135_India/manuals/parts_4TL6/` 52 pp (not yet mined).
- **4TL4 Parts Catalogue** — local: `Yamaha_RX135_4speed_India/manuals/parts_4TL4/` 52 pp (not yet mined).
- Yamaha global Communication Plaza, 1996 RX135 — `https://global.yamaha-motor.com/showroom/cp/collection/rx135/`.

**Port map (T3, but dimensioned and internally consistent)**
- `rx135_5speed_portmap.png` — "4TL10 – RX135/Z 5 Speed Port Map (With Dimensions)".
- `rx135_5speed_portmap_2.png` — same map, undimensioned (no added information).

**Secondary / community (used only where factory is silent)**
- xbhp post #89 (karthikdattag, 2018) — component delta, gear ratios, part codes.
- xbhp post #90 — non-stock "i2 series" kit port height (rejected as stock).
- Facebook port-map quote "190°/125°" — corroboration only.
- Team-BHP RX135 5-speed thread — cat-con weight, owner detail.
- Wikipedia RX100 page — model-year timeline.
- bikeinfobd — rejected except where corroborated.

**Damaged / unusable**
- `Yamaha_RX135_India/manuals/engine_manual/page_1..5.jpg` — **not engine content at all.** They are
  1.4–4.4 KB screenshots of a Scribd download-gate ("Please complete the captcha to download the
  file"). Discard; there is nothing to recover.
- `5speed_manual` pages are 250×322 px scans: readable for titles, marginal for small print. The CR
  line is the one figure in this document that could not be read with certainty; that is why the
  resolution in §14 relies on the Service Action rather than the manual.

**Parts catalogues — structure only, no parametric content**
`parts_4TL6/page_1..52.jpg` and `parts_4TL4/page_1..52.jpg` are standard Yamaha illustrated parts
lists: cover, foreword, contents, then one exploded drawing + one part-number table per assembly
(cylinder, crankshaft/piston, oil pump, intake, carburettor, exhaust, crankcase, clutch, transmission,
frame, wheels, electrical). **They contain no dimensions, no specifications and no torque values.**
Sampled and confirmed: `page_5` of both catalogues is the cylinder/head assembly and is drawing-only.
The two catalogues use visually identical cylinder illustrations with different part numbers — do not
read the drawing as evidence that the porting is the same.
The only extractable value is 5-speed-specific part numbers (e.g. generator/electrical section, not yet
indexed). This is ordering data, not simulation data.

---

### 17.1 Page-level coverage (what was actually opened and read)

| Document | Pages | Read | Notes |
|---|---|---|---|
| `specs_manual/page_1.jpg` (Service Action cover) | 1 | ✅ all | |
| `rx135_5s_vs_4s_difference_manual_screenshots/` | 17 | ✅ all | pp. 2–6 tables, E-1 plug, E-2 crank, E-3 gearbox, E-4 shift cam, E-5 airbox, E-6 carb table, porting drawing, gear-teeth sheet |
| `5speed_manual/` owner's manual | 19 | ✅ all | specs pp. 21–22, capacities p. 24, maintenance pp. 13–20, service schedule p. 30 |
| `engine_manual/` | 5 | ✅ all | **empty — captcha placeholders, no content** |
| `parts_4TL6/` (5-speed) | 52 | sampled (1,2,3,4,5) | diagram + part list only; contents mapped |
| `parts_4TL4/` (4-speed) | 52 | sampled (5) | diagram + part list only |
| `rx135_parts_catalogue_4TL1.pdf` | 51 | text list only | part numbers already captured; PDF text not re-parsed |
| Port maps | 2 | ✅ both | dimensioned + undimensioned |

**Conclusion on the manuals:** with the exception of the CR line in the owner's manual (§14 conflict 1),
**every page that carries a number has now been read.** The remaining unread pages are parts diagrams
and owner's-manual operating text that contain no specifications.

---

## 18. Open items, ranked

| Rank | Item | Status | Cheapest closure |
|---|---|---|---|
| 1 | Stock exhaust dimensions | open | tape measure on the silencer |
| 2 | Crankcase volume | open | fill crankcase with oil through the inlet, measure |
| 3 | Ignition advance curve | open | strobe at idle + 3000 / 5000 / 7000 rpm |
| 4 | Exhaust port absolute height (map vs drawing) | open | depth gauge, port top edge to cylinder top face, head off |
| 5 | Rod length | unverified | calipers on a stock rod |
| 6 | Reed spec | open | visual + feeler |
| 7 | Full dyno curve | open | one dyno pull |
| 8 | Squish clearance | open | solder wire |

**With items 1 and 2 closed, the model goes from a calibrated sensitivity tool to a predictive one.**

---

## 19. Housekeeping

The folder currently contains **four duplicate trees** with the same PDF three times, the same two
port-map PNGs four times, and three overlapping parameter datasets that contradict each other on CR
and carburettor. This file supersedes all of them. Recommend archiving everything except
`manuals/` and this file before any code is written, so the model has a single parameter source.
