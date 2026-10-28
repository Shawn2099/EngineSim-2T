# UFLO — Data Bank 2.0: OCR damage, repairs, and audit

Source: `references/text/Blair,_G.P._—_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`,
lines 20132–20359 ("Data Bank 2.0", Fig. 2.7 solution for `g = 1.4`).
Output: `port/uflo.csv`.
Scripts: `port/build_uflo.py` (transcription), `port/audit_uflo.py` (repair + audit).

Quantity: `y = (β'1+β"1)/(2·Xc) = Xs/Xc` against `x = B1/Xc`.
Grid: I = 1..21 (AK = 0.00 … 1.00), J = 1..41 (x = 0.60 … 1.40, step 0.02).

---

## 0. Result at a glance

| item | count |
|---|---|
| values required (21 × 41) | 861 |
| values printed legibly and transcribed | 855 (99.3 %) |
| values physically lost in the source | **6** |
| values reconstructed by interpolation | **6** (all at I = 8) |
| values still ambiguous after repair | 0 |
| invariant violations in the finished table | 0 (see §6 for one caveat) |

Nothing in this file was invented to make a check pass: the six entries of §2 are the only
numbers in `uflo.csv` that are not printed, and they are bracketed by their neighbours on
both axes.

---

## 1. Layout of `uflo.csv` (read this before loading it)

22 rows × 41 columns, no header, comma separated, 5 decimal places.

* **row 1** = the x axis, 0.60000 … 1.40000.
* **rows 2–22** = banks I = 1 … 21, i.e. AK = 0.00, 0.05, … 1.00.

Row 2 (I = 1, AK = 0) is identical to row 1, and must be: bank I = 1 *is* the closed-end
diagonal `y = x`, stored in the book as the `BX` vector so that `BX(J)` can be read straight
out of the file (`UFLO_GENERATION.md` §2). The file that Prog.5.1 actually `INPUT#1`s is
**rows 2–22** (21 rows); row 1 is there because the deliverable asked for the axis as well.

---

## 2. The one real data loss — I = 8 (AK = 0.35), J = 1 … 6

### What is printed (src 20209–20218)

```
20209 1.35216                       <- last value of the AK=.30 bank (J=41)
20210 ^32-g6,.84335,.85416,.86532,.87686
20211 .88881,-90117,.91396,.92721,.9409
20212 .955,.96824,.97988,.98959,.9968
...
20218 1.34413
```

The `AK=.35` header is gone, replaced by the page-break debris `^32-g6`. Only **35** numbers
survive in this bank, not 41.

### Why exactly six are missing, and why they are J = 1…6

The bank contains a single `1`, as the 15th of the 35 surviving numbers. Column J = 21 is
`1.00000` in every bank (it is the pivot x = 1, where all curves meet), so the 15th surviving
number is J = 21 and the **first surviving number is J = 7**. Therefore J = 1…6 are the six
that are lost. (This corrects `UFLO_GENERATION.md` §4, which says "only 40 values on the page"
and "the first value of that bank is lost"; the printed count is 35 and six values are gone.)

Independent confirmation that the survivors start at J = 7: `0.84335` must be J = 7 because

* the AK-interpolation of the neighbouring banks at J = 7 predicts 0.84344 (quartic) / 0.8429
  (AK = .30 and .40 only), while at J = 1 it predicts 0.7843 — `0.84335` is 0.06 away from that;
* `0.84335` cannot be J = 1 because bank ordering requires
  `ABX(.30,1) = 0.77504 < ABX(.35,1) < ABX(.40,1) = 0.79238`.

Recovery from elsewhere in the corpus was attempted and fails: a full-text search for
`84335` / `85416` / `86532` finds only src 20211 — the table is printed once.

### How the six were reconstructed

Polynomial interpolation **in AK at fixed J**, from the neighbouring intact banks. The scheme
was not assumed: each candidate was first scored on the 35 entries of this same bank that *are*
printed (J = 7…41), which is a genuine held-out test — the interpolant never sees them.

| scheme (banks used) | max abs error on the 35 surviving entries | rms |
|---|---|---|
| quartic .20/.25/.30/.40/.45 | **0.00001** | 0.000004 |
| cubic .25/.30/.40/.45 | 0.00002 | 0.000007 |
| cubic .20/.25/.30/.40 | 0.00003 | 0.000012 |
| quadratic .30/.40/.45 | 0.00007 | 0.000025 |
| quadratic .25/.30/.40 | 0.00009 | 0.000033 |
| linear .30–.40 | 0.00047 | 0.000212 |

The quartic was adopted. The table is smooth in AK to ~1e-5, so a horizontal interpolant
reproduces printed digits almost exactly; extrapolating that accuracy six columns to the left
is safe to roughly ±0.0006 (the spread between the best and worst schemes, which is dominated
by the linear one; the five non-linear schemes agree with each other to 2.0e-4).

### Adopted values (INTERPOLATED — not printed)

| I | J | x | adopted value | alternative (linear .30–.40) | spread across schemes |
|---|---|---|---|---|---|
| 8 | 1 | 0.60 | **0.78427** | 0.78371 | ±0.00056 |
| 8 | 2 | 0.62 | **0.79357** | 0.79302 | ±0.00055 |
| 8 | 3 | 0.64 | **0.80306** | 0.80252 | ±0.00054 |
| 8 | 4 | 0.66 | **0.81274** | 0.81222 | ±0.00052 |
| 8 | 5 | 0.68 | **0.82266** | 0.82216 | ±0.00050 |
| 8 | 6 | 0.70 | **0.83285** | 0.83237 | ±0.00048 |

Consistency of the repair, checked against its printed continuation:

* first differences along the repaired stretch are 0.00930, 0.00949, 0.00968, 0.00992, 0.01019,
  0.01050, 0.01050 — monotone and smoothly continuing into the printed `0.84335` at J = 7;
* the same differences at AK = .30 are 0.00934, 0.00956, 0.00978, 0.01005, 0.01035, 0.01068 and
  at AK = .40 are 0.00929, 0.00944, 0.00962, 0.00983, 0.01007 — the repaired row sits between
  them, as it must;
* every repaired cell is strictly inside the AK = .30 and AK = .40 brackets at its own J;
* the whole bank is strictly increasing in x and strictly ordered against its neighbours.

**Provenance flag:** I = 8, J = 1…6 are the only interpolated cells. If the simulation turns
out to be sensitive to AK ≈ 0.35 at low `B1/Xc` (x = 0.60–0.70), re-read the printed page
(image copy of p. 438) before trusting those six numbers to better than ~5e-4.

### The other bank that looked damaged but is not

AK = .65 (I = 14) has a garbled header `AK-65` (src 20274) but **all 41 values are present and
legible**. Header only; no data repair.

---

## 3. Character-level restorations (digit present in the source, only the punctuation lost)

These cells were *not* reconstructed — the digits are on the page; the comma or decimal point
was OCR'd as something else. Each is confirmed by its two neighbours in the same row and by the
bank-ordering constraint in its column.

| I | J | src | printed text | adopted | why |
|---|---|---|---|---|---|
| 2 | 9 | 20145 | `.77443..79..80608` | 0.79000 | double period for separator; `0.79` lies between `0.74498` (AK=0) and `0.79617` (AK=.10) |
| 3 | 21, 22 | 20163 | `1.1 01315` | 1.00000, 1.01315 | merged tokens at a page break; J=21 is the exact pivot `1`, next is `1.01315` |
| 3 | 24 | 20163 | `1 04882` | 1.04882 | space for decimal point |
| 3 | 25 | 20163 | `1 0679` | 1.06790 | space for decimal point |
| 4 | 20 | 20172 | `.97671„99062` | 0.99062 | `„` glyph for comma; last entry before the pivot |
| 8 | 12 | 20212 | `-90117` | 0.90117 | hyphen for leading period; between `.88881` and `.91396` |
| 10 | 3, 4 | 20230 | `.8183„ 82787` | 0.81830, 0.82787 | `„` for comma and a lost trailing zero |
| 10 | 14, 15 | 20232 | `.93863„95174` | 0.95174 | `„` for comma |
| 17 | 14, 15 | 20309 | `..96703„97489` | 0.96703, 0.97489 | doubled period + `„` |
| 19 | 7 | 20328 | `.9O089` | 0.90089 | letter **O** for zero; between `.89101` and `.91092` |
| 19 | 8 | 20328 | `.91O92` | 0.91092 | letter **O** for zero |
| 20 | 22, 23 | 20345 | `1.00011.1.00044` | 1.00011, 1.00044 | dropped comma; J=21 is `1.00000`, J=24 is `1.00104` |
| 21 | 8 | 20352 | `,,91708` | 0.91708 | doubled comma |
| 21 | 9 | 20352 | `.92724„93663` | 0.93663 | `„` for comma |

Beyond these individual cases, 36 lines in the region use `..`, `„` or `,-` where a comma or a
decimal point belongs (e.g. `,84063„85097`, `.81201..82132`). All such lines were normalised
mechanically and then verified digit-by-digit against the source, so no digit was guessed.

### Row I = 1 (the `BX` vector)

The printed axis row is itself OCR'd (`.6,.62..64,.66,.68`, `1.1.02.1.04...`, `1.1,1.12...`,
src 20133–20142). It is regenerated exactly as `0.60, 0.62, … 1.40`, which loses nothing: the
axis is arithmetic, and this bank is defined as `y = x`.

---

## 4. Damaged bank headers (cosmetic — the AK axis is not read from the file)

`AKA(I)` is built in the program by `AKA(1)=0 : AKA(I)=AKA(I-1)+.05`
(`UFLO_GENERATION.md` §1), so these are only a reading aid; none affects the data.

| src | printed | should be |
|---|---|---|
| 20153 | `AK=.l` | .10 |
| 20178 | `AK=2` | .20 |
| 20188 | `AK=25` | .25 |
| 20198 | `AK=3` | .30 |
| 20210 | *(absent — `^32-g6`)* | .35 |
| 20274 | `AK-65` | .65 |
| 20296 | `AK=75` | .75 |
| 20306 | `AK=80` | .80 |
| 20316 | `AK=.85 i` | .85 |
| 20326 | `AK=,90` | .90 |
| 20350 | `AK=1` | 1.00 |

---

## 5. Things that look like invariant violations but are not

Two adjacent banks hold **exactly equal** values at one cell each:

* (I = 21, J = 19): AK = 1.00 and AK = 0.95 are both `0.99664`;
* (I = 20, J = 20): AK = 0.95 and AK = 0.90 are both `0.99908`.

Both duplicates are in the printed source — J = 19 twice at src 20344 and 20354, J = 20 twice at
src 20330 and 20344 — and are physically sensible: as AK → 1 the family degenerates and the
curves merge into `y ≈ x`. These are *contacts*, not crossings — no bank overtakes another
anywhere. Tightest genuine separation between neighbours is 1e-5 (I = 21 vs 20 at J = 20);
median separation is 6.6e-3.

---

## 6. Invariant audit — and one correction to the requirement as stated

Run `python audit_uflo.py` to reproduce.

| # | invariant | result |
|---|---|---|
| 1 | J = 21 is exactly `1.00000` in every bank | **pass**, 21/21 |
| 2 | row I = 1 (AK = 0) satisfies y = x exactly | **pass**, 41/41 (max error 0) |
| 3 | each bank monotonic in x | **pass as increasing**, see below |
| 4 | adjacent banks do not cross | **pass**, 800/800 comparisons, 2 exact contacts (§5) |

### Correction to invariant 3

The requirement I was given says each bank must be **monotonically decreasing** in x. That is
not a property of this table, and it cannot be: bank I = 1 is `y = x`, which rises from 0.60 to
1.40, and every other bank rises with it (e.g. I = 21 goes 0.84891 → 1.18775). Fig. 2.7 plots
`Xs/Xc` against `B1/Xc`, and increasing `B1/Xc` means increasing superposition pressure, so the
ordinate rises.

What is true — and what is checked instead — is the invariant recorded in
`UFLO_GENERATION.md` §5:

* each bank is **strictly increasing** in x: 21/21 banks, 40/40 steps each, smallest step 2e-5;
* there is a visible slope change at the J = 21 pivot, with the branches ordered in AK as
  required: **rising** in AK for J < 21 (400/400 comparisons) and **falling** in AK for
  J > 21 (400/400).

So: as literally worded, invariant 3 fails for all 22 rows; read as the physically correct
"monotonic in x, with the AK ordering of invariant 4", it passes everywhere. No data was
altered to satisfy the mis-stated direction — doing so would have destroyed the table.

---

## 7. Independent verification of the transcription

`audit_uflo.py` re-derives the digit string of every 5-value block from the source lines and
requires it to appear verbatim in the printed text. 177 of 180 blocks match exactly. The three
that do not are accounted for:

* I = 8, J = 1…5 — interpolated (§2);
* I = 8, J = 6…10 — contains the interpolated J = 6, and J = 7 begins a new printed line;
* I = 19, J = 6…10 — the letter-**O** line `.9O089,.91O92` (§3).

This catches transcription slips, but by construction it cannot catch a value assigned to the
wrong bank; the column-ordering check of invariant 4 is what covers that (and it passes for all
800 in-column comparisons).

---

## 8. Verdict

The table is internally consistent: every one of the four structural invariants holds, the
861 cells are 855 printed + 6 interpolated to ±0.0006, and no cell is silently guessed. It is
fit to drive `SUB PORT`, with two caveats worth carrying into the simulation record:

1. AK = 0.35, x = 0.60–0.70 rests on interpolation, not print (§2).
2. `SUB PORT` clamps only the *lower* end of `B1/Xc` (`IF BX1<.6 THEN BX1=.6`); for
   `B1/Xc > 1.40` it indexes J = 41 and interpolates against the never-initialised `BX(42)`
   (`UFLO_GENERATION.md` §2). That is a property of the deck, not of this file, and this
   transcription neither fixes nor worsens it.
