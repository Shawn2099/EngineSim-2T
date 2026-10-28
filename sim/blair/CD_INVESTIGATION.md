# Discharge coefficients in Blair Prog.5.1 — which value applies to the transfer port?

**Question.** Our MATLAB port reproduces Blair's published QUB 400 scavenge ratio only if the
transfer-port discharge coefficient is 0.9, not the 0.75 printed in the book. Which value does
Blair's own code use, and is the printed 0.75 for a different port?

**Answer.** Blair's own code uses **0.75**. The 0.9 that appears in the same subroutine block
belongs to a *different boundary*: the port **area** coefficient `AK` (not a discharge
coefficient at all), the **inlet** port inflow `CDI`, and — the one that is easy to mistake for
this — the **crankcase end** of the transfer duct in Prog.5.1. Nothing in Blair's code puts 0.9
at the cylinder end of the transfer port, in either scavenging model.

**And the 0.9 does not work.** Running the actual port with `CDT = 0.9` does not reproduce
Blair's SRvol: it moves it from +25.4 % to +20.3 % (case A) and from +17.8 % to +15.2 %
(case B), while pushing SRmass from +5.2 % to +22.9 % and +8.4 % to +28.7 %. The 0.9 was
inferred from a *ratio* that has a discharge coefficient in its denominator; the reasoning is
circular and the measurement refutes it. **0.9 is (c): a fudge that would hide an implementation
bug** — and one that does not even fix the quantity it was meant to fix.

---

## 1. Sources and how they were checked

| # | Witness | What it is | Transfer-port Cd |
|---|---|---|---|
| 1 | Book, Computer Program Appendix, **src 27730–27746** | Blair's printed Prog.5.1 listing, `TRPORTOPEN` (model 1, Eq.5.1.11) | **0.75** |
| 2 | Book, **src 27749–27762** | Blair's printed Prog.5.1 listing, `TRPORTOPEN` (model 2, Eq.5.1.13) | **0.75** |
| 3 | `port/blair_subroutines_basic.txt` 170–185, 189–197 | independent transcription of the same pages | **0.75** |
| 4 | `port/blair_prog52_basic.txt` 846–849, 864–867 | independent transcription of Prog.5.2 (identical routine) | **0.75** |
| 5 | `port/blair_clean.bas` 1103–1104, `blair_full.bas` 1003–1004 | merged/cleaned BASIC used by the port | **0.75** |
| 6 | `sim/blair/blair_step.m` 519–524 | MATLAB port | **0.75** |

All six agree. `src` numbers are line numbers in
`references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`.

### The printed statement, verbatim (src 27730–27746)

```
TRPORTOPEN:
IF PTR<=PC 1R THEN CCT=8
IF PTR>PC1R THEN CCT=.8
CALLFPORT(HTOT.HTDCTRHT.FTPRT.FTDUCT.AKT.CCT)
CALL PORT( AT( 1 ).BT( 1 ).PC1 .AKT)
IF PTR<=PC1R THEN CDT=.75          <- 27735
IF PTR>PC1R THEN CDT=.75           <- 27736
IF PTR<=PC1R THEN CALL OUTFLOW*BT( 1 ).AT( 1 l.FTDUCT.TCI.
HTKCTLMTl.DSCAV.CDT)
IF PTR>PCIR THEN CALL OUTFLOW)BT( 1 ).AT( I i.FTDUCT.TCCI.
HTl,CTt,MTLDSCAV,CDT)
EXPAND=PTR/PC!R
VOLINC=CT I *FTDUCT*DTM*EXPAND/VC 1
SCRATIO=SCRAT10+MTl*DTM/MREF
IF SCRATIO<0 THEN GOTO 91 1
SR=SR+VOLINC
SEFF= I -EXP( MSC*SR+CSC)
```

(`CCT=8` is the OCR losing the decimal point of `.8`; `PC IR`, `HTl` are OCR too. The two
`CDT=.75` lines are clean.)

Note the structure: the `<=`/`>` pair sets the **same** constant on both sides. The comparison
is dead — this is recorded independently in `blair_prog52_basic.txt` NOTE C6 and
`VERIFY_STRUCTURE.md` 7.2. So the value that reaches `OUTFLOW` at run time is **always 0.75**,
in every flow direction, for the whole scavenge period.

### This is definitionally the transfer port

`TRPORTOPEN` is the only routine that computes the transfer-port scavenge flow, and it is where
`SR` (scavenge ratio) is accumulated:

* `CALL FPORT(HTOT,HTDC,TRHT,FTPRT,FTDUCT,AKT,CCT)` — `TRHT` = transfer port height, `FTPRT` =
  transfer port area, `FTDUCT` = transfer duct area.
* `CALL OUTFLOW(...,FTDUCT,...)` — flow through that area.
* `SR=SR+VOLINC` — the scavenge ratio the validation compares against 1.134.

The narrative confirms the mapping: §5.1.5, src 10142–10291 says of Eqs. 5.1.10–5.1.14 "In
Prog.5.1 and 5.2, the reader will find this set of equations in the subroutine `TRPORTOPEN`",
and "All of the program examples presented within this chapter are computed using the version of
`EXPAND` presented in Eq. 5.1.11" (src 10276–10277).

---

## 2. Every Cd in play

`CD` is argument **9 of 9** of Blair's `SUB OUTFLOW(A,B,F,TR,H,C,M,D,CD)` and
`SUB INFLOW(A,B,F,TR,H,C,M,D,CD)`; in the MATLAB port it is the **6th of 6** arguments of
`local_outflow(m,A,B,F,TR,CD)` / `local_inflow(...)` (H, C, M, D are returned rather than
written through the argument list). Inside both bodies it is used exactly once,
`M=CD*C*F*D`.

`CYLINDER` and `BOX` take **no Cd at all**: `SUB CYLINDER(P1,P2,T1,T2,V1,V2,MC,WORK)` and
`SUB BOX(PB1,PB2,TB1,TB2,VB1,VB2,MB1,MB2,MIN,MO,CIN,CO,HIN,HO,WORK)`. Verified by grep over
`sim/blair/*.m` and over both `.bas` files — no `CD` in `sub_cylinder.m`, `sub_box.m`,
`CYLINDER:` or the `BOX` body.

### 2.1 Call sites in `blair_clean.bas` (= `blair_full.bas`, identical values)

| # | Subroutine / block | `blair_clean.bas` | arg | variable | value at run time | governs |
|---|---|---|---|---|---|---|
| 1 | main loop → `OUTFLOW` | 335–337 | 9 | `CD` | **.9** if `AT(KT)>=BT(KT)`, else **.75** | crankcase ↔ transfer duct, at the **crankcase end** |
| 2 | main loop → `OUTFLOW` | 338–340 | 9 | `CD` | **1** if `AE(KE1)>=BE(KE1)`, else **.75** | exhaust duct → silencer box |
| 3 | main loop → `OUTFLOW` | 341–343 | 9 | `CD` | **.75** if `AET(1)>=BET(1)`, else **1** | silencer box → diffuser/atmosphere |
| 4 | `EXPORTOPEN` → `OUTFLOW` | 1065–1067, 1066–1075 | 9 | `CDE` | **.75** (both branches; dead test) | **exhaust port**, cylinder → pipe |
| 5 | `TRPORTOPEN` → `OUTFLOW` | 1103–1105 | 9 | `CDT` | **.75** (both branches; dead test) | **transfer port**, duct → cylinder (subsonic branch) |
| 6 | `TRPORTOPEN` → `OUTFLOW` | 1104–1106 | 9 | `CDT` | **.75** (both branches; dead test) | **transfer port**, duct → cylinder (PTR>PC1R branch) |
| 7 | `INPORTOPEN` → `OUTFLOW` | 1141–1143 | 9 | `CDI` | **.75** if `PIR<=PCC1R` | **inlet port**, crankcase → inlet pipe |
| 8 | `INPORTOPEN` → `INFLOW` | 1142–1144 | 9 | `CDI` | **.9** if `PIR>PCC1R` | **inlet port**, atmosphere → crankcase (inflow) |

### 2.2 The same sites in the MATLAB port

| # | File / line | MATLAB call | Cd field | value |
|---|---|---|---|---|
| 1 | `blair_step.m` 256–263 | `sub_flow_out(m, BT(KT), AT(KT), FTDUCT, TCC1, CD)` | `m.CD` | `.9` / `.75` |
| 2 | `blair_step.m` 266–273 | `sub_flow_out(m, AE(KE1), BE(KE1), FEP1, TC1, CD)` | `m.CD` | `1` / `.75` |
| 3 | `blair_step.m` 276–283 | `sub_flow_out(m, AET(1), BET(1), FEP2, TB1, CD)` | `m.CD` | `.75` / `1` |
| 4 | `blair_step.m` 472–488 | `sub_flow_out(m, AE(1), BE(1), FEP1, TC1, CDE)` | `m.CDE` | `.75` |
| 5 | `blair_step.m` 519–534 | `sub_flow_out(m, BT(1), AT(1), FTDUCT, TC1/TCC1, CDT)` | `m.CDT` | `.75` |
| 6 | `blair_step.m` 577–590 | `sub_flow_out(... , CDI)` / `sub_flow_in(... , CDI)` | `m.CDI` | `.75` / `.9` |
| — | `sub_flow.m` 108–138, 142–157 | `M = CD*C*F*D` | `CD` | passthrough |

`m.CDT` is not read from the input deck and is not exposed by `blair_init`; it is assigned
inside `local_trport_open` on every step. The 42-entry QUB 400 deck has no Cd field, so there is
no "deck value" to reconcile.

### 2.3 The coefficient that is *not* a discharge coefficient: `AK`

`AK` (and its siblings `AKE`, `AKT`, `AKI`) is the **port area coefficient** fed to
`SUB PORT(A,B,P,AK)` and to `FPORT(...,AK,CC)`, where `FPORT` computes
`AK=CC*FINST*FPRT/FPIP`. `CC` (`CCE`, `CCT`, `CCI` = .8/.8/.8–.9) is the coefficient inside
`FPORT`. These appear with `.9` and `.75` chosen by flow direction at five pipe ends
(`blair_clean.bas` 291–304; `blair_full.bas` 222–235; book src 26204–26219, 27022–27030).
They set the *boundary
condition*; they are a different quantity from the `CD` in `M=CD*C*F*D`. `INPUT_FORMAT.md` 401
describes them as "discharge-coefficient-like coefficients at the pipe ends", which is a fair
description but not the same object.

**This is the most likely origin of the 0.9 in the finding.** A few lines earlier in the same
main loop the transfer-duct area coefficient is set with `IF AT(KT)>=BT(KT) THEN AK=.9`
(line 303), and the flow line at the crankcase end of that same duct reads `THEN CD=.9`
(line 335). Neither is the transfer-port Cd.

---

## 3. The "0.75 at lines 1103/1104"

Those are **`blair_clean.bas` 1103/1104**, the two `CDT` assignments. They are not book lines.

**In the `.txt`, lines 1103 and 1104 are page furniture:**

```
1103: <<<PAGE 13>>>
1104: The Basic Design of Two-Stroke Engines
```

followed by the opening of §1.1, "The fundamental method of operation of a simple two-stroke
engine" (1105–1135). There is no discharge coefficient anywhere near them. The book does not
discuss port Cd numerically in its running text at all — a grep for "coefficient" over the
whole 31 387-line file returns 17 hits, none of them a port Cd value. In this book the Cd values
live **only in the program listings**, which is why the listing is the authority.

The 0.75 is not "for a different port" in the sense of being borrowed from the exhaust or inlet
elsewhere: the same 0.75 is Blair's generic port value and he applies it to **all three** ports —
exhaust (`CDE` 27707/27708), transfer (`CDT` 27735/27736 and 27757/27758) and inlet subsonic
(`CDI` 27783). It is used *for the transfer port itself*, twice, in both scavenging models.

---

## 4. Where every 0.9 in Blair's code actually goes

| 0.9 site | src | `blair_clean.bas` | what it is |
|---|---|---|---|
| `IF AT(KT)>=BT(KT) THEN CD=.9` | 26231 | 335 | transfer duct, **crankcase end** (Prog.5.1 only; Prog.5.2 has `CD=1`, src 27041) |
| `IF AE(KE1)>=BE(KE1) THEN AK=.9` | 26204 | 291 | **area** coefficient, exhaust duct at the box |
| `IF AET(1)<BET(1) THEN AK=.9` | 26209 | 296 | area coefficient, diffuser at the box |
| `IF AET(KE2)>=BET(KE2) THEN AK=.9` | 26211 | 298 | area coefficient, diffuser outlet |
| `IF AT(KT)>=BT(KT) THEN AK=.9` | 26218 | 303 | area coefficient, transfer duct at the crankcase |
| `IF PIR>PCC1R THEN CDI=.9` | 27784 | 1142 | **inlet** port, inflow (atmosphere → crankcase) |
| `IF PIR>PCC1R THEN CCI=.9` | 27780 | 1133 | inlet `FPORT` coefficient, inflow |

So there are exactly two 0.9s that could be mistaken for a transfer-port Cd, and neither is one:
`CDI` is the **inlet** (its flow feeds `DRATIO` = delivery ratio, not `SR`), and `CD` at
`AT(KT)` is the **crankcase end** of the transfer duct — the flow between crankcase and duct,
which our port already has at .9 (correctly, per src 26231).

---

## 5. Empirical test: 0.75 vs 0.9, both QUB 400 load points

The port was copied to a scratch directory (no project file was modified) and `m.CDT` changed on
the `PTR>PC1R` branch — the branch the finding names — then run through `qub400_model` for cases
A and B. A third variant set 0.9 on both branches; it differs by <1 % and is not tabulated.

### Case A — 3000 rpm, THAR 1.0, SCRE, cycle 5 (Fig.5.9)

| quantity | published | CDT 0.75 | err | CDT 0.90 | err |
|---|---:|---:|---:|---:|---:|
| DR | 0.854 | 0.8865 | +3.8 % | 0.8558 | **+0.2 %** |
| SR mass | 0.874 | 0.9194 | +5.2 % | 1.0739 | **+22.9 %** |
| **SR vol** | **1.134** | **1.4225** | **+25.4 %** | **1.3641** | **+20.3 %** |
| SRvol / SRmass | 1.2975 | 1.5472 | +19.2 % | 1.2702 | −2.1 % |
| SE | 0.818 | 0.8877 | +8.5 % | 0.8762 | +7.1 % |
| TE | 0.504 | 0.5439 | +7.9 % (pass) | 0.5974 | **+18.5 % (fail)** |
| CE | 0.430 | 0.4817 | +12.0 % | 0.5109 | +18.8 % |
| power kW | 12.2 | 13.83 | +13.3 % | 14.79 | +21.2 % |
| BMEP bar | 6.14 | 6.96 | +13.4 % | 7.45 | +21.3 % |
| Pmax bar | 35.8 | 38.90 | +8.7 % | 40.76 | +13.9 % |

### Case B — 3000 rpm, THAR 0.25, SCRE, cycle 5 (Fig.5.13)

| quantity | published | CDT 0.75 | err | CDT 0.90 | err |
|---|---:|---:|---:|---:|---:|
| DR | 0.491 | 0.5452 | +11.0 % | 0.5390 | +9.8 % |
| SR mass | 0.535 | 0.5799 | +8.4 % | 0.6884 | **+28.7 %** |
| **SR vol** | **0.735** | **0.8661** | **+17.8 %** | **0.8469** | **+15.2 %** |
| SRvol / SRmass | 1.3738 | 1.4935 | +8.7 % | 1.2303 | **−10.4 %** |
| SE | 0.64 | 0.7156 | +11.8 % | 0.7063 | +10.4 % |
| TE | 0.569 | 0.6073 | +6.7 % | 0.6584 | **+15.7 %** |
| CE | 0.283 | 0.3297 | +16.5 % | 0.3531 | **+24.8 %** |

### What the test says

1. **0.9 does not reproduce SRvol.** +20.3 % and +15.2 % remain. The claim "reproduces the
   published scavenge ratio only if Cd = 0.9" is not what the code does.
2. **0.9 makes SRmass much worse** (+22.9 % / +28.7 % against +5.2 % / +8.4 %).
3. **0.9 breaks TE**, which passes at 0.75 in both cases.
4. **0.9 makes the ratio error change sign**: −2.1 % at full load but −10.4 % at quarter load.
   A constant that has to move one case by 19 % and the other by 8.7 % is not a constant that
   was wrong; it is a symptom of a load-dependent modelling error.
5. The one thing 0.9 "fixes" is DR (+3.8 % → +0.2 %). But DR is the **inlet** chain
   (`DRATIO` is accumulated in `INPORTOPEN` from `MI1`, and `CDI` is untouched). Tuning the
   transfer-port Cd to land DR is compensating a crankcase-pressure error through a channel that
   has nothing to do with the inlet port.

Test of the `[FIX3]` ratio-order change (early vs Blair's own late `PEX/PIR/PTR` placement), in
case it was the source of the volume error: case A gives SRvol 1.4223 vs 1.4225 and ratio
1.5475 vs 1.5472. **No effect** — that is not the cause either.

---

## 6. Why the 0.9 inference is circular

`TRPORTOPEN` accumulates two things from the same time step:

```
VOLINC  = CT1*FTDUCT*DTM*EXPAND/VC1        (src 27742)   -> SR (volume)
SCRATIO = SCRATIO + MT1*DTM/MREF           (src 27743)   -> SR (mass)
MT1     = CDT*CT1*FTDUCT*DSCAV             (SUB OUTFLOW)  -> note CDT
```

`CT1` here is the **velocity** `C` returned by `OUTFLOW`, not a temperature — the output order
is `H, C, M, D`. Dividing, the shared `CT1*FTDUCT*DTM` cancels:

```
SRvol / SRmass  =  EXPAND * MREF / ( VC1 * CDT * D )
```

(`PORT_NOTES.md` 73 states this identity; it is correct.) Three consequences:

* **SRvol does not contain `CDT` at all.** It is fixed by the volume chain
  `CT1*FTDUCT*EXPAND/VC1`. Changing Cd can only move it indirectly, through the thermodynamics —
  which is exactly the small, wrong-direction 4 % and 2 % seen above.
* `SRmass` is *linear* in `CDT`. Raising Cd by 0.9/0.75 = 1.2 raises SRmass by ~20 %.
* Therefore the ratio can be "fixed" by raising `CDT` while **both** absolute quantities get
  worse. That is what the table shows.

The finding was derived by taking the model's ratio (1.5472), multiplying by 0.75/0.9, and
observing that 1.289 ≈ 1.2975 — reproducing the *published pair* to 0.6 %. But the published
pair is two numbers, and the inference uses one degree of freedom to match one derived quantity.
The identity is satisfied equally well by ~19 % error in `EXPAND`, `VC1` or `D`. Solving it for
`CDT` assumes the other three are exact, which the SRvol error proves they are not.

Where the real error is: since SRvol is +25 % (A) / +18 % (B) and SRmass only +5 % / +8 %, and
the two chains share `CT1` and `FTDUCT`, the fault is in the **volume chain alone** —
`EXPAND = PTR/PC1R`, `VC1`, or `D` (which enters only the ratio). That is a genuine port defect
and it deserves its own investigation; it is not a Cd question.

---

## 7. Cross-check against the 1996 book

*The Design and Simulation of Two-Stroke Engines* (SAE, 1996) contains no Prog.5.1 listing, but
its stated Cd values are consistent with 0.75 for a port and show where a 0.9 legitimately comes
from — **small openings**, not the transfer port's operating range:

| Value | Port / situation | Line |
|---|---|---|
| 0.75 | "equivalent to 20 mm diameter with a discharge coefficient of 0.75, simulating a cylinder port or valve near its maximum opening" | 8443 |
| 0.90 | "the port diameter is equivalent to a 3-mm-diameter hole and has a coefficient of discharge of 0.90" — a blowdown, valve "just commenced its opening" | 8144–8145 |
| 0.85 | "a realistic coefficient of discharge of 0.85" for a simple **expansion** in a pipe | 6957 |
| 0.70 | "the quite logical Cd value of 0.7" for a sudden **contraction** | 6962 |
| 0.6–0.95 | measured map for the QUB SP single-pulse rig (Fig.2.27, axis labels 10061–10084); Cd is a function of pressure ratio and area ratio, not a constant | 10085 |

The 1996 book's Appendix A2 (11981–12130) is emphatic that a single constant Cd is a
simplification: Cd for simulation purposes depends on pressure ratio and **area ratio**,
`Cda = Aeff/At`. Blair's Prog.5.1 uses one constant per boundary because that is all the
1985 microcomputer model supported. Within that convention the transfer port is 0.75.

No QUB 400 figure states a Cd: Figs.5.9–5.13 print DR, SR, SE, TE, CE, power, BSFC, BMEP, IMEP,
PMEP, FMEP, Pmax, Tmax and angle — nothing else. So the published QUB 400 numbers can neither
confirm nor refute a Cd directly; they only constrain it jointly with everything else.

---

## 8. Verdict

**The value to use is 0.75.**

| Claim | Verdict |
|---|---|
| (a) 0.9 is what Blair used | **No.** Six independent witnesses, including two printings of Blair's own listing, give 0.75 twice in each of the two scavenging models. No version of `TRPORTOPEN` uses 0.9. |
| (b) 0.9 is what a correct reading of the code gives | **No.** The 0.9s in the block are `AK` (an area coefficient), `CCI`/`CDI` (the inlet), and `CD` at the crankcase end of the transfer duct. None is `CDT`. |
| (c) 0.9 is a fudge that hides an implementation bug | **Yes.** Measured: it leaves SRvol 20 % / 15 % high, doubles the SRmass error, and fails TE. It fits only the full-throttle SRvol/SRmass ratio, by coincidence (19 % ≈ 20 %), and fails at quarter throttle. |

The remaining defect is real and is **not** a discharge coefficient: SRvol is too high by 25 %
(A) and 18 % (B) while SRmass is only 5 % / 8 % high, and SRvol is independent of `CDT`. The
error is in the SRv volume chain (`EXPAND`, `VC1`, or the `D` used in the mass normalisation),
not in the port's Cd. Changing Cd would move the symptom around the validation table without
touching the cause.

**Recommendation:** leave `m.CDT = .75` as Blair printed it, keep `CD_INVESTIGATION` open on the
volume chain, and treat the +25 % SRvol as a bug to be found rather than a coefficient to be
tuned.

---

## 9. Reproduction

No file in the project was modified. The runs were made on copies under
`%TEMP%\opencode\`:

| folder | change | case A | case B |
|---|---|---|---|
| `cd075` | none (as delivered) | SRvol 1.4225, SRmass 0.9194, DR 0.8865 | SRvol 0.8661, SRmass 0.5799, DR 0.5452 |
| `cd09` | `blair_step.m` 523: `m.CDT = .9` | SRvol 1.3641, SRmass 1.0739, DR 0.8558 | SRvol 0.8469, SRmass 0.6884, DR 0.5390 |
| `cd09both` | `blair_step.m` 520 and 523: `.9` | SRvol 1.3590, SRmass 1.0706, DR 0.8571 | — |
| `cdlate` | `qub400_model.m`: `ratio_order = 'late'` | SRvol 1.4223, SRmass 0.9191, DR 0.8865 | — |

Each run is `qub400_model(qub400_load_input('QUB400_INPUT.dat'), over)` with
`rpm 3000`, `throttle 1.0` (case A) or `0.25` (case B), `SCRE`, 5 cycles; ~2–3 s per case.
