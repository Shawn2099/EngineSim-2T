# Extraction of model structure and equations from four local papers

Scope: what model structure and which equations each paper actually prints, with line numbers into
`references/text/*.txt`. Target application: a crank-angle 0-D model of a **132 cm³ crankcase-scavenged,
loop-scavenged, SI two-stroke**.

Convention in this document: `[L123]` = line number in the corresponding `.txt` file. "NOT STATED" means
the paper does not print it (as opposed to "not applicable"). Where OCR has destroyed an equation, the
raw OCR is quoted and the reconstruction is flagged as such.

Summary of what each source actually is:

| # | Paper | Class | Engine | Relevance to us |
|---|-------|-------|--------|-----------------|
| A | Theotokatos et al. 2018 | 0-D crank-angle + mean-value, Simulink | MAN 7K98MC, 7-cyl, 980 mm bore, 94 rpm, uniflow, turbocharged | Best-documented **validation accuracy table**; the 0-D cylinder is 1-zone closed / 2-zone scavenging |
| B | Zhang 1995 (MEng thesis) | 1-D MOC pipes + **0-D cylinder & crankcase control volumes** | Yamaha MT-110, **crankcase-compressed, piston-ported, loop-scavenged**, expansion chamber, 2200–4400 rpm | **Same engine architecture as ours.** Gives the open-system cylinder energy equation, Cd, effective port area, CFL stepping |
| C | Lamas & Rodríguez 2012 | **3-D CFD** (Fluent), not 0-D | 127.3 cm³ loop-scavenged two-stroke, 53.8 × 56 mm, CR 9.86, 6000 rpm | Geometry/displacement nearly identical to ours, but method is not adoptable for 0-D; useful only as SE sanity check |
| D | Liu et al. 2022 (Frontiers) | 0-D **multi-stage algebraic** | 6EX340EF and RTX-8, large uniflow marine diesels | Gives the stage decomposition (blowdown→PD→DM→PM) we can use to structure the scavenging event |

---

# Paper A — Theotokatos, Guan, Chen, Lazakis (2018)
*Development of an extended mean value engine model for predicting the marine two-stroke engine
operation at varying settings*

## A.1 Scavenging model structure

The paper contains **two different cylinder models**; only one of them is a crank-angle 0-D model.

- Closed cycle (compression–combustion–expansion): **one zone**.
- Scavenging (open cycle): **two zones**.

> "The difference between the zero-dimensional model and MVEM lies in the cylinder block. The
> zero-dimensional model cylinder block is more comprehensive as it simulates the closed cycle process
> (compression, combustion and expansion) by using a one-zone approach, and the scavenging process by
> employing a two-zone approach [30]." [L344–L350]

Zone definition (the only definition given):

> "The two zone scavenging model (the first zone includes air whereas the second zone includes exhaust
> gas) employs six first-order differential equations for calculating the temperature and the mass for
> each zone, the burnt fuel fraction of the second zone and the cylinder pressure in conjunction with
> the algebraic equations for calculating the working medium properties." [L379–L386]

So the state vector during scavenging is exactly six ODEs:
`T_1, m_1, T_2, m_2, x_b,2, p` — i.e. **pressure is integrated, not obtained from the ideal-gas law**.
For the one-zone closed period:

> "the one zone model employs three first-order differential equations for calculating the temperature,
> the mass and the burnt fuel fraction along with the ideal gas equation for calculating the pressure"
> [L374–L379]

Mass/energy basis:

> "the mass and energy conservation laws as well as the ideal gas state equation in each considered
> control volume zone are used" [L368–L372]

**NOT STATED:** the six two-zone equations themselves. The paper cites its own earlier paper (Guan et
al., *Energies* 2015;8:5738–5764, its ref [30] [L1703–L1704]) for the detail and does not reproduce them.
Also **NOT STATED:** how the zones exchange mass (whether air leaving zone 1 to the exhaust is pure air,
whether zone 2 entrains zone 1), how the zones' volumes are assigned, and how the two zones are
homogenised at EPC/EVC back to the one-zone closed model.

**SE/TE computation: NOT STATED.** Neither scavenging efficiency nor trapping efficiency appears in the
paper's nomenclature [L1769–L1925]; the paper reports only integral performance (power, BSFC, receiver
states, P_max, P_comp). This is a real gap for us: A is not a usable source for SE/TE.

## A.2 Cylinder gas exchange

For the 0-D model the port/valve **flow areas are inputs**, not modelled:

> "The zero-dimensional model cylinder block uses as input the scavenging ports and exhaust valves
> profiles as well as the fuel variable injection timing." [L350–L354]

For the MVEM the cylinder is flow-element with **two consecutive orifices**:

> "The air mass flow rate entering the cylinder is calculated considering the equivalent of two
> consecutive orifices, each one representing the cylinders scavenging ports and exhaust valve. The
> mass flow rate of the exhaust gas, exiting the engine cylinders, is estimated by using the continuity
> equation adding the mass flow rates of the air entering the engine cylinders and the injected fuel."
> [L422–L431]

**NOT STATED:** the orifice equation itself, the discharge coefficient (no value anywhere in the paper),
how the two areas are combined (series/minimum/sum), and whether sonic conditions are checked.

## A.3 Combustion model

> "The Woschni-Anisits combustion model [45] is used for describing the combustion process. This model
> employs a simple Wiebe function, the shape factor and the combustion duration of which are calculated
> by using a reference point respective values along with the combustion air/fuel equivalence ratio and
> engine speed. In this respect, the model constants need to be calibrated for one operating point as
> the model adjusts the model parameters in other operating points." [L388–L397]

Table 1 "The combustion model constants in zero-dimensional model" [L2088–L2098], as printed:

| symbol | value |
|---|---|
| a | 10 |
| m | 0.93 |
| Combustion duration (°CA) | 47 |
| Combustion air to fuel equivalence ratio | 2.13 |
| Reference engine speed (r/min) | 85.4 |

(85.4 r/min is printed as-is; the engine's MCR speed is 94 r/min [L2109–L2110], so this table entry looks
like a typo or an off-design reference point.)

**The Wiebe equation is NOT PRINTED.** The exponent convention (`t^m` vs `t^(m+1)`) is therefore **NOT
STATED** in this paper. The form must be taken from the cited source, Merker/Schwarz/Stiesch/Otto
*Simulating Combustion* (its ref [45], [L1742–L1743]), which is not in our file set. Note only that
`a = 10, m = 0.93` is a **large two-stroke marine diesel** calibration (a ≈ 10 saturates the burn at
Δθ_c), *not* an SI calibration.

## A.4 Heat transfer

> "The Woschni model [46] is employed for calculating the cylinder gas to wall heat transfer coefficient
> with the default value being as proposed for large two-stroke engine." [L396–L399]

Ref [46] = Woschni, SAE 670931 [L1744–L1745]. **NOT STATED:** the correlation, the constants C1, C2, the
characteristic velocity, the reference state, or the wall areas/temperatures. "Default value ... for
large two-stroke engine" is unquantified.

## A.5 Solution method

MATLAB/Simulink, modular blocks, no numerical details:

> "Both the zero-dimensional and the mean value engine models were developed in MATLAB/Simulink
> environment following the same modular approach" [L31–L34]

**NOT STATED:** integrator, step size, convergence criteria, number of cycles to steady state. Only
execution time is quantified: the extended MVEM "requires around double execution time in comparison
with the original MVEM ... whereas it is still approximately 7 times faster than real time and 570 times
faster than the zero-dimensional model" [L1482–L1490].

## A.6 Validation — **this is the paper's main value**

Test case: MAN Diesel & Turbo 7K98MC shop trials at 25/50/75/100 % MCR [L510–L532, L558–L561].
Engine data Table 2 [L2100–L2126]: bore 980 mm, stroke 2660 mm, 7 cyl, 40055 kW @ 94 r/min, BMEP 18.2 bar,
CR 17.5, con-rod 3220 mm, EVO 74°CA bBDC, EVC 87°CA aBDC, SPO/SPC ±42°CA, 3 turbochargers.

Table 3 "Percentage errors of the predicted parameters against experimental data from shop trials"
[L2128–L2232] — **0-D model**, at 100 / 75 / 50 / 25 % load:

| Parameter | 100 | 75 | 50 | 25 |
|---|---|---|---|---|
| Brake power | 1.02 | 1.01 | 0.99 | 0.92 |
| BSFC | −0.16 | −0.55 | 0.08 | −0.18 |
| Turbocharger speed | −0.03 | 0.41 | 1.47 | 4.52 |
| Scavenging air receiver pressure | −1.39 | −0.40 | 0.89 | 0.54 |
| Exhaust gas receiver pressure | 0.20 | 2.23 | 4.11 | 3.13 |
| Scavenging air receiver temperature | 0.72 | 0.39 | 0.45 | 0.24 |
| Exhaust gas receiver temperature | −0.46 | −0.48 | −1.08 | 0.37 |
| Exhaust gas temp. after turbocharger | 2.52 | 1.18 | 0.99 | 3.25 |
| **Maximum cylinder pressure** | **−0.71** | **−0.07** | **1.46** | **0.59** |
| **Cylinder compression pressure** | **−0.81** | **0.23** | **0.86** | **1.16** |

(MVEM column follows at [L2148–L2232]; MVEM cannot produce the two cylinder-pressure rows.)

Conclusion drawn:

> "It can be inferred that both models predictions exhibit sufficient accuracy for the high engine load
> region and the engine operation at low loads (down to 25% load)." [L564–L568]

Model-to-model (extended MVEM vs 0-D, 32 settings combinations):

> "The relative errors between the extended MVEM and zero-dimensional model are in the range of 0.5 to
> 1.0% for the BSFC and 0.05 to 1.03% for the other parameters" [L1364–L1366]
> "the deviations of the main engine parameters in the most cases are less than 1% and the highest
> deviation is 2.1%" [L1399–L1402]

Transient, extended MVEM vs 0-D: max error 0.81 % (SOI ramp) [L1437–L1438], 0.92 % (turbine area)
[L1455–L1456], 0.75 % (exhaust gas bypass) [L1468].

**What this tells us about achievable 0-D accuracy:** on a large slow-speed engine with well-known
geometry and measured boundary conditions, a 0-D model gives ≈1 % on power and BSFC, ≈0.5–1.5 % on
P_max/P_comp, and 2–4.5 % on the gas-path states at part load. Note this is *after calibration of the
combustion constants at one operating point* [L394–L397].

---

# Paper B — Zhang (1995), *Modelling the scavenging process in a two-stroke I.C. engine*

MEng thesis, Victoria University of Technology. Engine: Yamaha MT-110, **crankcase-compressed,
piston port-timed, loop-scavenged, expansion chamber** [L60–L62, L4259]. This is the closest structural
match to our engine among the four.

## B.1 Scavenging model structure

Not a zoned in-cylinder model. The **cylinder is one 0-D control volume (CV1)** and the **crankcase is a
second 0-D control volume (CV2)**, both open systems coupled to 1-D MOC pipes:

> "Control volumes 1 and 2 are connected to each other through a transfer pipe during the scavenging
> period." [L2835–L2836]
> "The above analysis is almost exactly applicable to the second control volume, crankcase."
> [L3195–L3196]

Zoning of the *charge* is not resolved in space or in separate gas zones; the scavenging quality is
imposed through an empirical η_s–Λ characteristic from the Blair single-cycle method, selected by
"scavenging type":

> "The information of the in-cylinder scavenging quality (scavenging quality without the influence of
> wave action) is obtained from the 'single cycle test', as suggested by Blair [8]. As first hand
> information of this kind was not readily available, the selection of the scavenging type was based on
> the results from the single cycle test published in [8]. Because the test engine cylinder has a
> two-scavenging port layout, YAM6 scavenging type was chosen for the computer simulation." [L3563–L3568]

and it is held constant over speed:

> "The selected scavenging type was used through the entire speed range ... the scavenging efficiency -
> scavenging ratio characteristic does not depend on engine speed very much but on the engine design.
> The primary parameter which affects the scavenging efficiency is the scavenging ratio" [L3572–L3578]

Definitions used (SAE J604) — quoted as printed, equations 2.1–2.4 are OCR-destroyed [L720–L743]:
η_s = m_a/(m_a+m_b) (fresh charge trapped / total trapped), η_t = m_a/m_i, η_c = m_a/(ρ_a V_cyl),
Λ_d = m_i/(ρ_a V_s). Scavenging ratio Λ_s is the volumetric ratio used in the η_s–Λ_s curve.

**NOT STATED:** the fitted η_s(Λ_s) expression actually coded (Blair's continuous displacement/mixing/
short-circuiting model is *described* at [L1158–L1189] but the code's two tuning parameters and the
YAM6 curve values are not printed). **NOT STATED:** any zone temperatures during scavenging — a single
cylinder temperature is carried.

## B.2 Cylinder gas exchange

Flow across the port is an orifice with a **constant** discharge coefficient:

> "The flow through the pipe boundaries is treated as flow through an orifice. The coefficient of
> discharge C_D is conventionally defined as: real mass flow / theoretical mass flow. Annand [54] has
> demonstrated that the coefficient of discharge C_D is a function of port opening fraction and pressure
> ratio. However in the current study, C_D is simplified as much as possible by regarding it as constant
> for all the pipe boundaries considered, following Blair in [8]." [L3506–L3516]

Table 4.1 "Coefficient of discharge at engine port" [L3517–L3529]:

| Port | Normal flow | Reverse flow |
|---|---|---|
| Exhaust | 0.75 | 0.75 |
| Transfer | 0.75 | 0.75 |
| Inlet | 0.75 | 0.90 |

Effective area is a **projected** area (not the geometric window), reduced for corner radii:

> "The flow through the port is one-dimensional uniform and plug flow. The effective port area is
> defined as the area which is perpendicular to the flow jets. It is the product of the effective port
> height h and the effective port width l, which are the projection of the geometric port height h_0 and
> width l_0 in the assumed flow direction, less the area of the rounded corners:
> h = V o s e«* / 1 " 'oco»ei» / A_w = fc/-0.858r^2" [L3533–L3541]

(OCR-garbled. Reconstruction, flagged: `h = h_0·cos θ_ax`, `l = l_0·cos θ_ta`,
`A_port = h·l − 0.858 r²`, with θ_ax axial and θ_ta tangential port inclination, r corner radius —
the corner term 0.858 r² is the standard two-corner circular-segment loss. Verify against the printed
page before hard-coding.)

Mass increments are orifice fluxes with the *stagnation* cylinder state as upstream and the pipe
*reference* state as downstream. Outflow [L3074–L3086]:

> "Δm_e^(1-2) = C_D · ρ_e · u_e · A_e · Δt ... In the last equation, C_D is the coefficient of discharge
> and A_e is the exhaust pipe area at the port."

and inflow [L3128–L3157]: `Δm_tr = C_D · ρ_0,tr · u_tr · A_tr · Δt` (eq. 3.115), with
`ρ_0,tr = p_0/(R·T_0,tr)`.

The whole point of the thesis is that the *upstream/downstream* states are not reservoir states but the
**Riemann variables at the first pipe node**, i.e. `u` and `T` come from the wave solution, and there is
a deliberate temperature discontinuity at the interface:

> "There is thus a discontinuity in the reference temperature between the port/pipe interface (first node
> in the pipe) and the rest of the pipe. For a realistic mass flow estimation for cylinder (or crankcase)
> inflow and outflow, in this study, T_0epipe is kept constant but T_0e^(2) is allowed to change as the
> cylinder state changes." [L3041–L3049]

**NOT STATED:** the subsonic/sonic branch logic and the critical-pressure-ratio test. The flow is always
computed from the local wave-determined velocity, so no choking test appears.

## B.3 Combustion model

> "The combustion process was simplified as a heat addition process in a closed thermodynamic system. A
> simple combustion model adequate for engine simulation is the heat release model which correlates the
> heat release rate and the crank angle. The model was deduced from the cylinder pressure trace analysis
> and was used by Blair[8]. Corrections and modifications were made to Blair's model, because part of the
> assumed combustion profile discussed by Blair [8] was omitted from the code. This meant that 17% of the
> total heat input had not been taken into account ... Blair's code was thus modified to include the
> missing profile and introduce a temperature dependent specific heat ratio." [L3603–L3615]

Calibration philosophy:

> "The value of the model parameters (polytropic index, combustion efficiency, trapped air-fuel ratio etc.)
> were those suggested by Blair et al [49][56]. These parameters are assumed constant for all speeds in
> the calculations." [L5006–L5009]

**NOT STATED:** the heat-release-rate function itself (Blair's is a tabulated/polynomial burn profile, not
a Vibe), **no Wiebe form, no a/m/Δθ_c values, no exponent convention.** If we want a Wiebe, this paper
gives us nothing.

## B.4 Heat transfer

Annand is cited, then switched off:

> "ΔQ^(1-2) is zero when the system is adiabatic. It may be specified further by an equation proposed by
> Annand [53]. As the heat transfer during the gas exchange period is small compared with the combustion
> period, it is assumed that ΔQ^(1-2) = 0 in this study." [L2921–L2926]

**NOT STATED:** Annand's constants, the closed-period heat transfer formulation, wall temperatures. The
gas-exchange model is effectively **adiabatic**.

## B.5 Solution method

Time marching in the MOC with a CFL-limited step and a safety factor:

> "To ensure numerical stability, the dimensionless time step predicted by the Courant-Friedrichs-Lewy
> (CFL) stability criterion ... was multiplied by a factor less than one, in this study 0.95. This
> ensures numerical stability. The proportionally related quantities, the crank angle step and the
> dimensional time step were multiplied by the same factor." [L3586–L3590]

CFL step: slopes of C+ / C− characteristics (eqs. 3.66–3.67) → take the absolute minimum slope over all
nodes of all pipes → `ΔZ = (dZ/dX)_min · ΔX` (eq. 3.68) [L2408–L2446]. Pipe mesh: "a mesh length of
10 mm, rather than 30 mm as recommend by Blair [8] was selected" [L3591–L3599].

Cylinder state is **implicit in the port boundary** and solved by fixed-point iteration on p_cv1:

> "p_cv1^(2), T_cv1^(2) and λ are interconnected and cannot be solved for directly. Iteration is used to
> solve for p_cv1^(2), T_cv1^(2) and λ." [L3348–L3357]
> "... 8 If p_cv1^(2) between two successive iterations falls below the specified tolerance, stop
> iteration or 9 Repeat steps 5-8." [L3379–L3382]

(Convergence tolerance value: **NOT STATED**.) Cycle handling:

> "the calculation needs resetting at the crank angle of the exhaust port open (EPO) after a cycle, that
> is, each cycle starts and ends at the same position. Control points are added across the engine model to
> examine the mass conservation which reflects the quality of the numerical solution." [L596–L600]

Mass-balance check: six control points; per-pipe imbalance `ε = Σin − Σout → 0`, and
"m_delivery = m_scavenging = m_exhaust" across ports over a cycle [L3387–L3450]. Blow-up/steady state is
therefore judged by **cycle-closure of mass**, not by an iterative residual. Marching steps: 100 rpm over
2200–4400 rpm [L3616–L3620].

Integration inside the pipe: trapezoidal rule along characteristics [L3593–L3595]; both Riemann variables
are advanced with a predictor-corrector recommended as future work [L5781–L5783].

## B.6 Validation

Measured on a dynamometer rig, 5 exhaust mid-section lengths (L3 = 240, 330, 400, 480, 550 mm), 2200–4400 rpm:

> "The agreement between the measurements and calculations was good, particularly at the medium and higher
> speeds. At lower speeds, the agreement deteriorated slightly, however the maximum discrepancy was still
> below 10%." [L4998–L5001]

Pressure traces at cylinder, transfer port and exhaust port:

> "The agreement between the measured and calculated pressure traces was good." [L5034–L5036]
(no percentage given)

**NOT STATED:** any tabulated % error per parameter, and no direct comparison of predicted vs measured
**η_s or η_c** — those are only plotted as predictions (Fig. 4.11/4.12, [L4004–L4058]). The single-cycle rig
(Appendix A, [L5931–L5967]) is described as the source of the η_s–Λ_s characteristic, but no predicted-vs-
measured SE error is reported.

This is the honest accuracy figure for a small crankcase-scavenged two-stroke: **< 10 % on torque/power
across the whole speed range, including wave-tuning effects.**

---

# Paper C — Lamas Galdo & Rodríguez Vidal (2012), *Simulation of the scavenging process in two-stroke engines*

This is a **3-D CFD book chapter**, not a 0-D model. It is in the set only as a reference/sanity check.

## C.1 "Scavenging model structure"

No zones. The cylinder is a 3-D finite-volume domain with **two species** (air, burnt gas) and a transport
equation for the air mass fraction:

> "as there are two components (air and burnt gases), one more equation must be added to characterize the
> propagating interface" [L152–L155]
> "∂(ρY_air)/∂t + ∇·(ρY_air V) = 0  (5) ... The mass fraction of the burnt gases, Y_gas, is given by the
> restriction that the total mass fraction must sum to unity: Y_gas = 1 − Y_air  (6)" [L274–L306]

SE is obtained by post-processing the field (see C.6). RANS k-ε / RNG k-ε turbulence [L307–L322].

## C.2 Cylinder gas exchange

Ports are meshed as part of the domain (scavenge port, exhaust port, cylinder, head [L766–L769]); the
boundary condition at the inlet/outlet is a **measured instantaneous pressure**:

> "Concerning the pressures, the experimentally values mentioned in the beginning of section 4 were
> employed as initial and boundary conditions." [L845–L847]

**NOT STATED:** any orifice equation, effective area, or Cd — the ports are geometrically resolved.

## C.3 Combustion model

Explicitly excluded: "As only the scavenging process and not the combustion is treated on this chapter,
only two components need to be computed" [L270–L272]. **NOT STATED / N.A.**

## C.4 Heat transfer model

No correlation — the energy equation is solved with a turbulent Prandtl number:

> "turbulent heat transport can be modeled using the concept of Reynolds' analogy ... the energy equation
> is thus given by the following: ... C_p[∂(ρT)/∂t + ∂(ρu_i T)/∂x_i] = ... + (μ_t/Pr_t)∂T/∂x_j" [L590–L657]

**NOT STATED:** any Woschni/Annand constants, wall temperature (not reported).

## C.5 Solution method

> "the software ANSYS Fluent 6.3 was employed. This is based on the finite volume method. Concerning the
> time discretization, an implicit method was chosen, with a constant timestep equivalent to 0.1º crankshaft
> angle. ... the PISO algorithm was employed ... A second order scheme was chosen for discretization of the
> continuity, momentum, energy and mass fraction equations." [L867–L875]

Grid/time-step independence verified by refinement [L876–L879]. **Convergence criteria: NOT STATED**
(per-timestep residuals not given).

## C.6 Validation

Engine: 127.3 cm³, 53.8 mm bore × 56 mm stroke, con-rod 110 mm, CR 9.86, loop scavenge, direct injection,
7.5 kW @ 6000 rpm, Table 1 [L690–L712] — i.e. **essentially our engine class**.

> "the numerical and experimental results are shown in Fig. 12. Note that an acceptable concordance is
> obtained between CFD and experimental results." [L888–L893]

Validated interval 90°–270° CA only, in-cylinder pressure only. **No % error is quoted** (the figure shows
the comparison; the text does not quantify it). **NOT STATED:** torque, BSFC, SE comparison.

One useful number — the scavenging efficiency for this engine at rated conditions:

> "it was quantified by means of the scavenging efficiency ... Ec. (13), and its value was 82.5 for the
> parameters studied.  η = mass of delivered air retained / mass of mixture in the cylinder" [L943–L955]

So **SE ≈ 0.825** is a realistic target for a 127 cm³ loop-scavenged engine — a very good plausibility
check for our SE output.

Also relevant to model selection:

> "a 3D CFD model is very tedious due to the large computational resources. Besides, the moving mesh required
> to simulate the movement of the piston is too computationally expensive to solve." [L1058–L1060]

---

# Paper D — Liu, Han, Liu, Ma (2022), *Investigation of the scavenging process in two-stroke uniflow scavenging marine engines by a real-time multi-stage model*

0-D, single-zone in space, **multi-stage in time**; algebraic (no differential equations at all).

## D.1 Scavenging model structure

> "In the cylinder zone, the complex gas motion is ideally divided to four stages: exhaust gas blowdown,
> perfect displacement, displacement-mixing, and perfect mixing. The duration of each stage is determined by
> the engine design and control parameters." [L18–L21]

> "In the novel multi-stage model, the four stages are assumed: blowdown, perfect-displacement (PD),
> displacement-mixing (DM), and perfect-mixing (PM) in Figure 1. The blowdown stage begins with the exhaust
> valves opening (EVO) (A) and ends with the scavenging ports opening (SPO) (B) ... The PD stage is from
> point B to point C and the DM stage is from point C to point D, where the point C is used to adjust the
> ratio of PD and DM ... The PD stage begins with the scavenging port closing (SPC) (D) and ends with the
> exhaust valve closing (EVC) (E), and there is only final mixture two in the cylinder at this stage."
> [L269–L281]

(The last sentence is a typo in the paper — it describes stage IV/PM, D→E, not PD.)

Two mass inventories are tracked throughout: fresh air `m_a` and residual `m_r`; these are not
thermally separate zones but are mixed in a prescribed sequence. **The key simplification:**

> "the pressure of the residual exhaust gas and fresh air in the cylinder are assumed to be equal with an
> average manifold pressure" [L384–L386]

with `P_B = P_C = P_D = P_p`, "P_p, the average pressure of the scavenge ports and the exhaust pipe"
[L350–L352]. So the whole scavenging event runs at **constant cylinder pressure**; only stage I and IV
change pressure.

**Stage I — blowdown (A→B), isentropic expansion:**

```
T_rB = T_rA · (P_B/P_A)^((κ−1)/κ)                                  (1)   [L367–L371]
m_rA = P_A·V_A/(R·T_A)                                             (2)   [L372–L374]
m_rB = P_B·V_B/(R·T_B)                                             (3)   [L375–L377]
```
Assumptions [L378–L382]: constant κ for all gases; **adiabatic wall**; ideal gas, constant R.

**Stage II — perfect displacement (B→C):**

```
T_rC = T_rB                                                         (4)   [L393–L394]
m_aC = ṁ_in·(t_C − t_B)                                             (5)   [L395–L396]
m_rC = m_rB − (T_aC/T_rC)·m_aC                                      (6)   [L397–L399]
m_mC = m_rC + m_aC                                                  (7)   [L400–L401]
T_mC = (m_rC/(m_rC+m_aC))·T_rC + (m_aC/(m_rC+m_aC))·T_aC            (8)   [L402–L407]
```
Eq. (6) is the displacement relation: the burnt mass pushed out equals the incoming air mass scaled by the
density ratio. Assumptions [L408–L417]: constant fresh-air T and ρ in the cylinder; constant exhaust T;
**constant cylinder pressure**; "The entering fresh air pushes out the exhaust gas by a perfect displacement
mechanism"; "There is no mass or heat that is allowed to cross the interface between the two gases";
adiabatic wall.

**Stage III — displacement + mixing simultaneously (C→D):**

```
T_mD = T_mC                                                         (9)    [L429–L430]
T_aD = T_aC                                                         (10)   [L431–L432]
m_aCD = ṁ_in·(t_D − t_C)                                            (11)   [L433–L434]
m_mD = P_D·V_D/(R·T_mD) − m_aCD                                     (12)   [L435–L439]
m_maD = (m_aC/m_C)·m_mD                                             (13)   [L440–L442]
m_aD = m_aCD + m_maD                                                (14)   [L443–L444]
m_D  = m_aCD + m_mD                                                 (15)   [L445–L446]
T_maD = (m_mD/m_D)·T_mD + (m_aCD/m_D)·T_aD                          (16)   [L447–L450]
```
(Eq. 12 is OCR-mangled; it is the ideal-gas total mass of mixture one after the air has been charged, i.e.
`m_mD = p_D V_D/(R T_mD) − m_aCD`.) Assumptions [L454–L464]: constant fresh-air T,ρ; constant exhaust T;
constant pressure; ideal mixing into "mixture one"; the air/residual ratio of mixture one stays at the
original ratio; adiabatic wall.

**Stage IV — perfect mixing (D→E):**

```
dm_DE = ṁ_out·(t_E − t_D)                                           (17)   [L472–L473]
m_mE = m_E = m_D − dm_DE                                           (18)   [L474–L475]
m_aE = (m_aD/m_D)·m_E                                              (19)   [L483–L484]
m_rE = (m_rD/m_D)·m_E                                              (20)   [L486–L487]
T_E  = (m_aE/m_E)·T_a + (m_rE/m_E)·T_rE                            (21)   [L489–L492]
P_E  = m_E·R·T_E/V_E                                               (22)   [L493–L495]
```
Assumptions [L496–L500]: ideal mixing into mixture two; whole cylinder occupied by mixture two;
adiabatic wall.

**SE / TE:** the paper reports **charging efficiency** and **residual exhaust coefficient** instead:

```
CE  = mass of delivered fresh charge retained / reference mass = m_a/(ρ_s·V_R)     (23)  [L865–L870]
REC = mass of residual exhaust gas retained / mass of delivered fresh charge retained
    = m_r/m_a                                                                    (24)  [L871–L875]
```
SE appears in the abbreviation list [L1139] but **no SE formula is printed**. **NOT STATED:** any trapping
efficiency, and any way to obtain TE other than `1 − escaping air / delivered air`.

The paper is explicit that the whole approach depends on prescribed flows:

> "Since a 0D scavenging model is aiming to simulate the in-cylinder residual exhaust gas and fresh air to
> the exhaust pipe for further combustion and performance simulation, the detailed in-cylinder mass exchange
> process is not necessary." [L222–L227]

**Critical limitation for us:** `ṁ_in` and `ṁ_out` are **inputs** throughout (eqs. 5, 11, 17), not computed
from port areas and pressure differences. There is no orifice, no Cd, no area schedule. Point C ("used to
adjust the ratio of PD and DM") and the stage boundary times are tuning parameters.

## D.2 Cylinder gas exchange

As above: no orifice equation, no effective area, no Cd. Flow is an externally supplied mass flow
(`ṁ_in`, `ṁ_out`). Pressure coupling is only through the constant `P_p` (mean of scavenge port and exhaust
pipe pressure) during B→D and through eqs. 1 and 22. **NOT STATED:** how `ṁ_in`, `ṁ_out` are obtained.

## D.3 Combustion model

Not modelled; the model stops at EVC. "The model provides the initial conditions for subsequent combustion"
[L955–L958]. **NOT STATED / N.A.:** no Wiebe, no heat release.

## D.4 Heat transfer model

No correlation — the wall is simply declared adiabatic in all four stages [L380, L417, L464, L500].
**NOT STATED:** any h_g correlation or constants.

## D.5 Solution method

Purely algebraic, stage-by-stage. There is **no time integration, no step size, no convergence criterion**;
the stage boundaries are engine events (EVO, SPO, "point C", SPC, EVC) plus the pressure condition
`P_B = P_C = P_D = P_p`. **NOT STATED:** Δt, iteration, tolerance. The claim is only real-time capability.

## D.6 Validation

Validated against **CFD, not experiment** (the CFD itself is validated against manufacturer cylinder
pressure):

> "The results of the 0D model agree well with the results of the CFD simulation, and the mean relative
> errors of temperature, pressure, and total mass do not exceed 3%, 4%, and 2%, respectively" [L23–L26]

Two engines: 6EX340EF (340 mm bore, 1600 mm stroke, CR 20.5, SPO 140°/SPC 220°, EVO 111°) [L549–L573] and
RTX-8 (520 mm bore, 2658 mm stroke, CR 21.8) [L761–L775]; loads 25/50/75/100 % [L693–L727, L789–L823].
CFD-vs-experiment cylinder pressure at compression TDC: "all the relative deviations were less than 0.1%"
[L636–L642], Table 4 [L656–L690].

**No experimental validation of the 0-D model, no torque/BSFC/SE error.** The 2–4 % figures are
model-vs-model, so they tell us about internal consistency, not absolute accuracy.

---

# Cross-cutting gap list (what we must supply ourselves)

| Item | A 2018 | B 1995 | C 2012 | D 2022 |
|---|---|---|---|---|
| Explicit orifice flow equation | NOT STATED | implicit via Δm = C_D ρ u A Δt [L3081–L3085] | N.A. (3-D) | NOT STATED |
| Discharge coefficient value | NOT STATED | 0.75 (0.90 reverse inlet) [L3517–L3529] | N.A. | NOT STATED |
| Effective-area definition | NOT STATED (input profiles) | projected height×width − 0.858r² [L3533–L3541] | N.A. (meshed) | NOT STATED |
| Wiebe equation + exponent | NOT STATED (constants only) | NOT STATED (Blair profile) | N.A. | N.A. |
| Heat-transfer correlation constants | NOT STATED | Annand cited, then Q=0 [L2921–L2926] | N.A. (solved) | adiabatic |
| Time step | NOT STATED | CFL × 0.95 [L3586–L3590] | 0.1 °CA [L869–L871] | N.A. |
| Convergence criterion | NOT STATED | pressure-iteration tolerance, value NOT STATED [L3379–L3382] | NOT STATED | N.A. |
| SE / TE formula | NOT STATED | SAE definitions, η_s–Λ_s curve [L720–L743] | Eq. 13, SE = 82.5 % [L943–L955] | CE, REC only [L865–L875] |

---

# Recommended structure for our model

Our engine differs from all four: it is **small (132 cm³), high-speed, SI, carburetted/crankcase-compressed,
piston-ported, loop-scavenged, naturally aspirated, no turbocharger**. Consequences that drive the choices:
short-circuiting is the dominant gas-exchange loss (15–20 % of fuel, quoted in B at [L1205–L1207]); the
exhaust is wave-tuned but we are not modelling pipes; and SI combustion is fast and must not be seeded with
marine-diesel Vibe constants.

## Recommendation table

| Item | Adopt | From | Why |
|---|---|---|---|
| 1. Scavenging structure | **Two-zone (air / burnt) during the open period, one-zone during the closed period**, zones exchanging mass through the transfer and exhaust orifices; add D's four-stage event decomposition as the *event schedule* | A (structure) + D (stage boundaries) | A is the only source with a zone-resolved, crank-angle-integrated scavenging model; D gives a physically-motivated ordering of blowdown/displacement/mixing that we can use to switch sub-models, and matches what the CFD papers see |
| 2. Gas exchange | **Orifice flow with `C_D·A_eff`, A_eff projected from the port geometry, C_D = 0.75 normal / 0.90 reverse inlet, subsonic+sonic branches** | B | B is the only source with a Cd table and an explicit effective-area definition, and it was validated on exactly our engine architecture |
| 3. Combustion | **Single-zone Vibe, `x = 1 − exp[−a·y^(m+1)]`, `y = (θ−θ_0)/Δθ_c`, with `a = 6.9`, `m = 2` as the SI starting point; expose a, m, Δθ_c as calibration parameters** | A's *form* (Woschni–Anisits), SI constants from us | No paper prints the equation or the exponent; A's a=10/m=0.93 are large-diesel values. Use the m+1 convention explicitly and document it, because "m" alone is ambiguous |
| 4. Heat transfer | **Woschni 1967** with the standard gas-velocity term during closed period and reduced convective term during scavenging; Annand as a cross-check | A (choice of Woschni) + B (Annand reference) | A uses Woschni but prints no constants; we must implement the published 1967 form. During scavenging the temperature difference is small, so accuracy there matters little (B's justification for Q=0) |
| 5. Solution | **Explicit crank-angle marching with a fixed small step (0.1–0.25 °CA), per-cycle reset at a fixed CA, mass-balance closure + cycle-periodicity as the convergence test, inner fixed-point iteration on the port/cylinder pressure coupling** | B (the method), C (step size sanity) | B's CFL/0.95 rule is about 1-D pipes and does not bind us; what transfers is the reset-at-fixed-CA, the mass-balance audit, and the coupled-pressure iteration at the ports. C's 0.1 °CA is a useful upper bound on acceptable resolution |
| 6. Validation | **Target: ≤10 % on torque/power over the speed range (B), ≤5–10 % on BSFC and trapped mass; use A's table as the aspirational ceiling only after per-parameter calibration; sanity-check SE against C's 82.5 %** | B (realistic target), A (ceiling), C (SE check) | A's ~1 % is achieved on a 40 MW engine with measured receiver states, a calibrated 1-point combustion model, and no wave dynamics to miss. That is not transferable to a 132 cm³ engine with a lumped exhaust. B is the honest benchmark: <10 % |

## 1. Scavenging model — detailed recommendation

Adopt the **A structure**: open period = two zones, closed period = one zone.

Implementation (the equations A does not print — this is the standard open-system two-zone form
consistent with A's stated six-ODE state vector [L379–L386]):

Zone 1 = fresh air (fed by the transfer port), zone 2 = burnt gas + products. Both at the same pressure
`p` (A's state vector integrates `p`, so pressure equality is enforced).

```
Zone masses:        dm_1/dt = ṁ_tr  − ṁ_1,ex − ṁ_12
                    dm_2/dt = ṁ_12  − ṁ_2,ex  (+ fuel, in the closed period)
Zone energies:      d(m_i c_v T_i)/dt = ṁ_in,i·h_in − ṁ_out,i·h_i − p·dV_i/dt + Q̇_i
Zone volumes:       V_i = m_i R T_i / p           (Σ V_i = V(θ))
Pressure:           dp/dt from A's sixth ODE, or p = Σm_i R T_i / V(θ)
Burnt fraction:     d x_b,2/dt  (A's sixth state; = 0 in zone 1 during scavenging)
```

Practical choices we must make and document (all **NOT STATED** in A):
- Which zone the transfer-port inflow enters (zone 1, pure air — assume this).
- Whether zone 1 can blow straight out of the exhaust port (this is **the short-circuiting mechanism**;
  it must be allowed, otherwise the model cannot produce the 15–20 % fuel loss of B [L1205–L1207]).
- How zone 1 and zone 2 exchange mass (`ṁ_12`): the physically cleanest option is
  displacement-only (no entrainment), with entrainment switched on in D's "displacement-mixing" stage.
- Homogenisation at EPC: mass-weighted mix of the two zones into the single zone used for compression.
- **Use D's stage schedule to gate the sub-models:** A→B blowdown (exhaust only, isentropic — D eq. 1),
  B→C perfect displacement (eqs. 4–8), C→D displacement+mixing (eqs. 9–16), D→E perfect mixing (eqs. 17–22).
  D's algebra is for a constant-pressure scavenging event, which is a defensible approximation for our
  crankcase-scavenged engine (port pressure ≈ crankcase pressure ≈ near-constant over the transfer window).

What to *not* adopt and why:
- **Do not use D as the primary model.** Its `ṁ_in`, `ṁ_out` are inputs [L395, L433, L472]; we need flow to
  be a *result* of port area and pressure difference, otherwise the model cannot respond to speed, port
  timing or crankcase compression.
- **Do not use B's empirical η_s(Λ_s) curve as the primary model.** It is speed-independent by assumption
  [L3572–L3578], i.e. it cannot produce the wave-driven delivery-ratio variation that dominates a small
  two-stroke. Keep it as a **calibration target**: at EPC, our integrated trapped fresh-air mass should
  reproduce a Blair-style η_s–Λ_s curve for a "YAM6"-class cylinder.
- **Do not use C**; 3-D CFD is out of scope by construction [L1058–L1060].

## 2. Gas exchange — detailed recommendation

```
ṁ = C_D · A_eff(θ) · p_u /√(R T_u) · Ψ(Π),      Π = p_d/p_u
Ψ = √( 2κ/(κ−1) · (Π^(2/κ) − Π^((κ+1)/κ)) )                 for Π > Π_crit
Ψ = √κ · ( 2/(κ+1) )^((κ+1)/(2(κ−1)))                        for Π ≤ Π_crit
Π_crit = ( 2/(κ+1) )^(κ/(κ−1))            (= 0.528 for κ = 1.4)
```
with `C_D = 0.75` normal flow, `0.90` for reverse flow through the inlet port [B, L3517–L3529], and

```
A_eff = h·l − 0.858 r²,   h = h_0·cos θ_ax,   l = l_0·cos θ_ta
```
[B, L3533–L3541 — reconstruction of OCR-garbled text, verify against the page].

Justification: B is the only source that states a Cd, states that it is constant "following Blair"
[L3506–L3516], and defines a *projected* area rather than the geometric window — which matters for a
loop-scavenged cylinder with inclined transfer ports. A's "two consecutive orifices" [L422–L431] is the
right *topology* for the MVEM (ports then exhaust valve in series) and is irrelevant to us because our
exhaust is a port, not a valve; if we ever add a tuned exhaust we would treat the pipe as a third volume.

Also adopt B's stagnation/reference-state split: cylinder state is stagnation upstream, the downstream
state is the receiver/pipe reference state [L3041–L3049]. For us, downstream is a plenum at fixed p, T
(crankcase for the transfer port, atmosphere/ambient for the exhaust if no pipe model). **Air-box /
crankcase:** treat the crankcase as a second 0-D control volume using exactly B's equation set applied to
CV2 [L3195–L3196] — that is the only place in the four papers where crankcase compression is actually
modelled, and it is essential for us.

## 3. Combustion — detailed recommendation

Use a single-zone Vibe for the closed period. Be explicit in code:

```
x_b(θ) = 1 − exp[ −a · ( (θ − θ_0)/Δθ_c )^(m+1) ]
dx_b/dθ = a(m+1)/Δθ_c · y^m · exp(−a y^(m+1)),    y = (θ−θ_0)/Δθ_c
Q̇_comb = m_f · LHV · η_comb · dx_b/dθ
```

- **This is the `m+1` convention.** A does not print its equation [L388–L397] and neither does B
  [L3603–L3615], so the convention is **NOT STATED in any of the four papers**. Getting this wrong is a
  factor-of-`y` error in the burn rate; freeze the convention above and never expose a bare "m" in the
  config file — name the parameter `vibe_m` and name the helper `vibe_exponent = vibe_m + 1`.
- **Constants:** A's `a = 10, m = 0.93, Δθ_c = 47 °CA` [L2088–L2098] are for a 980 mm-bore marine diesel at
  ~94 rpm. Do not import them. Start SI at `a = 6.9, m = 2` (the standard Vibe/ Heywood starting point) with
  `Δθ_c ≈ 50–60 °CA` for a small two-stroke (short-circuiting lengthens the apparent burn), then calibrate
  `a, m, Δθ_c, θ_0` against a measured cylinder pressure trace — exactly A's one-point-calibration
  philosophy [L394–L397] and B's [L5006–L5012].
- **Do not** adopt B's Blair pressure-trace-derived profile: it needs a measured pressure trace to derive,
  and B reports no functional form [L3603–L3615].
- Keep `η_comb` (and hence trapping) as the closure between fuel supplied and heat released; B warns the
  trapped AFR and combustion efficiency are speed-dependent in reality even though it held them constant
  [L5009–L5012].

## 4. Heat transfer — detailed recommendation

Adopt **Woschni 1967** (A's choice [L396–L399]) in its standard published form, since A prints no constants:

```
h_c = 3.26 · B^-0.2 · p^0.8 · T^-0.55 · w^0.8          [W/m²K, p in kPa, T in K, B in m]
w  = C_1 · S_p + C_2 · (V_d T_ref)/(p_ref V_ref) · (p − p_mot)
C_1 = 2.28 + 0.308·(u_g/S_p)     (gas exchange period: C_1 = 6.18 + 0.417·u_g/S_p)
C_2 = 3.24e-3                    (C_2 = 0 for the gas exchange period)
```
and, per B's argument, allow the scavenging-period heat transfer to be switched off entirely:

> "As the heat transfer during the gas exchange period is small compared with the combustion period, it is
> assumed that ΔQ^(1-2) = 0 in this study." [L2921–L2926]

**Caveat to record in the code:** B cites Annand but prints no constants [L2921–L2926]; A cites Woschni but
prints "the default value ... as proposed for large two-stroke engine" with no numbers [L396–L399]; C solves
the energy equation with no correlation [L590–L657]; D is adiabatic [L380, L417, L464, L500]. **No
heat-transfer constant in this set is usable as-is.** Woschni's coefficients must come from the primary
reference (SAE 670931, cited by A at [L1744–L1745]) or Heywood. Wall areas: not stated by any paper — model
as head + piston + liner with the liner area varying with crank angle.

## 5. Solution method — detailed recommendation

Adopt B's *architecture*, not its CFL rule:

1. **Crank-angle marching, explicit.** Fixed step `Δθ = 0.1–0.25 °CA`. Justification: C used 0.1 °CA
   [L869–L871]; our port-opening events are near-instantaneous in area, so a small fixed step avoids
   event-detection logic. Do **not** copy B's CFL×0.95 rule [L3586–L3590] — that constraint exists only
   because of the 1-D pipe mesh, and for a pure 0-D model it would be a meaningless (and possibly huge) step.
2. **Per-cycle reset at a fixed crank angle**, as B does at EPO [L596–L600]. Use TDC or EPO; the point is
   that every cycle starts from a bit-identical state so that cycle-to-cycle drift is a detectable error.
   Seed from the previous cycle's end state, not from a fixed guess, so the solution walks to the periodic
   orbit.
3. **Convergence test = periodicity + mass balance.** B's only convergence criteria are (i) the port/cylinder
   pressure iteration "falls below the specified tolerance" [L3379–L3382] and (ii) the mass-balance audit at
   six control points with `ε → 0` [L3387–L3448]. Neither tolerance value is printed. Use:
   - inner loop (port/cylinder coupling): `|p_new − p_old| < 1 Pa` or relative `1e-6`, max 20 iterations;
   - outer loop: stop when `|X_end − X_start|/|X_start| < 1e-4` per cycle for trapped mass, T, p, **and**
     when the cycle mass imbalance `|Σm_in − Σm_out| / Σm_in < 1e-6`.
4. **Audit mass and energy at the same four control points we care about**: inlet→crankcase, crankcase→
   cylinder (transfer), cylinder→exhaust, and the cylinder itself. B's `ε` definition [L3435–L3446] is a good
   template.
5. **Record `Δm` closure per cycle as a first-class output**, not a debug print. In B this is how numerical
   quality is judged [L3387–L3396]; for a 0-D two-stroke with a large short-circuit flow it is the single
   most sensitive indicator that the zone-exchange logic is wrong.

## 6. Validation — what accuracy is actually achievable

Targets, in order of defensibility:

| Level | Source | Achieved | How to use it |
|---|---|---|---|
| Realistic for us | B [L4998–L5001] | torque/power **< 10 %** over 2200–4400 rpm, 5 exhaust configurations; pressure traces "good" [L5034–L5036] | This is our primary acceptance band. Same engine class (crankcase-compressed, loop-scavenged, port-timed), same speed range order, and it *includes* wave-tuning error that we will also have because we do not model pipes |
| Aspirational ceiling | A Table 3 [L2128–L2232] | brake power ≈1 %, BSFC ≤0.6 %, P_max ≤1.5 %, P_comp ≤1.2 %, gas-path states 2–4.5 %, turbo speed ≤4.5 % | Achievable only *after* one-point combustion calibration on a 40 MW engine with measured receiver states. Do not promise these numbers for a 132 cm³ engine |
| Internal consistency | A [L1364–L1367, L1399–L1402] | 0.05–1.03 % model-vs-model | Useful as a regression test when we change a sub-model |
| Scavenging sanity | C [L943–L955] | SE = 82.5 % at rated | Our SE at rated speed should land within a few points of 0.80–0.85 for a loop-scavenged cylinder; large deviation means the short-circuit logic is wrong |
| Scavenging consistency | D [L23–L26] | T ≤3 %, p ≤4 %, mass ≤2 % (vs CFD) | Only a model-vs-model check; do not cite as validation |

**What to actually measure and compare, in priority order** (this is the honest reading of all four):
1. **Cylinder pressure trace**, entire cycle, at 2–3 speeds — A's Fig. 3 and B's Figs. 6.6–6.12 both do this
   and both treat it as *the* validation. Target: peak pressure within 5 %, peak location within 2 °CA,
   and correct shape through blowdown (this is where a bad scavenging model shows up).
2. **Trapped mass / SE / TE at EPC** — no paper in this set validates SE against measurement directly. The
   only measurement technique described is B's QUB single-cycle rig (air vs CO₂, oxygen analyser,
   [L5931–L5967]), which measures η_s vs Λ_s for a motored cylinder and would be the correct bench test if
   we ever want a hard SE validation. Until then, SE is a *prediction*, not a validated output, and should
   be reported with that caveat.
3. **BSFC and torque/power at 3+ speeds.** B: <10 %; A: ~1 % on a large engine. Expect 5–10 %.
4. **Crankcase pressure trace** — B has it (inlet/transfer port traces [L5016–L5036]); none of the others do.
   For a crankcase-scavenged engine this is the cheapest check that the crankcase control volume and the
   transfer-port Cd are right.
5. **Exhaust gas temperature** — A validates it to ≈0.5–3.3 % [L2197–L2214]; a useful coarse check because it
   integrates the whole cycle's energy balance.

**Do not claim** the 2–4 % of D or the 1 % of A as validation of our model. D's is model-vs-CFD; A's is a
different engine class with calibrated constants and a measured gas path.

## Residual risks in this recommendation

1. **A's two-zone equations are not printed** [L379–L386]. We are implementing a standard formulation under
   A's *stated* state-vector structure. It must be validated by mass/energy closure, not by appeal to A.
2. **No source gives a Wiebe equation with an explicit exponent.** We are choosing the `m+1` convention on
   the strength of the general literature, not on these four papers. This must be flagged in the code and
   checked against a measured burn rate.
3. **No source gives Woschni constants.** Must come from the primary reference.
4. **B's effective-area equations are OCR-damaged** [L3533–L3541]; the reconstruction (projection minus
   0.858 r²) should be checked against the printed thesis page before implementation.
5. **B is a 1-D MOC model, not 0-D.** We are borrowing its *cylinder/crankcase control-volume formulation,
   its Cd table and its effective-area definition* — all of which are 0-D-compatible — and discarding its
   pipe solution. Its <10 % accuracy figure was obtained *with* wave dynamics modelled; a pure 0-D model
   without pipes should be expected to do **worse** on a wave-tuned small two-stroke, especially near the
   tuned speed. That is the main reason to treat 10 % as a floor on the error, not a target.
