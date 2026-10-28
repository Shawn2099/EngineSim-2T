# sim/blair - input and harness layer

MATLAB harness around a port of Blair's two-stroke simulator (Prog.5.1, the
"engine model No.1" of *The Basic Design of Two-Stroke Engines*, ch.5).

This folder contains **only the input and harness layer**: case-file reading,
the UFLO boundary table, the sweep driver and plotting. The physics lives in
`blair_init.m` and `blair_run.m`, which are written separately. Nothing here
computes engine behaviour.

## Interface contract (provided by the physics layer)

```matlab
mdl = blair_init(casepath)              % build the model from a case file
mdl = blair_run(mdl, rpm, throttle)     % run one operating point

mdl.results must contain:
  power_kW  bmep_bar  imep_bar  pmep_bar  fmep_bar  bsfc_gkWh
  DR  SE  TE  CE  pmax_bar  tmax_K  converged  cycles
```

`rpm` is in rev/min and `throttle` is the throttle area ratio THAR (0..1).

## Requirements

MATLAB base only - no toolboxes. Tables, `datetime` and `exportgraphics`
(R2020a+) are used; if `exportgraphics` is unavailable, `print -dpng` is used
automatically.

`blair_init.m` and `blair_run.m` must be on the MATLAB path (normally the same
folder). Run everything from `sim\blair`, or `addpath` it.

## Files

| File | Purpose |
|---|---|
| `load_case.m` | Read + validate a Prog.5.1 case file (42 values) |
| `load_uflo.m` | Read `port\uflo.csv` as a 21x41 `ABX` plus the 41-element `BX` axis |
| `sweep.m` | Speed x throttle grid over `blair_run`, checkpointed, resumable |
| `plot_curve.m` | Plot a sweep table, save a PNG under `sim\blair\plots\` |

Each file has a single `CONFIG` block at the top holding every path and
tunable. Nothing else in the code hard-codes a path.

## Quick start

```matlab
cd('C:\Users\malliath\Desktop\engine_sim\sim\blair')

% 1. read the reference case (also validates it)
[case_data, meta] = load_case('C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat');

% 2. read the unsteady-flow boundary table
[ABX, BX] = load_uflo();        % ABX is 21x41, BX is 1x41

% 3. one operating point
mdl = blair_init('C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat');
mdl = blair_run(mdl, 3000, 1.0);
disp(mdl.results)

% 4. a sweep, then a plot
t   = sweep('C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat', ...
            2000:500:7000, [1 0.5 0.25]);
png = plot_curve(t);
```

Run a sweep in one line:

```matlab
t = sweep('C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat', 2000:500:7000, [1 0.5 0.25]); plot_curve(t);
```

Defaults: `load_case()` and `load_uflo()` with no argument read the reference
QUB 400 deck and `port\uflo.csv` (see each file's `CONFIG`).

## Where outputs land

| Output | Default location | Set in |
|---|---|---|
| Checkpoint | `sim\blair\sweep_checkpoint.mat` | `sweep.m` `CONFIG.checkpoint_file` |
| Sweep table (CSV) | `sim\blair\sweep_results.csv` | `sweep.m` `CONFIG.csv_file` |
| Plot PNG | `sim\blair\plots\sweep_<case>_<timestamp>.png` | `plot_curve.m` `CONFIG.plot_dir` |

`plot_curve` creates `plots\` if it does not exist. The PNG path is returned.

## sweep: grid, table, checkpoint

```matlab
t = sweep(casepath, rpm_list, throttle_list);
t = sweep(casepath, rpm_list, throttle_list, opts);
```

* Rows are ordered **throttle outer, speed inner**, so each throttle setting
  is one contiguous block of rows (one curve in the plot). Point `i` is
  `(throttle_list(k), rpm_list(j))` with `i = (k-1)*numel(rpm_list) + j`.
* Duplicate entries in either list are removed, order preserved.
* Columns: `rpm`, `throttle`, then every contract result field, then `ok`.
  `rpm` and `throttle` are the requested values. `ok` is true when
  `blair_run` returned normally; a failed point keeps `NaN` physics so plots
  and statistics skip it. `converged` is logical, `cycles` numeric.
* A point that throws is recorded as failed and the sweep continues; the
  model is re-initialised after a failure so the next point starts clean.
  An interface violation (no `mdl.results` struct) stops the sweep instead,
  because every later point would fail the same way.
* Checkpoint is written **after every point**, atomically (`.tmp` then
  `movefile`), so an interrupt cannot leave a half-written `.mat`.
* Resume: re-running the same call with the same case file and the same two
  grids recomputes nothing. The checkpoint is keyed on the case path, the
  case file's size and timestamp, the two lists, and `CONFIG.file_version`.
  Change the case or either list and the sweep starts fresh (the old file is
  left in place until the first new point overwrites it).
* Previously failed points are retried on resume (`opts.retry_failed`,
  default true). Pass `opts.retry_failed = false` to keep them as failures.
* `t.Properties.UserData` carries `casepath`, `rpm_list`, `throttle_list`,
  `n_points`, `checkpoint` and `created`; `plot_curve` uses it for the title.
  `readtable` of the CSV loses this - the plot then says `series`.

`opts` fields (all optional):

| Field | Default | Meaning |
|---|---|---|
| `resume` | `true` | reuse a matching checkpoint |
| `checkpoint` | `CONFIG.checkpoint_file` | `''` disables checkpointing |
| `csv` | `CONFIG.csv_file` | `''` skips the CSV copy |
| `verbose` | `true` | one line per point |
| `retry_failed` | `true` | retry failed points on resume |
| `validate_case` | `true` | run `load_case` before starting |

## plot_curve: what is drawn

Six panels against engine speed, one line per throttle setting (colour):
power [kW], torque [N.m], bmep [bar], bsfc [g/kWh], DR/TE/SE [%], and peak
pressure [bar] / peak temperature [K]. Torque is derived, not read from the
table:

```
T [N.m] = P [kW] * 1000 / (2*pi*rpm/60)
```

DR, TE and SE are solid, dashed and dotted inside their panel; colour is the
throttle. If every efficiency in the table is <= 1.5 it is treated as a
fraction and shown as percent, otherwise it is assumed to be percent already.
Panels whose columns are absent or entirely NaN say "no data" instead of
failing, so a partially failed sweep still plots.

```matlab
plot_curve(t, struct('show', true, 'prefix', 'part_load'));
```

## Case file format (`load_case`)

One value per line; everything after `!` is a comment. The reference deck
annotates each line as `VALUE ! NAME ! UNIT ! source-line`, and the NAME
column is cross-checked against the expected prompt order, because the deck
is in **program prompt order, not Fig.5.3 order**. The three known traps are
`TCR/CCR/TEXC`, `LTP/TRAR/LIP/DIP/THAR`, and `NC/NE` first in the combustion
block.

The returned struct has exactly 42 fields, in prompt order:

```
BO ST CRL RPM TCR CCR TEXC                       engine
EPO EPFO NEP WEP RTE RBE                         exhaust port
TPO TPFO NTP WTP RTT RBT SCAV                    transfer port
IPO IPFO NIP WIP RTI RBI                         inlet port
LEP1 DEP1 LEP2 DEP2 VBOX SIL                     exhaust box silencer
LTP TRAR                                         transfer duct
LIP DIP THAR                                     inlet duct and load
NC NE BEFF BDEG TAF                              closed cycle
```

Units are as typed: mm, deg crank, rev/min, cm^3, degC.

Validation:

* every field must be present - a short file reports every missing field;
* every numeric field has a hard physical range (bore 10-300 mm, TCR > 1,
  THAR in (0, 1], ...). A value outside its range is an error naming the
  line, field, value and range;
* cross-field impossibilities are errors: rod shorter than the crank radius,
  `EPFO < EPO`, `TPFO < TPO`, port widths exceeding the bore circumference,
  corner radii wider than half the port;
* design oddities are warnings only: transfer opening before exhaust,
  `TRAR` outside 1.2-1.5, `BEFF` outside 0.80-0.85, `VBOX` under 5x swept
  volume, pipe neck larger than the bore.

Two string fields are normalised so the physics layer sees one spelling:

* `SCAV` - one of `UNIFLOW`, `SCRE`, `YAM1`, `YAM6`, `CD`, `QUBCR`.
  Spaces and underscores are removed before matching, so `YAM 1` becomes
  `YAM1`. (Blair compares exact strings and silently produces zero scavenging
  efficiency if the word does not match; this reader refuses instead.)
* `SIL` - `PLAIN BOX` for answer `N`, `ABSORPTION` for answer `Y`.
  `N`/`NO`/`PLAIN BOX` and `Y`/`YES`/`ABSORPTION` are all accepted.

`[case_data, meta] = load_case(...)` also returns `meta.source`,
`meta.line_numbers`, `meta.comment_names`, `meta.field_names` and
`meta.warnings`.

## UFLO table (`load_uflo`)

`ABX` is the 21x41 Blair Fig.2.7 table: row 1 is the `BX = B1/Xc` axis
(0.60:0.02:1.40), rows 2..21 are the twenty `AK = 0:0.05:1.00` banks.
The CSV has 22 rows because row 2 repeats the axis; that duplicate is
dropped. A 21-row file is accepted as-is. Any other row count, or a
22-row file whose second row is not a copy of the first, is an error rather
than a guess - mis-slicing this table corrupts every port boundary condition
without any visible symptom.

`meta.ak` returns the derived 1x21 area-ratio axis (it is not stored in the
file). `meta.dropped_duplicate` records whether row 2 was removed.

Interpolation caveat: Blair's `SUB PORT` clamps `AK` at .95 and evaluates
`ABX(I+1,J+1)`, touching `ABX(21,42)` at `BX1 = 1.40` - outside this matrix.
The original relies on BASIC zero-filling that element; guard the `J+1`
access instead of assuming a column 42 exists.

## Failure modes

Everything fails loudly with a stable identifier, never silently:

| Error id | Cause |
|---|---|
| `blair:load_case:notFound` | case file does not exist |
| `blair:load_case:missingFields` | fewer than 42 values; names them |
| `blair:load_case:invalid` | bad number, out-of-range value, bad string, inconsistent geometry |
| `blair:load_uflo:notFound` | UFLO file does not exist |
| `blair:load_uflo:badWidth` / `badSize` / `ambiguousLayout` | table shape is not 21x41 or 22x41-with-duplicate |
| `blair:load_uflo:badAxis` / `badNumber` / `notFinite` | damaged or non-numeric table |
| `blair:sweep:noPhysics` | `blair_init`/`blair_run` not on the path |
| `blair:sweep:badCase` | `load_case` rejected the deck |
| `blair:sweep:initFailed` | `blair_init` threw |
| `blair:sweep:badResults` | `blair_run` returned no `.results` struct |
| `blair:plot_curve:badTable` / `empty` | table lacks required columns or rows |

Warnings that do not stop a run: `blair:load_case:suspicious` (field-name
shift, design oddities), `blair:load_uflo:suspicious` (axis or monotonicity),
`blair:sweep:pointsFailed`, `blair:sweep:missingField`.

## Notes

* Nothing here validates the physics. Its output is taken at face value and
  only field presence is checked.
* `load_case` and `load_uflo` run standalone - they do not need the physics
  layer, so the input deck can be validated before the solver exists.
* The checkpoint file is disposable. Deleting it just means the next sweep
  starts from the first point.
