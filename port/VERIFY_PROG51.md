# VERIFY_PROG51 — independent check of `port/blair_prog51_basic.txt`

**Source:** `references/text/Blair,_G.P._—_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`, lines 26032–26840
**Transcript:** `port/blair_prog51_basic.txt`, lines 1–683
**Method:** full walk, all 764 source code lines and all 683 transcript lines, no sampling. Backed by a mechanical cross-check of every numeric token, identifier and keyword census, GOSUB/GOTO target sets, and a completeness sweep (every source line's squeezed content must appear in the transcript).

> Note: the source filename uses an **em dash** (`—`), not a hyphen. The hyphenated path in the brief does not exist.

---

## 1. Counts per class

| Class | Meaning | Count |
|---|---|---|
| **A** | Transcription error (changed something that was not damaged) | **0** |
| **B** | Legitimate OCR repair (source gibberish, repair defensible) | **136 lines** (of 675 code lines); every one inspected individually |
| **C** | Unjustified repair (source legible, changed anyway) | **1** (cosmetic) |
| **D** | Omission (source statement missing) | **0** |
| **E** | Addition (statement in transcript not in source) | **4** code statements + **8** editorial lines |

Line accounting: 764 source code lines → 675 transcript code lines + 4 added statements; the 93-line difference is accounted for exactly by 41 re-joined statements (each absorbing 2–7 source lines).

---

## 2. Class A — transcription errors

**None.** Specifically verified clean:

* All 26 numeric labels (`19, 25, 305, 307, 310, 405, 407, 410, 426, 427, 428, 430, 431, 433, 434, 439, 50, 500, 501, 502, 631, 632, 633, 634, 635, 639`) present, unique, and *every* `GOTO` target resolves to an existing label. No dangling or invented label.
* All 26 distinct `GOSUB` targets identical (58 `GOSUB`s in, 58 out).
* Statement counts preserved for `GOTO` 30/30, `NEXT` 10/10, `DIM` 9/9, `RETURN` 16/16, `WRITE` 6/6, `LOCATE` 65/65, `ELSE` 3/3, `STEP` 2/2, `SQR` 1/1, `INT(` 7/7, `CLOSE` 4/4.
* Order inside every subroutine preserved, including the ones where the natural order is counter-intuitive.
* All `.9` / `.75` / `1` discharge-coefficient polarities preserved, including the per-port argument-order reversals (`PORT(BE(K1),AE(K1),…)` vs `PORT(AET(1),BET(1),…)` vs `PORT(BET(K2),AET(K2),…)` vs `PORT(BI(KI),AI(KI),…)` vs `PORT(BT(KT),AT(KT),…)`) — all five correct.
* `<=` vs `<` asymmetry for the inlet port (`HTDC<HIOT` while the other two use `<=`) preserved.
* `CALL CYLINDER(…,VC1,VC2,MC2,…)` (8 args, `MC2` only, no `MC1`) preserved as printed, not "regularised" to match the `BOX` form.
* The `CALL STAB(AE(),BE(),KE1,SDE,LEM1)` line that appears **twice** in the source (26183/26184) is reproduced twice (144/145). A tidying transcriber would have deleted one.
* `CALL AREA(…DE2M,DE2M,KO,KE2,…)` **before** `CALL AREA(…DE1M,DE1M,KO,KE1,…)` — the reversed order of 26163/26164 is preserved.
* `DIM ABX(21,45)` with the read loop only to 41 (26037 vs 26053) preserved — not "corrected" to 45.
* `TC1` assigned twice (26043 then 26051 region) preserved.
* `NINT(KT,LTP,TEREF,TTREF)` and `NINT(KI,LIP,TEREF,TIREF)` — the `TTREF`/`TIREF` (not `TEREF`) arguments preserved.

---

## 3. Class C — unjustified repair (source legible, changed anyway)

| # | Source line | Source text | Transcript line | Transcript text | Change |
|---|---|---|---|---|---|
| C1 | 26771 | `PRINT"0.7"` | 620 | `PRINT " 0.7"` | One **leading space inserted inside the string literal**. The source is perfectly legible and has no space (the neighbouring `" 1.5"` / `" 1.0"` do have one, so this looks like a consistency "fix"). Screen label only — no numerical effect. |

---

## 4. Class D — omissions

**None.** The completeness sweep matched every one of the 764 source code lines to a transcript counterpart. Lines correctly *not* carried over are page furniture only, not statements: `561`, `562`, `563`, `56.3`, `564`…`576`, `<<<PAGE nnn>>>`, and the running heads. Also dropped: source line 26584, which contains a single stray `(` and is not a statement.

---

## 5. Class E — additions

All four code additions share one root cause: when a `PRINT`/`LPRINT` statement begins with a bare keyword (`PRINT"` or `LPRINT` alone, with the rest of the statement wrapped onto the next line), the transcriber emitted **both** a bare `PRINT`/`LPRINT` **and** the reconstructed `PRINT "…"` — i.e. the statement start was double-counted.

| # | Source line(s) | Source text | Transcript line(s) | Transcript text | Change |
|---|---|---|---|---|---|
| E1 | 26305–26307 | `LPRINT` / `USING"######.###";DELRAT(…` | **244** + 245 | `LPRINT` **and** `LPRINT USING"######.###";DELRAT(…)` | One extra bare `LPRINT`. Source is a *single* statement (`LPRINT USING`), which the transcript correctly rebuilt at 245 — but the orphan `LPRINT` was left in place. Adds a blank line per row of the delivery-ratio table. **Note the same construct at 26294–26296 was merged correctly at transcript 239**, so 244 is also internally inconsistent. |
| E2 | 26479 → 26480 | `PRINT "EXHAUST PORT DATA"` then `PRINT"` (start of `OPENS …`) | **383** | `PRINT` | Extra bare `PRINT` between the section header and the `OPENS` line. Source has no blank print there. |
| E3 | 26485–26486 → 26487 | `PRINT'TRANSFER PORT DATA…";SCAV$` then `PRINT"` | **388** | `PRINT` | Extra bare `PRINT` between the transfer-port header and its `OPENS` line. |
| E4 | 26493 → 26494 | `PRINT'TNLET PORT DATA"` then `PRINT"` | **393** | `PRINT` | Extra bare `PRINT` between the inlet-port header and its `OPENS` line. |

**Cross-check that these are additions and not lost source:** the parallel printer version `DATASETL` is structurally identical in the source, and the transcript reproduces `DATASETL` **without** any of these insertions (transcript 415–426). Source `DATASET` has 30 `PRINT` statements; transcript has 33. Source `DATASETL` has 27; transcript has 27.

Editorial additions (deliberate, declared, **not** valid BASIC — must be stripped before translation):

| # | Transcript line | Content |
|---|---|---|
| E5 | 1 | `REM Blair, G.P. - The Basic Design of Two-Stroke Engines (SAE)` |
| E6 | 2 | `REM PROG.5.1 "ENGINE MODEL NO.1", book pp.291-298` |
| E7 | 3 | `REM OCR rejoined; <UNRESOLVED: ...> flags on their own line mark doubts` |
| E8 | 24 | `<UNRESOLVED: OPENT\#l."UFLO">` |
| E9 | 161 | `<UNRESOLVED: IF CYC=CYCTRIP THEN PCOUNT=PCOUNT+1>` |
| E10 | 188 | `<UNRESOLVED: CALL SHORTAE( ).BE( ),KO.KE 1)>` |
| E11 | 264 | `<UNRESOLVED: OPEN'LPTl :PROMPT"FOR OUTPUT AS#2>` |
| E12 | 675 | `<UNRESOLVED: OPEN'T',#l,FIL$>` |

I checked all five `<UNRESOLVED:` notes against the raw source text: each quotes the source faithfully and each stated reason is accurate.

---

## 6. Class B — repairs that must still be re-checked by hand

All 136 repairs are defensible, but these are the ones where a wrong guess would be silent and fatal. **Verify each against the book page before translating.**

### 6a. Numeric constants where the transcriber supplied a digit or decimal point

| Source line | Source text | Transcript line | Transcript text | Judgment |
|---|---|---|---|---|
| 26205 | `IF AE(KE1 )<BE(KE1) THEN AK=75` | 167 | `… THEN AK=.75` | decimal point inserted |
| 26208 | `IF AET( 1 )>=BET( 1) THEN AK=75` | 170 | `… THEN AK=.75` | decimal point inserted |
| 26212 | `IF AET(KE2)<BET(KE2) THEN AK=,75` | 174 | `… THEN AK=.75` | `,` → `.` |
| 26130 | `PA=I01325!` | 95 | `PA=101325!` | leading `10` recovered |
| 26148 | `CVAL=4.3F+07` | 113 | `CVAL=4.3E+07` | `F` → `E` |
| 26352 | `LE1M=1.EP1/1000` | 288 | `LE1M=LEP1/1000` | `1.E` → `LE` |
| 26355 | `DE2M=DEP2/10O0` | 291 | `DE2M=DEP2/1000` | `O` → `0` |
| 26459 | `VBOXM=VBOX/10( 10000!` | 371 | `VBOXM=VBOX/1000000!` | **6-digit divisor reconstructed from 26356** |
| 26596 | `GTS=!500` | 458 | `GTS=1500` | `!` → `1` |
| 26650 | `YT1=Y0-15C)0*YTT` | 506 | `YT1=Y0-1500*YTT` | `15C)0` → `1500` |
| 26589 | `EP=2*(I80-EPO)` | 451 | `EP=2*(180-EPO)` | `I` → `1` |
| 26129 | `N17=l/7` | 94 | `N17=1/7` | `l` → `1` |
| 26642 | `YY4=Y0-4*GYS` | 499 | `YY4=Y0-.4*GYS` | decimal point inserted |
| 26644 | `YY6=Y0-6*GYS` | 501 | `YY6=Y0-.6*GYS` | decimal point inserted |
| 26670 | `YF(K)=Y0-K*YEF/I0` | 526 | `… /YEF/10` | `I0` → `10` |
| 26706 | `YPS=GYS/1()` | 558 | `YPS=GYS/10` | `()` → `0` |
| 26707 | `YVS=YEF/1()` | 559 | `YVS=YEF/10` | `()` → `0` |
| 26043 | `DIMXA(20O),YC(20()),…,YI(25O)` | 15 | `DIM XA(200),YC(200),…,YI(250)` | array bounds |
| 26045 | `DIM YV(250),YP(250),XXA(25()),YB(250)` | 17 | `… XXA(250) …` | array bound |

*None of these changes a value that is already consistent elsewhere except 26459, which is corroborated by 26356 (`VBOXM=VBOX/1000000!`) and 26459's own unit comment (`VBOX AS cm3`).* The `.75` repairs are corroborated by their `.9` partners and by `AK` being a discharge coefficient.

### 6b. Control flow / index repairs that are judgment calls

| Source line | Source text | Transcript line | Transcript text | Judgment |
|---|---|---|---|---|
| 26227 | `CALL SHORTAE( ).BE( ),KO.KE 1)` | 187 | `CALL SHOK(AE(),BE(),KO,KE1)` | routine renamed to match the three sibling `SHOK` calls; flagged in file. `SHOK` is not printed in this listing, so the rename cannot be confirmed. |
| 26684 | `-(XA(NM).YC(M-1))` | 540 | `-(XA(M-1),YC(M-1))` | `NM` → `M-1`, by symmetry |
| 26685 | `-(XA(M-1),YE(M-D)` | 541 | `-(XA(M-1),YE(M-1))` | `D` → `1`, by symmetry |
| 26813 | `( X X A ( M ) , Y V ( M ) M X X A ( M - I I . Y Y ( M - 1 ) )` | 658 | `(XXA(M),YV(M))-(XXA(M-1),YV(M-1))` | `YY` → `YV` chosen over `YP`/`YB` |
| 26251 | `BOX(PCI,PC2,TCLTC2.VCLVC2,MCl.MC2,MTl.MELCTLCELHTl.HEl.CYWORK)` | 204 | `BOX(PC1,PC2,TC1,TC2,VC1,VC2,MC1,MC2,MT1,ME1,CT1,CE1,HT1,HE1,CYWORK)` | 7 split/repaired arguments in one line |
| 26241 | `OUTFLOW! AET( 1 ).BET( I ).FEP2,TB LHET1.CET1 .MET! .D.GD)` | 200 | `OUTFLOW(AET(1),BET(1),FEP2,TB1,HET1,CET1,MET1,D,CD)` | `GD` → `CD` |
| 26238 | `OUTFLOW* AE( KEl ),BE(KE1 l.FLP 1 ,TC I …` | 197 | `OUTFLOW(AE(KE1),BE(KE1),FEP1,TC1,…` | `FLP1` → `FEP1` |
| 26182 | `CALLSTAB(A1().BI(),KLSDLLIMESH)` | 143 | `CALL STAB(AI(),BI(),KI,SDI,LIMESH)` | `KL`→`KI`, `SDLL`→`SDI,` |
| 26328 | `OPEN'LPTl :PROMPT"FOR OUTPUT AS#2` | 263 | `OPEN "LPT1:" FOR OUTPUT AS #2` | `PROMPT` deleted; colon kept inside the device name |
| 26382, 26388, 26389, 26410, 26413 | `LOCATE 22. LPRINT "POWER…` etc. | 314, 320, 321, 338, 341 | `LOCATE 22,1:PRINT "POWER…` etc. | **`LPRINT` read as `,1:PRINT`** on 5 lines — converts a printer write into a screen write. Context (surrounding `LOCATE`/`PRINT` pairs) supports it, but it is an interpretation, not an OCR fix. |
| 26397, 26417 | `LOCATE 26. LINPUT …` / `LOCATE 25,LINPUT …` | 325, 345 | `LOCATE 26,1:LINE INPUT …` / `LOCATE 25,1:LINE INPUT …` | `LINPUT` → `LINE INPUT` |
| 26051, 26830 | `OPENT\#l."UFLO"` / `OPEN'T',#l,FIL$` | 23, 674 | `OPEN"I",#1,"UFLO"` / `OPEN"I",#1,FIL$` | mode letter guessed as `I`; both flagged in file; corroborated by `INPUT#1` immediately after each |
| 26449 | `VBOX AScni3)` | 361 | `VBOX AS cm3)` | `AScni3` → `AS cm3` |
| 26638 | `PRINT" LO"` | 495 | `PRINT "1.0"` | `LO` → `1.0`; corroborated by the identical label column in SPLOT1 (`2.0`@row2, `1.5`@row9, `1.0`@row16) |
| 26636 | `PRINT'T .5"` | 487 | `PRINT "1.5"` | `'T .5` → `1.5` |
| 26101 vs 26165 | `DTDUCI =SQR(…)` but `CALL AREA(DTDUCT,DTDUCT,…)` | 68 | `DTDUCT=SQR(…)` | source is internally inconsistent; transcript unified to `DTDUCT`. Legible-source change, but required for the program to work. |
| 26452 | `INPUT'TYPE IN THE WORD ABSORPTION'"` | 364 | `INPUT "TYPE IN THE WORD ABSORPTION"` | trailing `'` dropped |

---

## 7. Re-joined (wrapped) lines — audit

41 source statements span line breaks, absorbing 93 source lines. I checked every one against its source fragment. **37 of 41 are correct**; the 4 exceptions are E1–E4 above.

Joins verified correct (spot list of the structurally risky ones):

* 26066–67 `50 INPUT "RESPONSE FOR NEW DATA…";H$`
* 26094–95 `INPUT "TYPE 'RUN'…";Z$`
* 26233–35 `CALL OUTFLOW(BT(KT),AT(KT),FTDUCT,TCC1,HTKT,CTKT,MTKT,D,CD)` — 9 args
* 26242–43 `CALL BOX(PB1,…,BOXW)` — 15 args
* 26244–46 `CALL BOX(PCC1,…,CCWORK)` — 15 args
* 26247–50 `IF HTDC<=HEOT THEN CALL CYLINDER(PC1,…,CYWORK)` — correctly merges a 4-line `IF/THEN/CALL` split
* 26251–52 `IF HTDC>HEOT THEN CALL BOX(PC1,…,CYWORK)` — 15 args
* 26278–79 `500 INPUT "RESPONSE FOR RECALCULATION…";D$`
* 26290–92, 26299–26303, 26310–11 table header strings — hyphenation `combus-/tion` and `CRANK-/CASE-CR` correctly healed
* 26389–93 `LOCATE 25.LPRINT "PEAK / CYLINDER / PRESS., / bar=";USING / "###.#";PMAX` — a 5-line statement
* 26426–26449 the whole `EXPIPDAT` question block (10 separate joins)
* 26525–26531, 26540–41, 26544–47, 26563–68 `DATASETL` blocks
* 26817–18 `INPUT "TYPE IN TITLE…CODE";P$`

---

## 8. Source defects preserved verbatim (do **not** "fix" during translation)

These look wrong but are what Blair printed; the transcript reproduces them faithfully. They are listed so the translator does not silently correct them and so a reviewer can decide deliberately.

1. **26183 / 26184** — `CALL STAB(AE(),BE(),KE1,SDE,LEM1)` appears twice in succession (transcript 144/145). Almost certainly one should be a different mesh (compare the `AET/BET/KE2` and `AT/BT/KT` and `AI/BI/KI` calls above it).
2. **26163 / 26164** — `AREA` is called for `DE2M/KE2` *before* `DE1M/KE1`.
3. **26037 vs 26053** — `DIM ABX(21,45)` but the load loop only fills `J=1..41`; `BX(J)` is then read for `J=1..41`.
4. **26225** — `IF HTDC<HIOT` uses strict `<` while the exhaust and transfer ports use `<=`.
5. **26199** — `CYCTRIP` is never defined or assigned anywhere in the listing (transcript 160, flagged).
6. **26637–26638** — `LOCATE 16,2 : PRINT " LO"` and later `LOCATE 16,2 : PRINT"0.7"` both target the same cell.
7. **26277** — `NEXT KK` closes a `FOR KK=1 TO 20000` loop that has no explicit exit, only `GOTO 500`/`GOTO 430`/`GOTO 431` out of it.

---

## 9. Verdict

**Safe to translate — conditionally.** The transcription is unusually faithful: **zero** class-A errors, **zero** omissions, and every label, `GOSUB` target, argument order, `.9`/`.75` polarity, `<=`/`<` asymmetry, loop bound and statement order is preserved, including several places where a tidier transcriber would have "fixed" the book. The only defects are **4 duplicated blank-print statements** (harmless to the physics, but they must be deleted or knowingly accepted) and **1 cosmetic space** in a screen label.

Before translating, do these three things:

1. **Strip the 8 editorial lines** (1–3, 24, 161, 188, 264, 675). They are not BASIC and will not parse. Re-add them as comments outside the code if you want to keep the audit trail.
2. **Delete transcript lines 244, 383, 388, 393** (class E). Line 244 in particular should go, because line 239 shows the transcriber correctly merged the identical construct elsewhere.
3. **Hand-check these transcript lines against the printed page** — they are the only places where a silent, fatal guess is possible:
   * **1000000 divisor:** line **371** (`VBOXM=VBOX/1000000!`) — the source text is destroyed; only `26356` corroborates it.
   * **Atmospheric pressure:** line **95** (`PA=101325!`).
   * **Heat-transfer/energy constant:** line **113** (`CVAL=4.3E+07`).
   * **Discharge coefficient decimals:** line **167**, **170**, **174** (`AK=.75`) — the source reads `75`, `75`, `,75`.
   * **Plot scale factors:** lines **458**, **506** (`1500`), **451** (`180`), **526**, **558**, **559** (`/10`), **499**, **501** (`.4`, `.6`).
   * **Array bounds:** lines **15**, **17** (`200/200/250`, `250`).
   * **Unresolved routine name:** line **187** (`CALL SHOK(...)` from `SHORTAE`) — confirm against the book's routine list; `SHOK` is not in this listing.
   * **Printer-vs-screen reads:** lines **314, 320, 321, 338, 341** — the transcriber turned `LPRINT` into `,1:PRINT` five times. Confirm these are screen writes.
   * **File open modes:** lines **23** and **674** (`OPEN "I"`).
   * **Preserved book defects:** do not let a translator "repair" items 1–4 in §8 without a deliberate decision.
