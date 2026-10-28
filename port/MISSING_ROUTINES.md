# The "missing" PROG.5.1 subroutines — CYLINDER, PAREA, STAB, OUTFLOW

Search performed over the **complete** OCR text of both books:

| File | Lines |
|---|---|
| `references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt` (1990) | 31,387 |
| `references/text/Blair,_G.P._-_Design_and_Simulation_of_Two-Stroke_Engines_(S.txt` (1996) | 33,534 |

Note on file names: both contain a non-ASCII en-dash (`U+2013`) between `G.P._` and the title.
`Read`/`-Path` with a plain hyphen fails; use `-LiteralPath` with the real file object, or `Get-ChildItem -Filter "Blair*"`.

---

## TL;DR

**None of the four is missing.** All four are printed in full in the 1990 book, in the
ProgList 5.0 shared-subroutine block on **source lines 27951–28192**, a block that sits
immediately *after* `CYLSTART:` (27934–27949) and immediately *before* `COMPUTER PROGRAM
PROG.6.1` (28198). `PROG51_DAMAGE.md` stops its transcription at `CYLSTART` (line 27949) and
therefore never reached them; its statement that these four are "not printed anywhere in the
book" (§7, and §9 caveat 2) is incorrect.

| Routine | Printed? | Where (1990 file lines) | Lines of code | 1996 book |
|---|---|---|---|---|
| `STAB` | **Yes, twice** | 21121–21131 and 27951–27963 | 10 | prose only (Sect. 2.18.2) |
| `OUTFLOW` | **Yes** | 28060–28075 | 16 | no code at all |
| `INFLOW` (9 args, as suspected) | **Yes** | 28077–28091 | 15 | no code at all |
| `PAREA` | **Yes** | 28130–28134 | 5 | no code at all |
| `CYLINDER` | **Yes** | 28136–28192 | 55 | no code at all |

Total: **101 lines of BASIC recoverable verbatim** (OCR-damaged but complete in logic).
The 1996 book prints **zero lines of program code anywhere** — verified numerically in §5.

The one substantive correction to the brief: `PAREA` is *not* the port-area-vs-crank-angle
routine. It returns the **full-open** port area and an equivalent diameter. The crank-angle
dependence is produced by `FPORT` (27946–27950, `AK = Cd·(HTDC−HOT)/PHT·FPRT/FPIP`) driven by
`PISTPOS`, i.e. a linear ramp in piston travel — not by `PAREA`.

---

## 1. CYLINDER — FOUND

### 1.1 Evidence

| Kind | File line | Text |
|---|---|---|
| definition | **28136** | `SUBCYLINDER(Pl.P2.Tl,T2,Vl,V2,MC,WORK)STATIC` → `SUB CYLINDER(P1,P2,T1,T2,V1,V2,MC,WORK) STATIC` |
| body | 28136–28192 | 55 statements, terminated by `END SUB` at 28192 |
| call (Prog 5.1) | 26247–26250 | `IF HTDC<=HEOT THEN CALL CYLINDER(PC1,PC2,TC1,TC2,VC1,VC2,MC2,CYWORK)` |
| call (Prog 5.2) | 27051 | `CYLINDER(PCI.PC2,TC1,TC2,` (continuation on 27052) |
| prose, 1990 | 10142–10143 | "Within the computer programs presented in the ProgLists.5.1 and 5.2, the combustion model is found in Subroutine CYLINDER." |
| prose, 1990 | 10238–10240 | references "the information for cylinder properties which would be provided by Subroutine CYLINDER" |

Nothing is truncated: 28193 is the page number `6n3` (p.603), 28195 is `<<<PAGE 312>>>`,
28196 the running head `Computer Program Appendix - I'rogList 6.0`, 28198
`COMPUTER PROGRAM PROG.6.1`. The listing closes cleanly on the printed page.

**Scope correction.** `CYLINDER` is the **closed-cycle** model only. It is called from the
main loop under `IF HTDC<=HEOT` (piston has not yet uncovered the exhaust port). The
*open-cycle* cylinder thermodynamics is `SUB BOX` (28093–28117), called at 26251–26252.
`CYLINDER` therefore does **not** contain mass flow, port flow or scavenging — it is
heat release + polytropic compression/expansion + the book-keeping used for the screen.

### 1.2 Printed listing, exactly as OCR'd (1990 file, 28136–28192)

```
28136 SUBCYLINDER(Pl.P2.Tl,T2,Vl,V2,MC,WORK)STATIC
28137 SHAREDGK,GE,NE,NC,DEG.SEFF.DC.BEFF.BDEG,TAF.CVAL.EPC.PA
28138 SHARED PMAX.TKMAX.MAXDEG.MREF.CEFF.TEFF.DRAT
28139 DEGC=DEG
28140 IF DEGC<=360 THEN POLYlNDEX=NC
28141 IF DEGC>360 THEN POLYINDEX=NE
28142 IF DEGC>EPC+5 THEN GOTO 30
28143 MAIR=SEFF*MC
28144 CEFF=MAIR/MREF
28145 TEFF=MAIR/(DRAT*MREF)
28146 IGN=360-BDEG/6
28147 BURNEND=IGN+BDEG
28148 TAILDEG=BURNEND-BDEG/3
28149 PEAK=IGN+BDEG/3
28150 602                                   <- page number, not code
28151 Computer Program Appendix - ProgList 5.0   <- running head
28152 TAFB=13
28153 IF TAF>TAFB THEN TAFB=TAF
28154 HEAT=BEFF*CVAL*MAIRA"AFB
28155 QMAX=36*HEAT/( 14*BDEG)
28156 S1=3*QMAX/BDEG
28157 S2=5*QMAX/(2*BDEG)
28158 S3=QMAX/(2*BDEG)
28159 30 IF DEGC<=IGN THEN GOTO 90
28160 \                                     <- garbage
28161 IF DEGC>=BURNEND THEN GOTO 90
28162 IF DEGOIGN THEN GOTO 20
28163 IF DEGC<=BURNEND THEN GOTO 20
28164 90P2=P1*(V1/V2)APOLYINDEX
28165 T2=P2*V2/(MC*GK)
28166 GOTO 50
28167 20 IF DEGC>PEAK THEN GOTO 60
28168 HT2=S1*(DEGC-IGN)
28169 GOTO 80
28170 60 IF DEGC<=TAILDEG THEN GOTO 70
28171 HT2=(BURNEND-DEGC)*S3
28172 GOTO 80
28173 70 HT2=(TAILDEG-DEGC)*S2
28174 80QHT=DC*(HTl+HT2)/2
28175 VR=V1/V2
28176 VRN=(VR)APOLYINDEX
28177 REM RASSWEILER AND WITHROW THEORY
28178 TRM1=(GE+1)*V2/(2*(GE-1))-VR
28179 TRM1=V2/(GE-1)
28180 P2=(QHT/TRM1)+P1*VRN
28181 T2=P2*V2/(MC*GK)
28182 50 WORK=(Pl+P2)*(V2-Vl)/2
28183 IFP2>P1 THEN DELTAP=(P2-P1 )/(l00000!*DC)
28184 IFP2>PI THEN PMAX=P2/100000!
28185 IF P2>P1 THEN MAXDEG=DEGC-360
28186 IFT2>T1 THEN TKMAX=T2
28187 IF DELTAP>DPMAX THEN DPMAX=DELTAP
28188 P1=P2
28189 T1=T2
28190 V1=V2
28191 HT1=HT2
28192 END SUB
```

### 1.3 Cleaned, ready-to-transcribe form

```basic
SUB CYLINDER (P1,P2,T1,T2,V1,V2,MC,WORK) STATIC
  SHARED GK,GE,NE,NC,DEG,SEFF,DC,BEFF,BDEG,TAF,CVAL,EPC,PA
  SHARED PMAX,TKMAX,MAXDEG,MREF,CEFF,TEFF,DRAT
  DEGC=DEG
  IF DEGC<=360 THEN POLYINDEX=NC
  IF DEGC>360 THEN POLYINDEX=NE
  IF DEGC>EPC+5 THEN GOTO 30
  MAIR=SEFF*MC
  CEFF=MAIR/MREF
  TEFF=MAIR/(DRAT*MREF)
  IGN=360-BDEG/6
  BURNEND=IGN+BDEG
  TAILDEG=BURNEND-BDEG/3
  PEAK=IGN+BDEG/3
  TAFB=13
  IF TAF>TAFB THEN TAFB=TAF
  HEAT=BEFF*CVAL*MAIR*TAFB
  QMAX=36*HEAT/(14*BDEG)
  S1=3*QMAX/BDEG
  S2=5*QMAX/(2*BDEG)
  S3=QMAX/(2*BDEG)
30 IF DEGC<=IGN THEN GOTO 90
  IF DEGC>=BURNEND THEN GOTO 90
  IF DEGC<IGN THEN GOTO 20              ' dead as printed (unreachable)
  IF DEGC<=BURNEND THEN GOTO 20         ' dead as printed (unreachable)
90 P2=P1*(V1/V2)^POLYINDEX
  T2=P2*V2/(MC*GK)
  GOTO 50
20 IF DEGC>PEAK THEN GOTO 60
  HT2=S1*(DEGC-IGN)
  GOTO 80
60 IF DEGC<=TAILDEG THEN GOTO 70
  HT2=(BURNEND-DEGC)*S3
  GOTO 80
70 HT2=(TAILDEG-DEGC)*S2
80 QHT=DC*(HT1+HT2)/2
  VR=V1/V2
  VRN=VR^POLYINDEX
  REM RASSWEILER AND WITHROW THEORY
  TRM1=(GE+1)*V2/(2*(GE-1))-VR   ' Eq 4.2.12 denominator, then discarded
  TRM1=V2/(GE-1)                 ' Eq 4.2.13 denominator, actually used
  P2=(QHT/TRM1)+P1*VRN
  T2=P2*V2/(MC*GK)
50 WORK=(P1+P2)*(V2-V1)/2
  IF P2>P1 THEN DELTAP=(P2-P1)/(100000!*DC)
  IF P2>P1 THEN PMAX=P2/100000!
  IF P2>P1 THEN MAXDEG=DEGC-360
  IF T2>T1 THEN TKMAX=T2
  IF DELTAP>DPMAX THEN DPMAX=DELTAP
  P1=P2
  T1=T2
  V1=V2
  HT1=HT2
END SUB
```

OCR repairs applied above (all mechanical, none affects logic):
`SUBCYLINDER`→`SUB CYLINDER`; `Pl/Tl/Vl`→`P1/T1/V1`; `POLYlNDEX/POLYINDEX` unified as
`POLYINDEX` (the OCR reads `POLYlNDEX` on 28140, `POLYINDEX` on 28141 — same variable);
`MAIRA"AFB`→`MAIR*TAFB`; `DEGOIGN`→`DEGC<IGN`; `(V1/V2)APOLYINDEX`→`(V1/V2)^POLYINDEX`;
`(VR)APOLYINDEX`→`VR^POLYINDEX`; `HTl`→`HT1`; `l00000!`→`100000!`; `IFT2>`→`IF T2>`;
`IFP2>`→`IF P2>`; `PI`→`P1` on 28184 `IFP2>PI` (compared against P1, cf. 28183/28185);
`(Pl+P2)`→`(P1+P2)`; `(V2-Vl)`→`(V2-V1)`.

**Two real defects in the printed routine** (not OCR):
1. `HT1` is read at 28174 and written at 28191 but is **absent from both SHARED lists**
   (28137–28138). Transcribed literally into QBasic, `HT1` is a local that is zero on entry,
   so the trapezoidal heat-release integration degrades to `QHT = DC*HT2/2`. Either add
   `HT1` to SHARED or accept rectangular integration.
2. `DPMAX` (28187) is likewise not in any SHARED list, so `DELTAP>DPMAX` is always true and
   the "maximum pressure rise per degree" diagnostic never accumulates.
Both are almost certainly dropped identifiers in the book or its OCR; neither affects P2/T2/WORK.

Minor: the mass argument passed by the caller is `MC2` (end-of-step mass, 26250) while the
routine uses it for start-of-step state (`T2=P2*V2/(MC*GK)`). Blair's own `BOX` uses
`MB1` for the same purpose. Harmless at 1–2° steps but worth noting when porting.

### 1.4 The equations CYLINDER implements, with line references

| Code line | Physics | 1990 book | 1996 book |
|---|---|---|---|
| 28154 `HEAT=BEFF*CVAL*MAIR*TAFB` | total heat available, `Q = ηc·m_tf·C_fl`, `m_tf = m_ta·AFR` | 2043–2050 (Eqs. 1.5.20, 1.5.21) | 2802 (Eq. 1.5.21), 16400–16405 (Eq. 4.3.36) |
| 28155 `QMAX=36*HEAT/(14*BDEG)` | triangular heat-release profile, area `= 14·H_M·P_θ/36` | 8403–8405 | 16458–16464 (Eq. 4.3.42) |
| 28152–28153 `TAFB=max(TAF,13)` | rich-mixture floor; AFR clamped at 13 | 8399–8400 (period/limits discussion) | 16456–16457 |
| 28146–28149 `IGN`, `BURNEND`, `TAILDEG`, `PEAK` | ignition `P_θ/6` btdc, rise `P_θ/3` about tdc, tail `P_θ/3` | 8390–8402 | 16456–16457 |
| 28156–28158 `S1,S2,S3` | slopes of the three heat-release segments | 8390–8402, Fig. 4.6 | Fig. 4.6 / Eq. 4.3.42 |
| 28164 `P2=P1*(V1/V2)^n` | polytropic compression (`NC`) / expansion (`NE`) | 8666–8678 | 16993–16994 (n = 1.25 / 1.35) |
| 28178–28180 | First Law in Rassweiler–Withrow form: `dQ = (P2 − P1·VRN)·V2/(γ−1)`, i.e. `P2 = QHT·(γ−1)/V2 + P1·VRN`; 28178 is the more exact denominator of Eq. 4.2.12 and is immediately overwritten by the Eq. 4.2.13 form | 8106–8139 (Eqs. 4.2.2–4.2.7), 8164 (4.2.12), 8175 (4.2.13) | 17002 (Eq. 4.2.8), 17037–17043 (Eq. 4.4.1) |
| 28165/28181 `T2=P2*V2/(MC*GK)` | equation of state `pV=mRT` | 8114–8118 (Eq. 4.2.4) | 17044–17050 (Eq. 4.4.2) |
| 28182 `WORK=(P1+P2)*(V2-V1)/2` | trapezoidal indicated work | 8133–8134 (Eq. 4.2.6) | 17003 (Eq. 4.2.8 work term) |
| 28143–28145 `CEFF`, `TEFF` | charging efficiency `= m_air/m_ref`, trapping efficiency `= m_air/(DR·m_ref)` | 1946–1975 (Sects. 1.5.3–1.5.4) | 2634–2675 (Sects. 1.5.3–1.5.4) |

Cross-check on the overwrite at 28178–28179: the book itself says the difference between
Eqs. 4.2.12 and 4.2.13 "is small … less than 1%" (8177–8178). The code computes the exact
form and then discards it — that is Blair's own choice, not a transcription error.

---

## 2. PAREA — FOUND (but it is not what the brief assumes)

### 2.1 Evidence

| Kind | Line | Text |
|---|---|---|
| definition | **28130** | `\j SUB PAREA(NP,WP.HP,RT,RB.FP.DP)STATIC` |
| body | 28130–28134 | 5 statements, `END SUB` at 28134 |
| call (Prog 5.1, exhaust) | 26097 | `CA1.LPAREA(NEP,WEPM.EXHT,RTEM.RBEM.FEPRT.DEPRT)` → `CALL PAREA(...)` |
| call (transfer) | 26098 | `CALL PAREA(NTP,WTPM.TRHT,RTTM.RBTM,FTPRT,DTPRT)` |
| call (inlet) | 26099 | `CALLPAREA(NIP,W1PM.1NHT.RTIM.RB1M.FIPRT.DIPRT)` |

Those three calls are in the Prog 5.1/5.2 common data section immediately after engine
geometry is read (26032–26100), i.e. once per run, not per time step.

Name collision to beware of: `PAREA` is *also* a scalar variable in other ProgLists —
21832–21843 (Prog 3.2 scavenging model), 29530–29531 and 29879 (reed-valve program, where it
means "required flow area"). Those are unrelated to the subroutine.

Name collision #2: `PAREA=` also appears at 21832 inside Prog 3.2 as a *variable*; do not
confuse the two when grepping.

### 2.2 Listing as printed

```
28130 \j SUB PAREA(NP,WP.HP,RT,RB.FP.DP)STATIC
28131 SHARED PI
28132 FP=NP*(WP*HP-(2-PI/2)*(RT*RT+RB*RB))
28133 DP=SQR(4*FP/PI)
28134 END SUB
```

Cleaned:

```basic
SUB PAREA (NP,WP,HP,RT,RB,FP,DP) STATIC
  SHARED PI
  FP=NP*(WP*HP-(2-PI/2)*(RT*RT+RB*RB))
  DP=SQR(4*FP/PI)
END SUB
```

Argument mapping (from the call sites): `NP` = number of identical ports, `WP` = effective
width of each port (m), `HP` = effective port height at full open (m), `RT`/`RB` = top/bottom
corner radii (m), `FP` = full-open area (m²), `DP` = equivalent flow diameter (m).

### 2.3 The equation it implements

`A_max = x_p(x_θ2 − x_θ1) − (2 − π/2)(r_t² + r_b²)`  — 1996 book **Eq. 5.2.6, lines
19038–19042** (rendered there as `Amax = xw(x62 − x91) − (2 − π/2)(rt² + rb²)`).
That is exactly line 28132 with `WP·HP` for `x_p(x_θ2 − x_θ1)`. `DP` is the diameter of an
equivalent circle, needed because the flow boundary equations take a throat area.

The 1990 book describes the required data (number of ports, effective width, top/bottom
corner radii) at **9540–9556**, and the instantaneous-area requirement at **9544–9546**, but
does not print Eq. 5.2.6 in the chapter text — only in the code.

### 2.4 What actually makes the area vary with crank angle

Not `PAREA`. The chain is:

1. `PISTPOS` (28124–28129, also 18704–18707, 29471–29474, label form 23866–23870) gives
   `HT` = distance from tdc.
2. `FPORT` (**27946–27950**) converts that to an area ratio:
   `FINST=(HTDC-HOT)/PHT` (clamped at 1), `AK=CC*FINST*FPRT/FPIP` — a **linear ramp in piston
   travel**, with `HOT` = port-open height, `PHT` = port height, `FPRT` = full-open area from
   `PAREA`, `FPIP` = pipe area, `CC` = discharge coefficient.
3. `PORT` (21200–21230 / 28034–28048) and `OUTFLOW`/`INFLOW` consume `AK`.

So the angle-resolved port area in PROG.5.1/5.2 is a **linearised** piston-travel ramp, not
the exact circular-segment integral of Eqs. 5.2.1–5.2.5. If the port has large corner radii
and you want the exact area, you must implement Eqs. 5.2.1–5.2.5 (1996 lines 18942–18972)
instead — that is the only place the crank-angle integration is written down.

---

## 3. STAB — FOUND, twice

### 3.1 Evidence

| Kind | Line | Text |
|---|---|---|
| definition (ProgList 2.0 block) | **21121–21131** | full 11-line body, `END SUB` 21131 |
| definition (ProgList 5.0 block) | **27951–27963** | full 10-line body, `END SUB` 27963 |
| call | 20492 | `CALL STAB(AE().BE().KE,SDE,LEM)` (Prog 2.1 "EXHAUST") |
| call | 20720 | `CALL STAB(AE(),BE(),KE.SDE,LEM)` (Prog 2.2 "INDUCTION") |
| calls | 26180–26184 | five calls at the top of the Prog 5.1 time loop (26183/26184 duplicate — see §4.3) |
| calls | 27001–27003 | Prog 5.2 equivalent |
| prose | 9868–9871 | "(c) In Subroutine STAB, where the minimum time step, dZ, is determined (see Sect. 2.4.1(d))" |

### 3.2 Listing as printed — ProgList 5.0 version (27951–27963)

```
27951 VSUB STAB(A(),B(),K,S,E)STATIC
27952 SHARED DZ.DTM.DC.RPM
27953 C=60*S/(RPM*F;)
27954 FOR J= 1 TO K
27955 Z=2/((A(J)+B(J))+ABS(5*(A(J)-B(J))))
27956 598                                   <- page number
27957 .                                     <- garbage
27958 Computer Program Appendix - ProgList 5.0   <- running head
27959 IF Z<DZ THEN DZ=Z
27960 NEXT J
27961 DC=360*DZ/C
27962 DTM=DC/(6*RPM)
27963 END SUB
```

Cleaned:

```basic
SUB STAB (A(),B(),K,S,E) STATIC
  SHARED DZ,DTM,DC,RPM
  C=60*S/(RPM*E)
  FOR J=1 TO K
    Z=2/((A(J)+B(J))+ABS(5*(A(J)-B(J))))
    IF Z<DZ THEN DZ=Z
  NEXT J
  DC=360*DZ/C
  DTM=DC/(6*RPM)
END SUB
```

ProgList 2.0 version (21121–21131) differs in only two respects: `SHARED DZ,DTM,DC,RPM`
(21122) and an explicit `DZ=1` initialiser (21124) before the `FOR` loop. The 5.0 version
omits `DZ=1` because the caller does it — **line 26178 `DZ=1`** immediately before the
`CALL STAB` block, and line 26999 for Prog 5.2. Preserve that if you refactor. (The damping
factor after the STAB block also differs: `DZ=.99*DZ` at 26185 for 5.1 versus `DZ=.9*DZ` at
27004 for 5.2.)

### 3.3 What it computes

`A(J)`, `B(J)` are Blair's pressure amplitude ratios α at the two ends of mesh J, so:

* `A+B` = sum of the two acoustic propagation speeds (non-dimensional),
* `5*|A−B|` = modulus of the particle velocity difference, because `u = 5a₀(α−1)`
  (1990 lines 3227 and 3276: `CG=5*Ao*(X-1)`),
* `Z = 2/((A+B)+|u_A−u_B|/a₀)` = time to cross one mesh divided by the reference time, i.e.
  the local Courant number. The loop takes the minimum over all meshes; `DZ` is that minimum,
  then damped by `DZ=.99*DZ` at 26185.

`C=60*S/(RPM*E)`: `S` = reference speed of sound for that duct (`SDE`, `SDT`, `SDI` from
`CYLSTART`, 27939–27941), `E` = mesh length (`LEM1`, `LTMESH`, `LIMESH`). So `C` is the
number of mesh traversals per revolution; `DC=360*DZ/C` is therefore the crank-angle increment
in degrees, and `DTM=DC/(6*RPM)` the same in seconds (since 360°/(6·RPM) = 60/RPM s/rev).
`DC` and `DTM` are `SHARED` and are the `DC`/`DTM` used by the whole time loop — **which is
why `DC` is never assigned in the Prog 5.1 body** (see §6.2).

Governing equation in the books: Courant–Friedrichs–Lewy stability criterion,
`dt = minimum over meshes of L/α`, 1996 **Eq. 2.18.7, lines 8763–8776** (text states the
criterion explicitly at 8775–8776); 1990 prose at **4387–4393** and **4407–4409** (Eq. 2.4.16).

---

## 4. OUTFLOW and INFLOW — BOTH FOUND, both 9 arguments

### 4.1 Evidence

| Kind | Line | Text |
|---|---|---|
| definition `OUTFLOW` | **28060** | `i/ SUB OUTFLOW(A.B.F,TR,H,C,M,D.CD)STATIC` |
| body | 28060–28075 | 16 statements, `END SUB` 28075 |
| definition `INFLOW` | **28077** | `SUB INFL0W(A.B.F,TR.H.C.M.D.CD)STAT1C` |
| body | 28077–28091 | 15 statements, `END SUB` 28091 |
| calls `OUTFLOW` | 26234–26235, 26238, 26241 | exhaust duct, exhaust port, transfer port (Prog 5.1) |
| | 27044, 27713, 27719, 27737, 27739, 27759, 27761, 27785 | Prog 5.2 + `PORTOPEN` blocks |
| call `INFLOW` | 27788 | `INFLOW) BI( 1).All I l.FIPRT.TIREF.` (inlet port open, continuation on 27789) |

Both take exactly the nine arguments the 5.1/5.2 code passes, so the guess in
`PROG51_DAMAGE.md` §7 ("`OUTFLOW` may be `INFLOW` renamed") is *half* right: they are two
separate routines with the same signature, and both are printed.

### 4.2 Listings as printed

```
28060 i/ SUB OUTFLOW(A.B.F,TR,H,C,M,D.CD)STATIC
28061 SHARED GK,GE,PA
28062 CP=481.17*TRM25
28063 GAM=1.7847/(TRA.(>417)
28064 AB=(A+B)/2
28065 TREF=TR/ABA2
28066 REM TR IS REGARDED AS THE SUPERPOSITION TEMPERATURE
28067 SD=SQR(GAM*GK*TREF)
28068 C=SD*(A-B)/(GAM-1)
28069 H=CP*TR
28070 D=ABA5*PA/(GK*TREF)
28071 M=CD*C*F*D
28072 M N=C/SQR( G A M*G K *TR I
28073 P1=(.5*(A+1))A7
28074 P2=(.5*(B+1))A7
28075 END SUB

28077 SUB INFL0W(A.B.F,TR.H.C.M.D.CD)STAT1C
28078 SHARED GK.GE.PA
28079 CP=481.17*TRM25
28080 GAM=1.7847/(TRA.()417)
28081 AB=(A+B)/2
28082 SD=SQR(GAM*GK*TR)
28083 C=2.5*SD*(A-B)
28084 T=TR*AB*AB
28085 H=CP*T
28086 D=ABA5*PA/(GK*TR)
28087 M=CD*C*F*D
28088 MN=C/SQR(GAM*GK*T)
28089 PR=(.5*(A+1))A7
28090 PL=(.5*(B+1))A7
28091 END SUB
```

Cleaned:

```basic
SUB OUTFLOW (A,B,F,TR,H,C,M,D,CD) STATIC
  SHARED GK,GE,PA
  CP=481.17*TR^0.25
  GAM=1.7847/(TR^0.0417)
  AB=(A+B)/2
  TREF=TR/AB^2
  REM TR IS REGARDED AS THE SUPERPOSITION TEMPERATURE
  SD=SQR(GAM*GK*TREF)
  C=SD*(A-B)/(GAM-1)
  H=CP*TR
  D=AB^5*PA/(GK*TREF)
  M=CD*C*F*D
  MN=C/SQR(GAM*GK*TR)
  P1=(0.5*(A+1))^7
  P2=(0.5*(B+1))^7
END SUB

SUB INFLOW (A,B,F,TR,H,C,M,D,CD) STATIC
  SHARED GK,GE,PA
  CP=481.17*TR^0.25
  GAM=1.7847/(TR^0.0417)
  AB=(A+B)/2
  SD=SQR(GAM*GK*TR)
  C=2.5*SD*(A-B)
  T=TR*AB^2
  H=CP*T
  D=AB^5*PA/(GK*TR)
  M=CD*C*F*D
  MN=C/SQR(GAM*GK*T)
  PR=(0.5*(A+1))^7
  PL=(0.5*(B+1))^7
END SUB
```

OCR reading notes: `ABA2`/`ABA5` are `AB^2`/`AB^5`; `(.5*(A+1))A7` is `^7`; `TRM25` is
`TR^0.25`; `TRA.()417` is `TR^0.0417`; `INFL0W` is `INFLOW` (zero for O); `STAT1C` is
`STATIC`. The exponents are physically consistent: for γ = 1.4, `p/p_ref = α^7` and
`ρ/ρ_ref = α^5`, and `ρ_ref = PA/(R·T_ref)` — so line 28070/28086 is exactly
`ρ = PA·α^5/(R·T_ref)`.

Argument mapping (identical for both): `A`,`B` = pressure amplitude ratios at the pipe end
adjacent to the boundary; `F` = throat area (m²); `TR` = superposition reference temperature
(K); outputs `H` = specific enthalpy (J/kg), `C` = particle velocity (m/s), `M` = mass flow
(kg/s), `D` = density (kg/m³); `CD` = discharge coefficient; `MN` = Mach number,
`P1`/`P2`/`PR`/`PL` = pressure ratios (computed but unused by the 5.1 caller).

Difference between the two, verbatim: `OUTFLOW` evaluates properties at `TREF = TR/AB²`
(flow out of the cylinder, i.e. cylinder-side reference), `INFLOW` at `TR` (pipe-side
reference), and `C` is written `SD*(A-B)/(γ-1)` vs `2.5*SD*(A-B)` — algebraically identical
for γ = 1.4, but check the sign/factor against **1996 Eqs. 2.16.8–2.16.11 (lines 7937–7940)**
and **2.17.7–2.17.9 (lines 8312–8426)** before trusting it: `OUTFLOW` is called with
`(BT,AT)` i.e. arguments swapped relative to `INFLOW`'s `(BI,AI)` usage, which is how the sign
is made consistent.

Gas-property fits used here (`CP=481.17·T^0.25`, `γ=1.7847/T^0.0417`) are the same as in
`BOX` (`CV=269.49·T^0.1667`, 28096/28109); they appear **only in code**, never as equations in
either book's text (confirmed by searching both files for `481.17`, `1.7847`, `269.49`).

---

## 5. The 1996 book: it contains no program listings at all

This is not a matter of the routines being moved — the 1996 book prints **no code**, anywhere.

| Marker | 1990 book | 1996 book |
|---|---|---|
| `END SUB` | 30 | **0** |
| `GOSUB` | 579 | **0** |
| `DIM ` | 26 | **0** |
| `LPRINT` | 349 | **0** |
| `REM ` | 341 | **0** |
| `STATIC` | 27 | 3 (all prose: 10712, 11994, 12650) |

The author states it explicitly in the Foreword:

> "The original book had the computer program listings at the back of it, occupying some 270
> pages. This book is already larger without them than the original book was with them!
> However, the computer programs have been extended in number and are available from SAE on
> diskette…" — **1996 lines 146–151**

and again in the appendix:

> "The Simulation Models and the set of computer Programs are available from SAE as executable
> files on diskettes for either IBM PC … or Macintosh …" — **1996 lines 30293–30296**

### 5.1 Is there a "Prog 5.1 / 5.2" in the 1996 book?

No. Searching the whole 1996 file for `Prog.?5`, `Program 5.`, `PROG 5` returns **nothing**.
The appendix lists Chapter 5's software only by description, unnumbered (1996 30269–30272):

```
Simulation Models associated with Chapter 5:
  Piston-ported, spark-ignition industrial engine
  Reed-valve, spark-ignition engine with expansion chamber exhaust
```

Chapter 5 itself is prose + result plots: 5.1 "Structure of a computer model" (18831), 5.2
"Physical geometry required for an engine model" (18904), 5.2.1 porting under piston control
(18915), 5.5 "The thermodynamic and gas-dynamic engine simulation" (19750), 5.5.1 chainsaw
(19770), 5.5.2 racing engine, 5.5.3 multi-cylinder. The only algorithmic statement about the
simulation is the six-item list of "key elements" at 18832–18892 — a specification, not
pseudo-code. There is **no flow chart, no pseudo-code and no listing** for the cylinder
calculation.

Note also that the 1996 closed-cycle model is **not** the same as the 1990 `CYLINDER`: 1996
uses a Vibe mass-fraction-burned function (Eq. 4.3.43, line 16476–16480; coefficients at
19793) whereas the 1990 code uses the triangular heat-release profile. A rewrite "per the
1996 book" would therefore not reproduce PROG.5.1.

### 5.2 What the 1996 book does give you (the equation set)

Everything needed to re-derive the four routines is present as theory:

| Topic | 1996 section | Lines |
|---|---|---|
| Time step / Courant criterion (→ `STAB`) | 2.18.2, Eq. 2.18.7 | 8750–8776 |
| Open-cycle cylinder & plenum thermodynamics (→ `BOX`) | 2.18.10, Eqs. 2.18.55–2.18.59 | 9567–9700 |
| Outflow boundary (→ `OUTFLOW`) | 2.16, Eqs. 2.16.8–2.16.13 | 7696–7990 |
| Inflow boundary (→ `INFLOW`) | 2.17, Eqs. 2.17.7–2.17.12 | 8197–8440 |
| Port area, exact (→ `PAREA` + `FPORT`) | 5.2.1, Eqs. 5.2.1–5.2.6 | 18915–19070 |
| Heat available | 1.5.7, Eq. 1.5.21 | 2799–2806 |
| Fuel vaporisation | 4.3.5, Eqs. 4.3.36–4.3.41 | 16394–16451 |
| Heat-release profile and total area | 4.3.6, Eq. 4.3.42 | 16452–16469 |
| Vibe mass-fraction-burned | 4.3.43 | 16470–16481 |
| Closed-cycle First Law solution | 4.4.2, Eqs. 4.4.1–4.4.4 | 16996–17094 |
| Gas purity through the closed cycle | 4.4.2, Eqs. 4.4.5–4.4.8 | 17095–17118 |

---

## 6. Why they appeared missing, and two corrections to `PROG51_DAMAGE.md`

### 6.1 The transcription stopped one section too early

`PROG51_DAMAGE.md` defines its source range as OCR lines **26032–26840**. The shared
subroutines for both 5.1 and 5.2 begin after that range at **27566** ("ENGINE MODEL NO.1 and
ENGINE MODEL NO.2" common section), and the numeric library continues **27951–28192**. The
report's own §7 table correctly lists `CYLSTART` as ending at 27949 — and stops there. The 43
lines that follow are exactly the four routines in question. Nothing was ever missing from the
book; the extraction window closed first.

### 6.2 Correction: `DC` *is* assigned

`PROG51_DAMAGE.md` §8.1 says "`DC` is never assigned … the main loop cannot advance". It is
assigned inside `STAB` (`DC=360*DZ/C`, line 27961), declared `SHARED` there (27952), and the
call at 26180 precedes the first use at 26186. Likewise `DTM` (27962) is the time step used by
every `BOX`/`OUTFLOW` call. So the loop runs; only `DZ=1` needs to be present at 26178.

### 6.3 Correction: routine inventory

`PROG51_DAMAGE.md` §7 "Not printed anywhere in the book" and §9 caveat 2 should read:
`SHOK` (21185/28019), `NINT` (21219/28049), `PORT` (21200/28034), `SETS` (21132/27964),
`AREA` (21138/27970), `PIPE` (21149/27981), `BOX` (21243/28093), `BELMOUTH` (21259/28119),
`PISTPOS` (18704, 28124, 29471), **`STAB` (21121, 27951)**, **`OUTFLOW` (28060)**,
**`INFLOW` (28077)**, **`PAREA` (28130)**, **`CYLINDER` (28136)** — i.e. every routine
PROG.5.1 calls is printed in the book.

There is no routine in PROG.5.1/5.2 whose body is absent.

---

## 7. Recoverable vs. must-be-rewritten, and the size of the job

**All four are recoverable verbatim.** Nothing in this group has to be re-derived from
equations.

| Routine | Status | Transcription effort | Residual risk |
|---|---|---|---|
| `CYLINDER` | printed, 28136–28192 | 55 statements; ~12 mechanical OCR repairs; add `HT1`/`DPMAX` to `SHARED` | low — logic unambiguous; two identifier dropouts in the book itself |
| `PAREA` | printed, 28130–28134 | 3 statements, zero repairs except `PI` | none |
| `STAB` | printed twice, 21121–21131 / 27951–27963 | 6 statements; one repair (`F;)`→`E)`) | none — two independent printings agree |
| `OUTFLOW` | printed, 28060–28075 | 12 statements; exponents/damaged tokens only | low — sign convention needs one live check (§4.2) |
| `INFLOW` | printed, 28077–28091 | 12 statements; same class of repairs | low |

**Size of the transcription:** ≈101 lines of BASIC (≈90 executable statements) out of the
673 already transcribed, i.e. the PROG.5.1 effort grows by about **15 %** and the whole
5.1+5.2 pair by about 8 %. Expect ~20 OCR repairs, all in the `A7`→`^7`, `O`→`0`/`C`,
`.`→`,` classes already catalogued in `PROG51_DAMAGE.md` §3.

**If you nevertheless chose to rewrite from equations instead of transcribing**, the estimate
would be: `STAB` ~8 lines, `PAREA` ~5, `OUTFLOW` ~15, `INFLOW` ~15, `CYLINDER` ~70 (you would
have to add the closed-cycle heat transfer and purity book-keeping that the printed version
leaves in `BOX`/the caller) → **≈115 lines of new MATLAB**, plus the risk of not matching
Blair's numerics. Transcribing is both cheaper and safer.

**Not recoverable from either book (unchanged):** the `.BOX`/`UFLO` data files and the
`0513.BAS`-style line-numbered outer shells differ between the two books; the 1996 book's
diskette programs are a different, extended codebase and cannot be mixed with the 1990
listing without re-validating every shared block (`PIPE`, `PORT`, `SHOK`, `BOX`).

---

## 8. One-line answer

`CYLINDER`, `PAREA`, `STAB` and `OUTFLOW` (and `INFLOW`) are **all printed verbatim in the
1990 book on lines 27951–28192** (ProgList 5.0 shared-subroutine block, book pp. ≈598–603);
the 1996 book prints **no code whatsoever** and only supplies the governing equations
(Sects. 2.16–2.18, 4.3–4.4, 5.2.1). Recover all four by transcription — ≈101 lines plus ~20
OCR repairs — not by rewriting. The only routine the brief mis-describes is `PAREA`, which is
the full-open area + equivalent diameter (Eq. 5.2.6), the crank-angle variation coming from
`FPORT`'s linear piston-travel ramp.
