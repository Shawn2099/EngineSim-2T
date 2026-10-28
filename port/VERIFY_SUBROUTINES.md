# Independent verification — `port/blair_subroutines_basic.txt`

**Source:** `references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`
(31 387 lines — the transcript's stated size is correct)

**Ranges verified, in full (no sampling):**

| Section | Source lines | Transcript lines | Content |
|---|---|---|---|
| A | 27565–28192 (+28193–28197 checked, junk/next chapter) | 56–568 | ProgList 5.1/5.2 common subroutines |
| B1 | 20836–21266 (21267 checked = next program header, correctly excluded) | 575–1008 | ProgList 2.1/2.2 subroutines |
| B2 | 18704–18707 | 1015–1018 | SUB PISTPOS (ProgList 1.1 version) |

Method: every source line in the three ranges was read and mapped to its transcript counterpart, one
statement at a time (side-by-side dumps of each routine). That was supplemented by machine checks that
are independent of my reading:

* **statement-keyword parity** (A: RETURN 16/16, CALL 22/22, END SUB 15/15, SHARED 11/11, FOR 44/44,
  NEXT 7/7, THEN 106/106, `<=` 16/16, `>=` 1/1, `+` 81/81; B1: RETURN 20/20, NEXT 23/23,
  END SUB 11/11, THEN 20/20, GOTO 18/18, SHARED 5/5, LOCATE 8/8, PRINT 9/9, `+` 120/120);
* **assignment parity** (`=` count: A 338 vs 339 — the +1 is accounted for by the `CDE-75 → CDE=.75`
  repair, and `<=`/`>=` counts are identical 16/16 and 1/1, so no comparison or assignment operator was
  lost; B1 218 vs 218 exactly);
* **numeric-token containment** (every numeric literal in the source is present in the transcript, and
  vice-versa, with only the documented repairs as exceptions);
* **whitespace-insensitive full-string diff** to count genuine edit clusters and to prove no block of
  code went missing.

---

## 1. Counts

| Class | Count |
|---|---|
| **A — transcription errors** | **0** |
| **B — legitimate OCR repair** | **≈338** alphanumeric edit clusters (diff-derived: 218 in A, 130 in B1, 1 in B2, less 11 page-marker residues). Of these, **≈90 are substantive** — 16 numeric literals, 25 exponent/POWER restorations, 6 lost-sign/operator restorations, 3 parameter-list repairs, ~40 identifier glyph repairs — and the remainder are ~90 wrapped-statement rejoins and ~170 quote/comma/space rebuilds |
| **C — unjustified repair** | **3** (all disclosed or provably inert — see §2) |
| **D — omission** | **0 code statements.** Net 112 more source lines than listing lines (A: 115, B1: −3); all are non-code — 20 page numbers, 31 running heads / `<<<PAGE n>>>` markers, 16 blank lines, and ~45 margin glyphs and continuation fragments of wrapped statements that were correctly rejoined |
| **E — addition** | **2** code tokens (a `REM` keyword on two comment lines) + **8** declared `<UNRESOLVED …>` annotations |

Net: **the listing is a faithful transcription.** Nothing that carries physics, indexing, timing,
argument order or numeric value was altered by the transcriber.

---

## 2. Findings

### A — transcription errors: none

### C — unjustified repairs (3)

| # | Source line | Transcript line | What changed | Assessment |
|---|---|---|---|---|
| C1 | 28162 | 538 | `IF DEGOIGN THEN GOTO 20` → `IF DEGC<IGN THEN GOTO 20` | The relational operator is illegible in the source; the transcriber **invented `<`**. Disclosed by an inline marker, and **provably inert**: the statement is reachable only with `DEGC>IGN` (line 28159 already branched away when `DEGC<=IGN`) and `DEGC<BURNEND` (28161), so the following line 28163 (`IF DEGC<=BURNEND THEN GOTO 20`) sends control to label 20 either way. No effect on any computed quantity. |
| C2 | 21080 | 823 | `YC0=INT(YE1-(PCY-0*PK)` → `YC0=INT(YE1-(PCY-1)*PK)` | `0`→`1` **and** a closing parenthesis added. The inline marker only discusses `YC0` vs `YCO`, so this digit change is undisclosed. Corroborated by `ESET` (21033: `YCO=INT(YE1-(PCY-1)*PK)`), so the reading is almost certainly right — but it is an undisclosed numeric edit. **Graphics only** (trace-panel origin). |
| C3 | 20953 | 696 | `XCM(J)=XC1+XMHC*(M)` → `XCM(J)=XC1+XMHC*(J-1)` | Loop-step argument invented; undisclosed. Corroborated by the identical idiom in `ASET` (20846) and by `M` being otherwise undefined. **Graphics only** (x-axis mesh). |

None of C1–C3 is in a physics routine.

### E — additions (2 code tokens)

| # | Source line | Transcript line | What changed |
|---|---|---|---|
| E1 | 27728 | 168 | `SCAVENGING MODEL NO.1 IN SUBROUTINE 'TRPORTOPEN'` → `REM SCAVENGING MODEL NO.1 IN SUBROUTINE "TRPORTOPEN"` (the `REM` keyword does not exist in the source) |
| E2 | 27748 | 187 | same for `SCAVENGING MODEL NO.2` |

Comment-only. (The source line is printed above `REM Eqn.5.1.1 …`, so it is a caption rather than a
statement; adding `REM` makes it legal BASIC and changes no behaviour.)

Annotations added (declared by the transcript as metadata, not listing text): lines 158, 538, 554, 708,
823, 991, 994, 998. **All eight are factually correct** where I could test them:

* 158 `TCT` — I grepped the whole book: `TCT` occurs **once only** (27720). The claim that TC1/TCC1 are
  used in the sibling branches is correct.
* 708 `CBLACK` uses `YA1` — correct; the panel really should use `YC1` (ABLACK uses `YA1`, DBLACK `YD1`).
* 823 `YC0` vs `YCO` — correct, both spellings are really printed.
* 991 `MDI`, 994 `TI`/`CI` undeclared in the Prog.2.0 `BOX` — correct; the 10-argument header really has
  no inlet mass-flow / inlet-temperature / inlet-velocity arguments.
* 998 `VB` cancels in `PB2=(MB2*TB2*PB1*VB)/(MB1*TB1*VB)` — correct (reduces to `MB2*TB2*PB1/(MB1*TB1)`).
* 554 `TRM1=…-VR` and the following unconditional reassignment — both really printed.

### B — legitimate repairs, material items only

**Numeric literals (16)** — each re-read against the source scan text:

| Source | Transcript | Source → transcript |
|---|---|---|
| 27590 | 68 | `LTM=LTP/10()fl` → `/1000` |
| 27824 / 27826 / 27930 / 27931 | 243 / 245 / 313 / 314 | `/I0()0`, `/10()(J`, `/1()00`, `/I000` → `/1000` |
| 27938 | 321 | `TIREF=3()()` → `300` |
| 27689 / 27691 | 138 / 140 | `-.l 17` → `-.117`; `. 1397` → `.1397` |
| 27731 / 27707 / 27758 | 171 / 155 / 195 | `CCT=8`→`.8`; `CDE-75`→`.75`; `CDT=75`→`.75` |
| 27780 / 28038 / 28039 | 216 / 421 / 422 | `CCI=9`→`.9`; `AK=95`→`.95`; `BX1=6`→`.6` |
| 27974 | 358 | `.78';i4` → `.7854` |
| 28183 | 559 | `l00000!` → `100000!` |

All are the "lost leading decimal point" / `l↔1` / `O↔0` classes declared in the transcript header.
**No numeric constant was changed to a different value, and no digit was altered other than these.**

**Exponents (25)** — the book prints `A2`, `A7`, `A(l/7)`, `A0.1667`, `(VR)A…`, `)APOLYINDEX`; the
transcript writes `^`. Full list: 27974, 28024, 28036, 28062, 28063, 28065, 28070, 28073, 28074, 28080,
28086, 28089, 28090, 28096, 28109, 28127, 28154, 28164, 28176, 21142, 21206, 21235, 21238, 21239, 21240,
18705. Every one is justified by the surrounding algebra (and 21206 is printed `*(l/7)`, i.e. a `*` where
`^` belongs — same repair).

**Lost signs / operators (6)** — the only ones in the whole listing:

| Source | Transcript | Source → transcript |
|---|---|---|
| 27653 | 104 | `TPC=36()TPO` → `TPC=360-TPO` (minus restored) |
| 27675 | 124 | `HMT=TRHT-RTTM RBTM` → `…-RTTM-RBTM` (minus restored) |
| 27949 | 333 | `AK=CC*FINSTTPRT/FPIP` → `…FINST*FPRT…` (`*` and the `F` of `FPRT` restored; `FPRT` is a declared parameter) |
| 28022 | 404 | `IFRK1 THEN GOTO 56` → `IF R1<1 THEN GOTO 56` (corroborated by the identical clean line at 21188) |
| 28023 | 405 | `(7*Rl*Rl-D)` → `(7*R1*R1-1))` |
| 28056 | 438 | `BI=RI KI` → `BI=RI-KI` |

**Identifier glyph repairs (~40)**: `Pl/Tl/Vl→P1/T1/V1`, `HTl→HT1`, `MTl/MTI→MT1`, `MBI→MB1`, `TBI→TB1`,
`MEl→ME1`, `MIl→MI1`, `PCCI/PCCl→PCC1`, `TCCI→TCC1`, `TCI→TC1`, `P1R→PIR`, `PI→P1` (28184), `DlPM→DIPM`,
`1POD→IPOD`, `1NHT→INHT`, `lNPUT→INPUT`, `F0RJ→FOR J`, `L1NE→LINE`, `GI/G! /G 1→G1`, `Rl→R1`,
`PORK→PORT` (27782), `FPOR1→FPORT`, `DEPD'→DIP`, `MRF.F→MREF`, `RPM*F;→RPM*E`, `^M→ZM` (20921),
`HXB5→-(XB5` (20896), `ABX(I+EJ)→ABX(I+1,J)`, `WINDOW OUTPUT* 1→#1`, `GOTO }}→GOTO 33`,
`LOCATE11,31→LOCATE 11,31`, `PRINTT.5"→PRINT"1.5"`, `PRINT"LO"→PRINT"1.0"`,
`SCAVENGING MODEL NO.l→NO.1`.

**Header / parameter-list repairs (3)**: `SUB FPOR1 (HOT.HTDCPHT.FPRT…)` → `SUB FPORT(HOT,HTDC,PHT,…)`
(7 parameters, matching the 7-argument call sites); `SUBCYLINDER(Pl.P2…)` → `SUB CYLINDER(P1,P2…)`;
`BOX(…CIN,CO,IUN,HO,WORK)` → `BOX(…CIN,CO,HIN,HO,WORK)` — `IUN`→`HIN` is justified because the body
uses `HIN` (28105) and `IUN` appears nowhere.

**Rejoins (the ~90 wrapped statements)**: e.g. 27572–27579 → line 63; 27709–27714 → 157; 27787–27789 → 222;
28093–28094 → 476; 21260–21261 → 1003. Statement order is never changed. Correct per the stated convention.

---

## 3. Physics audit (the five focus items)

### 3.1 `SUB CYLINDER` (28136–28192 → 515–568) — clean, equation for equation

I compared all 47 statements. **Every equation, coefficient and operator matches the print.**

| Quantity | Printed (source) = transcribed |
|---|---|
| index switch | `IF DEGC<=360 THEN POLYINDEX=NC` / `IF DEGC>360 THEN …NE` |
| combustion gate | `IF DEGC>EPC+5 THEN GOTO 30` |
| trapped charge | `MAIR=SEFF*MC`; `CEFF=MAIR/MREF`; `TEFF=MAIR/(DRAT*MREF)` |
| ignition | `IGN=360-BDEG/6` (÷**6**, not ÷3) |
| burn window | `BURNEND=IGN+BDEG`; `TAILDEG=BURNEND-BDEG/3`; `PEAK=IGN+BDEG/3` |
| heat release | `TAFB=13`; `IF TAF>TAFB THEN TAFB=TAF`; `HEAT=BEFF*CVAL*MAIR^TAFB` |
| Wiebe/trapezoid | `QMAX=36*HEAT/(14*BDEG)`; `S1=3*QMAX/BDEG`; `S2=5*QMAX/(2*BDEG)`; `S3=QMAX/(2*BDEG)` |
| ramps | `HT2=S1*(DEGC-IGN)`; `HT2=(TAILDEG-DEGC)*S2`; `HT2=(BURNEND-DEGC)*S3` |
| heat to wall | `QHT=DC*(HT1+HT2)/2` (**plus** sign — correct) |
| Rassweiler–Withrow | `TRM1=(GE+1)*V2/(2*(GE-1))-VR` **and** the overriding `TRM1=V2/(GE-1)`; `P2=(QHT/TRM1)+P1*VRN` |
| polytropic fallback | `P2=P1*(V1/V2)^POLYINDEX`; `T2=P2*V2/(MC*GK)` |
| work | `WORK=(P1+P2)*(V2-V1)/2` |
| diagnostics | `DELTAP=(P2-P1)/(100000!*DC)`; `PMAX=P2/100000!`; `MAXDEG=DEGC-360`; `IF T2>T1 THEN TKMAX=T2`; `IF DELTAP>DPMAX THEN DPMAX=DELTAP` |
| state commit | `P1=P2`; `T1=T2`; `V1=V2`; `HT1=HT2` |

**Local vs shared — the critical question.** Both `SHARED` statements are reproduced exactly
(13 names + 7 names, 28137/28138):

* `HT1` — **local**. Not a parameter, not in either `SHARED` list. Because the SUB is `STATIC`, `HT1`
  is a *persistent local*: it survives between calls and cannot be reset by the caller.
* `DPMAX` — **local**. Also absent from the `SHARED` list, even though `PMAX`, `TKMAX` and `MAXDEG`
  (its siblings) *are* shared. `DELTAP`, `HT2`, `IGN`, `BURNEND`, `TAILDEG`, `PEAK`, `TAFB`, `HEAT`,
  `QMAX`, `S1..S3`, `POLYINDEX`, `MAIR`, `VR`, `VRN`, `TRM1`, `QHT` are local too.

The transcript does **not** silently promote either one to `SHARED`, and does not add `DZ`-style
initialisers. That is exactly right — a translator who "tidies" this will change the model's numbers
(see §4).

### 3.2 `OUTFLOW` / `INFLOW` (28060–28091 → 443–474)

Nine arguments, order `(A,B,F,TR,H,C,M,D,CD)`, identical in the header and in all six call sites
(157/158; 177/178; 196/197; 221/222). Verified character-for-character:

```
OUTFLOW:  CP=481.17*TR^.25
          GAM=1.7847/(TR^.417)
          AB=(A+B)/2 ; TREF=TR/AB^2
          SD=SQR(GAM*GK*TREF)
          C=SD*(A-B)/(GAM-1)
          H=CP*TR
          D=AB^.5*PA/(GK*TREF)
          M=CD*C*F*D
          MN=C/SQR(GAM*GK*TR)          <- TR, not TREF  (as printed)
          P1=(.5*(A+1))^7 ; P2=(.5*(B+1))^7

INFLOW:   CP=481.17*TR^.25 ; GAM=1.7847/(TR^.417) ; AB=(A+B)/2
          SD=SQR(GAM*GK*TR)            <- TR, not TREF  (as printed)
          C=2.5*SD*(A-B)
          T=TR*AB*AB ; H=CP*T
          D=AB^.5*PA/(GK*TR)           <- TR, not T   (as printed)
          MN=C/SQR(GAM*GK*T)           <- T            (as printed)
          PR=(.5*(A+1))^7 ; PL=(.5*(B+1))^7
```

Every one of the three asymmetries between the two routines (`TREF` vs `T` in `SD`, in `D`, and in `MN`)
is preserved as printed. `481.17`, `1.7847`, `.25`, `.417`, `2.5`, `(GAM-1)` and the exponent `7` are all
digit-exact.

**Flow-direction logic is reproduced faithfully, including the awkward parts:**

* exhaust calls `OUTFLOW(AE(1),BE(1),…)` but the transfer calls `OUTFLOW(BT(1),AT(1),…)` — argument
  order *reversed* in the transfer routine, as printed (lines 157/158 vs 177/178/196/197);
* the inlet calls `OUTFLOW(BI(1),AI(1),…)` **and** `INFLOW(BI(1),AI(1),…)` with the same reversed order;
* the `<=`/`>`…`PC1R` split selects `TC1` vs `TCC1` (transfer), `TC1` vs `TCT` (exhaust), `TCC1` vs
  `TIREF` (inlet) exactly as printed.

### 3.3 `PAREA` (28130–28134 → 509–513)

```
FP=NP*(WP*HP-(2-PI/2)*(RT*RT+RB*RB))
DP=SQR(4*FP/PI)
```
Exact, including the `(2-π/2)` corner rounding term (a classic place to lose a factor) and the
`4*FP/PI` equivalent-diameter form. 7 parameters, matching call sites elsewhere in the book.

### 3.4 `FPORT` (27946–27950 → 330–334)

```
FINST=(HTDC-HOT)/PHT
IF FINST>1 THEN FINST=1
AK=CC*FINST*FPRT/FPIP
```
Exact — **and note there is no lower clamp in the book** (`IF FINST<0 THEN FINST=0` does not exist;
`FINST` occurs only here in the entire 31 387-line source). The ramp is one-sided: linear in
`(HTDC-HOT)/PHT`, saturated at 1. The transcriber did **not** invent the missing clamp, which is the
correct choice — but see §4, hazard H1.

### 3.5 `BOX`, 15-argument version (28093–28117 → 476–494)

```
SUB BOX(PB1,PB2,TB1,TB2,VB1,VB2,MB1,MB2,MIN,MO,CIN,CO,HIN,HO,WORK)STATIC
SHARED CCV,DTM,GK,GE
CV1=269.49*TB1^0.1667
DMI=MIN*DTM ; DME=MO*DTM
MB2=MB1+DMI-DME
EIN=DMI*(HIN+.5*CIN*CIN)
EO =DME*(HO +.5*CO*CO)
DW =PB1*(VB2-VB1)
TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV1*MB2)
CV2=269.49*TB2^0.1667
TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV2*MB2)
PB2=MB2*GK*TB2/VB2
WORK=(PB1+PB2)*(VB2-VB1)/2
PB1=PB2 : TB1=TB2 : MB1=MB2 : VB1=VB2
```

Mass bookkeeping (`MB2=MB1+DMI-DME`), the `-DW` sign (work *out* reduces internal energy), the
two-pass `TB2` iteration (CV evaluated at `TB1`, then at `TB2`; the first `TB2` is overwritten), and the
state commit are all digit-for-digit correct. `269.49` and `0.1667` are exact in both places.

### 3.6 Spot checks outside the focus list (also clean)

`PIPE` (both versions: `G1=3`, `G2=2`, `Y`/`Z` denominators, `QA/QB`, and `B2(J)` **not** `B2(J+1)`);
`SHOK` (`R2`, `R3^(1/7)`, the `A(J)>B(J)` swap branches, the `R1<1` early exit);
`PORT` (`X1=(P/PA)^(1/7)`, the `.95`/`.6` clamps, `I=INT(AK/.05)+1`, `J=INT((BX1-.6)/.02)+1`,
`A=2*X1*ABX1-B`); `AREA` (`*.7854`, `KC=KB-1`); `BELMOUTH` (`((4*M+1)+SQR(1+20*M-20*M*M))/6`);
`PISTPOS` (both versions); `STAB`; `SETS`; `NINT`; `CYLSTART` (`320`, `300`, `273`).

---

## 4. Book quirks that were (correctly) preserved — handle these when translating

These are **not** transcription defects. They are exactly what Blair printed, and each one will bite a
literal translation:

| # | Quirk | Source → transcript | Consequence |
|---|---|---|---|
| H1 | `FPORT` has **no lower clamp** on `FINST` | 27948 → 331–333 | If called while `HOT>HTDC`, `FINST<0` ⇒ **negative port area**. The caller must gate the call. Do not "helpfully" add the clamp without recording it. |
| H2 | `STAB` in ProgList 5.x has **no `DZ=1`** initialiser, but the ProgList 2.x copy **does** | 27951–27963 → 336–345 vs 21124 → 866 | `DZ` is a persistent local ⇒ it only ever ratchets downward across the whole run. Correctly preserved as the asymmetry it is. |
| H3 | `NINT` differs between versions: `RI=PL*A/LMESH`, `K1=KI+1` vs `RI=PL*A/30`, **`KI=KI+1` twice** | 28049–28059 → 433–441 vs 21219–21226 → 961–968 | The 2.x copy increments twice when `BI>.5`. A real book bug; preserved. |
| H4 | `CYLINDER`'s `DPMAX` is local and never reset | 28138/28187 → 517/563 | `DPMAX` accumulates across cycles; with `DPMAX` unshared the driver cannot reset it. Decide explicitly (global + per-cycle reset) rather than inheriting it. |
| H5 | `CYLINDER`'s `HT1` is local, and is updated on the *non-combustion* path too (label 90 → 50) | 28174/28191 → 550/567 | `HT1` normally decays to 0 at burn-out, so cross-cycle leakage is small — but it must be initialised for cycle 1. |
| H6 | `DELTAP` is only assigned when `P2>P1`, yet always compared | 28183/28187 → 559/563 | A stale `DELTAP` can be re-tested; harmless for a max, but replicate deliberately. |
| H7 | `CCE`, `CDE`, `CCT`, `CDT` are set to the **same** value in both branches of the `<=`/`>` test | 27700/27704, 27707/27708, 27731/27732, 27735/27736 … | Dead branches; harmless. (`CCI`/`CDI` genuinely differ: `.8`/`.9`, `.75`/`.9`.) |
| H8 | `CCCV=SV/(CCR-1)` while `BOX` shares **`CCV`** | 27830 → 249 (also 26340, 27136) | Three `CCCV=SV/(CCR-1)` vs `CCV=718` data statements. As printed, `CCV` is never computed in these listings. Transcriber kept `CCCV` (correct); the translator must decide which name the crankcase model uses. |
| H9 | `TCT` used once and nowhere defined | 27720 → 158 | Almost certainly `TCC1`. Disclosed in the transcript. |
| H10 | `INPORTOPEN`'s `FPORT` call passes `(HTDC,HIOT,…)` (swapped vs the other two) and `FIPRT` twice | 27781 → 217 | As printed. Do not "fix" without testing. |
| H11 | `CBLACK` uses `YA1` (the A-panel origin) | 20966 → 708 | Display-only; disclosed. |
| H12 | Prog.2.x `BOX`/`FLOW` reference undeclared `MDI`, `TI`, `CI` | 21247/21252 → 991/994 | Argument list is incomplete in the book; disclosed. |
| H13 | `ENGINEDAT` computes `FMEP=100*STM*RPM` | 27832 → 251 | A hard-coded empirical friction law (Pa), not derived from anything else in the listing; do not substitute a Heywood-type correlation silently. |

---

## 5. Verdict

**Safe to translate.** The physics routines — `CYLINDER`, `BOX` (15-arg), `OUTFLOW`, `INFLOW`, `PAREA`,
`FPORT`, `PORT`, `PIPE`, `SHOK`, `AREA`, `BELMOUTH`, `PISTPOS` — are transcribed **exactly**: every
equation, sign, argument order, coefficient and numeric constant matches the printed source, and the
`SHARED` lists (hence the local/shared status of `HT1` and `DPMAX`) are reproduced unaltered. The only
three unjustified repairs are confined to display code (`CBLACK`, `CSTART`) and one provably inert branch
in `CYLINDER`; none can change a computed number. Treat hazards H1–H13 as *book* behaviour to be decided
deliberately, not as transcription defects.
