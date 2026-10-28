# QUB 400 - validation report

Generated 2026-10-29 02:21:22 by `run_qub400.m`.

Reference: G.P. Blair, *The Basic Design of Two-Stroke Engines* (SAE).
Source line numbers (`src NNNNN`) refer to
`references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`.

## 1. Verdict

**VERDICT: FAIL** - 31/46 pass (67.4%), worst miss 7.12x tolerance (target 36).

| Metric | Value |
|---|---|
| Published targets defined | 53 |
| Scored targets (model must reproduce) | 46 |
| Reference targets (measured, not scored) | 7 |
| Targets reported by the model | 44 of 46 |
| Pass / fail | 31 / 15 |
| Pass fraction | 67.4 % |
| Worst miss | 7.12x tolerance (target 36) |

The numbers above are **after** the book-page repair to `blair_step.m` line 536
described in sec.1a; the same report before the repair was 17/46 pass (37.0 %),
worst miss 6.36x tolerance (target 38). Both sets of tables are in sec.1a.

## 1a. BOOK-PAGE REPAIR (book p.594) - before / after

**This section is inserted by hand. `run_qub400.m` regenerates secs.1-10 and does
not rewrite it** - re-running the driver will drop sec.1a unless it is re-applied.

### 1a.1 The change

`sim/blair/blair_step.m`, `TRPORTOPEN`, one statement:

```matlab
% as printed (p.594) and as ported (blair_clean.bas 1108):
VOLINC = CT1*FTDUCT*DTM*EXPAND/VC1
% repaired:
VOLINC = CDT*CT1*FTDUCT*DTM*EXPAND/VC1
```

This is a **book-page repair, not a transcription fix**. Page 594 prints the
four-factor line, so the transcription is faithful; the defect is inside Blair's
own listing. Section 5.1.5 (Eqs.5.1.6/5.1.7, pp.217-219) defines
`dMF = Dt1*dVF` - the mass increment is the density times the *same* volume
increment - while `SUB OUTFLOW` (p.310) returns an inviscid velocity `C` and
applies the discharge coefficient only to the mass, `M=CD*C*F*D`. The two
accumulators in `TRPORTOPEN` therefore integrate flows differing by `1/CD`.
`CDT` is the value the routine itself sets at 1103/1104 (`.75`, both branches)
and already passes to `OUTFLOW`; it is **not** a fitted constant.
Evidence: `SRV_INVESTIGATION.md` secs.4-6.

The as-printed value remains switchable for the record:

```matlab
mdl = blair_init(deck);  mdl.VOLINC_AS_PRINTED = true;  mdl = blair_run(mdl);
```

verified to reproduce the old baseline exactly (power 13.8261 kW, SRv 1.42254,
case-A 16-row mean deviation 8.71 %).

### 1a.2 Case A - 3000 rpm, full throttle (THAR 1.0), 5th cycle  [Fig.5.9]

| Quantity | Before | %Err | After | %Err | Published |
|---|---:|---:|---:|---:|---:|
| Power (kW) | 13.8261 | +13.33 | **12.5342** | **+2.74** | 12.2 |
| BMEP (bar) | 6.9615 | +13.38 | **6.3110** | **+2.79** | 6.14 |
| BSFC (g/kWh) | 424.90 | -8.43 | **475.77** | **+2.54** | 464 |
| DR (-) | 0.88647 | +3.80 | 0.89986 | +5.37 | 0.854 |
| TE (-) | 0.54395 | +7.93 | **0.49154** | **-2.47** | 0.504 |
| SE (-) | 0.88775 | +8.53 | **0.80095** | **-2.08** | 0.818 |
| pmax (bar) | 38.904 | +8.67 | **36.473** | **+1.88** | 35.8 |
| tmax (K) | 3070.6 | +6.21 | **2822.6** | **-2.37** | 2891 |
| SRv (-) | 1.42254 | +25.44 | 1.07970 | -4.79 | 1.134 |

Every channel improves except DR, whose error grows +3.80 -> +5.37 % and still
passes. Pass count 12/21 -> 20/21; the single remaining failure is tmax
(-2.37 % against a +/-2 % band).

### 1a.3 Case B - 3000 rpm, quarter throttle (THAR 0.25), 5th cycle  [Fig.5.13]

| Quantity | Before | %Err | After | %Err | Published |
|---|---:|---:|---:|---:|---:|
| Power (kW) | 9.2239 | +21.37 | **7.7583** | **+2.08** | 7.6 |
| BMEP (bar) | 4.6443 | +20.63 | **3.9064** | **+1.46** | 3.85 |
| BSFC (g/kWh) | 391.70 | -8.05 | 471.10 | +10.59 | 426 |
| DR (-) | 0.54518 | +11.03 | 0.55152 | +12.33 | 0.491 |
| TE (-) | 0.60733 | +6.74 | 0.51304 | -9.83 | 0.569 |
| SE (-) | 0.71555 | +11.80 | 0.58968 | -7.86 | 0.64 |
| pmax (bar) | 29.787 | +11.98 | **27.141** | **+2.03** | 26.6 |
| tmax (K) | 2718.4 | +6.81 | 2361.8 | -7.20 | 2545 |
| SRv (-) | 0.86606 | +17.83 | 0.64679 | -12.00 | 0.735 |

Mixed, net better. Power, BMEP, IMEP (+19.41 -> +2.14 %) and pmax move onto the
published values; BSFC, TE, SE, srv and tmax move *away* and now sit on the low
side. Pass count 5/16 -> 9/16. SE fails by 0.0003 (0.58968 vs 0.64 on a
+/-0.05 band) and TE by 0.006 (0.51304 vs 0.569).

### 1a.4 Case C - 5000 rpm, full throttle, SCRE column  [Fig.5.12]

| Quantity | Before | %Err | After | %Err | Published |
|---|---:|---:|---:|---:|---:|
| Power (kW) | 15.3772 | +26.98 | **12.9993** | **+7.34** | 12.11 |
| BMEP (bar) | 4.6455 | -23.84 | 3.9271 | -35.62 | 6.10 |
| IMEP (bar) | 5.2493 | -21.42 | 4.5406 | -32.03 | 6.68 |
| BSFC (g/kWh) | 382.23 | -17.44 | **473.23** | **+2.21** | 463 |
| DR (-) | 0.53215 | -37.39 | 0.55695 | -34.48 | 0.85 |
| TE (-) | 0.63095 | +23.72 | **0.52797** | **+3.52** | 0.51 |
| pmax (bar) | 29.920 | -16.19 | 27.479 | -23.03 | 35.7 |
| SE (-) | 0.7422 | n/a | 0.6317 | n/a | not a target |
| tmax (K) | 2788.5 | n/a | 2465.8 | n/a | not a target |

Power, BSFC and TE improve and two of them come inside tolerance (pass count
0/7 -> 2/7). BMEP, IMEP and pmax get worse in % error, but not because the
repair is wrong there: the published C column is internally inconsistent. At
12.11 kW, 5000 rpm and 397 cm3, `BMEP = P*1200/(Vs*N) = 7.32 bar` - not the
6.10 bar the table prints. The pre-repair model was already 24 % low on BMEP
*while 27 % high on power*, so it cannot satisfy both rows at any SRv; lowering
power toward 12.11 kW necessarily widens the gap to the 6.10 bar row. This is a
book-internal conflict (sec.7 class), not a regression the repair can avoid.

### 1a.5 Mean deviation

Two metrics, because two are already in use in this repository.

**(a) Case A, the 16 published Fig.5.9 rows of `blair_validate.m` 61-62**
- this is the "8.71 %" quoted in `PORT_DIFF.md` sec.6 and `REED_SCOPE.md`:

| | mean \|model/Blair - 1\| | pass |
|---|---:|---:|
| Before (as printed) | **8.71 %** | 17/46 |
| After (book-page repair) | **3.44 %** | 31/46 |

**(b) `check_qub400.m` scored rows, mean \|%Err\| per case:**

| Case | n | Before | After | Pass before | Pass after |
|---|---:|---:|---:|---:|---:|
| A | 21 | 7.47 % | **3.71 %** | 12/21 | 20/21 |
| B | 16 | 11.55 % | **6.42 %** | 5/16 | 9/16 |
| C | 7 | 23.86 % | **19.75 %** | 0/7 | 2/7 |
| All scored | 44 | 11.56 % | **7.25 %** | 17/46 | 31/46 |

### 1a.6 Verdict on the repair

* **Case A: verified.** Power 13.83 -> 12.53 kW (+13.3 -> +2.7 %), SRv
  1.4225 -> 1.0797 (+25.4 -> -4.8 %), 16-row mean deviation 8.71 -> 3.44 %,
  pass 12/21 -> 20/21. All three numbers the repair was predicted to produce.
* **Case B: improves.** Case mean 11.55 -> 6.42 %, pass 5/16 -> 9/16. It is
  affected because B runs the same `SCRE` model 1, so `SEFF` for B is the same
  `1-EXP(MSC*SR+CSC)` function of `SRv`, which falls 0.866 -> 0.647. The
  channels that worsen (BSFC, TE, SE, tmax) all move on the same trapped-mass
  chain; B's residual is now on the low side rather than the high side.
* **Case C: improves.** Case mean 23.86 -> 19.75 %, pass 0/7 -> 2/7, with power
  +27.0 -> +7.3 % and BSFC -17.4 -> +2.2 %. Affected for the same reason
  (`SCRE`); SRv 0.925 -> 0.712. Its BMEP/IMEP/pmax errors widen against a
  published column that is arithmetically inconsistent with its own power row
  (sec.1a.4).
* **No case is unaffected**, and none is made worse on its case mean. Nothing
  else in the model was changed to compensate: the residual errors in B and C
  are left where they fall.

## 2. Targets captured

53 numeric targets are captured: 46 are scored against the model and 7 are
measured reference values reported for correlation. They are all stated in text or
printed in a table - none is read off a graph. A further list of graph-only
items (5) is kept separately because no digit from them can be quoted.

| Case | Operating point | Targets | Scored | Reference | Source |
|---|---|---:|---:|---:|---|
| A | 3000 rpm, full throttle (THAR 1.0), 5th cycle | 21 | 21 | 0 | Fig.5.9 |
| B | 3000 rpm, quarter throttle (THAR 0.25), 5th cycle | 16 | 16 | 0 | Fig.5.13 |
| C | 5000 rpm, full throttle, SCRE column | 14 | 7 | 7 | Fig.5.12 |
| G | engine geometry / text consistency, speed independent | 2 | 2 | 0 | text 9835-9836 |
| **Total** | | **53** | **46** | **7** | |

Graph-only, flagged approximate and never scored:

| # | Content | Figure | src |
|---|---|---|---|
| 1 | Cylinder / crankcase / exhaust-port pressure ratio vs crank angle | Fig.5.9 | 10427-10428 |
| 2 | SE and SRv vs crank angle from transfer opening, SCRE/YAM6/CD | Fig.5.10 | 10454 |
| 3 | Scavenge ratio (mass and volume) vs crank angle, SCRE/YAM6/CD | Fig.5.11 | 10499 |
| 4 | BMEP, BSFC, TE, SE vs throttle area ratio, 3000 rpm, SCRE & YAM6 | Figs.7.13, 7.14 | 15130-15169 |
| 5 | Delivery ratio vs crank angle (lower half of the 5.9 screen) | Fig.5.9 | 10360-10362 |

## 3. Input deck

`QUB400_INPUT.dat` loaded: **42 entries, 40 numeric + 2 strings** (Prog.5.1
expects 40 numeric + 2 strings; the 48-entry figure belongs to Prog.5.2).

| Datum | Value |
|---|---|
| Bore / stroke / con-rod | 85.0 / 70.0 / 125.0 mm |
| Trapped CR / crankcase CR | 6.70 / 1.45 |
| Exhaust port opens / fully open | 96 / 180 deg ATDC |
| Transfer port opens / fully open | 118 / 180 deg ATDC |
| Inlet port opens / fully open | 60 deg BTDC / 0 deg ATDC |
| Transfer pipe / inlet pipe | 90 / 200 mm |
| Silencer box | LEP1 200, DEP1 38, LEP2 200, DEP2 38, VBOX 10000 cm3, SIL "N" |
| Combustion | nc 1.25, ne 1.35, BE 0.85, period 60 deg, A/F 13 |
| Scavenging model | `SCRE` |

Case overrides applied by the driver (the deck itself only carries one speed and one throttle):

| Case | RPM | THAR | Scavenging | Cycles |
|---|---:|---:|---|---:|
| A | 3000 | 1.00 | SCRE | 5 |
| B | 3000 | 0.25 | SCRE | 5 |
| C | 5000 | 1.00 | SCRE | 5 |

Case C is the Fig.5.12 table at 5000 rpm: the deck says 3000, so RPM is overridden.
Scavenging model No.1 (Eq. 5.1.11) is the one the book uses for all three cases
(src 15090-15092, code comment 27728-27729); this report assumes the port uses it.

## 4. Tolerance policy

| Quantity | Tolerance |
|---|---|
| power, bmep, bsfc, pmax | +/-5 % of published |
| dr, se, te | +/-5 percentage points, absolute (+/-0.05) |
| tmax | +/-2 % of published |
| everything else (imep, pmep, fmep, ce, sr, srv, efr, rpm, peak angle, geometry) | +/-10 % of published |

DR, SE and TE are absolute because a 5 % relative band on 0.5 would be +/-0.025,
which the book's own rounding (two or three decimals) cannot support.

## 5. Checker self-test

Two tests, both run every time. The first proves the harness plumbing is right;
the second proves it is not a rubber stamp.

### 5.1 Positive - published values fed back as model output

- Result: **46/46 scored targets pass (100.0 % pass), verdict `REPRODUCE`** - PASS.
- This exercises every field mapping, unit scale and tolerance rule with a known answer.
- The conflict cases are exercised too: feeding the printout's 0.854 delivery ratio
  against the text's 0.851 and 0.86 must pass on the +/-0.05 absolute band, and
  feeding PMEP 0.20 against the figure's 0.21 must pass on the +/-10 % band.

### 5.2 Negative - 20 % error planted on case A power

- Result: **45/46 pass, verdict `FAIL`, failure(s) on target 3** - PASS.
- The checker must flag exactly the planted target and nothing else. A checker that
  still reports 100 % here would be measuring nothing.

Self-test status: **PASS**

## 6. Model vs published

### Case A - 3000 rpm, full throttle (THAR 1.0), 5th cycle  [Fig.5.9]

| # | Quantity | Model | Published | Diff | %Err | Tolerance | Status | src |
|---:|---|---:|---:|---:|---:|---|---|---|
| 1 | Engine speed | 3000 | 3000 rev/min | +0 | +0.00 | +/-10.0% | **PASS** | 10402 |
| 2 | Delivery ratio | 0.89986 | 0.854 | +0.04586 | +5.37 | +/-0.050 abs | **PASS** | 10403 |
| 3 | Power | 12.534 | 12.2 kW | +0.3342 | +2.74 | +/-5.0% | **PASS** | 10404 |
| 4 | BSFC | 0.47577 | 0.464 (= 464 g/kWh) | +0.01177 | +2.54 | +/-5.0% | **PASS** | 10405 |
| 5 | BMEP | 6.311 | 6.14 bar | +0.171 | +2.79 | +/-5.0% | **PASS** | 10406 |
| 6 | IMEP | 6.9349 | 6.72 bar | +0.2149 | +3.20 | +/-10.0% | **PASS** | 10407 |
| 7 | PMEP | 0.4139 | 0.38 bar | +0.0339 | +8.92 | +/-10.0% | **PASS** | 10408 |
| 8 | FMEP | 0.21 | 0.21 bar | +5.551e-17 | +0.00 | +/-10.0% | **PASS** | 10409 |
| 9 | Peak pressure | 36.473 | 35.8 bar | +0.6729 | +1.88 | +/-5.0% | **PASS** | 10410 |
| 10 | Peak temperature | 2822.6 | 2891 K | -68.38 | -2.37 | +/-2.0% | **FAIL** | 10410 |
| 11 | Peak-pressure angle | 16.143 | =1 (decimals lost) | -0.05721 | -0.35 | +/-10.0% | **PASS** | 10410 / 10634-10635 |
| 12 | Scavenging efficiency | 0.80095 | 0.818 | -0.01705 | -2.08 | +/-0.050 abs | **PASS** | 10421 |
| 13 | Trapping efficiency | 0.49154 | 0.504 | -0.01246 | -2.47 | +/-0.050 abs | **PASS** | 10422 |
| 14 | Charging efficiency | 0.44167 | 0.430 | +0.01167 | +2.71 | +/-10.0% | **PASS** | 10423 |
| 15 | Scavenge ratio (mass) | 0.93044 | 0.874 | +0.05644 | +6.46 | +/-10.0% | **PASS** | 10424 |
| 16 | Scavenge ratio (vol) | 1.0797 | 1.134 | -0.05427 | -4.79 | +/-10.0% | **PASS** | 10425 |
| 17 | Exhaust flow ratio | 0.93169 | 0.876 | +0.05569 | +6.36 | +/-10.0% | **PASS** | 10426 |
| 48 | Delivery ratio (text 0.86) | 0.89986 | 0.86 | +0.03986 | +4.64 | +/-0.050 abs | **PASS** | 10652 |
| 49 | Delivery ratio (text 0.851) | 0.89986 | 0.851 | +0.04886 | +5.74 | +/-0.050 abs | **PASS** | 10666 |
| 50 | Scavenge ratio (text) | 0.93044 | 0.876 | +0.05444 | +6.21 | +/-10.0% | **PASS** | 10666-10667 |
| 51 | Exhaust flow ratio (text) | 0.93169 | 0.876 | +0.05569 | +6.36 | +/-10.0% | **PASS** | 10666-10667 |

Notes:

- **Delivery ratio (id 2)**: Running text 10666 says 0.851 for the same run; 0.86 at 10652 is a rounding. Printed value used.
- **FMEP (id 8)**: Geometry gate: code law is FMEP = 100*STM*RPM = 0.21 bar exactly (src 26342).
- **Peak pressure (id 9)**: Text 10628 quotes 35.7 bar, but that is the 5000 rpm Fig.5.12 value, not this run.
- **Delivery ratio (text 0.86) (id 48)**: Text rounds 0.854 up to 0.86; a third value for the same run.
- **Delivery ratio (text 0.851) (id 49)**: Directly conflicts with the 0.854 printout for the same run.

### Case B - 3000 rpm, quarter throttle (THAR 0.25), 5th cycle  [Fig.5.13]

| # | Quantity | Model | Published | Diff | %Err | Tolerance | Status | src |
|---:|---|---:|---:|---:|---:|---|---|---|
| 18 | Engine speed | 3000 | 3000 rev/min | +0 | +0.00 | +/-10.0% | **PASS** | 10694 |
| 19 | Delivery ratio | 0.55152 | 0.491 | +0.06052 | +12.33 | +/-0.050 abs | **FAIL** | 10695 |
| 20 | Power | 7.7583 | 7.6 kW | +0.1583 | +2.08 | +/-5.0% | **PASS** | 10690 |
| 21 | BSFC | 0.4711 | 0.426 kg/kWh | +0.0451 | +10.59 | +/-5.0% | **FAIL** | 10696 |
| 22 | BMEP | 3.9064 | 3.85 bar | +0.05635 | +1.46 | +/-5.0% | **PASS** | 10697 |
| 23 | IMEP | 4.3511 | 4.26 bar | +0.09111 | +2.14 | +/-10.0% | **PASS** | 10691 |
| 24 | PMEP | 0.23476 | 0.21 (figure) / 0.20 (text) | +0.03476 | +17.38 | +/-10.0% | **FAIL** | 10698 / 10732 |
| 25 | FMEP | 0.21 | 0.21 bar | +5.551e-17 | +0.00 | +/-10.0% | **PASS** | 10699 |
| 26 | Peak pressure | 27.141 | 26.6 bar | +0.5412 | +2.03 | +/-5.0% | **PASS** | 10700 |
| 27 | Peak temperature | 2361.8 | 2545 K | -183.2 | -7.20 | +/-2.0% | **FAIL** | 10700 |
| 28 | Scavenging efficiency | 0.58968 | not legible (text: 0.64) | -0.05032 | -7.86 | +/-0.050 abs | **FAIL** | 10712-10721 / 10680 |
| 29 | Trapping efficiency | 0.51304 | 0.569 | -0.05596 | -9.84 | +/-0.050 abs | **FAIL** | 10722 |
| 30 | Charging efficiency | 0.28196 | 0.283 | -0.001044 | -0.37 | +/-10.0% | **PASS** | 10723 |
| 31 | Scavenge ratio (mass) | 0.58311 | 0.535 | +0.04811 | +8.99 | +/-10.0% | **PASS** | 10724 |
| 32 | Scavenge ratio (vol) | 0.64679 | 0.735 | -0.08821 | -12.00 | +/-10.0% | **FAIL** | 10725 |
| 33 | Exhaust flow ratio | 0.58162 | 0.536 | +0.04562 | +8.51 | +/-10.0% | **PASS** | 10726 |

Notes:

- **PMEP (id 24)**: Figure line reads 0.21; text 10732 says 0.20 and 4.26-0.20-0.21=3.85 reproduces BMEP exactly. (alternative 0.21).
- **Scavenging efficiency (id 28)**: Figure SE row destroyed by OCR; only the text value 0.64 survives.

### Case C - 5000 rpm, full throttle, SCRE column  [Fig.5.12]

Measured **EXPT** rows are marked `REF` and are not scored.

| # | Quantity | Model | Published | Diff | %Err | Tolerance | Status | src |
|---:|---|---:|---:|---:|---:|---|---|---|
| 34 | Power | 12.999 | 12.11 kW | +0.8893 | +7.34 | +/-5.0% | **FAIL** | 10532-10538 (col 3, SCRE) |
| 35 | IMEP | 4.5406 | 6.68 bar | -2.139 | -32.03 | +/-10.0% | **FAIL** | 10541-10547 (col 3, SCRE) |
| 36 | BMEP | 3.9271 | 6.10 bar | -2.173 | -35.62 | +/-5.0% | **FAIL** | 10550-10556 (col 3, SCRE) |
| 37 | BSFC | 0.47323 | 463 g/kWh | +0.01023 | +2.21 | +/-5.0% | **PASS** | 10559-10565 (col 3, SCRE) |
| 38 | Delivery ratio | 0.55695 | 0.85 | -0.293 | -34.48 | +/-0.050 abs | **FAIL** | 10567-10573 (col 3, SCRE) |
| 39 | Trapping efficiency | 0.52797 | 0.51 | +0.01797 | +3.52 | +/-0.050 abs | **PASS** | 10582-10588 (col 3, SCRE) |
| 40 | Peak pressure | 27.479 | 35.7 bar | -8.221 | -23.03 | +/-5.0% | **FAIL** | 10598-10604 (col 3, SCRE) |
| 41 | Power [measured] | 12.999 | 12.4 kW | +0.5993 | +4.83 | +/-5.0% | **REF** | 10532-10538 (col 1, EXPT) |
| 42 | IMEP [measured] | 4.5406 | 6.80 bar | -2.259 | -33.23 | +/-10.0% | **REF** | 10541-10547 (col 1, EXPT) |
| 43 | BMEP [measured] | 3.9271 | 6.24 bar | -2.313 | -37.07 | +/-5.0% | **REF** | 10550-10556 (col 1, EXPT) |
| 44 | BSFC [measured] | 0.47323 | 437 g/kWh | +0.03623 | +8.29 | +/-5.0% | **REF** | 10559-10565 (col 1, EXPT) |
| 45 | Delivery ratio [measured] | 0.55695 | 0.85 | -0.293 | -34.48 | +/-0.050 abs | **REF** | 10567-10573 (col 1, EXPT) |
| 46 | Trapping eff. [measured] | 0.52797 | 0.60 | -0.07203 | -12.00 | +/-0.050 abs | **REF** | 10582-10588 (col 1, EXPT) |
| 47 | Peak pressure [measured] | 27.479 | 36.9 bar | -9.421 | -25.53 | +/-5.0% | **REF** | 10598-10604 (col 1, EXPT) |

### Case G - engine geometry and text consistency

| # | Quantity | Model | Published | Diff | %Err | Tolerance | Status | src |
|---:|---|---:|---:|---:|---:|---|---|---|
| 52 | Silencer box / Vs | - | twenty-five times | - | - | +/-10.0% | **NODATA** | 9835 |
| 53 | Outlet/inlet pipe area | - | equal | - | - | +/-10.0% | **NODATA** | 9836 |

## 7. Book-internal conflicts (recorded, not resolved)

The published values are transcribed as printed. Where the book contradicts itself,
both numbers are kept as targets and the tolerance absorbs the difference.

| Quantity | Case | Primary | Alternative | Treatment |
|---|---|---|---|---|
| Delivery ratio | A | **0.854** (printout 10403) | **0.851** (text 10666), **0.86** (text 10652) | All three are targets (ids 2, 48, 49). +/-0.05 absolute covers a 0.009 spread. |
| PMEP | B | **0.20** (text 10732) | **0.21** (figure 10698) | 0.20 chosen because 4.26 - 0.20 - 0.21 = 3.85 reproduces the printed BMEP exactly; 0.21 kept as `alt_value`; +/-10 % covers both. |
| Peak pressure | A vs C | **35.8** (3000 rpm, 10410) | **35.7** (5000 rpm, 10628/10598) | Not a conflict - different operating points. Both kept; the 0.1 bar coincidence is a trap. |
| Scavenging efficiency | B | **0.64** (text 10680) | figure row destroyed (10712-10721) | Single surviving source; flagged as the least reliable number in either printout. |
| Trapping efficiency | C | **0.51** calculated | **0.60** measured | 15 % apart, conceded by the book (10582-10584). Only the calculated value is scored; the measured one is a reference row. |

Two further source defects are carried in the data rather than "fixed":

- Peak-pressure angle in Fig.5.9 prints as `=1` (decimals lost). The target is 16.2 deg ATDC from
  the text at 10634-10635 (id 11).
- Fig.5.12 SEFF and CEFF rows each lost one of seven values and cannot be re-assigned. They
  are deliberately **not** targets; scavenging efficiency is validated on Cases A and B only.

## 8. How to read the verdict

| Verdict | Condition |
|---|---|
| `REPRODUCE` | every scored target is inside its tolerance |
| `CLOSE` | at least 80 % of scored targets pass, and no target is further than 2x its tolerance from the published value |
| `FAIL` | otherwise, or no model output at all |

The verdict is computed on scored targets only. Reference rows (the Fig.5.12 EXPT
column) are printed with their error but never change the verdict - the model is
judged against what the book's program calculated, and correlated against what was
measured.

If the geometry gate fails (FMEP != 100*STM*RPM, or swept volume != 397.0 cm3) the
reason line says so: the deck or the units are wrong and no downstream channel means
anything (QUB400_CHECKLIST.md sec.7).

## 9. Files

| File | Role |
|---|---|
| `qub400_targets.m` | the 53 published targets + the graph-only list |
| `check_qub400.m` | comparison, tolerances, self-test, verdict |
| `qub400_load_input.m` | parses the 42-entry deck into a struct |
| `run_qub400.m` | driver; writes this report |
| `qub400_model.m` | the port - **not present yet** |

## 10. Not checked

The five graph-only figures listed in sec.2, plus everything the book does not state:
torque, swept volume as a printed number, clearance volume, crankcase volume,
absolute air and fuel mass flows, measured exhaust temperature, and ignition timing.
TE at 5000 rpm is the book's own admitted weak point (calculated 0.51 vs measured
0.60); a 15 % TE discrepancy there is expected, not a porting bug.

