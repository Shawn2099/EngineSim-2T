# BUILD_MANIFEST — Blair PROG.5.1, assembled single-file source

Output: `port/blair_full.bas` (1503 lines, ASCII, one file)
Inputs: `port/blair_prog51_basic.txt`, `port/blair_subroutines_basic.txt`,
`port/SUBROUTINES_MAP.md`, `port/MISSING_ROUTINES.md`

| | |
|---|---|
| Source units merged | 44 (main program + 14 inline routines + 15 labelled 5.0 routines + 14 SUB blocks) |
| Conflicts / ambiguities resolved | **26** (log below, D1–D26) |
| Blockers left in the code | **0** |
| External artefacts needed to run | 2 (data file `UFLO`, one case data set) — see §8 |
| Logic rewritten | none. Only merges, unit removals, `REM` markers and one `DIM` block added |
| Verified | call arity 0 mismatches; 34 main-module labels, none duplicated, none unresolved; every `CALL`/`GOSUB` target defined; no stray marker lines; pure ASCII |

---

## 1. Inventory of `blair_full.bas`

Main program first (with the routines Blair prints inline in it), then the
ProgList 5.0 common block in the book's own order.

| .bas line | unit | book source | transcript |
|---|---|---|---|
| 45 | MAIN PROGRAM PROG.5.1 (to `501 END`) | 26032–26424 | 4–232 |
| 300 | `DATOUT` | in PROG.5.1 | 233–253 |
| 327 | `PRINTOUT` | in PROG.5.1 | 254–268 |
| 349 | `FILESET` | in PROG.5.1 | 269–300 |
| 387 | `RESETBDC` | in PROG.5.1 | 301–330 |
| 423 | `RESETTDC` | in PROG.5.1 | 331–350 |
| 449 | `EXPIPDAT` | 26425–26448 | 351–374 |
| 478 | `DATASET` | in PROG.5.1 | 375–410 |
| 520 | `DATASETL` | in PROG.5.1 | 411–439 |
| 556 | `SPLOT1` | in PROG.5.1 | 440–528 |
| 651 | `SPLOT2` | in PROG.5.1 | 529–544 |
| 673 | `SPLOT3` | in PROG.5.1 | 545–640 |
| 775 | `SPLOT4` | in PROG.5.1 | 641–660 |
| 801 | `FILING` | in PROG.5.1 | 661–671 |
| 818 | `FILED` | in PROG.5.1 | 672–683 |
| 848 | `TRPIPDAT` | 27570–27591 | 61–69 |
| 862 | `INPIPDAT` | 27592–27611 | 71–83 |
| 881 | `COMBDAT` | 27612–27648 | 85–98 |
| 901 | `PORTSTART` | 27649–27692 | 100–141 |
| 948 | `EXPORTSHUT` | 27693–27697 | 143–147 |
| 959 | `EXPORTOPEN` | 27698–27722 | 149–160 |
| 983 | `TRPORTSHUT` | 27723–27729 | 162–166 |
| 998 | `TRPORTOPEN` (scavenging model 1) | 27730–27747 | 168–185 |
| 1019 | `INPORTSHUT` | 27772–27776 | 207–211 |
| 1030 | `INPORTOPEN` | 27777–27791 | 213–224 |
| 1052 | `ENGINEDAT` | 27792–27834 | 226–253 |
| 1085 | `EXPORTDAT` | 27835–27867 | 255–273 |
| 1109 | `TRPORTDAT` | 27868–27903 | 275–296 |
| 1136 | `INPORTDAT` | 27904–27933 | 298–316 |
| 1160 | `CYLSTART` | 27934–27945 | 318–328 |
| 1177 | `SUB FPORT` | 27946–27950 | 330–334 |
| 1190 | `SUB STAB` | 27951–27963 | 336–345 |
| 1206 | `SUB SETS` | 27964–27969 | 347–352 |
| 1218 | `SUB AREA` | 27970–27980 | 354–364 |
| 1237 | `SUB PIPE` | 27981–28018 | 366–399 |
| 1277 | `SUB SHOK` | 28019–28033 | 401–415 |
| 1299 | `SUB PORT` | 28034–28048 | 417–431 |
| 1324 | `SUB NINT` | 28049–28059 | 433–441 |
| 1339 | `SUB OUTFLOW` | 28060–28076 | 443–458 |
| 1360 | `SUB INFLOW` | 28077–28092 | 460–474 |
| 1384 | `SUB BOX` (15-argument body) | 28093–28118 | 476–494 |
| 1410 | `SUB PISTPOS` (degrees body) | 28124–28129 | 502–507 |
| 1422 | `SUB PAREA` | 28130–28135 | 509–513 |
| 1436 | `SUB CYLINDER` | 28136–28192 | 515–568 |

Every unit is preceded by `REM ---- NAME : book source a-b | transcript lines n-m ----`.
The `FINISH:` label (main line 66) is Blair's own and is never `GOSUB`ed; kept as printed.

---

## 2. Decision log

One entry per conflict/ambiguity: what conflicted → what was kept → why → what
breaks if the other reading is right. `[Dnn]` markers in `blair_full.bas` point
back to these rows.

### 2.1 Duplicate names — the same routine printed twice

| # | what conflicted | kept | why | if the other is right |
|---|---|---|---|---|
| **D1** | `STAB` (A 27951, no `DZ=1`) vs (B1 21121, `DZ=1` first) | **A**, the 5.0 body | It is the ProgList 5.x version, and PROG.5.1 already sets `DZ=1` once before the block of five `CALL STAB` (main line 139) and damps once after (`DZ=.99*DZ`). The five calls accumulate a minimum; that is the contract the caller is written to. | With B1's body each of the five calls resets `DZ=1`, so only the **last** call's duct sets the step: `DZ` becomes the exhaust-duct minimum alone. The shorter ducts (crankcase, inlet, transfer) then violate the Courant limit → the run goes numerically unstable instead of slow. |
| **D2** | `SETS` (A 27964) vs (B1 21132) | **A** | Byte-identical bodies; A is the 5.x block. | Nothing — the two are identical. |
| **D3** | `AREA` (A 27970) vs (B1 21138) | **A** | Byte-identical bodies. | Nothing. |
| **D4** | `PIPE` (A 27981) vs (B1 21149) | **A** | Byte-identical bodies **except** that A uses label `23` for `QA=0`, B1 uses `22`. B1's `22` collides with `COMBDAT`'s `22` in the single main-module label space → duplicate-label error. | With B1's body the file does not compile (duplicate label 22); if 22 were renumbered, `GOTO 22` inside `PIPE` would jump into `COMBDAT`'s data-entry loop. |
| **D5** | `SHOK` (A 28019) vs (B1 21185) | **A** | Byte-identical bodies. | Nothing. |
| **D6** | `PORT` (A 28034) vs (B1 21200) | **A** | Byte-identical bodies (A also carries the extra comment-free `ABX1` form of the same bilinear interpolation). | Nothing. |
| **D7** | `NINT` (A 28049: dummy `K1`, `SHARED LMESH`) vs (B1 21219: dummy `KI`, literal `30`) | **A** | `LMESH=30` is set by the main program (line 115) immediately before the four calls, so the two are numerically identical here; A is the 5.x version and keeps the mesh length in one place. The map's "increments the caller's variable twice" is **not** what A does: in a `STATIC` SUB, `KI=INT(RI)` is a *local* and only `K1=KI+1` reaches the caller — one increment. Both versions return `round(PL·√(TE/TP)/30)+1`. | If B1 were right: no numeric difference at `LMESH=30`, but the literal `30` silently ignores `LMESH`, so any later change of mesh length would not take effect. (B1's body *does* double-increment if a translator drops `STATIC`, because its dummy is literally `KI` and the inlet call is `CALL NINT(KI,...)`.) |
| **D8** | `BOX` 15-argument (A 28093) vs 10-argument (B1 21243) | **A**, the 15-argument body | Forced: all three PROG.5.1 call sites pass 15 arguments (`26242`, `26245`, `26252`). A has two volumes `VB1/VB2`, the three flow/enthalpy pairs, and the `WORK` output; B1 has one `VB`, no work term, and a different 9th/10th argument. | With B1: every call is an arity error; `BOXW`/`CCWORK`/`CYWORK` are never computed, so `POWER` is 0 and `BSFC` divides by zero; and the crankcase/cylinder `pV=mRT` step loses its volume-change work term. |
| **D9** | `BOX`(B1) uses `MDI`, `TI`, `CI`, none of which is a parameter or `SHARED` | not applicable — B1 dropped | Any reading makes B1 unusable as called; three of its inputs do not exist at the call site. | If B1's header were the true one, PROG.5.1 would need three extra arguments at every call and an inlet mass flow that the program never computes. |
| **D10** | `BELMOUTH` (A 28119) vs (B1 21259), both with a dead `PA` argument | **neither — dropped** | Never called by PROG.5.1 or 5.2 (`SUBROUTINES_MAP.md` §A); it is PROG.2.2's bellmouth boundary. Keeping a dead duplicate would only re-create a link ambiguity. | Nothing breaks: no call site exists in this program. If 5.1 did need it, the two bodies are identical and either would do. |
| **D11** | `TRPORTOPEN` printed twice: scavenging model 1 (Eqn.5.1.1, A 27730) vs model 2 (Eqn.5.1.13, A 27750) | **model 1** | PROG.5.1 is the chapter-5 piston-ported model whose scavenging equation is 5.1.1; model 2 only replaces the `EXPAND` term with the density-corrected form, and Blair's published 5.1 figures are the model-1 ones. | If model 2 is right, `SEFF`/`SR` are wrong (see the exact 3-line diff in §3), so scavenging efficiency, trapping efficiency and every subsequent `MAIR=SEFF*MC` — hence `CEFF`, `TEFF`, peak pressure and IMEP — are all off. Nothing else in the file changes. |
| **D12** | `PISTPOS` degrees (A 28124, `A=D*DTOR`) vs radians (B2 18704, `A` used directly) | **A**, the degrees version | All eight call sites in this file pass degrees: `CALL PISTPOS(...,DEG,...)` from the main loop, and `EPO/EPFO/TPO/TPFO/IPO/IPFO` from `PORTSTART`, all of which are crank angles in degrees ATDC/BTDC entered as such. `DTOR` is defined in the main program (line 50) precisely for this. | With the radians body, every piston position is `cos(100 rad)`: `HT`/`HB` are meaningless, `VC2`, `VCC2`, `EXHT`, `TRHT`, `INHT` and all port areas are garbage, `PAREA` gets negative heights and the run produces nonsense from the first step. `DTOR` would also be dead. |

### 2.2 Argument-list and identifier mismatches

| # | what conflicted | kept | why | if the other is right |
|---|---|---|---|---|
| **D13** | `EXPORTOPEN` `PEX>PC1R` branch: `CALL OUTFLOW(...,TCT,...)` — `TCT` defined nowhere | **`TC1`** | `TCT` is a one-glyph misread of `TC1` (`1`→`T`); `TC1` is what the sibling branch one line above passes; Blair prints many `IF…/IF…` pairs with identical right-hand sides; and it is the only candidate guaranteed initialised. | If the token was really `TCC1` (as `SUBROUTINES_MAP.md` §7 guesses), the reverse-flow branch uses a crankcase temperature (~300–400 K) instead of the cylinder temperature (~1900 K): `TR` is ~5× low, so `M=CD·C·F·D` and `H` in that one branch are off by a factor of order 2–5. If it was `TB1` (the exhaust-box temperature, which is what the physics of reverse flow into the cylinder would want), the error is ~2×. Effect is confined to steps where exhaust-pipe pressure exceeds cylinder pressure — normally only the last degree or two of the exhaust period. |
| **D14** | `INPORTOPEN`: `CALL FPORT(HTDC,HIOT,INHT,FIPRT,FIPRT,AKI,CCI)` — same array for `FPRT` and `FPIP` | **as printed** (`FIPRT`,`FIPRT`) | The printed code is arithmetically well defined: `FPRT/FPIP = 1`, so `AKI = CCI·FINST`. Changing it would be rewriting logic, not resolving a merge. | If the intended second argument was `FIPM` (inlet pipe area — computed in `INPIPDAT` and `FILESET` and then used **nowhere**, which is strong circumstantial evidence), the inlet-port reflection area ratio is ~2–6× too large, so the crankcase is over-charged and `DRATIO`/`CEFF` read high. Flagged, not changed. |
| **D15** | `CYLINDER`: `HT1` is read (`QHT=DC*(HT1+HT2)/2`) and written (`HT1=HT2`) but is in neither `SHARED` list | **keep it LOCAL** (do *not* add it to `SHARED`, contra `MISSING_ROUTINES.md` §1.3) | In this program `HT1` is *already* a global with a different meaning: `TRPORTOPEN` writes it as the transfer-port enthalpy straight out of `OUTFLOW`, and `BOX(...,MT1,ME1,CT1,CE1,HT1,HE1,...)` consumes it as `HIN`. Making `CYLINDER`'s `HT1` shared would alias the two. Because `CYLINDER` is called only when `HTDC<=HEOT` — i.e. the first step after the **transfer** port has just shut — the first closed-cycle step of every cycle would integrate `QHT = DC·(1e6 + HT2)/2`, a one-step heat spike that inflates `P2` enormously. As printed, `HT1` is local and zero on entry, so the printed routine integrates heat with a rectangle rule; that is the behaviour Blair's published results were produced with. | If `HT1` *should* be shared and the alias were removed (e.g. by renaming the transfer enthalpy), the heat release becomes trapezoidal and total heat roughly doubles → peak pressure and temperature far above Blair's figures. If instead the printed local behaviour is "wrong", then `PMAX`/`TKMAX`/`MAXDEG` and the whole indicated diagram are low by that factor — but nothing crashes, and this is the only reading that keeps `BOX`'s energy balance intact. |
| **D16** | `CYLINDER`: `DPMAX` read and written but not `SHARED` (`DELTAP` is local too) | **keep it LOCAL**, unchanged | It is a diagnostic ("maximum pressure rise per degree"); no unit in PROG.5.1 reads `DPMAX`, and `RESETBDC` does not print it. Adding it to `SHARED` would change nothing visible. | If it should be shared, the only consequence is that a diagnostic that is currently always `0` would start accumulating. No effect on `P2`, `T2`, `WORK` or any printed result. |

### 2.3 Defects inside the main program

| # | what conflicted | kept | why | if the other is right |
|---|---|---|---|---|
| **D17** | Duplicate `SHOK` call on the exhaust duct (`CALL SHOK(AE(),BE(),KO,KE1)` twice; the second reads `SHORTAE( ).BE( ),KO.KE 1)`) | **both kept, second read as `SHOK(AE(),BE(),KO,KE1)`** | `SHOK` is idempotent — a second pass finds `R1<1` on every mesh and changes nothing — so the duplicate is harmless and removing it would be an edit to Blair's statement flow. `SHORTAE` is not a routine anywhere in the book; it is `SHOK` + `AE` split by the OCR. | If the second call were a genuinely different routine, one exhaust-duct shock correction is missing. Consequence: the `|R1|≥1` interface is left uncorrected for one step → a small pressure discontinuity that propagates. No crash. |
| **D18** | Duplicate `STAB` call on the exhaust duct (5 calls, the last two identical) | **both kept** | Same reasoning: `STAB` only ever lowers `DZ`, so the repeat is a no-op; the 5.2 listing has the same duplication per `MISSING_ROUTINES.md` §3.1. | Nothing — with the retained (A) body the duplicate cannot change `DZ`. |
| **D19** | `IF CYC=CYCTRIP THEN PCOUNT=PCOUNT+1` — `CYCTRIP` defined nowhere | **kept as printed** | In BASIC an undefined variable is 0 and `CYC` starts at 1, so the branch is never taken and `PCOUNT` stays 0. `PCOUNT` is read only by `EBLACK` (§B1), which PROG.5.1 never calls. Dead, harmless, and un-guessable. | If `CYCTRIP` were meant to be `CYCLESTOP` (7), `PCOUNT` would count steps in that one cycle; still unread in 5.1, so still no effect on any result. |

### 2.4 Build, OCR and namespace decisions

| # | what conflicted | kept | why | if the other is right |
|---|---|---|---|---|
| **D20** | `DELRAT, PEAKP, PEAKT, PMEP, CMEP, BMEP, POWER, FUEL, BSFC, SEFFP, TEFFP, CEFFP, SRMP, SRVP, EXRP` are used with subscripts but never `DIM`ed | **added one `DIM` block** (`.bas` lines 63–64), clearly marked as not Blair's | QBasic silently gives them 11 elements (0..10) and the code only uses 1..7, so the added `DIM …(20)` reproduces the printed behaviour exactly and removes the guesswork for a translator. No logic touched. | If a translator assumed a different implicit bound, `RESETBDC`/`RESETTDC`/`DATOUT` would either fail at index 7 or silently wrap. Nothing else changes. |
| **D21** | File-open mode character reads `"T"` at `OPEN"I",#1,"UFLO"` (main line 63) and `OPEN"I",#1,FIL$` (`FILED`) | **`"I"`** | `"T"` is not a BASIC mode; both files are read (`INPUT#1`), and the twin writer uses `FOR OUTPUT`. | If it were `"O"` or `"R"`, the file could not be read sequentially and the program dies at start-up (UFLO) or on `F`-load. |
| **D22** | `OPEN "LPT1:PROMPT" FOR OUTPUT AS #2` — stray `PROMPT` token in `PRINTOUT` | **deleted** (`OPEN "LPT1:" FOR OUTPUT AS #2`) | The transcription already deleted it: it has no BASIC meaning between a device name and `FOR`. | If the token were meaningful it would be a device qualifier; the printer replay would fail instead of printing. Plotting/printing only — the calculation is unaffected. |
| **D23** | Two label namespaces in one file: main-module labels (main loop + all `GOSUB` routines) vs `SUB`-local labels | **documented in the file header; both namespaces kept as printed** | QBasic line numbers are local to a `SUB…END SUB` block. `CYLINDER`'s `20 30 50 60 70 80 90`, `PIPE`'s `23 33 44 55`, `SHOK`'s `26 56` and `BOX`'s `103` therefore do **not** collide with the main module's `20` (`TRPIPDAT`), `50`, `305…439`, `500…502`, `911`. Verified: the 34 main-module labels are unique, all 38 references resolve, and each `SUB`'s internal labels resolve internally. | If a translator flattens everything into one label space (very likely — MATLAB has one `goto`-free namespace, and a naive BASIC front-end does too), then `CYLINDER`'s `GOTO 20` jumps into `TRPIPDAT`'s input loop and `GOTO 50` into the main loop at `INPUT "RESPONSE FOR NEW DATA…"` — an instant, silent, unrecoverable mess. **This is the single most dangerous thing in the file.** Rename `SUB`-local labels before flattening. |
| **D24** | Whole ProgList 2.1/2.2 block present in the input (`ASET`…`CLIPDRAW`, `EXPORT`, `FLOW`) plus `BELMOUTH` | **excluded** | None is called by PROG.5.1. `ASET/BSET/CSET/DSET/ESET`+`*BLACK`/`*WHITE`/`ARROB`/`ARROW`/`CLOCK`/`NSET`/`START`/`CLIPDRAW` are PROG.2.1/2.2's five-panel screen and printer dump; `EXPORT` and `FLOW` are their port ramp and post-processor; `CLIPDRAW` additionally calls `DATASET`+`SCALE`, which are not in the block at all (map §12). | If any were kept, the file gains 10 duplicate names (`STAB, SETS, AREA, PIPE, SHOK, PORT, NINT, BOX, BELMOUTH, PISTPOS`) and the wrong `STAB`/`PISTPOS`/`BOX`/`NINT` would be linkable; `CLIPDRAW` would also be an undefined-`GOSUB` pair (`DATASET`/`SCALE`). |
| **D25** | `CYLINDER`: `IF DEGOIGN THEN GOTO 20` — operator illegible | **`IF DEGC<IGN THEN GOTO 20`** | Every reading is dead: label `30` immediately above already branched away on `DEGC<=IGN`. Kept only so the line count matches the book. | Behaviour-neutral under any reading; no result changes. |
| **D26** | `CYLINDER`: `TRM1=(GE+1)*V2/(2*(GE-1))-VR` — the trailing `-VR` may belong to the next expression | **as printed** | The very next statement unconditionally reassigns `TRM1=V2/(GE-1)` (the Eqn.4.2.13 form Blair says he uses), so the value is discarded either way. | Behaviour-neutral: `TRM1` is overwritten before use, so `P2`, `T2` are identical under either reading. |

**Count: 26 entries. 12 are duplicate-name conflicts under one name
(D1–D12), 4 are argument/identifier defects (D13–D16), 3 are main-program
defects (D17–D19), 7 are build/namespace/OCR decisions (D20–D26).**

---

## 3. The two alternatives that are *not* in the file, verbatim

**(a) `TRPORTOPEN`, scavenging model 2** (book 27750–27771, Eqn.5.1.13). To
switch, replace the three starred lines of the retained body:

```
 retained (model 1)                    alternative (model 2)
 EXPAND=PTR/PC1R                  *    DCY=PC1/(GK*TC1)
 VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1 *    EXPAND=DSCAV/(.6*DSCAV+.4*DCY)
                                       VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1
```
Everything else in the two bodies is identical, including the `911` label. The
model-2 body also needs `DSCAV` to be the local density `OUTFLOW` writes — it
already is, at both `OUTFLOW` calls.

**(b) `PISTPOS`, radians body** (book 18704–18707, PROG.1.1):
`HT=R+C-R*COS(A)-SQR(C*C-(R*SIN(A))^2)` with no `DTOR` conversion and no
`SHARED DTOR`. Not used — see D12.

---

## 4. Dependency list — which unit calls which

`G` = `GOSUB <label>`, `C` = `CALL <sub>`; `xN` = number of call sites.
Leaves (call nothing) are marked ✔.

| caller | calls |
|---|---|
| **MAIN PROGRAM** | G `FILED`, `FILESET`, `ENGINEDAT`, `EXPORTDAT`, `TRPORTDAT`, `INPORTDAT`, `EXPIPDAT`, `TRPIPDAT`, `INPIPDAT`, `COMBDAT`, `DATASET`, `PORTSTART`, `CYLSTART`, `RESETBDC`, `RESETTDC`, `SPLOT1`, `SPLOT2`, `SPLOT3`, `SPLOT4`, `FILING`, `PRINTOUT`; C `PAREA` x3, `NINT` x4, `SETS` x4, `AREA` x4, `STAB` x5, `PISTPOS`, `PIPE` x4, `PORT` x5, `SHOK` x5, `OUTFLOW` x3, `BOX` x3, `CYLINDER` |
| `DATOUT` | — ✔ |
| `PRINTOUT` | G `DATASETL`, `DATOUT`; then `GOTO 430` back into the main loop (printer replay) |
| `FILESET` | — ✔ |
| `RESETBDC` | — ✔ |
| `RESETTDC` | — ✔ |
| `EXPIPDAT` | — ✔ |
| `DATASET` / `DATASETL` | — ✔ |
| `SPLOT1` … `SPLOT4` | — ✔ (draw only) |
| `FILING` / `FILED` | — ✔ |
| `TRPIPDAT` / `INPIPDAT` / `COMBDAT` | — ✔ |
| `PORTSTART` | C `PISTPOS` x6 |
| `EXPORTSHUT` / `TRPORTSHUT` / `INPORTSHUT` | — ✔ |
| `EXPORTOPEN` | C `FPORT`, `PORT`, `OUTFLOW` |
| `TRPORTOPEN` | C `FPORT`, `PORT`, `OUTFLOW` |
| `INPORTOPEN` | C `FPORT`, `PORT`, `OUTFLOW`, `INFLOW` |
| `ENGINEDAT` / `EXPORTDAT` / `TRPORTDAT` / `INPORTDAT` / `CYLSTART` | — ✔ |
| `SUB FPORT, STAB, SETS, AREA, PIPE, SHOK, PORT, NINT, OUTFLOW, INFLOW, BOX, PISTPOS, PAREA, CYLINDER` | — ✔ all leaves |

Depth is 3: `MAIN → EXPORTOPEN/TRPORTOPEN/INPORTOPEN → FPORT/PORT/OUTFLOW/INFLOW`,
and `MAIN → PORTSTART → PISTPOS`. No recursion.

---

## 5. SHARED variables — the literal `SHARED` statements

Only 11 of the 14 SUB blocks declare anything `SHARED`; `FPORT`, `SHOK`,
`AREA` and `SETS` are pure (everything arrives positionally), which is why they
are safe to reuse.

| SUB | `SHARED` list as printed | arrays in it |
|---|---|---|
| `STAB` (1190) | `DZ, DTM, DC, RPM` | — |
| `PIPE` (1237) | `DZ, A2(), B2()` | `A2(20)`, `B2(20)` |
| `PORT` (1299) | `ABX(), BX(), AKA(), PA` | `ABX(21,45)`, `BX(45)`, `AKA(45)` |
| `NINT` (1324) | `LMESH` | — |
| `OUTFLOW` (1339) | `GK, GE, PA` | — |
| `INFLOW` (1360) | `GK, GE, PA` | — |
| `BOX` (1384) | `CCV, DTM, GK, GE` | — |
| `PISTPOS` (1410) | `DTOR` | — |
| `PAREA` (1422) | `PI` | — |
| `CYLINDER` (1436) | `GK, GE, NE, NC, DEG, SEFF, DC, BEFF, BDEG, TAF, CVAL, EPC, PA` and `PMAX, TKMAX, MAXDEG, MREF, CEFF, TEFF, DRAT` | — |
| `FPORT`, `SHOK`, `AREA`, `SETS` | none | — |

**Distinct names that must be visible inside a `SUB`: 32.**
Scalars (27): `DZ DTM DC RPM PA LMESH GK GE CCV DTOR PI NE NC DEG SEFF BEFF
BDEG TAF CVAL EPC PMAX TKMAX MAXDEG MREF CEFF TEFF DRAT`.
Arrays (5): `A2() B2() ABX() BX() AKA()`.

Cross-check against the writers, all in the main module:
`DZ` ← main 138; `DTM`,`DC` ← `STAB`; `RPM`,`GK`,`GE`,`PA`,`PI`,`DTOR`,`CCV`,
`MREF`,`CVAL`,`DRAT` ← main initialisation block; `LMESH` ← main 115;
`NE,NC,BEFF,BDEG,TAF` ← `COMBDAT` (or `.BOX` file); `DEG` ← main loop;
`SEFF,CEFF,TEFF` ← `CYLINDER`; `EPC` ← `PORTSTART`; `PMAX,TKMAX,MAXDEG` ←
`CYLINDER` → `RESETBDC`; `ABX,BX,AKA` ← the `UFLO` read; `A2,B2` ← `PIPE`.

---

## 6. Arrays and the dimensions they need

| array | dimension in `blair_full.bas` | index range actually used | who writes / reads |
|---|---|---|---|
| `ABX` | `(21,45)` | I 1–21 (I+1 ≤ 21), J 1–41 loaded, 42–45 allocated but **zero** | read: `UFLO`; used: `PORT` |
| `BX` | `(45)` | 1–41 loaded; `BX(J+1)` may reach 42 | `BX(J)=ABX(1,J)`; used: `PORT` |
| `AKA` | `(45)` | 1–21 computed (`0,.05,…`); `AKA(I+1)` ≤ 21 | main; used: `PORT` |
| `AE,BE,FE,DFE` | `(20)` | 1–`KE1` (and `KE1-1` for `DFE`) | `SETS`,`AREA`,`PIPE`,`SHOK`,`PORT`,`EXPORTOPEN` |
| `AET,BET,FET,DFET` | `(20)` | 1–`KE2` | as above |
| `AT,BT,FT,DFT` | `(20)` | 1–`KT` | as above |
| `AI,BI,FI,DFI` | `(20)` | 1–`KI` | as above |
| `A2,B2` | `(20)` | 1–`KE1/KE2/KT/KI` (all four ducts share them) | `PIPE` only |
| `DF,F` | `(20)` | unused by PROG.5.1 (generic pair; `AREA` is always called with a duct-specific pair) | — |
| `XA,YC,YS,YE` | `(200)` | 1–`M`, one point per step in the exhaust-open window | `SPLOT2`,`SPLOT4` |
| `XXA,YP,YI,YV,YB` | `(250)` | 1–`MG2` | `SPLOT3`,`SPLOT4` |
| `YF` | `(13)` | 1–13 | `SPLOT1` |
| `DELRAT,PEAKP,PEAKT,PMEP,CMEP,BMEP,POWER,FUEL,BSFC,SEFFP,TEFFP,CEFFP,SRMP,SRVP,EXRP` | `(20)` **added, D20** | 1–`JJ`, printed 2–`CYCLESTOP-2` (=5) | `RESETBDC`,`RESETTDC`,`DATOUT` |

Hard limits a translator must preserve:

* the four duct arrays are `(20)`, so `KE1`, `KE2`, `KT`, `KI` **must stay
  ≤ 20**. `KI = round(PL·√(TE/TP)/30)+1` with `PL` in mm, so a pipe longer than
  ≈ 570 mm with the default 30 mm mesh overflows `AET/BET/FET/DFET` etc.
* `ABX` is `(21,45)` but only 41 columns are loaded (`FOR J=1 TO 41`). `PORT`
  only clamps `BX1` from below (`IF BX1<.6 THEN BX1=.6`), so `BX1>1.48` gives
  `J>45` (out of bounds) and `1.40<BX1≤1.48` interpolates against zero-filled
  columns 42–45. Blair relies on the physics to keep `|B/X1|≤1.40`. See §9.
* `CYCLESTOP=7` keeps the history arrays inside `(20)`; raising it needs the
  `DIM`s raised with it.

---

## 7. Cross-unit globals (the main module's de-facto COMMON)

Every `GOSUB` routine and the main program share **one** flat global namespace —
that is the whole point of Blair's labelling convention — so these need no
`SHARED` statement, but a translator must keep them global. Grouped by the unit
that produces them:

| produced by | names |
|---|---|
| `ENGINEDAT` / `FILED`+`FILESET` | `BO ST CRL RPM TCR CCR TEXC BOM STM CRLM RPS FPISTON SV CCCV CRNK FMEP TEREF` |
| `EXPORTDAT` / `TRPORTDAT` / `INPORTDAT` | `EPO EPFO NEP WEP RTE RBE WEPM RTEM RBEM` / `TPO TPFO NTP WTP RTT RBT WTPM RTTM RBTM SCAV$` / `IPO IPFO NIP WIP RTI RBI WIPM RTIM RBIM` |
| `EXPIPDAT` / `TRPIPDAT` / `INPIPDAT` | `LEP1 DEP1 LEP2 DEP2 VBOX SIL$ LE1M LE2M DE1M DE2M VBOXM FEP1 FEP2` / `LTP TRAR LTM` / `LIP DIP THAR LIM DIPM FIPM` |
| `PORTSTART` | `EPC IPC IPOD TPC PWE PWT PWI PHE PHT PHI PFI PFE PFT PFIM PFEM PFTM HEOT HEOB HEFT HEFB EXHT HME HTOT HTOB HTFT HTFB TRHT HMT HIOT HIOB HIFT HIFB INHT HMI MSC CSC` |
| `PAREA` calls (main) | `FEPRT DEPRT FTPRT DTPRT FIPRT DIPRT` |
| main | `FTDUCT DTDUCT TSV CYCV VC1 VCC1` |
| `CYLSTART` | `TEREF TTREF TIREF SDE SDT SDI DEREF DTREF DIREF` |
| `NINT` (main) | `KE1 KE2 KT KI LMESH LE1M LE2M LIM LTM` |
| `STAB` | `DZ DTM DC` |
| `PIPE`/`SHOK`/`SETS`/`AREA` | the mesh arrays and `A2 B2` only |
| `EXPORTOPEN` | `PC1R CCE CDE AKE ME1 HE1 CE1` |
| `TRPORTOPEN` | `CCT CDT AKT MT1 HT1 CT1 EXPAND VOLINC SCRATIO SR SEFF` |
| `INPORTOPEN` | `PCC1R CCI CDI AKI MI1 HI1 CI1 DRATIO` |
| `OUTFLOW`/`INFLOW` (main calls) | `HTKT CTKT MTKT HEK1 CEK1 MEK1 HET1 CET1 MET1` |
| `BOX` (main calls) | `PB1 PB2 TB1 TB2 MB1 MB2 BOXW PCC1 PCC2 TCC1 TCC2 MCC1 MCC2 CCWORK PC2 TC2 VC2 MC2 CYWORK` |
| `CYLINDER` | `PMAX TKMAX MAXDEG CEFF TEFF` |
| main loop | `DEG ANGD CYC CYCLE CYCLEP CYCLESTOP KK NN JJ PEX PIR PTR PTRO PEXP PEXT PCR PCCR PBR EPC CCMEP CYMEP FMEP MBACK EXRATIO DRAT` |
| `SPLOT1..4` | `M MG MG2 NCOUNT X0 Y0 GYS YEF YTT YPS YVS DR DR2 XA YC YS YE XXA YP YI YV YB YBL` |

Note `TEREF` has three writers (`ENGINEDAT`, `FILESET`, `CYLSTART`), all the
same expression `TEXC+273`; `LMESH` (30 mm reference mesh) is *not* `LIMESH`/
`LTMESH`/`LEM1`/`LEM2` (actual mesh lengths in m) — do not merge them.

---

## 8. Runtime prerequisites

| # | item | status |
|---|---|---|
| 1 | Data file **`UFLO`** — 21 rows × 41 columns, ASCII, comma separated, no extension, read at main line 63 | not printed in either book, but **already regenerated** as `port/uflo.csv` (861 values, audited). Install as `UFLO` beside the source. |
| 2 | One case data set — either a `.BOX` file for the `F` branch (`FILED`) or interactive answers for the `N` branch | `port/QUB400_INPUT.dat` + `INPUT_FORMAT.md` hold the validation case. |
| 3 | QuickBASIC runtime services: `LINE`, `WINDOW OUTPUT`, `LOCATE`, `CLS`, `LPRINT`, `PRINT USING` | plot/printer only; stub them out and the calculation is unaffected (`SPLOT*`, `DATASET(L)`, `DATOUT`, `PRINTOUT`). |
| 4 | Mesh counts `KE1/KE2/KT/KI ≤ 20` | see §6. Satisfied by the reference case. |

No code blocker. The only thing that cannot be recovered from the books is the
`UFLO` table, and it has been regenerated independently (`UFLO_GENERATION.md`).

---

## 9. Printed-and-kept items a translator should know about (not changed)

1. **`SUB`-local labels vs one global namespace** — D23. Highest risk item in
   the file.
2. **`CYLINDER`'s `HT1` is local, so heat release is a rectangle rule** — D15.
   Deliberate; sharing it would alias the transfer enthalpy *and* spike `P2`.
3. **`MC2` is passed to `CYLINDER`, not `MC1`** — the routine uses it as
   start-of-step mass (`T2=P2*V2/(MC*GK)`), while `BOX` uses `MB1`. At 1–2°
   steps the effect is small; a translator should not "fix" it silently in one
   place only.
4. **`INHT=HIOT-HIFT` looks inverted** next to `EXHT=HEFT-HEOT` and
   `TRHT=HTFT-HTOT`, but it is not a defect under Blair's own data convention:
   `IPO` is asked for in °BTDC and `IPFO` in °ATDC, and the reference case has
   `IPFO=0`, so `HIFT=0` (piston at TDC) and `INHT=HIOT` is positive (21.2 mm on
   the QUB 400 case). It only goes negative if a case is entered with the piston
   lower at `IPFO` than at `IPO`. Check the data, not the code.
5. **`FIPM` is computed twice and used nowhere** — the likely intended `FPIP`
   in `INPORTOPEN`'s `FPORT` call. See D14.
6. **`PORT` has no upper clamp on `BX1`** — `|B/X1|>1.48` indexes past `ABX`'s
   45 columns; `1.40–1.48` interpolates against zero columns. Blair relies on
   the physics. If the ported code ever reads `A = -B` (total reflection) for no
   obvious reason, this is why.
7. **The plot arrays `XA(200)`, `XXA(250)` are sized for ~1° steps** (one point
   per time step inside a window). If `DC` comes out much smaller than 1°, `M`
   and `MG2` run past the declared bounds. Plot-only, but QuickBASIC without
   bounds checking will corrupt memory rather than complain.
8. **`PAREA` is the full-open area, not an angle-resolved area** (the crank-angle
   ramp is `FPORT`'s linear piston-travel law). Do not "improve" it to
   Eqs.5.2.1–5.2.5 while porting 5.1 — the results would no longer be Blair's.

---

## 10. Verdict

**Complete enough to translate and run.**

* 26 conflicts resolved, each with a stated reason and a stated failure mode for
  the rejected reading; 0 blockers.
* One file, 44 units, no duplicate definitions, no undefined `CALL`/`GOSUB`
  target, no duplicate label in the main module, call arity verified against
  every declaration (0 mismatches), ASCII only.
* Arithmetic smoke test of the merged routines against the QUB 400 reference
  data: `PISTPOS` returns 0 at TDC and 70 mm at BDC (degrees body behaving);
  `PAREA` returns 13.2 cm² / ⌀41 mm for the exhaust port; `FPORT` ramps
  0→0.935 linearly; `NINT` returns `KE1=8, KE2=8, KT=5, KI=11` (all inside the
  `(20)` duct arrays); `AREA` gives `π·0.038²/4` for a constant-diameter duct and
  a monotone taper otherwise.
* Two caveats, both external to the source: the `UFLO` table must be installed
  (available as `uflo.csv`), and the `SUB`-local labels must be renamed before
  any flattening translation.
