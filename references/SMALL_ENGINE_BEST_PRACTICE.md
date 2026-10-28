# What Actually Improves Correlation for a Sub-200 cc Crankcase-Scavenged Carburetted Two-Stroke

**Scope:** single-cylinder, crankcase-scavenged, piston-ported, Schnürle/loop-scavenged, carburetted, <200 cc, naturally aspirated, non-tuned (stub or box) exhaust — i.e. the UAV / small-industrial class.

**Method:** every claim below is tied to a line number in the 23 extracts in `references/text/`. Where a paper says nothing, it says **NOT REPORTED**. Where a source comes from a different architecture (uniflow, boosted, marine diesel, free-piston, poppet-valve, separately-blown) it is flagged **NON-TRANSFERABLE** with the reason.

**Headline answer:** the literature's own error budget for this class is set by *trapped mass*, and trapped mass is set — in this order — by (1) the crankcase pump and its reed, (2) the exhaust boundary condition, (3) whether the scavenging curve is the right *shape* at the delivery ratio the engine actually runs at (≈0.5, not ≈1.0), and (4) discharge coefficients. Combustion and friction are downstream and comparatively cheap to fit.

---

## 0. The reference engines in this corpus that actually match the target class

| Engine | Displacement | Scavenging | Induction | CR_cc | Source |
|---|---|---|---|---|---|
| Ku & Trimble | 9.818 in³ = **161 cc** (2.50 × 2.00 in) | loop | rotary valve **+ blower** | **1.44** | `1956_Ku_Trimble` L313–331 |
| Yamaha MT-110S | **100 cc** (52 × 50) | Schnürle loop | piston port, carburettor | **not given** (CR 5.8) | `1995_MODELLING` L4259–4296 |
| Suzuki TS125 | **123 cc** (56 × 50) | crankcase-scavenged, piston port | carburettor | **1.3 : 1** | `1981_Jones_Brown` L1155–1180 |
| Blair "LOOPSAW" | **65 cc** | loop (2 transfer ports) | piston port | 1.4 / 1.5 | `Blair_Design_Simulation` L13093–13097; `Blair_Basic_Design` L10798, L10818 |
| Blair reed design example | **125 cc** | loop | reed | **1.35** | `Blair_Design_Simulation` L23850, L23870–23872 |
| Hooper (UAV flat-twin) | 342 cc total, **171 cc/cyl** (66 × 50) | Schnürle loop, 5 transfer ports | **6-petal steel reed + diaphragm carburettor** | **1.5 : 1** (measured) | `2022_Study_of_the_effects` L273–274, L371–386, L608–611 |
| Lamas (CFD anchor) | 127.3 cc (53.8 × 56) | loop, **DI** | — | not given | `2012_Simulation_of_the_Scavenging` L694–711 |
| Qiao (UAV flat-twin) | 498 cc total, 249 cc/cyl (75 × 56) | loop, 3 transfer ports | reed + single-point injection | not given | `2018_Qiao` L342–346, L359–425 |

The Hooper engine (L371–386) is the closest published analogue to the target: **171 cc/cyl, loop-scavenged, reed-valve, carburetted, crankcase-scavenged, CR_cc = 1.5, CR_trapped = 7.1**. Use it as the primary sanity anchor.

---

## 1. CRANKCASE PUMPING — sensitivity to crankcase volume / CR_cc

### 1.1 How sensitive is delivery? Very. A CR_cc change of 0.1 moves power ~17–20%.

This is the single best-quantified sensitivity in the corpus. Blair runs the *same* 65 cc chainsaw engine, same porting, same (restrictive) exhaust box, changing only CR_cc from 1.4 to 1.5:

> "The output of the computer calculation using Prog.5.1 is presented in Fig. 5.14 for a crankcase compression ratio of 1.4. It will be seen that the restrictive exhaust box has a profound influence on the cylinder and exhaust pressure diagrams. The build-up of exhaust back-pressure during the scavenge phase opposes the crankcase blowdown with the result that the crankcase pressure is still above the atmospheric pressure by exhaust port closure. This reduces the strength of the suction to half of the crankcase pumping action which translates into a low delivery ratio of 0.487." — `Blair_Basic_Design` L10798–10804

> "The resulting scavenging efficiency is correspondingly low at 0.52. Nevertheless, the engine produces 3.66 bar BMEP at 7500 rpm and a power output of 4.6 kW, with a commendable BSFC of 444 g/kWh." — L10809–10812

Then, changing **only** CR_cc:

> "Thus a data change is made to give a crankcase with a compression ratio of 1.5, and the calculation is repeated with the result shown in Fig. 5.15. The delivery ratio is considerably higher at 0.562, the scavenging efficiency is increased to 0.564, the power rises to 5.4 kW, and the BMEP to 4.3 bar. Although the pumping MEP has risen to 0.29 bar from 0.21 bar, the increase of IMEP from 4.18 to 4.90 bar more than compensates for the greater pumping work." — L10817–10822

**Derived numbers (mine, from the paper's own figures):** ΔCR_cc = +0.1 → DR +15.4 % (0.487→0.562), SE +8.5 % (0.52→0.564), power +17.4 % (4.6→5.4 kW), IMEP +17.2 % (4.18→4.90 bar), PMEP +38 % (0.21→0.29 bar).

Across the speed range, from the *same* comparison:

> "the higher crankcase compression ratio of 1.5 performs better across the entire engine speed range. The peak power output at 8000 rpm has been raised by 18% with a marginal improvement of 4% in specific fuel consumption. It reinforces the opinion that the crankcase pumping action is one of the most significant design parameters for a high-speed industrial engine of this type" — `Blair_Basic_Design` L10928–10933

> "The almost linear fall of DR with the lower crankcase compression ratio of 1.4 results in a 20% drop in power at 9000 rpm. At 5000 rpm there is very little difference in performance between the two variations of the engine" — L10934–10937

Note the shape of that last result: **CR_cc error is nearly free at low speed and punishes you at high speed.** A model calibrated only at 4000–5000 rpm will look excellent and then fail at 8000 rpm, which is exactly the failure signature Hooper reports (§5.3).

Blair also makes the mechanism explicit:

> "Below the piston, the compression of the fresh charge is taking place. The pressure and temperature achieved will be a function of the proportionate reduction of the crankcase volume, i.e., the crankcase compression ratio." — `Blair_Design_Simulation` L1693–1695

And in the small-engine-specific version (1-D model, 1.5 L swept, 1.2–2.4 swept range — see the non-transferable caveat below):

> "As the compression ratio of the crankcase increases, the torque of the engine shows an increasing trend. When the compression ratio of the crankcase is 1.2, due to the poor scavenging effect of the engine, there is less fresh charge entering the cylinder... But when the crankcase compression ratio increases to 1.8, continuing to increase the crankcase compression ratio will result in a smaller change in engine torque, but it will lead to a rapid increase in engine fuel consumption." — `IOP_2024_scavenge_params` L178–183

> "When the compression ratio of the crankcase is 1.5, the scavenging efficiency reaches a maximum of 95.14%." — L173–175

⚠️ **The 95 % number is a 1-D simulation output, not a measurement**, on a "spark ignition two-stroke diesel" (heavy-fuel SI) engine. It is an order of magnitude above every measured small-engine SE in this corpus (§3). Do not use it as a calibration target; use it only as a *trend* (SE peaks at CR_cc ≈ 1.5, then falls). **The CR_cc torque/BSFC trends in `IOP_2024` are NON-TRANSFERABLE numerically** (unknown displacement, heavy-fuel, likely boosted "intake crankcase turbocharging", L164–166).

### 1.2 Measured CR_cc range for <200 cc engines

This is the most useful practical fact in the corpus, and it is a *geometric* argument, not a tuning choice:

> "While it is true that the higher this value becomes, the stronger is the crankcase pumping action, the actual numerical value is greatly fixed by the engine geometry of bore, stroke, con-rod length and the interconnected value of flywheel diameter. In practical terms, it is rather difficult to organize the CRCC value for a 50 cm3 engine cylinder above 1.4 and almost physically impossible to design a 500 cm3 engine cylinder to have a value less than 1.55." — `Blair_Design_Simulation` L2263–2268 (identical wording: `Blair_Basic_Design` L1666–1671)

So: **CR_cc falls as displacement falls.** Assembled measured/design values:

| Engine | cc | CR_cc |
|---|---|---|
| Suzuki TS125 (`1981_Jones_Brown` L1155–1179) | 123 | **1.3** |
| Blair reed design example (`Blair_Design_Simulation` L23872) | 125 | **1.35** |
| Ku & Trimble (`1956_Ku_Trimble` L329–330) | 161 | **1.44** |
| Hooper UAV twin (`2022_Study...` L383–384) | 171/cyl | **1.5** |
| Chainsaw, Blair (`Blair_Basic_Design` L10798, L10818) | 65 | 1.4 → 1.5 |

**For a <200 cc engine, expect CR_cc ≈ 1.30–1.50, and 1.45 ± 0.05 is the defensible default.** Anything above ~1.6 on a sub-200 cc cylinder is geometrically implausible and is a red flag that the clearance volume was mis-specified (usually by omitting the transfer-duct volume or the reed-block cavity).

### 1.3 What is NOT reported

- **No experimental CR_cc sweep on a <200 cc engine exists in this corpus.** Blair's 1.4 vs 1.5 is a *simulation* comparison (L10916–10922), albeit a well-validated program. `IOP_2024` is 1-D only. Hooper states the CR_cc was "measured from the original engine" (L611) but never varies it.
- Ku & Trimble varied speed (500–3000 rpm), inlet pressure and exhaust pressure **but not CR_cc** (L466–495). Their single CR_cc = 1.44.
- No paper quantifies ∂DR/∂CR_cc analytically for this class. **NOT REPORTED.**
- No paper gives a measured crankcase pressure trace against which a pump model can be validated, *except* the 1995 thesis (see §1.4). Hooper notes only that "Input functions revolve largely around the compression ratio of the crankcase" (L609–610) — i.e. the crankcase is modelled as a simple variable-volume pump with no independent validation.

### 1.4 The one diagnostic that exposes crankcase-pump error: p_cc − p_cyl

The 1995 Yamaha MT-110S (100 cc) thesis is the only source here that publishes the crankcase-to-cylinder pressure difference and uses it diagnostically:

> "The back flow finally ceases as the cylinder volume increase and the crankcase volume decrease, and the flow reverses its direction at about 5 degrees crank angle after the transfer port opens." — `1995_MODELLING` L3871–3875

> "at about 35 degrees before the transfer port closes, the pressure difference reduces to zero and stays at zero for 20 degrees of crank angle... it is clear that the flow rate of transferred charge may drop as a result of lack of driving force before the port is geometrically shut by the piston timing edge. It greatly impairs the process of scavenging the cylinder." — L3899–3907

> "The reason for this zero pcc-pcyl pressure difference may be attributed to two factors. The first is the continuous transferring of mass from the crankcase to the cylinder and the change of crankcase volume causes the crankcase pressure decrease. The second is the cylinder pressure increase... plus the strong plugging pressure wave generated by the exhaust reverse cone arriving too early at the exhaust port which blocks the port" — L3908–3915

**This is the coupling that breaks naive models:** in this class the crankcase pump and the exhaust wave are not independent. If the exhaust model returns the plugging wave early, p_cyl rises, Δp across the transfer port collapses, delivery dies — and the modeller, seeing low delivery, will wrongly "fix" it by inflating CR_cc. Crankcase and exhaust errors are confounded; they must be diagnosed with the Δp trace, not with the power curve.

### 1.5 Upstream volume matters too (a data-set trap)

Schweitzer measured a delivery ratio of 0.544 that was an artefact of his own test rig:

> "The low delivery ratios and charging efficiencies obtained in these tests are not typical of the engine but are the result of an inadequate surge-tank capacity and a short 2-inch-diameter tube inserted between the tanks to minimize the pressure fluctuations. This small tube restricted the air delivery to below normal." — `1942_Schweitzer` L1249–1256

> "Subsequently, the air delivery tests were repeated with a larger surge tank (about 27 times displacement volume), free of restrictions and having two 20-inch-diameter rubber membranes... The air delivery thus measured corresponds to a delivery ratio of 0.72." — L1257–1264

⚠️ `1942_Schweitzer` engine is **10.5 in bore × 12 in stroke = 17 L, 30 hp at 400 rpm, crankcase-scavenged diesel** (L2441–2445) — **NON-TRANSFERABLE in scale and speed**; only the *methodological* warning transfers. Still, the warning is first-order for a carburetted UAV engine: the airbox/filter volume and intake tract length are part of the model, and if you simulate "atmosphere at the carburettor bellmouth" while the test cell had a ducted blower (Hooper L283–288, Ku & Trimble L348–351), you will mis-fit CR_cc to absorb the error.

---

## 2. REED VALVE — dynamic petal, not a static check valve

### 2.1 Every credible model in this corpus is dynamic

Blair (via Hinds), Hooper (via Morrison/Hinds), Ortenzi (via Fleck/Dave) and Climent all model the petal as a vibrating structure:

> "Hinds showed that the reed valve can be treated as a pressure-loaded cantilevered beam clamped at one end and forced into various modes of vibration by the crankcase pressure acting on one side of the beam, and the superposition pressure at that position in the inlet tract acting upon the other." — `Blair_Design_Simulation` L19292–19295

> "By correlating theory with experiment, Hinds showed that it was quite adequate to consider only the first two modes of vibration and that the higher orders could safely be neglected." — L19329–19330

> "Bounce off the reed stop must also be included, should it be in the form shown in Fig. 5.4 or be it a simple tip stop as is often found in practice." — L19321–19322

> "The effective throat area of the port posed by the reed system at any juncture... is defined by At and the numerical value of At is that given by either A_ip or A_rd, whichever is the lesser. To carry out this exercise during simulation, all of the data shown in Fig. 5.4, with the exception of x_tip and x_act which are computed, are required as input data to it, together with the Young's Modulus and the density of the reed petal material." — L19365–19370

Hooper's implementation:

> "The reed can be considered as a cantilever of slender cross section. The steel reeds applied in this study were 17.5 mm wide, 25 mm effective length and 0.2 mm thick. Using cantilever beam theory, it is possible to consider the reed motion due to the pressure difference occurring across the valve." — `2022_Study_of_the_effects` L495–499

> "Input of the effective port flow area and reed spring constant, kr, enables WAVE to simulate the reed block." — L606

Ortenzi's:

> "The geometry and dynamics of the reed valves and stop plates have been simulated as cantilever beams taking into account its interaction with the stop plates. When the pressure at the intake port is higher than the crankcase pressure, the reed valve receives a force that deflects it and then opens the port. The dynamics are modeled using the modal analysis, simulating the first two modes of vibration, and the integration method is the Runge–Kutta 4th order." — `2023_Ortenzi` L192–197

Climent uses a lumped mass-spring-damper instead:

> "The reed valve petal is assumed to be a punctual mass concentrated in the petal tip. The lift follows the classical mass-spring-damper model, where the external force depends on the pressure difference upstream and downstream of the valve." — `2023_Climent` L313–317

So there are two accepted levels of fidelity — **distributed cantilever (2 modes)** and **lumped 1-DOF mass-spring-damper** — and *no* source in this corpus uses a static check valve. A static (zero-lift-time, zero-inertia, ideal-diode) reed is not a simplification the literature endorses; it is outside the state of the art.

### 2.2 What the static assumption actually gets wrong — and why it is worst at high speed

A static check valve opens the instant p_in > p_cc and closes the instant it reverses, with no inertia, no bounce and no lift-area relationship. Three concrete errors follow, all evidenced:

**(a) It destroys the timing law, which is speed-dependent.** The reed's opening/closing points migrate with speed:

> "the reed valve opening and closing points, marked as RVO and RVC, respectively, are quite similar to a disc valve engine at low engine speeds and to a piston-controlled port at higher engine speeds. For racing engines, the designer would have wished those characteristics to be reversed! The transition in the RVO and the RVC points is almost, but not quite, linear with speed, with the total opening period remaining somewhat constant." — `Blair_Design_Simulation` L2150–2155

Measured/predicted on a Yamaha RD350LC:

> "The timing of opening and closing of the reed petal at the low speed of 5430 rpm shows the reed opening at 160° btdc and closing at 86° atdc, which is an asymmetrical characteristic about tdc. At the 'high' engine speed of 9150 rpm, the reed petal opens at 140° btdc and closes at 122° atdc." — L23730–23734

**Derived (mine):** the closing point moves **+36° CA** (86° → 122° atdc) and the opening point **+20° CA** (160° → 140° btdc) between 5430 and 9150 rpm, so the total open duration stays roughly constant (246° → 262° CA) while the *phasing* slides toward symmetry about TDC — i.e. the reed loses its asymmetric advantage and behaves like a symmetric piston port. A static check valve cannot reproduce a 36° CA closing-point migration; it will be wrong by that amount at one end of the speed range *by construction*.

**(b) It ignores that the lift area is itself flow-limiting.** The flow area past the petal is `A_rd = n_r · x · X_p`, and Blair stresses it must be matched to the port area:

> "if the design incorporates a large reed port area but a stiff reed which will barely lift under the pressure differential from the intake side to the crankcase, very little fresh charge will enter the engine. Equally, the design could have a large flexible reed which lifted easily but exposed only a small reed port, in which case that too would produce an inadequate delivery ratio characteristic." — L23764–23769

**(c) It ignores the crankcase-pumping feedback.** Reed forcing is *set by CR_cc*, so a static reed cannot respond to the parameter that matters most:

> "The mean pressure differential, Δp, assumed to act across the reed is found by estimating that this is a linear function of CRCC in atmosphere units, where 18% is regarded as the mean effective value of the maximum: Δp = 0.18(CRCC − 1) × 101325 N/m²" — L23912–23916

> "the opening and closing characteristics of the reed are now controlled by such factors as the reed material, the crankcase compression ratio, the engine speed and the throttle opening." — L2147–2149

### 2.3 At what speed does the reed become the limiting element?

The literature gives a *frequency* criterion, not a speed criterion — which is the correct way to think about it:

> "the first fundamental frequency is equal to the engine speed in cycles per second, i.e., rps. The first-order natural frequency is the one to which some attention should be paid, for it is my experience that it tends to be quite close to the maximum speed of engine operation of a well-matched design. As long as the reed natural frequency is 20% higher than the engine natural frequency, there is little danger of accelerated reed petal damage through fatigue." — L23896–23903

And in the worked 125 cc racing design:

> "REED NATURAL FREQUENCY, Hz = 160. ENGINE NATURAL FREQUENCY, Hz = 192. TIP LIFT RATIO, 'Crdt' = 0.33. STOP PLATE RADIUS 'Rsp', mm = 58. … 11500, bmep, bar = 11, CCrc = 1.35" — L23867–23872

**Read that carefully:** at 11 500 rpm the *engine* fundamental is 192 Hz and the *reed* natural frequency is only 160 Hz. The reed is being driven **above** its own first natural frequency at rated speed — i.e. it is inertia-dominated, cannot track the pressure signal, and its lift is running at the stop-plate limit (tip-lift ratio 0.33 vs the 0.3 design limit, L23945–23947).

**So, for a 0.2 mm steel petal of ~25 mm length:**

- **≲ 6 000 rpm:** reed behaves quasi-statically, timing is strongly asymmetric, a static valve is a tolerable approximation (error mostly in closing delay).
- **≈ 9 000–9 500 rpm:** the closing point has already migrated to ≈ symmetric (Blair's 122° atdc at 9150 rpm); the reed no longer buys you asymmetric timing. A static model is now materially wrong.
- **≈ 11 000–11 500 rpm:** reed natural frequency is below engine frequency; lift is stop-limited; the reed is the flow-limiting element and the whole induction model must be dynamic.

**Scaled to the target class:** a <200 cc UAV engine at 6 000–8 000 rpm sits *below* the regime where the reed is the limiter. This is why a static reed can survive a first-pass model of a 7 000 rpm UAV engine — but not of a 12 000+ rpm kart engine (`2023_Ortenzi` L144–160: X30 reed valve to 16 000 rpm; KZ, 5 transfer ports and 3 exhaust ports, ~37 kW).

⚠️ **Honest caveat:** **no paper in this corpus quantifies the error caused by a static vs dynamic reed.** No A/B study, no "static model overpredicts DR by X %". **NOT REPORTED.** What *is* reportable is the consequence chain: dynamic models reproduce measured reed lift and measured DR across the whole speed range —

> "The close correspondence between the calculation and measurement of reed lift is evident, as is the resulting calculation and measurement of delivery ratio over the entire speed range of the engine" — L23728–23730 (Fig. 6.26, 4000–10000 rpm)

— whereas the static model has no mechanism to produce the 36° CA closing migration.

### 2.4 Minimum reed data (all required; none optional)

From `Blair_Design_Simulation` L19365–19370 and L23786–23787, and `2022_Study...` L495–499:

petal length, width, thickness, number of petals, port length/width/corner radius, block half-angle, clamp offset `x_s`, stop-plate radius, **Young's modulus** and **density** of the petal material.

Reference values if you must assume: steel `Y = 207 GN/m², ρ = 7800 kg/m³`; glass-fibre composite `Y = 21.5 GN/m², ρ = 1850 kg/m³`; carbon-fibre `Y = 20.8 GN/m², ρ = 1380 kg/m³` (`Blair_Design_Simulation` L23789–23796).

---

## 3. SCAVENGING — measured SE on real small loop-scavenged engines

### 3.1 The critical number: small crankcase-scavenged engines run at delivery ratio ≈ 0.5, not ≈ 1.0

This is the most commonly violated fact in small-engine modelling. Blair's 65 cc chainsaw, correlated against measured power over 5400–10 800 rpm:

> "Fig. 5.9 shows the close correlation of the measured and simulated power and torque (as bmep) of the engine over the speed range from 5400 to 10,800 rpm. The attained bmep is quite modest at some 4 bar, but when the measured and simulated characteristics of delivery ratio and trapping efficiency are examined in Fig. 5.10, it can be seen that the engine attains this torque level with a peak delivery ratio, DR, of only 0.53 but with a high trapping efficiency of over 70%." — `Blair_Design_Simulation` L19800–19806

> "the data are for full throttle operation, but in such a unit the scavenging efficiency is modest at 0.75, for the delivery ratio is low so that the bmep produced approaches 4 bar at a high trapping efficiency, giving good fuel consumption and low hydrocarbon exhaust emissions." — L16694–16697 ("CHAINSAW ENGINE, 9600 rpm, SE=0.75", L16677)

And with a restrictive box silencer, the same engine drops further:

> "a low delivery ratio of 0.487... SRv is 0.614 for a SR level of 0.537. The resulting scavenging efficiency is correspondingly low at 0.52." — `Blair_Basic_Design` L10804–10809

By contrast, a tuned racing engine lives at the opposite corner:

> "125 cc GP MOTORCYCLE ENGINE, 10350 rpm, DR=1.15, SE=0.96" — `Blair_Design_Simulation` L16730–16731

**Calibrating a scavenging curve at DR ≈ 1.0 and applying it to a UAV engine running at DR ≈ 0.5 puts you on completely the wrong part of the curve** — the part Blair explicitly says is "of little consequence" for a low-bmep engine and where short-circuiting dominates (L13111–13115).

### 3.2 Measured SE values on real loop-scavenged engines in this corpus

| Value | Engine | How obtained | Transferable? |
|---|---|---|---|
| **SE = 0.75** at 9600 rpm, full throttle, DR ≈ 0.5 | 65 cc chainsaw, loop | correlation of simulation to *measured* power; SE is a model output constrained by measured DR and power (`Blair_Design_Simulation` L16677, L19800–19808) | ✅ small, loop, crankcase |
| **SE = 0.52** at 7500 rpm, restrictive box exhaust, DR 0.487 | 65 cc chainsaw, loop | idem (`Blair_Basic_Design` L10804–10812) | ✅ |
| **SE = 0.96** at 10350 rpm, DR 1.15 | 125 cc GP racing, tuned pipe | measured DR + measured power (`Blair_Design_Simulation` L16730–16731) | ✅ but only for tuned-pipe racing |
| **e = 66.7 %** (mass fraction fresh charge) at 1800 rpm, scavenge ratio 1.4 | 4.5 × 6 in = **1563 cc**, loop, **blower-scavenged** | measured air rate + indicated power + referenced 4-stroke C.F.R. engine (`1938_Rogowski` L573–599, L786–791) | ⚠️ **NON-TRANSFERABLE**: 10× the displacement, 1800 rpm, separately blown (L242–248), not crankcase-compressed |
| **SE = 82.5** | 127.3 cc loop, DI | **CFD output**, not measured (`2012_Simulation_of_the_Scavenging` L943–947) | ❌ modelled |
| **SE = 0.784 / 0.680** (high/partial load) | 249 cc/cyl UAV, loop | **3-D CFD output**, 1-D calibrated on pressure only (`2018_Qiao` L1478–1482) | ❌ modelled |
| **SE = 95.14 % / 97.2 % / 96.44 %** | unknown UAV "SI two-stroke diesel" | **1-D GT-POWER output** (`IOP_2024` L173–175, L225–226, L259–260) | ❌ modelled, and implausible (§1.1) |

**Bottom line: for a sub-200 cc Schnürle crankcase-scavenged engine at full throttle, the defensible measured SE band is 0.50–0.75.** If your model returns 0.90–0.97, it is wrong, no matter how good the power curve looks (you are compensating with combustion efficiency or friction).

### 3.3 SE-vs-delivery-ratio data: where it exists and what it says

**The best experimental evidence in the corpus is not a small-engine firing test — it is Ku & Trimble's finding that the fresh-charge fraction collapses onto scavenging ratio *alone*:**

> "It is interesting to note that the mass fraction of fresh charge in the cylinder was, within experimental accuracy, a function of scavenging ratio only, regardless of the individual values of engine speed, inlet pressure, or exhaust pressure, within the range of the variables investigated." — `1956_Ku_Trimble` L814–819

That is a licence to model scavenging as a one-dimensional function of R_s (or DR), with no speed dependence — the strongest structural simplification available to you. It was obtained on a **161 cc loop-scavenged crankcase-compressed engine** (L313–331), i.e. directly in class. ⚠️ Caveat: the airbox pressure was set independently by a blower (L348–351), so R_s was an independent variable; in a carburetted engine at fixed throttle, R_s is itself an output of the pump. Their result is therefore a statement about the *scavenging process*, and it does **not** remove the need to model the pump.

The method itself is worth knowing because it needs no pressure transducer:

> "consider the case when the engine is allowed to fire for one cycle and then skip, or run without firing, for several cycles... the mass fraction of fresh charge in the cylinder after port closure would be e_n = 1 − f^n" — L199–239

**Measured SE–DR curves for loop-scavenged cylinders were obtained on the QUB single-cycle gas rig** (constant volume, isobaric, isothermal, CO₂/air tracer, O₂ analyser). The 1995 thesis describes the rig and its role:

> "The experimental justification for such classical scavenging models is scant. Information of this kind was not available until the 1980's and probably the most appropriate experiments were conducted by researchers at The Queen's University of Belfast (QUB) on the single cycle engine test rig." — `1995_MODELLING` L1123–1126

> "The rig allows the scavenging process in a tested cylinder to be similar to what the theoretical assumptions of scavenging prescribe, that is, a constant volume, isobaric and isothermal process." — L1130–1132

> "during the experiment, the cylinder is filled with air to represent exhaust gas and the crankcase is filled with carbon dioxide to represent the fresh charge... The retained fresh charge in the cylinder is then discharged... into a paramagnetic oxygen analyser." — L5933–5942

Scale of that dataset:

> "By the end of 1994 at QUB, a large library of information on this subject has been amassed with up to four QUB single-cycle gas rigs conducting tests on over 1300 differing cylinder geometries." — `Blair_Design_Simulation` L13100–13107

`LOOPSAW` — "A loop-scavenged cylinder of 65 cm³ swept volume... two transfer ports... designed for use in a chainsaw and is very typical of all such cylinders designed for small piston-ported engines" (L13093–13097) — is the in-class measured SE–SR curve in that library (Figs. 3.12/3.13, L13141–13149). **Its numeric values are in figures and are not present in the extracted text — NOT REPORTED in numeric form.**

⚠️ **Important caveat on rig data:** the QUB rig has a *constant* crankcase volume (L1128–1129) and is isothermal, so it isolates the *port-geometry* contribution. It cannot reproduce the wave-action-driven trapping of a firing engine. Use it to get the SE–DR *shape*, then re-anchor the absolute level with a firing-engine power/BSFC point.

### 3.4 The scavenging model form matters, and Benson–Brandham is refuted

> "the authors concluded that the measured scavenging efficiencies and scavenging ratios, when plotted as ln(1−ηs) vs. X, do fall on straight lines. However, the slopes of these straight lines are all less than −1, which is in conflict with the Benson-Brandham theory. Moreover, the better the scavenging, the closer the value is to −2. This 1988 finding demonstrates that the Benson-Brandham scavenging model fails to correlate with relevant experiments. The reason is that the 'step change' assumptions are not realistic in real scavenging processes." — `1995_MODELLING` L1141–1147

That is a direct, experimental refutation of the two-parameter (x, y) step-change model *by the people who generated the data*. Blair subsequently replaced it with a continuous (volumetric, three-fraction, linearly-varying) model that needs two tuning parameters:

> "According to the author, the model is relatively simple to 'tune' for a particular engine cylinder, as there are usually only two parameters to be manipulated in order to achieve a good correlation with experiment." — L1181–1183

Yet `2018_Qiao` optimises ports against exactly the refuted Benson/Bradham (x, y) objective:

> "the key parameters, x and y, of the Benson/Bradham model are employed to construct an objective function" — `2018_Qiao` L326–328

and gets an excellent fit to *its own CFD*:

> "The root-mean-square error of the corresponding curve fitting is in the order of 10⁻⁴, indicating that the fitting curve matches well with the simulation result." — L1279–1281

**Read that as a warning, not a validation:** any two-parameter model will fit any smooth SE–DR curve to 10⁻⁴. The fit quality says nothing about physical validity; the QUB data says the underlying assumption is wrong. Prefer the **Sher/Blair continuous form**, or `Ortenzi`'s three-coefficient exponential:

> "SEv = 1 − e^{k0 + k1·DRv + k2·DRv²} where the coefficients k0, k1, k2 are empirical and are calibrated with experimental data." — `2023_Ortenzi` L218–222

Note also that Qiao's own results show SE and TE are not independent and cannot both be matched by one knob:

> "there exists an obvious trade-off relationship between the scavenging efficiency, ηS, and trapping efficiency, ηT" — `2018_Qiao` L1658–1660

⚠️ `2018_Qiao` also assumes η_S ≈ η_C = λ_S·η_T because "the intake pressure is approximately equal to the ambient pressure" (L196–202). For a throttled carburetted engine at part load this is false, and the assumption should not be inherited.

### 3.5 Cost of getting SE wrong

A trapping-efficiency error of 5 points nearly doubles unburned HC and costs 10 % fuel consumption (simulation comparison of two scavenging curves in the same engine):

> "the GPBDEF scavenging reaches 95%, while the LOOPSAW scavenging gets to a very creditable, but critically lower, 90%... the deflector piston design achieves the target bsHC emission of 25 g/kWh, but the loop-scavanged design has double that value at 50 g/kWh... The fuel consumption of the deflector piston engine is 10% better than the loop-scavenged design" — `Blair_Design_Simulation` L25493–25500

If your calibration target is power only, a 5-point TE error is invisible. If you also target BSFC or HC, it is not. **This is the argument for measuring BSFC, not just torque.**

---

## 4. DISCHARGE COEFFICIENTS — measured values and their variation with opening

### 4.1 C_d is a function of *two* variables, and published tables often give the wrong one

> "The objective is to measure and deduce Cd in such a manner that when it is 'replayed' in a computer simulation of the engine, at identical values of pressure, temperature and area ratio, the calculation would predict exactly the mass flow rate that was measured. At other thermodynamic state conditions, the discharge coefficient is characterized by the pressure ratio and the area ratio and fluid mechanic similarity is assumed." — `Blair_Design_Simulation` L12046–12050

> "this gives an 'ideal' discharge coefficient, Cdi... However, even with this modification to the classic analytical method, the value of 'ideal' discharge coefficient, Cdi, is still not the correct value for accurate use within a computer engine simulation." — L12061–12065

> "I have published a considerable volume of Cd data relating to both two- and four-stroke engines, but all of it is in the format of Cdi and all of it is in the traditional format whereby the ideal mass flow rate was determined by an isentropic analysis. Where the original measured data exist in a numeric format, that data can be re-examined and the required Cda determined. Where it does not, and the majority of it no longer exists as written records, then that which I have presented is well nigh useless for simulation purposes." — L12106–12111

> "Furthermore, it is the complete digitized map, such as in Fig. 2.27, that is needed for each and every pipe discontinuity to provide accurate simulation of unsteady gas flow through engines." — L12112–12113

**This is the most important sentence in the corpus on CD:** most published two-stroke C_d data cannot be used directly in a 1-D code. You need the *actual* C_d (non-isentropic reduction), as a map over (area ratio k, pressure ratio P).

### 4.2 Measured exhaust-port C_d for a 125 cc two-stroke, and how much it varies

> "In Figs. A2.4 to A2.7 are the measured discharge coefficients for both inflow and outflow at the exhaust port of a 125 cm³ Grand Prix racing motorcycle engine... These figures plot the discharge coefficients with respect to pressure ratio from the cylinder to the pipe, P, and for geometrical area ratios, k, of 0.127, 0.437, 0.716 and 0.824, respectively." — L12114–12119

> "At a low area ratio, k, there is almost no difference between Cdi and Cda. The traditional analysis would be equally effective here. As the area ratio increases, and where the mass flow rate is, almost by definition, increasing, then the mass flow rate error through the application of a Cdi value also rises. The worst case is probably inflow at high area ratios, where it is seen to be 20%." — L12123–12127

Numeric anchors read off the extracted figure **axis tick ranges** (L12133–12223; these are axis bounds, not digitised points): C_d ≈ 0.79–0.84 at k = 0.127; ≈ 0.60–0.68 at k = 0.716; ≈ 0.4–0.7 at k = 0.824 with a strong pressure-ratio trend. Treat these as ranges to sanity-check against, not as a data table.

**So: C_d varies roughly 2:1 across the port-opening range (k = 0.13 → 0.82), and using a single constant C_d mis-predicts mass flow by up to 20 % at the high-lift end — which is exactly where a WOT small engine spends the scavenging window.**

### 4.3 The literature disagrees on how much this matters — report the tension

`Ortenzi` treats the CD map as essential infrastructure:

> "the three-dimensional nature of the flow is not taken into account within the one-dimensional model; the effective area of the port is not its geometrical area. Such a problem can be overcome using discharge coefficients unique for each type of boundary device. These coefficients are functions of the area ratio of the port, reed, or throttle, but are functions also of the pressure ratio across the device. Such coefficients are then stored in three-dimensional matrixes, and for each area ratio and pressure ratio, they return as an output the discharge coefficient." — `2023_Ortenzi` L198–205

`Hooper` reports the same physics but cites Blair arguing against over-investing in it:

> "As the port pressure ratio varies the Cd value varies significantly. Heywood and Sher (1999) found that the steady flow Cd value is normally higher than the comparative value determined via unsteady flow conditions." — `2022_Study_of_the_effects` L718–720

> "Port effective flow area can be defined by determining their discharge coefficients (Cd) at varying port opening or piston positions. However, Blair (1996) argues that whilst this approach can be used effectively to improve port flow characteristics, it is of limited assistance within one-dimensional fluid dynamic engine models due to limitations of the models to be able to reproduce the actual thermodynamics occurring within the real engine. For this reason, isentropic methods can be adopted." — L620–625

`Climent` sidesteps measurement altogether and calibrates C_d to CFD:

> "A discharge coefficient is used for the intake and exhaust port openings and closings, and is a function of the piston position. The discharge coefficient of the ports is calibrated to attain the instantaneous mass flow rates obtained in the CFD simulations." — `2023_Climent` L309–311

⚠️ `2023_Climent` is **uniflow/opposed-scavenged with a separate air pump and rod-mounted intake ports** (L223–229) — **NON-TRANSFERABLE for scavenging or crankcase**, but the C_d-calibration *workflow* is transferable.

### 4.4 Measured C_d variation with *lift* (different architecture — flag)

The only lift-resolved C_d measurements in the corpus are for a **poppet-valve** two-stroke (65 cc four-stroke converted, L95–96), hence **NON-TRANSFERABLE to piston-ported Schnürle** — but they are the clearest demonstration of *how violently* C_d varies near cracking:

> "At 0 L/D ratio, SB Chevy has 0.55 coefficient and two-stroke poppet valve engine is 0.32 and 0.26 coefficient. Then the coefficient for both engine head have similar values at 0.05, 0.1 and 0.15 L/D ratio with 0.54, 0.61 and 0.57 coefficient respectively. The highest coefficient value is at 0.1 L/D ratio. Then, the values decrease gradually until 0.25 L/D ratio with 0.4 coefficients" — `2017_Kamili_Zahidi` L447–452

> "The two-stroke poppet valve engine has 90% higher coefficient between 0 until 0.05 L/D ratio. Then the percentage of coefficient different is reducing gradually until 46% at 0.279 L/D ratio." — L518–521

i.e. C_d rises from ~0.26 to ~0.61 (**2.3×**) within the first 10 % of lift, then *falls* again. The lesson for a piston-ported engine: do not extrapolate a single WOT C_d down to the port-cracking region, and do not assume C_d is monotonic in opening.

### 4.5 What is NOT reported

- **Measured C_d for the *transfer* ports of a small two-stroke: NOT REPORTED in this corpus.** Blair's Appendix A2.4–A2.7 is exhaust-port only (L12114–12116). No transfer-port C_d map appears in any of the 23 extracts.
- **No C_d map is published for a small utility/UAV engine of this class.** The only size-appropriate dataset is Blair's 125 cc Grand Prix racing cylinder — tuned pipe, high lift, high area ratio — so its high-*k* values are not representative of a detuned UAV port.
- No source quantifies the *power* sensitivity to C_d error. Only the mass-flow sensitivity (20 %) is given. **NOT REPORTED.**
- Qiao's GT-Power model silently uses C_d without reporting values (`2018_Qiao` L426–437).

---

## 5. PIPE — how much of the total error is exhaust modelling?

### 5.1 No study isolates it. This is the honest answer.

**NOT REPORTED.** No paper in this corpus performs an error decomposition that attributes X % of the total discrepancy to the exhaust model and Y % to scavenging, C_d, heat transfer, etc. The total errors reported are lumped:

| Source | Engine | Validation target | Reported error |
|---|---|---|---|
| `1995_MODELLING` | 100 cc Yamaha, piston port, expansion chamber | torque/power/BSFC, 2200–4400 rpm | "the agreement between the measurements and calculations was good, particularly at the medium and higher speeds. At lower speeds, the agreement deteriorated slightly, however the maximum discrepancy was still below 10%." (L4999–5001) |
| `2022_Study_of_the_effects` | 171 cc/cyl reed-valve UAV twin | full-load power + SFC, 3000–6500 rpm | "the predicted power output from the model was significantly lower than the actual power output from the test engine of the order of 8.2 to 13.3%, the greatest deviation occurring at 6000 rpm." (L1937–1939) |
| `2023_Ortenzi` | 125 cc X30 & KZ kart | power curve, 6500–16000 rpm | "root mean square error of about 0.5 kW" (L1330–1331; L1479–1480) — i.e. ~2 % of 22 kW, ~1.4 % of 37 kW |
| `2023_Climent` | uniflow prototype | instantaneous exhaust & cylinder pressure | "absolute maximum deviation of less than 2%" during scavenging (L355–362) |
| `2018_Qiao` | 249 cc/cyl UAV | in-cylinder pressure, 2 points | "a perfect matching" (L436–437) — unquantified |
| `IOP_2024` | unknown | in-cylinder pressure | "the maximum error is less than 5%" (L111–114) |

So the class-wide ceiling is: **~2 % on pressure traces, ~2–3 % on power for a well-instrumented tuned racing engine, ~10–13 % on power for a UAV-class engine.** Note that the *better* numbers come from engines with a strong pressure-wave signature (tuned pipes) — where the exhaust model is doing most of the work and is therefore easiest to check — while the *worse* numbers come from small UAV engines with short/stub exhausts, i.e. your case.

### 5.2 Three indirect bounds on the exhaust contribution

**(a) The exhaust restriction sets the delivery-ratio ceiling; CR_cc only buys back part of it.**

Blair's restrictive-box case: DR 0.487, SE 0.52, 4.6 kW, 3.66 bar BMEP. Raising CR_cc 1.4→1.5 recovers DR to 0.562 (L10804–10820). But the exhaust itself is named as the limiter:

> "With the restrictive exhaust system having been highlighted as the limiter on engine performance, the logical design option is to examine an engine design with one which is less restrictive." — `Blair_Basic_Design` L10813–10815

**Derived (mine):** DR 0.487 (restrictive exhaust, CR_cc 1.4) vs 0.562 (same exhaust, CR_cc 1.5) → the exhaust restriction costs at least 1 − 0.487/0.562 ≈ **13 % of the achievable delivery ratio** *at fixed CR_cc*, before any tuned-pipe benefit.

**(b) Trapping pressure swings → ±11 % trapped mass (±25 % min-to-max) purely from wave phasing.** The 1995 thesis, same engine, same porting, three speeds:

> "a plugging pulse (compression wave) arrives at the exhaust port before the port closes. It acts as a closed port, raising the port pressure to about 30% above the ambient pressure... the cylinder pressure at the commencement of compression reaches 135 kPa." — `1995_MODELLING` L3946–3952

> "At 2800 RPM, however, the plugging pulse arrives at the exhaust port fractionally early and the blocking effect is therefore not as effective as the 3400 RPM situation. The cylinder pressure at trapping is 122 kPa." — L3953–3955

> "At 4400 RPM, the wave phasing is incorrect... The cylinder pressure at trapping is down to 108 kPa, the lowest of the three engine speeds analysed. This results in poor engine performance and high specific fuel consumption." — L3956–3961

**Derived (mine):** 108 → 135 kPa at trapping is a **1.25× variation (≈ ±11 % about the mid-point)** in trapped pressure, hence — at comparable trapping temperature and cylinder volume — ~25 % min-to-max in trapped mass, from wave phasing alone. If your pipe model gets the phasing 15–20° CA wrong, you have a double-digit trapped-mass error that will be mis-attributed to scavenging efficiency.

**(c) Short pipes break the 1-D assumption over a large fraction of their length.** This is the small-engine-specific penalty, from the Suzuki TS125 study:

> "a main reason for the discrepancies shown in traces (a) and (c) of figure 7 is the fact that the initial region (i.e., in which the flow is far from one-dimensional), which is of the order of two to three diameters from the exhaust port, is a significant fraction (20 - 30 percent) of the 0.4 m pipe length." — `1981_Jones_Brown` L989–993

**A large engine's 1.5 m header contains the same 2–3-diameter non-1-D region at 5–10 % of its length; a small engine's 0.4 m header spends 20–30 % of itself outside the model's validity.** That is a structural, scale-dependent error no amount of C_d tuning removes. It is the single best justification for expecting *worse* pressure-trace agreement on a small engine than the 2 % Climent/Ortenzi figures suggest.

### 5.3 Why the error grows with speed on small engines

Both Hooper's and the 1995 thesis's residuals are speed-dependent, and both attribute it to the same mechanism (wave arrival timing) rather than to scavenging:

> "the predicted power output from the model was significantly lower than the actual power output from the test engine of the order of 8.2 to 13.3%, the greatest deviation occurring at 6000 rpm." — `2022_Study_of_the_effects` L1937–1939

> "it is clear that the returning 'suction wave' and the succeeding 'plugging wave' arrived at the exhaust port too early in all cases... leading to the relatively inefficient evacuation of the cylinder during the gas exchange period" — `1995_MODELLING` L5045–5048

> "The exhaust system of a two-stroke engine plays a fundamental role in its performance, where also variations of some millimeters can induce large modifications to the power curve." — `2023_Ortenzi` L1394–1396

⚠️ Ortenzi's "some millimetres" sensitivity is measured on a **racing tuned expansion chamber** (IAME X30, taper + end cone inside the silencer, L1398–1406). **Partly NON-TRANSFERABLE**: on a UAV engine with a stub or box silencer the sensitivity is much weaker — but Blair's box-silencer analysis (L10791–10804) shows that even a *non-tuned* box sets DR, so the exhaust remains a first-order boundary condition, just via restriction/back-pressure rather than wave phasing.

### 5.4 One more reason not to trust the exhaust model blindly: the end-pipe boundary

> "The pipe end boundaries, calculated using the method of characteristics, are a source of inaccuracies, especially in mass conservation during backflow. Such a model was refined by modifying the hypothesis of linear interpolation between the last (or the first) two nodes, reducing the mass conservation error always below 0.5%." — `2023_Ortenzi` L1471–1475

> "Such errors can also be of about 2%, and the worst results can be observed at lower and higher rpms" — L1274–1276

A 2 % *mass* non-conservation at the pipe ends is not a small number when DR is 0.5: it is 4 % of the delivered charge, and it is speed-dependent, so it masquerades as CR_cc error.

---

## 6. MINIMUM DATA SET — what these papers actually used

### 6.1 What each study measured, and what it achieved with it

| Study | Measurement set | Achieved |
|---|---|---|
| `1956_Ku_Trimble` | airflow (ASME orifice), fuel flow, torque, speed, inlet/exhaust pressure & temperature. **No cylinder pressure trace.** SE via skip-cycle (L53–56, 190–239, 369–386) | absolute SE (e) vs scavenge ratio — the cleanest scavenging data in the corpus |
| `1995_MODELLING` | torque, speed, fuel flow + **cylinder, transfer-port and exhaust-port pressure traces at 50 kHz** (L72–77); expansion-chamber geometry varied | <10 % on torque/power/BSFC; "good" pressure-trace agreement (L4999–5036) |
| `2012_Simulation` | **cylinder + intake + exhaust pressure traces** (L713–718); temperatures **estimated** from ideal Otto cycle, 1027 K, because "the in-cylinder temperatures can not be measured experimentally because a temperature sensor is not fast enough" (L727–729, L846–852) | CFD pressure match 90–270° CA (L887–893) |
| `2022_Study_of_the_effects` | full-load power + SFC curve, dynamometer, 3000–6500 rpm; **no Morse test, no pressure trace reported** (L1934–1948, L771–774) | 8.2–13.3 % power error |
| `2023_Ortenzi` | "the measurement on an engine test bed of the power curve, which is the main output of a racing engine" (L1300–1303) | **RMSE 0.5 kW** on two engines |
| `2023_Climent` | instantaneous pressure in air pump, combustion chamber and exhaust manifold; instantaneous volumes; cycle-averaged air mass flow, fuel, throttle, speed, torque (L233–241) | <2 % on pressure during scavenging |
| `2018_Qiao` | in-cylinder pressure at **two** operating points (6000 rpm WOT, 4500 rpm 40 % throttle), plus dyno | "perfect matching" (L426–437) |

### 6.2 The literature's explicit statements of what is required

The 1995 thesis gives the most usefully blunt version — it says that a *constant-parameter* combustion model is adequate but not correct, and names exactly the three measurements that upgrade it:

> "For an accurate simulation, such parameters should be determined experimentally and input to the program. This may include the accurate analysis of the cylinder pressure trace, and the measurement of the trapping efficiency and BSFC." — `1995_MODELLING` L5010–5012

And its input-data taxonomy is a serviceable checklist:

> "1. Geometric data, which include: bore, stroke, connecting rod length, port configuration and timing, model for scavenging, pipe dimensions; 2. Gas flow and operating condition data, including: combustion data, air-fuel ratio, engine speeds, throttle position, coefficient of discharge, initial conditions in cylinder, crankcase and pipes, boundary conditions at cylinder/pipe, crankcase/pipe and atmosphere/pipe interfaces." — L3468–3474

`Ortenzi` states the irreducible-residual argument — you can fit a power curve, but you cannot *identify* the parameters from it:

> "the need of calibration data, without which the results cannot be accurate, is still the main limitation of this study. By using quasi-dimensional codes for in-cylinder processes and one-dimensional codes for manifolds, the discharge coefficients and the scavenging process contain coefficients that need to be determined experimentally." — `2023_Ortenzi` L1487–1491

`Hooper`'s missing item — friction — is explicitly identified as a residual error source:

> "Further work could be conducted to provide a closer correlation of engine friction mean effective pressure within the engine models. Future work to secure data via Morse tests could be incorporated in the WAVE models. This was not possible within the current study. All modelling was therefore conducted with typical values associated with crankcase scavenged two-stroke cycle engines." — `2022_Study_of_the_effects` L1946–1950

> "Unfortunately, Morse test data was unavailable for the engine so values for friction mean effective pressure (pf) typical for crankcase scavenged engines were used in this study" — L771–774

⚠️ Also note Hooper had to borrow combustion parameters:

> "Sher (1984) identified values for b and c of 5 and 3 to 3.2 respectively following combustion rate analysis of the engines in question. In the absence of specific data for the subject engine this prior research has been considered here." — L736–738

### 6.3 The synthesis: minimum set, in three tiers

**Tier 1 — irreducible (without these no calibration is possible):**
1. **Bore, stroke, con-rod length** — geometry.
2. **Port timing and port width/height vs crank angle** — i.e. the flow-area vs CA curve for exhaust and all transfer ports, including corner radii. (Blair L19365–19368; `2022_Study` L613–618 "flow time-area history"; `1995_MODELLING` L3469.)
3. **Crankcase clearance volume (⇒ CR_cc)** — because everything scales off it (Blair L2263–2268; §1.1).
4. **One full-load torque/power curve over the operating speed band.** This alone gave Ortenzi RMSE 0.5 kW (L1300–1331).

**Tier 2 — what converts a fit into a model (and what the 8–13 % errors are made of):**
5. **One in-cylinder pressure trace at a representative speed** — Qiao's two traces were sufficient for them to declare validation (L426–437); `IOP_2024` calibrates on it alone (L108–114). This is the cheapest measurement that constrains combustion phasing and peak pressure.
6. **Exhaust-port pressure trace** — the only way to check wave phasing, and the only way to distinguish a scavenging error from an exhaust error (§1.4, §5.2b). Used by `1995_MODELLING` L5015–5036, `1981_Jones_Brown` L941–943, `2023_Climent` L340–341.
7. **Crankcase (or transfer-duct) pressure trace** — the only direct check on the pump and on Δp across the transfer port (`1995_MODELLING` L3871–3915; for why crankcase pressure is a function of CR_cc, `Blair_Design_Simulation` L1693–1695).
8. **Air mass flow + fuel flow** (⇒ delivery ratio and BSFC). Without DR you cannot place yourself on the SE–DR curve at all, and Ku & Trimble's whole method rests on measuring the pump mass rate (`1956_Ku_Trimble` L53–56). BSFC is what exposes a 5-point trapping-efficiency error (§3.5).
9. **Reed geometry + material properties** (§2.4) — required the moment the engine has a reed.

**Tier 3 — what closes the last few percent:**
10. **C_d maps over (area ratio × pressure ratio) for each port family**, reduced to C_da (Blair L12046–12065, L12112–12113). Highest-value for WOT/high-lift.
11. **Morse test (friction)** — Hooper's own identified gap (L1946–1950).
12. **Trapped-mass or trapping-efficiency anchor** — either a QUB-style single-cycle SE–DR curve for the actual cylinder, or the exhaust-port-closure pressure/temperature route used by Rogowski (`1938_Rogowski` L1212–1226) and by the 1995 study (`1995_MODELLING` L3942–3944: "A higher trapping pressure translates to a higher mass of trapped fresh mixture").
13. **Cylinder-wall / port temperatures.** Note the hard limit: in-cylinder gas temperature is *not measurable* with ordinary transducers (`2012_Simulation` L727–729), so wall/liner temperatures + a heat-transfer model are the practical substitute — and per §7 item 5, that choice alone is worth 12 % IMEP.

**What is explicitly *not* needed (and is often over-collected):** a full 3-D scan and 700 k-cell CFD (`2018_Qiao` L454–461, L559–560) is a design tool, not a calibration requirement; and Qiao's own optimisation could not be bench-validated: "this optimization method suffers from some limitations due to the lack of a practical bench test of the redesigned two-stroke small areoengine" (L1651–1653).

---

## 7. THE RANKED LIST — the 6 things that most improve correlation

*Ranking is for a sub-200 cc crankcase-scavenged carburetted engine running at DR ≈ 0.5 with a stub/box exhaust. The swap condition for a tuned-pipe engine is stated at the end.*

---

### #1 — Get the crankcase pump and the reed right (CR_cc, clearance volume, reed dynamics)

**Why first:** in this architecture the crankcase *is* the scavenging pump, and it is the only element that sets both the mass delivered and the reed's forcing. Its sensitivity is larger than any other single parameter quantified anywhere in this corpus.

**Evidence:**
- CR_cc 1.4→1.5 alone: DR 0.487→0.562 (**+15.4 %**), SE 0.52→0.564, power 4.6→5.4 kW (**+17.4 %**), IMEP 4.18→4.90 bar — `Blair_Basic_Design` L10804–10822.
- Across speed: "+18 %" peak power at 8000 rpm, "20 % drop in power at 9000 rpm" for the lower CR_cc — L10928–10936.
- CR_cc is *geometrically bounded by displacement*: "rather difficult to organize the CRCC value for a 50 cm3 engine cylinder above 1.4 and almost physically impossible to design a 500 cm3 engine cylinder to have a value less than 1.55" — `Blair_Design_Simulation` L2263–2268. So a sub-200 cc model should sit at **1.30–1.50**; measured points span 1.3 (TS125), 1.35 (Blair 125), 1.44 (Ku & Trimble 161 cc), 1.5 (Hooper 171 cc/cyl).
- Reed must be dynamic (§2.1) with forcing tied to CR_cc: Δp = 0.18(CR_cc−1)×101325 — `Blair_Design_Simulation` L23912–23916; and reed timing migrates 36° CA between 5430 and 9150 rpm — L23730–23734.
- Diagnose with p_cc − p_cyl, not with power: Δp collapsing to zero for 20° CA at 4400 rpm — `1995_MODELLING` L3899–3915.

**Actionable:** set clearance volume from a *physical* measurement of the crankcase + transfer-duct + reed-block volume (not back-fitted). Fit CR_cc at mid-speed only, then check it predicts the high-speed end. If you must back-fit CR_cc, you are almost certainly absorbing an exhaust or heat-transfer error (see #2, #5).

---

### #2 — Model the exhaust as the boundary condition it is (restriction for box/stub; wave phasing for tuned)

**Why second:** the exhaust sets the ceiling on delivery ratio and the trapping pressure, and it is the mechanism behind both studies' speed-dependent residuals. For a small engine it is *more* dangerous than for a large one because a bigger fraction of the pipe is outside 1-D validity.

**Evidence:**
- Exhaust restriction named as *the* limiter: "With the restrictive exhaust system having been highlighted as the limiter on engine performance..." and "reduces the strength of the suction to half of the crankcase pumping action which translates into a low delivery ratio of 0.487" — `Blair_Basic_Design` L10813–10815, L10802–10804. **Derived: ≥13 % of achievable DR lost to the restriction at fixed CR_cc.**
- Trapping pressure 135 / 122 / 108 kPa at 3400 / 2800 / 4400 rpm from wave phasing alone — `1995_MODELLING` L3946–3961 (**derived: ~25 % spread in trapped mass**).
- Exhaust-port pressure control is functionally equivalent to changing port timing: "controlling the exhaust pressure at the port has a similar effect to modification of the port timing device" — L1263–1265.
- The 1-D validity penalty for short pipes: non-1-D region "of the order of two to three diameters from the exhaust port, is a significant fraction (20 - 30 percent) of the 0.4 m pipe length" — `1981_Jones_Brown` L989–993.
- Both UAV-class models' residuals peak at high speed and are attributed to wave timing: `2022_Study` L1937–1939 (8.2–13.3 %, worst at 6000 rpm); `1995_MODELLING` L5045–5048 ("arrived at the exhaust port too early in all cases").
- Do not let the end-pipe boundary leak mass: 2 % non-conservation, worst at extreme rpm — `2023_Ortenzi` L1274–1276.

**Actionable:** measure the exhaust-port pressure trace (#6 in §6.3) *before* touching scavenging parameters. Model the actual silencer/box geometry including outlet area ratio (Blair's box: "volume... merely five times larger than the cylinder capacity, and the outlet pipe area from the box is just 40% of that of the exhaust downpipe", L10794–10796). Accept that on a 0.4 m system you will not reach 2 % pressure agreement; target ≤5 %.

---

### #3 — Use the right scavenging-curve *shape*, anchored at the DR the engine actually runs at (≈0.5), not Benson–Brandham at DR ≈ 1

**Why third:** once pump and pipe are right, residual error is dominated by the SE–DR curve — but only if it is evaluated in the right DR window. This is the most common *structural* error in small-engine models and it is invisible on a power curve.

**Evidence:**
- Small loop crankcase engines run at **DR ≈ 0.5**: "a peak delivery ratio, DR, of only 0.53 but with a high trapping efficiency of over 70 %" — `Blair_Design_Simulation` L19800–19806; SE = 0.75 at 9600 rpm (L16677); SE 0.52 / DR 0.487 with a restrictive box (`Blair_Basic_Design` L10804–10812).
- Defensible measured band for this class: **SE ≈ 0.50–0.75**. Values of 0.90–0.97 in the corpus are all *modelled* (`2018_Qiao` L1478–1482; `2012_Simulation` L943–947; `IOP_2024` L173–175) and should not be used as targets.
- SE collapses onto scavenge ratio alone, independent of speed and of inlet/exhaust pressure: `1956_Ku_Trimble` L814–819 — measured on a **161 cc loop crankcase-compressed** engine. This justifies a single SE(DR) curve with no speed term.
- The two-parameter step-change model is experimentally refuted: measured slopes "are all less than −1, which is in conflict with the Benson-Brandham theory... the better the scavenging, the closer the value is to −2" — `1995_MODELLING` L1141–1147. Use a continuous form (Sher/Blair, or `2023_Ortenzi` L218–222's exponential).
- Do **not** trust a 10⁻⁴ fit of a two-parameter model as validation (`2018_Qiao` L1279–1281).
- Cost of a 5-point TE error: bsHC 25→50 g/kWh, fuel consumption 10 % worse — `Blair_Design_Simulation` L25493–25500. **This is why BSFC must be in the calibration set.**

**Actionable:** get one QUB-style SE–DR curve for the actual cylinder geometry if you can (or borrow `LOOPSAW`, L13093–13097, as the small-loop baseline), fit k0/k1/k2 on DR ≤ 0.8, and hold the curve fixed while you tune everything else. Then validate on BSFC as well as power.

---

### #4 — Replace the single C_d with a 2-D map (area ratio × pressure ratio), reduced to C_da

**Why fourth:** C_d is a *multiplier on mass flow*, so its error propagates directly into DR — but its effect is partly confounded with #1 and #2, and the literature disagrees on its priority (Blair downplays it in 1-D; Ortenzi treats it as essential). Hence fourth, not higher.

**Evidence:**
- C_d is characterised by both pressure ratio and area ratio: `Blair_Design_Simulation` L12046–12050.
- Measured exhaust-port C_d at k = 0.127 → 0.824 spans roughly 0.84 → 0.4–0.7, i.e. **~2:1** variation with opening — L12114–12119, axes L12133–12223.
- Using isentropic C_di instead of actual C_da: "the worst case is probably inflow at high area ratios, where it is seen to be 20 %" mass-flow error — L12123–12127.
- Steady-flow C_d **overpredicts** vs unsteady: `2022_Study` L718–720.
- Most published data is unusable: "all of it is in the format of Cdi... that which I have presented is well nigh useless for simulation purposes" — L12106–12111. "it is the complete digitized map... that is needed for each and every pipe discontinuity" — L12112–12113.
- Implementation precedent: 3-D matrices over (area ratio, pressure ratio) — `2023_Ortenzi` L198–212.
- C_d can be reverse-engineered from CFD if no bench data exists — `2023_Climent` L309–311.
- C_d rises ~2.3× within the first 10 % of opening and then falls (poppet-valve data, **NON-TRANSFERABLE architecture**, but the shape warning transfers) — `2017_Kamili_Zahidi` L447–452.

**Actionable:** at minimum, use two C_d values (low-lift vs full-open) per port family and interpolate on area ratio; ideally include the pressure-ratio dimension. Never apply full-open C_d at port cracking. Note **transfer-port C_d is NOT REPORTED** anywhere in this corpus — you will have to measure it or calibrate it against a flow bench, do not assume exhaust-port values transfer.

---

### #5 — Fix the scavenging-period heat transfer (it is worth ~12 % IMEP on its own)

**Why fifth despite being worth 12 %:** it is a *cheap, isolated, one-parameter* fix once the gas-exchange model is sane, and it is invisible if you only match peak pressure. It must not be used to compensate for #1–#4.

**Evidence (the cleanest single-variable error isolation in the corpus):**
- "The heat transfer coefficient during scavenging can be as low as 200 W/m²K, leading to a peak deviation of 85 °C in temperature predictions and up to 12 % in deviation for trapped mass predictions. On the other hand, the proposed heat transfer model calculates a peak coefficient of 800 W/m²K during scavenging, leading to a peak temperature deviation of 25 °C along with almost negligible error in trapped mass predictions." — `2023_Climent` L969–977
- "a difference in trapped mass of up to 6 % at the exhaust port closing was observed... This translated to differences of up to 12 % in the IMEP of the engine." — L979–983
- Calibration sensitivity: changing coefficient b by ±50 % moves trapped mass 6.5 % — L933–942.
- The structural reason it is hard: in-cylinder temperature is not measurable — "a temperature sensor is not fast enough to accurately capture the in-cylinder temperature along the whole cycle" — `2012_Simulation` L727–729; temperatures must be estimated (1027 K from ideal Otto, L846–852).
- Note the direction: state-of-the-art (Anand/Hohenberg/Woschni) all under-predict h during scavenging and hence under-predict trapped mass — so a model that matches power while using Woschni is probably compensating elsewhere.

⚠️ `2023_Climent` is **uniflow/opposed-scavenged with a rod-port air pump** (L223–229) — **the 12 % number is NOT directly transferable** to a Schnürle crankcase-scavenged cylinder, where the transfer-port jet structure and wall wetting differ. Treat 12 % as the right order of magnitude and the *mechanism* (h during scavenging is 4× higher than standard correlations give) as transferable.

**Actionable:** do not tune heat transfer to fix a delivery-ratio error. Calibrate h during the scavenging window against a wall/liner thermocouple and the trapped-mass estimate from exhaust-port-closure pressure (`1938_Rogowski` L1212–1226; `1995_MODELLING` L3942–3944), and verify that IMEP moves by the expected ~12 % when you switch correlations.

---

### #6 — Calibrate combustion (Vibe) and friction with engine-specific data, not defaults

**Why last but not optional:** these are the residual 8–13 %. They are cheap to fix *if* you have a pressure trace and a Morse test; without them they silently absorb all the errors above.

**Evidence:**
- Hooper's residual is explicitly attributed to friction: "the predicted power output from the model was significantly lower than the actual power output... of the order of 8.2 to 13.3 %" (L1937–1939) and "Further work could be conducted to provide a closer correlation of engine friction mean effective pressure... Morse tests could be incorporated... This was not possible within the current study" (L1946–1950). Note the *sign*: model **under**-predicts → friction over-specified or trapped mass under-predicted.
- Combustion parameters were borrowed from a different engine in the absence of data (Sher b = 5, c = 3–3.2) — L736–738.
- The 1995 thesis shows the cheapest adequate compromise: constant Blair-suggested combustion parameters gave <10 % on power/BSFC across 2200–4400 rpm, but "For an accurate simulation, such parameters should be determined experimentally... This may include the accurate analysis of the cylinder pressure trace, and the measurement of the trapping efficiency and BSFC" — L5005–5012.
- Measured burn-duration anchors for this class: 65 cc chainsaw at 9600 rpm, SE = 0.75, burn period 64° CA, 50 % at 10° atdc, Vibe a = 5, m = 1.05 — `Blair_Design_Simulation` L16699–16704. 125 GP at 10350 rpm: 41° CA, 50 % at 9° atdc, a = 5.25, m = 1.25 — L16750–16755.
- Typical two-stroke PMEP is small and CR_cc-dependent: PMEP 0.21 bar at CR_cc 1.4 → 0.29 bar at 1.5 — `Blair_Basic_Design` L10821–10822. Throttling a crankcase-scavenged engine *reduces* PMEP, opposite to a four-stroke (L10731–10743) — do not use four-stroke friction/pumping models.

**Actionable:** measure a Morse test (or at minimum a motoring curve) to set FMEP; fit Vibe a/m and burn duration to the in-cylinder pressure trace at one speed, then check it holds across the band; target the 41–64° CA burn-duration range above.

---

### Swap condition

If the engine has a **tuned expansion chamber** (kart/racing geometry, taper + end cone), move **#2 to first**. There, exhaust phasing is not a boundary condition but the dominant forcing term: "variations of some millimeters can induce large modifications to the power curve" (`2023_Ortenzi` L1394–1396), and the exhaust length alone shifts peak power in rpm (L1408–1410). The pipe then controls trapping pressure directly and #1's CR_cc effect becomes second-order by comparison.

Conversely, if the engine is **throttled at part load** (a UAV at cruise), add a caveat to #1 and #4: the Qiao simplification η_S ≈ η_C = λ_S·η_T (`2018_Qiao` L196–202) is invalid, and the carburettor venturi is a *fixed* restriction — Blair had to model a diaphragm carburettor at wide-open throttle as "3/4 throttle" because of "a restriction ratio of 25 % to the carburetor flow diameter, even when the butterfly throttle valve is wide open" (`Blair_Basic_Design` L10785–10790). Getting that one number wrong mis-scales every part-load point.

---

## 8. Non-transferable sources — explicit register

| Source | Architecture | Why not transferable |
|---|---|---|
| `1938_Rogowski` | 1563 cc loop, separately blown, 1800 rpm | 10× displacement, external compressor (L242–248), not crankcase-compressed. **Only** the SE *measurement method* (66.7 % at SR 1.4, L573–599) and the exhaust-closure-pressure trapped-mass method (L1212–1226) are usable. |
| `1942_Schweitzer` | 17 L crankcase-scavenged **diesel**, 400 rpm | Scale and speed differ by an order of magnitude. Usable only as the tracer-gas method and as the surge-tank warning (L1249–1264). |
| `2016_Evaluations_of_Scavenge_Port_Designs` | **boosted** uniflow, DI | Forced scavenging, uni­flow ports, boost pressure. Nothing about crankcase pumping transfers. |
| `2019_Foteinos` | large **marine** uniflow diesel (50 cm bore) | 3-zone model for 50 cm bore; scavenging is uniflow with swirl, not Schnürle. |
| `Frontiers_2022_uniflow_scavenging` | uniflow | As above. |
| `2023_Climent` | uniflow/opposed, separate **air pump**, rod-mounted intake ports | Reed+plenum+air-pump architecture, no crankcase compression. Heat transfer and C_d workflow transferable; the 12 % number is indicative only. |
| `2018_Development_of_an_extended_mean_value` | large **marine** two-stroke, turbocharged | Mean-value model for a marine engine (L5–18); no relevance to gas exchange of a small crankcase-scavenged unit. |
| `2018_Jia_Free_Piston` | **free-piston** linear generator | No crankshaft ⇒ no crankcase pump at all. |
| `2017_Kamili_Zahidi` | **poppet-valve** two-stroke, 65 cc | Valve lift, not piston porting. C_d-vs-lift *shape* is instructive; absolute values are not transferable. |
| `2023_Shao` | small (**202 cc/cyl**) **cross**-scavenged HFDI, CFD only | Cross-scavenging with a deflector-less HFDI layout; not Schnürle, and CFD rather than measurement. |
| `IOP_2024_scavenge_params` | "SI two-stroke diesel", unknown displacement, 1-D only | SE ≈ 95–97 % is inconsistent with every measured value in §3; use only the CR_cc *trend*. |
| `2025_Improving_the_energy_efficiency` | crankcase-scavenged UAV, **EFI control** | Useful only for the carburettor→EFI delta (BSFC 370→300 g/kWh, L183–184) — i.e. a reminder that the fuelling system, not the gas-exchange model, sets the carburetted BSFC floor. |

---

## 9. The five sentences to remember

1. **CR_cc is bounded by geometry to 1.3–1.5 for <200 cc** (Blair L2263–2268; measured 1.3/1.35/1.44/1.5), and a 0.1 error in it is worth ~17 % power (`Blair_Basic_Design` L10804–10822).
2. **A static reed is outside the state of the art** — all four modelling papers use a dynamic petal, and the reed's closing point migrates 36° CA between 5430 and 9150 rpm (Blair L23730–23734). The *magnitude* of the static-reed error is **NOT REPORTED**; the timing migration is the mechanism.
3. **Small loop crankcase engines run at DR ≈ 0.5 with SE ≈ 0.50–0.75** (`Blair_Design_Simulation` L19800–19806, L16677; `Blair_Basic_Design` L10804–10812). Any model returning SE > 0.9 for this class is wrong.
4. **C_d is a 2-D map, ~2:1 across the opening range, and using the isentropic form costs up to 20 % mass flow** (Blair L12114–12127) — but most published tables are "well nigh useless" for simulation (L12111).
5. **The literature never isolates the exhaust contribution to error** — **NOT REPORTED** — but the three indirect bounds (≥13 % of DR lost to restriction; ~25 % trapped-mass spread from phasing; 20–30 % of a short pipe outside 1-D validity) make it the second-largest lever after the pump.
