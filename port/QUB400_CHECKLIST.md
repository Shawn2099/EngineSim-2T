# QUB 400 — expected-output checklist for Prog.5.1

Companion to `QUB400_INPUT.dat` (the input deck) and `UFLO_GENERATION.md`.
All "src NNNNN" are line numbers in
`references/text/Blair,_G.P._—_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`.

---

## 0. Two things to settle before comparing anything

### 0.1 The deck is 42 values, not 48 — and that is correct for Prog.5.1

`QUB400_INPUT.dat` holds **42** entries: **40 numeric + 2 strings (`SCAV$`, `SIL$`)**.

The "48 entries (47 numeric + 1 string)" figure belongs to **Prog.5.2**, which takes six
exhaust-pipe lengths + six diameters (`LP01…LP56`, `DEP1…DEP6`, 12 numbers) and no silencer
type. Prog.5.1 replaces those twelve numbers with the box-silencer block — five numbers plus
`SIL$` — so:

```
7 (engine) + 6 (exhaust port) + 7 (transfer port incl. SCAV$) + 6 (inlet port)
+ 6 (exhaust box: LEP1, DEP1, LEP2, DEP2, VBOX, SIL$) + 2 (transfer pipe)
+ 3 (inlet pipe) + 5 (combustion)                       = 42
```

The prompt blocks themselves are **not printed in the Prog.5.1 listing**. The 5.1 listing runs
src 26032–26840 ("COMPUTER PROGRAM PROG.5.1", 26032) and ends at `FILED:` (26828–26840); it
contains `EXPIPDAT`, `DATASET`, the solver and the graphics, but `ENGINEDAT`, `EXPORTDAT`,
`TRPORTDAT`, `INPORTDAT`, `TRPIPDAT`, `INPIPDAT` and `COMBDAT` appear only once in the book, in
the Prog.5.2 listing (27224–27933) — they are shared. Prog.5.1's own `.BOX` record order at
26820–26825 confirms the field set and order. This is exactly the caveat already recorded in
`INPUT_FORMAT.md` §2: "For Prog.5.1 the total is 40 numeric + 2 strings, because it takes five
box dimensions (`LEP1, DEP1, LEP2, DEP2, VBOX`) plus `SIL$` instead of the twelve tuned-pipe
numbers."

### 0.2 Three field-order traps (Fig.5.3 is not in prompt order)

`QUB400_INPUT.dat` is in **prompt** order. Copying Fig.5.3 top-to-bottom will silently
mis-assign these:

| Block | Program asks | Fig.5.3 prints | src of prompt / of figure |
|---|---|---|---|
| 1 | `TCR`, `CCR`, **`TEXC`** | EXHAUST TEMP, TRAPPED CR, CRANKCASE CR | 27810–27821 / 9564–9566 |
| 7 | `LTP`, `TRAR`, `LIP`, **`DIP`**, **`THAR`** | LENGTH.T, TRANSFER AR, LENGTH.I, **THROTTLE AR**, **CARB. DIA.** | 27579–27605 / 9586–9590 |
| 9 | **`NC`, `NE`**, `BEFF`, `BDEG`, `TAF` | COMB. EFF, COMB. PERIOD, A/F, **COMP. INDEX, EXP. INDEX** | 27613–27645 / 9628–9632 |

Block 9 is the trap that matters most: Fig.5.3's last two numbers are 1.25 and 1.35 (the
polytropic indices), but they are the **first** two values the program asks for.

Also: `SIL$` is not typed as a string. The prompt is
`INPUT"IS THE MUFFLER OF THE ABSORPTION TYPE(Y/N?)";ANS$` with `SIL$="PLAIN BOX"` presettable
(26450–26452), so the QUB 400 answer is **`N`** — the deck's line 32. `SCAV$`, by contrast, is a
literal string compared exactly (27897); it must be `SCRE` and nothing else.

### 0.3 Typing protocol

The deck is a value list, not a keystroke macro. Each of the eight blocks is entered by answering
`Y` to the block prompts at 26072–26093, then answering `Y` to the
`INPUT "NEW DATA FOR <item>(Y/N?)"` gate in front of **every** value (the gate is only offered so
a value can be skipped; answering `N` leaves the old value in place). Each block ends with
`INPUT "MORE DATA,(Y/N?)"` — answer **`N`** once, or the block restarts from its top.

After the eighth block, `GOSUB DATASET` echoes the whole set (26463–26523) and asks `OK?.(Y/N)`;
the answer is **not tested** (26522–26523), so a mistyped `N` will not stop the run — the echo is
the only check you get. Then `TYPE 'RUN' FOR CALCULATION` (26094).

Two silent-failure modes worth watching on the echo:

* `SCAV$` echoed as anything other than `SCRE` → `MSC`/`CSC` remain 0 → `SEFF = 1 - EXP(0) = 0`
  for every cycle, with no error message.
* `TCR`/`CCR`/`TEXC` in the wrong columns → the `TRAP-CR CRANKCASE-CR TEXC` line (26473) will not
  read `6.70  1.45  400.00`.

---

## 1. Case A — 3000 rpm, full throttle, `THAR = 1.0`, 5th cycle

Fig. 5.9 (caption 10427–10428). All values are **printed text** in the screen dump, not read off
a plot. Model: Prog.5.1, `SCRE`, scavenging model No.1 (Eq. 5.1.11 — see §6.3).

| # | Quantity | Expected | Figure | src |
|---|---|---|---|---|
| 1 | Engine speed, rpm | 3000 | 5.9 | 10402 |
| 2 | Delivery ratio | 0.854 | 5.9 | 10403 |
| 3 | Power, kW | 12.2 | 5.9 | 10404 |
| 4 | BSFC, kg/kWh | 0.464 (= 464 g/kWh) | 5.9 | 10405 |
| 5 | BMEP, bar | 6.14 | 5.9 | 10406 |
| 6 | IMEP, bar | 6.72 | 5.9 | 10407 |
| 7 | PMEP, bar | 0.38 | 5.9 | 10408 |
| 8 | FMEP, bar | 0.21 | 5.9 | 10409 |
| 9 | Peak cylinder pressure, bar | 35.8 | 5.9 | 10410 |
| 10 | Peak cylinder temperature, K | 2891 | 5.9 | 10410 |
| 11 | Peak-pressure crank angle, °ATDC | printed as `=1`; text says 16.2 | 5.9 | 10410 / 10634 |
| 12 | Scavenging efficiency, SE | 0.818 | 5.9 | 10421 |
| 13 | Trapping efficiency, TE | 0.504 | 5.9 | 10422 |
| 14 | Charging efficiency, CE | 0.430 | 5.9 | 10423 |
| 15 | Scavenge ratio (mass), SR | 0.874 | 5.9 | 10424 |
| 16 | Scavenge ratio (volume), SRv | 1.134 | 5.9 | 10425 |
| 17 | Exhaust flow ratio | 0.876 | 5.9 | 10426 |

Row 11 is unrecoverable from the printout: the decimal places are lost (`atdeg.ATDC=1`).
The text at 10633–10635 supplies 16.2° ATDC and says it "corresponds precisely with the
experimental data". Treat 16.2 as the target and 1.0 as OCR damage.

---

## 2. Case B — 3000 rpm, quarter throttle, `THAR = 0.25`, 5th cycle

Fig. 5.13 (caption 10727–10728). Same deck as Case A with **one** field changed —
"with the single exception of setting the throttle area ratio at 0.25 instead of 1.0"
(10669–10671).

| # | Quantity | Expected | Figure | src |
|---|---|---|---|---|
| 18 | Engine speed, rpm | 3000 | 5.13 | 10694 |
| 19 | Delivery ratio | 0.491 | 5.13 | 10695 |
| 20 | Power, kW | 7.6 | 5.13 | 10690 |
| 21 | BSFC, kg/kWh | 0.426 | 5.13 | 10696 |
| 22 | BMEP, bar | 3.85 | 5.13 | 10697 |
| 23 | IMEP, bar | 4.26 | 5.13 | 10691 |
| 24 | PMEP, bar | **0.20** (printed 0.21 — see §6.4) | 5.13 | 10698 / 10732 |
| 25 | FMEP, bar | 0.21 | 5.13 | 10699 |
| 26 | Peak cylinder pressure, bar | 26.6 | 5.13 | 10700 |
| 27 | Peak cylinder temperature, K | 2545 | 5.13 | 10700 |
| 28 | Scavenging efficiency, SE | **0.64** (figure line not legible) | 5.13 / text | 10712–10721 / 10680 |
| 29 | Trapping efficiency, TE | 0.569 | 5.13 | 10722 |
| 30 | Charging efficiency, CE | 0.283 | 5.13 | 10723 |
| 31 | Scavenge ratio (mass), SR | 0.535 | 5.13 | 10724 |
| 32 | Scavenge ratio (volume), SRv | 0.735 | 5.13 | 10725 |
| 33 | Exhaust flow ratio | 0.536 | 5.13 | 10726 |

No peak-pressure crank angle is legible for this case. Rows 24 and 28 are substitutions, not
readings — see §6.4 and §6.5.

---

## 3. Case C — 5000 rpm, seven scavenging models (a table, not a plot)

Fig. 5.12. **Different operating point:** the header reads
"DATA FOR CALCULATION FROM QUB 400 SINGLE CYLINDER RESEARCH ENGINE AT 5000 rpm" (10521), so
the Fig.5.3 `RPM = 3000` input must be **overridden to 5000** for this case. Every entry is
printed — this is a table, not a plot.

Columns, in order (10523–10529): `EXPT.` `UNIFLOW` `SCRE` `YAM1` `YAM6` `QUBCR` `CD`.

| Quantity | EXPT | UNIFLOW | SCRE | YAM1 | YAM6 | QUBCR | CD | src |
|---|---|---|---|---|---|---|---|---|
| POWER, kW | 12.4 | 12.37 | 12.11 | 11.87 | 11.21 | 12.11 | 10.76 | 10532–10538 |
| IMEP, bar | 6.80 | 6.81 | 6.68 | 6.56 | 6.23 | 6.69 | 6.00 | 10541–10547 |
| BMEP, bar | 6.24 | 6.22 | 6.10 | 5.98 | 5.65 | 6.10 | 5.42 | 10550–10556 |
| BSFC, g/kWh | 437 | 452 | 463 | 473 | 506 | 463 | 531 | 10559–10565 |
| DR | 0.85 | 0.84 | 0.85 | 0.85 | 0.86 | 0.85 | 0.86 | 10567–10573 |
| TEFF | 0.60 | 0.52 | 0.51 | 0.50 | 0.47 | 0.51 | 0.45 | 10582–10588 |
| PMAX, bar | 36.9 | 36.2 | 35.7 | 35.3 | 34.1 | 35.7 | 33.3 | 10598–10604 |

**Two damaged rows — do not reconstruct.** Seven columns are defined by the header, but only
six numbers survive; one value is lost and the column assignment after it is therefore unknown:

| Row | Values in printed order | src | Status |
|---|---|---|---|
| SEFF | 0.84, 0.82, 0.80, 0.75, 0.82, 0.72 | 10575–10580 | 6 of 7 — cannot be assigned |
| CEFF | 0.44, 0.43, 0.42, 0.40, 0.43, 0.39 | 10590–10595 | 6 of 7 — cannot be assigned |

Use SEFF/CEFF from Case C only as a magnitude check (0.72–0.84 and 0.39–0.44), and do the real
scavenging-efficiency validation on Cases A and B.

Self-consistency of the rest of the table (worth using as a test rather than a target):
QUBCR ties SCRE exactly on power 12.11 / BMEP 6.10 / BSFC 463, as the text claims at 10619–10620;
CD's 10.76 vs 12.11 is the "12 % power loss" of 10614; the "12.1 → 11.2 kW, 463 → 506 g/kWh"
sentence at 10503–10506 is the SCRE → YAM6 pair exactly.

---

## 4. Text-only statements (numbers with no figure, or with a figure that is a graph)

| Quantity | Value | src | Usable? |
|---|---|---|---|
| Exhaust downpipe length to silencer box | 200 mm | 10372–10373 | yes (input) |
| Silencer box volume / swept volume | 25× | 9835 | yes — consistency check on VBOX = 10 000 cm³ |
| Outlet pipe area = inlet pipe area | equal | 9836 | yes — check on DIA.1 = DIA.2 = 38 |
| Delivery ratio, full throttle | 0.86 | 10652 | text rounding of 0.854 |
| DR / SR / exhaust-flow ratio | 0.851 / 0.876 / 0.876 | 10666–10667 | conflicts with 10403 for DR — see §6.1 |
| Pmax measured vs calculated (5000 rpm) | 36.9 vs 35.7 bar | 10627–10628 | matches the Fig.5.12 columns |
| Peak-pressure crank angle | 16.2° ATDC | 10634–10635 | the only source for row 11 |
| Quarter throttle: air flow | 0.85 → 0.49 | 10673 | consistent with DR 0.854 / 0.491 |
| Quarter throttle: SRv | 1.13 → 0.73 | 10679 | consistent with rows 16 / 32 |
| Quarter throttle: SE | 0.82 → 0.64 | 10679–10680 | the source for row 28 |
| Quarter throttle: TE | 0.51 → 0.57 | 10680–10681 | consistent with rows 13 / 29 |
| Quarter throttle: pumping loss | 0.38 → 0.20 bar; friction constant 0.21 | 10731–10732 | the source for row 24 |
| Quarter throttle: power / BMEP | 12.2 → 7.6 kW; 6.1 → 3.8 bar | 10745–10746 | consistent with rows 3 / 20 |
| Quarter throttle: BSFC | 463 → 426 g/kWh | 10747–10748 | consistent with rows 4 / 21 |
| `BEFF`, `BDEG` provenance | from QUB 400 firing tests, Sect. 4.2.3 | 10087–10089 | confirms 0.85 / 60° |
| `TAF` provenance | "experimentally determined value for the QUB 400" | 10094–10095 | confirms 13 |
| `NC`, `NE` provenance | "recommended in Sect. 4.3.1 for general use" | 10092–10093 | confirms 1.25 / 1.35 |
| Chapter 7 re-run: single-cylinder vs three-cylinder | 6.22 bar / 0.462 kg/kWh vs 8.61 / 0.344 | 11743–11748 | **third** operating point — do not mix with Case A |
| Chapter 7 throttle sweep (0.15…1.0, SCRE & YAM6, 3000 rpm) | settings only, no numbers | 15081–15086 | unusable for validation |

---

## 5. Graph-only — no printed numbers anywhere

Flagged `GRAPH ONLY`: these carry information but no digit can be quoted, so they are **not**
checklist items and must not be turned into one.

| Quantity | Fig | src of caption | Status |
|---|---|---|---|
| Cylinder / crankcase / exhaust-port pressure ratio vs crank angle (full throttle, 5th cycle) | 5.9 | 10427–10428 | GRAPH ONLY as a *trace*; the 17 numbers in §1 are printed in the same figure and are usable |
| SE and SRv vs crank angle from transfer opening, SCRE / YAM6 / CD | 5.10 | 10454 | GRAPH ONLY |
| Scavenge ratio (mass and volume) vs crank angle, SCRE / YAM6 / CD | 5.11 | 10499 | GRAPH ONLY |
| BMEP, BSFC, TE, SE vs throttle area ratio, 3000 rpm, SCRE & YAM6 | 7.13, 7.14 | 15130–15169 | GRAPH ONLY — the only part-load source for `THAR` ≠ 1.0 / 0.25 |
| Delivery ratio vs crank angle (lower half of the 5.9 screen) | 5.9 | 10360–10362 | GRAPH ONLY |

Also figure-only and engine-independent (not validation targets): cV, cP and γ vs temperature
for air and exhaust gas, Figs. 5.5–5.7, described at 9898–9908.

**Nothing in this checklist is ESTIMATED from a plot.** Every quantity above is either printed
text or arithmetic on printed text. The only derived numbers are the two substitutes in §2
(PMEP 0.20, SE 0.64) and the 16.2° of row 11.

---

## 6. Book-internal inconsistencies to expect (do not "fix" the model to match them)

**6.1** Delivery ratio for Case A is 0.854 in the printout (10403) but 0.851 in the running text
(10666). Same run, two numbers; 0.854 is the program's own output.

**6.2** Case A peak pressure is 35.8 bar (10410) while the text's "calculated at 35.7 bar"
(10628) is the 5000 rpm Fig.5.12 value. Both are correct at their own operating point; the
coincidence that they are 0.1 bar apart is a trap.

**6.3** The scavenging equation used for Figs.5.9–5.13 is ambiguous in the prose: 10381 says
"Eq. 5.1.14", 10625 says "either Eq. 5.1.11 or Eq. 5.1.13", while Chapter 7 states that
"in the earlier exposition in Chapter 5, Eq. 5.1.11 is used for the analysis of behavior of the
QUB 400 engine" (15090–15092) and the code comment agrees ("SCAVENGING MODEL NO.1 … REM
Eqn.5.1.11 is being programmed here", 27728–27729). **Use model No.1 (Eq. 5.1.11)** and record
which one the port implements.

**6.4** Case B PMEP: the figure line reads 0.21 (10698) but the text says "reduced from 0.38 bar
to 0.20 bar" (10732), and 4.26 − 0.20 − 0.21 = 3.85 reproduces the printed BMEP exactly, whereas
4.26 − 0.21 − 0.21 = 3.84 does not. Take **0.20**.

**6.5** Case B SE: the figure's SE line is destroyed by OCR (10712–10721); only the text's 0.64
(10680) survives. This is the single least reliable number in either printout.

**6.6** Case B has no legible peak-pressure crank angle, so only 16 numbers of the 17-channel
set are checkable there (same 16 as Case A minus that row).

---

## 7. Suggested pass criterion

Compare channel by channel, not on one headline number, and in this order of trust:

1. **Geometry-derived channels** — FMEP 0.21 bar (should be exact: the code's whole friction
   model is `FMEP = 100*STM*RPM`, src 26342), swept volume 397.0 cm³, and the
   `IMEP − PMEP − FMEP = BMEP` identity. If these fail, the deck or the units are wrong and
   nothing downstream means anything.
2. **Mass-flow channels** — DR, SR, SRv, exhaust-flow ratio. These test the inlet pipe, the
   `THAR` throttle coefficient and the scavenge model together.
3. **Combustion channels** — Pmax, Tmax, peak angle. Pmax is the strongest single number in the
   book (36.9 measured vs 35.7 calculated at 5000 rpm, "corresponds precisely", 10627–10635).
4. **Efficiency channels last** — TE is the book's own admitted weak point (calculated 0.51 vs
   measured 0.60 at 5000/SCRE, 10582–10584); a 15 % TE discrepancy is expected, not a bug.
