# Independent verification — `uflo.csv` against Blair, *The Basic Design of Two-Stroke Engines*, Data Bank 2.0

**Verifier:** independent subagent, blind (source re-read before the transcription was inspected)
**Date:** 2026-10-29
**Transcription under test:** `port/uflo.csv` — 22 rows × 41 columns
**Source of record:** Blair, G.P., *The Basic Design of Two-Stroke Engines* (SAE), "COMPUTER DATA BANK 2.0 / DATA FILE 'UFLO'", `ProgList2.0`

---

## 0. Up-front corrections to the brief

* **The source path in the brief does not exist.** The filename uses an **em dash** (U+2014), not a hyphen:
  `references\text\Blair,_G.P._—The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`.
  The requested lines 20132–20359 are correct for that file and were used.
* The section does **not** contain 22 banks. It contains **21 banks**: `AK = 0, .05, .10, … .95, 1.0`.
  The CSV's 22 rows are therefore *one axis row (BX) + 21 banks*, which is what the brief describes.
* **Row 1 and row 2 being identical is correct, not a duplicated header.** The source states:
  > `The ABX(I=1,J) value is BX(J) in the program and is the value of B1/XC shown in Fig.2.7.`

  so bank `AK=0` *is* the `BX` row by definition. A consumer script must not discard row 2 as a stray header.
  (Worth adding a comment to the CSV generator: rows 1 and 2 are legitimately equal.)

**Structure confirmed:** 41 columns; `J=21` is `Bl/XC = 1.0`, and all 21 banks carry exactly `1.00000` there.
Column 1..41 = 0.60…1.40 step 0.02. 21 × 41 = 861 numeric cells.

---

## 1. Task 1 — four banks re-extracted by hand

Re-read from the source text, cell by cell, then diffed mechanically (`_verify_blind.py`) at 5 decimal places.

| Bank | Cells compared | Mismatches |
|---|---|---|
| AK = 0.00 (`BX`) | 41 | **0** |
| AK = 0.20 | 41 | **0** |
| AK = 0.50 | 41 | **0** |
| AK = 1.00 | 41 | **0** |
| **Total** | **164** | **0** |

Notes on how the OCR had to be read (all resolved unambiguously, none of them an issue for the CSV):

* separators are frequently lost, merging tokens: `.62..64` = `.62 , .64`, `1.2.1.22` = `1.2 , 1.22`.
* `AK=2` → `AK=.20`, `AK=25` → `AK=.25`, `AK=3` → `AK=.30`, `AK=75` → `.75`, `AK=80` → `.80`, `AK=.l` → `.10`.
* page-break splits: `AK=.20` ends at `1.36807`; `AK=.30` resumes `1.06341…`; `AK=.50` resumes on page 440 at `1.13082…`; `AK=.70` resumes `1.09924…`; `AK=.90` resumes `1.05667…`. All correctly rejoined in the CSV.

**Extra assurance:** the brief only asked for four banks, but I diffed **all 20 legible banks** (`all except AK=.35`, see §5). Result: **20 × 41 = 820 / 820 cells exact, zero mismatches.** The four requested banks are a subset.

I then re-checked the four requested banks against the **printed page scan** (not just the OCR text layer) — pages 437, 438–439, 440, 442–443 of the book — and all 164 cells agree with the ink on the page as well. Row 1/`BX` is printed as:

```
AK=0 and BX(1,1 to 41)      .6,.62,.64,.66,.68   .7,.72,.74,.76,.78   .8,.82,.84,.86,.88
                            .9,.92,.94,.96,.98   1,1.02,1.04,1.06,1.08  1.1,…,1.4
```

which matches CSV row 1 exactly (the OCR's lone `C` on its own line is the `1` of `1,1.02,…`).

---

## 2. Task 2 — the x axis against the source BX row

`uflo.csv` line 1 = `0.60000 … 1.40000`, step 0.02, 41 values.
Source `BX(1..41)` = `.6 .62 .64 … 1.38 1.4`.
**0 mismatches.** ✔

Also verified: every bank is strictly increasing in `J` (as it must be, ABX rising with B1/XC), and the two apparent ties in the matrix — `J=19` and `J=20` between `AK=0.95` and `AK=1.00` (both `0.99664` and both `0.99908`) — are genuine ties present in the printed book.
`ABX` rises with `AK` for `J ≤ 20` and falls with `AK` for `J ≥ 22`, monotone everywhere. ✔

---

## 3. Task 3 — ten random spot checks

Chosen to sit on the awkward bits (lost decimal points, page breaks, OCR letter-for-digit), so they have real diagnostic power. `I` = AK index, `J` = column.

| # | AK (I) | J | CSV value | Source line | Source text | Result |
|---|---|---|---|---|---|---|
| 1 | 0.05 | 1 | 0.68173 | 20144 | `.68173` | ✔ |
| 2 | 0.10 | 22 | 1.01315 | 20163 | `1.1 01315,…` → `1 , 1.01315` | ✔ (page-break cell) |
| 3 | 0.15 | 20 | 0.99062 | 20172 | `.97671,99062` (leading `.` lost) | ✔ |
| 4 | 0.25 | 5 | 0.80355 | 20189 | `.79332,80355` (leading `.` lost) | ✔ |
| 5 | 0.30 | 41 | 1.35216 | 20210 | `1.35216` (last cell before page break) | ✔ |
| 6 | 0.45 | 3 | 0.81830 | 20230 | `.8183, 82787` | ✔ |
| 7 | 0.70 | 41 | 1.28245 | 20295 | `1.28245` (last cell before page break) | ✔ |
| 8 | 0.80 | 14 | 0.96703 | 20309 | `.95716,.96703,97489` | ✔ |
| 9 | 0.90 | 7 | 0.90089 | 20328 | `.9O089` (letter `O`) | ✔ |
| 10 | 0.95 | 10 | 0.93494 | 20342 | `-93494` (`.`→`-`) | ✔ |

**0 mismatches / 10.**

---

## 4. Task 4 — every mismatch, and every repaired OCR cell

### 4.1 Mismatches inside the four requested banks + the ten spot checks

**None.** 174 comparisons, 0 mismatches.

### 4.2 Inventory of damaged source cells and how the CSV resolved them

The text layer is a lossy OCR of a 150 dpi scan; about 25 *values* (as opposed to mere separators) had to be reconstructed. Every one of them was re-checked independently: bracketed by its `J−1` and `J+1` neighbours in the same bank, and verified against the page image where legible. **All 25 are correct** — no repair is wrong.

| AK | J | Raw OCR | CSV | Basis for repair | Verdict |
|---|---|---|---|---|---|
| 0.00 | 21 | `C` (own line) | 1.00000 | ABX(I,21)=1.0 identically; scan shows `1,1.02,…` | defensible ✔ |
| 0.05 | 7 | `75942` | 0.75942 | leading `.` lost; between .74498/.77443 | defensible ✔ |
| 0.10 | 21 | `1.1 01315` → `1` | 1.00000 | ABX(I,21)=1.0; between .98777 / 1.01315 | defensible ✔ |
| 0.10 | 24 | `1 04882` | 1.04882 | space for `.`; between 1.03040 / 1.06790 | defensible ✔ |
| 0.10 | 25 | `1 0679` | 1.06790 | idem | defensible ✔ |
| 0.15 | 20 | `97671,99062` | 0.99062 | leading `.` lost | defensible ✔ |
| 0.20 | 5 | `. 79153` | 0.79153 | stray space; monotone | defensible ✔ |
| 0.25 | 5 | `.79332,80355` | 0.80355 | leading `.` lost | defensible ✔ |
| 0.40 | 6 | `84063` | 0.84063 | leading `.` lost | defensible ✔ |
| 0.40 | 7 | `85097` | 0.85097 | leading `.` lost | defensible ✔ |
| 0.45 | 3 | `.8183` | 0.81830 | trailing zero | defensible ✔ |
| 0.45 | 4 | `82787` | 0.82787 | leading `.` lost | defensible ✔ |
| 0.45 | 8 | `86836` | 0.86836 | leading `.` lost | defensible ✔ |
| 0.45 | 15 | `95174` | 0.95174 | leading `.` lost | defensible ✔ |
| 0.65 | 20 | `-99885` | 0.99885 | `-` for `.`; between .99580 / 1.0 | defensible ✔ |
| 0.80 | 15 | `97489` | 0.97489 | leading `.` lost | defensible ✔ |
| 0.80 | 22 | `1.1.00054` | 1.00054 | merged tokens | defensible ✔ |
| 0.85 | 1 | `83931` | 0.83931 | leading `.` lost; scan confirms `.83931` | defensible ✔ |
| 0.90 | 7 | `.9O089` | 0.90089 | letter `O` for `0` | defensible ✔ |
| 0.90 | 8 | `.91O92` | 0.91092 | letter `O` for `0` | defensible ✔ |
| 0.90 | 20 | `9966,99908` | 0.99908 | leading `.` lost | defensible ✔ |
| 0.95 | 10 | `-93494` | 0.93494 | `-` for `.`; scan confirms `.93494` | defensible ✔ |
| 1.00 | 8 | `,,91708` | 0.91708 | stray comma | defensible ✔ |
| 1.00 | 10 | `92724,93663` | 0.93663 | leading `.` lost | defensible ✔ |
| 1.00 | 11 | `94554` | 0.94554 | leading `.` lost | defensible ✔ |

All 25 sit strictly inside their neighbour bracket. Every repair is a *formatting* restoration (a dropped `.`, an `O` for `0`, a lost separator) — never a guess at a digit — so all are defensible.

Separator-only damage (e.g. `.62..64`, `1.29252.1.3124.1.33229…`) is harmless: the tokens still carry all five digits.

---

## 5. Task 5 — the six "interpolated" cells in `AK = 0.35`

### 5.1 They are missing from the **text file**, but not from the **book**

* In the text layer the bank is destroyed at the start: line 20211 reads `^32-g6,.84335,.85416,.86532,.87686`. The block contains only **35 legible tokens**, and the `AK=.35` header is gone too — `AK=.35` appears nowhere in the text file.
* 41 − 35 = **6 cells lost, exactly J = 1…6**. Confirmed by alignment: the 35 surviving tokens map one-to-one onto `J = 7…41`, and I verified those 35 cells against the CSV with **0 mismatches**.
* The reason for the damage is visible on the page: the printed `AK=.35` header has a **hand-drawn circle over it**, and the ink of the first two value lines is partly obscured by the same stroke. That is what the OCR choked on.

**But the six values are printed in the book and are legible in the PDF scan** (page 439):

```
AK=.35
.78427 , .79358 , .80306 , .81275 , .82267
.83286 , .84335 , .85416 , .86532 , .87686
.88881 , .90117 , .91396 , .92721 , .9409
...
```

So the premise "these cells are missing from the source" is **false for the source document**; it is true only for the OCR text file. Nothing needed to be invented.

### 5.2 The reconstructed values vs. what the book actually prints

| J | CSV (interpolated) | Book (scan) | Δ | Verdict |
|---|---|---|---|---|
| 1 | 0.78427 | 0.78427 | 0 | correct |
| 2 | 0.79357 | **0.79358** | −0.00001 | **MISMATCH** |
| 3 | 0.80306 | 0.80306 | 0 | correct |
| 4 | 0.81274 | **0.81275** | −0.00001 | **MISMATCH** |
| 5 | 0.82266 | **0.82267** | −0.00001 | **MISMATCH** |
| 6 | 0.83285 | **0.83286** | −0.00001 | **MISMATCH** |

Digits read at 16× magnification, and each group cross-read twice at different scales. The distinguishing features are clear: the `8` closing `79358` has two closed loops, whereas the `5` closing `81275` has a flat top bar and an open left side; the `7` closing `82267` has a top bar and a bare diagonal, whereas the `6` closing `83286` has a closed lower bowl.

**4 mismatches**, all −1 in the 5th decimal place (relative error ≈ 1.3 × 10⁻⁵).

### 5.3 Is the interpolation itself plausible? Yes — uncannily so

Using only the neighbouring banks (which are intact and verified):

| J | book value | linear mid of .30/.40 | dev | quadratic (.25,.30,.40) | dev | quadratic (.30,.40,.45) | dev |
|---|---|---|---|---|---|---|---|
| 1 | .78427 | .78371 | +.00056 | .78440 | −.00013 | .78420 | +.00007 |
| 2 | .79358 | .79302 | +.00056 | .79370 | −.00012 | .79350 | +.00008 |
| 3 | .80306 | .80252 | +.00054 | .80318 | −.00012 | .80299 | +.00007 |
| 4 | .81275 | .81222 | +.00053 | .81286 | −.00011 | .81268 | +.00007 |
| 5 | .82267 | .82217 | +.00050 | .82277 | −.00010 | .82260 | +.00007 |
| 6 | .83286 | .83237 | +.00049 | .83296 | −.00010 | .83279 | +.00007 |

* A plain linear midpoint is already within 5.6 × 10⁻⁴ — i.e. 0.07 % — of the truth.
* A quadratic through the two nearest banks plus one outer bank is within 1.3 × 10⁻⁴.
* The reconstruction is within **1 × 10⁻⁵** of the printed value in all six cells, i.e. roughly an order of magnitude better than the model's own accuracy. That is better than an honest extrapolation would normally achieve, and is consistent with the values having effectively been read off the page image rather than extrapolated.
* Convexity is preserved: the slope sequence per 0.05 of AK at `AK=.25/.30/.35/.40/.45` is monotonically decreasing in all six columns (e.g. J=1: .01074, .00923, .00811, .00721), matching the neighbouring banks.

**Conclusion on §5:** the six cells are physically absent from the OCR text only; the values are printed in the book. The reconstruction is an excellent approximation and **4 of the 6 are off by one unit in the last digit**. Physically negligible (1.3 × 10⁻⁵ relative on an area-ratio ordinate), but they are not what the book says.

---

## 6. Mismatch count and verdict

| Check | Cells | Mismatches |
|---|---|---|
| AK = 0.00 bank (41) | 41 | 0 |
| AK = 0.20 bank | 41 | 0 |
| AK = 0.50 bank | 41 | 0 |
| AK = 1.00 bank | 41 | 0 |
| Ten random spot checks (other banks) | 10 | 0 |
| **Subtotal — as requested** | **174** | **0** |
| *(extra)* remaining 16 legible banks, full diff | 656 | 0 |
| *(extra)* AK = 0.35, 35 OCR-surviving cells | 35 | 0 |
| *(extra)* AK = 0.35, 6 reconstructed cells | 6 | **4** |
| **Whole table** | **861** | **4** |

**Verdict: PASS for the four re-extracted banks and the spot checks — 0 mismatches out of 174 comparisons.**
The x axis / `BX` row is exact. The transcription is a faithful, mechanically consistent rendering of Data Bank 2.0; all 25 reconstructed OCR cells were resolved correctly.

**One qualified defect:** the six cells in bank `AK = 0.35` that were declared interpolated are **not** missing from the book — they are legible in the scan — and four of the six (`J = 2, 4, 5, 6`) differ from the printed values by 1 × 10⁻⁵ (CSV is low). The other two (`J = 1, 3`) are exactly right. Overall table accuracy is therefore **857 / 861 cells exact (99.54 %)**, with the four residuals being last-digit-only and physically irrelevant.

### Recommended action

1. Replace the six `AK=0.35` cells `J=1..6` with the printed values
   `0.78427, 0.79358, 0.80306, 0.81275, 0.82267, 0.83286`.
2. Change the provenance note from "interpolated" to "recovered from the PDF page image (page 439); OCR text layer lost these six cells under a hand annotation".
3. Add a comment that rows 1 and 2 are intentionally identical (`ABX(1,J) = BX(J)`).
4. Consider a full cell-by-cell audit of the remaining banks against the page scan: they agree with the OCR text, but the OCR text is itself the weak link (it silently destroyed six cells here, so it could have corrupted others where a transcriber would have had no reason to look).

---

## 7. Scope and residual risk

* Verified against **both** the OCR text layer and the printed page scan for the four requested banks, the `BX` row, and all of `AK = 0.35`.
* The other 16 banks were diffed against the OCR **text** only. They are internally consistent (monotone in both directions, no local anomalies in a bicubic residual scan of all 741 interior cells; the only large residuals are the genuinely steep low-`BX`/low-`AK` corner), but a wrong digit that is wrong in the OCR *and* faithfully copied would not be caught by that method. Given that the text layer demonstrably loses/corrupts cells, a scan-level audit of the remaining banks is the only way to close that gap.
* The PDF scan is 150 dpi 1-bit; individual glyphs are ~5 × 12 px. The four `AK=.35` mismatches were each read at 16× magnification in two independent renderings, and the distinguishing glyph features are clear, but this is the one place where the verdict rests on visual interpretation rather than an exact match.

### Reproduction artefacts (in `port/`)

| File | Purpose |
|---|---|
| `_verify_blind.py` | hand re-extraction of all 21 banks + diff against `uflo.csv` |
| `_verify_ak35.py` | AK=.35 surviving-cell diff, interpolation-vs-neighbour analysis, convexity check |
| `_verify_repairs.py` | all 25 repaired cells bracketed against neighbours |
| `_verify_smooth.py` | structural + bicubic residual scan of the whole matrix |
| `_verify_tokens.py` | enumerates every malformed token in the source block |
| `_sheet_L1.png`, `_sheet_L1b.png`, `_sheet_L1c.png`, `_sheet_L2.png` | 16× page-image crops of the six disputed cells |
