# CLEAN_LOG — the five fixes applied to `blair_full.bas`

Output: `port/blair_clean.bas` (1607 lines). Checked by `port/_verify_clean.py`
(65 main-module labels, 70 main-module branches, 0 unresolvable, 0 duplicate;
7 CYLINDER-local labels, 10 branches, 0 unresolvable).

Nothing else was touched. The 25 non-blocking defects of `VERIFY_STRUCTURE.md`
§9 are left exactly as printed, including the D15/D16/D19/D25/D26 comments, the
duplicate `STAB`/`SHOK` calls, the missing inlet cascade at `HTDC=HIOT`, the
unclamped `BX1` in `PORT`, and the `RESETTDC`/`RESETBDC` index offset.

**Line-number convention.** `full:N` = line N of `blair_full.bas`, `clean:N` =
line N of `blair_clean.bas`. The clean file is not line-aligned with the full
one: FIX1 removes 2 net lines at the top, so for every line after the old 47,
`clean = full - 2 + (adjustments from the other four fixes)`. Cross-reference
the `full:` numbers below, not the clean ones, against `VERIFY_STRUCTURE.md`.

A machine-readable full diff is `port/_clean_diff.txt`
(`git diff --no-index port/blair_full.bas port/blair_clean.bas`). The hunks that
matter are reproduced below.

---

## FIX 1 — delete the book's listing title block — **applied**

`full:45-47` were not BASIC statements (`COMPUTER PROGRAM PROG.5.1`,
`PROGRAM NAME "ENGINE MODEL NO.1"`, `ProgList.5.1`). `ProgList.5.1` is not even
a legal identifier. Any parser dies on `full:45`, so this was blocker 1 of 7.

Before (`full:44-48`):

```
REM ==========================================================================
COMPUTER PROGRAM PROG.5.1
PROGRAM NAME "ENGINE MODEL NO.1"
ProgList.5.1
REM PROGRAM Prog.5.1
```

After:

```
REM ==========================================================================
REM [FIX1] deleted: the book's listing title block (blair_full.bas 45-47)
REM PROGRAM Prog.5.1
```

The two `REM` lines Blair prints in place of the title block are kept: they are
the legal form of the same three lines, so no information is lost. Net effect:
-2 lines.

**Physics: unchanged.** These lines assign nothing.

---

## FIX 2 — rename CYLINDER's colliding labels `20` and `50` — **applied**

`full:1468` (`20 IF DEGC>PEAK THEN GOTO 60`) and `full:1486`
(`50 WORK=(P1+P2)*(V2-V1)/2`) collide with the main module's `20`
(`TRPIPDAT`, `full:849`) and `50` (the main data menu, `full:89`). Flattened,
`full:1467`'s `GOTO 50` lands in the interactive `INPUT "RESPONSE FOR NEW
DATA…"` prompt in the middle of the integration loop. This was blockers 2 and 3.

Renamed at both definitions and all three references:

| full: | before | after |
|---|---|---|
| 1463 | `IF DEGC<IGN THEN GOTO 20` | `IF DEGC<IGN THEN GOTO C20` |
| 1464 | `IF DEGC<=BURNEND THEN GOTO 20` | `IF DEGC<=BURNEND THEN GOTO C20` |
| 1467 | `GOTO 50` | `GOTO C50` |
| 1468 | `20 IF DEGC>PEAK THEN GOTO 60` | `C20: IF DEGC>PEAK THEN GOTO 60` |
| 1486 | `50 WORK=(P1+P2)*(V2-V1)/2` | `C50: WORK=(P1+P2)*(V2-V1)/2` |

The definitions take a colon (`C20:`) because QBasic requires one on a named
label; a *reference* to a named label is written without it. CYLINDER's other
five labels (`30 60 70 80 90`), PIPE's (`23 33 44 55`) and SHOK's (`26 56`) are
unique in the whole file and are left alone. Also updated: the header note at
`full:23-26` and the CYLINDER banner at `full:1432-1434`, so neither still
claims the file is safe to flatten as printed.

**Physics: unchanged.** Label renaming only.

---

## FIX 3 — move `PEX PIR PTR PTRO PEXP PEXT` above their first use — **applied**

`full:273-278` computed the port pressure ratios at the *bottom* of the loop
body; their consumers are the port open/shut routines called at `full:237-242`.
As printed:

* on step 1 of every run all six are 0, so `INPORTOPEN`'s `IF PIR<=PCC1R` is
  true and the `OUTFLOW` branch (not `INFLOW`) is taken unconditionally;
* on every later step they are one step stale, and `PIR` alone chooses between
  `OUTFLOW` (`full:1043`) and `INFLOW` (`full:1044`) — different equations.

Before (`full:236-237` and `full:270-279`):

```
CALL PORT(BT(KT),AT(KT),PCC1,AK)
IF HTDC<=HEOT THEN GOSUB EXPORTSHUT
...
PBR=PB2/PA
PEX=((AE(1)+BE(1))/2)^7
PIR=((AI(1)+BI(1))/2)^7
PTR=((AT(1)+BT(1))/2)^7
PTRO=((AT(KT)+BT(KT))/2)^7
PEXP=((AE(KE1)+BE(KE1))/2)^7
PEXT=((AET(1)+BET(1))/2)^7
IF ANGD>EPC THEN GOTO 310
```

After (`clean:303-316`, `clean:354-356`):

```
CALL PORT(BT(KT),AT(KT),PCC1,AK)
REM [FIX3] PEX PIR PTR PTRO PEXP PEXT moved here from 273-278, ...
PEX=((AE(1)+BE(1))/2)^7
PIR=((AI(1)+BI(1))/2)^7
PTR=((AT(1)+BT(1))/2)^7
PTRO=((AT(KT)+BT(KT))/2)^7
PEXP=((AE(KE1)+BE(KE1))/2)^7
PEXT=((AET(1)+BET(1))/2)^7
IF HTDC<=HEOT THEN GOSUB EXPORTSHUT
...
PBR=PB2/PA
REM [FIX3] PEX PIR PTR PTRO PEXP PEXT now computed above ...
IF ANGD>EPC THEN GOTO 310
```

**Placement is the last safe point.** The six must come *after* the four `PIPE`
calls (`full:218-221`) and the five `PORT` calls (`full:225-236`), because both
rewrite the amplitudes they read — `PORT` assigns `AE(KE1)`, `AET(1)`,
`AT(KT)`, `AI(1)`… through `A=2*X1*ABX1-B` at `full:1312`. They must come
*before* `EXPORTSHUT/EXPORTOPEN/TRPORTSHUT/TRPORTOPEN/INPORTOPEN/INPORTSHUT`
(`full:237-242`). `clean:316` is therefore the only legal insertion point.

**Physics: intentionally changed**, and this is the one fix that changes numbers.
On step 1 the inlet boundary now sees the real `PIR` instead of 0; on all later
steps it sees the current step's value rather than the previous step's.

`PTRO`, `PEXP`, `PEXT` are dead (`VERIFY_STRUCTURE.md` §2.4); they are moved with
the group so the six statements stay together, not because they are read.

---

## FIX 4 — freeze the STATIC decision — **applied**

All 14 `SUB` statements end in `STATIC` (`full:1177, 1190, 1206, 1218, 1237,
1277, 1299, 1324, 1339, 1360, 1384, 1410, 1422, 1436`), but the assembled
header at `full:28-31` claimed the opposite: *"Every variable a SUB uses … is
LOCAL and starts at 0 on every call."* Two contradictory statements in one file,
and the answer decides the heat release (`VERIFY_STRUCTURE.md` §6.2, blocker 5).

**Decision frozen: STATIC is honoured. A SUB's locals persist between calls.**
They are zeroed once at program start, never re-zeroed on entry, and never alias
a main-module variable of the same name.

Before (`full:28-31`):

```
REM  ALL SUBs ARE STATIC. Every variable a SUB uses that is not in its parameter
REM  list and not in its SHARED list is LOCAL and starts at 0 on every call.
REM  Two of Blair's routines depend on that: CYLINDER's HT1 (see [D15]) and
REM  NINT's KI (see [D7]). Do not "helpfully" make them global.
```

After (`clean:30-59`): a 30-line `REM` block stating the decision and listing
every consequence that a translator must carry:

* `CYLINDER`'s `HT1` (read `full:1475`, written `full:1495`) is the previous
  call's `HT2`, so `QHT=DC*(HT1+HT2)/2` is the **trapezoidal** rule. Under
  automatic locals it would be a rectangle rule (`HT1=0`) and total heat
  release changes by roughly a factor of two — hence `PMAX`, `TKMAX`, `IMEP`.
* `CYLINDER`'s `HT2` is assigned only on the combustion path (`full:1469, 1472,
  1474`); on either `GOTO 90` path it keeps the previous call's value. Only
  STATIC makes that well-defined.
* `CYLINDER`'s `IGN BURNEND TAILDEG PEAK S1 S2 S3 QMAX HEAT MAIR` are read
  without being re-assigned on any call with `DEGC>EPC+5` (`full:1442` jumps
  past their block to `30`), so they too are the previous call's values.
* `CYLINDER`'s `DELTAP` is written only when `P2>P1` (`full:1487`) and then
  compared with the persistent `DPMAX` (`full:1491`). `VERIFY_STRUCTURE.md`
  §4.3 calls `DELTAP` "benign — always assigned before use"; under the frozen
  STATIC reading that is **not** true, and the port keeps both persistent.
* `NINT`'s `KI` is a local, so `K1=KI+1` (`full:1331`) increments the caller's
  mesh count exactly once. If `KI` were lifted to global scope the inlet call
  `CALL NINT(KI,…)` would alias it and increment twice (`[D7]`).
* The port must **not** add `HT1` to the shared set: the main module already
  uses `HT1` as the transfer-port enthalpy (written `full:1005/1006`, consumed
  by `BOX` at `full:265`). Aliasing the two is `[D15]`'s failure mode.

Also corrected the header claim that "BLOCKERS: none in the code" (`full:33`)
to name the five fixes and the external `UFLO` artefact.

**Physics: unchanged in BASIC.** This fix records the semantics the keyword
already had. It is decisive for the MATLAB port, which implements the persistent
locals explicitly (`sim/blair/sub_cylinder.m`).

---

## FIX 5 — replace the PRINTOUT / FOR replay with an explicit mode flag — **applied**

The construct removed (`full:188-206, 286-293, 327-342, 578`):

| full: | statement | problem |
|---|---|---|
| 205 | `IF CYCLE=CYCLEP+1 THEN GOTO 431` | jumps **into** `PRINTOUT`'s body at 341, past its own `GOTO 430` |
| 340 | `GOTO 430` | leaves `PRINTOUT` without returning; its `GOSUB` frame stays open until 342 |
| 188/286 | `FOR KK=1 TO 20000` … `NEXT KK` | the loop is left by `GOTO 500` (206) and re-entered at 430, so a second `P` reaches `NEXT KK` with no `FOR` frame |
| 578 | `IF D$="P" THEN GOTO 439` | `D$`, the *menu answer*, is silently doing duty as a mode flag |

So `PRINTOUT` had no return path of its own and the loop was not a loop. This
was blockers 6 and 7 (the seventh, the `UFLO` row count, is external and is
handled by `sim/blair/load_uflo.m`, not here).

**What the original actually did.** `CYCLEP = CYCLESTOP+10 = 17`. The run ends
at `CYCLE=7`; `P` then set `CYCLE=17`, printed the tables, opened `LPT1:`,
jumped to 430 and computed **one further revolution** with every screen
`CLS` suppressed (`D$="P"` → `GOTO 439`), drawing that revolution to the
printer, then closed the printer at 431 and returned. Its results were
discarded (`JJ` was not advanced into the history).

**Replacement.** `PRINTMODE` is now the flag, the loop has one entry point and
no `FOR/NEXT`:

```
PRINTMODE=0
KK=0
CYCLELOOP:
KK=KK+1
DZ=1
...
IF ANGD>360+EPO THEN CYCLE=CYCLE+1
IF PRINTMODE=1 AND CYCLE=CYCLEP THEN GOTO 430
IF PRINTMODE=1 AND CYCLE=CYCLEP+1 THEN GOTO 431
IF PRINTMODE=0 AND CYCLE=CYCLESTOP THEN GOTO 500
430 IF ANGD>360+EPO THEN ANGD=ANGD-360
...
IF KK>=20000 THEN GOTO 500
GOTO CYCLELOOP

500 INPUT "…";D$
IF D$="R" THEN GOTO 50
IF D$="F" THEN GOSUB FILING
IF D$="Q" THEN GOTO 501
IF D$="P" THEN GOSUB PRINTOUT
IF PRINTMODE=1 THEN GOTO CYCLELOOP     ' [FIX5] start the replay
GOTO 500
501 END
```

`PRINTOUT` now ends its printing part with `PRINTMODE=1 : KK=1 : IF
ANGD>360+EPO THEN ANGD=ANGD-360 : RETURN` and the replay *ends* at

```
431 CLOSE #2
PRINTMODE=0
GOTO 500
```

so `PRINTOUT` is a normal subroutine that returns to its caller, and the replay
is a mode of the main loop entered and left at named points. `SPLOT1`'s
`IF D$="P" THEN GOTO 439` became `IF PRINTMODE=1 THEN GOTO 439`. The menu
answer is no longer overloaded.

**Behaviour preserved:** `P` still prints the data tables, still computes one
further revolution (`CYCLE=17`) with the plots going to the printer, and still
returns to the menu. The three exit tests stay at the head of the body, where
`full:204-206` had them, so the number of steps computed in a normal run is
unchanged.

**Behaviour changed, in the replay only:** the replay revolution is now entered
at `CYCLELOOP` instead of mid-body at `430`. That executes the eight statements
the old entry skipped (`DZ=1`, `NN=NN+1`, the five `STAB` calls, `DZ=.99*DZ`,
`DEG=DEG+DC`), so the printed plot is drawn one `DC` of crank angle ahead of the
old one and with a freshly computed `DZ`. No stored result changes: the tables
are printed *before* the replay, and `JJ` never advances past the run's value.
`PRINTOUT`'s `IF ANGD>360+EPO THEN ANGD=ANGD-360` performs the wrap that the
old `GOTO 430` performed, so the replay does not immediately trip
`CYCLE=CYCLEP+1`.

**Physics: unchanged in a normal run.** The replay is display-only.

---

## What was deliberately NOT changed

Per the brief, none of the 25 non-blocking defects was touched even where it is
tempting. The ones a reader will notice, with a one-line reason each:

| `VERIFY_STRUCTURE.md` | item | why left |
|---|---|---|
| §1.4 | inlet cascade has no case for `HTDC=HIOT` | one step per cycle at most; no translation blocker |
| §2.1 | `CYCTRIP` never assigned | dead in BASIC (`0`); the port keeps it as an explicit 0 |
| §2.2 | `PC1R` reused across `EXPORTOPEN`→`TRPORTOPEN` | safe for every data set where the transfer port opens after the exhaust |
| §2.3 | `HT2` unassigned on the `GOTO 90` paths | made well-defined by FIX4, not "fixed" |
| §2.4 | 57 dead stores | no effect on any result |
| §2.5 | `MSC`/`CSC` have no default | the port raises an error instead of silently returning `SEFF=0` |
| §3.2 | no upper clamp on `BX1` in `PORT` | the port asserts instead of corrupting memory |
| §3.2 | `XA`/`XXA` overflow at `DC<0.81°` | plot-only; not translated |
| §5 | `FPORT` argument order swapped at 1039 | numerically correct as printed; do **not** normalise |
| §7.1 | `SEFFP` stored one index below `DELRAT` | the port keeps the offset and documents it (see below) |
| §7.2 | four identical `IF/IF` branch pairs | `1005/1006` is not identical; do not collapse |
| §8 | `uflo.csv` has 22 rows | handled outside this file by `sim/blair/load_uflo.m` |

### The one index the port had to resolve

`RESETTDC` writes `SEFFP/TEFFP/CEFFP/SRMP/SRVP/EXRP(JJ)` at `full:424-429`
using `JJ` **before** `RESETBDC` increments it at `full:389`. In BASIC the first
cycle therefore lands in slot **0** (legal, and never printed) and cycle *n*'s
scavenging data sits one slot below cycle *n*'s MEP data, while `DATOUT` prints
both from the same `JJJ`. MATLAB has no index 0, so `blair_clean.bas` is *not*
changed (it must stay runnable in BASIC) but the port stores scavenging data at
`JJ+1`, i.e. keyed to the cycle number. That is documented in
`sim/blair/blair_step.m` and `blair_run.m`; it changes which cycle a printed row
belongs to, never the physics.

Cross-checked against the book page image (p.584): `RESETBDC`'s own screen
display reads `SEFFP(JJ-1)` — Blair corrects the offset himself when he shows
the numbers, so the physically correct pairing is cycle *n* with `SEFFP(n-1)`.
The port's `JJ+1` storage reproduces exactly that pairing.

---

## Appendix — three transcription defects found while translating

**Not fixed here.** `blair_clean.bas` keeps every one of them, because Job 1 was
five named fixes and "do not change any physics". They are recorded because the
MATLAB port deviates from the `.bas` on exactly these three statements, and a
reader diffing the two must know why. Each was settled by rendering the book
page from `references/Blair, G.P. — The Basic Design of Two-Stroke Engines
(SAE).pdf`, not by inference.

| # | `clean:` | transcribed (and in this file) | printed in the book | why it matters |
|---|---|---|---|---|
| 1 | 1341, 1362 | `CP=481.17*TR^.25` | `CP=481.17*TR^.125` | cp at 300 K is 2003 J/kgK instead of 982 — the enthalpy fed to `BOX` is 2–3× too large, against `cv+R = 984` |
| 2 | 1342, 1363 | `GAM=1.7847/(TR^.417)` | `GAM=1.7847/(TR^.0417)` | GAM = 0.073 at 2000 K, so `GAM-1` is **negative**: every `OUTFLOW`/`INFLOW` velocity and mass flow reverses sign and the model cannot run |
| 3 | 1452 | `HEAT=BEFF*CVAL*MAIR^TAFB` | `HEAT=BEFF*CVAL*MAIR/TAFB` | MAIR ≈ 2e-4 kg raised to the 13th power is 1e-48 J: **no combustion at all**, in every cycle |

Evidence: book page 310 (Computer Program Appendix – ProgList 5.0) prints
`CP=481.17*TR^.125` and `GAM=1.7847/(TR^.0417)` inside both `OUTFLOW` and
`INFLOW`; page 603 prints `HEAT=BEFF*CVAL*MAIR/TAFB`. The transcription notes in
`port/blair_prog52_basic.txt` already record the third one as repair **D9**
(1285-1294) with the same arithmetic argument; the merge into `blair_full.bas`
lost it. All three are OCR losses of a `0` or a `/`, and in this scan `/` and
`^` are the same glyph (`A`), which is why the operator was misread.

Repaired only in `sim/blair/sub_flow.m` and `sim/blair/sub_cylinder.m`, with
the original token quoted in the comment beside each. `VERIFY_STRUCTURE.md`
does not list them: they are not structural defects, and the audit did not
re-derive the thermodynamics.

The same page images confirm several things the audit could only infer:
`IF DEGC>IGN THEN GOTO 20` (the illegible line at `clean:1564`, dead under any
reading), `TRM1` assigned twice, `CALL FPORT(HTDC,HIOT,INHT,FIPRT,FIPRT,…)` with
its arguments deliberately swapped, and `TC1` (not `TCT`) in both
`EXPORTOPEN` `OUTFLOW` branches.

