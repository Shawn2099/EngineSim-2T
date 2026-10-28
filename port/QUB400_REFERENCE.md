# QUB 400 — REFERENCE CASE FOR VALIDATION

Everything the book gives for the QUB 400 single-cylinder research engine, with source line
numbers from
`references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`.

Two OCR conventions in the source that matter when reading Fig.5.3 and the screen dumps:
the degree sign `°` is rendered as `2` in Fig.5.3's headings ("EXHAUST PORT OPENS, 2ATDC"
= "°ATDC", "EXHAUST TEMP, 2C" = "°C"), and `0` inside decimals is frequently lost
(`RATI0-0.854`, `SCAV. RATI0(mass)`).

---

## 1. What the engine is

| Statement | src |
|---|---|
| "a QUB 400 single-cylinder research engine" — one of four worked examples | 9487–9490 |
| "a 250 cc QUB cross scavenged cylinder, called QUBCR" is a **different** test cylinder (the single-cycle scavenging rig), not this engine | 6433–6436 |
| "The exhaust system for the QUB 400 single-cylinder research engine has a short pipe of 200 mm to a generously proportioned silencer box which poses little restriction to the exhaust flow." | 10372–10374 |
| "The silencer for the QUB 400 engine is a generously proportioned device with the box volume twenty-five times larger than the cylinder swept volume, with an outlet pipe equal in area to the inlet pipe from the engine." | 9832–9836 |
| "a large capacity single-cylinder engine which is operating without a tuned exhaust system to aid the scavenging flow" | 10652–10654 |
| The scavenging of the QUB 400 is modelled with **SCRE** (3-port loop, "good scavenging") in §5.2.1, and the comparison in Fig.5.12 also runs UNIFLOW, YAM1, YAM6, QUBCR, CD on the same geometry | 10437–10440, 10521–10529 |
| Chapter 7 re-runs the same geometry at 3000 rpm over throttle ratios 0.15/0.2/0.3/0.4/0.5/1.0 | 15081–15086 |

Swept volume is **never stated as a number**. It follows from bore and stroke:
π/4 × 85² × 70 = **397.0 cm³** (derived, see §9).

---

## 2. Engine dimensions and port data — Fig.5.3, "QUB400" column

Column heading list: src 9559–9595. The QUB400 column of values: src 9596–9632 (one value
per line in the OCR — 36 values, in the same order as the headings).

| Datum (Fig.5.3 heading, src) | QUB 400 value | src of value | Units |
|---|---|---|---|
| BORE, mm (9560) | 85.0 | 9597 | mm |
| STROKE, mm (9561) | 70.0 | 9598 | mm |
| CON-ROD, mm (9562) | 125.0 | 9599 | mm |
| ENGINE SPEED, rpm (9563) | 3000 | 9600 | rev/min |
| EXHAUST TEMP, °C (9564) | 400 | 9601 | °C (pipe *reference* temperature) |
| TRAPPED CR (9565) | 6.7 | 9602 | – |
| CRANKCASE CR (9566) | 1.45 | 9603 | – |
| EXHAUST PORT OPENS, °ATDC (9567) | 96 | 9604 | deg ATDC |
| FULLY OPEN, °ATDC (9568) | 180 | 9605 | deg ATDC |
| NUMBER OF PORTS (9569) | 1 | 9606 | count |
| WIDTH EACH PORT, WE (9570) | 54.8 | 9607 | mm |
| TOP RADIUS, RTE (9571) | 12 | 9608 | mm |
| BOTTOM RADIUS, RBE (9572) | 12 | 9609 | mm |
| TRANSFER PORT OPENS, °ATDC (9573) | 118 | 9610 | deg ATDC |
| FULLY OPEN, °ATDC (9574) | 180 | 9611 | deg ATDC |
| NUMBER OF PORTS (9575) | 6 | 9612 | count |
| WIDTH EACH PORT, WT (9576) | 15.3 | 9613 | mm (effective width per port — see note) |
| TOP RADIUS, RTT (9577) | 3 | 9614 | mm |
| BOTTOM RADIUS, RBT (9578) | 3 | 9615 | mm |
| SCAVENGING TYPE (9579) | VARIOUS | 9616 | string (`UNIFLOW`/`SCRE`/`YAM1`/`YAM6`/`QUBCR`/`CD`) |
| INLET PORT OPENS, °BTDC (9580) | 60 | 9617 | deg **BTDC** |
| FULLY OPEN, °ATDC (9581) | 0 | 9618 | deg ATDC (0 = tdc) |
| NUMBER OF PORTS (9582) | 1 | 9619 | count |
| WIDTH EACH PORT, WI (9583) | 45.0 | 9620 | mm |
| TOP RADIUS, RTI (9584) | 6 | 9621 | mm |
| BOTTOM RADIUS, RBI (9585) | 6 | 9622 | mm |
| TRANSFER LENGTH, T (9586) | 90.0 | 9623 | mm |
| TRANSFER AREA RATIO (9587) | 1.35 | 9624 | – |
| INLET LENGTH, I (9588) | 200.0 | 9625 | mm |
| THROTTLE AREA RATIO (9589) | 1 & 0.25 | 9626 | – (two runs: full & quarter throttle) |
| CARBURETTER DIAMETER, I (9590) | 34.0 | 9627 | mm |
| COMBUSTION EFFICIENCY (9591) | 0.85 | 9628 | – |
| COMBUSTION PERIOD, deg (9592) | 60.0 | 9629 | deg |
| AIR-TO-FUEL RATIO (9593) | 13 | 9630 | – (mass) |
| COMPRESSION INDEX, NC (9594) | 1.25 | 9631 | – |
| EXPANSION INDEX, NE (9595) | 1.35 | 9632 | – |

**Derived port timings** (not printed in Fig.5.3; from the code's own relations, src
27650–27653):
exhaust 96° → 264° ATDC (168° open) · transfer 118° → 242° ATDC (124° open) ·
inlet 300° BTDC→ATDC → 60° ATDC (120° open).

**Note on `WT = 15.3`.** §5.1.1 (src 9809–9814) works an example in which a 3-port cylinder
with 28.6 mm side ports at 5° upsweep and a 30 mm rear port at 55° upsweep is entered as
"number of transfer ports = 3" and "effective port width = [2×28.6×cos(5°) + 30×cos(55°)]/3
= 24.7". The QUB 400's six transfer ports at 15.3 mm are therefore *effective* widths, not
measured chord widths. NOT STATED is the individual upsweep angle of each of the six QUB
400 transfer ports.

---

## 3. Exhaust system — Fig.5.4(a), "QUB400 ENGINE" column

Headings: src 9751–9757 ("QUB400 ENGINE", "CHAINSAW ENGINE", "LEN.1", "DIA.1", "LEN.2",
"DIA.2", "BOX VOLUME, cc"). QUB 400 column: src 9758–9762.

| Datum | Value | src | Units |
|---|---|---|---|
| LEN.1 — inlet pipe length, exhaust port → silencer box | 200 | 9758 | mm |
| DIA.1 — inlet pipe diameter | 38 | 9759 | mm |
| LEN.2 — outlet pipe length | 200 | 9760 | mm |
| DIA.2 — outlet pipe diameter | 38 | 9761 | mm |
| BOX VOLUME | 10000 | 9762 | cm³ |

Consistency: 10000/397.0 = 25.2, matching "twenty-five times larger than the cylinder swept
volume" (src 9835); DIA.1 = DIA.2 matches "outlet pipe equal in area to the inlet pipe"
(src 9836).

QUB 400 is **not** in Fig.5.4(b) — the tuned-pipe table only carries the Husqvarna MK4 and
125 GP (src 9769–9805). The QUB 400 is a Prog.5.1 (box-silencer) case only.

---

## 4. Numerical output that IS stated in the text (not only plotted)

### 4.1 Fig.5.9 — full throttle, 3000 rpm, fifth cycle (boot printout)

The screen dump at src 10393–10426 is printed *text*, not a plot: these are the exact numbers
the program displayed.

| Quantity | Value as printed | src |
|---|---|---|
| Engine speed | 3000 rpm | 10402 |
| Delivery ratio | 0.854 | 10403 |
| Power | 12.2 kW | 10404 |
| BSFC | 0.464 kg/kWh (= 464 g/kWh) | 10405 |
| BMEP | 6.14 bar | 10406 |
| IMEP | 6.72 bar | 10407 |
| PMEP | 0.38 bar | 10408 |
| FMEP | 0.21 bar | 10409 |
| Peak cylinder pressure | 35.8 bar | 10410 |
| Peak cylinder temperature | 2891 K | 10410 |
| Peak-pressure crank angle | printed as "=1"; the text says 16.2° ATDC | 10410 / 10634 |
| Scavenging efficiency | 0.818 | 10421 |
| Trapping efficiency | 0.504 | 10422 |
| Charging efficiency | 0.430 | 10423 |
| Scavenge ratio (mass) | 0.874 | 10424 |
| Scavenge ratio (volume) | 1.134 | 10425 |
| Exhaust flow ratio | 0.876 | 10426 |

> Minor internal inconsistencies in the book: the same run's delivery ratio is quoted as
> 0.854 in the printout (10403) but as "0.851" in the text (10666); and the peak-pressure
> angle in the printout has lost its decimal places. Neither can be resolved from the
> source.

### 4.2 Fig.5.13 — quarter throttle, 3000 rpm, fifth cycle

Same data as Fig.5.9 "with the single exception of setting the throttle area ratio at 0.25
instead of 1.0" (src 10669–10671).

| Quantity | Value as printed | src |
|---|---|---|
| Engine speed | 3000 rpm | 10694 |
| Delivery ratio | 0.491 | 10695 |
| Power | 7.6 kW | 10690 |
| BSFC | 0.426 kg/kWh | 10696 |
| BMEP | 3.85 bar | 10697 |
| IMEP | 4.26 bar | 10691 |
| PMEP | 0.21 bar as printed — but 0.20 bar is intended (see note) | 10698 |
| FMEP | 0.21 bar | 10699 |
| Peak cylinder pressure | 26.6 bar | 10700 |
| Peak cylinder temperature | 2545 K | 10700 |
| Scavenging efficiency | **not legible in this figure**; text gives 0.64 | 10712–10721 / 10680 |
| Trapping efficiency | 0.569 | 10722 |
| Charging efficiency | 0.283 | 10723 |
| Scavenge ratio (mass) | 0.535 | 10724 |
| Scavenge ratio (volume) | 0.735 | 10725 |
| Exhaust flow ratio | 0.536 | 10726 |

> The PMEP entry: the figure line reads "0.21" (10698) while the paragraph says "the pumping
> loss is reduced from 0.38 bar to 0.20 bar" (10732), and the arithmetic 4.26 − 0.20 − 0.21 =
> 3.85 reproduces the printed BMEP exactly, whereas 0.21 does not. Take **0.20**.

### 4.3 Fig.5.12 — scavenging-model comparison at **5000 rpm**

Header: "DATA FOR CALCULATION FROM QUB 400 SINGLE CYLINDER RESEARCH ENGINE AT 5000 rpm"
(src 10521). Columns: EXPT., UNIFLOW, SCRE, YAM1, YAM6, QUBCR, CD (src 10523–10529).

⚠ **This is a different operating point from Figs.5.9/5.13 (3000 rpm).** The Fig.5.3 data
block itself specifies 3000 rpm, so this table was produced by overriding RPM to 5000.

| Quantity | EXPT | UNIFLOW | SCRE | YAM1 | YAM6 | QUBCR | CD | src |
|---|---|---|---|---|---|---|---|---|
| POWER, kW | 12.4 | 12.37 | 12.11 | 11.87 | 11.21 | 12.11 | 10.76 | 10532–10538 |
| IMEP, bar | 6.80 | 6.81 | 6.68 | 6.56 | 6.23 | 6.69 | 6.00 | 10541–10547 |
| BMEP, bar | 6.24 | 6.22 | 6.10 | 5.98 | 5.65 | 6.10 | 5.42 | 10550–10556 |
| BSFC, g/kWh | 437 | 452 | 463 | 473 | 506 | 463 | 531 | 10559–10565 |
| DR | 0.85 | 0.84 | 0.85 | 0.85 | 0.86 | 0.85 | 0.86 | 10567–10573 |
| TEFF | 0.60 | 0.52 | 0.51 | 0.50 | 0.47 | 0.51 | 0.45 | 10582–10588 |
| PMAX, bar | 36.9 | 36.2 | 35.7 | 35.3 | 34.1 | 35.7 | 33.3 | 10598–10604 |

Two rows — **SEFF** and **CEFF** — are damaged: seven columns are defined by the header but
only **six** values survive. They are therefore recorded only in printed order, with no
column assignment claimed:

| Row | Values in printed order | src | Comment |
|---|---|---|---|
| SEFF | 0.84, 0.82, 0.80, 0.75, 0.82, 0.72 | 10575–10580 | one value lost; cannot be reassigned |
| CEFF | 0.44, 0.43, 0.42, 0.40, 0.43, 0.39 | 10590–10595 | one value lost; cannot be reassigned |

Do **not** reconstruct the missing entries. Everything else in the table is self-consistent:
QUBCR ties SCRE exactly on power 12.11 / BMEP 6.10 / BSFC 463, which is what the text claims at
src 10619–10620, and CD's 10.76 vs 12.11 is the "12% power loss" of src 10614.

**Cross-check with the text:** "from the best to the worst of loop scavenging, i.e. from an
SCRE to a YAM6 type … the variation in power is from 12.1 to 11.2 kW, i.e. an 8% drop. The
consequential change in specific fuel consumption is from 463 to 506 g/kWh, i.e. a 9%
deterioration" (10503–10506) — matches the SCRE/YAM6 columns exactly.

---

## 5. Values stated only in the running text (with line numbers)

| Statement | Value | src |
|---|---|---|
| Exhaust downpipe length to the silencer | 200 mm | 10372–10373 |
| Silencer box = 25 × swept volume; outlet pipe area = inlet pipe area | 25×, equal | 9835–9836 |
| Delivery ratio "is high, at 0.86" | 0.86 | 10652 |
| "the DR, SR and exhaust flow ratio values are 0.851, 0.876 and 0.876" | 0.851 / 0.876 / 0.876 | 10666–10667 |
| Peak cylinder pressure measured vs calculated | 36.9 bar vs 35.7 bar | 10627–10628 |
| Peak cycle pressure crank angle | 16.2° ATDC, "corresponds precisely with the experimental data" | 10634–10635 |
| Quarter throttle: air flow falls "from 0.85 to 0.49" | 0.85 → 0.49 | 10673 |
| Quarter throttle: SRv down from 1.13 to 0.73 | 1.13 → 0.73 | 10679 |
| Quarter throttle: scavenging efficiency down from 0.82 to 0.64 | 0.82 → 0.64 | 10679–10680 |
| Quarter throttle: trapping efficiency up from 0.51 to 0.57 | 0.51 → 0.57 | 10680–10681 |
| Quarter throttle: pumping loss 0.38 → 0.20 bar; friction constant at 0.21 | 0.38 → 0.20; 0.21 | 10731–10732 |
| Quarter throttle: power 12.2 → 7.6 kW, BMEP 6.1 → 3.8 bar | 12.2 → 7.6; 6.1 → 3.8 | 10745–10746 |
| Quarter throttle: BSFC improves 15%, 463 → 426 g/kWh | 463 → 426 | 10747–10748 |
| Experimental comparison at QUB "15% would have been observed for power and fuel consumption changes for those same scavenging types" | 15% | 10507–10509 |
| CD loses 12% power and 13% BSFC to SCRE | 12% / 13% | 10614 |
| Combustion efficiency and period for the four engines were "determined from the experimental work with the QUB 400 engine in Sect. 4.2.3" | BE = 0.85, period = 60° | 10087–10089 |
| Trapped air-fuel ratio 13.0 "is the experimentally determined value for the QUB 400" | 13.0 | 10094–10095 |
| Polytropic indices "recommended in Sect. 4.3.1 for general use" | nc = 1.25, ne = 1.35 | 10092–10093 |
| Chapter 7: the same data in a three-cylinder engine gives BMEP 8.61 bar and bsfc 0.344 kg/kWh, vs 6.22 bar / 0.462 kg/kWh as a single | 8.61 / 0.344; 6.22 / 0.462 | 11743–11748 |
| Chapter 7: same geometry at 3000 rpm, throttle ratios 0.15, 0.2, 0.3, 0.4, 0.5, 1.0, SCRE and YAM6 | list of settings only | 15081–15086 |

Note that the Chapter 7 single-cylinder figures (6.22 bar, 0.462 kg/kWh at *some* speed, with
scavenging model No.2 rather than No.1 — src 15090–15092) are a **third** operating point and
should not be mixed with Fig.5.9's 6.14 bar / 0.464.

---

## 6. NOT STATED

| Item | Status |
|---|---|
| **Torque** | NOT STATED anywhere for the QUB 400 in Chapter 5 (the shared nomenclature table lists `BTRQ` in N·m, src 11850/11874, but no value is given for this engine) |
| **Swept volume** as a number | NOT STATED (derivable: 397.0 cm³) |
| **Clearance volume / geometric compression ratio** | NOT STATED (only the *trapped* CR, 6.7) |
| **Crankcase volume** as a number | NOT STATED (only CCR = 1.45) |
| Indicated or brake power at any speed other than 3000 rpm (Figs.5.9/5.13) and 5000 rpm (Fig.5.12) | NOT STATED numerically |
| Fuel mass flow, air mass flow in kg/s, absolute (only delivery ratio) | NOT STATED |
| Exhaust gas temperature, measured | NOT STATED (400 °C is the *reference* temperature input) |
| Ignition timing | deliberately not an input (§5.1.4, src 10109–10120) |
| Individual transfer-port areas, upsweep angles, and the port plan layout | NOT STATED for the QUB 400 specifically |
| Exhaust port height (top edge to bottom edge, mm) | NOT STATED — only the timings and the two corner radii |
| A measured pressure–crank-angle trace in digital form | NOT STATED; only the screen plots |
| bmep / bsfc / torque at part load other than 0.25 throttle | NOT STATED numerically |

---

## 7. Output that exists only as figures

These carry quantitative information but **no printed numbers**; digitising them is the only
way to use them:

| Figure | Content | src of caption |
|---|---|---|
| **Fig.5.9** | Cylinder / crankcase / exhaust-port pressure ratio vs crank angle, full throttle, 5th cycle. ⚠ the *numbers* are printed in the same figure (see §4.1), so this one is usable | 10427–10428 |
| **Fig.5.10** | Scavenging efficiency SE and scavenge ratio by volume SRv vs crank angle from transfer opening, for SCRE, YAM6 and CD | 10454 |
| **Fig.5.11** | Scavenge ratio by mass and by volume vs crank angle, SCRE/YAM6/CD | 10499 |
| **Fig.5.12** | Scavenging-model comparison — ⚠ this is a **table**, not a plot; all values are printed (§4.3) | 10605–10607 |
| **Fig.5.13** | Quarter-throttle screen dump — numbers printed (§4.2) | 10727–10728 |
| Fig.5.5, 5.6, 5.7 | cV, cP and γ vs temperature for air and exhaust gas (engine-independent) — described at src 9898–9908 | — |
| Fig.7.13, 7.14 | Predicted BMEP/BSFC/TE/SE vs throttle area ratio, 3000 rpm, SCRE & YAM6 — **graphs only, no numbers** | 15130–15169 |

---

## 8. Usable numeric validation set — summary

| Operating point | Data available | Sufficient to validate a model? |
|---|---|---|
| 3000 rpm, full throttle (THAR=1.0), Prog.5.1, SCRE, Eq.5.1.11 | power, BSFC, BMEP, IMEP, PMEP, FMEP, DR, SE, TE, CE, SR mass, SR vol, exhaust-flow ratio, Pmax, Tmax — **16 numbers** plus complete geometry | **Yes — the single best validation case in the book** |
| 3000 rpm, quarter throttle (THAR=0.25) | same set, except SE (0.64 from text) and PMEP (0.20 from arithmetic) | Yes, with those two substitutions |
| 5000 rpm, seven scavenging models | power, IMEP, BMEP, BSFC, DR, TEFF, PMAX complete; SEFF and CEFF one value short | Partly — power/BSFC/BMEP/PMAX fully usable, SE/CE not |
| "EXPT." column of Fig.5.12 | measured power 12.4 kW, IMEP 6.80, BMEP 6.24, BSFC 437 g/kWh, DR 0.85, SE 0.84, TE 0.60, CE 0.44, Pmax 36.9 bar at 5000 rpm | Yes — this is the **bench data** to correlate against |

**Bottom line:** QUB 400 has a complete, self-consistent *numeric* input set — the 36
entries tabulated in §2 (35 numbers plus the `SCAVENGING TYPE` string, with `THAR` holding
two values, 1 and 0.25) and the 5 box numbers of Fig.5.4(a) — and two full 16-channel numeric
outputs at 3000 rpm (Figs.5.9, 5.13), plus a 7-column table at 5000 rpm (Fig.5.12). It does
**not** have a torque figure or any multi-speed sweep in numeric form. Validation must
therefore be done at the two fixed 3000 rpm points and the single 5000 rpm point, not as a
speed sweep.

---

## 9. Derived cross-checks (arithmetic on the book's numbers — NOT values from the book)

Offered only to show the input set is coherent; none of these numbers is printed in the text.

| Derived quantity | Calculation | Result | Versus book |
|---|---|---|---|
| Swept volume | π/4 × 0.085² × 0.070 | 3.9696E-4 m³ = 397.0 cm³ | 10000/397 = 25.2 ✓ (src 9835) |
| FMEP from the code's law `100*STM*RPM` | 100 × 0.070 × 3000 | 21 000 Pa = 0.21 bar | 0.21 bar ✓ (10409) |
| BMEP from the other MEPs (full throttle) | 6.72 − 0.38 − 0.21 | 6.13 bar | 6.14 ✓ (10406) |
| BMEP from the other MEPs (quarter throttle) | 4.26 − 0.20 − 0.21 | 3.85 bar | 3.85 ✓ (10697) |
| Power from BMEP (full throttle) | 6.14E5 × 3.9696E-4 × (3000/60) | 12.19 kW | 12.2 ✓ (10404) |
| Power from BMEP (quarter throttle) | 3.85E5 × 3.9696E-4 × 50 | 7.64 kW | 7.6 ✓ (10690) |
| **Torque** at 3000 rpm full throttle | P/ω = 12200/(2π×50) | **38.8 N·m** | NOT STATED in book |

The last line is the only way to obtain a QUB 400 torque datum: it must be back-calculated
from the printed power, and it is exact only to the rounding of "12.2 kW".

---

## 10. Cautions for using this as a validation case

1. **Two different speeds, one data table.** Fig.5.3 says 3000 rpm; Fig.5.12 says 5000 rpm.
   The 5000 rpm table can only be reproduced by overriding `RPM`.
2. **Two different scavenging equations.** §5.2.1 (Figs.5.9–5.13) uses the *first* model,
   Eq.5.1.11, as the book states explicitly: "in the earlier exposition in Chapter 5, Eq.
   5.1.11 is used for the analysis of behavior of the QUB 400 engine" (src 15090–15092); the
   code comments confirm it ("SCAVENGING MODEL NO.1 … REM Eqn.5.1.11 is being programmed
   here", src 27728–27729). Chapter 7's re-run uses Eq.5.1.13 instead. The two models differ
   in the expansion term EXPAND used to convert duct volume flow into cylinder volume flow,
   and the text blames exactly that difference for the TE mismatch against experiment
   (src 10624–10625). **Any reproduction must state which model it used.**
3. **TE is the known weak point.** Calculated 0.51 vs measured 0.60 at 5000/SCRE
   (10582–10584) — a 15% discrepancy that the book itself concedes.
4. **Peak pressure is the strongest validation channel**: 35.7 bar calculated vs 36.9 bar
   measured, at a crank angle of 16.2° ATDC which "corresponds precisely with the
   experimental data" (10627–10635).
5. **`SCAV$` must be exactly `SCRE`** to reproduce these figures; any other string silently
   produces SE=0 (see `INPUT_FORMAT.md` §2, block 3).
6. The "EXPT." column is measured at 5000 rpm while the only measured-adjacent printouts in
   Figs.5.9/5.13 are at 3000 rpm, so a single-speed model cannot be validated against both at
   once.
