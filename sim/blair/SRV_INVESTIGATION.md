# SRv investigation — is the +25.4 % scavenge-ratio error a transcription defect or a book inconsistency?

**Verdict: book inconsistency — an internal inconsistency in Blair's *printed* listing, not a defect in
our transcription.** The printed page and `blair_clean.bas` agree character for character on every
statement of the block, including `VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1` with no discharge coefficient.
Blair's printed program therefore cannot reproduce Blair's printed output, because the volume path it
integrates is not the same flow as the mass path it integrates two statements later.

**And the fix works.** Restoring the `CDT` that the routine itself sets (`= .75`, both branches) to the
volume increment takes SRv from **1.4225 (+25.4 %) to 1.0797 (−4.8 %)**, power from **13.83 kW to
12.53 kW (+2.7 % vs Blair's 12.2)**, and the case-A mean deviation from **8.71 % to 3.44 %**. Measured,
not estimated — §6.

---

## 1. How the page was read (and why that matters)

| item | value |
|---|---|
| Book | Blair, *The Basic Design of Two-Stroke Engines* (SAE) |
| Printed page | **594**, "Computer Program Appendix – ProgList 5.0", left column |
| PDF page | 307 of 347, `references\Blair, G.P. — The Basic Design of Two-Stroke Engines (SAE).pdf` |
| The page's own content | one CCITT G4 **scanned bitmap** (xref 1869, 1650×1275, ≈150 dpi) **plus** an invisible ABBYY FineReader 8.0 OCR text layer |

The task's hypothesis was that "the text layer may have dropped a term that is visible in print". It
can, and on this very page it does — the OCR layer reads `VOLINC=CT I *FTDUCT*DTM*EXPAND/VC 1`,
`EXPAND=PTR/PC!R`, `SEFF= I -EXP( MSC*SR+CSC)`. So the text layer was **not** used as evidence.
Instead the embedded scan was extracted with `doc.extract_image(1869)` and the block cropped from
those **pixels**, i.e. the render contains no OCR glyphs at all. Renders made through
`page.get_pixmap()` (`blair_p594_full_600dpi.png`) composite the OCR layer over the scan and are kept
only as locators, not as evidence.

**Evidence (read off the bitmap, no text layer):**

* `sim\blair\blair_p594_TRPORTOPEN_scan_8x.png` — the whole model-1 block, left column, 8×
* `sim\blair\blair_p594_block_top_scan_8x.png` — `CALL FPORT…`, `CALL PORT…`, both `CDT=.75` lines
* `sim\blair\blair_p594_pageno_scan_8x.png` — the printed page number **594** (provenance)
* `sim\blair\blair_p594_rawscan.png` — the untouched page bitmap
* `sim\blair\blair_p594_full_600dpi.png` — full page (locator only; OCR overlaid)

What the pixels say (transcribed from `blair_p594_TRPORTOPEN_scan_8x.png`):

```
IF PTR<=PC1R THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TC1,
T1,CT1,MT1,DSCAV,CDT)                      <- "HT1" whose H is clipped at the scan edge
IF PTR>PC1R  THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TCC1,
T1,CT1,MT1,DSCAV,CDT)
EXPAND=PTR/PC1R
VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1
SCRATIO=SCRATIO+MT1*DTM/MREF
IF SCRATIO<0 THEN GOTO 911
SR=SR+VOLINC
SEFF=1-EXP(MSC*SR+CSC)
911 RETURN
```

`VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1`. Four factors. No `CD`, no `CDT`, no second parenthesis —
there is nothing on that line for a transcription to have dropped.

---

## 2. The transcription, verbatim

`C:\Users\malliath\Desktop\engine_sim\port\blair_clean.bas`, lines 1098–1113 (statement block 1103–1112):

```
1098: TRPORTOPEN:
1099: IF PTR<=PC1R THEN CCT=.8
1100: IF PTR>PC1R THEN CCT=.8
1101: CALL FPORT(HTOT,HTDC,TRHT,FTPRT,FTDUCT,AKT,CCT)
1102: CALL PORT(AT(1),BT(1),PC1,AKT)
1103: IF PTR<=PC1R THEN CDT=.75
1104: IF PTR>PC1R THEN CDT=.75
1105: IF PTR<=PC1R THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TC1,HT1,CT1,MT1,DSCAV,CDT)
1106: IF PTR>PC1R THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TCC1,HT1,CT1,MT1,DSCAV,CDT)
1107: EXPAND=PTR/PC1R
1108: VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1
1109: SCRATIO=SCRATIO+MT1*DTM/MREF
1110: IF SCRATIO<0 THEN GOTO 911
1111: SR=SR+VOLINC
1112: SEFF=1-EXP(MSC*SR+CSC)
1113: 911 RETURN
```

Mirrored statement-for-statement in the port at `sim\blair\blair_step.m` 519–542
(`m.VOLINC = m.CT1*m.FTDUCT*m.DTM*m.EXPAND/m.VC1;` at line 536).

---

## 3. Page image vs transcription, character by character

| # | printed (p.594) | `blair_clean.bas` | |
|---|---|---|---|
| 1 | `IF PTR<=PC1R THEN CCT=.8` | 1099 | ✓ |
| 2 | `IF PTR>PC1R THEN CCT=.8` | 1100 | ✓ |
| 3 | `CALL FPORT(HTOT,HTDC,TRHT,FTPRT,FTDUCT,AKT,CCT)` | 1101 | ✓ |
| 4 | `CALL PORT(AT(1),BT(1),PC1,AKT)` | 1102 | ✓ |
| 5 | `IF PTR<=PC1R THEN CDT=.75` | 1103 | ✓ |
| 6 | `IF PTR>PC1R THEN CDT=.75` | 1104 | ✓ |
| 7 | `IF PTR<=PC1R THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TC1,HT1,CT1,MT1,DSCAV,CDT)` | 1105 | ✓ |
| 8 | `IF PTR>PC1R THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TCC1,HT1,CT1,MT1,DSCAV,CDT)` | 1106 | ✓ |
| 9 | `EXPAND=PTR/PC1R` | 1107 | ✓ |
| 10 | **`VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1`** | **1108** | **✓ identical** |
| 11 | `SCRATIO=SCRATIO+MT1*DTM/MREF` | 1109 | ✓ |
| 12 | `IF SCRATIO<0 THEN GOTO 911` | 1110 | ✓ |
| 13 | `SR=SR+VOLINC` | 1111 | ✓ |
| 14 | `SEFF=1-EXP(MSC*SR+CSC)` | 1112 | ✓ |
| 15 | `911 RETURN` | 1113 | ✓ |

Both `TC1` (subsonic branch) and `TCC1` (supersonic branch) are correct in the transcription; both
`CDT=.75` constants are correct; the `<=`/`>` branch structure is correct. **Nothing was lost.**

Corroboration that this is not a one-off transcription: the two independent transcriptions in the repo
that reach this block (`blair_prog52_basic.txt` 851 & 870, `blair_subroutines_basic.txt` 180 & 200)
both read `VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1`. (`blair_prog51_basic.txt` is the main program only — it
calls `TRPORTOPEN` at line 184 and does not contain the body.)

So the block is closed: **the missing term is missing from the book.**

---

## 4. But the book is inconsistent with itself — three ways

### 4.1 The theory says the volume and the mass use the *same* ΔVF

Chapter 5, §5.1.5, printed pp. 217–219 (PDF pp. 117–119), read off the scan
(`blair_p218_AVF_AMF_scan_8x.png`, `blair_p218_SRv_eq510_scan_8x.png`, `blair_p219_SRv_text_scan_6x.png`):

> "Volume increment of charge exiting transfer duct,
> **ΔVF = Δt·CGt1·Ft1**  (5.1.6)
> Mass increment of fresh charge exiting transfer duct,
> **ΔMF = Dt1·ΔVF**  (5.1.7)
> The value of CGt1 is the superposition particle velocity at the first mesh point in the transfer
> duct, Ft1 is the duct area at that point, and Dt1 is the superposition density at the same location."

> "Mass increment … SRt = Σ[ΔMF·Δt/Msr]  (5.1.8)"

> "…the first logical approach to estimate scavenge ratio by volume, SRv, would be to sum the
> increments of ΔVF … of the instantaneous cylinder volume at that crank angle:
> **SRv = Σ[ΔVF/VC1]**  (5.1.10)
> … the first logical assumption for an expansion ratio, EXPAND, for this entering fresh charge would be
> **EXPAND = Pt1/PC1**  (5.1.11)
> The ensuing modification to Eq. 5.1.10 is then given by:
> **SRv = Σ[EXPAND·ΔVF/VC1]**  (5.1.12)"

Eq. 5.1.7 is the whole case: mass is the **density times the same volume increment**. ΔVF is the
physical volume that crossed the port; ΔMF is its mass. One volume, one mass, no coefficient between
them. There is no place in Eqs. 5.1.6–5.1.12 for a discharge coefficient, and none appears.

### 4.2 But his `SUB OUTFLOW` puts the Cd only on the mass

Printed p. 310 (PDF p. 310), read off the scan (`blair_p310_OUTFLOW_scan_8x.png`):

```
SD=SQR(GAM*GK*TREF)
C=SD*(A-B)/(GAM-1)          <- inviscid: the isentropic wave relation, no Cd
H=CP*TR
D=AB^.5*PA/(GK*TREF)
M=CD*C*F*D                  <- Cd applied here, and only here
```

`C` is returned *unreduced*; the contraction is applied afterwards, to `M` alone. `TRPORTOPEN`
then does:

* `CALL OUTFLOW(...)` → `CT1` (inviscid velocity), `MT1 = CD·C·F·D` (Cd-reduced mass)
* `SCRATIO = SCRATIO + MT1*DTM/MREF` → **mass accumulator uses the Cd-reduced flow**
* `VOLINC = CT1*FTDUCT*DTM*EXPAND/VC1` → **volume accumulator uses the inviscid flow**

Substituting into Blair's own Eq. 5.1.7: the code's `AMF` is `CD·Dt1·ΔVF`, not `Dt1·ΔVF`. The two
accumulators in the same subroutine are integrating **different flows**, off by 1/Cd. That is exactly
the 19 % excess in the ratio:

| | model | Blair | |
|---|---|---|---|
| SRv | 1.4225 | 1.134 | +25.4 % |
| SRm | 0.9194 | 0.874 | +5.2 % |
| **SRv/SRm** | **1.547** | **1.2975** | **+19.2 %** |

The mass path is the one that is calibrated (SRm within 5 %, DR within 4 %), so the defect is in the
volume path — a missing `CDT` — not in `SUB OUTFLOW`.

### 4.3 The alternative readings, and why they fail

* *"No Cd anywhere — both paths should be inviscid."* Then SRm would be ~33 % high, not 5 %. Refuted
  by the port's own mass agreement and by `M=CD*C*F*D` being printed in three places.
* *"`CDT` should be .9, not .75."* Already tested in `CD_INVESTIGATION.md` §1: SRv +25.4 % → +20.3 %,
  SRm +5.2 % → +22.9 %, mean deviation 8.71 % → 13.07 %. Refuted.
* *"`EXPAND` is wrong."* It is `PTR/PC1R`, i.e. Eq. 5.1.11 with the transfer-duct pressure — correct,
  and the book states all Chapter 5 examples use the 5.1.11 form ("*All of the program examples
  presented within this chapter are computed using the version of EXPAND presented in Eq. 5.1.11*",
  p. 220). Not it.

---

## 5. So: which is it?

**Book inconsistency.** Specifically an internal inconsistency between

* the printed theory (Eqs. 5.1.6/5.1.7: `ΔMF = Dt1·ΔVF`), and
* the printed code (`AMF = CD·Dt1·ΔVF` while `SRv` integrates `ΔVF` un-Cd'd),

i.e. the printed program omits, from one of a paired set of statements, the discharge coefficient that
the other applies. Blair's Fig. 5.9 numbers were evidently produced by a build in which the two paths
were consistent (or with an effective factor of ~0.84–0.85 — see §6); they are not reproducible from
the listing as printed. The type of defect is the same as the three already-known "book-page repairs"
in this port (`GAM=1.7847/TR^.417` for `.0417`, `CP=481.17*TR^.25` for `.125`, the `HEAT` line): the
book, not the transcriber, is wrong.

---

## 6. Does reinstating the Cd fix SRv? Measured

Method: `sim\blair\blair_step.m` was **not** edited. A copy was made in
`%TEMP%\opencode\srvpatch\blair_step.m` with the single line 536 replaced by

```matlab
cdv_str = getenv('SRV_CD'); if isempty(cdv_str), cdv = 1; else, cdv = str2double(cdv_str); end
m.VOLINC  = cdv*m.CT1*m.FTDUCT*m.DTM*m.EXPAND/m.VC1;
```

that copy placed first on the path, and the QUB 400 case-A sweep run through
`blair_validate`'s 16 published rows (`blair_run(blair_init(deck),3000,1.0)`, ≈1.3 s per point).
`cdv = 1` reproduces the committed baseline exactly (13.8261 kW, SRv 1.4225), so the harness is sound.

| `cdv` in `VOLINC` | power kW | SRv | SRm | SE | CE | BSFC g/kWh | pmax bar | mean dev |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **1.00 (as printed / as ported)** | 13.826 | 1.4225 | 0.9194 | 0.888 | 0.482 | 424.9 | 38.90 | **8.71 %** |
| 0.90 | 13.396 | 1.2858 | 0.9229 | 0.859 | 0.468 | 440.6 | 38.08 | 6.21 % |
| 0.85 | 13.039 | 1.2137 | 0.9248 | 0.841 | 0.460 | 453.9 | 37.51 | 4.69 % |
| 0.80 | 12.742 | 1.1441 | 0.9269 | 0.821 | 0.451 | 465.8 | 36.99 | 3.12 % |
| **0.75 (the `CDT` the routine sets)** | **12.534** | **1.0797** | 0.9304 | 0.801 | 0.442 | 475.8 | 36.47 | **3.44 %** |
| *Blair, Fig. 5.9* | *12.2* | *1.134* | *0.874* | *0.818* | *0.430* | *464* | *35.8* | — |

**Answer to the question asked: yes, substantially.** With the coefficient restored:

* SRv: **1.4225 → 1.0797**, error **+25.4 % → −4.8 %** (four-fifths of the log-error gone);
* power: **13.83 → 12.53 kW**, i.e. **+13.3 % → +2.7 %** against Blair's 12.2 kW;
* case-A mean |model/Blair−1|: **8.71 % → 3.44 %** (−60 %);
* SRm degrades slightly, +5.2 % → +6.5 % — the trade `PORT_DIFF.md` §6 anticipated, but the net is
  strongly positive.

Two honest caveats:

1. **It over-corrects by ~5 %.** Blair's 1.134 sits between `cdv=0.80` (1.1441, +0.9 %) and `cdv=0.75`
   (1.0797, −4.8 %). The factor that best fits *both* published numbers is ≈0.84–0.85 — which is
   exactly what the published ratio implies (1.547 × f = 1.2975 → f = 0.839).
2. **No single factor can be exact**, because SRm is independently +5–6 % high. Forcing SRv to 1.134
   would just move the error into SRv/SRm. The correct statement is: the volume path's *structure* is
   wrong by a factor of order 1/Cd; the residual few percent belongs to the mass side.

---

## 7. What to do

1. **Make one edit, and label it a book-page repair, not a transcription fix.**
   In `sim\blair\blair_step.m` line 536:

   ```matlab
   % BOOK-PAGE REPAIR (not a transcription fix). Blair p.594 prints
   %   VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1
   % but §5.1.5 Eq.5.1.6/5.1.7 define dMF=Dt1*dVF (mass = density * the same volume
   % increment) and SUB OUTFLOW (p.310) applies CD only to M=CD*C*F*D. Without CDT the
   % two accumulators in this routine integrate flows differing by 1/CD.
   m.VOLINC  = m.CDT*m.CT1*m.FTDUCT*m.DTM*m.EXPAND/m.VC1;      % 1108 + missing CDT
   ```

   Use `m.CDT`, not a literal: the routine sets it two statements earlier and both branches set `.75`.

2. **Do not tune the coefficient to 0.80.** It scores 3.12 % vs 3.44 %, but 0.80 is not a number in the
   listing; it is curve-fitting one published point. If the residual ever needs a justification, it has
   to come from the mass side, not from a fudged volume coefficient.

3. **Record the deviation loudly** in `PORT_DIFF.md`/`BUILD_MANIFEST.md` next to GAM/HEAT/CP, with the
   page-594 citation, so no later reviewer "verifies" 1108 against the book and reverts it. Note that a
   statement-by-statement diff against the book will *always* flag this line as a mismatch — that
   mismatch is the intended state.

4. **Expect the rest of the cascade to move with it** (SE 0.888→0.801, CE 0.482→0.442, BSFC 424.9→475.8,
   pmax 38.90→36.47). Re-baseline `check_qub400` and any RX 135 work that inherited the old SE/CE.

5. **Fix the framing in the ticket: 13.83 kW vs 12.2 kW is +13.3 %, not 8.7 %.** The 8.7 % in
   `PORT_DIFF.md` §6 is the mean |model/Blair − 1| over the 16 published rows, not the power error.

---

## 8. Evidence files

| file | what it shows |
|---|---|
| `sim\blair\blair_p594_TRPORTOPEN_scan_8x.png` | **primary evidence** — the model-1 `TRPORTOPEN` block off the printed page 594 bitmap; `VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1` with no Cd |
| `sim\blair\blair_p594_block_top_scan_8x.png` | `CALL FPORT…`, `CALL PORT…`, and both `CDT=.75` lines |
| `sim\blair\blair_p594_pageno_scan_8x.png` | printed page number 594 (provenance) |
| `sim\blair\blair_p594_rawscan.png` | the whole page bitmap, unmodified |
| `sim\blair\blair_p594_full_600dpi.png` | full page, OCR layer overlaid — locator only, not evidence |
| `sim\blair\blair_p310_OUTFLOW_scan_8x.png` | `C=SD*(A-B)/(GAM-1)` then `M=CD*C*F*D` — the Cd lives on the mass only |
| `sim\blair\blair_p218_AVF_AMF_scan_8x.png` | Eq. 5.1.6 `ΔVF=Δt*CGt1*Ft1`, Eq. 5.1.7 `ΔMF=Dt1*ΔVF` |
| `sim\blair\blair_p218_SRv_eq510_scan_8x.png` | Eq. 5.1.10 `SRv=Σ[ΔVF/VC1]` |
| `sim\blair\blair_p219_SRv_text_scan_6x.png` | Eq. 5.1.11 `EXPAND=Pt1/PC1`, Eq. 5.1.12 `SRv=Σ[EXPAND*ΔVF/VC1]` |

## 9. Reproducing

```matlab
addpath('...\sim\blair');  addpath('%TEMP%\opencode\srvpatch');   % patched copy first
deck = '...\port\QUB400_INPUT.dat';
for f = [1 0.9 0.85 0.8 0.75]
    setenv('SRV_CD', num2str(f));
    r = blair_run(blair_init(deck), 3000, 1.0).results;
    fprintf('%4.2f  P=%7.4f  SRv=%7.4f  SRm=%7.4f  SE=%6.4f\n', f, r.power_kW, r.srv, r.sr, r.SE);
end
setenv('SRV_CD','');
```

The patched `blair_step.m` and the driver scripts live in
`C:\Users\malliath\AppData\Local\Temp\opencode\srvpatch\` and `%TEMP%\opencode\srv{A,B,C}.m`;
the repository tree was not modified by this investigation.
