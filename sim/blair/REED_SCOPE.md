# Reed-valve induction in the Prog.5.1 port — scope

**Question.** Prog.5.1 models a crank-driven piston-port inlet (`IPO`/`IPFO`/`WIP`/`RTI`/`RBI`).
The RX135 has a reed valve into the crankcase and no inlet window in the cylinder wall. How much
work is a reed model, and what does it need that we do not have?

**Answer, up front.**

| | |
|---|---|
| Engineering effort | **2 days** of code (2.5–3 with validation against Blair's own published reed designs). Not 2 hours. Not a week. |
| Blocked on | **One afternoon with the reed cage off the engine and a caliper.** Seven dimensions, one magnet, one micrometer. Nothing else. |
| If you cannot get the cage off | **2 hours** buys the quasi-static lift law, which is already written (wrongly) in `sim/engine_model.m` — see §5. |
| Single biggest finding | Blair **never prints the petal equation of motion**, in either book. He prints the modal *frequencies*, the *static* deflection and the *areas*, and points at Hinds' thesis for the dynamics. "Port Blair's reed model" is a reconstruction, not a transcription. See §1.3. |

---

## 0. Where the code stands

Two induction models live in this repo and they do not talk to each other.

| model | inlet | reed? |
|---|---|---|
| `sim/engine_model.m` (quasi-1D, single-zone) | `params.m` §7: seat area, petal length/width/thickness, `E`, stop height, cracking `dp` | **yes, quasi-static.** `engine_model.m:206-223` — `x = dp*Ap/k`, `A_rd = min(n*x*w, As)`, in series with the VM22 venturi |
| `sim/blair/*` (the Prog.5.1 port) | `IPO IPFO NIP WIP RTI RBI` — a crank-driven piston window | **no.** `blair_step.m:225-230` dispatches on `HTDC` vs `HIOT`; `local_inport_open` (`blair_step.m:559-592`) computes the area from `fport(HTDC,HIOT,INHT,FIPRT,FIPRT,CCI)` at line 574 |

The ported code is honest about this: `run_rx135_sweep.m:5-7` says "THE INLET IS A PROXY - there is
no reed model in Prog.5.1", and `port/RX135_PROXY.dat:17-22` marks the whole inlet block
`NOT AVAILABLE`. Blair confirms it himself:

> "Although Prog.5.2 does not contain induction system variations to handle disc valve or reed valve
> induction systems, the program permits the designer to model all of the engine porting and exhaust
> geometry…"
> — *Basic Design* (1990), **lines 11055-11058**

The present proxy is `600 mm² open for 120°` (60° BTDC → 60° ATDC). Blair's measured reed behaviour
is **~250° of opening** (§1.4). That is not a small correction.

---

# 1. What Blair actually prints (Task 1)

Two texts, both in `references/text/`. Line numbers below are of the extracted `.txt` files
(the `(S.txt` file is 33 534 lines; the SAE 1990 file is 31 387).

## 1.1 The physical statement

> "When the reed lifts… a complex pattern of pressure is applied to the reed surfaces on both sides.
> It is the summation of all of these pressures over the entire surface area of the reed petal which
> gives rise to the force that causes the reed to open, and a combination of these forces and the
> dynamic spring characteristics of the reed petal which makes it reseat itself."
> — *Design & Simulation* (1996), **lines 19282-19287**, p.368

> "Hinds [5.18] showed that the reed valve can be treated as a pressure-loaded cantilevered beam
> clamped at one end and forced into various modes of vibration by the crankcase pressure acting on
> one side of the beam, and the superposition pressure at that position in the inlet tract acting
> upon the other."
> — **lines 19292-19295**

That is the whole model statement: **clamped-free cantilever, two pressures, modal superposition.**

## 1.2 The three laws he does print

### (a) Natural frequencies — Eq. 5.2.15, **lines 19298-19315**

OCR is mangled; the equation is

```
f_j = (β_j L_r)² / (2 π L_r²) · sqrt( Y·I / (ρ·A) )
```

with `β_j L_r = 1.875, 4.694, 7.855, 10.996, 14.137` for the first five modes
(**line 19315**). `Y` = Young's modulus, `ρ` = density, `I` and `A` = second moment of area and
cross-section in the plane of bending (**lines 19306-19308**):

```
I = X_r · x_t³ / 12          A = X_r · x_t          — Eq. 5.2.16, lines 19310-19312
```

The 1990 book gives the same law already collapsed to the first two modes, which is the form to
implement (*Basic Design*, **Eqs. 6.3.7/6.3.8, lines 13577-13579**):

```
FREQ1 = (1.758/π)·sqrt( Y·MI / (Mo·L⁴) )        MI = RDWD·RDTH³/12   (Eq. 6.3.5, l.13570)
FREQ2 = (11.015/π)·sqrt( Y·MI / (Mo·L⁴) )       Mo = RDWD·RDTH·RDRH  (Eq. 6.3.6, l.13573)
```

`1.758 = 1.875²/2` and `11.015 = 4.694²/2` — the two books agree exactly.

### (b) Static deflection under a uniformly distributed load — Eq. 6.3.10, **lines 13606-13609**

```
DEFL = P_load · X_r · L_r⁴ / (8 · Y · I)
P_load = 0.18 · (CR_cc − 1) · 101325   Pa        — Eq. 6.3.9, lines 13601-13605
```

(The 1996 version, **Eq. 6.3.6, lines 23918-23923**, OCRs the exponent as `Lr^3`; the 1990 text at
line 13608 and the Prog.6.4 listing at line 29541 both read `L^4`, and `L^4` is the only form that
reproduces Blair's own worked example — §1.5. **Use `L⁴`.**)

This is the **stiffness** of the petal as a uniformly loaded beam:

```
k_uniform = 8·E·I / L³           (not 3EI/L³, which is a tip point load — see §5.3)
```

### (c) The effective flow areas — Eqs. 5.2.17–5.2.19, **lines 19336-19352**

```
A_ip = x_w·h − (4 − π)·r²                        Eq. 5.2.17   block entrance
A_rp = n_rp·( L_p·X_p − r_p²(4 − π) )·sin(φ_rb)  Eq. 5.2.18   seat, seen in the flow direction
A_rd = n_r · x_tip · X_p                         Eq. 5.2.19   curtain past the petal
```

and the governing selection, **lines 19365-19370**:

> "the effective throat area of the port posed by the reed system at any juncture (see Eq. 2.16.4) is
> defined by A_t and the numerical value of A_t is that given by either A_ip or A_rd,
> **whichever is the lesser**."

Note `X_p` — **port** width — in Eq. 5.2.19, not petal width `X_r`. The present `engine_model.m`
uses petal width, and the seat area instead of `A_ip`.

Two more printed facts about the area:

- the curtain should be computed at the lift **at the end of the port**, not at the tip,
  i.e. at the station `L_p + X_s` from the clamp (**lines 19353-19356**);
- no cosine correction is applied to Eq. 5.2.19 because the discharge coefficients already absorb
  the block angle (**lines 19357-19364**).

### (d) The two derived design numbers

```
tip lift ratio   C_rdt = x_tip / L_r                             Eq. 5.2.20, lines 19375-19379
stop plate radius R_sp = (1 − C_rdt²)·L_r / (2·C_rdt)            Eq. 6.3.9,  lines 23949-23952
                                                                    basic Eq. 6.3.12, line 13620
```

`C_rdt = 0.3` is the mechanical limit (**lines 23945-23948**); Fleck's measurements sit at 0.15–0.3
(**line 23908**).

## 1.3 What he does **not** print — and this is the scoping crux

There is **no integrated equation of motion anywhere in either book.** No `d²x/dt²`, no mass matrix,
no damping coefficient, no time-stepping scheme, no stability criterion, no reed pseudo-code. What
exists is:

- a *description* of the intended solution — pressure "distribution along the length of the reed, on
  both sides, … usually in steps of 1 mm", a modal sum, and "bounce off the reed stop must also be
  included" (**lines 19316-19324**);
- a statement that **two modes suffice** (**lines 19329-19330**), on Hinds' correlation;
- a pointer: *"For a fuller description of the theoretical model of reed valve motion the thesis by
  Hinds [5.18] or by Houston [5.19] should be consulted."* (**lines 19331-19333**).

So a reed implementation is **our** dynamics, calibrated against **his** frequencies, static
deflection, areas and stop geometry. That is why the estimate below is days and not hours, and why
the acceptance tests in §4.4 are built from his published numbers rather than from a listing.

For completeness, Blair's own verdict on difficulty (**line 23502**):

> "The incorporation of these induction systems into an engine modeling program is straightforward in
> the case of the disc valve and **complex for a reed valve** design."

## 1.4 Behaviour the model must reproduce

| fact | value | source |
|---|---|---|
| measured lift traces, steel / glass / CFRP | Figs 6.24-6.26, **lines 23536-23723** | D&S |
| low speed 5430 rpm | opens **160° BTDC**, closes **86° ATDC** → 246° | **line 23730** |
| high speed 9150 rpm | opens **140° BTDC**, closes **122° ATDC** → 262° | **line 23732** |
| the character | "asymmetrically timed at low speeds and symmetrically timed at high speeds" | **lines 23733-23736** |
| forcing frequency | first harmonic = engine rps; keep `f_1 ≥ 1.2·rps` | **lines 23897-23903** |
| petal material | steel 207 GN/m², 7800 kg/m³; glass 21.5 GN/m², 1850; carbon 20.8 GN/m², 1380 | **lines 23789-23796**; basic **29762-29767** |

The 5430/9150 rpm pair is the quantitative target for the whole exercise: **any** inlet model that
cannot produce an open period near 250° and a closing point that walks from 86° to 122° ATDC is not
a reed model. A fixed piston window physically cannot, which is the argument for doing this at all.

## 1.5 Verification of my transcription (do this first, before writing any code)

I evaluated Blair's own two published designs from Eqs. 5.2.15/6.3.10. He prints the answers, so the
check is exact:

| case | Blair's print | computed | error |
|---|---|---|---|
| 125 GP, glass, 38×22.7×0.42 mm | `REED NATURAL FREQUENCY = 160 Hz` (line 23867) | **160.16 Hz** | 0.1 % |
| 125 GP, glass, tip lift ratio | `0.33` (line 23869) | **0.330** | 0.0 % |
| 125 GP, stop plate radius | `58 mm` (line 23870) | **57.6 mm** | 0.7 % |
| 125 GP, seat area `A_rp` | `1499 mm²` (line 23864) | **1499 mm²** | 0.0 % |
| 125 GP, curtain `A_rd` | `1474 mm²` (line 23865) | **1474 mm²** | 0.0 % |
| chainsaw, steel, 30 mm × 0.20 mm | `185 Hz` (basic line 13664) | **184.9 Hz** | 0.05 % |
| 125 GP, steel, 38 mm × 0.25 mm | `144 Hz` (basic line 13670) | **144.0 Hz** | 0.0 % |
| 125 GP, carbon, 38 mm × 0.60 mm | `261 Hz` (basic line 13701) | **260.6 Hz** | 0.15 % |

Eight for eight. `REED_SCOPE` therefore ships a real oracle: three published reed designs whose
frequency, lift and area are all known, plus `Fig 6.27`/`Fig 6.19` full input sets
(**lines 23850-23871** and **13684-13705**). Any implementation must hit that table before it is
pointed at the RX135.

Note also that Blair's two books are mutually consistent, and that the *chainsaw* reed
(30 mm, 0.20 mm steel, 185 Hz) is numerically identical to the reed currently assumed in
`params.m:242-247`. The RX135 assumption is Blair's chainsaw, not an RX135.

---

# 2. Inputs the model needs (Task 2)

### 2.1 The full list, with Blair's symbol and where it comes from

| # | input | symbol | eq / line | RX135 today | status |
|---|---|---|---|---|---|
| 1 | number of petals | `n_r` | 5.2.19 | `reed_n = 2` | **UNKNOWN** — ASSUMED in `params.m:242` |
| 2 | petal free length | `L_r` | 5.2.15/6.3.10 | 30 mm | **UNKNOWN** — ASSUMED, `params.m:243` |
| 3 | petal width | `X_r` | 5.2.16 | 10 mm | **UNKNOWN** — derived backwards from the assumed seat, `params.m:244` + `engine_model.m:119` |
| 4 | petal thickness | `x_t` | 5.2.16 | 0.20 mm | **UNKNOWN** — ASSUMED, `params.m:245` |
| 5 | Young's modulus | `Y` | 5.2.15 | 207 GPa (steel) | material **UNKNOWN**; property known if steel |
| 6 | petal density | `ρ` | 5.2.15 | **absent from `params.m`** | material **UNKNOWN**; must be added |
| 7 | petal material identity | — | 23789-23796 | not recorded | **UNKNOWN** — magnet + a look |
| 8 | stop height / stop radius | `R_sp`, `x_stop` | 6.3.9 | 9.9 mm = 0.33·L | **UNKNOWN** — ASSUMED, `params.m:247` |
| 9 | port width | `X_p` | 5.2.18/5.2.19 | not present (10 mm used instead) | **UNKNOWN** |
| 10 | port length | `L_p` | 5.2.18 | not present | **UNKNOWN** |
| 11 | port corner radius | `r_p` | 5.2.18 | not present | **UNKNOWN** |
| 12 | clamp-to-port distance | `X_s` | 19353-19356 | not present | **UNKNOWN** |
| 13 | block half-angle | `φ_rb` | 5.2.18 | not present (flat = 90° assumed) | **UNKNOWN** |
| 14 | block entrance width × height | `x_w`, `h` | 5.2.17 | not present | **UNKNOWN** |
| 15 | number of block ports | `n_rp` | 5.2.18 | = `n_r` assumed | **UNKNOWN** |
| 16 | seat area | `A_rp` | 5.2.18 | 600 mm² | **UNKNOWN** — ASSUMED, `params.m:232` |
| 17 | modal damping ratio | `ζ` | — | not present | **not given by Blair at any point.** Pick 0.02–0.05 |
| 18 | crankcase volume | `V_cc` | — | `CCR = 1.343` → 385 cc | **UNKNOWN** — ASSUMED, deck line 32; sets the whole pressure range the reed sees |

### 2.2 Which of these we already have

Only four, and all four are borrowed:

- `Y = 207 GPa`, `ρ = 7800` — **known** for steel, from Blair (lines 23789-23796). These are
  properties, not measurements; they are correct *if* the petal is steel.
- `L_r = 30 mm`, `x_t = 0.20 mm` — **not RX135 data.** They are Blair's *chainsaw* reed
  (basic line 13664). The resulting 185 Hz is the chainsaw's frequency, not ours.
- `n_r = 2` and `A_rp = 600 mm²` — assumptions, no source.

`params.m` carries no `ρ` at all, so even the quasi-static path cannot be turned into a dynamic one
without adding a field.

### 2.3 Which we can measure — all of them

Every geometric quantity in the table is a caliper dimension on a part we can hold. With the cage
off the crankcase:

| measurement | tool | time |
|---|---|---|
| petal count `n_r`, port count `n_rp` | eyes | 10 s |
| free length `L_r`, width `X_r`, thickness `x_t` | caliper + micrometer | 2 min |
| port width `X_p`, port length `L_p`, corner radius `r_p`, clamp-to-port `X_s` | caliper | 5 min |
| block half-angle `φ_rb`, entrance `x_w × h` | protractor + caliper | 5 min |
| stop height (petal lift at the stop) | feeler gauge / depth caliper | 2 min |
| material (steel vs composite) | magnet | 5 s |

**Total: under 20 minutes**, and it also settles the seat area (`A_rp` from Eq. 5.2.18) and the
stop radius. This is already the number-one item in `port/RX135_CASE_NOTES.md:470-471`.

The two that are *not* on the bench:

- **crankcase volume** — needs the engine assembled and filled through the inlet at BDC with the
  piston at BDC (`RX135_CASE_NOTES.md:473`). This now matters more than it did: the reed's whole
  operating pressure band is set by `CR_cc`, and `1.343` is a guess.
- **modal damping `ζ`** — not measurable without a bench rig, and not needed to first order; it only
  sets the decay of the ringing after a seat or stop impact.

### 2.4 A consistency check that already tells us the assumptions are wrong

Blair's matched-design criterion (**line 23769**):

> "In a matched design, the effective reed port area should be larger than the effective flow area
> past the petal, but not by a gross margin."

At the stop, our assumed set gives

```
A_rd,max = n_r · 0.33·L_r · X_p = 2 × 0.33 × 30 mm × 10 mm ≈ 198 mm²
A_rp (assumed seat)                                        = 600 mm²
```

**The curtain is 3× smaller than the seat.** The petal set as currently assumed cannot pass the
assumed seat at full lift — the reed is the throttle, permanently. Compare Blair's 125 GP design,
where `A_rp = 1499` and `A_rd = 1474` mm²: matched to 2 %.

To match 600 mm² at `C_rdt = 0.33` and `L_r = 30 mm` you need `n_r·X_p ≈ 60 mm`, i.e. **4 petals of
15 mm port width** (or 2 × 30 mm, which is not a V-block). A 4-petal cage is also what Blair reports
for the RD350 (**line 23540**: "four reed petals and ports").

Consequence for the current proxy: because `engine_model.m` derives petal width *from* the seat
(`engine_model.m:119`), and because `k = 3EI/L³` is 3/8 of the correct uniform-load stiffness
(§5.3), the existing quasi-static petal is pinned against its stop at almost any crankcase
depression, so the "live" reed parameter is really just the seat area in disguise — which is exactly
what the audit found (`sim/audit/sweep_reed_A.csv`: 400→800 mm² moves peak power 6.79→8.12 kW,
i.e. the sweep is sweeping geometry, not physics).

---

# 3. Minimum viable change to the port (Task 3)

## 3.1 Which routine is replaced

One block, in one file: **`local_inport_open` (`blair_step.m:559-592`)**, and the dispatch that
guards it (`blair_step.m:225-230`). The inlet area stops being a function of crank angle and becomes
a function of the petal state.

Today:

```matlab
% blair_step.m:225-230
if m.HTDC < m.HIOT
    m = local_inport_open(m);      % 323
end
if m.HTDC > m.HIOT
    m = local_inport_shut(m);      % 324   sets AKI=0, MI1=0, AI(1)=BI(1)
end
```

```matlab
% blair_step.m:574-575   the line that goes away
m.AKI = fport(m.HTDC, m.HIOT, m.INHT, m.FIPRT, m.FIPRT, m.CCI);   % 1139
[tmp, m.AKI] = sub_port(m, m.BI(1), m.PCC1, m.AKI);                % 1140
```

After:

```matlab
% always, no crank-angle test — a reed has no opening angle
[m, x_lift, A_throat] = sub_reed(m);                % petal EOM, this step
m.AKI = m.CCI * A_throat / m.FIPRT;                 % same law as FPORT, new area
[tmp, m.AKI] = sub_port(m, m.BI(1), m.PCC1, m.AKI); % 1140 unchanged
```

`local_inport_shut` disappears from the reed path: "shut" is `x = 0`, which the EOM produces by
itself when `PIR ≤ PCC1`. Keep it, and keep `fport.m`, for the piston-port models — QUB 400 must
still validate.

The downstream flow code is **untouched**: `sub_flow`/`INFLOW`/`OUTFLOW` (lines 583-590) already
take a discharge coefficient and an area, and `CCI` is already selected from `PIR` vs `PCC1R`
at lines 561-566.

## 3.2 State that is added

A single `m.reed` struct, initialised once, carried through every step:

```matlab
m.reed.x        % tip lift [m]                 (state)
m.reed.v        % tip velocity [m/s]           (state)   <-- the new degree of freedom
m.reed.x_stop   % lift at the stop plate [m]
m.reed.L X_p x_t X_r n_r Y rho   % geometry + material
m.reed.k        % 8*Y*I/L^3   [N/m]   uniform-load stiffness
m.reed.m_eq     % 33/140 * rho*X_r*x_t*L_r [kg]  first-mode equivalent mass
m.reed.A_p      % X_r*L_r   loaded area [m^2]
m.reed.zeta     % modal damping
m.reed.A_rp     % seat, Eq. 5.2.18
m.reed.A_ip     % block entrance, Eq. 5.2.17
```

Two scalars and a struct — the port stays a struct pass, as everywhere else in `sim/blair`.

**The EOM** (one mode, uniform forcing — our reconstruction, not Blair's print):

```
m_eq·ẍ + c·ẋ + k·x = (PIR − PCC1)·A_p        c = 2·ζ·sqrt(k·m_eq)
clip x to [0, x_stop]
at a stop or seat event: x ← limit, v ← −e·v   (e ≈ 0, inelastic; Blair: "bounce … must be included", l.19321)
A_rd   = n_r · x · X_p                         Eq. 5.2.19
A_throat = min(A_ip, A_rd)                     line 19367
```

`m_eq = 33/140 · m_petal` is the standard equivalent mass of a uniform cantilever under a uniform
load; `k = 8EI/L³` is consistent with Blair's Eq. 6.3.10. Both are ours; both are checkable (§4.4).

Two design notes that save time:

1. **Do not put the reed parameters in the deck.** `load_case.m` and `INPUT_FORMAT.md` are another
   agent's contracts and the six inlet fields are already marked `NOT AVAILABLE`. Put the reed data
   in a new `reed_params.m`, keyed off the deck name, and leave the deck bytes alone. Cheapest,
   least coupled, easiest to revert.
2. **Keep the piston-port branch behind a flag** (`m.inlet_model = 'piston' | 'reed'`, default
   `'piston'`). The QUB 400 validation (8.7 % mean deviation, 17/46 targets) must not move.

## 3.3 Coupling to the crankcase volume in BOX

This is the good news: **`sub_box.m` does not change at all**, and neither does the crankcase call.

```
        ┌──────────────────────────────────────────────────────┐
        │  sub_reed:  force = PIR - PCC1                        │
        │             PIR  = ((AI(1)+BI(1))/2)^7   blair_step:199 │  front face (inlet tract)
        │             PCC1 = crankcase pressure    blair_step:299 │  back face  (previous BOX)
        └───────────────┬──────────────────────────────────────┘
                        │ A_throat
                        ▼
   AKI = CCI·A_throat/FIPRT → sub_port  (acoustic boundary, blair_step:575)
                        │
                        ▼
   sub_flow_out/in → HI1, CI1, MI1        (blair_step:583-590)
                        │
                        ▼
   sub_box( crankcase, VB1=VCC1, VB2=VCC2, MIN=MI1, MO=MTKT )      blair_step:299-301
                        │
                        └── PCC1, TCC1, MCC1 → next step's reed force
```

- The reed only ever touches **`MI1`**, the same variable the piston window produced. `BOX`'s mass
  balance `MB2 = MB1 + DMI − DME` (`sub_box.m:80`) is unchanged.
- `VCC2 = CCCV + HBDC·FPISTON` (`blair_step:103`) is unchanged — the reed changes the crankcase
  *mass*, never its *volume*.
- `VCC1` still comes back from `sub_box`'s `VB1 = VB2` side effect (`sub_box.m:93`, documented at
  lines 41-51). Nothing there is touched.
- `DRATIO` still accumulates `MI1·DTM/MREF` (`blair_step:591`) and `DR` still comes out of the same
  place. That is what makes the change auditable against the proxy sweep already in
  `RX135_SWEEP.csv`.
- The loop is closed with a **one-step lag on `PCC1`**, which is already how Blair's box works and is
  also how `CCI` is already selected (`blair_step:561`). No reordering needed, no iteration needed.

**One deck consequence.** With a reed, `FIPRT` must be the *block entrance* `A_ip` (Eq. 5.2.17), not
the seat, because `FIPRT` is the reference area of the inlet duct's port end and `A_throat` is
normalised against it. The `WIP = 40.2 mm` proxy line was chosen to make `FIPRT = 600 mm²`; that
number should be re-derived from the measured cage mouth.

## 3.4 Files touched

| file | change | net lines |
|---|---|---|
| `sub_reed.m` | **new** — petal EOM, contact logic, area laws | +110…150 |
| `reed_params.m` | **new** — geometry, material, derived `k`, `m_eq`, `A_rp`, `x_stop`, with provenance tags in the house style | +40…60 |
| `blair_init.m` | init `m.reed`, set `m.inlet_model` | +25…35 |
| `blair_step.m` | dispatch 225-230 gated on `inlet_model`; line 574 becomes three lines; `local_inport_open` branches | +15, ~12 changed |
| `reed_check.m` | **new** — the §1.5 oracle, plus a lift-vs-crank-angle trace | +70…90 |
| `sub_box.m`, `sub_port.m`, `sub_flow*.m`, `sub_parea.m`, `fport.m` | **untouched** | 0 |
| `load_case.m`, `INPUT_FORMAT.md`, `RX135_PROXY.dat` | **untouched** | 0 |

**≈ 300 new lines, ≈ 15 changed.** That is the same size as `sub_cylinder.m` (9.7 kB). It is a
weekend-shaped change, not a rewrite.

---

# 4. Work and the instability risk (Task 4)

## 4.1 The estimate

| step | effort | why it can go wrong |
|---|---|---|
| `reed_params.m` + `sub_reed.m` | 0.5 d | getting `k`, `m_eq` and the contact rule consistent |
| wiring `blair_step` / `blair_init`, keeping QUB on the old path | 0.5 d | the `HTDC` dispatch has a documented missing case (`HTDC == HIOT`, `blair_step:209-211`); the reed path deletes the question |
| `reed_check.m` against the §1.5 oracle | 0.5 d | must reproduce 160/185/144/261 Hz and 0.33/0.17 lift — this is where a factor-of-2 force error surfaces |
| run the 3000–9000 sweep, judge `DR`, convergence, stability | 0.5–1.0 d | see §4.3; `blair_run`'s convergence test is a 20-cycle mean, so a limit cycle shows up as "not converged", not as noise |
| notes / units / revert path | 0.25 d | — |
| **total** | **2.25–2.75 d** | |

Two hours would buy the area laws and a static lift (§5). It would not buy the dynamics, and the
dynamics are the part the crank window is standing in for.

## 4.2 Time step: is the petal actually stiff?

The usual worry about a reed is that it is a stiff oscillator that would force a much smaller step
than the duct Courant limit. **Measured against this code, it is not.** Numbers:

The crank step is set by `sub_stab` (`sub_stab.m:53-61`): `DC = 360·DZ/C`, `DTM = DC/(6·RPM)`. For
this deck that is **O(0.5–2) crank degrees**, i.e. `DTM ≈ 10–40 µs` at 7500–9000 rpm
(22.2 µs at 1°/7500 rpm).

| `f_1` | period | crank steps per period @1°/7500 rpm | margin vs explicit stability `ω·Δt < 2` |
|---|---|---|---|
| 160 Hz (Blair 125 GP glass) | 6.25 ms | 281 | 77× |
| **185 Hz (30 mm × 0.20 mm steel — our assumption)** | 5.41 ms | 243 | 67× |
| 312 Hz (20 mm × 0.20 mm steel) | 3.21 ms | 144 | 40× |
| 520 Hz (20 mm × 0.25 mm steel) | 1.92 ms | 87 | 24× |
| 1159 Hz (2nd mode of the 30 mm steel) | 0.86 ms | 39 | 9× |

A central-difference/Verlet integrator is stable to `ω·Δt < 2` and accurate to ~1 % at `ω·Δt < 0.2`.
At 185 Hz and 22 µs, `ω·Δt = 0.026`. **The free oscillation is not a stiff mode for this code — there
is a two-order-of-magnitude margin, and no sub-stepping is needed.**

Two caveats worth stating because they are where the time actually goes:

1. **Only one mode.** One mode is comfortably resolved. Two modes is 39 steps/period — still
   integrable, but Blair's 2-mode justification came with 1 mm pressure segmentation and Hinds'
   calibration, neither of which we have. **Do one mode**, and treat the second as a diagnostic
   printout, not a state.
2. **The step is variable.** `DC` is recomputed every step from the ducts, so the petal integrator
   must be written against the *actual* `m.DTM` of that step (semi-implicit Euler or a Verlet with
   the current `DTM`). Never assume a fixed `dt`, and never integrate the petal on a fixed 1° grid.

## 4.3 Where the instability actually is

Not the oscillator. Three other places, in descending danger:

1. **The stop.** A hard stop modelled as a penalty spring is the real stiffness: with a contact
   stiffness of `N·k`, the contact frequency is `sqrt(N)·185 Hz`. `N = 100` → 1.85 kHz → 24 steps per
   contact period, marginal; `N = 1000` → 5.9 kHz → 7.6 steps per period → **unstable**. So either
   cap `N ≲ 100` or, better, use the exact inelastic event (`x ← x_stop; v ← −e·v`), which is what
   Blair's "bounce off the reed stop" means anyway. **Recommendation: events, not penalty springs.**
2. **Chatter at the closing instant.** The petal closes when `PIR ≤ PCC1`; one step later the
   crankcase has been fed, `PCC1` rises, the petal reopens, and if the two are within a few hundred
   pascals the area can toggle at the step rate. Mitigations, in order: inelastic contact (`v` is
   killed, so reopening needs a real pressure), a small static hysteresis (`PIR − PCC1 > +Δp_c` to
   open, `< −Δp_c` to close, `Δp_c ≈ 100–300 Pa` — defensible: Blair's own design assumes a cracking
   differential, and `params.m:235` already carries 500 Pa), and a lift floor of ~1 % `L_r` so the
   area never reaches exactly zero.
3. **The one-step lag.** `PCC1` is the previous step's pressure. At 22 µs and 185 Hz the lag is
   0.4 % of a period — irrelevant physically, and it is the same lag the existing `CCI` selection
   already lives with. Do not "fix" it with iteration; iteration is where the code becomes slow and
   fragile.

Net: **the risk of a new instability is low, and it is a contact-handling risk, not a stiffness
risk.** The mitigation list above is about 15 lines.

## 4.4 Acceptance tests (write these before the model)

1. **Oracle.** Reproduce the eight numbers in §1.5 from `reed_params.m` + the area laws, with no
   engine running. Cheap, and it catches every unit error.
2. **Static limit.** With `ẍ = ẋ = 0` and `Δp = 0.18(CR_cc−1)·101325`, the model must return exactly
   Blair's Eq. 6.3.10 deflection (0.33·L for the 125 GP). This pins `k = 8EI/L³`.
3. **Period.** With `Δp` stepped to `P_load` and held, the computed first-mode period must match
   `1/f_1` within 2 %.
4. **No-op regression.** With `inlet_model = 'piston'`, `blair_validate` must return the identical
   QUB 400 result to the last digit. (Bit-identical, not "close".)
5. **Event timing.** On the RX135 sweep, opening and closing angles must fall inside the envelope
   Blair measured: open 140–160° BTDC, close 86–122° ATDC (**lines 23730-23732**). If they do not,
   either the geometry is wrong (likely) or the stiffness is wrong.
6. **Delivery ratio, against a known anchor.** The proxy already matches the *4-speed* rating at the
   right speed: 8.75 kW at 6500 rpm against a factory 8.9 kW / 12 PS @ 6500
   (`RX135_SWEEP.csv`; `PROJECT_STATUS.md:47`). It misses the 5-speed point: 9.05 kW at 7500 against
   10.4 kW (`PROJECT_STATUS.md:45`). A reed model should close the 7500 rpm gap *without* disturbing
   the 6500 rpm agreement — if it moves both, it is changing the whole inlet calibration, not adding
   the missing physics. `DR` is 0.764 at 7500 and 0.863 at 6500 today. Note that the deck is a
   hybrid (4-speed induction on a 5-speed cylinder) so neither rating is strictly binding
   (`PROJECT_STATUS.md:50`); use them as a sanity band, not a target.

---

# 5. If the reed model is too much (Task 5)

## 5.1 The cheapest defensible thing: 2 hours

**Port the quasi-static lift law that `sim/engine_model.m` already has into `local_inport_open`.**
Replace line 574 with:

```matlab
dp  = m.PIR - m.PCC1;                                  % both already exist
x   = min( max(dp,0)*m.reed.Ap/m.reed.k, m.reed.x_stop );
A_rd = m.reed.n_r * x * m.reed.X_p;                    % Eq. 5.2.19
m.AKI = m.CCI * min(m.reed.A_ip, A_rd) / m.FIPRT;      % line 19367
```

~25 lines including the header and the params block, one file plus one insert. **This is genuinely a
two-hour job**, and it is defensible in the literature because every line of it is Blair printed
text (Eq. 6.3.10, Eq. 5.2.19, line 19367) rather than a dynamics model we invented.

It is *much* better than a fixed piston window because it is:

- **pressure-driven**, so opening and closing are asymmetric about TDC by construction — the whole
  point of Fig. 1.8(c)/(d);
- **not tied to `IPO`**, so it deletes the single largest unrepresented field in the deck;
- **self-limiting**: it saturates at the stop and at zero, so it cannot produce a negative or
  unphysical area.

What it loses versus the dynamic model: the petal's inertia. It therefore *under-predicts* opening
lag at high speed and cannot ring, so `DR` will be slightly high at 9000 rpm and the closing point
will land too early. That is the honest cost, and it is the second-order term.

## 5.2 The 30-minute thing if even that is too much

Keep the crank window and multiply it by a pressure gate on the *sign* of the crankcase depression:

```matlab
if m.PCC1 < m.PA
    m.AKI = m.CCI * m.FIPRT/m.FIPRT;      % open
else
    m.AKI = 0;                            % seat closed
end
```

This is a check valve with zero inertia and a full-area opening — what `baseline/engine_model.m:173-179`
already does. It fixes the worst thing about the current proxy (a piston window that is *open while
the crankcase is above atmospheric* and therefore backflows) and nothing else. It is not a reed
model and should not be described as one.

## 5.3 A bug to fix on the way, whichever route you take

`params.m:248-250` and `engine_model.m:121` use

```matlab
rk = 3*rE*rI/rL^3;        % tip stiffness, POINT load at the tip
```

while Blair's Eq. 6.3.10 (`DEFL = P_load·X_r·L⁴/(8EI)`) is the **uniformly loaded** case:

```matlab
rk = 8*rE*rI/rL^3;        % 2.67x stiffer
```

For the currently assumed petal this is `k = 153 N/m` instead of **409 N/m**, so the quasi-static lift
is **2.67× too large**: 9.8 mm at 5 kPa instead of 3.7 mm. The petal is therefore modelled as pinned
against the stop over almost the whole inlet event, which is why the reed parameter sweep behaves
like a seat-area sweep. Two characters, and the existing model starts responding to `Δp`.

Also: `engine_model.m:217` uses petal width `rw` and the seat `rAs` where Blair uses port width `X_p`
(Eq. 5.2.19) and `A_ip` (line 19367). Same class of error, same fix.

---

# 6. Verdict

**Two days.** Concretely: 2.25–2.75 days for a one-mode dynamic petal with a verified oracle and a
re-run of the 3000–9000 sweep, of which about half a day is the verification harness rather than
physics. It is not two hours (that is the quasi-static version), and it is not a week, because the
change is one struct, one new file, one replaced line and one deleted dispatch — the duct, the box,
the flow relations and the acoustic boundary are all already in the right shape.

**What it needs that we do not have.** All of it is on the bench:

| # | missing | why it matters | how |
|---|---|---|---|
| 1 | **petal count** (`n_r`) — 2 assumed, 4 likely | scales the curtain area linearly; a factor-2 error in the inlet flow area | count them |
| 2 | **petal length, width, thickness** — 30/10/0.20 mm are Blair's *chainsaw* | `f_1 ∝ x_t/L_r²`, `k ∝ x_t³/L_r³`; sets both the dynamics and the lift | caliper + micrometer |
| 3 | **petal material** — steel assumed | `Y` 207 vs 20.8 GPa, `ρ` 7800 vs 1380 — a 10× and 5.6× error | magnet |
| 4 | **stop height** — 0.33·L assumed | it *is* the maximum flow area: `A_rd,max = n·x_stop·X_p` | feeler gauge |
| 5 | **port width / length / corner radius / clamp distance / block angle** | Eq. 5.2.18 gives the seat; the seat is the other half of `A_t = min(A_ip, A_rd)` | caliper + protractor |
| 6 | **crankcase volume** (`CR_cc = 1.343` assumed) | sets the whole pressure band the petal sees, i.e. the lift | fill test, engine assembled, BDC |
| 7 | **modal damping `ζ`** | only the ringing; pick 0.02–0.05 and say so | not measurable in-house |

Items 1–5 are one afternoon with the cage off — **and they also fix the existing quasi-static model,
which is currently wrong for a reason that has nothing to do with missing data (§5.3).** Item 6 is
independent of this task and is already the second-largest uncertainty in the case file.

If the cage cannot come off this week, do §5.1 (two hours) and §5.3 (two characters). That removes
the crank-angle fiction honestly and leaves the inertia for later. Doing neither, and continuing to
run a 600 mm² × 120° piston window on a reed-valve engine, is the one option with no defence.

---

## Appendix — citation index

`references/text/Blair,_G.P._-_Design_and_Simulation_of_Two-Stroke_Engines_(S.txt` (33 534 lines)

| lines | p. | content |
|---|---|---|
| 2012-2034 | 17 | §1.3.3 reed valves, V-blocks, materials |
| 2054-2055 | 18 | Fig. 1.8 piston / disc / reed timing |
| 2145-2156 | 19-20 | §1.3.4 asymmetric at low speed, symmetric at high speed |
| 19264-19288 | 367-368 | reed induction; the two face pressures and the force |
| 19274 | 367 | Fig. 5.4 petal and block dimensions |
| 19292-19333 | 368-369 | Hinds cantilever, Eq. 5.2.15, modes, 1 mm segmentation, bounce off stop, 2-mode adequacy, thesis pointers |
| 19306-19315 | 368 | `Y`, `ρ`, `I`, `A` (Eq. 5.2.16), `β_j L_r` = 1.875…14.137 |
| 19334-19352 | 369 | Eqs. 5.2.17, 5.2.18, 5.2.19; curtain at the port end, not the tip |
| 19357-19370 | 369 | no cosine correction; `A_t = min(A_ip, A_rd)`; data required |
| 19375-19380 | 369 | Eq. 5.2.20 tip lift ratio |
| 20701 | 396 | 125 GP: six glass petals, 38 × 22.7 × 0.42 mm |
| 23473-23502 | 446-447 | §6.3; disc easy, **reed complex** |
| 23536-23723 | 448-449 | Figs 6.24-6.26 measured vs predicted lift and `DR` |
| 23730-23736 | 450 | RVO/RVC 160/86 @5430, 140/122 @9150 |
| 23755-23796 | 450-451 | matched-area criterion; material properties |
| 23810-23847 | 451-452 | isosceles 200° assumption, Eqs. 6.3.1-6.3.3 |
| 23850-23871 | 452 | Fig. 6.27 full reed data set + outputs |
| 23893-23903 | 453 | 20 % natural-frequency rule |
| 23904-23923 | 453 | lift ratio 0.15-0.3, Eq. 6.3.5, Eq. 6.3.6 |
| 23929-23952 | 453-454 | Eqs. 6.3.7-6.3.9, stop radius, `C_rdt` = 0.3 |

`references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt` (31 387 lines)

| lines | p. | content |
|---|---|---|
| 11055-11065 | 235-236 | **"Prog.5.2 does not contain … reed valve induction"** |
| 13569-13579 | 287 | Eqs. 6.3.5-6.3.8: `MI`, `Mo`, `FREQ1 = 1.758·TERM/π`, `FREQ2 = 11.015·TERM/π` |
| 13581-13587 | 287 | forcing = rps; 20 % rule |
| 13601-13612 | 287 | Eqs. 6.3.9-6.3.11: `P_load`, `DEFL = P_load·RDWD·RDLN⁴/(8·YMOD·MI)` |
| 13615-13621 | 288 | Eq. 6.3.12 stop radius |
| 13655-13714 | 289 | chainsaw 30 mm/0.20 mm/**185 Hz**; 125 GP 38 mm/0.25 mm/**144 Hz**; carbon 0.60 mm/**261 Hz** |
| 13684-13705 | 155 | Fig. 6.19 full carbon-reed data set |
| 29525-29545 | 631-632 | Prog.6.4 arithmetic verbatim (`TERM`, `FREQ1`, `DEFLECTION`, `STOPRAD`) |
| 29754-29767 | — | material table: steel 2.07e11/7800, glass 2.15e10/1850, carbon 2.08e10/1380 |
| 27946-27950 | 598 | SUB FPORT — the piston-port inlet law being replaced |

Repo:

| file:lines | content |
|---|---|
| `sim/blair/blair_step.m:225-230` | crank-angle inlet dispatch (deleted for reeds) |
| `sim/blair/blair_step.m:559-592` | `INPORTOPEN`, incl. the `fport` call at 574 |
| `sim/blair/blair_step.m:299-301` | crankcase `BOX` call — the coupling point |
| `sim/blair/sub_box.m:77-95` | crankcase mass/energy step (unchanged) |
| `sim/blair/sub_parea.m:85-92`, `fport.m` | `FPORT` (kept for the piston-port cases) |
| `sim/blair/sub_stab.m:53-61` | `DC`/`DTM`, the step the petal must use |
| `sim/params.m:232-252` | the seven assumed reed parameters |
| `sim/engine_model.m:107-122, 206-223` | the existing quasi-static reed and its `3EI` bug |
| `port/RX135_CASE_NOTES.md:269-293, 470-476` | why the inlet block is `NOT AVAILABLE`; what to measure |
| `sim/audit/sweep_reed_A.csv` | 400→800 mm² seat: 6.79→8.12 kW |
