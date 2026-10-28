# Verification of the RX135 parameter set against the reference literature

Date: 2026-10-28. Sources actually used: Blair *Design and Simulation of
Two-Stroke Engines* (D&S), Blair *The Basic Design of Two-Stroke Engines*
(BD), Heywood 2nd ed., and the 2022 trapped-CR paper in `references/`.
Every entry below was read from the extracted text, not recalled.

Legend: ✓ confirmed · ≈ consistent but at the edge of a literature range ·
✗ contradicted · ? unverifiable from the literature

---

## 1. Verified table

| # | Parameter | Ours | Literature | Verdict |
|---|---|---|---|---|
| 1 | Bore × stroke | 58 × 50 mm | — | ✓ arithmetic |
| 2 | Displacement | 132.10 cc | — | ✓ |
| 3 | Geometric CR | 10.1 : 1 | road 2-strokes 8–12; Blair's racing 125 ≈ 14 | ≈ plausible |
| 4 | Head volume | 15.9 cc | — | ✓ factory |
| 5 | Trapped CR | 5.91 | Blair quotes 6.62, 7, 8, 9 (D&S §5.5) | ≈ low end, consistent with a 186° exhaust |
| 6 | Deck clearance | 0.8 mm | — | ✓ derived from the factory porting drawing |
| 7 | Squish clearance | not measured | Blair's model input block: **1.5 mm** | ? use 1.5 mm as the placeholder |
| 8 | Exhaust duration | 185.7° | Blair's racing 125: 200°; road engines ~170–180° | ≈ high for a road engine |
| 9 | Transfer duration | 131.3° | Blair's racing 125: 132° | ≈ **racing timing** |
| 10 | Blowdown | 27.2° | 25–30 typical | ✓ |
| 11 | Exhaust width / bore | 0.672 | ring-support limit ≈ 0.65–0.70 | ✓ at the limit |
| 12 | **Transfer width ratio Cpb** | **1.95** | Blair Eq. 3.5.1: "difficult to raise much in excess of **1.25** for loop- and cross-scavenged engines" | ✗ **far over** |
| 13 | Specific time area EXTA | 0.0173 s/m | Blair: chainsaw 0.00907, GP 0.01549 | ✗ above a GP engine |
| 14 | Crankcase CR | 1.343 | Blair's 125 cc reference: 1.35 | ✓ |
| 15 | **Friction** | 0.618 bar (1.30 Nm) | Blair Eq. 5.4.2 "motorcycles, etc.": **0.394 bar (0.83 Nm)** | ✗ **57 % high** |
| 16 | Burn duration | 45° CA | Blair's models: 41, 43, 45, 49, 64° | ✓ |
| 17 | Combustion efficiency | 0.95 | Heywood: 0.95–0.98 | ✓ |
| 18 | BMEP at the anchor | 6.30 bar | Blair's classes: 3.75 chainsaw, 8 enduro, 9 MX, 11 GP | ✓ |
| 19 | BSFC | 405 g/kWh @ 6.30 bar | Blair: **435 g/kWh @ 6.28 bar** | ✓ |
| 20 | Mean piston speed | 12.5 m/s | normal | ✓ |
| 21 | Pipe tuned length | 1172 mm | Blair Eq. 6.2.4 with Texc 450–480 °C → **1127 mm** | ✗ 4 % long |
| 22 | Pipe diameters | 36.8 / 69.6 / 22.9 mm | Blair: 1.125·d0 / 2.125·d0 / 0.70·d0 | ✓ |
| 23 | Connecting rod | 98 mm | Blair's comparable 125: 110 mm | ? unmeasured |

---

## 2. The four contradictions, and what they mean

### 2.1 Friction is 57 % too high (correctable now)

Blair Eq. 5.4.2, explicitly labelled "motorcycles, etc.":

```
fmep = 105 · Lst · N   =  105 × 0.050 × 7500  =  39 375 Pa  =  0.394 bar
```

0.394 bar = **0.828 Nm** at this displacement. The model uses **1.30 Nm (0.618 bar)**,
which sits between Blair's *industrial* line (0.563 bar) and his *plain-bearing*
line (0.719 bar) — neither applies to a rolling-bearing motorcycle engine.

Correcting it **adds 371 W** to brake power. The model's over-prediction is
therefore larger than reported, not smaller.

### 2.2 Transfer port width ratio 1.95 vs a practical limit of 1.25

Blair Eq. 3.5.1 defines `Cpb = Σ(port widths)/bore` and states that for loop- and
cross-scavenged engines it is difficult to exceed **1.25**.

```
our transfers: 25 + 19 + 25 + 19 + 25 = 113 mm on a 58 mm bore -> Cpb = 1.95
even with a 0.7 effective-width factor                            -> Cpb = 1.36
```

This is a **mechanical** limit (inter-port bar strength, ring support), independent
of any simulation. It says the transfer windows in the port map are substantially
wider than a production loop-scavenged cylinder can carry.

### 2.3 Time area exceeds a 1988 GP 125

EXTA 0.0173 s/m against Blair's GP value of 0.01549. Consistent with §2.2: the
porting carries more flow area than a racing engine of the same class.

### 2.4 Pipe tuned length is 4 % long

Blair (D&S §6.2) guides exhaust temperature by BMEP: below 5 bar → 350–450 °C;
enduro (8 bar) → 500 °C; GP (11 bar) → 600 °C. At 6.3 bar, 450–480 °C is right,
giving **LT = 1127 mm**, not 1172 mm (which assumed 530 °C).

---

## 3. What the contradictions add up to

Three independent checks now agree that the port geometry is hotter than a
6.3 bar road engine:

| Check | Result |
|---|---|
| Specific time area | +48 % exhaust, +81 % transfer vs a 6.3 bar requirement |
| Transfer width ratio | 1.95 vs 1.25 |
| Transfer timing | 131° — identical to Blair's racing 125 |

Scaling the transfer widths to Cpb = 1.25 (113 → 72.5 mm, ×0.64) drops the transfer
time area to ≈ 0.0122 s/m, against 0.0105 required for 6.3 bar — within 16 %.
That single geometric correction brings the transfers into the right band, which is
further evidence that the widths in the map are not production values.

**Conclusion:** the port map is most likely a tuned/racing dimension set, not the
stock 4TL10 cylinder. This is now supported by a mechanical limit rather than by
simulation output alone.

---

## 4. Corrections to apply

| Item | From | To | Basis |
|---|---|---|---|
| Friction torque @ 7500 | 1.30 Nm | **0.828 Nm** | Blair Eq. 5.4.2 |
| Pipe temperature / LT | 530 °C / 1172 mm | **470 °C / 1127 mm** | Blair §6.2 guidance |
| Squish clearance | unset | **1.5 mm** placeholder | Blair model input |
| Transfer widths (test only) | 113 mm | 72.5 mm (Cpb 1.25) | Blair Eq. 3.5.1 |

Note the friction change is not a tuning knob: it moves the model *away* from the
anchor. That is the honest direction.

---

## 5. What the literature cannot verify

| Item | Why |
|---|---|
| Connecting rod 98 mm | no manual or catalogue states it |
| Port heights (27.0 vs 29.7 mm) | the two sources disagree; literature gives no stock figure |
| Cat-con outlet diameter | not in any text; must be measured |
| Ignition advance curve | no source; static 19.5° is factory |
| Crankcase volume 385 cc | consistent with CR 1.35 but not measured |

---

## 6. Reproducibility

Extracted text of all sources: `%TEMP%\opencode\refs\*.txt`
(produced with PyMuPDF from `references\*.pdf`). Page references above are the
book's printed page numbers where visible in the extract.
