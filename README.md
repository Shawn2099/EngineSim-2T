# EngineSim-2T — Yamaha RX135 two-stroke engine simulation

Simulation of a **Yamaha RX135** (Indian market, 132 cc, crankcase-scavenged, loop-scavenged,
reed-valve, carburetted two-stroke) for stock-vs-modified comparison and porting studies.

## The engine

**Hybrid build** — not a factory configuration:

| | |
|---|---|
| Cylinder | 5-speed `4TL10` (porting confirmed against the barrel) |
| Head | 5-speed `09L` — CR 10.1:1, chamber 15.9 cc |
| Carburettor | 4-speed VM22, main 165, pilot 17.5, needle 4J26 |
| Exhaust | 4-speed absorptive silencer, measured (see below) |
| Gearbox | 4-speed, final 16/34 |
| Observed | ~120 km/h "barely touched" → ~8700 rpm in 4th |

## The exhaust (measured, not assumed)

Straight-through absorptive silencer, 5.98 L:

```
header  390 mm, 46 mm ID
cone    240 mm, 46 -> 96 mm
can     600 mm, 96 mm ID, five chambers 140/100/90/70/200 mm
core    35 mm x 420 mm, perforated, through the baffle plates
outlet  35 mm with a 5 mm bridge  -> 787 mm2  (~31.7 mm equivalent)
```

## Two simulators, side by side

1. **`sim/` — our own crank-angle 0-D model.** Fast, fully tagged parameters, validated on peak
   speed (2–4 %). Good for comparative studies at ~±15 %. Reed model is the known weak point.

2. **`sim/blair/` — a MATLAB port of Gordon Blair's Prog.5.1** (from *The Basic Design of
   Two-Stroke Engines*). 1-D method-of-characteristics pipe, published algorithm. Now reproduces
   Blair's own QUB 400 reference case to **3.4 % mean deviation** after one documented book-page
   repair.

## Start here

| File | Contents |
|---|---|
| `sim/PROJECT_STATUS.md` | configuration, decisions, what is measured vs assumed |
| `sim/RX135_5S_VERIFIED_PARAMETERS.md` | full parameter set with provenance tags |
| `sim/VERIFICATION_vs_LITERATURE.md` | 23 parameters checked against Blair / Heywood |
| `sim/REFERENCES_EXTRACT.md` | equations used, with page references |
| `sim/blair/QUB400_VALIDATION.md` | validation of the ported simulator |
| `sim/blair/RX135_RESULTS_v2.md` | the RX135 prediction |
| `port/` | the BASIC transcription, UFLO data, input decks |

## Status in one line

Both simulators predict **~7.8 kW at 7500 rpm** for this build — and both say the **inlet (reed) is
the limiting element**. Reed petal geometry is the one measurement that would most improve the answer.

## What this cannot do

Absolute power prediction (no dyno data), knock/detonation, ring-support limits, jetting. It is a
comparison tool: it tells you what changes *between* two configurations, not what the engine makes.

## Reproducing

```matlab
cd sim/blair
mdl = blair_init('..\..\port\RX135_INPUT.dat');
mdl = blair_run(mdl, 7500, 1.0);
mdl.results
```

```matlab
cd sim/blair
t = sweep('..\..\port\RX135_INPUT.dat', 3000:500:9000, 1.0);
plot_curve(t);
```
