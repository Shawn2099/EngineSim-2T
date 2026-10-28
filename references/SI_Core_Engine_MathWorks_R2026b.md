Title: SI Core Engine - Spark-ignition engine from intake to exhaust port - Simulink

URL Source: https://www.mathworks.com/help/autoblks/ref/sicoreengine.html

Markdown Content:
**R**2026**b**

Spark-ignition engine from intake to exhaust port

*   ![Image 1: SI Core Engine block icon](https://www.mathworks.com/help/autoblks/ref/si_core_engine.png)

**Libraries:**  
 Powertrain Blockset / Propulsion / Combustion Engine Components / Core Engine

## Description

The SI Core Engine block implements a spark-ignition (SI) engine from intake to exhaust port. You can use the block in larger vehicle models, hardware-in-the-loop (HIL) engine control design, or vehicle-level fuel economy and performance simulations.

The SI Core Engine block calculates:

*   Brake torque

*   Fuel flow

*   Port gas mass flow, including exhaust gas recirculation (EGR)

*   Air-fuel ratio (AFR)

*   Exhaust temperature and exhaust mass flow rate

*   Engine-out (EO) exhaust emissions

    *   Hydrocarbon (HC)

    *   Carbon monoxide (CO)

    *   Nitric oxide and nitrogen dioxide (NOx)

    *   Carbon dioxide (CO 2)

    *   Particulate matter (PM)

### Air Mass Flow

To calculate engine air mass flow, configure the SI engine to use either of these air mass flow models.

| Air Mass Flow Model | Description |
| --- | --- |
| [SI Engine Speed-Density Air Mass Flow Model](https://www.mathworks.com/help/autoblks/ug/spark-ignition-engine-simple-speed-density-breathing-model-1.html) | Uses the speed-density equation to calculate the engine air mass flow, relating the engine air mass flow to the intake manifold pressure and engine speed. Consider using this air mass flow model in engines with fixed valvetrain designs. |
| [SI Engine Dual-Independent Cam Phaser Air Mass Flow Model](https://www.mathworks.com/help/autoblks/ug/si-engine-dual-independent-cam-phaser-air-mass-flow-model.html) | To calculate the engine air mass flow, the dual-independent cam phaser model uses: * Empirical calibration parameters developed from engine mapping measurements * Desktop calibration parameters derived from engine computer-aided design (CAD) data In contrast to typical embedded air mass flow calculations based on direct air mass flow measurement with an air mass flow (MAF) sensor, this air mass flow model offers: * Elimination of MAF sensors in dual cam-phased valvetrain applications * Reasonable accuracy with changes in altitude * Semiphysical modeling approach * Bounded behavior * Suitable execution time for electronic control unit (ECU) implementation * Systematic development of a relatively small number of calibration parameters |

### Brake Torque

To calculate the brake torque, configure the SI engine to use either of these torque models.

| Brake Torque Model | Description |
| --- | --- |
| [SI Engine Torque Structure Model](https://www.mathworks.com/help/autoblks/ug/si-engine-torque-structure-model.html) | For the structured brake torque calculation, the SI engine uses tables for the inner torque, friction torque, optimal spark, spark efficiency, and lambda efficiency. If you select **Crank angle pressure and torque** on the block **Torque** tab, you can: * Simulate advanced closed-loop engine controls in desktop simulations and on HIL bench, based on cylinder pressure recorded from a model or laboratory test as a function of crank angle. * Simulate driveline vibrations downstream of the engine due to high-frequency crankshaft torsionals. * Simulate engine misfires due to lean operation or spark plug fouling by using the injector pulse width input. * Simulate cylinder deactivation effect (closed intake and exhaust valves, no injected fuel) on individual cylinder pressures, mean-value airflow, mean-value torque, and crank-angle-based torque. * Simulate the fuel-cut effect on individual cylinder pressure, mean-value torque, and crank-angle-based torque. |
| [SI Engine Simple Torque Model](https://www.mathworks.com/help/autoblks/ug/spark-ignition-engine-simple-torque-model-1.html) | For the simple brake torque calculation, the SI engine block uses a torque lookup table map that is a function of engine speed and load. |

### Fuel Flow

To calculate the fuel flow, the SI Core Engine block uses fuel injector characteristics and fuel injector pulse-width.

To calculate the fuel economy for high-fidelity models, the block uses the volumetric fuel flow.

The equation uses these variables.

˙m fuel Fuel mass flow, g/s
ω Engine rotational speed, rad/s
Cps Crankshaft revolutions per power stroke, rev/stroke
S inj Fuel injector slope, mg/ms
P w inj Fuel injector pulse-width, ms
N cyl Number of engine cylinders
_N_ Engine speed, rpm
_Sg fuel_ Specific gravity of fuel
_Q fuel_ Volumetric fuel flow

The block uses the internal signal `FlwDir` to track the direction of the flow.

### Air-Fuel Ratio

To calculate the air-fuel (AFR) ratio, the CI Core Engine and SI Core Engine blocks implement this equation.

The CI Core Engine uses this equation to calculate the relative AFR.

To calculate the exhaust gas recirculation (EGR), the blocks implement this equation. The calculation expresses the EGR as a percent of the total intake port flow.

The equations use these variables.

$A F R$Air-fuel ratio
_AFR s_ Stoichiometric air-fuel ratio
$\left(\overset{\cdot}{m}\right)_{i n t k}$Engine air mass flow
$\left(\overset{\cdot}{m}\right)_{f u e l}$Fuel mass flow
λ Relative AFR
_y intk,b_ Intake burned mass fraction
_EGR pct_ EGR percent
$\left(\overset{\cdot}{m}\right)_{i n t k , b}$Recirculated burned gas mass flow rate

### Exhaust

The block calculates the:

*   Exhaust gas temperature

*   Exhaust gas-specific enthalpy

*   Exhaust gas mass flow rate

*   Engine-out (EO) exhaust emissions:

    *   Hydrocarbon (HC)

    *   Carbon monoxide (CO)

    *   Nitric oxide and nitrogen dioxide (NOx)

    *   Carbon dioxide (CO 2)

    *   Particulate matter (PM)

The exhaust temperature determines the specific enthalpy.

The exhaust mass flow rate is the sum of the intake port air mass flow and the fuel mass flow.

To calculate the exhaust emissions, the block multiplies the emission mass fraction by the exhaust mass flow rate. To determine the emission mass fractions, the block uses lookup tables that are functions of the engine torque and speed.

The fraction of air and fuel entering the intake port, injected fuel, and stoichiometric AFR determine the air mass fraction that exits the exhaust.

If the engine is operating at the stoichiometric or fuel rich AFR, no air exits the exhaust. Unburned hydrocarbons and burned gas comprise the remainder of the exhaust gas. This equation determines the exhaust burned gas mass fraction.

The equations use these variables.

$T_{e x h}$Engine exhaust temperature
$h_{e x h}$Exhaust manifold inlet-specific enthalpy
$C p_{e x h}$Exhaust gas specific heat
$\left(\overset{\cdot}{m}\right)_{i n t k}$Intake port air mass flow rate
$\left(\overset{\cdot}{m}\right)_{f u e l}$Fuel mass flow rate
$$
\left(\overset{\cdot}{m}\right)_{e x h}
$$Exhaust mass flow rate
$$
y_{i n , f u e l}
$$Intake fuel mass fraction
_y exh,i_ Exhaust mass fraction for i = CO 2, CO, HC, NOx, air, burned gas, and PM
$$
\left(\overset{\cdot}{m}\right)_{e x h , i}
$$Exhaust mass flow rate for i = CO 2, CO, HC, NOx, air, burned gas, and PM
_T brake_ Engine brake torque
_N_ Engine speed
_y exh,air_ Exhaust air mass fraction
_y exh,b_ Exhaust air burned mass fraction

### Power Accounting

For the power accounting, the block implements equations that depend on **Torque model**.

When you set **Torque model** to `Simple Torque Lookup`, the block implements these equations.

| Bus Signal | Description | Equations |
| --- | --- | --- |
| `PwrInfo` | `PwrTrnsfrd` — Power transferred between blocks * Positive signals indicate flow into block * Negative signals indicate flow out of block | `PwrIntkHeatFlw` | Intake heat flow | $\left(\overset{\cdot}{m}\right)_{i n t k} h_{i n t k}$ |
| `PwrExhHeatFlw` | Exhaust heat flow | $- \left(\overset{\cdot}{m}\right)_{e x h} h_{e x h}$ |
| `PwrCrkshft` | Crankshaft power | $- T_{b r a k e} \omega$ |
| `PwrNotTrnsfrd` — Power crossing the block boundary, but not transferred * Positive signals indicate an input * Negative signals indicate a loss | `PwrFuel` | Fuel input power | $\left(\overset{\cdot}{m}\right)_{f u e l} L H V$ |
| `PwrLoss` | All losses | $T_{b r a k e} \omega - \left(\overset{\cdot}{m}\right)_{f u e l} L H V - \left(\overset{\cdot}{m}\right)_{i n t k} h_{i n t k} + \left(\overset{\cdot}{m}\right)_{e x h} h_{e x h}$ |
| `PwrStored` — Stored energy rate of change * Positive signals indicate an increase * Negative signals indicate a decrease | _Not used_ |

When you set **Torque model** to `Torque Structure`, the block implements these equations.

| Bus Signal | Description | Equations |
| --- | --- | --- |
| `PwrInfo` | `PwrTrnsfrd` — Power transferred between blocks * Positive signals indicate flow into block * Negative signals indicate flow out of block | `PwrIntkHeatFlw` | Intake heat flow | $\left(\overset{\cdot}{m}\right)_{i n t k} h_{i n t k}$ |
| `PwrExhHeatFlw` | Exhaust heat flow | $- \left(\overset{\cdot}{m}\right)_{e x h} h_{e x h}$ |
| `PwrCrkshft` | Crankshaft power | $- T_{b r a k e} \omega$ |
| `PwrNotTrnsfrd` — Power crossing the block boundary, but not transferred * Positive signals indicate an input * Negative signals indicate a loss | `PwrFuel` | Fuel input power | $\left(\overset{\cdot}{m}\right)_{f u e l} L H V$ |
| `PwrFricLoss` | Friction loss | $- T_{f r i c} \omega$ |
| `PwrPumpLoss` | Pumping loss | $- T_{p u m p} \omega$ |
| `PwrHeatTrnsfrLoss` | Heat transfer loss | $T_{b r a k e} \omega - \left(\overset{\cdot}{m}\right)_{f u e l} L H V - \left(\overset{\cdot}{m}\right)_{i n t k} h_{i n t k} + \left(\overset{\cdot}{m}\right)_{e x h} h_{e x h} + T_{f r i c} \omega + T_{p u m p} \omega$ |
| `PwrStored` — Stored energy rate of change * Positive signals indicate an increase * Negative signals indicate a decrease | _Not used_ |

_h exh_ Exhaust manifold inlet-specific enthalpy
_h intk_ Intake port specific enthalpy
$\left(\overset{\cdot}{m}\right)_{i n t k}$Intake port air mass flow rate
$\left(\overset{\cdot}{m}\right)_{f u e l}$Fuel mass flow rate
$$
\left(\overset{\cdot}{m}\right)_{e x h}
$$Exhaust mass flow rate
_ω_ Engine speed
_T brake_ Brake torque
_T pump_ Engine pumping work offset to inner torque
_T fric_ Engine friction torque
_LHV_ Fuel lower heating value

## Ports

### Input

expand all

Fuel injector pulse-width, $P w_{i n j}$, in ms.

Spark advance, _SA_, in degrees crank angle before top dead center (degBTDC).

#### Dependencies

To create this port, for the **Torque model** parameter, select `Torque Structure`.

Intake cam phase angle command, $\varphi_{I C P C M D}$, in degCrkAdv, or crank degrees of advance relative to the intake phaser park position.

#### Dependencies

To create this port, for the **Air mass flow model** parameter, select `Dual-Independent Variable Cam Phasing`.

Exhaust cam phase angle command, $\varphi_{E C P C M D}$, in degCrkRet, or crank degrees of retard relative to the exhaust phaser park position.

#### Dependencies

To create this port, for the **Air mass flow model** parameter, select `Dual-Independent Variable Cam Phasing`.

Ambient pressure, $P_{A m b}$, in Pa.

#### Dependencies

To create this port, for the **Air mass flow model** parameter, select `Dual-Independent Variable Cam Phasing`.

Engine speed, _N_, in rpm.

Engine cooling temperature, _T coolant_, in K.

#### Dependencies

To enable this parameter, for **Torque model**, select `Torque Structure`.

Bus containing the upstream:

*   `Prs` — Pressure, in Pa

*   `Temp` — Temperature, in K

*   `Enth` — Specific enthalpy, in J/kg

*   `MassFrac` — Intake port mass fractions, dimensionless. EGR mass flow at the intake port is burned gas.

Specifically, a bus with these mass fractions:

    *   `O2MassFrac` — Oxygen

    *   `N2MassFrac` — Nitrogen

    *   `UnbrndFuelMassFrac` — Unburned fuel

    *   `CO2MassFrac` — Carbon dioxide

    *   `H2OMassFrac` — Water

    *   `COMassFrac` — Carbon monoxide

    *   `NOMassFrac` — Nitric oxide

    *   `NO2MassFrac` — Nitrogen dioxide

    *   `NOxMassFrac` — Nitric oxide and nitrogen dioxide

    *   `PmMassFrac` — Particulate matter

    *   `AirMassFrac` — Air

    *   `BrndGasMassFrac` — Burned gas

Bus containing the exhaust:

*   `Prs` — Pressure, in Pa

*   `Temp` — Temperature, in K

*   `Enth` — Specific enthalpy, in J/kg

*   `MassFrac` — Exhaust port mass fractions, dimensionless.

Specifically, a bus with these mass fractions:

    *   `O2MassFrac` — Oxygen

    *   `N2MassFrac` — Nitrogen

    *   `UnbrndFuelMassFrac` — Unburned fuel

    *   `CO2MassFrac` — Carbon dioxide

    *   `H2OMassFrac` — Water

    *   `COMassFrac` — Carbon monoxide

    *   `NOMassFrac` — Nitric oxide

    *   `NO2MassFrac` — Nitrogen dioxide

    *   `NOxMassFrac` — Nitric oxide and nitrogen dioxide

    *   `PmMassFrac` — Particulate matter

    *   `AirMassFrac` — Air

    *   `BrndGasMassFrac` — Burned gas

### Output

expand all

Bus signal that contains these block calculations.

| Signal | Description | Variable | Units |
| --- | --- | --- | --- |
| `IntkGasMassFlw` | Engine intake air mass flow | $\left(\overset{\cdot}{m}\right)_{a i r}$ | kg/s |
| `IntkAirMassFlw` | Engine intake port mass flow | $\left(\overset{\cdot}{m}\right)_{i n t k}$ | kg/s |
| `NrmlzdAirChrg` | Engine load (that is, normalized cylinder air mass) corrected for final steady-state cam phase angles | $L$ | N/A |
| `Afr` | Air-fuel ratio at engine exhaust port | $A F R$ | N/A |
| `FuelMassFlw` | Fuel flow into engine | $\left(\overset{\cdot}{m}\right)_{f u e l}$ | kg/s |
| `FuelVolFlw` | Volumetric fuel flow | _Q fuel_ | m 3/s |
| `ExhManGasTemp` | Exhaust gas temperature at exhaust manifold inlet | $T_{e x h}$ | K |
| `EngTrq` | Engine brake torque | $T_{b r a k e}$ | N·m |
| `EngSpd` | Engine speed | $N$ | rpm |
| `IntkCamPhase` | Intake cam phaser angle | $\varphi_{I C P}$ i | crank degrees advance relative to park |
| `ExhCamPhase` | Exhaust cam phaser angle | $\varphi_{E C P}$ | crank degrees retard relative to park |
| `CrkAng` | Engine crankshaft absolute angle | $$ \int_{0}^{\left(\right. 360 \left.\right) C p s} E n g S p d \frac{180}{30} d \theta $$ where $$ C p s $$ is crankshaft revolutions per power stroke | degrees crank angle |
| `EgrPct` | EGR percent | _EGR pct_ | N/A |
| `EoAir` | EO air mass flow rate | $$ \left(\overset{\cdot}{m}\right)_{e x h} $$ | kg/s |
| `EoBrndGas` | EO burned gas mass flow rate | _y exh,b_ | kg/s |
| `EoHC` | EO hydrocarbon emission mass flow rate | _y exh,HC_ | kg/s |
| `EoCO` | EO carbon monoxide emission mass flow rate | _y exh,CO_ | kg/s |
| `EoNOx` | EO nitric oxide and nitrogen dioxide emissions mass flow rate | _y exh,NOx_ | kg/s |
| `EoCO2` | EO carbon dioxide emission mass flow rate | _y exh,CO2_ | kg/s |
| `EoPm` | EO particulate matter emission mass flow rate | _y exh,PM_ | kg/s |
| `CylPrs` | Cylinder pressure | N/A | Pa |
| `EngTrqCrk` | Crank-angle based engine torque | N/A | N·m |
| `PwrInfo` | `PwrTrnsfrd` | `PwrIntkHeatFlw` | Intake heat flow | $\left(\overset{\cdot}{m}\right)_{i n t k} h_{i n t k}$ | W |
| `PwrExhHeatFlw` | Exhaust heat flow | $- \left(\overset{\cdot}{m}\right)_{e x h} h_{e x h}$ | W |
| `PwrCrkshft` | Crankshaft power | $- T_{b r a k e} \omega$ | W |
| `PwrNotTrnsfrd` | `PwrFuel` | Fuel input power | $\left(\overset{\cdot}{m}\right)_{f u e l} L H V$ | W |
| `PwrLoss` | For **Torque model** set to ``` Simple Torque Lookup ``` : All losses | $T_{b r a k e} \omega - \left(\overset{\cdot}{m}\right)_{f u e l} L H V - \left(\overset{\cdot}{m}\right)_{i n t k} h_{i n t k} + \left(\overset{\cdot}{m}\right)_{e x h} h_{e x h}$ | W |
| `PwrFricLoss` | For **Torque model** set to ``` Torque Structure ``` : Friction loss | $- T_{f r i c} \omega$ | W |
| `PwrPumpLoss` | For **Torque model** set to ``` Torque Structure ``` : Pumping loss | $- T_{p u m p} \omega$ | W |
| `PwrHeatTrnsfrLoss` | For **Torque model** set to ``` Torque Structure ``` : Heat transfer loss | $T_{b r a k e} \omega - \left(\overset{\cdot}{m}\right)_{f u e l} L H V - \left(\overset{\cdot}{m}\right)_{i n t k} h_{i n t k} + \left(\overset{\cdot}{m}\right)_{e x h} h_{e x h} + T_{f r i c} \omega + T_{p u m p} \omega$ | W |
| `PwrStored` | _Not used_ |

Engine brake torque, $T_{b r a k e}$, in N·m.

Bus containing:

*   `MassFlwRate` — Intake port mass flow rate, in kg/s

*   `HeatFlwRate` — Intake port heat flow rate, in J/s

*   `Temp` — Intake port temperature, in K

*   `MassFrac` — Intake port mass fractions, dimensionless.

Specifically, a bus with these mass fractions:

    *   `O2MassFrac` — Oxygen

    *   `N2MassFrac` — Nitrogen

    *   `UnbrndFuelMassFrac` — Unburned fuel

    *   `CO2MassFrac` — Carbon dioxide

    *   `H2OMassFrac` — Water

    *   `COMassFrac` — Carbon monoxide

    *   `NOMassFrac` — Nitric oxide

    *   `NO2MassFrac` — Nitrogen dioxide

    *   `NOxMassFrac` — Nitric oxide and nitrogen dioxide

    *   `PmMassFrac` — Particulate matter

    *   `AirMassFrac` — Air

    *   `BrndGasMassFrac` — Burned gas

Bus containing:

*   `MassFlwRate` — Exhaust port mass flow rate, in kg/s

*   `HeatFlwRate` — Exhaust heat flow rate, in J/s

*   `Temp` — Exhaust temperature, in K

*   `MassFrac` — Exhaust port mass fractions, dimensionless.

Specifically, a bus with these mass fractions:

    *   `O2MassFrac` — Oxygen

    *   `N2MassFrac` — Nitrogen

    *   `UnbrndFuelMassFrac` — Unburned fuel

    *   `CO2MassFrac` — Carbon dioxide

    *   `H2OMassFrac` — Water

    *   `COMassFrac` — Carbon monoxide

    *   `NOMassFrac` — Nitric oxide

    *   `NO2MassFrac` — Nitrogen dioxide

    *   `NOxMassFrac` — Nitric oxide and nitrogen dioxide

    *   `PmMassFrac` — Particulate matter

    *   `AirMassFrac` — Air

    *   `BrndGasMassFrac` — Burned gas

## Parameters

expand all

#### Block Options

To calculate engine air mass flow, configure the SI engine to use either of these air mass flow models.

| Air Mass Flow Model | Description |
| --- | --- |
| [SI Engine Speed-Density Air Mass Flow Model](https://www.mathworks.com/help/autoblks/ug/spark-ignition-engine-simple-speed-density-breathing-model-1.html) | Uses the speed-density equation to calculate the engine air mass flow, relating the engine air mass flow to the intake manifold pressure and engine speed. Consider using this air mass flow model in engines with fixed valvetrain designs. |
| [SI Engine Dual-Independent Cam Phaser Air Mass Flow Model](https://www.mathworks.com/help/autoblks/ug/si-engine-dual-independent-cam-phaser-air-mass-flow-model.html) | To calculate the engine air mass flow, the dual-independent cam phaser model uses: * Empirical calibration parameters developed from engine mapping measurements * Desktop calibration parameters derived from engine computer-aided design (CAD) data In contrast to typical embedded air mass flow calculations based on direct air mass flow measurement with an air mass flow (MAF) sensor, this air mass flow model offers: * Elimination of MAF sensors in dual cam-phased valvetrain applications * Reasonable accuracy with changes in altitude * Semiphysical modeling approach * Bounded behavior * Suitable execution time for electronic control unit (ECU) implementation * Systematic development of a relatively small number of calibration parameters |

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`AirMassFlowOptionPopup`
**Values:**```
Dual-Independent Variable Cam
                                        Phasing
```
 (default) | `Simple Speed-Density`
**Data Types:**`character vector`

#### Dependencies

The table summarizes the parameter dependencies.

| Air Mass Flow Model | Enables Parameters |
| --- | --- |
| ``` Dual-Independent Variable Cam Phasing ``` | **Cylinder volume at intake valve close table, f_vivc** **Cylinder volume intake cam phase breakpoints, f_vivc_icp_bpt** **Cylinder trapped mass correction factor, f_tm_corr** **Normalized density breakpoints, f_tm_corr_nd_bpt** **Engine speed breakpoints, f_tm_corr_n_bpt** **Air mass flow, f_mdot_air** **Exhaust cam phase breakpoints, f_mdot_air_ecp_bpt** **Trapped mass flow breakpoints, f_mdot_trpd_bpt** **Air mass flow correction factor, f_mdot_air_corr** **Engine load breakpoints for air mass flow correction, f_mdot_air_corr_ld_bpt** **Engine speed breakpoints for air mass flow correction, f_mdot_air_n_bpt** |
| ``` Simple Speed Density ``` | **Speed-density volumetric efficiency, f_nv** **Speed-density intake manifold pressure breakpoints, f_nv_prs_bpt** **Speed-density engine speed breakpoints, f_nv_n_bpt** |

To calculate the brake torque, configure the SI engine to use either of these torque models.

| Brake Torque Model | Description |
| --- | --- |
| [SI Engine Torque Structure Model](https://www.mathworks.com/help/autoblks/ug/si-engine-torque-structure-model.html) | For the structured brake torque calculation, the SI engine uses tables for the inner torque, friction torque, optimal spark, spark efficiency, and lambda efficiency. If you select **Crank angle pressure and torque** on the block **Torque** tab, you can: * Simulate advanced closed-loop engine controls in desktop simulations and on HIL bench, based on cylinder pressure recorded from a model or laboratory test as a function of crank angle. * Simulate driveline vibrations downstream of the engine due to high-frequency crankshaft torsionals. * Simulate engine misfires due to lean operation or spark plug fouling by using the injector pulse width input. * Simulate cylinder deactivation effect (closed intake and exhaust valves, no injected fuel) on individual cylinder pressures, mean-value airflow, mean-value torque, and crank-angle-based torque. * Simulate the fuel-cut effect on individual cylinder pressure, mean-value torque, and crank-angle-based torque. |
| [SI Engine Simple Torque Model](https://www.mathworks.com/help/autoblks/ug/spark-ignition-engine-simple-torque-model-1.html) | For the simple brake torque calculation, the SI engine block uses a torque lookup table map that is a function of engine speed and load. |

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`TrqOptionPopup`
**Values:**```
Torque
                                    Structure
```
 (default) | `Simple Torque Lookup`
**Data Types:**`character vector`

#### Dependencies

The table summarizes the parameter dependencies.

| Torque Model | Enables Parameters |
| --- | --- |
| ``` Torque Structure ``` | **Inner torque table, f_tq_inr** **Friction torque table, f_tq_fric** **Engine temperature modifier on friction torque, f_fric_temp_mod** **Engine temperature modifier breakpoints, f_fric_temp_bpt** **Pumping work table, f_tq_pump** **Optimal spark table, f_sa_opt** **Inner torque load breakpoints, f_tq_inr_l_bpt** **Inner torque speed breakpoints, f_tq_inr_n_bpt** **Spark efficiency table, f_m_sa** **Spark retard from optimal, f_del_sa_bpt** **Lambda efficiency, f_m_lam** **Lambda breakpoints, f_m_lam_bpt** |
| ``` Simple Torque Lookup ``` | **Torque table, f_tq_nl** **Torque table load breakpoints, f_tq_nl_l_bpt** **Torque table speed breakpoints, f_tq_nl_n_bpt** |

#### Air

Number of engine cylinders, $N_{c y l}$.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`NCyl`
**Values:**`4` (default) | scalar
**Data Types:**`double`

Crankshaft revolutions per power stroke, 

$$
C p s
$$

, in rev/stroke.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`Cps`
**Values:**`2` (default) | scalar
**Data Types:**`double`

Displaced volume, $V_{d}$, in m^3.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`Vd`
**Values:**`0.0015` (default) | scalar
**Data Types:**`double`

Ideal gas constant, $R_{a i r}$, in J/(kg·K).

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`Rair`
**Values:**`287` (default) | scalar
**Data Types:**`double`

Standard air pressure, $P_{s t d}$, in Pa.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`Pstd`
**Values:**`101325` (default) | scalar
**Data Types:**`double`

Standard air temperature, $T_{s t d}$, in K.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`Tstd`
**Values:**`293.15` (default) | scalar
**Data Types:**`double`

The engine volumetric efficiency lookup table, $f_{\eta_{v}}$, is a function of intake manifold absolute pressure and engine speed

where:

*   $\eta_{v}$ is engine volumetric efficiency, dimensionless.

*   _MAP_ is intake manifold absolute pressure, in KPa.

*   _N_ is engine speed, in rpm.

![Image 2: 3D plot of engine volumetric efficiency versus intake manifold absolute pressure and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_vol_eff.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_nv`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Simple
                                Speed-Density
```
.

Intake manifold pressure breakpoints for speed-density volumetric efficiency lookup table, in KPa.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_nv_prs_bpt`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Simple
                                Speed-Density
```
.

Engine speed breakpoints for speed-density volumetric efficiency lookup table, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_nv_n_bpt`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Simple
                                Speed-Density
```
.

The cylinder volume at intake valve close table (IVC), $f_{V i v c}$ is a function of the intake cam phaser angle

where:

*   $$
V_{I V C}
$$

 is cylinder volume at IVC, in L.

*   $\varphi_{I C P}$ is intake cam phaser angle in crank degrees of advance relative to the intake phaser park position.

![Image 3: Plot of cylinder volume versus intake cam phaser angle](https://www.mathworks.com/help/autoblks/ref/block_si_core_vol_ivc.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_vivc`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

Cylinder volume intake cam phase breakpoints, in L.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_vivc_icp_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

The trapped mass correction factor table, $f_{T M c o r r}$, is a function of the normalized density and engine speed

where:

*   $T M_{c o r r}$, is trapped mass correction multiplier, dimensionless.

*   $\rho_{n o r m}$ is normalized density, dimensionless.

*   _N_ is engine speed, in rpm.

![Image 4: 3D plot of trapped mass correction multiplier versus normalized density and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_tm_corr.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tm_corr`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

Normalized density breakpoints, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tm_corr_nd_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

Engine speed breakpoints, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tm_corr_n_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

The phaser intake mass flow model lookup table is a function of exhaust cam phaser angles and trapped air mass flow

where:

*   $\left(\overset{\cdot}{m}\right)_{i n t k i d e a l}$ is engine intake port mass flow at arbitrary cam phaser angles, in g/s.

*   $\varphi_{E C P}$ is exhaust cam phaser angle in crank degrees of retard relative to the exhaust phaser park position.

*   $T M_{f l o w}$ is flow rate equivalent to corrected trapped mass at the current engine speed, in g/s.

![Image 5: 3D plot of air mass flow versus exhaust cam phaser angle and flow rate equivalent](https://www.mathworks.com/help/autoblks/ref/block_si_core_air_mass_flow.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_mdot_intk`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

Exhaust cam phaser breakpoints for air mass flow lookup table, in crank degrees of retard relative to park.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_mdot_air_ecp_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

Trapped mass flow breakpoints for air mass flow lookup table, in g/s.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_mdot_trpd_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

The intake air mass flow correction lookup table, $f_{a i r c o r r}$, is a function of ideal load and engine speed

where:

*   $L_{i d e a l}$ is engine load (normalized cylinder air mass) at arbitrary cam phaser angles, uncorrected for final steady-state cam phaser angles, dimensionless.

*   _N_ is engine speed, in rpm.

*   $\left(\overset{\cdot}{m}\right)_{a i r}$ is engine intake air mass flow final correction at steady-state cam phaser angles, in g/s.

*   $\left(\overset{\cdot}{m}\right)_{i n t k i d e a l}$ is engine intake port mass flow at arbitrary cam phaser angles, in g/s.

![Image 6: 3D plot of engine intake air mass flow final correction versus engine load and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_air_mass_corr.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_mdot_air_corr`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

Engine load breakpoints for air mass flow final correction, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_mdot_air_corr_ld_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

Engine speed breakpoints for air mass flow final correction, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_mdot_air_n_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Air mass flow model** parameter, select 
```
Dual-Independent
                                Variable Cam Phasing
```
.

#### Torque

For the simple torque lookup table model, the SI engine uses a lookup table map that is a function of engine speed and load, $T_{b r a k e} = f_{T n L} \left(\right. L , N \left.\right)$, where:

*   $T_{b r a k e}$ is engine brake torque after accounting for spark advance, AFR, and friction effects, in N·m.

*   _L_ is engine load, as a normalized cylinder air mass, dimensionless.

*   _N_ is engine speed, in rpm.

![Image 7: 3D plot of engine brake torque after accounting for spark advance versus engine load and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_simp_torque.png)

The simple torque lookup model assumes that the calibration has negative torque values to indicate the non-firing engine load (L) versus speed (N) condition. The calibrated table (L-by-N) contains the non-firing data in the first table row (1-by-N). When the fuel delivered to the engine is zero, the model uses the data in the first table row (1-by-N) at or above 100 AFR. 100 AFR results from fuel cutoff or very lean operation where combustion cannot occur.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_nl`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Simple Torque Lookup`.

Engine load breakpoints, _L_, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_nl_l_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Simple Torque Lookup`.

Engine speed breakpoints, _N_, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_nl_n_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Simple Torque Lookup`.

If you select **Crank angle pressure and torque** on the block **Torque** tab, you can:

*   Simulate advanced closed-loop engine controls in desktop simulations and on HIL bench, based on cylinder pressure recorded from a model or laboratory test as a function of crank angle.

*   Simulate driveline vibrations downstream of the engine due to high-frequency crankshaft torsionals.

*   Simulate engine misfires due to lean operation or spark plug fouling by using the injector pulse width input.

*   Simulate cylinder deactivation effect (closed intake and exhaust valves, no injected fuel) on individual cylinder pressures, mean-value airflow, mean-value torque, and crank-angle-based torque.

*   Simulate the fuel-cut effect on individual cylinder pressure, mean-value torque, and crank-angle-based torque.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`EnableCrkSignalsCheckbox`
**Values:**`off` (default) | `on`
**Data Types:**`character vector`

#### Dependencies

To enable this parameter, set **Torque model** to `Torque Structure`.

Cylinder pressure table _Prs_, as a function of speed _N_, load _L_, and crank angle _M_, in Pa.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_crk_prs`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`. Select **Crank angle pressure and torque**.

Brake torque table _T brake_, as a function of speed _N_, load _L_, and crank angle _M_, in N·m.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_crk_btq`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`. Select **Crank angle pressure and torque**.

Speed breakpoints, _N_, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_crk_n_bpt`
**Values:**`[750 5000]` (default) | `1`-by-`N` vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`. Select **Crank angle pressure and torque**.

Load breakpoints, _L_. No dimension.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_crk_l_bpt`
**Values:**`[0.2 1.4]` (default) | `1`-by-`L` vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`. Select **Crank angle pressure and torque**.

Crank angle breakpoints, _M_, in deg.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_crk_ang_bpt`
**Values:**`[60 660]` (default) | `1`-by-`M` vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`. Select **Crank angle pressure and torque**.

Top dead center (TDC) compression angles by cylinder, in deg.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_crk_tdc_ang`
**Values:**`[0 540 180 360]` (default) | vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`. Select **Crank angle pressure and torque**.

The inner torque lookup table, $f_{T q i n r}$, is a function of engine speed and engine load, $T q_{i n r} = f_{T q i n r} \left(\right. L , N \left.\right)$, where:

*   $T q_{i n r}$ is inner torque based on gross indicated mean effective pressure, in N·m.

*   _L_ is engine load at arbitrary cam phaser angles, corrected for final steady-state cam phaser angles, dimensionless.

*   _N_ is engine speed, in rpm.

![Image 8: 3D plot of inner torque based on gross indicated mean effective pressure versus engine load at arbitrary cam phaser angles and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_inner_torque_table.png)

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_inr`
**Values:**array
**Data Types:**`double`

The friction torque lookup table, $f_{T f r i c}$, is a function of engine speed and engine load, 

$$
T_{f r i c} = f_{T f r i c} \left(\right. L , N \left.\right)
$$

, where:

*   $T_{f r i c}$ is friction torque offset to inner torque, in N·m.

*   _L_ is engine load at arbitrary cam phaser angles, corrected for final steady-state cam phaser angles, dimensionless.

*   _N_ is engine speed, in rpm.

![Image 9: 3D plot of friction torque offset to inner torque versus engine load at arbitrary cam phaser angles and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_friction_torque_table.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_fric`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

Engine temperature modifier on friction torque, _ƒ fric,temp_, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_fric_temp_mod`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

Engine temperature modifier breakpoints, in K.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_fric_temp_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

The pumping torque lookup table, _ƒ Tpump_, is a function of engine load and engine speed, `Tpump=ƒTpump(L,N)`, where:

*   _T pump_ is pumping torque, in N·m.

*   _L_ is engine load, as a normalized cylinder air mass, dimensionless.

*   _N_ is engine speed, in rpm.

![Image 10: 3D plot of pumping torque versus engine load and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_pump.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_pump`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

The optimal spark lookup table, $f_{S A o p t}$, is a function of engine speed and engine load, $S A_{o p t} = f_{S A o p t} \left(\right. L , N \left.\right)$, where:

*   _SA opt_ is optimal spark advance timing for maximum inner torque at stoichiometric air-fuel ratio (AFR), in deg.

*   _L_ is engine load at arbitrary cam phaser angles, corrected for final steady-state cam phaser angles, dimensionless.

*   _N_ is engine speed, in rpm.

![Image 11: 3D plot of optimal spark advance timing for maximum inner torque at stoichiometric air-fuel ratio (AFR) versus engine load and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_optimal_spark_table.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_sa_opt`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

Inner torque load breakpoints, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_inr_l_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

Inner torque speed breakpoints, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_tq_inr_n_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

The spark efficiency lookup table, $f_{M s a}$, is a function of the spark retard from optimal

where:

*   $M_{s a}$ is the spark retard efficiency multiplier, dimensionless.

*   $\Delta S A$is the spark retard timing distance from optimal spark advance, in deg.

![Image 12: Spark retard efficiency versus spark retard timing distance](https://www.mathworks.com/help/autoblks/ref/block_si_core_spark_eff_table.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_m_sa`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

Spark retard from optimal inner torque timing breakpoints, in deg.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_del_sa_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

The lambda efficiency lookup table, $f_{M \lambda}$, is a function of lambda, $M_{\lambda} = f_{M \lambda} \left(\right. \lambda \left.\right)$, where:

*   $M_{\lambda}$ is the lambda multiplier on inner torque to account for the air-fuel ratio (AFR) effect, dimensionless.

*   $\lambda$ is lambda, AFR normalized to stoichiometric fuel AFR, dimensionless.

![Image 13: Plot of lambda multiplier versus lambda](https://www.mathworks.com/help/autoblks/ref/block_si_core_lambda_eff_table.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_m_lam`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

Lambda effect on inner torque lambda breakpoints, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_m_lam_bpt`
**Values:**vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, for the **Torque model** parameter, select `Torque Structure`.

#### Exhaust

The exhaust temperature lookup table, $f_{T e x h}$, is a function of engine load and engine speed

where:

*   _T exh_ is engine exhaust temperature, in K.

*   _L_ is normalized cylinder air mass or engine load, dimensionless.

*   _N_ is engine speed, in rpm.

![Image 14: 3D plot of engine exhaust temperature versus engine speed and engine load](https://www.mathworks.com/help/autoblks/ref/block_si_core_exhaust.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_t_exh`
**Values:**array
**Data Types:**`double`

Engine load breakpoints used for exhaust temperature lookup table, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_t_exh_l_bpt`
**Values:**```
[0.2 0.275 0.35 0.425 0.5 0.575 0.65
                                        0.725 0.8 0.875 0.95 1.025 1.1 1.175 1.25]
```
 (default) | vector
**Data Types:**`double`

Engine speed breakpoints used for exhaust temperature lookup table, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_t_exh_n_bpt`
**Values:**```
[750 1053.57142857143
                                        1357.14285714286 1660.71428571429 1964.28571428571
                                        2267.85714285714 2571.42857142857 2875 3178.57142857143
                                        3482.14285714286 3785.71428571429 4089.28571428571
                                        4392.85714285714 4696.42857142857 5000]
```
 (default) | vector
**Data Types:**`double`

Exhaust gas-specific heat, $C p_{e x h}$, in J/(kg·K).

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`cp_exh`
**Values:**`1005` (default) | scalar
**Data Types:**`double`

The SI Core Engine CO 2 emission mass fraction lookup table is a function of engine torque and engine speed, _CO2 Mass Fraction_ = ƒ(_Speed_, _Torque_), where:

*   _CO2 Mass Fraction_ is the CO 2 emission mass fraction, dimensionless.

*   _Speed_ is engine speed, in rpm.

*   _Torque_ is engine torque, in N·m.

![Image 15: 3D plot of CO2 emission mass fraction versus engine speed and engine torque](https://www.mathworks.com/help/autoblks/ref/block_si_core_co2.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_CO2_frac`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, on the **Exhaust** tab, select **CO2**.

The SI Core Engine CO emission mass fraction lookup table is a function of engine torque and engine speed, _CO Mass Fraction_ = ƒ(_Speed_, _Torque_), where:

*   _CO Mass Fraction_ is the CO emission mass fraction, dimensionless.

*   _Speed_ is engine speed, in rpm.

*   _Torque_ is engine torque, in N·m.

![Image 16: 3D plot of CO emission mass fraction versus engine speed and engine torque](https://www.mathworks.com/help/autoblks/ref/block_si_core_co.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_CO_frac`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, on the **Exhaust** tab, select **CO**.

The SI Core Engine HC emission mass fraction lookup table is a function of engine torque and engine speed, _HC Mass Fraction_ = ƒ(_Speed_, _Torque_), where:

*   _HC Mass Fraction_ is the HC emission mass fraction, dimensionless.

*   _Speed_ is engine speed, in rpm.

*   _Torque_ is engine torque, in N·m.

![Image 17: 3D plot of HC emission mass fraction versus engine speed and engine torque](https://www.mathworks.com/help/autoblks/ref/block_si_core_hc.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_HC_frac`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, on the **Exhaust** tab, select **HC**.

The SI Core Engine NOx emission mass fraction lookup table is a function of engine torque and engine speed, _NOx Mass Fraction_ = ƒ(_Speed_, _Torque_), where:

*   _NOx Mass Fraction_ is the NOx emission mass fraction, dimensionless.

*   _Speed_ is engine speed, in rpm.

*   _Torque_ is engine torque, in N·m.

![Image 18: 3D plot of NOx emission mass fraction versus commanded engine torque and engine speed](https://www.mathworks.com/help/autoblks/ref/block_si_core_nox.png)

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_NOx_frac`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, on the **Exhaust** tab, select **NOx**.

The SI Core Engine PM emission mass fraction lookup table is a function of engine torque and engine speed where:

*   _PM_ is the PM emission mass fraction, dimensionless.

*   _Speed_ is engine speed, in rpm.

*   _Torque_ is engine torque, in N·m.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_PM_frac`
**Values:**array
**Data Types:**`double`

#### Dependencies

To enable this parameter, on the **Exhaust** tab, select **PM**.

Engine speed breakpoints used for the emission mass fractions lookup tables, in rpm.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_exhfrac_n_bpt`
**Values:**```
[750 1053.57142857143
                                        1357.14285714286 1660.71428571429 1964.28571428571
                                        2267.85714285714 2571.42857142857 2875 3178.57142857143
                                        3482.14285714286 3785.71428571429 4089.28571428571
                                        4392.85714285714 4696.42857142857 5000]
```
 (default) | vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, on the **Exhaust** tab, select **CO2**, **CO**, **NOx**, **HC**, or **PM**.

Engine torque breakpoints used for the emission mass fractions lookup tables, in N·m.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`f_exhfrac_trq_bpt`
**Values:**```
[0 15 26.4285714285714
                                        37.8571428571429 49.2857142857143 60.7142857142857
                                        72.1428571428571 83.5714285714286 95 106.428571428571
                                        117.857142857143 129.285714285714 140.714285714286
                                        152.142857142857 163.571428571429 175]
```
 (default) | vector
**Data Types:**`double`

#### Dependencies

To enable this parameter, on the **Exhaust** tab, select **CO2**, **CO**, **NOx**, **HC**, or **PM**.

#### Fuel

Fuel injector slope, $S_{i n j}$, mg/ms.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`Sinj`
**Values:**`6.45161290322581` (default) | scalar
**Data Types:**`double`

Air-fuel ratio, $A F R$.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`afr_stoich`
**Values:**`14.6` (default) | scalar
**Data Types:**`double`

Fuel lower heating value, _LHV_, in J/kg.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`fuel_lhv`
**Values:**`46e6` (default) | scalar
**Data Types:**`double`

Specific gravity of fuel, _Sg fuel_, dimensionless.

#### Programmatic Use

To set the block parameter value programmatically, use the [`set_param`](https://www.mathworks.com/help/simulink/slref/set_param.html) function.

To get the block parameter value programmatically, use the [`get_param`](https://www.mathworks.com/help/simulink/slref/get_param.html) function.

**Parameter:**`fuel_sg`
**Values:**`0.745` (default) | scalar
**Data Types:**`double`

## References

[1] Gerhardt, J., Hönninger, H., and Bischof, H., _A New Approach to Functional and Software Structure for Engine Management Systems — BOSCH ME7_. SAE Technical Paper 980801, 1998.

[2] Heywood, John B. _Internal Combustion Engine Fundamentals_. New York: McGraw-Hill, 1988.

## Version History

**Introduced in R2017a**

How useful was this information?

Unrated

1 star

2 stars

3 stars

4 stars

5 stars
