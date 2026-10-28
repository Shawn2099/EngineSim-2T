# sim/blair — MATLAB port of Blair PROG.5.1 (physics core)

Written against `port/blair_clean.bas` (the merged source after the five fixes in
`port/CLEAN_LOG.md`). One field per Blair variable, Blair's own names, 1-based
arrays, one statement at a time: a line here can be read against the BASIC line
quoted beside it.

## Interface

```matlab
mdl = blair_init(casepath);          % blair_clean.bas up to the loop head
mdl = blair_step(mdl);               % one crank-angle step
mdl = blair_run(mdl, rpm, throttle); % run to cyclic convergence, fill .results
T   = blair_validate(casepath);      % the QUB 400 case beside Fig.5.9
```

`mdl.results` carries the 14 contract fields
(`power_kW bmep_bar imep_bar pmep_bar fmep_bar bsfc_gkWh DR SE TE CE
pmax_bar tmax_K converged cycles`) plus `sr srv exhaust_flow_ratio
peak_angle_deg bsfc_kgkWh swept_volume_cm3 rpm throttle`, which
`check_qub400.m` scores. `mdl.hist` holds every cycle.

## Files

| file | source | notes |
|---|---|---|
| `blair_init.m` | 105-227, 1001-1044, 154-221 | constants, UFLO, unit conversion, PORTSTART, PAREA, NINT, SETS/AREA, pre-loop state |
| `blair_step.m` | 256-370 | one pass of the crank-angle loop, plus RESETBDC/RESETTDC and the six port-state blocks as local functions |
| `blair_run.m` | — | restart from `mdl.init`, step, detect convergence at BDC, fill results |
| `sub_cylinder.m` | 1541-1600 | CYLINDER, including its STATIC locals in `mdl.cyl` |
| `sub_box.m` | 1384-1402 | BOX, 15 arguments; returns VB1 (BASIC passes by reference) |
| `sub_port.m` | 1299-1313 | PORT, the UFLO bilinear interpolation |
| `sub_flow.m` | 1339-1374 | OUTFLOW and INFLOW in one file (MATLAB allows one public function per file) |
| `sub_flow_out.m`, `sub_flow_in.m` | — | public wrappers for those two |
| `sub_parea.m` | 1422-1426, 1177-1181 | PAREA and FPORT, same two-entry arrangement |
| `fport.m` | — | public wrapper for FPORT |
| `sub_stab.m` | 1190-1199 | STAB, sets DZ/DTM/DC |
| `sub_pipe.m` | 1237-1270 | PIPE |
| `sub_nint.m` | 1487-1495 | NINT, mesh count |
| `sub_pistpos.m` | 1410-1415 | PISTPOS, degrees version |
| `sub_sets.m`, `sub_area.m`, `sub_shok.m` | 1206, 1218, 1277 | the three routines the task list does not name |
| `qub400_model.m` | — | adapter for `run_qub400.m`; no physics |

`load_case.m`, `load_uflo.m`, `sweep.m`, `check_qub400.m`, `qub400_targets.m`,
`run_qub400.m`, `plot_curve.m` are other agents' files; this port uses
`load_case` and `load_uflo` and does not modify any of them.

## Three transcription defects repaired in the port only

`blair_clean.bas` still has them (Job 1 was five named fixes). The port uses the
printed book values, quoted beside each line. See `port/CLEAN_LOG.md`
(appendix) and the headers of `sub_flow.m` / `sub_cylinder.m`.

| statement | transcribed | book page |
|---|---|---|
| `CP=481.17*TR^.25` | `.25` | `.125` (p.310) |
| `GAM=1.7847/(TR^.417)` | `.417` | `.0417` (p.310) |
| `HEAT=BEFF*CVAL*MAIR^TAFB` | `^` | `/` (p.603) |

Without the first two, GAM < 1 and every flow reverses sign. Without the third
there is no combustion at all.

## Accuracy, honestly

QUB 400, 3000 rpm, full throttle, SCRE, cycle 5 — mean deviation from Fig.5.9
is 8.7 %; 17 of 46 scored targets pass `check_qub400.m` (case A 12/21). The
delivery ratio (+3.8 %), the mass-based scavenge ratio (+5.2 %), the exhaust
flow ratio (+5.2 %) and the peak-pressure angle (+1.1 %) are close; the
volume-based scavenge ratio (+25 %) is not, and through
`SEFF=1-EXP(MSC*SR+CSC)` it drives the scavenging efficiency (+8.5 %), the
charging efficiency (+12 %) and therefore IMEP and power (+13 %).

That ratio is `SRvol/SRmass = EXPAND*MREF/(VC1*CD*D)`, and Blair's published
pair (1.134 / 0.874 = 1.2975) is reproduced to 0.2 % by the port's ratio times
0.75/0.9 — i.e. by a transfer-port discharge coefficient of 0.9 in the inflow
branch instead of the 0.75 printed twice at `blair_clean.bas` 1103/1104. That is
recorded as an open question, **not** applied: it would be tuning, and the book
prints 0.75.

Case C (5000 rpm, Fig.5.12) fails for a reason outside the port: the book's
column quotes 12.11 kW **and** BMEP 6.10 bar at 5000 rpm, which for this 397 cc
single-cylinder implies 20.2 kW, not 12.1. The two figures are consistent only
at 3000 rpm, so at least one of them is mislabelled in the source.
