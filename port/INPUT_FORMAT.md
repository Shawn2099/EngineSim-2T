# INPUT FORMAT — Blair Prog.5.1 / Prog.5.2 ("ENGINE MODEL Nos.1 & 2")

Reconstructed from the program listings (book pp.298–312, source lines 26841–28197 for
Prog.5.2) and from the Chapter 5 text (esp. §5.1.1–5.1.5, pp.206–220, and §5.2/§5.3).
"src NNNNN" refers to the line numbers of
`references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`.

Companion file: `blair_prog52_basic.txt` (the transcription of Prog.5.2, which carries
the same line references).

---

## 0. Summary of completeness

| Question | Answer |
|---|---|
| Is every prompted input recoverable? | **Yes — all 48 entries.** Every `INPUT` statement in the nine data blocks survives in legible form, and each is echoed back by `DATASET` (src 27294–27352) with a column heading, which independently confirms the order and meaning. |
| Is the intended *physical* meaning of each one given? | **Almost all.** 5 fields are named but never explained anywhere in the book (→ §8): `TCR` is explained only indirectly, `TRAR` and `THAR` are explained in §5.1.2, `BEFF`/`BDEG` in §5.1.4. `LP23` vs `LP34` geometry is only given as a figure. |
| Are units stated? | **Yes** — `DATASET` prints "ALL DATA IN mm AND deg UNITS" (src 27298) and every prompt names its quantity; every conversion to SI is explicit in `FILESET`/`ENGINEDAT`/the port subroutines. |
| Is the UFLO file format given? | **Yes, fully** — 21×41, ordering, contents and the exact interpolation indices are all printed (src 20119–20131 plus `SUB PORT`, src 28034–28048). |
| Is the on-disk save format given? | **Yes** — `FILING`/`FILED` (src 27538–27564) give the exact record order. **Caveat:** Prog.5.1 and Prog.5.2 use the *same* `.BOX` extension and *different* field order (→ §6). |

---

## 1. How the user is driven

```
            ┌─ "N" ─→ nine Y/N-gated data blocks ─┐
menu 50 ────┤                                     ├─→ 502 DATASET (echo all data to screen)
  (src 26876)└─ "F" ─→ FILED (.BOX file) ─────────┘        │
                                                          ↓
                                              PORTSTART (derive port heights/areas)
                                                          ↓
                                          "RUN" / "NEW"  →  NEW → back to menu 50
                                                          ↓
                                            9-cycle time-stepping loop
                                                          ↓
                                  menu 500:  R, P (print), F (file), Q (quit)
```

The nine blocks, in prompt order (src 26882–26903):

| # | Menu prompt | Block label | Subroutine | src |
|---|---|---|---|---|
| 1 | NEW BASIC ENGINE DATA | 15 | `ENGINEDAT` | 27792 |
| 2 | NEW EXHAUST PORT DATA | 16 | `EXPORTDAT` | 27835 |
| 3 | NEW TRANSFER PORT DATA | 17 | `TRPORTDAT` | 27868 |
| 4 | NEW INLET PORT DATA | 18 | `INPORTDAT` | 27904 |
| 5 | NEW EXHAUST PIPE LENGTH DATA | 19 | `EXLENDAT` | 27224 |
| 6 | NEW EXHAUST PIPE DIAMETER DATA | 119 | `EXDIADAT` | 27255 |
| 7 | NEW TRANSFER PIPE DATA | 20 | `TRPIPDAT` | 27570 |
| 8 | NEW INLET PIPE DATA | 21 | `INPIPDAT` | 27592 |
| 9 | NEW DATA FOR CLOSED CYCLE | 22 | `COMBDAT` | 27612 |

**Prompting pattern.** Inside each block, every single value is offered separately:

```
INPUT "NEW DATA FOR <item>(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT "TYPE IN <item>(<SYMBOL>)";<SYMBOL>
...
INPUT "MORE DATA,(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO <block label>
```

so data entry is *selective*: answering `N` everywhere leaves the previous value in place.
The `MORE DATA` loop only exists for convenience — it re-asks the whole block.
Note the inconsistency in the prompt strings: the exhaust-port width prompt says
`(WE)` while the variable is `WEP` (src 27851), and the transfer-port top-radius prompt
says `(RTE)` while the variable is `RTT` (src 27888). **Read the variable, not the
parenthesised symbol.**

After all blocks, `502 GOSUB DATASET` prints the whole data set for a visual check and
asks `OK?(Y/N)` (src 27351) — but the answer is **not tested**; execution continues
regardless.

---

## 2. The 48 inputs, in prompt order

Order = order in which the program asks for them. `Array index` is "scalar" unless the
quantity indexes an array. "src" is the `INPUT` statement.

### Block 1 — `ENGINEDAT` (src 27792–27834)

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 1 | `BO` | Cylinder bore | mm | scalar | src 27794. → `BOM=BO/1000` (27824) → `FPISTON=PI*BOM^2/4` (27828) → `SV` → every volume, MEP and power term |
| 2 | `ST` | Piston stroke | mm | scalar | src 27796. → `STM` (27825), `CRNK=STM/2` (27831), `SV`, `FMEP=100*STM*RPM` (27832) |
| 3 | `CRL` | Connecting-rod length, bearing centres (the code's `C` in `PISTPOS`) | mm | scalar | src 27798. → `CRLM=CRL/1000` (27826) → `PISTPOS(S,R,C,D,HT,HB)` (28124–28129) |
| 4 | `RPM` | Engine speed | rev/min | scalar | src 27805. → `RPS=RPM/60` (27827); also inside `STAB` (27953) for the time step, and `FMEP` |
| 5 | `TCR` | **Trapped** compression ratio (ratio of trapped volume at exhaust closure to clearance volume) | – | scalar | src 27814. `TSV=FPISTON*HEOT`, `CYCV=TSV/(TCR-1)`, `VC1=TSV+CYCV` (26915–26917); `PC1=TCR*PA/2.5` (26948) |
| 6 | `CCR` | Crankcase compression ratio, referenced to **full** stroke | – | scalar | src 27818. `CCCV=SV/(CCR-1)` (27830); `PCC1=.9*CCR*PA` (26951); `VCC1=CCCV+FPISTON*HEOB` (26918) |
| 7 | `TEXC` | Exhaust-pipe **reference** temperature (the `Tref` of §2.5.1), not the measured gas temperature | °C | scalar | src 27821. `TEREF=TEXC+273` (27833 and 27936) → exhaust-pipe speed of sound `SDE=SQR(GE*GK*TEREF)` (27939) and `DEREF` (27942) |

> ⚠ **Order trap.** Fig.5.3 (the book's data table, src 9559–9632) lists the same block in
> the order BORE, STROKE, CON-ROD, ENGINE SPEED, **EXHAUST TEMP, TRAPPED CR, CRANKCASE CR**,
> i.e. `TEXC` *before* `TCR` and `CCR`. The program asks for `TCR`, `CCR`, **then** `TEXC`.
> Data typed straight off Fig.5.3 will be shifted by one field unless this is noticed.

### Block 2 — `EXPORTDAT` (src 27835–27867)

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 8 | `EPO` | Exhaust port **opening** timing (piston top edge uncovers port) | deg **ATDC** | scalar | src 27839. `DEG=EPO` and `ANGD=EPO` start the cycle (26958, 26994); `EPC=360-EPO` closure (27650); screen scale `EP=2*(180-EPO)` (27417) |
| 9 | `EPFO` | Exhaust port **fully open** timing | deg ATDC | scalar | src 27843. `PISTPOS(...EPFO,HEFT,HEFB)` → `EXHT=HEFT-HEOT` = full port height (27669–27670) |
| 10 | `NEP` | Number of exhaust ports | count | scalar | src 27847. `PAREA(NEP,WEPM,EXHT,...)` (26909) → `FEPRT`, `DEPRT` |
| 11 | `WEP` | Maximum (effective) width of **each** exhaust port — already reduced by the cosine of any upsweep/downdraught (§5.1.1, src 9809–9811) | mm | scalar | src 27851. `WEPM=WEP/1000`; `PWE=WEPM-2*RTEM` (27662) |
| 12 | `RTE` | Exhaust port **top** corner radius | mm | scalar | src 27856. `RTEM`; `HME=EXHT-RTEM-RBEM` (27671); in `PAREA` |
| 13 | `RBE` | Exhaust port **bottom** corner radius | mm | scalar | src 27860. `RBEM`; as above |

### Block 3 — `TRPORTDAT` (src 27868–27903)

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 14 | `TPO` | Transfer port opening timing | deg ATDC | scalar | src 27872. `TPC=360-TPO` (27653); `PISTPOS(...TPO,HTOT,HTOB)` (27672); opens the scavenge model |
| 15 | `TPFO` | Transfer port fully open timing | deg ATDC | scalar | src 27876. `HTFT` → `TRHT=HTFT-HTOT` (27674) |
| 16 | `NTP` | Number of transfer ports | count | scalar | src 27879. `PAREA(NTP,WTPM,TRHT,...)` (26911) → `FTPRT` → `FTDUCT=TRAR*FTPRT` (26913) |
| 17 | `WTP` | Maximum (effective) width of **each** transfer port — the §5.1.1 averaging rule applies: for ports of differing width and upsweep, enter `sum(W*cos(upsweep))/NTP` | mm | scalar | src 27883 (prompt says `WE`). `WTPM`; `PWT=WTPM-2*RTTM` (27663) |
| 18 | `RTT` | Transfer port top corner radius | mm | scalar | src 27888 (prompt says `RTE`). `RTTM`; `HMT=TRHT-RTTM-RBTM` |
| 19 | `RBT` | Transfer port bottom corner radius | mm | scalar | src 27892. `RBTM`; as above |
| 20 | `SCAV$` | Scavenging type **character string**: `UNIFLOW`, `SCRE`, `YAM1`, `YAM6`, `CD`, `QUBCR` | – (selector) | scalar string | src 27897. `PORTSTART` (27680–27691) maps it to `MSC`/`CSC`, used in `SEFF=1-EXP(MSC*SR+CSC)` |

> ⚠ `SCAV$` is matched with an exact string comparison. A mis-typed or differently-spaced
> value (e.g. `YAM 1`, as the book's own PRINT line spells it at src 27894) matches nothing,
> `MSC`/`CSC` stay 0, and `SEFF=1-EXP(0)=0` silently — every cylinder then runs with zero
> scavenging efficiency and no error is reported.

### Block 4 — `INPORTDAT` (src 27904–27933)

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 21 | `IPO` | Inlet port opening timing | deg **BTDC** (note: opposite sign convention to the exhaust/transfer ports) | scalar | src 27911. `IPC=360+IPO` (27651), `IPOD=360-IPO` (27652); `PISTPOS(...IPO,HIOT,HIOB)` |
| 22 | `IPFO` | Inlet port fully open timing | deg ATDC | scalar | src 27916. `HIFT` → `INHT=HIOT-HIFT` (27678) |
| 23 | `NIP` | Number of inlet ports | count | scalar | src 27918. `PAREA(NIP,WIPM,INHT,...)` → `FIPRT` |
| 24 | `WIP` | Maximum (effective) width of each inlet port | mm | scalar | src 27922. `WIPM`; `PWI=WIPM-2*RTIM` |
| 25 | `RTI` | Inlet port top corner radius | mm | scalar | src 27924. `RTIM`; `HMI=INHT-RTIM-RBIM` |
| 26 | `RBI` | Inlet port bottom corner radius | mm | scalar | src 27927. `RBIM` |

### Block 5 — `EXLENDAT` (src 27224–27254) — **Prog.5.2 only**

Six consecutive parallel pipe segments of the expansion chamber, from the exhaust port
outwards (Fig.5.2(b), src 9528–9537).

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 27 | `LP01` | Length, cylinder face → segment 1/2 junction | mm | segment 1 of 6 | src 27227. `LP01M`; `LEPM=sum(LP01M..LP56M)` (26960); `NINT(KQ1,LP01,...)` → `K1` |
| 28 | `LP12` | Length, junction 1/2 → 2/3 | mm | segment 2 | src 27230 → `KQ2`, `K2` |
| 29 | `LP23` | Length, junction 2/3 → 3/4 (the divergent cone) | mm | segment 3 | src 27235 → `KQ3`, `K3` |
| 30 | `LP34` | Length, junction 3/4 → 4/5 (the parallel belly) | mm | segment 4 | src 27238 → `KQ4`, `K4` |
| 31 | `LP45` | Length, junction 4/5 → 5/6 (the convergent cone) | mm | segment 5 | src 27241 → `KQ5`, `K5` |
| 32 | `LP56` | Length, junction 5/6 → open end (the stinger) | mm | segment 6 | src 27245 → `KQ6`, `K6` |

> The listing prints `LP54` and `LPg`/`LP56` in the Fig.5.2(b) sketch (src 9532–9534) —
> those are OCR artefacts of the *figure*, not of the code. The code is uniformly
> `LP01…LP56`, six lengths, six diameters, in ascending segment order.

### Block 6 — `EXDIADAT` (src 27255–27293) — **Prog.5.2 only**

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 33 | `DEP1` | Diameter of segment 1 (constant from port to first junction) | mm | pipe 1 of 6 | src 27258. `DE1M`, `FEP1=PI*DE1M^2/4`; `AREA(DE1M,DE1M,K0,K1,...)` |
| 34 | `DEP2` | Diameter of segment 2 | mm | pipe 2 | src 27261. `AREA(DE1M,DE2M,K1,K2,...)` — segment 2 is a linear taper from DEP1 to DEP2 |
| 35 | `DEP3` | Diameter at the end of segment 3 | mm | pipe 3 | src 27264. `AREA(DE2M,DE3M,K2,K3,...)` |
| 36 | `DEP4` | Diameter at the end of segment 4 | mm | pipe 4 | src 27266. `AREA(DE3M,DE4M,K3,K4,...)` |
| 37 | `DEP5` | Diameter at the end of segment 5 | mm | pipe 5 | src 27270. `AREA(DE4M,DE5M,K4,K5,...)` |
| 38 | `DEP6` | Diameter at the end of segment 6 (= the open end) | mm | pipe 6 | src 27273. `AREA(DE5M,DE6M,K5,K6,...)`; `AE(K6)`/`BE(K6)` is the open-end boundary |

Each segment is discretised today as a **linear taper** from its entry diameter to its
exit diameter (`SUB AREA`, src 27970–27980), so a real stepped junction is modelled as a
one-mesh taper — the reason the book uses six segments for a five-feature pipe.

### Block 7 — `TRPIPDAT` (src 27570–27591) — shared

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 39 | `LTP` | Transfer duct length, transfer port → crankcase (Fig.5.1 "LENGTH.T") | mm | scalar | src 27579. `LTM=LTP/1000`; `NINT(KT,LTP,TEREF,TTREF)` (26972) → `KT`; `LTMESH=LTM/(KT-1)` |
| 40 | `TRAR` | Transfer-port-to-transfer-duct **area ratio** (duct area = TRAR × total port area at full opening). Typical 1.2–1.5 (§5.1.2, src 9850–9851) | – | scalar | src 27583. `FTDUCT=TRAR*FTPRT` (26913); `DTDUCT=SQR(4*FTDUCT/PI)` |

> The transfer duct is assumed **untapered** and its area is *derived* from the port area,
> so `TRAR` is the only geometry input for the duct cross-section. It is not a
> measurement; it is a design assumption.

### Block 8 — `INPIPDAT` (src 27592–27611) — shared

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 41 | `LIP` | Inlet tract length, piston face → carburettor venturi/throttle body | mm | scalar | src 27594. `LIM`, `NINT(KI,LIP,TEREF,TIREF)` (26973) → `KI`, `LIMESH` |
| 42 | `DIP` | Carburettor flow diameter (venturi). The duct is linearly tapered from the full inlet port area to this diameter (§5.1.2, src 9852–9859) | mm | scalar | src 27596 (prompt prints `DEPD`/`DIP`). `DIPM`, `FIPM=PI*DIPM^2/4`; `AREA(DIPRT,DIPM,K0,KI,...)` (26991) |
| 43 | `THAR` | Throttle area ratio, 1.0 = fully open | – | scalar | src 27605. Used directly as the port coefficient of discharge at the inlet pipe end: `AK=THAR; CALL PORT(BI(KI),AI(KI),PA,AK)` (27025–27026) |

`THAR` is the **load** control, not a geometry data item — it is the one input a user
sweeps to move along a part-load curve. For a diaphragm carburettor that is fully open
yet still restricts, the book's chainsaw example sets 0.75 at "full throttle"
(src 10783–10790), and Fig.5.3 gives QUB 400 `1 & 0.25` for the full- and quarter-throttle
runs.

### Block 9 — `COMBDAT` (src 27612–27648) — shared

| # | Field | Meaning | Units | Array index | Where used in the code |
|---|---|---|---|---|---|
| 44 | `NC` | Polytropic index of **compression** (closed cycle, before tdc) | – | scalar | src 27616. `POLYINDEX=NC` for `DEGC<=360`; recommended 1.25 |
| 45 | `NE` | Polytropic index of **expansion** (closed cycle, after tdc) | – | scalar | src 27622. `POLYINDEX=NE` for `DEGC>360`; recommended 1.35 |
| 46 | `BEFF` | Combustion (heat-release) efficiency — fraction of the fuel's calorific value actually released | – | scalar | src 27630. `HEAT=BEFF*CVAL*MAIR/TAFB` (28154) |
| 47 | `BDEG` | Combustion period — crank degrees from start to end of heat release. Not an ignition timing: the release is phased symmetrically about tdc (src 10109–10120) | deg | scalar | src 27638. `IGN=360-BDEG/6`, `BURNEND=IGN+BDEG`, `TAILDEG`, `PEAK`; also `QMAX=36*HEAT/(14*BDEG)` (28155) |
| 48 | `TAF` | Trapped air-fuel ratio (mass). Also the default `TAF=13` set at src 26854 | – | scalar | src 27640/27645. `FUEL(JJ)=DRATIO*MREF/TAF` (27182); `TAFB` and `HEAT` in `CYLINDER` |

**Count check:** 7 + 6 + 7 + 6 + 6 + 6 + 2 + 3 + 5 = **48 entries** (47 numeric + 1 string).
Blair states "There are 48 different data numbers which can be changed in those engine
models for a single calculation" (src 11964) — consistent, if `SCAV$` is counted as one.
For Prog.5.1 the total is 40 numeric + 2 strings, because it takes five box dimensions
(`LEP1, DEP1, LEP2, DEP2, VBOX`) plus `SIL$` instead of the twelve tuned-pipe numbers.

---

## 3. Arrays and dimensions

`ABX(21,45)` — the one that needs explaining:

| Array | Declared | Actually used | What the two subscripts index |
|---|---|---|---|
| `ABX(21,45)` | 21 × 45 | 21 × **41** | **I** = 1…21 = the *port-to-pipe area ratio* `AK`, values 0, .05, .10, … 1.00 (step .05, set by `AKA(I)` at src 26872–26875). **J** = 1…41 = the *reflection amplitude ratio* `BX1 = B1/Xc`, values .60, .62, … 1.40 (step .02, read as `BX(J)=ABX(1,J)` at src 26870). `ABX(I,J)` is the value of `(A1+B1)/Xc` from Fig.2.7 for that (AK, B/Xc) pair. |
| `BX(45)` | 45 | 41 | `BX(J)`, the J-axis breakpoints .60…1.40; it *is* row I=1 of ABX. |
| `AKA(45)` | 45 | 21 | `AKA(I)`, the I-axis breakpoints 0…1.00. Built arithmetically, not read from file. |
| `AE(60), BE(60), FE(60), DFE(60)` | 60 | `K6` | Exhaust pipe: mesh index 1 = cylinder end, `K6` = open end. `A` = outgoing amplitude ratio *f*, `B` = incoming *g*, `F` = area at the mesh, `DF` = area change between meshes. |
| `AT(20), BT(20), FT(20), DFT(20)` | 20 | `KT` | Transfer pipe, same convention; end `KT` = crankcase end. |
| `AI(20), BI(20), FI(20), DFI(20)` | 20 | `KI` | Inlet pipe, same convention; end `KI` = atmosphere/throttle end. |
| `A2(60), B2(60)` | 60 | `K6` | Scratch copies inside `SUB PIPE` (updated values written here, then copied back). |
| `DF(60), F(60)` | 60 | **unused in Prog.5.2** | Generic work arrays; Prog.5.2 uses only the per-duct triples. |
| `POWER(), BMEP(), BSFC(), CMEP(), PMEP(), DELRAT(), SEFFP(), TEFFP(), CEFFP(), SRMP(), SRVP(), EXRP(), PEAKP(), PEAKT()` | **not declared** | index `JJ` = cycle 1…9 | One value per engine cycle, filled in `RESETBDC`/`RESETTDC`. In this BASIC dialect an undeclared array defaults to subscripts 0…10, which happens to contain `CYCLESTOP=9`. |

Why 45 rather than 41: `SUB PORT` evaluates `BX(J+1)` and `ABX(I,J+1)`, so the arrays must
extend one element beyond the last valid breakpoint (J=41 at BX1=1.40). The same
over-allocation is why `AE`… are dimensioned 60 when a 6-segment pipe only needs ~20–40
meshes.

---

## 4. The "UFLO" data file

**Identified and fully specified** at src 20119–20131 (Computer Data Bank 2.0, pp.228 ff.):

> "DATA FILE "UFLO" — This File is an array ABX(I,J) of 21 by 41 elements. This file
> contains the sonic and subsonic solution for inflow and outflow for unsteady flow where
> g = 1.4. The following banks of 41 numbers are the J array elements and each bank in turn
> is an I set, starting at 1 and going up to 21. The AK value at the start of each bank is
> for information only and is not part of the data set. The ABX(I,J) is the numeric value
> of (A1+B1)/Xc in Fig.2.7. The ABX(I = 1,J) value is BX(J) in the program and is the value
> of B1/Xc shown in Fig.2.7. The AK, or port to pipe area ratio, are the numbers in front of
> each bank below."

| Property | Value |
|---|---|
| Filename used by the code | literal `"UFLO"` — no extension, current directory (src 26856) |
| Access mode | `OPEN "I",#1,"UFLO"` — sequential text input |
| Size | 861 numbers (21 banks × 41 values) |
| Delimiter | comma-separated (`INPUT#1,ABX(I,J)` reads one comma-delimited field). Line breaks are irrelevant to the parser. |
| Read order | `FOR I=1 TO 21` outer, `FOR J=1 TO 41` inner (src 26857–26861) → **J varies fastest**; the 41 values of row I=1 come first, then all 41 of row I=2, etc. |
| Row I=1 | the 41 `BX` values themselves, .60 .62 .64 … 1.40 |
| Rows I=2…21 | 20 further banks, one per AK from .05 to 1.00 |
| Column J=1…41 | `BX1 = B1/Xc` from .60 to 1.40 |
| Data stored | `(A1+B1)/Xc` of Fig.2.7 — the non-dimensional superposition pressure amplitude at a port, i.e. the solution of the port boundary condition |
| Physics | perfect gas, γ = 1.4 only; covers both inflow (B negative) and outflow (B positive) |
| Not data | the printed `AK=0`, `AK=.05`, … labels that head each bank on the page |
| Other programs reading it | Progs.2.2, 2.3, 5.1 and 5.2 all open the same file (src 20367, 20603, 21273, 26037) |

**How it is indexed inside the model** — `SUB PORT`, src 28034–28048:

```
X1=(P/PA)^(1/7)          ' isentropic pressure amplitude ratio
BX1=B/X1                 ' normalised incoming amplitude
IF AK>.95 THEN AK=.95    ' upper clamp on the AREA-RATIO axis only
IF BX1<.6 THEN BX1=.6    ' lower clamp on the amplitude axis only
I=INT(AK/.05)+1          ' -> 1..20, so I+1 <= 21
J=INT((BX1-.6)/.02)+1    ' -> 1..41
linear interpolate ABX in I, then in J, then A=2*X1*ABX1-B
```

Consequences worth knowing before trusting the interpolator:

* `AK` is clamped at .95 (not 1.0) precisely so `ABX(I+1, …)` stays inside 21 rows.
* `BX1` is clamped **only from below**. There is no upper clamp, so any state that
  produces `BX1 > 1.40` indexes `J=41` and then interpolates against `BX(42)`, which is
  never initialised (0) — a divide-by-zero or a wild value. The bank is valid only for
  `0.6 <= B/Xc <= 1.4`.
* The interpolation is in `AK` and `B/Xc`, not in pressure or velocity, so the same 861
  numbers serve every port at every crank angle in every engine.

---

## 5. Units

Everything the user types is in **mm, degrees, revolutions/minute, cm³ and °C**
("ALL DATA IN mm AND deg UNITS", src 27298; the same line appears in Prog.5.1's DATASET at
src 26467). All physics inside is SI.
The conversion is done in exactly three places — `ENGINEDAT` (27824–27833),
`FILESET` (27127–27170) and the tail of each port block:

| Quantity | Input unit | Internal variable | Conversion |
|---|---|---|---|
| Lengths, diameters, radii, widths, port heights | mm | `…M` suffix, m | `/1000` |
| Angles, timings | deg crank | deg | `DTOR=PI/180` inside `PISTPOS` only |
| Speed | rev/min | `RPS`, rev/s | `/60` |
| Pressure | — (never input) | Pa | `PA=101325!`, `PCC1=.9*CCR*PA`; displayed as bar via `/100000!` |
| Temperature | °C (`TEXC` only) | K (`TEREF`) | `+273` |
| Area | — (derived) | m² | `PI*D^2/4` |
| Volume | — (derived); box volume in cm³ for Prog.5.1 | m³ | `VBOX/1000000!` (src 26459) |
| BMEP/IMEP/PMEP/FMEP | — (computed) | Pa | shown in bar |
| BSFC | — (computed) | kg/kWh | shown as kg/kWh and g/kWh |

Note the *deliberate* mixing in `SUB NINT`: pipe lengths are passed in **mm** (`LP01`,
`LTP`, `LIP`) because `LMESH=30` is also in mm, while `LEMESH=LEPM/(K6-1)` is in **metres**.
Both are correct — `NINT` returns a mesh *count*.

---

## 6. The save file (`.BOX`) — and a real trap

`FILING` (src 27538) writes eight comma-delimited records with `WRITE#`; `FILED`
(src 27552) reads them back with `INPUT#`. Both programs use the extension `.BOX`.
A `.BOX` file therefore holds one complete data set, including one value of `THAR` —
i.e. one load point per file.

**Prog.5.2 record order** (src 27542–27549):

| Record | Fields |
|---|---|
| 1 | `BO, ST, CRL, RPM, TEXC, TCR, CCR` |
| 2 | `EPO, EPFO, NEP, WEP, RTE, RBE` |
| 3 | `TPO, TPFO, NTP, WTP, RTT, RBT, SCAV$` |
| 4 | `IPO, IPFO, NIP, WIP, RTI, RBI` |
| 5 | `LP01, LP12, LP23, LP34, LP45, LP56` |
| 6 | `DEP1, DEP2, DEP3, DEP4, DEP5, DEP6` |
| 7 | `LTP, TRAR, LIP, DIP, THAR` |
| 8 | `NC, NE, BEFF, BDEG, TAF` |

**Prog.5.1 record order** (src 26820–26825) is *different in two places*:

| Record | Fields |
|---|---|
| 1 | `BO, ST, CRL, RPM, **TCR, CCR, TEXC**` ← the last three swapped |
| 5 | `LEP1, DEP1, LEP2, DEP2, VBOX, SIL$, **LTP, TRAR, LIP, DIP, THAR**` ← pipe data on record 5, not 7 |

> ⚠ A `.BOX` written by Prog.5.1 and read by Prog.5.2 silently loads `TCR` into `TEXC`,
> `CCR` into `TCR`, `TEXC` into `CCR`, and then takes box-silencer dimensions as tuned-pipe
> dimensions. No validation, no magic number, no version field. The two file formats must be
> kept apart by filename convention.

`SCAV$` and `SIL$` are written as quoted strings by `WRITE#`, so `INPUT#` recovers them
including embedded commas — but a comma inside the typed scavenging word would still break
the record parse.

---

## 7. Physical measurements vs calibration constants

This is the distinction that decides whether a model can be "tuned" to a test bed.

### (a) Genuine physical measurements / designer's geometry — taken off the engine

**36 of the 47 numeric inputs.**

`BO, ST, CRL` (3) · `EPO, EPFO, NEP, WEP, RTE, RBE` (6) · `TPO, TPFO, NTP, WTP, RTT, RBT` (6) ·
`IPO, IPFO, NIP, WIP, RTI, RBI` (6) · `LP01…LP56` (6) · `DEP1…DEP6` (6) ·
`LTP` (1) · `LIP` (1) · `DIP` (the carburettor bore, a bought-in dimension) (1) = **36**.

The remaining 11 numeric entries split as: 8 calibration constants (table b), `TCR` and
`CCR` on the boundary, and `RPM` as the test operating point.

`TCR` and `CCR` sit on the boundary: they are properties of the engine as built, but
`TCR` in this program is the **trapped** ratio referenced to exhaust closure
(`CYCV=FPISTON*HEOT/(TCR-1)`), which must be measured or computed as
`(V_clearance + V_trapped)/V_clearance`, *not* read off a geometric-compression-ratio
specification sheet.

### (b) Empirical / calibration constants — **not** properties of the engine

| Field | Why it is a calibration constant | Book's own values |
|---|---|---|
| `TEXC` | the pipe *reference* temperature of §2.5.1, a modelling assumption about mean pipe gas temperature; the prompt itself calls it "EXHAUST PIPE REFERENCE TEMPERATURE" | 400 °C (QUB 400), 400 (saw), 550 (Husqvarna), 650 (125 GP) |
| `TRAR` | assumed transfer-duct/port area ratio; the book gives only a *range* | "Typical values … range from 1.2 to 1.5" (src 9851); 1.20–1.40 in Fig.5.3 |
| `THAR` | the load-setting variable, not a geometry | 1.0 full / 0.25 quarter (QUB 400); 0.75–1.0 elsewhere |
| `BEFF` | heat-release efficiency, fitted to the QUB 400 combustion diagrams in §4.2.3 | 0.85 for QUB 400 and the chainsaw; 0.80 for the Husqvarna and the 125 GP (Fig.5.3, src 9628/9665/9702/9739) |
| `BDEG` | combustion period, same fit | 60° QUB 400; 50° chainsaw; 55° Husqvarna; 50° 125 GP (Fig.5.3, src 9629/9666/9703/9740) |
| `TAF` | trapped air-fuel ratio — measured if you can, assumed if you cannot | 13 for QUB 400 (the book's own measured value); 13 chainsaw; "AS EXPT" (11.1–11.5 per text) Husqvarna; 12 for the 125 GP |
| `NC`, `NE` | polytropic indices recommended for general use in §4.3.1, not measured | 1.25 / 1.35 for all four engines |
| `SCAV$` | a **selector**, not a number: it picks a slope/intercept pair measured on a *different* single-cycle rig | Fig.3.14 values (src 6600–6634) |

### (c) Calibration constants that are hard-coded and cannot be changed from the keyboard

| Constant | Value | src | Meaning |
|---|---|---|---|
| `PA` | `101325!` Pa | 26943 | ambient (reference) pressure |
| `TA` | 293 K | 26944 | ambient temperature |
| `GE`, `GK` | 1.4, 287 J/kgK | 26936–26937 | reference ratio of specific heats and gas constant |
| `CCP`, `CCV` | 1005, 718 J/kgK | 26938–26939 | reference cp, cv for the cold ducts |
| `CVAL` | 4.3E+07 J/kg | 26957 | calorific value of the fuel |
| `TTREF`, `TIREF` | 320 K, 300 K | 27937–27938 | reference temperatures of the transfer and inlet ducts |
| `LMESH` | 30 mm | 26959 | exhaust-pipe mesh length (all other meshes are scaled from it) |
| `CYCLESTOP` | 9 | 26996 | cycles calculated in one run |
| **`FMEP`** | `100*STM*RPM` (Pa) | 27832 | **the whole friction model**: FMEP[Pa] = 100 × stroke[m] × speed[rpm]. Check: 100 × 0.070 × 3000 = 21 000 Pa = **0.21 bar**, exactly the FMEP printed in Fig.5.9 for the QUB 400. |
| `AK` clamps | .9 / .75 | 27022–27030 | discharge-coefficient-like coefficients at the pipe ends, chosen by flow direction |
| scavenge `MSC`/`CSC` | 6 pairs | 27680–27691 | = Fig.3.14, keyed by `SCAV$` |

`FMEP` is the single most important thing *not* on the input list: the user cannot supply a
measured friction curve, so any correlation against a real bsfc is limited by Blair's
`100·L·N` law.

---

## 8. What the book does *not* state

| Gap | Status |
|---|---|
| The **exact** shape of the six pipe segments beyond their lengths and end diameters | NOT SPECIFIED numerically; the code taper-interpolates each segment linearly (`SUB AREA`), and Fig.5.2(b) is the only statement of intent |
| Whether `WEP`/`WTP`/`WIP` already include the upsweep cosine | YES for transfer ports (§5.1.1, worked example src 9809–9811); NOT STATED explicitly for exhaust/inlet ports, though the heading "effective width … in the gas flow direction" (src 9543) implies yes |
| `IPFO` when the inlet port is fully open exactly at tdc | QUB 400 uses `IPFO=0` (Fig.5.3), so "fully open, deg ATDC" includes 0 = tdc |
| Which of the two `TRPORTOPEN` blocks is the default | NOT STATED; both are printed and the user must delete one |
| A file-format version/validation for `.BOX` | absent (see §6) |
| Any check that `SCAV$` matched one of the six strings | absent (see §2, block 3) |
| Turbulence, heat transfer to walls, blow-by, reed/disc induction | explicitly outside the model (src 11055–11064) |

---

## 9. Cross-checks that confirm this reading

These are arithmetic on the book's own numbers, and they hold to the digit — which is the
strongest evidence that the input list above is complete and correctly ordered:

| Check | Result |
|---|---|
| QUB 400 swept volume from `BO=85`, `ST=70` | π/4 × 85² × 70 = 397.0 cm³ |
| Fig.5.4(a) box volume 10 000 cm³ vs "twenty-five times larger than the cylinder swept volume" (src 9835) | 10 000 / 397 = 25.2 ✓ |
| `FMEP=100*STM*RPM` at 3000 rpm | 0.21 bar = Fig.5.9 FMEP ✓ |
| `IMEP − PMEP − FMEP = BMEP` | 6.72 − 0.38 − 0.21 = 6.13 ≈ 6.14 ✓ (Fig.5.9) |
| Power from BMEP: 6.14 bar × 397 cm³ × 50 rev/s | 12.19 kW = Fig.5.9 "12.2" ✓ |
| `CYCV=TSV/(TCR-1)` with `TSV=FPISTON*HEOT` | requires `HEOT` from `PISTPOS` at `EPO=96°` — confirms `TCR` is the *trapped* ratio |
| 48 data entries counted in §2 | 48 ✓ (src 11964) |
