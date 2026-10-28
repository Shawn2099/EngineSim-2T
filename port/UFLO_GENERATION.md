# UFLO — what it is, and whether we can regenerate it

Target: produce the data file `UFLO` that Prog.5.1 opens at start-up, for the QUB 400
validation case.

Source: `references/text/Blair,_G.P._—_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt`
(all "src NNNNN" below are line numbers in that file).

---

## 1. Where the file is defined

| Fact | src |
|---|---|
| `OPEN"I",#1,"UFLO"` — literal filename, **no extension**, current directory, sequential text input | 26051 (Prog.5.1) and 26856 (Prog.5.2); transcription line 23 |
| `FOR I=1 TO 21 STEP 1 / FOR J=1 TO 41 STEP 1 / INPUT#1,ABX(I,J)` — read order, **J varies fastest** | 26052–26056 (and 26857–26861); transcription 25–29 |
| After the read: `BX(J)=ABX(1,J)` for J=1..41 | 26059–26061 (and 26864–26866); transcription 32–34 |
| `AKA(1)=0` then `AKA(I)=AKA(I-1)+.05` for I=2..21 — the AK axis is **built arithmetically, not read from the file** | 26062–26067 (and 26867–26872); transcription 35–38 |
| Data-bank description: 21 × 41, "the sonic and subsonic solution for inflow and outflow for unsteady flow where g=1.4" | 20119–20131 |
| "the relevant file is called UFLO and is a 21 by 41 matrix of six-digit numbers … presented in number format in the Computer Program Appendix as Data Bank 2.0" | 3847–3849 |
| Same file is read by Progs.2.2, 2.3, 5.1 and 5.2 | 20367, 20603, 21273, 26037 |

Size: 21 × 41 = **861 numbers**, comma-separated; the format is insensitive to line breaks
(`INPUT#1` reads one comma-delimited field at a time, 20126 "The AK value at the start of each
bank is for information only and is not part of the data set").

---

## 2. (a) Exact definition of the tabulated quantity

The book's own words (20127–20131):

> "The ABX(I,J) is the numeric value of (A1+B1)/XC in Fig.2.7. The ABX(I=1,J) value is BX(J) in
> the program and is the value of B1/XC shown in Fig.2.7. The AK, or port to pipe area ratio, are
> the numbers in front of each bank below."

So the bank holds the **ordinate of Fig. 2.7**: the non-dimensional superposition pressure
amplitude at the port, i.e. the solution of the cylinder↔pipe boundary condition.

**The two independent variables.** The unambiguous statement is written in the β/β' notation of
Sect. 2.4 (src 4368–4375):

> "Suppose that it is an exhaust port open to a cylinder. In this case the boundary condition
> chart UFLO given in Fig. 2.7, and contained in the computer file of the same name, must be used
> for evaluation of β'1. It will be observed in Fig. 2.7 that the axes are also labelled in terms
> of β and B values. **The x-axis has values of B1/Xc**, where B1 is the value of B'1 in question.
> … The methodology of solution is exactly as discussed in Sect. 2.3.3, in terms of the
> port-to-pipe AK value and the cylinder pressure amplitude ratio, Xc. **The y-axis is also
> plotted in terms of (β'1 + β"1)/(2*Xc)** so that the parameter can be evaluated by
> interpolation, and β"1 determined."

In the X notation of Sect. 2.3.3 (src 3823–3840):

* Vertical axis — `(Xi + Xr - 1)/Xc`, "the superposition pressure amplitude ratio at the port,
  but … the pressure over the full pipe area at the port" (3838–3840).
* Horizontal axis — `(2*Xi - 1)/Xc` (3831–3833).
* Family parameter — lines of constant **AK = (effective port area)/(pipe area) = CC*FP/FPIP**
  (3823–3826, Eq. 2.3.17), where CC is a contraction coefficient taking values "as high as unity
  and … as low as 0.6" (3828–3830).

**Notation warning.** The data-bank text at 20127 writes the ordinate as `(A1+B1)/Xc`, *without*
the factor 2 that appears in both the axis label at 4374 and the code at 28047
(`A=2*X1*ABX1-B`). The two are consistent only as

```
ordinate  y = (β'1 + β"1)/(2*Xc) = (A+B)/(2*Xc) = Xs/Xc = (Xi + Xr - 1)/Xc
abscissa  x = B1/Xc             = B/Xc          = (2*Xi - 1)/Xc
```

with the code's `A = 2*Xr-1`, `B = 2*Xi-1`. This is verified by the table itself: **row I=1
(AK = 0) is exactly `y = x`** (the closed-end, no-flow diagonal, `Xs = 2Xi-1` at src 3658), which
is why `BX(J)=ABX(1,J)` works at all (26059–26061). Anyone reading 20127 literally and dividing
by 1 instead of 2 will produce a table that is wrong by a factor of two in the ordinate and will
fail on row 1 immediately.

Grid actually tabulated (from `AKA` above and the printed banks):

| axis | values | step | count |
|---|---|---|---|
| I = AK | 0, .05, .10, … 1.00 | .05 | 21 |
| J = (2Xi-1)/Xc = B1/Xc | .60, .62, … 1.40 | .02 | 41 |

Row I=1 (AK=0) is **not** a solution of a flow problem: it is the closed-end / no-flow diagonal
`y = x`, stored so that `BX(J)` can be read straight out of the file.

### How the code consumes it — `SUB PORT`, quoted verbatim (28034–28048)

```
SUB PORT(A,B,P,AK) STATIC
SHARED ABX(),BX(),AKA(),PA
X1=(P/PA)^(1/7)                      ' P = pressure on the far side of the port (cylinder/box)
BX1=B/X1                             ' = horizontal axis of Fig.2.7
IF AK>.95 THEN AK=.95                ' upper clamp on the area-ratio axis only
IF BX1<.6 THEN BX1=.6                ' lower clamp on the amplitude axis only
I=INT(AK/.05)+1
J=INT((BX1-.6)/.02)+1
RA=(AK-AKA(I))/(AKA(I+1)-AKA(I))
AB1=RA*(ABX(I+1,J+1)-ABX(I,J+1))+ABX(I,J+1)
AB2=RA*(ABX(I+1,J)-ABX(I,J))+ABX(I,J)
RB=(BX1-BX(J))/(BX(J+1)-BX(J))
ABX1=RB*(AB1-AB2)+AB2
A=2*X1*ABX1-B                        ' recover the reflected amplitude
END SUB
```

Two consequences for the generator:

1. `A = 2*Xc*ABX1 - B` is the only thing the solver ever asks of the table, and the
   superposition pressure comes back as `PRs = ((A+B)/2)^7` (src 26260 / 27061,
   `PEX=((AE(1)+BE(1))/2)A7`).
   Hence the tabulated ordinate is exactly `y = (A+B)/(2*Xc) = Xs/Xc`, with the code's `A`, `B`
   being `2*Xr-1`, `2*Xi-1` — which is why the axes run .60…1.40 and why the AK=0 row is `y = x`.
2. The table is valid only for `0.6 <= B/Xc`; there is **no upper clamp** on `BX1`, so `BX1>1.40`
   indexes `J=41` and interpolates against the never-initialised `BX(42)` (see `INPUT_FORMAT.md` §4).

---

## 3. (b) The equations the book *does* give

The port boundary is a gasdynamic solution, not a correlation. The book supplies the
superposition machinery but **not** the boundary solution itself:

| Eq. / statement | Content | src |
|---|---|---|
| Eq. 2.2.1 | `Xs = Xi + Xr - 1` (superposition pressure amplitude) | 3657–3658, 3732–3734 |
| Eq. 2.2.2 / 2.3.13 | `CGs = 5*Ao*(Xi - Xr)` with `5 = 2/(g-1)` at g=1.4 | 3674–3676, 3729–3731 |
| Eq. 2.3.11 (from 2.1.14) | `As/Ao = Xs` — isentropic link between amplitude and temperature | 3720–3722 |
| `X = (P/Po)^(1/7)` | pressure ratio ↔ amplitude ratio, g=1.4 | e.g. 3815, 3886 |
| Eq. 2.3.17 | `AK = CC*FP/FPIP`; `0.6 <= CC <= 1.0` | 3823–3830 |
| Pipe reference temperature | "calculated from an isentropic pressure drop from the cylinder pressure to the pipe reference temperature" — i.e. `Tref = Tc/Xc^2` | 3863–3865 |

Closing the system needs three more conditions, which are the *standard* ones but which this book
never writes down: quasi-steady isentropic orifice flow through the vena contracta, mass-flow
continuity across the port plane, and static-pressure continuity there. With `Tref = Tc/Xc^2`
the densities cancel and the closure collapses to one scalar equation in `y = Xs/Xc` at given
`(x = B/Xc, AK)`.

### What is missing

> "The solution of the gas dynamics of the flow must include separate treatments for subsonic
> inflow, sonic inflow, subsonic outflow and sonic outflow. … A complete description of the
> solution is out of place in this book, as the theoretical solution would occupy almost a book
> in itself, but the result of that solution is presented in graphical form in Fig. 2.7 …"
> — src 3787–3794

The method is attributed to Wallace & Nassif(2.5), Blair & Cahoon(2.6) and McConnell(2.7)
(src 3789–3792; bibliography 5664–5670), and the book explicitly says the *mechanism of solution*
was published there, not here (3849–3851):

> "the mechanism of solution for the UFLO file, and of its use by interpolation in a computer
> program, are both described in that paper."

There is **no equation anywhere in this book for the port boundary condition** — no quadratic, no
choked-flow expression, no regime-switch criteria. (The 1996 companion volume *Design and
Simulation of Two-Stroke Engines* was also searched: it contains no `UFLO`/`ABX` data bank.)

---

## 4. (c) Analytic, or numerical per entry?

**Short answer: the shape of the problem is closed-form, but the table is not regenerable from
this book, and it does not need to be — it is printed in full.**

**Why the shape is closed-form.** For a fixed `(x, AK)` the unknown is the single scalar `y`, and
the subsonic branches are algebraic: squaring the continuity relation gives a **quadratic in y**,
e.g. the outflow branch

```
sqrt(5)*(x - y) = AK*sqrt(1 - y^2)
  ->  (5 + AK^2)*y^2 - 10*x*y + (5*x^2 - AK^2) = 0

      y = [ 5x + AK*sqrt(5*(1 - x^2) + AK^2) ] / (5 + AK^2)      (positive root)
```

(Check at x = 0.80, AK = 1: y = (4 + sqrt(2.8))/6 = 0.94555, against 0.94554 printed at src
20351–20359 — the closure is right where it applies.)

so no iteration is needed: 861 entries = 861 closed-form evaluations, a few dozen lines of code,
with the sonic branches handled by an explicit throat condition instead of the radical. That is
the "few lines of code" answer, and it is the right architecture for a port.

**Why it is still not a regenerator.** I tested that closure against ten printed banks
(AK = .05, .10, .30, .40, .50, .60, .70, .95, 1.00 and the AK=0 row; 410 tabulated values read
from src 20144–20359):

| regime | max abs error in the tabulated value |
|---|---|
| bulk subsonic band, small/moderate AK | 0.0013 (AK=.05) … 0.0101 (AK=.50) |
| AK ≈ .6 – .7 | 0.008 … 0.020 |
| strong-gradient corners (x = 0.60 at every AK; x > 1.05 at AK ≥ .95) | 0.032 … 0.080 |

The table is printed to six digits; an error of 0.08 is ~10 % of the entry. The residual pattern
is systematic, not random (it grows exactly where the port solution changes regime), so the
discrepancy is a missing piece of physics/closure — presumably the contraction-coefficient and
sonic-branch conventions of McConnell — not round-off. **Conclusion: the naive closure is a good
skeleton but not a faithful regenerator, and no closure that reproduces six digits can be derived
from this book alone.**

**Therefore the route is transcription, not generation.** The complete table *is* printed:
Data Bank 2.0, `AK=0` bank at src 20132 through the last value of the `AK=1` bank at src 20359 —
21 banks of 41 numbers, with the `AK=…` headers to be discarded (20125–20126).

### Known OCR damage in the printed table (repair list)

| src | damage |
|---|---|
| 20133–20142 | row 1 read as ".6,.62..64,…" — the `1.0` and `1.1` entries are mangled (".1.02" = "1,1.02") |
| 20153 | header `AK=.l` = `AK=.1` |
| 20178 | header `AK=2` = `AK=.2` |
| 20198 | header `AK=3` = `AK=.3` |
| **20211** | `AK=.35` header **missing entirely**, and the first value of that bank is lost (`^32-g6,.84335,…` — only 40 values on the page) |
| 20163, 20207, 20250, 20293 | page break falls inside a bank |
| 20274 | header `AK-65` = `AK=.65` |
| 20350 | header `AK=1` = `AK=1.00` |
| throughout | commas OCR'd as full stops or dropped: `.89452`→`,89452`, `1.00011.1.00044`, `„`, `-` for `.`, `,84063„85097` |

One bank (AK = .35) is physically damaged on the page — its header is gone and one of its 41
values with it. A second (AK = .65) has a garbled header but all 41 values legible. Everything
else is recoverable with mechanical normalisation, which is why the repair step below leans on
the table's own invariants rather than on eyeballing.

---

## 5. Plan

1. **Extract.** Take src 20132–20359 as the only authority for the 861 numbers. Strip the
   `AK=…` lines, the page headers (`The Basic Design of Two-Stroke Engines`, `Computer Program
   Appendix - ProgList 2.0`, page numbers `437`–`440`) and figure/section headings. Re-join the
   five banks split by page breaks.
2. **Normalise the OCR.** Replace `„` and stray `-` with `.`/`,`, restore leading zeros
   (`,84891` for `.84891`), split merged tokens (`1,1.01315` is two values), and force every
   value to 6 significant digits (`1` → `1.00000`).
3. **Assert the structure.** Fail loudly unless: exactly 861 values; 21 rows × 41 columns; every
   row has exactly one entry equal to 1.00000 and it must be at column J=21 (x = 1.00); row 1
   equals the `BX` vector `.60,.62,…1.40`; at each fixed J < 21 the entry is monotonically
   **increasing** in AK, and at each fixed J > 21 monotonically **decreasing** in AK; each row
   increases monotonically with J throughout, with a visible change of slope at the J=21 pivot.
   These invariants pin every digit the OCR can damage: the whole J=21 column is exactly 1.00000
   in the banks I checked (src 20148, 20163, 20203, 20224, 20244, 20269, 20289, 20345, 20355).
4. **Repair AK=.35 and any other short bank** by re-reading the page, and only if that fails,
   by interpolating between AK=.30 and AK=.40 — and **label those entries as interpolated** in
   the file's provenance note, never silently.
5. **Cross-check.** Run the closure of §4 over the repaired table. It should agree to ~0.01 in
   the bulk subsonic band; any entry that disagrees by more than 0.02 *and* is not in a
   regime-change corner is an OCR error, not a physics error. Use it as a typo detector, not as
   an oracle.
6. **Write.** 21 lines of 41 comma-separated values, row I=1 (the `BX` vector) first, no `AK`
   labels, no header — exactly what `INPUT#1` expects at 26052–26056. File name `UFLO`, no
   extension.

Only after step 3 passes should the QUB 400 deck be run: `SUB PORT` fails *silently* on a bad
table (`INPUT_FORMAT.md` §4), so a corrupt UFLO produces plausible-looking but wrong output
rather than an error.
