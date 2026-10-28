# Numeric constants extracted from four local papers

Target model: crank-angle 0-D, 132 cc, 58 mm bore x 50 mm stroke, crankcase-scavenged
loop-scavenged SI two-stroke (Yamaha RX135).

Rules applied here:

* Every value is quoted verbatim from the extracted `.txt` file, with the line number of that file.
* "NOT FOUND" means the paper does not contain the number. Nothing is inferred or back-filled
  from general knowledge.
* Values from a different architecture are marked **NOT TRANSFERABLE** with the reason.
* Where the PDF text extraction mangled an equation, the mangled glyph block is reproduced and the
  value is flagged rather than silently reconstructed.

Line numbers refer to the `references/text/*.txt` files, **not** to journal page numbers.

---

## Paper A — Hooper, "Study of the effects of trapped compression ratio on the heavy fuel operation of a spark ignition UAV engine" (Aircraft Eng. & Aerospace Technology, AEAT-07-2021-0220.R2)

**Architecture: twin-cylinder, 342 cm3, 66 x 50 mm, crankcase-scavenged, loop-scavenged (Schnürle,
five transfer ports), SI, reed-valve induction.** This is the *same* architecture as our engine and
the same 50 mm stroke, so it is the most directly usable of the four papers.

> Note: this text file contains the manuscript twice (the body repeats from about line 4200 onward).
> All line numbers below refer to the first occurrence.

### A.1 Discharge coefficients (Cd)

No numeric Cd anywhere in the paper. What it does say:

* L620–625: "Within a two-stroke cycle engine equipped with ports in the cylinder walls, the flow of air/exhaust is defined by the gas properties and the position of the piston. Port effective flow area can be defined by determining their discharge coefficients (Cd) at varying port opening or piston positions. However, Blair (1996) argues that whilst this approach can be used effectively to improve port flow characteristics, it is of limited assistance within one-dimensional fluid dynamic engine models due to limitations of the models to be able to reproduce the actual thermodynamics occurring within the real engine. For this reason, isentropic methods can be adopted."
* L715–722: "As the port pressure ratio varies the Cd value varies significantly. Heywood and Sher (1999) found that the steady flow Cd value is normally higher than the comparative value determined via unsteady flow conditions. Within WAVE it is possible to define flow coefficients where data is available. A key input function was taken from the engine porting analysis shown in Figure 5 to define flow areas and timing of all modelled ports."
* L2513–2516: nomenclature lists "Cd  Discharge coefficient" and "Cd  Flow coefficient" — **two distinct symbols, no values**.

**Verdict: Cd values NOT FOUND.** The paper is explicit that it did *not* calibrate Cd but used
isentropic (ideal) port flow with geometric flow areas instead. This is a direct warning against
tuning Cd in a 1-D model of a loop-scavenged engine unless you have flow-bench data.

### A.2 Scavenging (SE, TE, DR, charging efficiency, SE-vs-SR)

* L2590–2591: "DR  Delivery ratio" (nomenclature entry only).
* Otherwise: **NOT FOUND.** No SE, no TE, no DR, no charging-efficiency number, and no
  Benson-Brandham / two-zone scavenging model constants appear anywhere in the paper.
* Related but not scavenging-model constants:
  * L383–384 (Table 1): "Crankcase compression ratio (rcc)  1.5:1"
  * L381–382 (Table 1): "Trapped compression ratio (rcTrap)  7.1:1"
  * L615–618: "Figure 5. Port flow time - area history" (a figure; the time-area data are *not*
    tabulated in the text, so no numeric port-area curve can be recovered here).

### A.3 Combustion (Wiebe / Vibe)

* L724–726: "The work of Wiebe (1967) established the formula in equation (8) for assessment of the mass fraction burnt by the combustion process. This formula forms the basis of calculations within WAVE."
* L735–738: "The research of Heywood and Sher (1999) analysing similar crankcase scavenged spark ignition two-stroke cycle engines has been used to influence the Wiebe function development within this study. Sher (1984) identified values for b and c of 5 and 3 to 3.2 respectively following combustion rate analysis of the engines in question. In the absence of specific data for the subject engine this prior research has been considered here."

So: **b = 5, c = 3 to 3.2** — for a crankcase-scavenged SI two-stroke, i.e. our architecture.

**Convention: the paper does not state it in recoverable text.** Equation (8) exists only as an
image; the extraction produced the following glyph block at L807–821:

```
807:  −b
808: b
809: 0
810: Δθ
811: θ
812: -
813: θ
814: c
815: -
816: exp
817:  -
818: 1
819: θ
820: x
821: m
```

i.e. the form is `x(θ) = 1 - exp[-c((θ-θ0)/Δθ)^...]` with *b* in the exponent position and *m*
elsewhere, but the exact `b` vs `b+1` (or `m` vs `m+1`) pairing is lost. **Do not adopt b = 5 as `m`
without checking the WAVE/Wiebe convention** — if the code expects `m` and the paper quotes the
exponent, m = 5 is right; if the code expects `m+1`, it is m = 4. This single ambiguity is the most
likely source of a wrong burn rate in the model.

* **Burn duration in crank degrees: NOT FOUND.** Only the symbol is defined — L2689–2690:
  "Δθb  Duration of combustion". No numeric value is given.
* **Wiebe `a` (efficiency factor): NOT FOUND.** No `a` value is stated.
* **Ignition delay:** the paper gives the Douaud & Eyzat knock-integral induction time, not a
  spark-to-flame-development delay (L903–916):
  > "𝜏= 0.01869𝐴𝑝( 𝑂𝑁/100) 3.4017 𝑝𝑐𝑦𝑙 −1.7 𝑒𝑥𝑝( 3800 𝐴𝑇 ⁄ 𝑇𝑢𝑛𝑏)"  (L908–916)
  Constants: **0.01869, 3.4017, −1.7, 3800**; `Ap` and `AT` are user multipliers, `ON` fuel octane
  number, `Tunb` unburned-gas temperature.
* L927–932: knock criterion "∫ 𝑑𝜏/𝜏 = 1" (limits t0 to ti).
* L962–963: "B0, is a frequency factor (2233 x 103 Hz)" — post-knock burn, `B0 = 2.233e6 Hz`.
* L951–955: post-detonation burn time prefactor "0.8573".

### A.4 Heat transfer

* L740–741: "A critical aspect of any engine model is within the assumptions for heat transfer. In the WAVE models the following calculation for heat transfer coefficient, h, was used: -"
* L749–753 (the usable part): "Equation (9) is derived from the research of Woschni (1967). The mean piston speed was found by Woschni to be able to equate to the characteristic gas speed, vch. The variable Cm, in equation (9) is a scaling factor based upon cylinder bore diameter. If for example the piston crown has a flat non-domed design the value for Cm would be unity, as it was for the subject engine. The combustion chamber is a concentric recess as can be seen in Figure 1. The surface area of the chamber was analysed resulting in a value for Cm of 1.315."

  → **Cm = 1.0** (flat crown, and the sentence claims this "was" the subject engine) and
  **Cm = 1.315** (concentric recess, obtained from a surface-area analysis of their "Figure 1").
  The two statements in the same paragraph are inconsistent; 1.315 is evidently the value actually
  used, since their chamber is a recess. **Quote them separately and do not present 1.0 as this
  engine's value.**

* The Woschni equation itself survives only as a glyph block, L818–835, which reads:
  `h = 0.0128 D^-0.2 P^0.8 T^-0.53 v_ch^0.8 C_m` (constant **0.0128** at L832; exponents
  **0.8 / −0.53 / 0.8 / −0.2** at L822–826; `D`, `P`, `T`, `v_ch`, `C` at L827–831).
* L755–762: "The Colburn analogy as defined by Bird et al (2002), and shown in equation (10), is used by WAVE to calculate heat transfer in areas remote from the cylinder." Equation (10) as extracted: `ℎ= 𝐶𝑓/2 𝑝𝑈𝑐𝑝𝑃𝑟^−2/3` (L758–762) — i.e. Pr exponent **−2/3**.
* **Wall temperatures: NOT FOUND.** No piston/liner/head surface temperature is quoted for this engine.
* **Heat transfer coefficients: NOT FOUND** (no h values in W/m2K are tabulated).

### A.5 Friction

* L771–774: "An allowance for engine friction within WAVE is provided by the expression developed by Chen and Flynn (1965) and shown in equation (11). Unfortunately, Morse test (Stone, 2012) data was unavailable for the engine so values for friction mean effective pressure (pf) typical for crankcase scavenged engines were used in this study to make the correlation representative here."
* L776–786: `𝑝𝑓= 𝑐1 + 𝑐2(𝑝𝑚𝑎𝑥) + 𝑐3 𝑁𝑠/2 + 𝑐4 (𝑁𝑠/2)^2` — **structure only, c1..c4 NOT FOUND.**
* L1947–1949 (Discussion): "Further work could be conducted to provide a closer correlation of engine friction mean effective pressure within the engine models. … All modelling was therefore conducted with typical values associated with crankcase scavenged two-stroke cycle engines."

**Verdict: no FMEP number and no c1..c4 values. NOT FOUND.** The authors admit the friction term was
never validated, so these are not a literature anchor even in principle.

### A.6 Engine specs and performance (for transfer judgement)

Table 1, L371–398:

```
372: Table.1. Standard engine design data
373: Swept Volume (cm3)   342
375: No. of cylinders     2
377: Bore (mm)            66
379: Stroke (mm)          50
381: Trapped compression ratio (rcTrap)  7.1:1
383: Crankcase compression ratio (rcc)    1.5:1
385: Induction control   Single 6 petal reed valve (steel reeds)
387: Fuel system         Single diaphragm carburettor
392: Fuel                Gasoline (with 4% SAE40 two-stroke oil added)
396: Lubrication system  Total loss (Premixed fuel)
397: Exhaust system      Short stub pipes
```

Other numbers:

* L273–274: "the engine is a 180° horizontal flat-twin design and employs a shared crankcase providing scavenge air for both cylinders. Each cylinder of the engine displaces a swept volume of 171 cm3."
* L480–482: "The cylinders use a five-transfer port arrangement that adopts the loop scavenging process developed originally by Schnürle…"
* L487–489: "The engine also uses two exhaust ports per cylinder with a central bridge exhausting into short stub pipes of 122 mm length…"
* L496–497: "The steel reeds applied in this study were 17.5 mm wide, 25 mm effective length and 0.2 mm thick."
* L586–587: "Values for the 𝛽𝑗𝑙𝑟 term in equation (3) relate to the reed modes of vibration with values of 1.875, 4.694, 7.855, 10.996 and 14.137 recommended."
* L1545–1550: "The engine has a full geometric stroke compression ratio (rc) of 9.2:1. This equates to a TCR of 6.74:1." … "Alternative shims were machined giving ratios of 6.00:1 (8.02:1) and 5.65:1 (7.28:1)."  → **inconsistency in the paper itself**: Table 1 says TCR 7.1:1, the text says 6.74:1 for rc = 9.2:1.
* L1079–1080: "the maximum power from the experimental testing can be seen to occur at 6500 RPM with a value of 16.27 kW. The minimum full load SFC occurs at 6000 RPM with a value of 0.464 kg/kWh."
* L1954–1955: "a maximum power of 15.35 kW at 6500 RPM with a corresponding SFC of 0.536 kg/kWh to be recorded compared with 16.27 kW and 0.481 kg/kWh at the same speed using gasoline."
* Model outputs (not constants, but usable as validation targets, 6000 RPM):
  * L1509–1513: "The maximum cylinder pressure, shown in Figure 9, for inlet injection is 31.9 bar occurring at 12.2° ATDC. For the auxiliary port injected model, the maximum cylinder pressure can be seen to have increased to 33.5 bar and occurs at 13.1° ATDC. In terms of the predicted torque throughout the same cycles the peak positive torque is 119.1 Nm for inlet injection with a peak negative of -35.3 Nm."
  * L1832–1833: "the maximum cylinder pressure using 6.00:1 TCR is 28.8 bar occurring at 13.1° ATDC. Reducing the TCR to 5.65:1 shows a predicted maximum cylinder pressure of 26.2 bar at 14.1° ATDC."
* **BMEP: NOT FOUND** (power and speed are given, BMEP never is).
* L1189–1246 (Table 2) tabulates port-open time vs speed, which is a usable cross-check on our port
  timing: "Port Open Time (ms)" 5.50 at 3000 rpm, 4.71 at 3500, 4.13 at 4000, 3.67 at 4500, 3.30 at
  5000, 3.00 at 5500, 2.75 at 6000, 2.54 at 6500, 2.36 at 7000.
* L1742–1743: "a potential value for RON of 58.6 has been calculated for a cetane value of 30" (JET A-1 knock modelling only — irrelevant to a gasoline model).
* L1098–1099: auxiliary-port injection pressures "2.75 bar" and "7.25 bar".

---

## Paper B — Kravchenko, Obodets, Kuzmenko, "Improving the energy efficiency of a two-stroke engine with crankcase scavenging for UAVs by implementing an electronic fuel injection system" (Combustion Engines 2026;204(1):72-80)

**Architecture: crankcase-scavenged, loop-charged, SI two-stroke UAV engine — nominally the right
architecture, but this is an electronics/ECU paper. No engine was built or tested.**

This is the key limitation, stated by the authors themselves:

* L708–712: "The next stage of research will focus on testing the developed injection system directly on a two-stroke internal combustion engine, with an assessment of the efficiency and environmental characteristics of the fuel-injected engine in comparison to the carbureted version."

### B.1 Discharge coefficients

* L271–277: "𝑚𝑓𝑢𝑒𝑙 = 𝜇𝑆𝑖𝑛𝑗√2 ∙𝑔 ∙𝜌𝑓(𝑃𝑓𝑢𝑒𝑙 −𝑃𝑚) ∙𝑃𝑊 … where ṁfuel denotes the mass flow rate of fuel during a single injection event, 𝜇 is the injector discharge coefficient…"

**μ is named but never valued. Cd for ports: NOT FOUND.**

### B.2 Scavenging

**NOT FOUND.** No SE, TE, DR or charging-efficiency value appears. (Only qualitative statements,
e.g. L142–145: "Although fuel injection into the intake manifold of two-stroke engines does not
eliminate fuel–air mixture losses during scavenging…")

### B.3 Combustion

**NOT FOUND.** No Wiebe parameters, no burn duration, no ignition delay.

### B.4 Heat transfer

**NOT FOUND** as a model constant. The only temperature numbers are sensor specifications:

* L538–541: "A platinum PT100 sensor is used as the engine cylinder temperature sensor (CHT). Its characteristics enable high-accuracy temperature measurements across a wide operating range from –50°C to +400°C."

### B.5 Friction

**NOT FOUND.**

### B.6 Engine specs

**NOT FOUND — this paper has no test engine.** Bore, stroke, displacement, speed, BMEP and power of
a specific engine are never given. All performance numbers are quoted from *other* authors' work:

* L154–156: "in [12] … an increase in power from 3.6 kW to 4.2 kW was observed, accompanied by a reduction in HC emissions from 2310 ppm to 1200 ppm."
* L182–184: "there was a notable reduction in brake-specific fuel consumption (BSFC), reaching 300 g/kWh, compared to 370 g/kWh for the carbureted version."
* L185–188: "hydrocarbon emissions were reduced by 53%, and carbon monoxide (CO) emissions by 40%".
* L190–192: "the maximum brake thermal efficiency was increased by 9.1%, while unburned HC emissions were reduced by 79.3% and CO emissions by 94.5%".
* L149: "fuel injection can provide up to 20% higher output power relative to a carbureted version."
* L162–163: "the thermal efficiency of the cycle was improved by 5–25%."

Other numbers that might be mistaken for model constants but are *not*:

* L211–213: "typically from 8.0 to 25.5. The stoichiometric ratio is approximately 14.7."
* L366: "operating above 1000 meters".
* L541: CHT sensor range −50 to +400 °C (see B.4).

**Verdict on Paper B: contains no usable simulation constants.** Its value to us is only the
injector-flow equation form (B.1) and the AFR window (8.0–25.5). Do not cite it for scavenging,
combustion, heat transfer or friction.

---

## Paper C — Sun, Wang, Zhang, Zhao, Zhang, Zhu, "Analysis of the interactive effects of scavenge parameters on spark ignition two-stroke diesel engines" (J. Phys.: Conf. Ser. 2760 (2024) 012049)

**Architecture: single-cylinder, crankcase-scavenged ("intake crankcase turbocharging", L164),
compression-ignition diesel, GT-POWER 1-D, rated 5500 r/min.** The title says "spark ignition
two-stroke diesel", which is self-contradictory; the body treats it as a diesel
("two-stroke diesel engine", L47, L72, L147; "diesel-electric hybrid power devices", L93).

### C.1 Discharge coefficients

**NOT FOUND.** No Cd is mentioned at all.

### C.2 Scavenging

This is the paper's whole subject, but the numbers are *optimiser outputs*, not model constants, and
they are for a diesel:

* L169: "Considering the actual application range of the crankcase compression ratio, the exploration range here is 1.2 ~ 2.4"
* L170–175: "The effect of crankcase compression ratio on scavenging under engine calibration conditions (5500 r/min) is shown in Figure 4. … When the compression ratio of the crankcase is 1.5, the scavenging efficiency reaches a maximum of 95.14%."
* L182–188: "when the crankcase compression ratio increases to 1.8, continuing to increase the crankcase compression ratio will result in a smaller change in engine torque, but it will lead to a rapid increase in engine fuel consumption. … Therefore, considering both power and economic factors, a crankcase compression ratio of 1.8 can achieve relatively good engine performance."
* L216–217: "the airport width ratio coefficient is set between 0.8 and 1.2."
* L225–226: "When the width coefficient of the scavenging port is 1.0 and the width coefficient of the exhaust port is 0.8, the scavenging efficiency reaches the maximum value of 97.2%."
* L245–247: "Original machine gas distribution phase: the opening angle of the scavenging port is 124° CA, and the closing angle of the intake port is 236° CA; The opening angle of the exhaust port is 87° CA, and the closing angle of the exhaust port is 273° CA."
* L248–249: "the timing deviation of the airport is set between ± 2° CA."
* L259–260: "When the scavenging port is at 125° CA and the exhaust port is open at 89° CA, the scavenging efficiency reaches its maximum value of 96.4%."
* L55–59 (abstract) contradicts the body: "the engine scavenging efficiency reaches 96.44% when the scavenging port timing is 123° CA and the exhaust port timing is 89° CA." → **123° in the abstract vs 125° in the body (L259, L285). Internal inconsistency; do not use the abstract number.**
* Definitions used (L128–153), useful for making our SE/TE/DR consistent with theirs:
  * L128–132: "Scavenge efficiency ∅ is the ratio of 1 (the mass of fresh gas left in the cylinder after the air exchange process is completed), and 0 (the total mass of gas in the cylinder)."
  * L133–141: supply ratio (their "excess scavenging coefficient") = trapped-delivery mass / reference filling mass.
  * L147–150: "The scavenging efficiency of a two-stroke diesel engine ∅ can be approximately defined as the excess scavenging coefficient ∅ and capture rate 0, the product is i.e.: ∅ = ∅ · 0"
* Numeric trapping efficiency, delivery ratio, charging efficiency: **NOT FOUND** (Figure 3 only;
  no numbers in the text).
* SE-vs-SR correlation / Benson-Brandham break point / two-zone constants: **NOT FOUND.**
* Model validation quality, L111–113: "During the combustion process, there is a certain error due to the calculation error of the heat transfer process, but the maximum error is less than 5%."

### C.3 Combustion

**NOT FOUND.** No Wiebe, no burn duration, no ignition delay.

### C.4 Heat transfer

**NOT FOUND** (only the passing remark at L112–113 that heat-transfer calculation error exists).

### C.5 Friction

**NOT FOUND.**

### C.6 Engine specs

**NOT FOUND for bore/stroke/displacement/BMEP/power.** The paper never states them. What exists:

* L98–99: "A one-dimensional performance simulation model of a spark ignition two-stroke single-cylinder diesel engine was established based on the engine of a certain drone as a reference structure".
* L170: calibration/rated condition "5500 r/min".
* L164: "The two-stroke engine in this study adopts intake crankcase turbocharging".
* Port timing and width ratios as above (C.2).

**Verdict on Paper C: the 95.14% / 97.2% / 96.4% scavenging efficiencies are NOT TRANSFERABLE.**
They are (i) diesel, not SI; (ii) from a 1-D model whose scavenging sub-model was never described;
(iii) implausibly high for a loop-scavenged crankcase-scavenged cylinder — real loop-scavenged SI
two-strokes trap 60–80% (see Paper D's fired values, 0.61–0.68). Using 95% in our model would
substantially over-predict trapped charge. The only transferable idea is the *shape* of the result:
SE is non-monotonic in crankcase compression ratio with a maximum near 1.5–1.8.

---

## Paper D — Wang et al., "Evaluations of Scavenge Port Designs for a Boosted Uniflow Scavenged Direct Injection Gasoline (BUSDIG) Engine by 3D CFD Simulations" (SAE 2016-01-1049)

**Architecture: single-cylinder 0.5 L, 80 x 100 mm, CR 14:1, boosted (Pi = 1.2-2.0 bar), uniflow
scavenging (liner intake ports + 2 poppet exhaust valves in a flat head), direct injection gasoline,
1000-3000 rpm, 3-D CFD (STAR-CD).** **Every scavenging number below is NOT TRANSFERABLE to our
engine** — uniflow + boost + poppet exhaust + DI is a fundamentally different gas-exchange system
from crankcase-scavenged loop scavenging. They are recorded because they define the *upper bound* of
what good scavenging looks like, and because the definitions are the cleanest of the four papers.

### D.1 Discharge coefficients

**NOT FOUND.** No Cd is used or quoted; the port boundaries are pressure boundaries (L175–176).

### D.2 Scavenging

Definitions (L349–379) — the most rigorous set of the four papers:

* L353–356: `DR = delivered fresh charge mass / reference mass`
* L358–363: `TE = mass of delivered fresh charge retained in the cylinder / total mass of delivered fresh charge = CE/DR`
* L368–372: `SE = mass of delivered fresh charge retained in the cylinder / total mass of trapped cylinder charge`
* L373–377: `CE = mass of delivered fresh charge retained in the cylinder / reference mass`
* L378–379: "The reference mass in above equations is calculated by the displaced volume multiplied by the ambient air density."

Cold-condition values at Pi = 2 bar, digitised from the figure data labels in Fig. 8 (labels at
L493–528; the plotted order is DR, TE, SE, CE as given by the legend at L547–550, and the ordering is
confirmed by the text statement that SE = 100% at 1000 rpm, L464–467):

| speed | SPN | DR | TE | SE | CE |
|---|---|---|---|---|---|
| 1000 rpm | 12 | 6.59 | 0.23 | 1.00 | 1.55 |
| 1000 rpm | 8  | 6.33 | 0.23 | 1.00 | 1.45 |
| 1000 rpm | 6  | 5.96 | 0.23 | 1.00 | 1.38 |
| 2000 rpm | 12 | 3.33 | 0.48 | 0.96 | 1.60 |
| 2000 rpm | 8  | 3.21 | 0.47 | 0.94 | 1.51 |
| 2000 rpm | 6  | 3.03 | 0.47 | 0.92 | 1.41 |
| 3000 rpm | 12 | 2.24 | 0.67 | 0.87 | 1.50 |
| 3000 rpm | 8  | 2.20 | 0.65 | 0.85 | 1.42 |
| 3000 rpm | 6  | 2.08 | 0.63 | 0.82 | 1.32 |

Backed by text: L464–467: "At low engine speed (i.e. 1000 rpm), the increase in the absolute scavenging duration leads to significantly higher DR and complete scavenge (SE=100%)."

Intake-pressure sweep, 2000 rpm (labels L620–655, legend L662–664 for SPN, L674–676 for the four
parameters):

| Pi | SPN | DR | TE | SE | CE |
|---|---|---|---|---|---|
| 1.2 bar | 12 | 1.37 | 0.66 | 0.88 | 0.90 |
| 1.2 bar | 8  | 1.36 | 0.64 | 0.86 | 0.86 |
| 1.2 bar | 6  | 1.26 | 0.63 | 0.81 | 0.80 |
| 1.6 bar | 12 | 2.44 | 0.52 | 0.95 | 1.27 |
| 1.6 bar | 8  | 2.40 | 0.50 | 0.93 | 1.20 |
| 1.6 bar | 6  | 2.28 | 0.49 | 0.90 | 1.12 |
| 2.0 bar | 12 | 3.33 | 0.48 | 0.96 | 1.60 |
| 2.0 bar | 8  | 3.21 | 0.47 | 0.94 | 1.51 |
| 2.0 bar | 6  | 3.03 | 0.47 | 0.92 | 1.41 |

Fired-condition values, which are the physically relevant ones (L743–747):

> "DR gradually increases from 1.66 at AIA= 45⁰ to 1.96 at AIA=90⁰, and CE increases from 1.03 to 1.19. However, AIA shows only slight impact on SE which increases from 0.92 at AIA=45⁰ to 0.95 at AIA=90⁰. TE slightly decreases from 0.62 to 0.61."

Fired-condition SPO/EVO sweep, SPH = 14 mm, 2000 rpm, Pi = 2 bar (labels L1074–1109, legend
L1114–1118 for SPO/EVO and L1125–1128 for DR/TE/SE/CE); each cell is DR / TE / SE / CE:

| SPO | EVO 107 | EVO 117 | EVO 127 |
|---|---|---|---|
| 116 °CA | 2.38 / 0.60 / 0.97 / 1.42 | 2.28 / 0.63 / 0.96 / 1.43 | 2.28 / 0.59 / 0.96 / 1.35 |
| 122 °CA | 2.51 / 0.59 / 0.97 / 1.47 | 2.33 / 0.61 / 0.96 / 1.43 | 2.39 / 0.51 / 0.96 / 1.23 |
| 128 °CA | 2.69 / 0.58 / 0.98 / 1.56 | 2.34 / 0.57 / 0.97 / 1.34 | 1.87 / 0.56 / 0.95 / 1.05 |

Fired, SPH = 18 mm (labels L1223–1246; 128 °CA not run, L1210–1213):

| SPO | EVO 107 | EVO 117 | EVO 127 |
|---|---|---|---|
| 116 °CA | 2.51 / 0.57 / 0.97 / 1.44 | 2.37 / 0.60 / 0.96 / 1.43 | 2.33 / 0.58 / 0.96 / 1.34 |
| 122 °CA | 2.64 / 0.56 / 0.98 / 1.48 | 2.44 / 0.59 / 0.97 / 1.43 | 2.13 / 0.57 / 0.96 / 1.21 |

Fired, appendix (Pi = 2 bar, 2000 rpm; labels L1624–1647, legend L1654–1655 for the two port designs,
L1664–1667 for DR/TE/SE/CE): AIA=90/SOA=20 → 2.39 / 0.51 / 0.96 / 1.23; AIA=60/SOA=31.5 →
1.87 / 0.61 / 0.94 / 1.14. At Pi = 1.2 bar fired (L1677–1692): 0.91 / 0.80 / 0.82 / 0.72 and
0.86 / 0.79 / 0.81 / 0.68. L1714–1716: "The results with Pi=1.2 bar are extremely low (DR, SE and CE < 0.1) and not shown in this figure."

Other numeric statements:

* L607–609: "The maximum percentage changes of DR, TE, SE and CE under different operating conditions are 9.6%, 5.8%, 8.0% and 12%."
* L289–291: "a swirl ratio no less than 3 is expected to enhance the mixing between the fuel droplets and in-cylinder charge and meanwhile prevent the wall wetting." (**SR here means swirl ratio, not scavenging ratio — do not confuse with the SE-vs-SR correlation we are looking for.**)
* L1164–1172: "When the EVO is fixed at 117 ⁰CA, the exhaust valve profile is asymmetric to BDC, leading to same ECR and EER around 11. … The lower limit of ECR and EER is around 10.22 … a later SPO of 128 ⁰CA can extend the higher limit of ECR or EEC to 11.98."

**SE-vs-SR (scavenging ratio) correlation, Benson-Brandham break point, two-zone split constants:
NOT FOUND** in this paper as well. No scavenging model is fitted; the CFD predicts SE directly.

### D.3 Combustion

**NOT FOUND.** Combustion is explicitly excluded — L416–418: "the multi-cycle simulation is not possible via CFD without a validated combustion model. As the combustion process is not included in this study, the results from the first cycle are analyzed".

### D.4 Heat transfer

No correlation constants, but **wall temperatures are given** (Table 2, L197–244) — the only wall
temperatures in the four papers:

```
236: Piston head temperature (Thead)   340 K (cold)   440 K (fired)
239: Piston top temperature (Tpiston)  360 K (cold)   522 K (fired)
242: Cylinder liner temperature (Tliner) 320 K (cold)  384 K (fired)
```

and the gas/port boundary temperatures:

```
211: Cylinder temperature (T cylinder)  400 K (cold)  1665 K (fired)
214: Cylinder pressure (P cylinder)     2 bar (cold)  8.6 bar (fired)
217: Intake temperature (T intake)      300 K (cold)  350 K (fired)
220: Exhaust temperature (T exhaust)    350 K (cold)  800 K (fired)
223: Exhaust pressure (P exhaust)       1.01 bar (cold) 1.06 bar (fired)
```

* L167–168: "The Angelberger wall function was used for the simulation of the wall heat transfer."
* No Woschni/Annand constants, no h values: **NOT FOUND**.

### D.5 Friction

**NOT FOUND.** (CFD gas-exchange study; friction never enters.)

### D.6 Engine specs

Table 1, L114–128:

```
115: Bore 80 mm
117: Stroke 100 mm
119: Connecting rod 180 mm
121: Displacement 0.5 L
123: Compression ratio 14:1
125: Cylinder head Flat roof / 2 exhaust valves
127: Piston Flat piston
```

Port geometry and timing:

* L111–113: "Twelve evenly distributed scavenge intake ports were integrated to the cylinder block."
* L143–145: "The width of each scavenge intake port was fixed at 20⁰ and the interval between ports was fixed at 10⁰".
* L1205–1213: "the scavenge port height (SPH) was increased from original 14 mm to 18 mm".
* L201–209: "Exhaust valve duration (ED) 126 °CA ATDC / Exhaust valve lift (EL) 8.64 mm / Exhaust valve opening (EVO) 127 °CA ATDC".
* L1026–1028: "SPO=116 °CA / SPO=122 °CA / SPO=128 °CA"; L1009–1011: "EVO=127 °CA / EVO=117 °CA / EVO=107 °CA".
* Speeds investigated: 1000, 2000, 3000 rpm (L463–464, L534–557). **BMEP/power: NOT FOUND.**

---

## Cross-paper summary table

| Constant | Value | Source (file, line) | Architecture | Transferable to our 58 x 50 crankcase-scavenged loop-scavenged SI engine? |
|---|---|---|---|---|
| Wiebe `b` | 5 | Paper A, L737 | Crankcase-scavenged loop-scavenged SI 2-stroke, 66x50 | **YES, with caution** — same architecture and near-identical bore/stroke; but confirm whether the code's exponent is `b` or `b+1` (equation image lost, L807–821) |
| Wiebe `c` | 3 to 3.2 | Paper A, L737 | same as above | **YES, with caution** (same caveat; range spans two-zone/flame-development differences) |
| Wiebe `a` | NOT FOUND | Paper A | — | — |
| Burn duration Δθb | NOT FOUND | Paper A, L2689–2690 (symbol only) | — | — |
| Douaud-Eyzat τ prefactor | 0.01869 | Paper A, L908 | SI (knock integral) | **YES** for knock prediction only; not a flame-development delay |
| Douaud-Eyzat ON exponent | 3.4017 | Paper A, L908–911 | SI | **YES** (knock model) |
| Douaud-Eyzat p exponent | −1.7 | Paper A, L912 | SI | **YES** (knock model) |
| Douaud-Eyzat activation term | 3800 | Paper A, L914 | SI | **YES** (knock model) |
| Post-knock frequency factor `B0` | 2233e3 Hz | Paper A, L962–963 | SI | **YES** but irrelevant unless modelling knock |
| Post-knock burn prefactor | 0.8573 | Paper A, L951–952 | SI | as above |
| Woschni constant | 0.0128 | Paper A, L832 (glyph block L818–835) | SI 2-stroke, WAVE implementation | **YES** — standard Woschni form; the constant is code-specific, not engine-specific |
| Woschni exponents | 0.8 / −0.53 / 0.8 / −0.2 (v, T, P, D) | Paper A, L822–826 | " | **YES** (form, not tuning) |
| Woschni `Cm`, flat crown | 1.0 | Paper A, L751–752 | same engine | **YES, with caution** — Cm is a chamber-shape/area scaling, so it must match *our* chamber |
| Woschni `Cm`, concentric recess | 1.315 | Paper A, L753 | same engine, domed recess chamber | **NO (do not copy)** — this is a geometric area ratio for *their* head; our RX135 chamber area must be computed |
| Colburn Pr exponent (remote areas) | −2/3 | Paper A, L758–762 | generic | **YES** |
| Cd, exhaust / transfer / inlet / reed | NOT FOUND | Papers A–D | — | — (Paper A explicitly used isentropic port flow instead, L620–625) |
| Injector discharge coefficient μ | NOT FOUND (symbol only) | Paper B, L273–277 | port/manifold EFI | — |
| Scavenging efficiency SE | 95.14% (CCR 1.5), 97.2%, 96.4% | Paper C, L175, L226, L260 | Crankcase-scavenged **diesel**, 5500 rpm, 1-D GT-POWER | **NO** — diesel + never-validated scavenging sub-model; 95%+ is far above any real loop-scavenged SI value. Would over-predict trapped charge badly |
| Port timing at max SE | scav 125 °CA / exhaust 89 °CA (body) vs 123 °CA (abstract) | Paper C, L259–260 vs L58 | diesel | **NO** — different port geometry/rated speed; also internally inconsistent |
| Original port timing of their engine | scav 124/236 °CA, exhaust 87/273 °CA | Paper C, L245–247 | diesel | **NO** for the numbers; useful only as a sanity range |
| Crankcase compression ratio optimum | 1.5 (max SE) and 1.8 (best BSFC/torque trade-off) | Paper C, L175, L182–188 | crankcase-scavenged diesel | **WITH CAUTION** — Paper A's SI engine runs 1.5:1 (L383–384), so 1.5 is corroborated across two crankcase-scavenged engines; 1.8 is diesel-specific |
| Crankcase CR exploration range | 1.2 – 2.4 | Paper C, L169 | " | **WITH CAUTION** (range only) |
| SE / TE / DR / CE, uniflow fired | SE 0.92–0.98, TE 0.51–0.63, DR 1.66–2.69, CE 1.03–1.56 | Paper D, L743–747, L1074–1109 | **Boosted uniflow, DI, poppet exhaust, 80x100** | **NO** — uniflow + boost + poppet valves give near-perfect displacement scavenging; our loop-scavenged crankcase engine cannot reach SE 0.95 or DR 2.5 at 1 bar. Use only as an upper bound |
| SE / TE / DR / CE, uniflow cold | DR 2.08–6.59, TE 0.23–0.67, SE 0.82–1.00, CE 1.32–1.60 | Paper D, L493–528, L620–655 | " | **NO** — same reason, plus these are cold-flow (no burned gas) results |
| Fired-condition TE for a *loop* engine implied by Paper D | 0.61–0.68 | Paper D, L746, L1624–1647 | uniflow (best case) | **WITH CAUTION** — treat as an upper bound; a real crankcase-scavenged loop engine traps less |
| SE-vs-SR correlation, Benson-Brandham break point, two-zone split | NOT FOUND | Papers A–D | — | — (Paper D's "SR" is *swirl ratio*, L289–291 — not scavenging ratio) |
| Wall temperature, piston head | 440 K fired (340 K cold) | Paper D, L236–237 | boosted uniflow DI gasoline | **WITH CAUTION** — magnitude is typical for an SI piston crown; the value is a CFD boundary condition, not a measurement, and their engine is boosted/DI |
| Wall temperature, piston top | 522 K fired (360 K cold) | Paper D, L239–240 | " | **WITH CAUTION** (as above) |
| Wall temperature, liner | 384 K fired (320 K cold) | Paper D, L242–243 | " | **WITH CAUTION** (as above; our air-cooled RX135 liner will run hotter) |
| Exhaust port gas temperature | 800 K fired / 350 K cold | Paper D, L220–221 | " | **WITH CAUTION** — boundary condition of a boosted engine; usable only as a starting magnitude |
| Exhaust pressure | 1.06 bar fired / 1.01 bar cold | Paper D, L223–224 | " | **WITH CAUTION** — our stub-pipe/tuned exhaust is strongly unsteady |
| Heat transfer coefficients `h` (W/m2K) | NOT FOUND | Papers A–D | — | — |
| FMEP / Chen-Flynn c1..c4 | NOT FOUND (structure only, L776–786) | Paper A, L771–774, L1947–1949 | crankcase-scavenged SI | **NO** — authors state they used unvalidated "typical" values |
| Test-engine bore x stroke | 66 x 50 mm (A); 80 x 100 mm (D); not stated (B, C) | Paper A L377–379; Paper D L115–117 | A = same architecture | A: **YES** (nearly our size); D: **NO** |
| Test-engine displacement | 342 cm3 total / 171 cm3 per cylinder (A); 0.5 L (D) | Paper A L373–374, L274; Paper D L121 | A = 1.3x our cylinder | A: **WITH CAUTION** (2.6x our displacement) |
| Trapped compression ratio | 7.1:1 (Table 1) vs 6.74:1 (text, for rc = 9.2:1); also 6.00:1 and 5.65:1 | Paper A, L381–382, L1545–1550 | crankcase-scavenged SI 2-stroke | **WITH CAUTION** — directly comparable architecture, but the paper contradicts itself on 7.1 vs 6.74 |
| Geometric compression ratio | 9.2:1 | Paper A, L1545 | " | **YES** as a reference point (check against RX135 spec) |
| Max power / speed | 16.27 kW @ 6500 rpm (gasoline, 342 cm3) | Paper A, L1079–1080 | " | **WITH CAUTION** — quotable as-is; note that displacement-scaling it myself gives 16.27 × 132/342 ≈ 6.3 kW, but that is arithmetic, not a literature value |
| Min SFC | 0.464 kg/kWh @ 6000 rpm (gasoline); 0.481 @ 6500 | Paper A, L1080, L1955 | " | **WITH CAUTION** — realistic BSFC bracket for a carburetted 2-stroke |
| BMEP | NOT FOUND | Papers A–D | — | — |
| Peak cylinder pressure (model) | 31.9 bar @ 12.2° ATDC (II); 33.5 bar @ 13.1° ATDC (API); 28.8 bar @ 13.1° ATDC (6.00:1 TCR) | Paper A, L1509–1513, L1832–1833 | " | **WITH CAUTION** — validation target, not a constant |
| Reed geometry | 17.5 mm wide, 25 mm effective length, 0.2 mm thick, 6 petals, steel | Paper A, L385–386, L496–497 | " | **NO** — different reed block; only the modelling approach transfers |
| Reed mode constants βjlr | 1.875, 4.694, 7.855, 10.996, 14.137 | Paper A, L586–587 | cantilever beam theory | **YES** — these are textbook cantilever eigenvalues, not engine-specific |
| Port open time vs speed | 5.50 ms @ 3000 rpm → 2.36 ms @ 7000 rpm | Paper A, L1189–1246 | " | **WITH CAUTION** — depends on their port height; useful to check our exhaust-port timing |
| AFR operating window | 8.0 to 25.5; stoichiometric 14.7 | Paper B, L211–213 | generic SI | **YES** (generic, not a fitted constant) |
| BSFC, port-injected vs carburetted | 300 vs 370 g/kWh | Paper B, L183–184 (quoting ref [13]) | 2-stroke SI with high-pressure DI | **NO** — second-hand DI data, not our architecture |
| Power gain from EFI | up to 20% | Paper B, L149 | generic 2-stroke | **WITH CAUTION** — qualitative claim, not a model input |
| Swirl ratio target | "no less than 3" | Paper D, L289–291 | boosted uniflow DI | **NO** — 3-D flow target for a different chamber; and "SR" there is swirl ratio |

---

## What this means for the model (short version)

1. **Only Paper A is a genuine source of tunable constants for our engine.** It is the same
   architecture (crankcase-scavenged, loop-scavenged, SI, reed valve, 50 mm stroke) and it gives
   exactly three usable numbers: Wiebe **b = 5**, **c = 3–3.2**, and Woschni **Cm = 1.315**
   (plus the standard Woschni/Colburn exponents).
2. **Cd is absent from all four papers.** Paper A deliberately avoided Cd calibration and used
   isentropic port flow. That is the single biggest hole: our Cd guesses cannot be replaced from
   this literature set, only replaced by *a defensible isentropic baseline*.
3. **No scavenging model constants exist in any of the four papers.** No Benson-Brandham break
   point, no two-zone split, no SE = f(SR) fit. The SE numbers that do exist are either diesel
   (Paper C, 95–97%, not credible for us) or boosted-uniflow (Paper D, 0.92–0.98, an upper bound
   only). For a crankcase-scavenged loop-scavenged SI engine, Paper D's *fired* TE of ~0.61 is the
   most defensible ceiling, and real trapping will be below it.
4. **No FMEP anywhere.** Paper A states outright that it used unvalidated "typical" values and
   recommends a Morse test. Our friction term must come from elsewhere (or from a Morse test).
5. Paper B (2025) and Paper C (2024) contribute **no simulation constants at all** — B is an ECU
   paper with no engine, C is a parameter-sweep study with no engine geometry. They should not be
   cited as sources for any constant in the model.
