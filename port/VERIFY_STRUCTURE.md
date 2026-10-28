# VERIFY_STRUCTURE — static structural audit of `port/blair_full.bas`

Audit of the assembled 1503-line BASIC source against `BUILD_MANIFEST.md`, performed by
parsing the file (no execution), before translation.

Method: every statement was stripped of `REM`, labels were extracted by both forms
(`nnnn stmt` and `name:`), all `GOTO`/`GOSUB`/`CALL` sites were resolved with an explicit
scope model, and every identifier was counted and classified by line. Counts below are
from those passes, not from the manifest.

Line numbers are `.bas` line numbers (1-based, as `Read` reports them).

---

## 0. Manifest claims re-tested

| manifest claim (§10 and header) | measured | verdict |
|---|---|---|
| "call arity 0 mismatches" | 60 `CALL` sites, 14 `SUB`s, **0** arity mismatches | **confirmed** |
| "every `CALL`/`GOSUB` target defined" | 84 branch references, **0** unresolved | **confirmed** |
| "34 main-module labels, none duplicated" | 34 numeric main-module labels, unique — **but** 29 named routine labels + `FINISH` are omitted from the count, and 2 numeric labels *are* duplicated once `SUB` scope is dropped | **partly confirmed** |
| "all 38 references resolve" | there are **84** `GOTO`/`GOSUB` references (29 `GOSUB`, 55 `GOTO`), not 38 | **number wrong, conclusion right** |
| §5 "only 11 of the 14 SUB blocks declare anything `SHARED`" | **10** blocks declare (`CYLINDER` uses **two** `SHARED` statements, so there are 11 statements, not 11 blocks); 4 declare none (`FPORT`, `SETS`, `AREA`, `SHOK`) | **statement count right, block count wrong** |
| §5 "32 distinct names must be visible inside a `SUB`" | union of the 11 `SHARED` statements = 27 scalars + 5 arrays = **32** | **confirmed** |
| §5/§7 shared-variable table, name by name | matches the file exactly | **confirmed** |
| D23 "`BOX`'s `103`" | `SUB BOX` (1384–1402) contains **no label at all** | **claim is stale** |
| "0 blockers left in the code" | 0 link-time blockers; **1 syntax blocker + 2 flattening blockers** (below) | **not confirmed** |

---

## 1. Branch targets, label scope, SUB boundaries

### 1.1 Resolution

84 references (29 `GOSUB`, 55 `GOTO`), 45 distinct `GOTO` targets, 29 distinct `GOSUB`
targets. **Every one resolves.** No `ON…GOTO`, no computed `GOTO`/`GOSUB`, no `GOSUB`
inside a `SUB`, no `RETURN` inside a `SUB`.

All 29 `GOSUB` targets are the 29 named routine labels; `FINISH:` (line 80) is defined and
never referenced (manifest acknowledges this).

### 1.2 Labels defined twice — **DEFECT, 2**

In the file as written, QBasic resolves these per scope, so they are legal. They become
fatal identifier collisions the moment the label spaces are merged, and `D23` is right that
this is the highest-risk item.

| label | main-module definition | `SUB` definition | statements that break after flattening |
|---|---|---|---|
| `20` | line **849** (`TRPIPDAT`, transfer-pipe input loop) | line **1468** (`CYLINDER`, "after peak") | **1463**, **1464** `GOTO 20` |
| `50` | line **89** (main, `INPUT "RESPONSE FOR NEW DATA…"`) | line **1486** (`CYLINDER`, WORK calculation) | **1467** `GOTO 50` |

Flattened, line 1467's `GOTO 50` jumps into the interactive data-entry prompt in the middle
of the integration loop, and 1463/1464 jump into `TRPIPDAT`'s input loop. No error, no
diagnostic — silent, unrecoverable, exactly as `D23` predicts.

`CYLINDER`'s other five labels (`30, 60, 70, 80, 90`) and all of `PIPE`'s (`23, 33, 44,
55`) and `SHOK`'s (`26, 56`) are unique across the whole file — only **`20` and `50`**
collide.

### 1.3 Targets that cross a routine boundary

**DEFECT, 2** — both in the printer-replay hack, and both must be modelled before
flattening:

| line | statement | lands at | problem |
|---|---|---|---|
| **205** | `IF CYCLE=CYCLEP+1 THEN GOTO 431` | **341** `431 CLOSE #2` — *inside `PRINTOUT`*, past its own `GOTO 430` | enters `PRINTOUT` mid-body; the `RETURN` at 342 returns to the caller of the `GOSUB PRINTOUT` at line 291 |
| **340** | `GOTO 430` (in `PRINTOUT`) | **207** — inside the main loop | leaves `PRINTOUT` without returning; its frame stays open until 342 |

`PRINTOUT` therefore has **no return path of its own**. It is not a subroutine in any
translatable sense; it is a coroutine with the main loop. Any mechanical
"`GOSUB` → function call" rewrite produces a function that never returns, and any
translation that gives `PRINTOUT` a local scope loses the `CYCLE`/`CYCLEP` state it
shares with the loop.

No `GOTO`/`GOSUB` anywhere in the file crosses an actual `SUB` boundary.

### 1.4 Cascade completeness at the port boundaries

| ports | lines | complete? |
|---|---|---|
| exhaust | 237 `HTDC<=HEOT`, 238 `HTDC>HEOT` | yes |
| transfer | 239 `HTDC<=HTOT`, 240 `HTDC>HTOT` | yes |
| cylinder/box | 264 `HTDC<=HEOT`, 265 `HTDC>HEOT` | yes |
| **inlet** | 241 `HTDC<HIOT`, 242 `HTDC>HIOT` | **no — `HTDC=HIOT` takes neither branch** |

**DEFECT, 1.** On the step where the piston height equals the inlet-port-opening height
exactly, neither `INPORTOPEN` nor `INPORTSHUT` runs, so `AI(1)`, `BI(1)` and `AKI` carry
over unchanged for one step. Low frequency, one step per cycle at most, and plot-invisible,
but it is an uncovered case that the other two ports do not have.

---

## 2. Variable analysis

### 2.1 Used but never assigned — **DEFECT, 1 (+ 1 conditional)**

| line | variable | note |
|---|---|---|
| **217** | `CYCTRIP` | `IF CYC=CYCTRIP THEN PCOUNT=PCOUNT+1`. Never assigned anywhere. QBasic gives 0, `CYC` is 1 (line 124), dead. **Already logged as D19**; confirmed. `CYC` itself is assigned once (124) and never modified, so the test cannot become true even if `CYCTRIP` were set later. |
| **1032/1041/1044** | `PIR` | assigned only at **274**, i.e. *after* `INPORTOPEN` consumes it at 241 — see 2.2 |

### 2.2 Read before write on the first iteration (ordering defects) — **DEFECT, 3**

`PEX`, `PTR`, `PIR` are computed at lines **273–275** at the *bottom* of the loop body, but
consumed at **237–242** near the *top*:

```
237-242  GOSUB EXPORTSHUT/EXPORTOPEN/TRPORTSHUT/TRPORTOPEN/INPORTOPEN/INPORTSHUT
         ...uses PEX (961..975), PTR (999..1006), PIR (1032..1044)
253-265  OUTFLOW, BOX, CYLINDER
270-278  PCR PCCR PBR PEX PIR PTR PTRO PEXP PEXT   <-- computed here
```

Consequences: (a) on the **first** iteration all three are 0; (b) on every later iteration
they are one timestep stale. This is not cosmetic on the inlet: `PIR` alone decides whether
line 1043 (`OUTFLOW`) or 1044 (`INFLOW`) runs — two different routines with different
equations. With `PIR=0` on step 1 the `OUTFLOW` branch is taken unconditionally. `PTR`
decides `TC1` vs `TCC1` at 1005/1006; `PEX` decides branches that are numerically identical
after D13 (961/962, 965/966, 967/975), so `PEX`'s staleness is benign today but becomes
live the moment D13 is revisited.

`PC1R` has the same shape: it is computed inside `EXPORTOPEN` (960) and reused by
`TRPORTOPEN` (999–1007). That is safe only while `HTDC>HTOT` implies `HTDC>HEOT`
(i.e. the transfer port never opens while the exhaust is shut). If a data set violates
that, `TRPORTOPEN` reads a stale `PC1R`. **HAZARD.**

### 2.3 Read before write inside `CYLINDER` — **DEFECT, 2**

* **`HT1`** (line 1475 `QHT=DC*(HT1+HT2)/2`) has its **only** write at line **1495**
  (`HT1=HT2`), *after* the read. See §6.2 — with `STATIC` this is the previous call's
  `HT2` (trapezoidal rule); with automatic locals it is 0 (rectangle rule). The manifest's
  D15 asserts the latter; the source says `STATIC`, which means the former. Material.
* **`HT2`** is assigned only on the combustion path (1469, 1472, 1474). Both
  `GOTO 90` paths (1457 `DEGC<=IGN`, 1458 `DEGC>=BURNEND`) reach 1495 without assigning it,
  so on those steps `HT1` is loaded from a stale/garbage `HT2`. On the very first call
  `HT2` has never been written at all.

### 2.4 Assigned but never read — **DEFECT, 57**

50 main-module globals + 7 `SUB` locals. All are dead stores; none affects a result, but
they are the largest single block of misleading code in the file and every one of them will
become an "unused variable" warning (or an accidental global) in the translated source.

**Main module — engine constants (5)**

| line | name |
|---|---|
| 141 | `CCP` |
| 142 | `GR` |
| 143 | `N27` |
| 144 | `N17` |
| 182 | `COUNT` |

**Main loop / diagnostics (8)**

| line | name | note |
|---|---|---|
| 125,190 | `NN` | incremented, never read |
| 132,438 | `MBACK` | reset twice, never read |
| 272 | `PBR` | |
| 276 | `PTRO` | |
| 277 | `PEXP` | |
| 278 | `PEXT` | |
| 262 | `BOXW` | `BOX`'s WORK output for the exhaust box; only `CCWORK` (263) and `CYWORK` (264/265) are consumed |
| 263 | `TCC2`, `MCC2` | written by `BOX`, never read back |

**`PORTSTART` outputs never consumed (23)** — the residue of the 5.2 angle-resolved port
model:

`IPC` (903), `IPOD` (904), `TPC` (905), `PFI` (906), `PFE` (907), `PFT` (908), `PFIM`
(909), `PFEM` (910), `PFTM` (911), `PWE` (912), `PWT` (913), `PWI` (914), `PHE` (915),
`PHT` (916), `PHI` (917), `HEFB` (919), `HME` (921), `HTOB` (922), `HTFB` (923), `HMT`
(925), `HIOB` (926), `HIFB` (927), `HMI` (929).

(`HEOB`, also written at 918, **is** live — used at 122.)

**`CYLSTART` (3)**: `DEREF` (1167), `DTREF` (1168), `DIREF` (1169).

**`PAREA` outputs (2)**: `DEPRT` (114), `DTPRT` (115) — the third, `DIPRT` (116), is used
at 181.

**Pipe geometry (1)**: `FIPM` (378, 873) — computed twice, read nowhere. This is the
circumstantial evidence for D14 and is worth keeping visible.

**`TRPORTOPEN` (1)**: `DSCAV` (1005, 1006) — `OUTFLOW`'s density output, unused in
scavenging model 1. (It *is* needed for model 2 — see manifest §3a.)

**Plot code (4)**: `YT1` (622), `YT2` (623), `YT3` (624), `MG` (665).

**`SUB` locals never read (7)**: `MN` (1351, `OUTFLOW`), `P1` (1352), `P2` (1353) — all
three shadow-named but scope-local; `MN` (1371, `INFLOW`), `PR` (1372), `PL` (1373);
`DPMAX` (1491) — only ever compared with itself, see D16.

**String variables never read (2)**: `S$` (512), `A$` (411, 437).

### 2.5 Conditionally assigned (no default) — **HAZARD, 2**

`MSC` and `CSC` are assigned only in the six `SCAV$` tests at 930–941. If the case data
gives `SCAV$` any other value (including the untouched `""` when every data prompt is
answered `N`), both stay 0, `SEFF=1-EXP(0)=0` at 1012, and `CEFF`/`TEFF` follow to 0 — a
silent zero-result run rather than a diagnostic. `TAF` by contrast has a default (line 68).

---

## 3. Arrays

### 3.1 DIM before first use — **0 defects**

All 44 arrays are `DIM`ed at lines **50–64**, before the first array reference at line 77.
No implicit-dimension use anywhere. `A2`/`B2` are `DIM`ed at line 55 as well as declared
`SHARED` in `PIPE` (1238) — correct.

Note for the translator: there is **no `OPTION BASE`**, so QBasic arrays are base 0 and
`DIM X(20)` allocates indices **0..20 (21 elements)**. Sizing a translated array as 20
elements silently drops the last one; the duct arrays are used at index `KE1`/`KE2`/`KT`/`KI`
which reaches exactly 20.

### 3.2 Maximum index reached vs declared size

| array | declared | largest index reached | within? |
|---|---|---|---|
| `ABX` | (21,45) | dim1 **21** (via `I+1`, `I=INT(AK/.05)+1`, `AK` clamped ≤.95 at 1303) | dim1 **yes** (exactly) |
| `ABX` | (21,45) | dim2 **46** when `BX1≥1.48` (`J+1`, `J=INT((BX1-.6)/.02)+1`, 1306–1309) | **NO — by 1** |
| `BX` | (45) | **46** when `BX1≥1.48` (1310) | **NO — by 1** |
| `AKA` | (45) | **21** (`AKA(I+1)`, 1307) | yes |
| `DF`, `F` | (20) | `F(KB)` = **20**, `DF(KB-1)` = 19 | yes (unused by 5.1 anyway) |
| `AE,BE,FE,DFE` | (20) | `KE1` / `KE1-1` | yes iff `KE1≤20` |
| `AET,BET,FET,DFET` | (20) | `KE2` | yes iff `KE2≤20` |
| `AT,BT,FT,DFT` | (20) | `KT` | yes iff `KT≤20` |
| `AI,BI,FI,DFI` | (20) | `KI` | yes iff `KI≤20` |
| `A2,B2` | (20) | `KE1`/`KE2`/`KT`/`KI` (all four ducts share them) | yes iff all ≤20 |
| `XA,YC,YS,YE` | (200) | `1+(EPC-EPO)/DC = 1+(360-2·EPO)/DC` → **161** at `EPO=100, DC=1` | yes iff **DC ≥ 0.81°** |
| `YF` | (13) | **13** (642, `FOR K=1 TO 13`) | yes — exactly at bound |
| `YI,YV,YP,XXA,YB` | (250) | `1+2·EPO/DC` → **201** at `EPO=100, DC=1` | yes iff **DC ≥ 0.80°** |
| `DELRAT…EXRP` (15) | (20) | `JJ` = **7** after the run, **8** during the print replay | yes |

**DEFECT, 2 (one root cause).** `SUB PORT` puts no upper clamp on `BX1` (it only clamps
from below at 1304). With `ABX` loaded for only 41 columns (`FOR J=1 TO 41`, line 76) and
`BX(42..45)` never written (they stay 0), the failure ladder in `BX1` is:

| `BX1` | `J` | what happens |
|---|---|---|
| ≤ 1.40 | ≤ 41 | correct |
| 1.40 – 1.42 | 41 | interpolates columns 41/42, i.e. real data against a zero column → wrong `A`, no error |
| **1.42 – 1.48** | **42–44** | **`RB=(BX1-BX(J))/(BX(J+1)-BX(J))` at 1310 is 0/0 → division by zero** |
| **≥ 1.48** | **45** | `ABX(I,46)` and `BX(46)` → **out of bounds by one** |

This sharpens manifest §9.6, which mentions only the `>1.48` case and misses the earlier
division-by-zero window. `BX1 = B/X1 = B/(P/PA)^(1/7)`, so it exceeds 1.42 whenever a
duct-end pressure amplitude is ~42 % above the local mean — reachable on the exhaust
opening step.

**Step-size-dependent (2).** `XA/YC/YS/YE(200)` and `XXA/YP/YI/YV/YB(250)` overflow when
`DC` falls below ~0.8°: `DC = 360·DZ/C` from `STAB`, and `DZ` is the Courant minimum over
four ducts. A finer mesh (larger `KE`) lowers `DC` directly, so this is not hypothetical.
QuickBASIC without bounds checking corrupts memory silently; a MATLAB port would error.
Same class as manifest §9.7, quantified.

**Data-dependent (1).** All duct arrays overflow if `NINT` returns > 20:
`K = round(PL·√(TE/TP)/30)+1`, so `LEP1/LEP2/LTP/LIP > 570 mm` overflows. Confirmed against
114/166–169. Also, `NINT` returning **1** (any pipe shorter than ~15 mm, or `L=0`) makes
`KE1-1=0` and lines **170–173** divide by zero. No guard anywhere.

---

## 4. `SHARED` declarations

### 4.1 Counts

14 `SUB`s; **10** carry `SHARED` (11 statements, `CYLINDER` has two), 4 do not (`FPORT`,
`SETS`, `AREA`, `SHOK`). Union = 32 distinct names (27 scalars + 5 arrays), exactly as
manifest §5 states. Every name in the manifest's table is present in the file with the
stated spelling, and no name is present that the table omits. **The table is accurate; the
"11 of 14" sentence counts statements, not blocks.**

### 4.2 Declared but never used — **DEFECT, 5**

| `SUB` | declaration | used? |
|---|---|---|
| `OUTFLOW` (1340) | `GE` | **no** — the body uses `GAM=1.7847/(TR^.417)` (1342), not `GE` |
| `INFLOW` (1361) | `GE` | **no** — same |
| `BOX` (1385) | `GE` | **no** — the body uses `CV1/CV2 = 269.49*T^0.1667` (1386, 1394) |
| `BOX` (1385) | `CCV` | **no** — `CCV` is set to 718 at line 141 and read *nowhere* in the file |
| `CYLINDER` (1437) | `PA` | **no** — pressures are absolute bars throughout; `PA` never appears in 1439–1495 |

These are harmless individually, but `CCV`+`GE` being declared in `BOX` while the routine
uses a hard-coded `269.49·T^0.1667` is a live trap: a translator "restoring" the ideality
of `SHARED CCV` into `BOX` would change the specific-heat model and every box temperature.

### 4.3 Used but not declared — **DEFECT, 5 names, 2 of them real**

`CYLINDER` uses five names that are in neither its parameter list nor its `SHARED` lists:

| name | lines | assessment |
|---|---|---|
| `HT1` | read **1475**, written **1495** | **real defect** — read-before-write, and the manifest's D15 reasoning about it is inverted (§6.2) |
| `HT2` | 1469/1472/1474 → read 1475, 1495 | **real defect** — not assigned on the `GOTO 90` paths |
| `POLYINDEX` | 1440/1441 → read 1465, 1477 | benign — always assigned before use |
| `DELTAP` | 1487 → read 1491 | benign — always assigned first |
| `DPMAX` | 1491 only | dead diagnostic (D16) |

`HT1` is also the name of the *transfer-port enthalpy* in the main module (written by
`OUTFLOW` at 1005/1006, consumed by `BOX` at 265). Under `STATIC` these are two different
storages, so the file is correct as written. **Any translation that lifts `SUB` locals to
script/global scope aliases them**, and the first closed-cycle step then integrates
`QHT = DC*(~1e6 + HT2)/2` — D15's own failure mode. This is the second-highest-risk item in
the file after the label collision.

---

## 5. `SUB` call sites — arity and order

60 call sites, 14 `SUB`s. Measured argument count vs declared parameter count:

| `SUB` | params | call sites | args at each site | ok |
|---|---|---|---|---|
| `FPORT(HOT,HTDC,PHT,FPRT,FPIP,AK,CC)` | 7 | 963, 1001, 1039 | 7, 7, 7 | ✔ |
| `STAB(A(),B(),K,S,E)` | 5 | 191–194, 199 | 5 ×5 | ✔ |
| `SETS(A(),B(),K)` | 3 | 174–177 | 3 ×4 | ✔ |
| `AREA(DA,DB,KA,KB,DF(),F())` | 6 | 178–181 | 6 ×4 | ✔ |
| `PIPE(KA,KB,A(),B(),DF(),F())` | 6 | 218–221 | 6 ×4 | ✔ |
| `SHOK(A(),B(),KA,KB)` | 4 | 243, 249–252 | 4 ×5 | ✔ |
| `PORT(A,B,P,AK)` | 4 | 225, 228, 231, 233, 236, 964, 1002, 1040 | 4 ×8 | ✔ |
| `NINT(K1,PL,TE,TP)` | 4 | 166–169 | 4 ×4 | ✔ |
| `OUTFLOW(A,B,F,TR,H,C,M,D,CD)` | 9 | 255, 258, 261, 967, 975, 1005, 1006, 1043 | 9 ×8 | ✔ |
| `INFLOW(A,B,F,TR,H,C,M,D,CD)` | 9 | 1044 | 9 | ✔ |
| `BOX(…15…)` | 15 | 262, 263, 265 | 15 ×3 | ✔ |
| `PISTPOS(S,R,C,D,HT,HB)` | 6 | 211, 918, 919, 922, 923, 926, 927 | 6 ×7 | ✔ |
| `PAREA(NP,WP,HP,RT,RB,FP,DP)` | 7 | 114–116 | 7 ×3 | ✔ |
| `CYLINDER(P1,P2,T1,T2,V1,V2,MC,WORK)` | 8 | 264 | 8 | ✔ |

**0 arity mismatches — the manifest's claim is independently confirmed.**

Order checks (semantic, not just counts):

* `PAREA` — `(NEP,WEPM,EXHT,RTEM,RBEM)`, `(NTP,WTPM,TRHT,RTTM,RBTM)`,
  `(NIP,WIPM,INHT,RTIM,RBIM)`: count, width, height, top radius, bottom radius. All three
  consistent. ✔
* `STAB(A(),B(),K,S,E)` — callers pass `(duct, duct, K, snd-speed, mesh-length)`, and the
  body reads `C=60*S/(RPM*E)`. Consistent at all five sites. ✔
* `BOX` — `MIN/MO` are both fed from `OUTFLOW`'s signed `C`, so the `MB2=MB1+DMI-DME` at
  1389 balances only because both use the same signed convention. Preserve the sign
  convention; do not "fix" `MO` to a positive outflow. ✔ as written.
* `PORT`/`OUTFLOW` are called `(B,A)` at 225/231/233/236/255/1005/1006/1043 and `(A,B)`
  elsewhere. This is **not** an error: `PORT(A,B,…)` writes A from B (1312), so the first
  argument is the outgoing characteristic, and the swap follows duct orientation (index 1
  vs index K). Consistent across all 8+8 sites. ✔

**One order anomaly — DEFECT/HINT, 1:**

| line | call | issue |
|---|---|---|
| **1039** | `CALL FPORT(HTDC,HIOT,INHT,FIPRT,FIPRT,AKI,CCI)` | arguments 1 and 2 are **swapped** relative to the sibling calls at 963 (`FPORT(HEOT,HTDC,…)`) and 1001 (`FPORT(HTOT,HTDC,…)`). Result: `FINST=(HIOT−HTDC)/INHT`, i.e. the ramp runs 0→1 as `HTDC` *falls* from `HIOT` to `HIFT`, whereas the other two run 0→1 as `HTDC` *rises*. Self-consistent with the guard at 241 (`HTDC<HIOT`) and with `INHT=HIOT−HIFT`, so it is numerically correct — but it means the inlet port ramps in the opposite sense to the other two, and any translator that normalises the three call sites to one form inverts the inlet port area and `FINST` goes negative (there is no lower clamp on `FINST`, only `IF FINST>1 THEN FINST=1` at 1179). **Do not normalise this call.** |

---

## 6. Constructs that will not translate mechanically

### 6.1 Hard syntax blocker — **BLOCKER, 1**

| lines | text | problem |
|---|---|---|
| **45–47** | `COMPUTER PROGRAM PROG.5.1` / `PROGRAM NAME "ENGINE MODEL NO.1"` / `ProgList.5.1` | **not BASIC statements.** They are a listing title block from the book. Line 47 is not even a valid identifier (`ProgList.5.1`). Any BASIC front-end, and any line-oriented translator, fails on line 45. They must be deleted or turned into `REM`. |

The manifest calls the file "ASCII only, no stray marker lines" (header line 14) and
"complete enough to translate" (§10) without mentioning this block.

### 6.2 `STATIC` — **BLOCKER for correctness, 14 `SUB`s**

All 14 `SUB` statements end in `STATIC` (1177, 1190, 1206, 1218, 1237, 1277, 1299, 1324,
1339, 1360, 1384, 1410, 1422, 1436), written flush against the closing parenthesis
(`)STATIC`).

In QuickBASIC/QBasic, `SUB … STATIC` means **the procedure's local variables are preserved
between calls**. It is the opposite of the file header's assertion (lines 28–31: "starts at
0 on every call") and of the manifest's D7/D15 reasoning. Concretely:

* `CYLINDER`'s `HT1` is a persistent local: `HT1=HT2` at 1495 leaves the last heat rate for
  the next call, so line 1475 integrates **trapezoidally**. D15 explicitly says the printed
  code "integrates heat with a rectangle rule" and that the trapezoidal reading "roughly
  doubles" total heat. On the source as printed, the trapezoidal reading is the one that
  happens. Which one produced Blair's published figures is now an open question that D15
  asserts without evidence.
* `CYLINDER`'s `DPMAX` also persists, so the D16 claim "a diagnostic that is currently
  always `0`" is wrong — it accumulates normally.
* `NINT`'s `KI` is safe either way, because 1328 overwrites it unconditionally before
  1331 uses it. D7's double-increment does **not** occur with automatic locals; it occurs
  only if a translator lifts `KI` to global scope (then `K1` and `KI` alias and the
  increment at 1330 lands twice).

Whatever the intent, the file does not state one behaviour unambiguously: it depends on
whether `STATIC` is honoured. **Freeze this decision before translating**, and in the port
make every `SUB` local explicitly declared with a defined initialisation at the top of the
routine rather than relying on either convention.

### 6.3 Control flow that is not structured

| construct | lines | why it blocks a mechanical rewrite |
|---|---|---|
| `GOSUB`/`RETURN` used as a coroutine with the main loop | 291 → 327…340 → 207 … 205 → 341 → 342 | `PRINTOUT` never returns from its own body; see §1.3. Needs a `printing` flag plus a state machine, not a call. |
| `FOR`/`NEXT` entered and exited by `GOTO` | 188 `FOR KK=1 TO 20000`; 206 `GOTO 500` (leaves the loop without `NEXT`); 430 is re-entered by `GOTO` from 204 and 340; 286 `NEXT KK` | The loop is not a loop. QBasic leaves the `FOR` frame on the stack when 206 jumps out; the print replay re-enters the body at 430 and pops that stale frame at 286. A second `P` request then reaches `NEXT KK` with no frame (`NEXT without FOR`). Even if QBasic tolerates it, no translator can map this to `for`/`while` — it must become an explicit step counter plus a mode variable. |
| `IF … THEN GOTO x ELSE GOTO y` | 266, 280, 283 | fine in itself, but combined with 267/268 the labels appear in the order 427 then 426; a translator that sorts labels by number changes the flow. |

### 6.4 Output, graphics and device statements — portable only with stubs

`PRINT`/`LPRINT` with `USING` **in mid-statement** (306, 312, 317, 400–409, 430–435, 483,
488, 493, 498, 502, 506, 510, 522, 526, 530, 534, 538, 542, 546): QBasic allows
`PRINT "x=";USING"##.#";v`, which has no direct equivalent in any other language.
`LOCATE` (158×), `CLS` (93, 123, 579, 688), `LINE (x,y)-(x,y)` (625–640, 661–663, 749–754,
758–767, 788–792), `WINDOW OUTPUT#2` (339).
`OPEN "LPT1:" FOR OUTPUT AS #2` (336) — a DOS device name; the `[D22]` deletion is correct
but what is left is still a printer handle, not a file.
`LINE INPUT` (411, 437) and `INPUT` with prompts — interactive, no batch equivalent.

### 6.5 File I/O

`OPEN"I",#1,"UFLO"` (70) and `INPUT#1,ABX(I,J)` (77) — fixed-format file read, no
robustness: a missing or short `UFLO` aborts at line 77 with no message.
`OPEN P$ FOR OUTPUT AS #1` / `WRITE#1` (803–810) and `OPEN"I",#1,FIL$` / `INPUT#1`
(818–830) — an 11-field-per-record ASCII format, string fields written **unquoted-comma
separated**. Re-importing depends on `INPUT#` semantics not breaking on the embedded commas
in the strings.

### 6.6 Numerics and typing

* **No `OPTION BASE`** → all arrays base 0; `DIM A(20)` = 21 elements. (§3.1)
* **Default type is `SINGLE`** (7 significant digits). `PI=3.141593` (65) is a single.
  Every untyped variable in the file is single precision; a translation to `double` will not
  reproduce Blair's printed figures bit-for-bit and, in `PIPE`/`SHOK` where the scheme is
  marginally stable, can change the sign of small reflections.
* Type suffixes in use: `100000&` long (301), `100000!` single (372, 402, 405, 469, 1487),
  `2!` (652), `1!` (572), `101325!` (145).
* `^` with a non-integer exponent (1282, 1465, 1477) — `(-x)^(1/7)` returns a QBasic error
  (or a HUGE value) for negative bases; `R3` at 1282 is guaranteed positive by the `R1<1`
  guard, but a `double` port with `pow()` will return `NaN` instead of raising.
* `INT()` is floor for positive and truncation-toward-zero for negative arguments — used at
  655, 656, 755, 781, 1305, 1306, 1328. Any use of `round()` changes mesh counts and
  interpolation indices.

### 6.7 Two label styles in one namespace

Numeric labels (`50`, `305`, `430`, `911`, …) and named labels (`DATOUT:`, `PRINTOUT:`,
`SPLOT1:` …) coexist, and `GOSUB` reaches both. `GOTO 433` / `GOTO 434` jump *forward* into
mid-routine code, and `GOTO 27`-style label order is not monotonic (427 at 267 precedes 426
at 268). A translator must keep a `label → address` map for the whole main module, not a
structured control-flow reconstruction.

### 6.8 Constructs the file does **not** contain — good news

Confirmed absent (grep over the whole file): `OPTION BASE`, `DEF FN`, `DATA`/`READ`/
`RESTORE`, `ON … GOTO`/`ON … GOSUB`, computed `GOTO`/`GOSUB` (no `GOTO (` or `GOTO expr`),
`SELECT CASE`, `WHILE`/`WEND`, `COMMON`, `DECLARE`, `CONST`, `TYPE`, `FUNCTION`, `EXIT`,
`ERASE`, `SWAP`, `RANDOMIZE`, `GOSUB` inside a `SUB`, `RETURN` inside a `SUB`, and **string
arrays** (no `DIM` with a `$`). That removes most of the usual BASIC-to-anything hazards.

---

## 7. Additional findings not in the manifest

**7.1 History-array index alignment (HAZARD, 1).** `RESETTDC` writes `SEFFP/TEFFP/CEFFP/
SRMP/SRVP/EXRP(JJ)` at 424–429 using the `JJ` value *before* `RESETBDC` increments it at
389. Trace: cycle 1 → `RESETTDC` stores at index **0**, then `RESETBDC` increments to 1 and
stores `DELRAT(1)`; cycle 2 → `SEFFP(1)` vs `DELRAT(2)`. So for any cycle `n`, the
scavenging quantities land one slot below the delivery/MEP quantities for the same cycle,
while `DATOUT` (305–317) prints both from the same `JJJ`. Either Blair intended the offset
(skipping the first, non-representative cycle) or the printed table pairs different cycles.
Needs checking against Blair's published table before the port reports anything.

**7.2 Identical branch pairs (NOTE, 4).** 961/962 (`CCE=.8` both), 965/966 (`CDE=.75`
both), 999/1000 (`CCT=.8` both), 1003/1004 (`CDT=.75` both). Dead conditionals left by
`[D13]`. Do **not** "simplify" them: the 1005/1006 pair looks the same but is not —
it passes `TC1` in one branch and `TCC1` in the other. A translator that collapses all four
pairs will collapse that one too.

**7.3 `SPLOT1` dead branch (NOTE, 1).** 557 `NCOUNT=1`, 558 `IF NCOUNT>=2 THEN GOTO 410`
— the test can never be true, so the `RETURN` at 644 is only reachable by falling through
to 580…643. Harmless, but it means `SPLOT1` has no early exit and always redraws all 60-odd
`LOCATE`/`PRINT`/`LINE` statements.

**7.4 `D$` read before assignment on the first run (NOTE, 1).** `SPLOT1` tests
`IF D$="P"` at 578, but `D$` is first assigned at 287, after the integration loop has been
exited. On the first run `D$` is `""`, the test is false, `CLS` runs at 579. Correct by
accident; document it.

**7.5 `POWER(JJ)` as a divisor (HAZARD, 1).** 398 `BSFC(JJ)=FUEL(JJ)*RPS*3600/POWER(JJ)` —
`POWER` is `(CMEP+PMEP-FMEP)*SV*RPS/1000` and goes to 0 if `FMEP` reaches IMEP+PMEP (any
data set with a long stroke and high rpm). Unguarded division by zero; the manifest mentions
it only in the D8 rejection note.

---

## 8. Outside the `.bas` — one artifact defect

`port/uflo.csv` (the regenerated `UFLO` table) has **22 rows × 41 columns = 902 values**,
but lines 75–79 read exactly **21 × 41 = 861** values (`FOR I=1 TO 21`). Rows 0 and 1 of the
CSV are **identical** (the all-1.0 `AKA=0` row, duplicated), so the read is shifted: the
program loads `AKA=0` twice and **never loads the last row** (`AKA=1.0`); `ABX(21,J)` ends up
holding the `AKA=0.95` row. The manifest §8 states "21 rows × 41 columns, 861 values,
audited". Either the CSV has a stray duplicate first row and should lose it, or the program's
loop bound is wrong. This does not affect the verdict on the `.bas`, but the file is not
runnable to Blair's figures until it is resolved.

---

## 9. Defect count

Each finding is counted once, at the class where it is diagnosed; where a finding could sit
in two classes the table says so.

| # | class | blocking | non-blocking defects | hazards / notes |
|---|---|---|---|---|
| 1 | branch targets and label scope | **2** — labels `20`, `50` defined twice | 3 — 205→431, 340→430, gap at 241/242 | 1 — `FINISH` unused (0 unresolved targets out of 84) |
| 2 | variables | **1** — `HT1` read before write | 5 — `CYCTRIP` undefined; `PEX`, `PTR`, `PIR` stale; `HT2` unassigned on a path | 3 — `MSC`/`CSC` no default, `PC1R` conditional, `D$` first run |
| 2b | dead stores | — | **57** — 50 globals + 7 `SUB` locals | — |
| 3 | arrays | 0 | 7 — `ABX` dim2 46/45; `BX` 46/45; `BX1` 1.42–1.48 division by zero; `XA/YC/YS/YE`; `XXA/YP/YI/YV/YB`; `KE>20`; `NINT`→1 | 3 — `YF` exactly at bound, `DF`/`F` unused, `JJ` during replay |
| 4 | `SHARED` | 0 (the `HT1` scope blocker is counted in class 2) | 8 — `GE`×3, `CCV`, `PA` declared-unused; `HT1`, `HT2`, `POLYINDEX` undeclared | 1 — manifest "11 of 14" is 10 |
| 5 | `SUB` calls | 0 | 1 — argument order at 1039 | 0 (**0 arity mismatches out of 60 sites — manifest confirmed**) |
| 6 | non-mechanical constructs | **3** — lines 45–47 not BASIC; `STATIC` semantics; `PRINTOUT` has no return path | 1 — `FOR`/`NEXT` entered and exited by `GOTO` | 2 — graphics/printer/`USING`/device; `SINGLE` typing and numeric semantics |
| 7 | not in manifest | 0 | 1 — `RESETTDC`/`RESETBDC` index offset | 4 — identical branch pairs, `NCOUNT`, `D$`, `POWER` divisor |
| 8 | external artifact | **1** — `UFLO` row count | 0 | 0 |

**Totals: 7 blockers, 25 non-blocking structural defects, plus 57 dead stores (82 defects
if each dead store is counted separately), 14 hazards/notes.**

The 7 blockers are: lines 45–47 (not BASIC); the `20` collision; the `50` collision;
`CYLINDER`'s `HT1`; the undecided `STATIC` semantics; `PRINTOUT`'s missing return path; and
the `uflo.csv` row count.

---

## 10. Verdict

**Not safe to translate as one unit as it stands.** The *merge* is structurally sound —
the manifest's core claims hold: all 84 branch targets resolve, all 60 `CALL`s match their
declarations in count, the `SHARED` table is accurate, no array is used before it is
`DIM`ed, and no BASIC feature outside the "hard" list is present. The problems are not merge
errors; they are (a) one non-BASIC title block, (b) scope assumptions that the source
contradicts, and (c) two orderings that a translator will silently invert.

It becomes safe after five mechanical, verified fixes, in this order:

1. **Delete or `REM` lines 45–47.** They are not BASIC and nothing will parse past them.
2. **Rename the two colliding labels** — `CYLINDER`'s `20` and `50` (1468, 1486) → e.g.
   `C20`/`C50`, and their three references at 1463, 1464, 1467. Without this, a flattened
   label space jumps into `TRPIPDAT`'s input loop and the main data-entry prompt. This is
   `D23`'s warning, now with the exact line numbers.
3. **Fix the order of the pressure ratios**: move 273–278 (`PEX`, `PTR`, `PIR`, and their
   siblings) *above* 237, or accept and document the one-step lag. As written, step 1 of
   every run decides the inlet boundary from `PIR=0`, which selects `OUTFLOW` instead of
   `INFLOW`.
4. **Decide `STATIC` explicitly** and give every `SUB` local a defined value at entry.
   `CYLINDER`'s `HT1`/`HT2`/`DPMAX` behave differently under the two readings, and the
   manifest's D15/D16 conclusions depend on the reading that the keyword contradicts.
5. **Replace the `PRINTOUT` coroutine** (205→431, 340→430, `FOR`/`NEXT` unbalanced) with an
   explicit mode flag before any control-flow lowering.

Then, before the numbers are trusted: add the upper clamp on `BX1` in `PORT` (or clamp the
`J` index), raise `XA`/`XXA` or assert `DC ≥ 0.81`, guard `KE>20` and `KE=1` after `NINT`,
and fix the `uflo.csv` row count.

Do **not** translate as one unit: split at unit boundaries, keep the main module's flat
global namespace explicit as one struct/workspace, and treat the 29 `GOSUB` routines as
state-machine segments rather than functions until fix 5 is done.
