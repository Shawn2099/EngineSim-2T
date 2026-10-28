# PORT_DIFF.md — MATLAB port vs `port/blair_clean.bas`, statement by statement

Scope: the nine routines named in the task, in descending order of importance
(`sub_cylinder`, `sub_box`, `sub_port`, `sub_flow`/`_out`/`_in`, `sub_parea`+`fport`,
`sub_stab`, `sub_pipe`, `sub_nint`, `sub_pistpos`), plus a call-site audit of the
statements in the main loop (287–347) that feed them, because that is where
1-based/argument-order errors would show up.

Method: every executable BASIC statement in each `SUB`/`END SUB` range was paired
with its MATLAB counterpart and checked for operator, sign, index base, operand
order and statement order. Numeric literals were also extracted from both sides
and compared as multisets, to catch a silently retyped constant: **none differ**.

All line numbers below are the **real** line numbers of `blair_clean.bas` as it
stands. (The header and body comments in the port quote numbers ~100 too low —
see §7.1.)

The port was **not** modified. Where a number was needed, a scratch copy under
`%TEMP%\opencode\blair_scratch` was edited and run.

---

## 1. Counts

| class | count | definition |
|---|---:|---|
| **ERR** | **5** | the MATLAB computes something different from `blair_clean.bas` |
| **RISK** | **11** | defensible, but can differ (guards, loop-that-may-not-run, state carried between calls) |
| **OK** | **145** | one-to-one |

Of the 5 ERRs, 3 are distinct expressions (one is duplicated in OUTFLOW and
INFLOW). All 5 are **documented "book-page repairs"**, not slips: the port
deliberately departs from the delivered `.bas` text on the grounds that the
transcription is damaged. They are still ERR against the source being diffed,
and they are the only places where the two disagree on arithmetic. **No ERR was
found in CYLINDER's control flow, BOX's order of operations, PORT's index
arithmetic, or the NINT/KE/KT mesh arithmetic.**

Baseline reproduction of the port's own documented result (run, not read):

```
power=13.8261 kW  bmep=6.9615  imep=7.5797  pmep=0.4082  bsfc=424.90
DR=0.88647 SE=0.88775 TE=0.54395 CE=0.48173 sr=0.91944 srv=1.42254 efr=0.92120
pmax=38.9040 tmax=3070.61 angle=16.376   mean|model/Blair-1| = 8.71 %
```

so the file on disk is the file `PORT_NOTES.md`/`QUB400_VALIDATION.md` describe.

---

## 2. ERR table (ranked by how much it could change power)

Ranking is **measured**, not guessed: each repair was reverted to the `.bas`
text, one at a time, in the scratch copy, and the case A run repeated.

| # | BASIC | MATLAB | statement (BASIC → MATLAB) | power if translated literally | rank |
|---|---|---|---|---:|---:|
| E1 | 1342, 1363 | `sub_flow.m` 127, 146 | `GAM=1.7847/(TR^.417)` → `GAM = 1.7847/(TR^.0417)` | **run aborts** (flows reverse; `PORT: BX1=1.42076 falls in the untabulated band`) | 1 |
| E2 | 1556 | `sub_cylinder.m` 126 | `HEAT=BEFF*CVAL*MAIR^TAFB` → `HEAT = m.BEFF*m.CVAL*MAIR/TAFB` | **−1.722 kW** (vs +13.826): no combustion, pmax 13.8 bar, tmax 483 K | 2 |
| E3 | 1341, 1362 | `sub_flow.m` 126, 145 | `CP=481.17*TR^.25` → `CP = 481.17*TR^.125` | 13.518 kW (−2.2 %) but DR 0.553 (−38 %), srv 0.849 (−40 %), tmax 2418 K | 3 |

Notes on the ranking:

* **E1 (GAM)** dominates everything. `GAM=1.7847/T^.417` gives 0.164 at 300 K, so
  `GAM-1` is **negative**; `C=SD*(A-B)/(GAM-1)` and `M=CD*C*F*D` (BASIC 1347,
  1350; ML 131, 134) both change sign. Every duct then flows backwards: the
  crankcase is filled from the transfer duct, the inlet duct expels. The run does
  not merely mis-predict — it leaves the UFLO table in the first scavenging step
  and stops. Power impact: total loss of a valid result.
* **E2 (HEAT)** is the second-largest. `MAIR` is ~2.3e-4 kg and `TAFB` = 13, so
  `MAIR^TAFB` ≈ 1e-48 J: `QMAX`=~0, `S1..S3`=~0, `QHT`=~0 and the "combustion"
  cycle is a pure polytropic compression. Measured power goes **negative**
  (−1.72 kW, BMEP −0.87 bar): the engine becomes a pump.
* **E3 (CP)** is large in every *other* channel but surprisingly small in power
  (13.52 vs 13.83 kW). `CP` only enters `H=CP*TR`, and in BOX's energy balance
  `EIN−EO` partially cancels, so a 2× `cp` moves the temperature and the duct
  state (DR −38 %) far more than the work integral. This is why a
  "CP-only" bug would be caught by DR/SE/srv and *not* by power.

Caveat: these three are corrections of transcription damage, and the port's
justification (renderings of book pp.310/603) may well be right — I cannot
adjudicate the book page from here. Against **the file being diffed** they
compute something different, which is what an ERR table means. They are *not*
the cause of the 8.7 % (see §6).

---

## 3. RISK table

| # | BASIC | MATLAB | what could differ |
|---|---|---|---|
| R1 | 1405 `I=INT(AK/.05)+1` | `sub_port.m` 87–92 | Added hard error when `I<1` or `I+1>21`. `DIM ABX(21,45)` legally owns index 0, so BASIC **reads `ABX(0,·)`** (zero) and carries on for a negative `AK`; the port stops. Reachable only if a caller passes `HTDC<HOT` (see R11). |
| R2 | 1406 `J=INT((BX1-.6)/.02)+1` | `sub_port.m` 93–100 | Added hard error when `J+1>45` (`BX1>1.48`). QBasic does not bounds-check by default: BASIC reads past the array (adjacent memory, undefined), the port aborts. Deliberate ("what is undefined is stopped"), but it is a behavioural difference, not a no-op. |
| R3 | 1410 `RB=(BX1-BX(J))/(BX(J+1)-BX(J))` | `sub_port.m` 101–108 | Added hard error for the `BX1∈[1.42,1.48)` band where `BX(J)=BX(J+1)=0`. QBasic raises "Division by zero" here too, so the abort is *faithful* — but Blair's run could in principle be restarted, this one cannot. |
| R4 | 1431 `K1=KI+1` | `sub_nint.m` 61–67 | Added `K1>20` error. BASIC indexes `AE(21)` past `DIM AE(20)` silently. |
| R5 | 1428–1431 | `sub_nint.m` 68–74 | Added `K1<2` error. BASIC divides by `KE1-1=0` at 210–213 (QBasic "Division by zero"). Faithful in effect, different in mechanism. |
| R6 | 1293–1298 | `sub_stab.m` 54–59 | `FOR J=1 TO K` with `K=0` never runs, so `DC=360*DZ/C` and `DTM=DC/(6*RPM)` use the **running** `DZ` (from the caller / the previous duct). Identical to BASIC, but nothing inside STAB initialises `DZ`: if the `DZ=1` at 258 were ever dropped, all five calls would inherit last step's `DZ`. Reproduced on purpose ([D1]). |
| R7 | 1238 `SHARED DZ,A2(),B2()` | `sub_pipe.m` 55–56 | `A2/B2` are function-local instead of SHARED — the only SHARED declaration in the file not reproduced. Verified benign: loop 1 writes exactly `A2(KA+1..KB)` and `B2(KA..KC)`, loop 2 reads exactly those. It would stop being benign if `KC<KA` (then loop 2 copies zeros over `A(KA+1)`/`B(KA)`) — unreachable while `KO=1`, `KB≥2`. |
| R8 | 1398–1401 | `sub_box.m` 90–93 | `PB1 TB1 MB1 VB1` are *outputs* that each call site must write back. At the crankcase call this is the only source of `VCC1` for the next step; if a future call site drops `VB1`, `DW`/`WORK`/PMEP silently use a frozen volume for the whole run. All three current sites assign it. |
| R9 | 1561–1571 (STATIC block) | `sub_cylinder.m` 76–81, 188–194 | All 16 persistent names live in `m.cyl`, seeded once by `BLAIR_INIT` (418–411). A `blair_step` on a hand-built struct (no `m.cyl`) would run with `HT1=[]` and give the rectangle-rule heat release that [FIX4] exists to prevent. Correct for the documented entry point only. |
| R10 | 523–528 | `blair_step.m` 417–430 | `SEFFP/TEFFP/CEFFP/SRMP/SRVP/EXRP` are stored at `JJ+1`, not `JJ`. Physics-neutral (the same values, one slot along) and intentional, but any consumer that indexes Blair's printed rows is one cycle out, and it is the reason `blair_run` can report SE/TE/CE from the same `n` as DR. |
| R11 | 1278–1280 | `sub_parea.m` 87–91 + `fport.m` | No lower clamp on `FINST`, as printed: `HTDC<HOT` ⇒ `AK<0`. BASIC survives it (index 0 of a `DIM(21,·)` array is legal); the port then rejects it in PORT (R1). The inlet call's deliberately swapped argument order (1139, `FPORT(HTDC,HIOT,…)`) is what normally keeps `FINST≥0`; "normalising" that call to `(HIOT,HTDC,…)` would make it negative. |

---

## 4. OK tables, routine by routine

Legend: `✓` = one-to-one (same operator, same operand order, same index base).

### 4.1 `SUB CYLINDER` (1540–1600) → `sub_cylinder.m` — 47 OK, 1 ERR

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1543 | `DEGC=DEG` | 84 | ✓ |
| 1540 arg | `P1..V2` ↔ `PC1..VC2`, `MC` ↔ `MC2` | 85–88 | ✓ (MC2, not MC1, as printed) |
| 1544 | `IF DEGC<=360 THEN POLYINDEX=NC` | 91–93 | ✓ |
| 1545 | `IF DEGC>360 THEN POLYINDEX=NE` | 94–96 | ✓ two separate IFs kept, so `DEGC=360` takes NC |
| 1546 | `IF DEGC>EPC+5 THEN GOTO 30` | 99 | ✓ |
| 1547 | `MAIR=SEFF*MC` | 101 | ✓ |
| 1548 | `CEFF=MAIR/MREF` | 102 | ✓ |
| 1549 | `TEFF=MAIR/(DRAT*MREF)` | 103 | ✓ |
| 1550 | `IGN=360-BDEG/6` | 104 | ✓ |
| 1551 | `BURNEND=IGN+BDEG` | 105 | ✓ |
| 1552 | `TAILDEG=BURNEND-BDEG/3` | 106 | ✓ |
| 1553 | `PEAK=IGN+BDEG/3` | 107 | ✓ |
| 1554 | `TAFB=13` | 108 | ✓ |
| 1555 | `IF TAF>TAFB THEN TAFB=TAF` | 109–111 | ✓ |
| **1556** | **`HEAT=BEFF*CVAL*MAIR^TAFB`** | **126** | **ERR E2** |
| 1557 | `QMAX=36*HEAT/(14*BDEG)` | 127 | ✓ |
| 1558 | `S1=3*QMAX/BDEG` | 128 | ✓ |
| 1559 | `S2=5*QMAX/(2*BDEG)` | 129 | ✓ |
| 1560 | `S3=QMAX/(2*BDEG)` | 130 | ✓ |
| 1561 | `30 IF DEGC<=IGN THEN GOTO 90` | 135 | ✓ merged with 1562 into `\|\|`, same truth table |
| 1562 | `IF DEGC>=BURNEND THEN GOTO 90` | 135 | ✓ |
| 1567 | `IF DEGC<IGN THEN GOTO C20` | — | ✓ dead under every reading ([D25]); correctly omitted |
| 1568 | `IF DEGC<=BURNEND THEN GOTO C20` | 141 (`else`) | ✓ |
| 1569 | `90 P2=P1*(V1/V2)^POLYINDEX` | 138 | ✓ |
| 1570 | `T2=P2*V2/(MC*GK)` | 139 | ✓ |
| 1571 | `GOTO C50` | 160 | ✓ |
| 1572 | `C20: IF DEGC>PEAK THEN GOTO 60` | 143 | ✓ |
| 1573 | `HT2=S1*(DEGC-IGN)` | 150 | ✓ |
| 1574 | `GOTO 80` | 152 | ✓ |
| 1575 | `60 IF DEGC<=TAILDEG THEN GOTO 70` | 144 | ✓ |
| 1576 | `HT2=(BURNEND-DEGC)*S3` | 147 | ✓ |
| 1578 | `70 HT2=(TAILDEG-DEGC)*S2` | 145 | ✓ |
| 1579 | `80 QHT=DC*(HT1+HT2)/2` | 153 | ✓ trapezoid, `HT1` = previous call's `HT2` |
| 1580 | `VR=V1/V2` | 154 | ✓ |
| 1581 | `VRN=VR^POLYINDEX` | 155 | ✓ |
| 1586 | `TRM1=(GE+1)*V2/(2*(GE-1))-VR` | 156 | ✓ dead store kept, as printed ([D26]) |
| 1587 | `TRM1=V2/(GE-1)` | 157 | ✓ |
| 1588 | `P2=(QHT/TRM1)+P1*VRN` | 158 | ✓ |
| 1589 | `T2=P2*V2/(MC*GK)` | 159 | ✓ |
| 1590 | `C50: WORK=(P1+P2)*(V2-V1)/2` | 163 | ✓ computed from **pre-roll** P1,V1 |
| 1591 | `IF P2>P1 THEN DELTAP=(P2-P1)/(100000!*DC)` | 164–165 | ✓ |
| 1592 | `IF P2>P1 THEN PMAX=P2/100000!` | 166 | ✓ |
| 1593 | `IF P2>P1 THEN MAXDEG=DEGC-360` | 167 | ✓ three 1591-1593 IFs merged into one `if P2>P1` — same result, no side effects in the guard |
| 1594 | `IF T2>T1 THEN TKMAX=T2` | 169–171 | ✓ |
| 1595 | `IF DELTAP>DPMAX THEN DPMAX=DELTAP` | 172–174 | ✓ `DELTAP` deliberately not reset (STATIC) |
| 1596 | `P1=P2` | 175, 184 | ✓ |
| 1597 | `T1=T2` | 176, 185 | ✓ |
| 1598 | `V1=V2` | 177, 186 | ✓ |
| 1599 | `HT1=HT2` | 178 | ✓ executed on **both** paths, so a polytropic step re-latches `HT2` |

Order check: `WORK` (163) precedes the peak bookkeeping (164–174) and the roll
(175–178), exactly as 1590 < 1591 < … < 1596. No reordering.

### 4.2 `SUB BOX` (1484–1502, 15-argument version) → `sub_box.m` — 16 OK

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1486 | `CV1=269.49*TB1^0.1667` | 77 | ✓ hard-coded `cv(T)`, **not** `CCV` (declared SHARED at 1485 but unused, as printed) |
| 1487 | `DMI=MIN*DTM` | 78 | ✓ no `ABS()` — the sign convention BOX's mass balance needs |
| 1488 | `DME=MO*DTM` | 79 | ✓ |
| 1489 | `MB2=MB1+DMI-DME` | 80 | ✓ |
| 1490 | `EIN=DMI*(HIN+.5*CIN*CIN)` | 81 | ✓ |
| 1491 | `EO=DME*(HO+.5*CO*CO)` | 82 | ✓ |
| 1492 | `DW=PB1*(VB2-VB1)` | 83 | ✓ |
| 1493 | `TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV1*MB2)` | 84 | ✓ first pass, `CV1` |
| 1494 | `CV2=269.49*TB2^0.1667` | 85 | ✓ |
| 1495 | `TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV2*MB2)` | 86 | ✓ second pass **re-uses `CV1` in the numerator and `CV2` only in the denominator** — the easy thing to "tidy", and it was not tidied |
| 1496 | `PB2=MB2*GK*TB2/VB2` | 87 | ✓ `GK`, not `GR` |
| 1497 | `WORK=(PB1+PB2)*(VB2-VB1)/2` | 88 | ✓ uses the **new** `PB2` |
| 1498 | `PB1=PB2` | 90 | ✓ |
| 1499 | `TB1=TB2` | 91 | ✓ |
| 1500 | `MB1=MB2` | 92 | ✓ |
| 1501 | `VB1=VB2` | 93 | ✓ returned as an output (BASIC by-reference write) |

Argument mapping at the three call sites is exact (14 in / 1 out), see §5.

### 4.3 `SUB PORT` (1399–1413) → `sub_port.m` — 12 OK

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1401 | `X1=(P/PA)^(1/7)` | 76 | ✓ |
| 1402 | `BX1=B/X1` | 77 | ✓ |
| 1403 | `IF AK>.95 THEN AK=.95` | 78–80 | ✓ clamp **before** `I` is formed, and `AK` is returned so the clamp reaches the caller |
| 1404 | `IF BX1<.6 THEN BX1=.6` | 81–83 | ✓ |
| 1405 | `I=INT(AK/.05)+1` | 84 | ✓ `INT`=floor, 1-based, no array shift |
| 1406 | `J=INT((BX1-.6)/.02)+1` | 85 | ✓ |
| 1407 | `RA=(AK-AKA(I))/(AKA(I+1)-AKA(I))` | 110 | ✓ `AKA(I)=(I-1)*.05` matches the table build at 125–128 |
| 1408 | `AB1=RA*(ABX(I+1,J+1)-ABX(I,J+1))+ABX(I,J+1)` | 111 | ✓ column `J+1` (= "upper" BX1) |
| 1409 | `AB2=RA*(ABX(I+1,J)-ABX(I,J))+ABX(I,J)` | 112 | ✓ column `J` |
| 1410 | `RB=(BX1-BX(J))/(BX(J+1)-BX(J))` | 113 | ✓ |
| 1411 | `ABX1=RB*(AB1-AB2)+AB2` | 114 | ✓ interpolation order (AB1 = high end) preserved |
| 1412 | `A=2*X1*ABX1-B` | 115 | ✓ |

`ABX` is zero-padded to 45 columns in `blair_init` (120–121) so that `J+1=42..45`
returns 0 exactly as QBasic's `DIM ABX(21,45)` does. Index arithmetic therefore
agrees with Blair for every reachable table position.

### 4.4 `SUB OUTFLOW` (1439–1454) → `sub_flow.m::local_outflow` — 10 OK, 2 ERR

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| **1341** | **`CP=481.17*TR^.25`** | **126** | **ERR E3** |
| **1342** | **`GAM=1.7847/(TR^.417)`** | **127** | **ERR E1** |
| 1343 | `AB=(A+B)/2` | 128 | ✓ |
| 1344 | `TREF=TR/AB^2` | 129 | ✓ superposition temperature |
| 1346 | `SD=SQR(GAM*GK*TREF)` | 130 | ✓ `sqrt` |
| 1347 | `C=SD*(A-B)/(GAM-1)` | 131 | ✓ sign convention preserved |
| 1348 | `H=CP*TR` | 132 | ✓ (not `CP*TREF`) |
| 1349 | `D=AB^.5*PA/(GK*TREF)` | 133 | ✓ |
| 1350 | `M=CD*C*F*D` | 134 | ✓ `CD·C·F·D`, order irrelevant, sign load-bearing |
| 1351 | `MN=C/SQR(GAM*GK*TR)` | 135 | ✓ dead store, kept |
| 1352 | `P1=(.5*(A+1))^7` | 136 | ✓ dead store, kept |
| 1353 | `P2=(.5*(B+1))^7` | 137 | ✓ dead store, kept |

Wrapper `sub_flow_out.m` 17 → `sub_flow('OUTFLOW', …)`: pure dispatch, ✓.

### 4.5 `SUB INFLOW` (1460–1474) → `sub_flow.m::local_inflow` — 10 OK, 2 ERR

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| **1362** | **`CP=481.17*TR^.25`** | **145** | **ERR E3** |
| **1363** | **`GAM=1.7847/(TR^.417)`** | **146** | **ERR E1** |
| 1364 | `AB=(A+B)/2` | 147 | ✓ |
| 1365 | `SD=SQR(GAM*GK*TR)` | 148 | ✓ `TR`, **not** `TREF` — the three real differences from OUTFLOW are all present |
| 1366 | `C=2.5*SD*(A-B)` | 149 | ✓ |
| 1367 | `T=TR*AB*AB` | 150 | ✓ |
| 1368 | `H=CP*T` | 151 | ✓ |
| 1369 | `D=AB^.5*PA/(GK*TR)` | 152 | ✓ |
| 1370 | `M=CD*C*F*D` | 153 | ✓ |
| 1371 | `MN=C/SQR(GAM*GK*T)` | 154 | ✓ dead store |
| 1372 | `PR=(.5*(A+1))^7` | 155 | ✓ dead store |
| 1373 | `PL=(.5*(B+1))^7` | 156 | ✓ dead store |

Wrapper `sub_flow_in.m` 21 ✓.

### 4.6 `SUB PAREA` (1522–1526) and `SUB FPORT` (1277–1281) → `sub_parea.m` — 5 OK

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1524 | `FP=NP*(WP*HP-(2-PI/2)*(RT*RT+RB*RB))` | 79 | ✓ `m.PI` = 3.141593, not `pi` |
| 1525 | `DP=SQR(4*FP/PI)` | 80 | ✓ |
| 1278 | `FINST=(HTDC-HOT)/PHT` | 87 | ✓ argument order `(HOT,HTDC)` kept |
| 1279 | `IF FINST>1 THEN FINST=1` | 88–90 | ✓ |
| 1280 | `AK=CC*FINST*FPRT/FPIP` | 91 | ✓ `FPRT/FPIP`, and the 1139 call passes `FIPRT` twice so the ratio is 1 ([D14]) |

### 4.7 `SUB STAB` (1290–1299) → `sub_stab.m` — 6 OK

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1292 | `C=60*S/(RPM*E)` | 53 | ✓ |
| 1293 | `FOR J=1 TO K` | 54 | ✓ (see R6 for `K=0`) |
| 1294 | `Z=2/((A(J)+B(J))+ABS(5*(A(J)-B(J))))` | 55 | ✓ the `5*` and the `ABS` are inside the denominator |
| 1295 | `IF Z<DZ THEN DZ=Z` | 56–58 | ✓ never raises `DZ` |
| 1297 | `DC=360*DZ/C` | 60 | ✓ global `DZ`, **this** call's `C` — the contract [D1] protects |
| 1298 | `DTM=DC/(6*RPM)` | 61 | ✓ |

### 4.8 `SUB PIPE` (1337–1370) → `sub_pipe.m` — 30 OK

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1339–1341 | `G1=3` `G2=2` `KC=KB-1` | 50–52 | ✓ |
| 1342 | `FOR J=KA TO KC` | 58 | ✓ `KC=KB-1`, so `A(J+1)` tops out at `A(KB)` |
| 1343 | `AA=DZ*A(J+1)*B(J)` | 59 | ✓ `J+1` on the **A** side only |
| 1344 | `BB=DZ*A(J)*B(J+1)` | 60 | ✓ `J+1` on the **B** side only |
| 1345 | `Y=(1+DZ*(G1*(A(J+1)-A(J))-G2*(B(J+1)-B(J))))` | 61 | ✓ |
| 1346 | `Z=(1+DZ*(G1*(B(J)-B(J+1))-G2*(A(J)-A(J+1))))` | 62 | ✓ the two differences are reversed **and** `A`/`B` swapped w.r.t. Y — preserved |
| 1347 | `WA=(A(J+1)+G2*AA-G2*BB)/Y` | 63 | ✓ |
| 1348 | `RA=(A(J)-G1*BB+G1*AA)/Z` | 64 | ✓ |
| 1349 | `WB=(B(J+1)+G1*AA-G1*BB)/Y` | 65 | ✓ |
| 1350 | `RB=(B(J)+G2*AA-G2*BB)/Z` | 66 | ✓ |
| 1351–1354 | `AA=WA-WB` `BB=RA-RB` `CC=WA+WB` `DD=RA+RB` | 67–70 | ✓ the same names are **re-used** for different quantities — preserved exactly |
| 1355 | `IF AA=0 THEN GOTO 23` | 71 | ✓ |
| 1356 | `QA=-DZ*CC*AA*DF(J)/(4*F(J))` | 74 | ✓ `4*F(J)`, not `4*DF(J)` |
| 1357 | `GOTO 33` | 75 | ✓ |
| 1358 | `23 QA=0` | 72 | ✓ |
| 1359 | `33 IF BB=0 THEN GOTO 44` | 76 | ✓ |
| 1360 | `QB=-DZ*BB*DD*DF(J)/(4*F(J))` | 79 | ✓ |
| 1361 | `GOTO 55` | 80 | ✓ |
| 1362 | `44 QB=0` | 77 | ✓ |
| 1363 | `55 A2(J+1)=WA+QA` | 81 | ✓ |
| 1364 | `B2(J)=RB+QB` | 82 | ✓ **not** `B2(J+1)` |
| 1365 | `NEXT J` | 83 | ✓ |
| 1366–1369 | second loop `A(J+1)=A2(J+1)`; `B(J)=B2(J)` | 85–88 | ✓ two-pass write-back preserved (in-place update would change every result) |

`A2/B2` locality: see R7.

### 4.9 `SUB NINT` (1424–1432) → `sub_nint.m` — 6 OK

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1426 | `A=SQR(TE/TP)` | 52 | ✓ |
| 1427 | `RI=PL*A/LMESH` | 53 | ✓ `PL` in **mm** against `LMESH=30` mm; no unit slip |
| 1428 | `KI=INT(RI)` | 54 | ✓ `floor`, not `round` |
| 1429 | `BI=RI-KI` | 55 | ✓ |
| 1430 | `IF BI>.5 THEN KI=KI+1` | 56–58 | ✓ round-half-**up**, `>`, not `>=` |
| 1431 | `K1=KI+1` | 59 | ✓ the 1-based mesh count is `KI+1`; `KI` stays a function local, so `CALL NINT(KI,…)` at 209 cannot alias and double-increment ([D7]) |

`blair_init` 328–336 passes `LEP1/LEP2/LTP/LIP` (mm) and divides by
`KE1-1/KE2-1/KI-1/KT-1` for the mesh lengths — the `K1=KI+1` contract is honoured
end to end (verified numerically: `KE1=KE2=8, KT=5, KI=11`).

### 4.10 `SUB PISTPOS` (1510–1515) → `sub_pistpos.m` — 3 OK

| BASIC | statement | MATLAB | class |
|---|---|---|---|
| 1512 | `A=D*DTOR` | 37 | ✓ degrees→radians done here, once |
| 1513 | `HT=R+C-R*COS(A)-SQR(C*C-(R*SIN(A))^2)` | 38 | ✓ sign of the `sqrt` term, `C*C` not `C^2`-clamped, no `abs` |
| 1514 | `HB=S-HT` | 39 | ✓ |

---

## 5. Call-site audit (main loop 287–347 → `blair_step.m`)

Argument order is where a port silently breaks; every one of these was checked
against the BASIC call, not against the routine's own docstring.

| BASIC | MATLAB | class |
|---|---|---|
| 287–290 `PIPE(KO,KE1/KE2/KT/KI, A,B, DF,F)` | 115–118 | ✓ all four, same array pairing (`DFE/FE`, `DFET/FET`, `DFT/FT`, `DFI/FI`) |
| 291–294 `PORT(BE(KE1),AE(KE1),PB1,AK)` | 142–143 (B=`AE`, out→`BE`) | ✓ |
| 295–297 `PORT(AET(1),BET(1),PB1,AK)` | 152–153 (B=`BET`, out→`AET`) | ✓ |
| 298–300 `PORT(BET(KE2),AET(KE2),PA,AK)` | 162–163 (B=`AET`, out→`BET`) | ✓ |
| 301–302 `PORT(BI(KI),AI(KI),PA,AK)`, `AK=THAR` | 167–169 | ✓ |
| 303–305 `PORT(BT(KT),AT(KT),PCC1,AK)` | 178–179 (B=`AT`, out→`BT`) | ✓ |
| 313–318 `PEX PIR PTR PTRO PEXP PEXT` | 198–203 | ✓ same six expressions; [FIX3] relocation is in both files |
| 319–324 dispatch `<=` vs `>` | 213–230 | ✓ including the missing `HTDC=HIOT` inlet case (neither branch runs) |
| 325–334 `SHOK` ×5 incl. the duplicate | 245–249 | ✓ duplicate kept |
| 335–337 `OUTFLOW(BT(KT),AT(KT),FTDUCT,TCC1,…)` | 262–263 | ✓ |
| 338–340 `OUTFLOW(AE(KE1),BE(KE1),FEP1,TC1,…)` | 272–273 | ✓ |
| 341–343 `OUTFLOW(AET(1),BET(1),FEP2,TB1,…)` | 282–283 | ✓ |
| 344 `BOX(PB1,PB2,TB1,TB2,VBOXM,VBOXM,MB1,MB2,MEK1,MET1,CEK1,CET1,HEK1,HET1,BOXW)` | 291–293 | ✓ 14 in, `VB1=VB2=VBOXM` so `DW=0` |
| 345 `BOX(PCC1,PCC2,TCC1,TCC2,VCC1,VCC2,MCC1,MCC2,MI1,MTKT,CI1,CTKT,HI1,HTKT,CCWORK)` | 299–301 | ✓ `MIN=MI1`, `MO=MTKT` — i.e. inlet in, transfer out |
| 346 `CYLINDER(PC1,PC2,TC1,TC2,VC1,VC2,MC2,CYWORK)` | 306–307 | ✓ `MC2`, and the call is gated on `HTDC<=HEOT` |
| 347 `BOX(PC1,PC2,TC1,TC2,VC1,VC2,MC1,MC2,MT1,ME1,CT1,CE1,HT1,HE1,CYWORK)` | 309–311 | ✓ `HT1` here is the **main module's** transfer enthalpy, not CYLINDER's static |
| 348–351 MEP integrals incl. `DEG<180` skip on cycle 1 | 326–332 | ✓ |

All eight `PORT` call sites write the returned `AK` back (`m.AK`, `m.AKE`,
`m.AKT`, `m.AKI`). That matters: PORT clamps `AK` to .95 by reference, and the
same `AK` is reused by the next three calls. Every site does it correctly.

---

## 6. The 8.7 % is **not** one of the ERRs

`blair_validate.m` 61–62 prints `mean |model/Blair − 1|` over 16 rows; that is
the 8.7 % (measured 8.71 %). Decomposition of that metric:

| channel | deviation | note |
|---|---:|---|
| `srv` volume scavenge ratio | **+25.44 %** | 1.6 of the 8.7 points on its own |
| power / bmep / imep | +13.3 / +13.4 / +12.8 % | all ≈ +CE |
| CE charging efficiency | +12.03 % | = SEFF·MC/MREF |
| SE scavenging efficiency | +8.53 pp | `1−EXP(MSC·SR+CSC)` |
| pmax / tmax | +8.67 / +6.21 % | consequence of the trapped charge + heat |
| BSFC | −8.43 % | consequence of power |
| DR / sr / efr | +3.8 / +5.2 / +5.2 % | the only near-correct group |
| TE / pmep / fmep / angle | +7.9 / +7.4 / 0.0 / +1.1 % | |

Everything except DR/sr/efr is one cascading quantity. `SEFF` is a function of
**one** input, `SR`, and `SR` at the end of scavenging *is* the reported `srv`
(1.4225). Blair's own numbers require `SR = 1.1335` for SE = 0.818. So a single
number is 25 % high, and it is the number that sets the trapped mass, hence CE,
IMEP, BMEP, power, BSFC, pmax and tmax.

**Single most likely cause: the volume-based scavenge ratio `SR`, i.e. the
`VOLINC` accumulation — `VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1` (BASIC 1108 /
`blair_step.m` 536) summed into `SR=SR+VOLINC` (1111 / 541) and consumed by
`SEFF=1-EXP(MSC*SR+CSC)` (1112 / 542).**

Why this and not something else:

1. It is the largest single term in the metric and the only quantity that scales
   the whole power chain. Removing just that one row leaves 7.6 %.
2. The `VOLINC` volume path carries **no** discharge coefficient, while the mass
   path it is paired with, `MT1=CD*C*F*D` (BASIC 1350 / `sub_flow.m` 134),
   carries one. Hence `SRv/SRm` comes out **1.547** against Blair's published
   1.134/0.874 = **1.2975** — a 19 % excess that no other statement can produce.
   This is the same defect either way you write it: 1108 missing `CD`, or 1103/1104
   printing `.75` where the book's own pair implies `≈.9`.
3. The explanation given in `PORT_NOTES.md` (set `CDT` to .9 at 1103/1104) is
   **measurably wrong**: running with `m.CDT = .9` gives a mean deviation of
   **13.07 %**, worse than 8.71 % (power 14.76 kW, sr 1.071, efr 1.072). That
   variant fixes the *ratio* but breaks the mass flow, so it is not the fix.

Important for this audit: **this is not a translation error.** Statements 1107–1112
match `blair_clean.bas` exactly (`EXPAND=PTR/PC1R`, `VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1`,
`SCRATIO=SCRATIO+MT1*DTM/MREF`, `IF SCRATIO<0 THEN GOTO 911`, `SR=SR+VOLINC`,
`SEFF=1-EXP(MSC*SR+CSC)` — all ✓). The 8.7 % is inherited from the source at
1103–1109, which is why a statement-by-statement diff of the nine routines finds
nothing to blame for it. If the intent is to reduce the deviation, the only
defensible place to look is the discharge coefficient in the transfer-port
inflow branch (1103/1104) together with `VOLINC` (1108) — as a *pair*, since
fixing either alone makes the other worse.

---

## 7. Housekeeping

### 7.1 Line-number drift in the port's own comments

Every one of these files cites `blair_clean.bas` line numbers that are **~100 too
low** (they belong to an earlier revision in which the SUB block had not yet
moved down):

| file | header claims | actual | offset |
|---|---|---|---|
| `sub_box.m` | 1384–1402 | 1484–1502 | −100 |
| `sub_port.m` | 1299–1313 | 1399–1413 | −100 |
| `sub_flow.m` | 1339–1354, 1360–1374 | 1439–1454, 1460–1474 | −100 |
| `sub_stab.m` | 1190–1199 | 1290–1299 | −100 |
| `sub_pipe.m` | 1237–1270 | 1337–1370 | −100 |
| `sub_pistpos.m` | 1410–1415 | 1510–1515 | −100 |
| `sub_parea.m`/`fport.m` | 1422–1426, 1177–1181 | 1522–1526, 1277–1281 | −100 |
| `sub_cylinder.m` | 1541–1600 | 1540–1600 | −1 (body uses `blair_full` numbers, as stated) |
| `sub_nint.m` | 1487–1495 | 1424–1432 | **+63** (also wrong inside its error strings: "1493" is 1431, "51-54" is 90–98, "170-173" is 210–213) |

This is documentation only — no arithmetic depends on it — but it defeats the
purpose of the mapping and it is how a reviewer "verifies" a line that is not
there. `sub_nint.m` is the worst because its *runtime error message* quotes the
wrong line to the user.

### 7.2 What the hint list predicted, and what was found

* *NINT's `K1=KI+1`, `KE1/KE2/KT`* — correct, including the `KI`-is-local
  requirement at 209 and the `/(KE-1)` mesh lengths at 210–213. No ERR.
* *BOX mass/energy bookkeeping order* — the 16 statements are in source order,
  the two-pass `CV1`→`CV2` temperature solve is intact, and `WORK` uses the new
  `PB2`. No ERR.
* *STATIC locals used before assignment* — CYLINDER is the only routine that
  reads a local before assigning it in the same call (`HT1`, `HT2`, `IGN`,
  `BURNEND`, `TAILDEG`, `PEAK`, `S1..S3`, `QMAX`, `TAFB`, `HEAT`, `MAIR`,
  `POLYINDEX`, `DELTAP`, `DPMAX`) and all 16 are carried in `m.cyl`, seeded once
  by `BLAIR_INIT` and re-seeded per run by `blair_run` 129. No ERR (R9 is the
  fragility note).

---

## 8. Bottom line

* **5 ERR, 11 RISK, 145 OK** (plus 12 call-site rows audited OK).
* No ERR in the six routines' *logic*: the port is a faithful, statement-ordered
  translation. The 5 ERRs are the three documented "book-page repairs"
  (GAM, HEAT, CP), ranked above by measured effect on power.
* **The 8.7 % mean deviation is not caused by any of them.** It is the
  volume-based scavenge ratio `SR` (+25.4 %) — `VOLINC` at 1108 accumulating the
  port volume flow without the discharge coefficient that the mass path applies —
  which through `SEFF=1−EXP(MSC·SR+CSC)` sets SE, CE, IMEP and therefore power
  and BSFC. The port's own explanation (CDT .75→.9) was tested and makes it
  worse (13.07 %).
