# Reference extraction — what is usable, and one uncomfortable finding

Extracted 2026-10-28 from `references/`. Only items that produce numbers we can
use are included. Sources are named so every figure is traceable.

---

## 1. Blair's specific time-area method — an independent check on the porting

**Source:** G.P. Blair, *The Basic Design of Two-Stroke Engines* (SAE), §6.1,
Eqs. 6.1.7–6.1.12, pp. 258–264.

**Definition (Eq. 6.1.12):**

```
specific time area, s/m  =  Σ(A·dθ) / (RPS · 360 · SV)
```

with A in m², SV in m³, θ in degrees. Blair notes that entering A in **mm²** and
SV in **cc** is self-correcting and also gives s/m.

**Empirical correlations (BMEP in bar, STA in s/m):**

| Port | Equation | Blair eq. |
|---|---|---|
| Inlet | BMEP = 774·INTA − 1.528 | 6.1.7 |
| Transfer, upper band | BMEP = 2400·TRTA1 − 9.66 | 6.1.8 |
| Transfer, lower band | BMEP = 587·TRTA2 + 0.128 | 6.1.9 |
| Exhaust | BMEP = 1050·EXTA − 5.975 | 6.1.10 |
| Blowdown | BMEP = 8187·BLOWTA + 1.75 | 6.1.11 |

**Calibration points Blair publishes (p. 264):**

| Engine | rpm | EXTA | BLOWTA | TRTA | INTA | BMEP from fit |
|---|---|---|---|---|---|---|
| Chainsaw | 8000 | 0.00907 | 0.00032 | 0.00534 | 0.00965 | 3.55 (actual ≈4) |
| GP 125 | 11500 | 0.01549 | 0.00095 | 0.00776 | 0.01570 | 10.29 (actual ≈10.6) |

The fit is calibrated to pass through both, so it is only credible **inside
roughly 3.5–10.5 bar**. Treat anything outside as a flag, not a prediction.

---

## 2. Applied to the RX135 (step-2 time-areas, at 7500 rpm)

Inputs: Σ(A·dθ) exhaust **103 038** mm²·deg, blowdown **5 653**, transfers
**112 880**; SV 132.104 cc; RPS 125.

| Quantity | Ours at 7500 rpm | Blair fit predicts |
|---|---|---|
| EXTA 0.01733 s/m | — | **12.22 bar** (outside band) |
| BLOWTA 0.00095 s/m | — | 9.54 bar |
| TRTA 0.01899 s/m | — | outside band both ways (11.3 lower / 35.9 upper) |

**Required time-area for the BMEP the bike actually produces (6.30 bar):**

| Port | Required Σ(A·dθ) | Actual | Excess |
|---|---|---|---|
| Exhaust | 69 500 mm²·deg | 103 038 | **+48 %** |
| Blowdown | 3 300 | 5 653 | **+71 %** |
| Transfer (lower band) | 62 500 | 112 880 | **+81 %** |

### Reading

The porting in the 4TL10 map carries roughly **1.5× (exhaust) to 1.8×
(transfers) more time-area than Blair's criterion requires for a 6.3 bar
engine at 7500 rpm.** Inverting the fits, the same porting is matched to a
6.3 bar engine at **≈11 100 rpm (exhaust), ≈12 800 rpm (blowdown), ≈13 500 rpm
(transfers)**.

Two compatible explanations, both testable:

1. **The map is a tuned/racing porting spec, not the stock cylinder.** It is
   already suspicious on other grounds: its port tops sit 2.7 mm above the
   factory porting drawing (§5.3 of the parameter file), and it is titled
   "RX135/**Z**".
2. **The stock cat-con pipe is the restriction.** A restrictive pipe costs
   BMEP directly; the ports may be perfectly adequate but the pipe cannot
   empty and plug. Blair's correlations are calibrated on engines with
   functioning expansion chambers.

Consequence for the model: if the map is a racing spec, calibrating to 10.4 kW
will force a low scavenge/combustion efficiency to compensate, and **every
port-timing sweep will be a sensitivity around a possibly wrong baseline.**
The port-height sweep band (173–190°) partially covers this, but only
partially — it covers timing, not area.

**Discriminating measurement (30 min, barrel off):** port window widths and
heights on the actual cylinder. If the real transfers total ~90 mm of width
rather than the map's 113 mm, the map is not stock.

---

## 3. Blair's empirical expansion-chamber design — better than our placeholder

**Source:** Blair, *Design and Simulation of Two-Stroke Engines* (SAE), §6.2,
Eqs. 6.2.4–6.2.12, pp. 441–444.

**Tuned length** (piston face to tail-pipe entry), mm:

```
LT = 83.3 · a0 · θep / rpm          (6.2.4)
a0 = sqrt(γ·R·(Texh + 273))          (2.1.1)
```

`83.3 = 1000/12`, so this is **identical to the placeholder formula already in
use** (L = a·Ed/12N). That is a useful independent confirmation of the form;
what we gain is the segment proportioning and diameters.

**Segment lengths as fractions of LT** (they sum to 1.00 without the tail-pipe):

| Segment | Fraction |
|---|---|
| L1 first pipe | 0.100 |
| L2 diffuser stage 1 | 0.275 |
| L3 diffuser stage 2 | 0.183 |
| L4 | 0.092 |
| L5 mid-section | 0.110 |
| L6 rear cone | 0.240 |
| L7 tail-pipe | = L6 |

**Diameters from the exhaust port equivalent diameter** `d0 = sqrt(4A_ex/π)`:

| Item | Enduro (broad) | Road racing |
|---|---|---|
| Header d1 | 1.125·d0 | 1.05·d0 |
| Belly d4 (= d5) | 2.125·d0 | 3.25·d0 |
| Tail-pipe | 0.70·d0 (≤8 bar) | 0.65·d0 (9 bar), 0.60·d0 (11 bar) |

Blair's guidance: 500 °C exhaust gas for an enduro-class engine, 600 °C for GP.

**Applied to the RX135** (A_ex 842 mm² → d0 = 32.7 mm; enduro coefficients,
Texh 500 °C → a0 = 557 m/s):

| Item | Map duration 185.7° | Factory 173.3° |
|---|---|---|
| LT | **1149 mm** | 1073 mm |
| L1 / L2 / L3 / L4 | 115 / 316 / 210 / 106 | 107 / 295 / 196 / 99 |
| L5 / L6 / L7 | 126 / 276 / 276 | 118 / 257 / 257 |
| Header ID | 36.8 mm | same |
| Belly ID | 69.6 mm | same |
| Stinger ID | 22.9 mm (0.70 d0) | same |

Our current placeholder uses 25/35/15/25 split and a1 = 500 m/s giving 1032 mm.
Blair's version is 1149 mm with a two-stage diffuser, which is both more
realistic and properly sourced. The 22.9 mm stinger is large — that is Blair's
deliberate choice for a low-BMEP engine that must empty easily, and it is
consistent with a restrictive stock silencer.

---

## 4. Cross-check on trapped compression ratio

**Source:** *Study of the effects of trapped compression ratio…* (2022),
Aircraft Engineering and Aerospace Technology, AEAT-07-2021-0220.

A crankcase-scavenged SI two-stroke UAV engine runs geometric CR **9.2:1** and
**trapped CR 6.74:1** — a ratio TCR/CR = **0.73**.

Ours: geometric 10.1, trapped 5.91 → ratio **0.585**.

Not an error — it follows directly from our exhaust port closing 27 mm down a
50 mm stroke — but it says our engine traps a *smaller* fraction of the stroke
than that reference engine, i.e. relatively high exhaust porting again. Same
signal as §2. Worth one line in the model documentation; no parameter change.

---

## 5. What in `references/` is not useful for this engine

| Item | Why |
|---|---|
| Marine uniflow papers (IOP 2024, Frontiers 2022, 2016 Brunel) | Uniflow-scavenged, exhaust-valved, typically diesel. Scavenging efficiencies quoted 96–97 % are not transferable to crankcase-scavenged loop scavenging. |
| 2018 extended mean-value marine diesel model | Different architecture; mean-value anyway. |
| 2025 UAV crankcase-scavenged efficiency paper | Closest in architecture; useful for qualitative trends, no numbers we can adopt. |
| Heywood, Pulkrabek | General IC engines, almost nothing two-stroke specific. Useful for Wiebe/heat-transfer forms only. |
| `port_timing_formula_notes.md` | Correct, but covered by the model already. |

---

## 6. Scavenging framework — replaces the two-loss heuristic

**Source:** Blair, *Design and Simulation of Two-Stroke Engines*, §1.5 and §3.1,
pp. 27–29 and 212–216.

Blair's definitions, which must not be mixed:

```
DR  delivery ratio        = delivered fresh / reference mass
SE  scavenging efficiency = trapped fresh / total trapped mass
TE  trapping efficiency   = trapped fresh / delivered fresh
CE  charging efficiency   = trapped fresh / reference mass
```

Consistency relations:

```
CE = TE · DR = SE          (ideal, m_trapped = m_reference)
TE = SE / DR
```

**Two ideal limits (Hopkinson):**

| Process | SE | TE |
|---|---|---|
| Perfect displacement | SE = SR for SR<1; SE = 1 above | 1 |
| Perfect mixing (Eq. 3.1.19) | **SE = 1 − e^(−SR)** | (1−e^(−SR))/SR |

**Benson–Brandham blend (Eq. 3.1.21):** perfect displacement up to a break
point SR_pd, then perfect mixing to the end. One shape parameter, SR_pd.

**Why this matters for step 3.** The step-3 model applies a short-circuit
fraction (1−η) *and* a mixing loss on the transfer path. That is two losses
describing one physical process, and it is why achieved SE collapses to 0.43
at 7500 rpm and 0.17 at 2000 rpm while power still lands on the anchor. Blair's
framework gives exactly one degree of freedom: pick the blend (or SR_pd), and
SE follows from SR, TE follows from SE/SR. The short-circuit mass is then
*defined* as delivered − trapped fresh, not applied as a second penalty.

Sanity anchor: at DR ≈ 0.955, perfect mixing gives SE = 1 − e^(−0.955) =
**0.615** and perfect displacement gives 0.955. A real Schnürle loop-scavenged
engine sits between, nearer the mixing limit. Anything below ~0.6 at that DR
is a modelling artefact, not a scavenging result.

---

## 7. Three diagnoses of the step-3 flags, from these sources

### 7.1 Power peak at 8000 rpm instead of 7500 — a pipe/temperature inconsistency

Blair's Eq. 6.2.4 and Eq. 2.1.1 are coupled: the length must be computed from
the sound speed **at the mean pipe temperature**. The placeholder used
a0 = 500 m/s, which corresponds to only **349 °C**. If the model's pipe gas is
near Blair's 500 °C enduro value (a0 = 557 m/s), then the same 1032 mm length
tunes at

```
N = 83.3 · 557 · 185.66 / 1032 = 8347 rpm
```

which brackets the observed 8000 rpm peak. The pipe length is not wrong in
isolation — it is inconsistent with the gas temperature the solver computes.

**Fix:** set L from the model's own mean exhaust temperature each run, or
recompute L with Blair's coefficients and hold the temperature assumption
explicit. Do not leave a0 and Te as independent assumptions.

### 7.2 p_trap 2.09 bar, DR 0.955, +55.2 % trapped mass from the pipe — over-plugging

Blair's empirical diameters for an engine of this class: header 1.125·d0,
belly 2.125·d0, tail-pipe 0.70·d0 (≤8 bar). With d0 = 32.7 mm that is
**69.6 mm belly and 22.9 mm stinger**. The placeholder runs a **90 mm belly and
16 mm stinger** — a much larger area ratio and a much tighter stinger, i.e. far
stronger plugging. Blair also notes a real pipe produces a trapped-mass gain of
order 20–30 %; the model gets 55.2 %, which is the same over-plugging seen from
the other end.

### 7.3 The high DR is consistent with §2 — the ports are oversized

DR 0.955 at the top of the band, p_trap 2.09 bar, BSFC 518 g/kWh — all three
say the engine is trapping too much charge at too high a pressure. That is what
oversized porting does, and §2 measured it independently: +48 % exhaust and
+81 % transfer time-area against Blair's criterion for 6.3 bar.

**So the four loud flags are one coherent story**: oversized ports deliver more
charge than a 6.3 bar engine can use, an over-plugging invented pipe traps it
at 2 bar instead of 1.4, and a double-counted scavenge model then throws most
of it away at low speed. Each has a literature-grounded fix, and none of them is
a calibration knob.

---

## 8. Recommended use

1. Add the specific time-area check as a **screening gate**, not a calibration
   target: if the model's delivered BMEP ever exceeds ~10 bar at 7500 rpm, the
   port geometry and the power anchor are inconsistent.
2. Replace the placeholder pipe with Blair's proportions and diameters (§3).
   It remains CALIBRATED/ASSUMED — the shape is still invented — but it is now
   invented from a 60-year-old empirical method rather than a round-number
   split.
3. Treat the 48 %/81 % time-area excess as an **open question about the map's
   provenance**, recorded in the parameter file, not as an error to be
   corrected by tuning.
