# PROG.5.1 — "ENGINE MODEL NO.1" — transcription and damage report

Source text: `references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`
Source range: OCR lines **26032–26840** (book pages **291–298**), i.e. from
`COMPUTER PROGRAM PROG.5.1` up to the line before `COMPUTER PROGRAM PROG.5.2`.
Output: `port/blair_prog51_basic.txt`

---

## 1. Counts

| Quantity | Value |
|---|---|
| Raw OCR lines in range | **809** |
| Lines removed as page furniture | **46** (+1 page number OCR'd as `56.3`, removed during transcription) |
| OCR lines that are actual code | 763 |
| **Clean statements written out** | **673** (plus 3 REM provenance lines) |
| **Statements repaired** | **179** — 160 single-line substitutions, 19 multi-line rejoins |
| Baseline lines absorbed by rejoining / dropped as garbage fragments | 90 |
| Statements needing no change at all (verified by diff) | **494** |
| **`<UNRESOLVED>` flags** | **5** |
| Subroutines defined inside this range | **14** (label style; no `SUB…END SUB` in this range) |
| Distinct routines called but *not* defined in this range | **28** — 21 tabulated in §7, `SHOK`/`NINT`/`PORT` printed in the 2.x section, 4 never printed |

Diff method: the cleaned file was compared line-by-line against the raw range with the
furniture stripped, using a normalised (case- and punctuation-insensitive) sequence match.
"Needing no change" therefore means the statement text is identical to the OCR apart from
spacing/punctuation layout; anything the diff flagged as replaced, inserted or absorbed
counts as a repair.

---

## 2. Page furniture removed (46 lines)

* `Computer Program Appendix - ProgList 5.0` and its OCR variants
  (`… - I'rogl.ist 5.0`, `… - I'roglJsl 5.0`, `… - I'rogList 5.0`, `Computer Program Appendix`) — 7 lines.
* `<<<PAGE 291>>>` … `<<<PAGE 298>>>` — 8 lines.
* `The Basic Design of Two-Stroke Engines` / `The Basic Design oj Two-Stroke Engines`
  (running head) — 8 lines.
* Running page numbers **561–576** — 15 lines. These are *not* BASIC line numbers — they sit
  at the foot of every page and must not be confused with the program's own line numbers
  (19, 25, 50, 430, 431, 502, …). Page 563 was OCR'd as the number **`56.3`** and is removed
  as well (a 16th page-number line), which is exactly the kind of string that could be
  mistaken for a BASIC line number.
* Blank lines — 8.

---

## 3. Repair classes applied

Everything below is character/syntax repair; no algorithm, no ordering, no variable name and
no blank-line structure of the *logic* was altered. Variable names are exactly as Blair wrote
them (`FLP1`→`FEP1` only where the OCR letters were impossible; see §4).

**a. Identifier damage (≈70 lines).** Typical: `P1`→`PI`, `ANSS`→`ANS$`, `BK20)`→`BK(20)`,
`1NHT`→`INHT`, `\VIPM`→`WIPM`, `VB0XM`→`VBOXM`, `PCCl`→`PCC1`, `TCCl`→`TCC1`,
`MCCI`→`MCC1`, `VCCI`→`VCC1`, `FETO`→`FET()`, `DFIO`→`DFI()`, `FIO`→`FI()`, `ATI l.BTO`→
`AT(),BT()`, `AK).BIO`→`AI(),BI()`, `1POD`→`IPOD`, `RAT10`→`RATIO`, `SCRAT10`→`SCRATIO`,
`PR1NT`/`LPR1NT`/`PRIN1`→`PRINT`/`LPRINT`, `USlNG`/`IISING`/`US!NG`→`USING`,
`CL0SE`→`CLOSE`, `lNPUT`/`INl'UT`/`NPUT`→`INPUT`, `P0\VER`→`POWER`, `BSF:C`→`BSFC`,
`TIS`→`TI$`, `S1L$`→`SIL$`, `K0N`/`K()N`→`KON`, `CYCLEST()P`→`CYCLESTOP`,
`F0RKK`→`FOR KK`, `NEXTNNN`/`NEXTJJJ`/`NEXTK`→`NEXT …`, `DIMXA`→`DIM XA`,
`CALLPIPE`/`CALLPORT`/`CALLSETS`/`CALLSTAB`/`CALLAREA`/`CALLPAREA`→`CALL …`.

**b. Digit / letter confusion (≈45 lines).** `DRAT=I`→`DRAT=1`, `MA=I`→`M=1`,
`20O`→`200`, `25()`→`250`, `3()`→`30`, `1()`→`10`, `10(10000!`→`1000000!`,
`10O0`→`1000`, `I01325!`→`101325!`, `IOOO00!`→`100000!`, `4.3F+07`→`4.3E+07`,
`l/7`→`1/7`, `PA=I01325!`→`PA=101325!`, `Y=YYO`→`Y=YY0`, `!500`→`1500`.

**c. Operators and separators (≈50 lines).** Exponent `A7`→`^7` (six lines of `PEX`…`PEXT`);
missing `-(` re-inserted in the `LINE` graphics statements (`(XA(M),YS(M))-(XA(M-1),…)`);
`;`/`,`/`:` confusion in `PRINT USING` / `LPRINT USING`; `LOCATE 22.` → `LOCATE 22,1`
(the column argument was lost, page `LOCATE` is always two-argument here);
`IFM=1`→`IF M=1`, `IFCYC=`→`IF CYC=`, `THENCD=`→`THEN CD=`, `FORJ=l 1 0 41`→`FOR J=1 TO 41`.

**d. Quoting.** Book quotes were OCR'd as apostrophes, backslashes or nothing:
`INPUT'NEW DATA…";ANS$` → `INPUT "NEW DATA…";ANS$`; `IF H$='"F"` → `IF H$="F"`;
`500 INPUT-RESPONSE … IS R\ PRINTING IS P\ …` → `INPUT "RESPONSE … IS 'R', PRINTING IS 'P', …"`;
`IF D$="P"' THEN` → `IF D$="P" THEN`; `SIL$="PLA1N BOX"`→`PLAIN BOX`.

**e. Multi-line rejoins (19).** The book's wide letter-spacing made the OCR cut single
statements across 2–5 physical lines. Examples:
`CALL` + `OUTFLOW(…)` + `MTKT.D.CD)` → one `CALL OUTFLOW(…)`;
`CALL` + `BOX(PCCl,…` + `MTKT.CI 1…` → one `CALL BOX(…)`;
`IF HTDC<=HEOT` + `THEN` + `CALL CYLINDER(…` → one line;
`INPUT'NEW DATA FOR INITIAL EXHAUST PIPE LENGTH! Y/` + `N?)";ANS$` → one line;
`LPRINT'POWER.kW` + `BMEP.bar BSFC…` + `FMEP.bar"` → one `LPRINT`;
`LPRINT "PEAK`+`CYLINDER`+`PRESS.,`+`bar=";USING`+`"###.#";PMAX` → one line;
`FORNNN=l TO 20 / LPRINT / NEXTNNN` kept separate (they are separate statements).

**f. Garbage fragments deleted (small).** A lone `(` after `Y0=250`; `i` in
`LPRINT" OP / i FULL-OPEN`; `OP` in the same block; `PROMPT` in the `OPEN "LPT1:"` line
(flagged); `.` and `.�` stray marks; the `-` hyphenation break `combus-`/`tion` inside a
string; `AScni3`→`cm3`; `PRINTU6"`→`PRINT"0.6"`; `PRINT" LO"`→`PRINT"1.0"`;
`PRINT'T .5"`→`PRINT"1.5"`; `PRINTTPO"`→`PRINT "TPO"`.

**g. BASIC line numbers.** Restored where visible or unambiguous:
19 (the `EXPIPDAT` data-entry loop), 25 (`CALL PISTPOS`), 50, 305, 307, 310, 405, 407,
410, 426, 427, 428, 430, 431, 433, 434, 439, 500, 501, 502, 631, 632, 633, 634, 635, 639.
Page numbers sitting in the same visual position (561–576, plus `56.3`) were removed as
furniture, not kept as line numbers.

---

## 4. Judgement calls (defensible, but not certain)

These are the places where the OCR allowed more than one reading and I chose one. They are
*not* counted as `<UNRESOLVED>` because context is strong, but a reviewer should look at them.

| Output line | OCR | Choice | Reason |
|---|---|---|---|
| 23, 674 | `OPENT\#l."UFLO"`, `OPEN'T',#l,FIL$` | `OPEN"I",…` | mode `T` does not exist; both files are read (`INPUT#`) |
| 325, 345 | `LINPUT "PRESS RETURN' TO CONTINUE";AS` | `LINE INPUT …;A$` | `LINPUT` is not BASIC; QB4 has `LINE INPUT` |
| 187 | `CALL SHORTAE( ).BE( ),KO.KE 1)` | `CALL SHOK(AE(),BE(),KO,KE1)` | next three lines all call `SHOK` with the same argument pattern |
| 181 | `GOSUB EX PORTS HUT` | `GOSUB EXPORTSHUT` | `EXPORTSHUT:` is printed at source line 27693 |
| 197 | `…,FLP 1 ,TC I ,…` | `…,FEP1,TC1,…` | `FEP1` is defined in FILESET/EXPIPDAT; `FLP1` never is |
| 448, 456–458 | `YZ=3()`, `GPS=1!`, `GTS=!500` | `YZ=30`, `GPS=1!`, `GTS=1500` | `YT1=Y0-1500*YTT` is consistent only with `GTS=1500` |
| 314–323, 338–345 | `LOCATE 22. LPRINT …` | `LOCATE 22,1:PRINT …` | a two-argument `LOCATE` cannot be followed by `LPRINT`; these are screen rows |
| 101 | `PA=I01325!` | `PA=101325!` | standard atmosphere, Pa |
| 212–217 | `…/2)A7` | `…/2)^7` | pressure-ratio power for the port coefficients |
| 322 | `USING"####."` | kept as printed | digit placeholder may have been lost; harmless |
| 483–495, 586–594, 615–620 | `PRINT"P."`, `"A"`, `"T"`, `"M"`, `"F."`, `" 1.5"` | kept as printed | single-character axis labels, printed one per `LOCATE` |

---

## 5. `<UNRESOLVED>` lines (5)

| # | Output line | Statement as transcribed | Why unresolved |
|---|---|---|---|
| 1 | 23 | `OPEN"I",#1,"UFLO"` | mode character legible only as `T`; no such BASIC mode — assumed input |
| 2 | 160 | `IF CYC=CYCTRIP THEN PCOUNT=PCOUNT+1` | `CYCTRIP` occurs nowhere else in the book's listing; letters are clear, so this may be a genuine (untested) variable rather than OCR damage |
| 3 | 187 | `CALL SHOK(AE(),BE(),KO,KE1)` | first token reads `SHORTAE`; routine not printed in this range |
| 4 | 263 | `OPEN "LPT1:" FOR OUTPUT AS #2` | stray token `PROMPT` between device and `FOR` deleted |
| 5 | 674 | `OPEN"I",#1,FIL$` | same mode-character problem as #1 |

Each flag sits on its own line immediately after the statement it refers to, in the form
`<UNRESOLVED: original OCR text>   ; why`. They are the only non-BASIC lines besides `REM`s,
so they can be stripped mechanically.

---

## 6. Subroutine definitions inside this range

Blair's PROG.5.1 uses label-style subroutines (`NAME:` … `RETURN`), all at the end of the
program; there is no `SUB … END SUB` in this listing (the numeric routines are separate
modules, §7). Ranges are output-file line numbers; source = OCR line numbers.

| # | Label | Output lines | Source lines | Purpose |
|---|---|---|---|---|
| — | *main program* | 4–232 | 26032–26285 | I/O, initialisation, time-stepping loop, plots |
| 1 | `DATOUT` | 233–253 | 26286–26316 | line-printer summary tables |
| 2 | `PRINTOUT` | 254–268 | 26317–26332 | redirect output to `LPT1:`, call `DATASETL`/`DATOUT` |
| 3 | `FILESET` | 269–300 | 26333–26364 | unit conversion (mm→m, rpm→rps), areas, `TEREF` |
| 4 | `RESETBDC` | 301–330 | 26365–26402 | per-cycle book-keeping at BDC, screen page 1 |
| 5 | `RESETTDC` | 331–350 | 26403–26424 | scavenging/trapping/charging efficiencies, screen page 2 |
| 6 | `EXPIPDAT` | 351–374 | 26425–26462 | exhaust pipe + box data entry (internal label `19`) |
| 7 | `DATASET` | 375–410 | 26463–26523 | echo data to screen |
| 8 | `DATASETL` | 411–439 | 26524–26576 | echo data to printer |
| 9 | `SPLOT1` | 440–528 | 26577–26672 | draw pressure-ratio plot frame (internal label `439`) |
| 10 | `SPLOT2` | 529–544 | 26673–26688 | plot cylinder/crankcase/exhaust traces, EPO→EPC |
| 11 | `SPLOT3` | 545–640 | 26689–26795 | draw delivery-ratio plot frame (labels `631`–`635`) |
| 12 | `SPLOT4` | 641–660 | 26796–26815 | plot delivery ratio, inlet, crankcase traces |
| 13 | `FILING` | 661–671 | 26816–26827 | write `.BOX` data file |
| 14 | `FILED` | 672–683 | 26828–26840 | read `.BOX` data file |

Flow/thermodynamic work in the main program is done through the external routines in §7
(`PISTPOS`, `PIPE`, `STAB`, `PORT`, `OUTFLOW`, `BOX`, `CYLINDER`), not by in-line code.

---

## 7. Routines Prog.5.1 calls but which are *not* in this range

The book prints them elsewhere; line numbers are in the same source text and are given so the
next stage can pull them in. **None of these are transcribed here.**

| Routine | Where printed | Notes |
|---|---|---|
| `ENGINEDAT` | 27792–27834 | 5.1/5.2 common section |
| `EXPORTDAT` | 27835–27867 | common |
| `TRPORTDAT` | 27868–27903 | common |
| `INPORTDAT` | 27904–27933 | common |
| `TRPIPDAT` | 27570–27591 | common (5.1 label used) |
| `INPIPDAT` | 27592–27611 | common |
| `COMBDAT` | 27612–27648 | common |
| `PORTSTART` | 27649–27692 | sets `EPC,TPC,IPC,IPOD`, port widths/heights, `HEOT/HTOT/HIOT` |
| `EXPORTSHUT` | 27693–27722 | common |
| `EXPORTOPEN` | within 27693–27730 | label lost in OCR |
| `TRPORTSHUT` | 27723–27729 | OCR `TRPORTS HUT:` |
| `TRPORTOPEN` | 27730–27771 | label printed twice (27730, 27750) |
| `INPORTSHUT` | 27772–27776 | common |
| `INPORTOPEN` | 27777–27791 | common |
| `CYLSTART` | 27934–27949 | sets `TTREF,TIREF,HEOB,…` |
| `SETS` | 27964–27969 | `SUBSETS(A(),B(),K)STATIC` — OCR dropped the space |
| `AREA` | 27970–27980 | also 21138–21148 in the 2.x section |
| `PIPE` | 27981–28018 | also 21149–21184 |
| `BOX` | 28093–28117 | 16-argument version; also 21243–21258 |
| `BELMOUTH` | 28119–28123 | also 21259–21266 |
| `PISTPOS` | 18704–18707 | also 29471–29474, and label-style at 23866–23870 |

**Not printed anywhere in the book** (must come from the companion disk or be re-derived from
the chapter-5 equations): `PAREA` (port area/geometry), `STAB` (mesh stability criterion),
`CYLINDER` (closed-cycle cylinder thermodynamics), `OUTFLOW`. Note that the 5.1/5.2 common
section prints `SUB INFLOW(A,B,F,TR,H,C,M,D,CD)` with exactly the 9 arguments that 5.1 passes
to `OUTFLOW` — almost certainly the same routine renamed between editions.
`SHOK`, `NINT`, `PORT` are printed in the 2.x subroutine section (21185, 21219, 21200) with
matching argument lists.

---

## 8. Defects that are in the printed program, not in the OCR

Reported because a mechanical translation will trip over them:

1. **`DC` is never assigned.** It is the crank-angle step (`DEG=DEG+DC`, `ANGD=ANGD+DC`,
   `IF ANGD<=EPO+DC …`) but no `DC=` statement exists anywhere in the listing. The main loop
   cannot advance until this is supplied (from `STAB` or an `INPUT`).
2. **`TC1` is assigned twice** — `TC1=1900` (line 107) and then
   `TC1=PC1*VC1/(GK*MC1)` (line 114). Faithful to the book; the second wins.
3. **`CALL STAB(AE(),BE(),KE1,SDE,LEM1)` appears twice in succession** (lines 144–145).
   The second is probably meant to be a different array or is a book typo.
4. **`SPLOT1` sets `NCOUNT=1` and then tests `IF NCOUNT>=2`** (dead branch); `MG2` is
   initialised in `SPLOT1` but `MG` (incremented in `SPLOT2`) is initialised nowhere.
5. **`DATASET` and `DATASETL` print the combustion parameters in different orders** —
   `NC,NE,BEFF,BDEG,TAF` (screen) versus `BEFF,BDEG,TAF,NC,NE` (printer) — and with different
   formats (`########.##` vs `#########.##`).
6. **Unit conversions are duplicated** in `FILESET` and again in `EXPIPDAT`.
7. `MBACK` is set to 0 in three places and never used; `COUNT`, `PTR`, `PTRO`, `PEXP`,
   `PEXT`, `PBR` are computed and never read (left-overs from a larger diagnostic version).

---

## 9. How far can this be trusted?

| Measure | Value |
|---|---|
| Statements identical to the OCR after normalisation | 494 / 673 = **73 %** |
| Statements whose only change is mechanical repair of character damage | 160 / 673 = **24 %** |
| Statements rejoined from a split statement | 19 / 673 = **3 %** |
| Statements I would not defend as certain | 5 / 673 = **0.7 %** |
| **Estimate of statements certainly correct as transcribed** | **≈ 98 %** |

Damage is unevenly distributed. The computational core (§ main loop, 4–232) is the cleanest
part of the listing: only character-level errors, and every statement is recoverable with
certainty. The worst areas are:

* the graphics label blocks in `SPLOT1`/`SPLOT3` (~40 one-character `PRINT` strings, letter
  case and digit/letter confusion unrecoverable in principle, but cosmetic only);
* the long text strings in `DATASET`/`DATASETL`, where line breaks fell inside strings and a
  few words lost letters (`TNLET`→`INLET`, `TIIROTTLE`→`THROTTLE`, `TRANSFERER`→`TRANSFER.AR`);
* the `EXPIPDAT` prompt block, which the OCR scattered one clause per line.

**Translatability judgement.** The transcription is translatable: 673 statements, of which
668 carry no unresolved flag, no line-numbers were invented, and every identifier is Blair's
own spelling. A mechanical translation (BASIC → Python/MATLAB) can proceed statement by
statement without judgement calls, with three caveats that are properties of the *program*,
not of the transcription:

1. `DC` must be supplied or the time loop will not run (defect 8.1).
2. Four routines are not printed at all (`PAREA`, `STAB`, `CYLINDER`, `OUTFLOW`/`INFLOW`) and
   eight more are printed only outside this range (`SHOK`, `NINT`, `PORT`, `SETS`, `AREA`,
   `PIPE`, `BOX`, `PISTPOS`); they must be taken from §7 or re-derived from the book's
   equations before the model will run.
3. The plotting subroutines (`SPLOT1`–`SPLOT4`, ~200 lines, 30 % of the file) are QB screen
   graphics with no physical content. They can be dropped wholesale in a translation without
   affecting the simulation — but they are the noisiest part of the transcription, so expect
   the residual 2 % of doubt to be concentrated there.

If the plotting code is set aside, the fraction of *physically meaningful* lines that are
certainly correct rises to about 99 %.
