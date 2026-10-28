# Accuracy targets for a 0-D/1-D simulation of a small (<200 cc) crankcase-scavenged, loop-scavenged, carburetted SI two-stroke

Scope: all 23 text extracts in `references/text/`. Priority given to papers that validate a model against
measured engine data. Line numbers refer to the `.txt` extract files (1-based, as delivered).

Citation tags used below:

| Tag | File in `references/text/` |
|---|---|
| **[O23]** | `2023_Ortenzi_1D_Model_High_Performance_Two_Stroke.txt` |
| **[Z95]** | `1995_MODELLING_THE_SCAVENGING_PROCESS_IN_A_TWO_STROKE_I_C_EN.txt` (PhD thesis, Zhang) |
| **[BD96]** | `Blair,_G.P._-_Design_and_Simulation_of_Two-Stroke_Engines_(S.txt` (textbook; `..._Basic_Design_...` is a near-duplicate of the same text — same QUB 400 table appears at the same line numbers in both) |
| **[W22]** | `2022_Study_of_the_effects_of_trapped_compression_ratio_on_th.txt` |
| **[C23]** | `2023_Climent_Heat_Transfer_1D_Uniflow_Scavenged.txt` |
| **[S23]** | `2023_Shao_Small_Two_Stroke_HFDI_Scavenging_Combustion.txt` |
| **[Q18]** | `2018_Qiao_Scavenging_Ports_Small_Aeroengine_Benson_Bradham.txt` |
| **[I24]** | `IOP_2024_scavenge_params.txt` |
| **[JB81]** | `1981_Jones_Brown_Two_Stroke_Exhaust_Noise_Method_of_Characteristics.txt` |
| **[L12]** | `2012_Simulation_of_the_Scavenging_Process_in_Two_Stroke_Engi.txt` |
| **[MV18]** | `2018_Development_of_an_extended_mean_value_engine_model_for_.txt` |
| **[F19]** | `2019_Foteinos_Three_Zone_Scavenging_Model_Uniflow.txt` |
| **[FR22]** | `Frontiers_2022_uniflow_scavenging.txt` |
| **[J18]** | `2018_Jia_Free_Piston_Two_Stroke_Scavenging_Ports_Valves.txt` |
| **[K25]** | `2025_Improving_the_energy_efficiency_of_a_two_stroke_engine_.txt` |
| **[B16]** | `2016_Evaluations_of_Scavenge_Port_Designs_for_a_Boosted_Unif.txt` |
| **[KZ17]** | `2017_Kamili_Zahidi_Two_Stroke_Poppet_Valve_Port_Flow.txt` |
| **[KT56]** | `1956_Ku_Trimble_Scavenging_Characteristics_Skip_Cycle.txt` |
| **[SC42]** | `1942_Schweitzer_Tracer_Gas_Charging_Efficiency_Two_Stroke.txt` |
| **[R38]** | `1938_Rogowski_Scavenging_Piston_Ported_Two_Stroke_Cylinder.txt` |
| **[HW]** | `Heywood,_J.B._-_Internal_Combustion_Engine_Fundamentals,_2nd.txt` (textbook) |
| **[PK]** | `Pulkrabek,_W.W._-_Engineering_Fundamentals_of_the_Internal_C.txt` (textbook) |

---

## 0. Headline answer

**Best accuracy anyone in this corpus reports for a single-cylinder engine under 200 cc is a power-curve
RMSE of about 0.5 kW** on 125 cc racing karts **[O23 L62, L1331, L1430, L1480]**. On the 22 kW X30 that is
≈2.3 %; on the 37 kW KZ it is ≈1.4 % (my arithmetic from the power levels quoted at **[O23 L152–158]**).
That figure covers **power only** — no BSFC, no trapped mass, no scavenging efficiency, no pressure trace.

**The best *complete* validation of a carburetted crankcase-scavenged loop-scavenged engine is ±10 % worst
point on torque, power and BSFC, with matching cylinder/transfer/exhaust pressure traces, on a 100 cc
engine** **[Z95 L4999–5001]**, with a 125 cc 1-D noise/pressure model in the same accuracy class
(**"reasonably good agreement; particularly in magnitude"**, no % given) **[JB81 L981–982]**.

**Cost of the 0.5 kW result:** geometry + a measured WOT power curve (~21 speed points). All 7 combustion
and turbulence calibration constants were *left at 1*, i.e. deliberately untuned **[O23 L387–389, L638–649]**,
but the model imports discharge-coefficient tables and scavenging coefficients from Blair's published data
**[O23 L201–212, L216–222, L1489–1491]**. The authors' own verdict: **"the need of calibration data, without
which the results cannot be accurate, is still the main limitation of this study"** **[O23 L1487–1489]**.

**Nothing in this corpus validates trapped mass or scavenging efficiency against measurement on a small
engine.** The closest is a sensitivity result: heat-transfer choice alone moves in-cylinder trapped mass by
**"up to 12 %"** **[C23 L61–62]**.

---

## 1. Papers that validate a model against measured engine data

### 1.1 Ortenzi & Bossaglia 2023 — **[O23]** — the strongest small-engine validation

**1. ENGINE.** Two racing karts. X30: 125 cc, direct drive, electric start, **three transfer ports, intake
reed valve**, carburetted (Tillotson HW27A), 6500–16 000 rpm **[O23 L144–156, L1305–1318]**, ~22 kW senior /
~15 kW junior **[O23 L152–153]**. KZ "Screamer III": **"54 mm bore, 54.4 mm stroke"** (= 124.6 cc), **five
transfer ports and three exhaust ports**, intake reed valve, six-speed, ~37 kW, carburettor limited to 30 mm,
CR ≈12.3 **[O23 L156–160, L1419–1426]**. Both are loop-scavenged **[O23 L134, L446–448, L1462]**.
Bore/stroke of the X30: **NOT REPORTED** in the extract (homologation form is cited instead, **[O23 L1317]**).

**2. MODEL CLASS.** Quasi-dimensional: 0-D two-zone in-cylinder thermodynamics with flame-development /
turbulent / wall-quench combustion (Eqs. 8–12 **[O23 L326–386]**) and a K-k-ε turbulence model including
tumble and squish **[O23 L410–418]**; 1-D manifolds solved with a modified second-order Roe Riemann solver
**[O23 L56–58, L791–806]**; reed valves as cantilever beams with modal analysis **[O23 L192–197]**.
Crank-angle resolved, multi-cycle. Runtime ≈360 s for 30 iterations × 21 speeds **[O23 L80–82]**.

**3. ACCURACY ACHIEVED.** Power curve only, three configurations:
> "There is quite a good correlation with the experimental data in both of the engines, with a root mean
> square error of about 0.5 kW." **[O23 L1329–1331]**

> "Also, in this case, this is in good accordance with all the curves, and the root mean square error is
> about 0.5 kW." **[O23 L1428–1430]** (KZ engine)

> "There is good accordance between the model and measurement, and the root mean square error for both
> engines is about 0.5 kW." **[O23 L1479–1480]**

The only other quantitative accuracy claim is numerical, not physical — end-pipe mass conservation:
error **"can also be of about 2%"** with the classical method, reduced to **"the maximum error is about
0.5%"** **[O23 L1264–1276]**. No BSFC, torque, peak-pressure or trapped-mass comparison is reported.

**4. CALIBRATION USED.** Deliberately minimal, per-engine:
- Combustion constants `C_FDF`, `C_S`, `C_wall` **all set to 1** — "the default values of the calibration
  constant, in the absence of more detailed measured data … are all set to 1" **[O23 L387–398]**.
- Turbulence constants `C_in`, `C_T0`, `C_β`, `C_Lg` **all set to 1** **[O23 L638–649]**, plus `α_in = 0.1`
  taken from literature **[O23 L494–496]**.
- λ = 0.85 and ignition 22° BTDC, both *set*, not fitted **[O23 L1322–1323]**.
- Discharge coefficients: 3-D tables as functions of area ratio and pressure ratio, **"taken from [8,18–20]"**
  (Blair's four-stroke book and SAE papers) **[O23 L198–212]**.
- Scavenging: `SE_v = 1 − exp(k0 + k1·DR_v + k2·DR_v²)` where "the coefficients k0, k1, k2 are empirical and
  are calibrated with experimental data" **[O23 L216–222]** — inherited, not re-fitted here.
- Validated against: **full-load power curves**, senior + junior + KZ, 6500–16 000 rpm in 500 rpm steps
  **[O23 L1313–1314, L80–82]**. No pressure traces used.

**5. WHAT THEY SAY DOMINATES THE ERROR.**
> "However, the need of calibration data, without which the results cannot be accurate, is still the main
> limitation of this study. … the discharge coefficients and the scavenging process contain coefficients
> that need to be determine experimentally." **[O23 L1487–1491]**

> "Such calculation reduces, though it does not nullify, the need for experimental data…"
> **[O23 L1462–1464]**

---

### 1.2 Zhang 1995 PhD thesis — **[Z95]** — the only full carburetted <200 cc validation

**1. ENGINE.** **"YAMAHA MT-110 S"**, **"52 mm" bore × "50 mm" stroke, "100 cc"**, carburettor, **"crankcase
compression, piston port timing and loop scavenging"**, CR 5.8, exhaust port opens 104° ATDC, transfer
128° ATDC, inlet 62° BTDC **[Z95 L4259–4296]**. Test range **2200–4400 rpm**, WOT, five exhaust mid-section
lengths (240/330/400/480/550 mm) **[Z95 L369–371, L3647–3649, L4758–4762]**.

**2. MODEL CLASS.** 1-D unsteady gas dynamics by the method of characteristics for inlet/transfer/exhaust
pipes, with 0-D cylinder and crankcase control volumes **[Z95 L60–70, L3490–3506]**, crank-angle resolved,
multi-cycle to steady state. Mesh 10 mm, CFL 0.95 **[Z95 L3586–3599]**.

**3. ACCURACY ACHIEVED.**
> "…the agreement between measurements and calculations was good, particularly at the medium and higher
> speeds. At lower speeds, the agreement deteriorated slightly, however **the maximum discrepancy was still
> below 10%**." **[Z95 L4999–5001]**

Pressure traces: **"The agreement between the measured and calculated pressure traces was good"**
**[Z95 L5035–5036]** — cylinder, transfer port and exhaust port, at 7 speed/pipe combinations
**[Z95 L5023–5033]**.

**4. CALIBRATION USED.** Explicitly minimal and *not* engine-specific:
- **"Cp is simplified as much as possible by regarding it as constant for all the pipe boundaries
  considered"** — CD = 0.75 for exhaust, transfer and inlet (normal), 0.90 inlet reverse
  **[Z95 L3514–3529]** (Table 4.1).
- Scavenging curve: **"As first hand information of this kind was not readily available, the selection of the
  scavenging type was based on the results from the single cycle test published in [8]"** → YAM6 chosen
  **[Z95 L3563–3568]**.
- Exhaust pipe gas temperature assumed in two bands: 350 °C for 2200–2900 rpm, 450 °C for 3000–4400 rpm
  **[Z95 L3579–3585]**.
- Combustion: heat-release model from Blair, with **"polytropic index, combustion efficiency, trapped
  air-fuel ratio etc. … those suggested by Blair"**, held constant for all speeds **[Z95 L3604–3615,
  L5006–5009]**.
- Validated against: torque + power + BSFC + 3 pressure traces, 5 pipe lengths, ~23 speed points per pipe
  (100 rpm steps) **[Z95 L3616–3620]**.

**5. WHAT THEY SAY DOMINATES THE ERROR.**
> "Apart from the pipe flow model, the prediction of engine performance characteristics is very dependent on
> how the combustion is modelled." **[Z95 L5002–5005]**

> "These parameters are assumed constant for all speeds … In practical cases, these parameters may vary
> slightly with engine speed and load change. For an accurate simulation, such parameters should be
> determined experimentally and input to the program. This may include the accurate analysis of the cylinder
> pressure trace, and the measurement of the trapping efficiency and BSFC." **[Z95 L5008–5012]**

---

### 1.3 Blair — QUB 400 single-cylinder research engine — **[BD96]**

**1. ENGINE.** **"400 cc loop scavenged, spark-ignition, carburetted, research engine, watercooled, of 85 mm
bore and 70 mm stroke"**, untuned exhaust (box silencer), trapped CR 6.62 **[BD96 L8190–8200]**. One
steady point at 5000 rpm for the measured-vs-calculated table **[BD96 L10521]**, plus 3000 rpm in the
program output **[BD96 L10402–10410]**. **This engine is 400 cc — twice the boundary of interest — so treat it
as an architecture match, not a size match.**

**2. MODEL CLASS.** 1-D method-of-characteristics gas dynamics + 0-D cylinder/crankcase thermodynamics, with
a prescribed heat-release combustion profile **[BD96 L8362–8371]**; crank-angle resolved, multi-cycle.

**3. ACCURACY ACHIEVED** (measured vs calculated, SCRE loop scavenging, 5000 rpm, **[BD96 L10521–10604]**):

| Quantity | Measured | Calculated | Error |
|---|---|---|---|
| Power, kW | 12.4 | 12.11 | −2.3 % |
| IMEP, bar | 6.80 | 6.68 | −1.8 % |
| BMEP, bar | 6.24 | 6.10 | −2.2 % |
| BSFC, g/kWh | 437 | 463 | **+5.9 %** |
| Delivery ratio | 0.85 | 0.85 | 0 % |
| Scavenging efficiency | 0.84 | 0.80 | −0.04 abs (−4.8 %) |
| **Trapping efficiency** | **0.60** | **0.51** | **−0.09 abs (−15 %)** |
| Charging efficiency | 0.44 | 0.42 | −0.02 abs |
| Peak pressure, bar | 36.9 | 35.7 | −3.3 % |

> Note on this table: the extract lists 7 column headings (EXPT, UNIFLOW, SCRE, YAM1, YAM6, QUBCR, CD) but
> only 6 values for SEFF and CEFF **[BD96 L10574–10595]**, so one column did not survive extraction. The
> EXPT/UNIFLOW/SCRE triplets used above are read in order and are consistent with the surrounding text.

> "The correlation between the SCRE calculated data and the experimental facts is very good for virtually
> every parameter, with the exception of the trapping efficiency, TE." **[BD96 L10621–10625]**

> "That the combustion model is performing as postulated can be assessed by comparing the level of peak
> cylinder pressure, PMAX, measured at 36.9 bar and calculated at 35.7 bar." **[BD96 L10626–10628]**

**4. CALIBRATION USED.** The combustion model was built *from this engine's own* measured pressure diagram:
> "In Sect. 4.2, the experimental data from this engine is used to suggest the model of combustion currently
> employed in Progs.5.1 and 5.2 … it would signal a poor future for combustion modelling if it could not
> compute accurately the combustion behavior in the very engine from which the model is concocted!"
> **[BD96 L10628–10632]**

Also: scavenging type selected (SCRE), discharge coefficients from Blair's tabulated data, and the choice
between Eq. 5.1.11 and Eq. 5.1.13 for volumetric expansion, which "like SE, is heavily dependent upon"
**[BD96 L10624–10625]**. Validated against: one steady-state dyno point plus its pressure diagram.

**5. WHAT THEY SAY DOMINATES THE ERROR.** Scavenging sub-model selection:
> "From the best to the worst of loop scavenging, i.e., from an SCRE to a YAM6 type scavenging system, the
> variation in power is from 12.1 to 11.2 kW. i.e., an 8 % drop. The consequential change in specific fuel
> consumption is from 463 to 506 g/kWh, i.e., a 9 % deterioration." **[BD96 L10503–10506]**

> "…these variations would not be as great as those predicted by experimental work at QUB … where 15 % would
> have been observed for power and fuel consumption changes for those same scavenging types…"
> **[BD96 L10506–10509]**

And a methodological caution that matters for your validation plan:
> "…a pressure transducer as the sole evidence of accuracy of a theoretical unsteady gasdynamic calculation
> is insufficient evidence upon which to make a judgment of the accuracy of that theoretical approach."
> **[BD96 L5341–5344]**

---

### 1.4 WAVE model of a 342 cc crankcase-scavenged UAV engine — **[W22]**

**1. ENGINE.** **"Swept Volume (cm3) 342 … No. of cylinders 2 … Bore 66 mm … Stroke 50 mm"** (= 171 cc per
cylinder), trapped CR 7.1, crankcase CR 1.5, **single 6-petal steel reed valve**, **single diaphragm
carburettor**, short stub exhaust pipes, premixed oil **[W22 L371–398]**. Tests 3000–6500 rpm, peak power at
6500 rpm **[W22 L1351–1352]**. **Architecture is an exact match to your target; capacity is 342 cc total.**

**2. MODEL CLASS.** 1-D Ricardo WAVE (v2021.3), crank-angle resolved, multi-cycle **[W22 L401–403]**;
Wiebe combustion **[W22 L735–738]**, Woschni heat transfer **[W22 L749–753]**, Chen–Flynn friction
**[W22 L771–774]**.

**3. ACCURACY ACHIEVED.**
> "Above 5000 RPM the predicted power output from the model was significantly lower than the actual power
> output from the test engine of the order of **8.2 to 13.3 %**, the greatest deviation occurring at 6000
> RPM. In terms of SFC, correlation was close below 4500 RPM but deviates from 4500 RPM and above."
> **[W22 L1936–1940]**

Absolute numbers at 6500 rpm: measured carburetted 98RON **"maximum 16.27 kW"**; modelled inlet-injected
indolene **"14.84 kW"** (−8.8 %), modelled port-injected **"15.07 kW"** (−7.4 %) **[W22 L1351–1353]**. Minimum
SFC measured 0.464 kg/kWh vs modelled 0.508 kg/kWh (+9.5 %) **[W22 L1354–1357]**. Mid-range:
> "a reasonable correlation between the experimental results and modelled data has been achieved in the
> medium speed range from 3000 to 5000 RPM although a marked improvement in power with the WAVE model is
> exhibited at 3500-4000 RPM." **[W22 L1348–1350]**

**4. CALIBRATION USED.** Essentially *borrowed* constants, not fitted to this engine's dyno curve:
- Wiebe shape/duration exponents **b = 5, c = 3–3.2 from Sher (1984)**: "In the absence of specific data for
  the subject engine this prior research has been considered here." **[W22 L735–738]**
- Woschni scaling factor **C_m = 1.315**, derived from chamber surface-area analysis **[W22 L750–753]**.
- **FMEP from generic values**: "Morse test data was unavailable for the engine so values for friction mean
  effective pressure (pf) typical for crankcase scavenged engines were used in this study to make the
  correlation representative here." **[W22 L771–774]**
- Injector pulse width "optimised within the model" **[W22 L484]**.
- Validated against: full-load power and SFC curves, 3000–6500 rpm **[W22 L1344–1357]**.

**5. WHAT THEY SAY DOMINATES THE ERROR.** Friction and high-speed gas exchange:
> "Further work could be conducted to provide a closer correlation of engine friction mean effective pressure
> within the engine models. Future work to secure data via Morse tests could be incorporated in the WAVE
> models. This was not possible within the current study. All modelling was therefore conducted with typical
> values associated with crankcase scavenged two-stroke cycle engines." **[W22 L1946–1950]**

---

### 1.5 Climent et al. 2023 — 1-D uniflow, pressure-based validation — **[C23]**

**1. ENGINE.** Prototype opposed-piston two-stroke "range extender": **reed valve into an air pump, intake
ports on the rod, exhaust ports perpendicular**, i.e. opposed/uniflow scavenging **[C23 L223–230]**.
Bore, stroke and displacement: **NOT REPORTED**. Speeds **2000, 2250, 2500 rpm** at full load, 2000 rpm
partial load, two exhaust configurations **[C23 L239–241, L248–279]**.

**2. MODEL CLASS.** 0-D–1-D (VEMOD): 1-D unsteady compressible flow in intake/exhaust lines, **cylinder as a
0-D element** **[C23 L280–301]**, plus 3-D CFD (CONVERGE, URANS RNG k-ε) downstream **[C23 L375–417]**.
Crank-angle resolved.

**3. ACCURACY ACHIEVED.** Pressure-only, scavenging window:
> "…the modelling pressure traces follow the experimental measurements with an absolute maximum deviation of
> **less than 2 %**." **[C23 L354–362]**

> "Once a peak deviation of less than 2 % was accomplished, these multipliers were held constant…"
> **[C23 L367–371]**

Also reports the *consequence* of heat-transfer error rather than a validated trapped mass:
> "…deviations of less than 2 % can be observed and an impact of **up to 12 % on the in-cylinder trapped
> mass** can be seen." **[C23 L61–62]**

**4. CALIBRATION USED.** Three named knobs:
- **"heat transfer and friction multipliers in the exhaust manifold were calibrated"** to reach the <2 %
  peak-deviation target **[C23 L367–369]**;
- **"The discharge coefficient of the ports is calibrated to attain the instantaneous mass flow rates
  obtained in the CFD simulations"** **[C23 L309–311]**;
- reed-valve mass-spring-damper parameters **[C23 L313–321]**.
Validated against: exhaust-manifold and in-cylinder pressure traces at 4 operating points (2 speeds FL,
1 speed PL × 2 exhaust configs) **[C23 L248–279, L346–347]**.

**5. WHAT THEY SAY DOMINATES THE ERROR.**
> "In this particular application, the temperature deviation led to a poor prediction of trapped mass in the
> cylinder." **[C23 L55–56]**

This is the single most important statement in the corpus for a 0-D/1-D small-engine model: a 2 % pressure
match concealed a 12 % trapped-mass error.

---

### 1.6 Shao et al. 2023 — CFD, 3 % peak pressure — **[S23]**

**1. ENGINE.** **"Displaced volume 400cc … Bore × Stroke 65.5 mm × 60 mm … Cross Scavenging … 3 inlet + 1
exhaust … Turbocharger … Direct Inject … Compression ratio 16 … Rated speed 2400 rpm"**
**[S23 L187–226]**. Opposed-cylinder (2 cylinders → ≈202 cc/cyl). **Diesel-like heavy fuel, not carburetted.**
Operating points: 2400 rpm, 1200–2400 rpm sweep, 25–100 % load, altitudes to 5000 m **[S23 L389–397,
L607–623]**.

**2. MODEL CLASS.** 3-D transient CFD (Ansys Forte), RNG k-ε, 1 °CA steps, 329 023 cells **[S23 L304–316]**.

**3. ACCURACY ACHIEVED.**
> "Results show that the maximum error of cylinder pressure calculated by simulation and measured by the test
> is about **3 %**, the combustion phase is basically consistent…" **[S23 L371–375]**

One operating point (2400 rpm, −8 °CA injection). Power, BSFC, trapped mass: **NOT REPORTED**.

**4. CALIBRATION USED.** Spray/breakup constants (KH size 1.0, time 40.0; RT size 0.15, time 1.0, distance
1.9 — Table A1 **[S23 L704–719]**), discharge coefficient 0.7 from momentum-flux measurement **[S23 L357–358]**,
measured injection-rate profile **[S23 L249–253]**, assumed wall temperatures 400/450 K **[S23 L344–350]**.

**5. WHAT THEY SAY DOMINATES THE ERROR.** **NOT REPORTED.**

---

### 1.7 Sun et al. 2024 (IOP) — GT-POWER, <5 % pressure — **[I24]**

**1. ENGINE.** **"a spark ignition two-stroke single-cylinder diesel engine … based on the engine of a certain
drone"**, crankcase-scavenged ("air passes … then enters the crankcase … enters the cylinder through the
scavenging port") **[I24 L93–106]**. Rated/calibration speed **5500 r/min** **[I24 L170]**. Port timings:
scavenge open 124 °CA close 236 °CA, exhaust open 87 °CA close 273 °CA **[I24 L245–247]**. Bore, stroke,
displacement: **NOT REPORTED**.

**2. MODEL CLASS.** 1-D GT-POWER, four modules (intake, cylinder, crankcase, exhaust) **[I24 L49–50,
L105–106]**, crank-angle resolved.

**3. ACCURACY ACHIEVED.**
> "After calibration, the simulation and experimental data values of the model in the compression and
> expansion stages are consistent. During the combustion process, there is a certain error due to the
> calculation error of the heat transfer process, but **the maximum error is less than 5 %**."
> **[I24 L111–113]**

Peak pressure / IMEP / BSFC: **NOT REPORTED**.

**4. CALIBRATION USED.** **"the model was calibrated using the original cylinder pressure curve"**
**[I24 L263–265]**; individual tuned parameters: **NOT REPORTED**. Validated against: one cylinder-pressure
trace at 5500 rpm **[I24 L107–110]**.

**5. WHAT THEY SAY DOMINATES THE ERROR.** Heat transfer during combustion **[I24 L112–113]**.

---

### 1.8 Qiao et al. 2018 — 1-D/3-D coupled, no numeric error — **[Q18]**

**1. ENGINE.** **"Total displacement 498 cm3 … Bore 75 mm … Stroke 56 mm"**, two-cylinder horizontally
opposed, **"crankcase scavenged engine and the gas flow admitted to the crankcase is controlled by reed
valves"**, single-point injection gasoline, CR 10.6, rated 32 kW @ 6500 r/min, 3 scavenge ports + 1 exhaust
**[Q18 L340–422]**. Test points: **6000 r/min WOT and 4500 r/min 40 % throttle** **[Q18 L431–434]**.

**2. MODEL CLASS.** 1-D GT-POWER (crank-angle resolved) providing boundary conditions to 3-D AVL FIRE CFD
**[Q18 L335–339, L453–470]**.

**3. ACCURACY ACHIEVED.** Qualitative only:
> "…the GT Power simulation model is validated against experimental data in terms of the in-cylinder pressure
> during the complete engine cycle and the comparative results display a **perfect matching**."
> **[Q18 L435–437]**

> "As shown in Figure 8, the reliability of the 3D AVL FIRE simulation model has been verified…"
> **[Q18 L576–578]**

No % error, no power/BSFC comparison: **NOT REPORTED**.

**4. CALIBRATION USED.**
> "…corresponding configuration parameters of the GT Power simulation model are precisely calibrated.
> In-cylinder pressure is an important working performance index … Therefore, **in-cylinder pressure is
> selected as the calibration target** and thus we adjust the parameter settings accordingly…"
> **[Q18 L426–430]**

Same for the 3-D model **[Q18 L575–576]**. Parameters named: **NOT REPORTED**. Data points: 2.

**5. WHAT THEY SAY DOMINATES THE ERROR.** **NOT REPORTED.**

---

### 1.9 Jones & Brown 1981 — 1-D MOC on a 125 cc engine — **[JB81]**

**1. ENGINE.** **"a high performance, single cylinder, 125 cc two-stroke motorcycle engine"**, tested at
**4000 rpm high load** and **6000 rpm low load** (1.3 m pipe), three exhaust systems (0.4 m straight,
1.3 m straight, tuned expansion chamber) **[JB81 L938–972]**. Bore/stroke: **NOT REPORTED** (Appendix 1 not in
extract).

**2. MODEL CLASS.** 1-D method of characteristics tracking C+, C− and path-line characteristics; cylinder
boundary driven by measured pressure; radiated noise via monopole assumption **[JB81 L61–76, L640]**.
Time/crank-angle resolved, 2 cycles to steady state **[JB81 L977–980]**.

**3. ACCURACY ACHIEVED.** Qualitative, both pressure and 1/3-octave noise:
> "**Very good agreement with experiment** on an operating engine has been achieved in the calculation of both
> the third-octave radiated noise and the associated pressure cycles at several locations in the different
> exhaust systems." **[JB81 L67–70]**

> "The computed pressure traces (a) and (c) of figure 7 both show **reasonably good agreement; particularly in
> magnitude**, with the measurements." **[JB81 L981–982]**

No % error: **NOT REPORTED**.

**4. CALIBRATION USED.** **"The initial cylinder conditions are based on actual measured pressure values"**
**[JB81 L640, L941–944]**. No tuned coefficients are listed: **NOT REPORTED**.

**5. WHAT THEY SAY DOMINATES THE ERROR.** Near-port three-dimensionality:
> "…a main reason for the discrepancies … is the fact that the initial region (i.e., in which the flow is far
> from one-dimensional), which is of the order of two to three diameters from the exhaust port, is a
> significant fraction (**20 - 30 percent**) of the 0.4 m pipe length." **[JB81 L987–993]**

---

### 1.10 Lamas & Rodríguez 2012 — 3-D CFD, 127 cc — **[L12]**

**1. ENGINE.** **"Displacement 127.3 cm3 … Bore 53.8 mm … Stroke 56 mm … Loop scavenge … Direct injection …
Power 7500 W … Speed 6000 rpm"**, single cylinder **[L12 L690–712]**. (DI, not carburetted.)

**2. MODEL CLASS.** 3-D CFD (Fluent 6.3), RNG k-ε, 0.1 °CA time step, dynamic layering **[L12 L867–879]**.

**3. ACCURACY ACHIEVED.** Pressure only, scavenging window 90–270 °CA:
> "Note that an **acceptable concordance** is obtained between CFD and experimental results." **[L12 L889–893]**

Predicted scavenging efficiency **"its value was 82.5"** **[L12 L943–947]** — a prediction, not a validation
against measurement. Power/BSFC/trapped mass errors: **NOT REPORTED**.

**4. CALIBRATION USED.** Measured intake/exhaust/cylinder pressures as boundary conditions; **initial
temperature "must be estimated from an adaptation of the ideal Otto cycle"** (1027 K) **[L12 L844–852]**.
No tuned coefficients: **NOT REPORTED**.

**5. WHAT THEY SAY DOMINATES THE ERROR.** **NOT REPORTED** (only generic warnings about CFD producing
"non-physical results due to erroneous modeling", **[L12 L1058–1063]**).

---

## 2. Marine / large-engine validations (do **not** transfer to a <200 cc engine without saying so)

These are included because they contain the most explicit accuracy statements, but every one is a
crosshead, uniflow, turbocharged engine of 340–980 mm bore. Their error levels reflect (a) far better
instrumentation and (b) a totally different scavenging mechanism (uniflow with exhaust valves, not loop).

### 2.1 Theotokatos et al. 2018 — 0-D + MVEM, MAN 7K98MC — **[MV18]**

- **ENGINE:** **"Bore 980 mm … Stroke 2660 mm … Number of cylinders 7 … Brake power at MCR 40055 kW …
  Engine speed at MCR 94 r/min … Compression ratio 17.5"**, uniflow (SPO 42 °CA before BDC) **[MV18 L2100–2126]**.
- **MODEL:** 0-D one-zone closed cycle + two-zone scavenging **[MV18 L344–356]**; extended MVEM; steady state
  at 25/50/75/100 % MCR **[MV18 L558–561]**.
- **ACCURACY:** Table 3 **[MV18 L2128–2156]** — brake power error **1.02 / 1.01 / 0.99 / 0.92 %**;
  BSFC **−0.16 / −0.55 / 0.08 / −0.18 %**; scavenge receiver pressure **−1.39 … +0.89 %**; exhaust receiver
  pressure up to **4.11 %**; turbocharger speed up to **4.52 %** at 25 % load.
- **CALIBRATION:** Wiebe **a = 10, m = 0.93, combustion duration 47 °CA, φ = 2.13, reference speed 85.4 rpm**
  **[MV18 L2088–2098]**; "the model constants need to be calibrated **for one operating point** as the model
  adjusts the model parameters in other operating points" **[MV18 L394–396]**.
- **DOMINANT ERROR:** **NOT REPORTED**; largest residual is turbocharger speed at low load.
- **Data points used:** 4 (25/50/75/100 % MCR shop trials).

### 2.2 Foteinos & Kyrtatos 2019 — 0-D three-zone, MAN 6S50ME — **[F19]**

- **ENGINE:** **"MAN B&W 6S50ME … Bore 500 mm … Stroke 2000 mm … 6 cylinders … P_MCR 7620 kW …
  N_MCR 115 RPM … Uniflow … Ports per cylinder 30"** **[F19 L225–246]**.
- **MODEL:** 0-D control-volume code MOTHER + 2-D axisymmetric CFD for calibration **[F19 L258–294]**.
- **ACCURACY:** **code-level** claim, not this engine's measurement:
  > "After submodel calibration, the accuracy of MOTHER calculations against measured data is **better than
  > 3 % over the whole operating range** of an engine and it has been **validated with over 50 engine
  > types**." **[F19 L315–318]**
  The paper's own validation is 0-D **versus CFD** and is qualitative: "manages to accurately predict the
  qualitative evolution of scavenging" and "**slightly overestimates the mass of the air zone**"
  **[F19 L933–948]**.
- **CALIBRATION:** three-zone mixing parameters ξ and k revised against CFD **[F19 L205–210, L256–257]**;
  number of tuned parameters **NOT REPORTED**.
- **DOMINANT ERROR:** scavenging model fidelity **[F19 L215–218]**.
- **Data points used:** 4 loads (25/50/75/100 %) × 2 port-geometry cases **[F19 L247–256]**.

### 2.3 Liu et al. 2022 (Frontiers) — 0-D multi-stage, 6EX340EF — **[FR22]**

- **ENGINE:** **"Bore 340 mm … Stroke 1,600 mm … Compression Ratio 20.5 … 75 % Load Power 3,672 kW …
  75 % Load Speed 142.5 rpm"**, uniflow **[FR22 L549–573]**.
- **MODEL:** 0-D four-stage scavenging model (blowdown / perfect displacement / displacement-mixing /
  perfect mixing) **[FR22 L17–23]**.
- **ACCURACY:** **versus CFD, not experiment**:
  > "The results of the 0D model agree well with the results of the CFD simulation, and the **mean relative
  > errors of temperature, pressure, and total mass do not exceed 3 %, 4 %, and 2 %**, respectively."
  > **[FR22 L23–26]**
- **CALIBRATION:** "calibration parameters for each zone's mass transformation" **[FR22 L221]**; values **NOT
  REPORTED** in extract.
- **DOMINANT ERROR:** **NOT REPORTED**.
- **Data points used:** 1 load (75 %), CFD-referenced **[FR22 L560–563]**.

---

## 3. Non-validating items in the corpus (read, but no accuracy to extract)

| Paper | What it actually is | Why no accuracy figure |
|---|---|---|
| **[B16]** 2016 BUSDIG | 3-D CFD of a 0.5 L (80 × 100 mm) boosted-uniflow DI engine, 1000–3000 rpm **[B16 L114–124]** | Cold/fired flow study only; no experimental validation in the paper |
| **[KZ17]** 2017 Kamili | Steady-flow bench on a 65 cc (50 × 33 mm) four-stroke converted to two-stroke poppet valve **[KZ17 L92–96]** | Flow coefficients only; no cycle model |
| **[J18]** 2018 Jia | 0-D Ricardo WAVE free-piston engine-generator scavenging study **[J18 L98–105]** | "model validation results can be found elsewhere" **[J18 L150–151]** |
| **[K25]** 2025 Kravchenko | EFI/ECU hardware + Alpha-N fuelling strategy for a crankcase-scavenged UAV engine **[K25 L19–39]** | No thermodynamic model; engine displacement **NOT REPORTED** |
| **[KT56]** 1956 Ku & Trimble | Skip-cycle experimental method for trapped fresh-charge fraction **[KT56 L55–71]** | Measurement technique, not a model |
| **[SC42]** 1942 Schweitzer | Tracer-gas charging-efficiency method; test engine 10.5 in bore × 12 in stroke, 30 hp @ 400 rpm **[SC42 L2442–2448]** | Measurement technique, not a model |
| **[R38]** 1938 Rogowski | Experimental scavenging study, 4.5 in bore × 6 in stroke **[R38 L130]** | Measurement technique, not a model |
| **[HW]**, **[PK]**, **[BD96]** | Textbooks | [BD96] contributes the QUB 400 table above; [HW]/[PK] give no two-stroke simulation accuracy data |

---

## 4. The explicit question: best accuracy under 200 cc, and what it cost

### 4.1 What is actually reported

| Claim | Engine | Realistic reading |
|---|---|---|
| **RMSE ≈ 0.5 kW on power** **[O23 L62, L1331, L1430, L1480]** | 125 cc, loop, reed valve, carburetted | ≈1.4 % at 37 kW, ≈2.3 % at 22 kW, ≈3.3 % at 15 kW (my arithmetic). **Power only.** No BSFC, pressure, trapped mass, SE. |
| **Max discrepancy < 10 %** **[Z95 L4999–5001]** | 100 cc, loop, piston-port, carburetted | Worst point, low speed; torque + power + BSFC + 3 pressure traces across 5 pipe lengths. **The only complete validation at this size.** |
| **< 5 % on cylinder pressure** **[I24 L113]** | small SI two-stroke, size not given | Pressure trace only, one point, calibration target = that same trace. |
| **< 2 % on pressure during scavenging** **[C23 L362]** | prototype uniflow, size not given | Pressure only; the same model carries a **12 % trapped-mass** uncertainty **[C23 L61–62]**. |
| **≈3 % on peak pressure** **[S23 L374]** | 400 cc cross-scavenged DI | CFD, one point, peak-pressure metric only. |
| **8.2–13.3 % on power, ≈9.5 % on SFC** **[W22 L1939, L1354–1357]** | 342 cc (171 cc/cyl), crankcase, reed, carburetted | **Uncalibrated** 1-D with literature constants — this is the honest "no data" baseline. |

### 4.2 What the 0.5 kW cost

- **Engine-specific input:** full geometry (ports, pipe discretisation, reed dynamics) plus the
  homologation data **[O23 L1317, L1424–1426]**.
- **Engine-specific calibration data:** **one WOT power curve per engine**, 6500–16 000 rpm in 500 rpm steps
  **[O23 L1313–1314, L80–82]**. No pressure traces, no BSFC, no trapped-mass measurement.
- **Inherited calibration:** discharge-coefficient tables **[O23 L198–212]** and the three scavenging
  coefficients k0, k1, k2 **[O23 L216–222]** taken from Blair **[O23 L1489–1491]**. These are the *real* cost:
  they were paid for by someone else's experimental campaign.
- **Tuning effort:** none — 7 combustion/turbulence constants all fixed at 1 **[O23 L387–398, L638–649]**.

In other words: **~2 % on power is achievable for a <200 cc loop-scavenged carburetted engine with a
geometry-accurate 1-D model + one power curve + borrowed discharge/scavenging correlations, and no
per-engine pressure trace.** Remove the borrowed correlations and you fall to the 8–13 % band **[W22]**.

### 4.3 What that number does *not* cover

No paper here validates, on a small engine, against measurement:
- **trapped mass** (best available evidence is a 12 % swing from heat transfer alone, **[C23 L61–62]**);
- **scavenging efficiency / trapping efficiency** (Blair's own table shows TE off by 15 %,
  **[BD96 L10581–10588]**; and TE/SE are "heavily dependent" on which scavenging equation is used,
  **[BD96 L10624–10625]**);
- **BSFC** better than ~6–10 % **[BD96 L10557–10565; W22 L1354–1357]**;
- **cycle-to-cycle** behaviour (all models here are single deterministic cycles).

---

## 5. Recommended accuracy targets for your simulator

Derived from the above, for a <200 cc crankcase-scavenged, loop-scavenged, carburetted SI engine:

| Quantity | Best demonstrated | Realistic target *with* engine data | Target *without* engine data |
|---|---|---|---|
| Power / torque, WOT sweep | ~2 % RMSE **[O23]** | **±3–5 %** | ±10–15 % **[W22 L1939]** |
| BSFC | ~6 % **[BD96 L10557–10565]** | **±6–10 %** | ±10–15 % |
| Peak cylinder pressure | ~2–3 % **[BD96 L10626–10628; S23 L374]** | **±3–5 %** | ±8–10 % |
| IMEP / BMEP | ~2 % **[BD96 L10539–10556]** | **±3–5 %** | ±8 % |
| Delivery ratio | 0 % at one point **[BD96 L10566–10573]** | **±5 %** | ±10 % |
| Trapped mass | not validated anywhere | **±10 %** (heat transfer dominated, **[C23 L61–62]**) | ±15–20 % |
| Scavenging / trapping efficiency | TE −15 % **[BD96 L10581–10588]** | **±5–10 % abs** | ±10–15 % abs |

Calibration budget consistent with the above (parameter counts as evidenced):
1. **Port/valve discharge coefficients** — 3 boundaries × forward/reverse, as `f(area ratio, pressure ratio)`
   **[O23 L198–212; Z95 L3517–3529]**.
2. **Scavenging law** — 2 (Benson/Bradham x, y **[Q18 L282–310]**) or 3 (k0, k1, k2 **[O23 L216–222]**), or a
   stage-based model **[FR22]**.
3. **Combustion** — Wiebe a/m/duration or C_FDF/C_S/C_wall; 3 parameters **[MV18 L2088–2098; O23 L390–398;
   W22 L735–738]**.
4. **Heat transfer** — 1 multiplier, and it is the one that governs trapped mass **[C23 L367–369]**.
5. **Friction** — FMEP c1–c4 (or 2), and this governs the high-speed power gap **[W22 L771–774, L1947–1948]**.
6. **Operating set points** — λ and ignition timing **[O23 L1320–1323]**.

**Minimum viable calibration data set, in order of value per test-hour:**
1. WOT power + torque + BSFC vs speed (10–20 points) — anchors friction and trapping.
2. Cylinder pressure at 3 speeds (low / peak-power / high) — anchors combustion, heat transfer and peak
   pressure; without this you are in the **[W22]** 8–13 % band.
3. One trapped-mass or scavenging-efficiency measurement (skip-cycle or tracer, **[KT56]**, **[SC42]**) — the
   only defence against a 2 %-pressure / 12 %-trapped-mass false confidence **[C23 L55–62]**.

---

## 6. Summary table

| Paper | Engine | Model | Claimed accuracy | Calibration parameters | Data points used |
|---|---|---|---|---|---|
| **Ortenzi 2023 [O23]** | 125 cc karts: X30 (reed, 3 transfer, carb) & KZ 54×54.4 (reed, 5 transfer, carb), 6500–16 000 rpm | Quasi-D 2-zone + K-k-ε in cylinder; 1-D Roe manifolds; CA-resolved | **Power RMSE ≈0.5 kW** (≈1.4–3.3 %), power only **[L62, L1331, L1430, L1480]** | 7 constants fixed at 1; CD tables + k0/k1/k2 inherited from Blair; λ=0.85, 22° BTDC **[L387–398, L638–649, L1320–1323, L1489–1491]** | Full WOT power curves, 500 rpm steps, 6500–16 000 rpm, 3 configs **[L80–82, L1313]** |
| **Zhang 1995 [Z95]** | Yamaha MT-110S, 52×50, **100 cc**, crankcase, piston-port, loop (Schnurle), carburetted, 2200–4400 rpm | 1-D MOC + 0-D volumes; CA-resolved | **Max discrepancy <10 %** (torque, power, BSFC); pressure traces "good" **[L4999–5001, L5035–5036]** | CD = 0.75 constant (0.90 inlet reverse); scavenging type YAM6 from Blair; T_exh assumed 350/450 °C; Blair combustion constants **[L3514–3529, L3563–3568, L3579–3585, L5006–5009]** | 5 pipe lengths × ~23 speeds (100 rpm steps) + 7 pressure-trace points **[L3616–3620, L5023–5033]** |
| **Blair [BD96]** (QUB 400) | 400 cc, 85×70, loop, SI, carburetted, untuned exhaust, 5000 rpm | 1-D MOC + 0-D; prescribed heat release | Power −2.3 %, BMEP −2.2 %, **BSFC +5.9 %**, peak P −3.3 %, **TE −15 %** **[L10521–10604]** | Heat-release model derived from *this engine's* pressure diagram; scavenging type; Eq 5.1.11 vs 5.1.13 choice **[L10628–10632, L10624–10625]** | 1 steady point (+1 at 3000 rpm) with its pressure diagram |
| **WAVE UAV 2022 [W22]** | 342 cc twin (171/cyl), 66×50, crankcase, 6-petal reed, diaphragm carb, 3000–6500 rpm | 1-D Ricardo WAVE; CA-resolved | **Power 8.2–13.3 % low** >5000 rpm; SFC +9.5 %; good 3000–4000 **[L1936–1940, L1348–1357]** | Wiebe b=5, c=3–3.2 (Sher); Woschni Cm=1.315; **FMEP from generic values** (no Morse test); injector PW optimised **[L735–738, L750–753, L771–774, L484]** | Full-load power & SFC curves, 3000–6500 rpm **[L1344–1357]** |
| **Climent 2023 [C23]** | Prototype opposed-piston uniflow, reed + rod ports; **displacement NOT REPORTED**; 2000–2500 rpm | 0-D–1-D (VEMOD) + 3-D CFD | **Pressure deviation <2 %** during scavenging **[L354–362]**; trapped mass ±12 % **[L61–62]** | Exhaust heat-transfer + friction multipliers; port CD calibrated to CFD; reed model **[L367–369, L309–311]** | 4 points (3 speeds FL, 1 PL, 2 exhaust configs) **[L248–279]** |
| **Shao 2023 [S23]** | 400 cc opposed, 65.5×60, **cross** scavenged, turbo, DI heavy fuel, CR 16, 2400 rpm | 3-D CFD (Forte), 1 °CA | **Peak pressure ≈3 %** **[L371–375]** | KH/RT breakup constants; CD 0.7; measured injection rate; assumed wall temps **[L704–719, L357–358, L344–350]** | 1 point (2400 rpm, −8 °CA) |
| **Sun 2024 [I24]** | Small single-cylinder SI two-stroke, crankcase-scavenged, 5500 rpm; **bore/stroke/displacement NOT REPORTED** | 1-D GT-POWER | **Pressure <5 % max** **[L111–113]** | Calibrated to the cylinder pressure curve; parameters NOT REPORTED **[L263–265]** | 1 pressure trace |
| **Qiao 2018 [Q18]** | 498 cc flat-twin, 75×56, crankcase, reed, SPI gasoline, CR 10.6, 6000 & 4500 rpm | 1-D GT-POWER + 3-D AVL FIRE | "**perfect matching**" of pressure; **no % given** **[L435–437]** | In-cylinder pressure as calibration target; parameters NOT REPORTED **[L426–430]** | 2 (6000 WOT, 4500 40 %) |
| **Jones & Brown 1981 [JB81]** | 125 cc single, high-performance two-stroke, 4000 & 6000 rpm | 1-D MOC (characteristics) | "**reasonably good agreement; particularly in magnitude**"; "very good agreement" for noise **[L981–982, L67–70]** — no % | Initial cylinder conditions from measured pressure **[L640]** | 3 exhaust systems, 2 speeds |
| **Lamas 2012 [L12]** | 127.3 cc single, 53.8×56, loop, DI, 6000 rpm | 3-D CFD (Fluent), 0.1 °CA | "**acceptable concordance**" on pressure; SE = 82.5 predicted **[L889–893, L947]** | Measured pressures as BCs; T_init from ideal Otto **[L844–852]** | 1 condition |
| **Theotokatos 2018 [MV18]** *(marine)* | MAN 7K98MC, 980×2660, 7 cyl, 40 055 kW @94 rpm, uniflow | 0-D + MVEM, steady | **Power 0.92–1.02 %, BSFC −0.16…−0.55 %** **[L2128–2156]** | Wiebe a=10, m=0.93, 47 °CA, φ=2.13, ref 85.4 rpm — "calibrated for one operating point" **[L2088–2098, L394–396]** | 4 loads (25/50/75/100 % MCR) |
| **Foteinos 2019 [F19]** *(marine)* | MAN 6S50ME, 500×2000, 6 cyl, 7620 kW @115 rpm, uniflow | 0-D MOTHER + 2-D CFD | **"better than 3 % over the whole operating range"**, code-level, 50+ engine types **[L315–318]**; own validation vs CFD, qualitative **[L933–948]** | 3-zone mixing coefficients ξ, k revised against CFD **[L205–210, L256–257]** | 4 loads × 2 port cases |
| **Liu 2022 [FR22]** *(marine)* | 6EX340EF, 340×1600, uniflow, 3672 kW @142.5 rpm | 0-D 4-stage | **Temperature ≤3 %, pressure ≤4 %, mass ≤2 % — vs CFD, not experiment** **[L23–26]** | "calibration parameters for each zone's mass transformation" **[L221]** | 1 load (75 %), CFD reference |
