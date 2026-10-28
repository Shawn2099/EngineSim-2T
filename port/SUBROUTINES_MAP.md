# Blair common subroutines — map

Companion to `blair_subroutines_basic.txt`.

* Source: `references/text/Blair,_G.P._-_The_Basic_Design_of_Two-Stroke_Engines_(SAE).txt` (31387 lines)
* Output: `port/blair_subroutines_basic.txt` (1022 lines)
* **63 subroutine entries**, **52 distinct names**, **8 unresolved markers**

Call sites quoted below are from the main programs in the same source file
(PROG.5.1/PROG.5.2 around lines 26060–26260 and 26880–27075; PROG.2.1/PROG.2.2
around 20470–20540 and 20700–20775; PROG.1.1 around 18650–18660).

Naming convention in Blair's listings: routines that end in `RETURN` are entered
with `GOSUB` and take their arguments through shared/global variables only;
routines that end in `END SUB` are entered with `CALL` and take positional
arguments.

---

## Section A — ProgList 5.1 / 5.2 common subroutines (source 27565–28192)

| name | source lines | output lines | arguments (as declared) | arguments (as called elsewhere) | what it does |
|---|---|---|---|---|---|
| TRPIPDAT | 27570–27591 | 61–69 | none (globals LTP, TRAR; label `20`) | `GOSUB TRPIPDAT` (26087, 26899) | Prompts for transfer-pipe length and transfer port/pipe area ratio; converts LTP to m in LTM. |
| INPIPDAT | 27592–27611 | 71–83 | none (globals LIP, DIP, THAR; label `21`) | `GOSUB INPIPDAT` (26089, 26901) | Prompts for inlet-pipe length, diameter and throttle area ratio; sets LIM, DIPM, FIPM. |
| COMBDAT | 27612–27648 | 85–98 | none (globals NC, NE, BEFF, BDEG, TAF; label `22`) | `GOSUB COMBDAT` (26091, 26903) | Prompts for the five combustion parameters used by `SUB CYLINDER`. |
| PORTSTART | 27649–27692 | 100–141 | none (globals EPO/EPFO/TPO/TPFO/IPO/IPFO, SCAV$) | `GOSUB PORTSTART` (26093, 26905 OCR `PORTS'! ART`) | Converts port timings to piston positions via 6× `PISTPOS`, derives EH/TR/IN heights, sets the scavenging constants MSC/CSC for the chosen SCAV$ model. |
| EXPORTSHUT | 27693–27697 | 143–147 | none (globals AKE, ME1, AE(), BE()) | `GOSUB EXPORTSHUT` (26221, 27032) | Zeroes exhaust-port flow area and mass flow while the port is shut. |
| EXPORTOPEN | 27698–27722 | 149–160 | none (globals PC1, PA, PEX, HEOT, HTDC, EXHT, FEPRT, FEP1, TC1/TCT, HE1, CE1, ME1, D, EXRATIO, MREF, DTM) | `GOSUB EXPORTOPEN` (26222, 27033) | Computes exhaust-port discharge area via `FPORT`, then in/out flow via `OUTFLOW`, and accumulates the exhaust mass-ratio EXRATIO. |
| TRPORTSHUT | 27723–27729 | 162–166 | none (globals AKT, MT1, AT(), BT()) | `GOSUB TRPORTSHUT` (26223, 27034 OCR `TRPORTSHLJT`) | Zeroes transfer-port flow area and mass flow while the port is shut. |
| TRPORTOPEN (model 1) | 27730–27747 | 170–185 | none (globals PTR, PC1R, HTOT, HTDC, TRHT, FTPRT, FTDUCT, TC1, TCC1, HT1, CT1, MT1, VC1, MSC, CSC, SCRATIO, MREF, DTM, SR, SEFF; label `911`) | `GOSUB TRPORTOPEN` (26224, 27035) | Scavenging model No.1 (Eqn.5.1.1): transfer-port discharge + outflow, volume increment, Eqn.5.1.1 scavenging efficiency SEFF. |
| TRPORTOPEN (model 2) | 27750–27771 | 189–205 | same as model 1, plus DCY, DSCAV (label `911`) | same call (26224, 27035) — only one variant is retained | Scavenging model No.2 (Eqn.5.1.13): as above but with the density-corrected EXPAND term. |
| INPORTSHUT | 27772–27776 | 207–211 | none (globals AKI, MI1, AI(), BI()) | `GOSUB INPORTSHUT` (26226, 27037) | Zeroes inlet-port flow area and mass flow while the port is shut. |
| INPORTOPEN | 27777–27791 | 213–224 | none (globals PCC1, PA, PIR, FIPRT, HTDC, HIOT, INHT, TCC1, TIREF, HI1, CI1, MI1, D, DRATIO, MREF, DTM) | `GOSUB INPORTOPEN` (26225, 27036 OCR `1NPORTOPEN`) | Inlet-port discharge area via `FPORT`, then `OUTFLOW` or `INFLOW` depending on flow direction; accumulates DRATIO. |
| ENGINEDAT | 27792–27834 | 226–253 | none (globals BO, ST, CRL, RPM, TCR, CCR, TEXC; label `15`) | `GOSUB ENGINEDAT` (26073, 26883, 29516, 29907) | Prompts for the basic engine geometry/speed/compression ratios and derives BOM, STM, CRLM, RPS, FPISTON, SV, CCCV, CRNK, FMEP, TEREF. |
| EXPORTDAT | 27835–27867 | 255–273 | none (globals EPO, EPFO, NEP, WEP, RTE, RBE; label `16`) | `GOSUB EXPORTDAT` (26079, 26889) | Prompts for exhaust-port timing/count/width/radii; converts widths and radii to m. |
| TRPORTDAT | 27868–27903 | 275–296 | none (globals TPO, TPFO, NTP, WTP, RTT, RBT, SCAV$; label `17`) | `GOSUB TRPORTDAT` (26081, 26891) | Prompts for transfer-port timing/count/width/radii and the scavenging model name; converts to m. |
| INPORTDAT | 27904–27933 | 298–316 | none (globals IPO, IPFO, NIP, WIP, RTI, RBI; label `18`) | `GOSUB INPORTDAT` (26083, 26893) | Prompts for inlet-port timing/count/width/radii; converts to m. |
| CYLSTART | 27934–27945 | 318–328 | none (globals TEXC, GE, GK, PA) | `GOSUB CYLSTART` (26132, 26945) | Sets the three reference temperatures and the corresponding reference densities and acoustic speeds. |
| FPORT | 27946–27950 | 330–334 | `HOT, HTDC, PHT, FPRT, FPIP, AK, CC` | `CALL FPORT(HEOT,HTDC,EXHT,FEPRT,FEP1,AKE,CCE)` (27705); `CALL FPORT(HTOT,HTDC,TRHT,FTPRT,FTDUCT,AKT,CCT)` (27733); `CALL FPORT(HTDC,HIOT,INHT,FIPRT,FIPRT,AKI,CCI)` (27781) | Linear port-opening ramp: AK = CC·FINST·FPRT/FPIP, with FINST = (HTDC−HOT)/PHT clipped at 1. |
| STAB | 27951–27963 | 336–345 | `A(), B(), K, S, E` | `CALL STAB(AE(),BE(),KE1,SDE,LEM1)` (26183/26184); `CALL STAB(AET(),BET(),KE2,SDE,LEM2)` (26180); `CALL STAB(AT(),BT(),KT,SDT,LTMESH)` (26181); `CALL STAB(AI(),BI(),KI,SDI,LIMESH)` (26182) | Computes the stable Courant-limited DZ over all meshes, then DC (crank degrees/step) and DTM (time/step). |
| SETS | 27964–27969 | 347–352 | `A(), B(), K` | `CALL SETS(AE(),BE(),KE1)` (26159); `CALL SETS(AET(),BET(),KE2)` (26160); `CALL SETS(AT(),BT(),KT)` (26161); `CALL SETS(AI(),BI(),KI)` (26162); 5.2: `CALL SETS(AE(),BE(),K6)` / `(AT(),BT(),KT)` / `(AI(),BI(),KI)` (26977–26983) | Initialises K right- and left-going characteristic meshes to unity. |
| AREA | 27970–27980 | 354–364 | `DA, DB, KA, KB, DF(), F()` | `CALL AREA(DE1M,DE1M,K0,KE1,DFE(),FE())` (26984); `CALL AREA(DE2M,DE2M,K0,KE2,DFET(),FET())` (26163); `CALL AREA(DTDUCT,DTDUCT,K0,KT,DFT(),FT())` (26165); `CALL AREA(DIPRT,DIPM,K0,KI,DFI(),FI())` (26166) | Fills duct area F() by linear taper from diameter DA at KA to DB at KB, and the area differences DF(). |
| PIPE | 27981–28018 | 366–399 | `KA, KB, A(), B(), DF(), F()` (+ SHARED DZ, A2(), B2()) | `CALL PIPE(K0,KE1,AE(),BE(),DFE(),FE())` (26200); `(K0,KE2,AET(),BET(),DFET(),FET())` (26201); `(K0,KT,AT(),BT(),DFT(),FT())` (26202); `(K0,KI,AI(),BI(),DFI(),FI())` (26203); 5.2 same four at 27019–27021 with K6 | Two-characteristic mesh gas-dynamics step for one pipe (labels 23/33/44/55). |
| SHOK | 28019–28033 | 401–415 | `A(), B(), KA, KB` | `CALL SHOK(AE(),BE(),K0,KE1)` (26227); `(AET(),BET(),K0,KE2)` (26228); `(AT(),BT(),K0,KT)` (26229); `(AI(),BI(),K0,KI)` (26230); 5.2 same four at 27038–27040 | Applies the Hartree/Blair shock-fitting correction across the interface when |R1| ≥ 1 (labels 26/56). |
| PORT | 28034–28048 | 417–431 | `A, B, P, AK` (+ SHARED ABX(), BX(), AKA(), PA) | `CALL PORT(BE(KE1),AE(KE1),PB1,AK)` (26207); `CALL PORT(AET(1),BET(1),PB1,AK)` (26210); `CALL PORT(BET(KE2),AET(KE2),PA,AK)` (26213); `CALL PORT(BI(KI),AI(KI),PA,AK)` (26215); `CALL PORT(BT(KT),AT(KT),PCC1,AK)` (26220); 5.2 at 27024/27026/27031 | Port reflectivity: bilinear interpolation in the UFLO table over (AK, B/X1) to return the reflected characteristic A. |
| NINT | 28049–28059 | 433–441 | `K1, PL, TE, TP` (+ SHARED LMESH) | `CALL NINT(KE1,LEP1,TEREF,TEREF)` (26151); `CALL NINT(KE2,LEP2,TEREF,TEREF)` (26152); `CALL NINT(KT,LTP,TEREF,TTREF)` (26153); `CALL NINT(KI,LIP,TEREF,TIREF)` (26154); 5.2 `CALL NINT(KQ1,LP01,TEREF,TEREF)` … (26961–26973) | Chooses the number of meshes for a duct from the temperature ratio: RI = PL·√(TE/TP)/LMESH, rounded. |
| OUTFLOW | 28060–28076 | 443–458 | `A, B, F, TR, H, C, M, D, CD` (+ SHARED GK, GE, PA) | `CALL OUTFLOW(AE(KE1),BE(KE1),FEP1,TC1,HEK1,CEK1,MEK1,D,CD)` (26238); `CALL OUTFLOW(AET(1),BET(1),FEP2,TB1,HET1,CET1,MET1,D,GD)` (26241); `OUTFLOW(BT(KT),AT(KT),FTDUCT,TCC1,HTKT,CTKT,MTKT,D,CD)` (26234–26235, 27044–27045) | Non-steady outflow at a restriction: superposition temperature, stagnation enthalpy, density and mass flow for a left/right-going pair. |
| INFLOW | 28077–28092 | 460–474 | `A, B, F, TR, H, C, M, D, CD` (+ SHARED GK, GE, PA) | `CALL INFLOW(BI(1),AI(1),FIPRT,TIREF,HI1,CI1,MI1,D,CDI)` (27787–27789) — the only call site in the whole listing | Non-steady inflow at a restriction: as OUTFLOW but with the inflow (2.5·SD) velocity and PR/PL pulse ratios. |
| BOX | 28093–28118 | 476–494 | `PB1, PB2, TB1, TB2, VB1, VB2, MB1, MB2, MIN, MO, CIN, CO, HIN, HO, WORK` (+ SHARED CCV, DTM, GK, GE) | `CALL BOX(PB1,PB2,TB1,TB2,VBOXM,VBOXM,MB1,MB2,MEK1,MET1,CEK1,CET1,HEK1,HET1,BOXW)` (26242–26243); `BOX(PCC1,PCC2,TCC1,TCC2,VCC1,VCC2,MCC1,MCC2,MI1,MTKT,CI1,CTKT,HI1,HTKT,CCWORK)` (26245–26246); `BOX(PC1,PC2,TC1,TC2,VC1,VC2,MC1,MC2,MT1,ME1,CT1,CE1,HT1,HE1,CYWORK)` (26252); 5.2 at 27046–27047, 27053–27054 | Single-zone (crankcase or airbox) energy/mass step: mass balance, first-law temperature (twice, with CV1 then CV2), pressure from the perfect-gas law, and the work term. |
| BELMOUTH | 28119–28123 | 496–500 | `B, A, PA` | **never called from PROG.5.1/5.2**; only `CALL BELMOUTH(BE(KE),AE(KE),PA)` (20748, PROG.2.2) | Bellmouth reflection: solves the cubic for N and returns B = 2N−1 (PA is declared but not referenced). |
| PISTPOS | 28124–28129 | 502–507 | `S, R, C, D, HT, HB` (+ SHARED DTOR) | `CALL PISTPOS(STM,CRNK,CRLM,DEG,HTDC,HBDC)` (26196, 27015); 6 calls in PORTSTART (27668–27677) | Piston position from crank angle: converts D degrees to radians via DTOR, returns HT (from TDC) and HB (from BDC). |
| PAREA | 28130–28135 | 509–513 | `NP, WP, HP, RT, RB, FP, DP` (+ SHARED PI) | `CALL PAREA(NEP,WEPM,EXHT,RTEM,RBEM,FEPRT,DEPRT)` (26097); `CALL PAREA(NTP,WTPM,TRHT,RTTM,RBTM,FTPRT,DTPRT)` (26098); `CALL PAREA(NIP,WIPM,INHT,RTIM,RBIM,FIPRT,DIPRT)` (26099) | Port effective area from NP identical ports of width WP and height HP with corner radii RT/RB, and the equivalent diameter DP. |
| CYLINDER | 28136–28192 | 515–568 | `P1, P2, T1, T2, V1, V2, MC, WORK` (+ 20 SHARED names) | `CALL CYLINDER(PC1,PC2,TC1,TC2,VC1,VC2,MC2,CYWORK)` (26249–26250, 27051–27052) | Cylinder closed-period step: polytropic compression/expansion or Rassweiler–Withrow heat release, scavenging efficiency, peak-pressure and peak-temperature tracking (labels 20/30/50/60/70/80/90). |

---

## Section B1 — ProgList 2.1 / 2.2 common subroutines (source 20836–21266)

### B1a — screen/printer plot routines (entered with GOSUB, no arguments)

| name | source lines | output lines | arguments (as declared) | arguments (as called elsewhere) | what it does |
|---|---|---|---|---|---|
| ASET | 20840–20855 | 580–595 | none (globals XA1/XA2/XMH/KE, XAM(), XM(), PK, YA1/YA2/YA3, Y15, Y5) | `GOSUB ASET` (20481, 20711, 21095) | Sets up panel (a): crank-angle abscissa array XAM/XM and the pressure-ratio ordinate scale. |
| ABLACK | 20856–20871 | 597–610 | none (globals PS(), YAM(), XAM(), XA1..YA3) | `GOSUB ABLACK` (20535, 20767, 21101) | Draws panel (a) axes and the black pressure-ratio trace PS(). |
| AWHITE | 20872–20876 | 612–616 | none (globals XAM(), YAM(), KE) | `GOSUB AWHITE` (20526, 20763) | Erases (redraws in colour 30) the panel (a) trace before the next cycle. |
| BSET | 20877–20888 | 618–629 | none (globals XA1, XA2, YA3, …) | `GOSUB BSET` (20482, 20712, 21096) | Sets up panel (b): the gas-particle Mach-number diagram box. |
| BBLACK | 20889–20908 | 631–650 | none (globals MN(), MM(), YM(), AKD, MRAT, YB8) | `GOSUB BBLACK` (20536, 20768, 21102) | Draws panel (b) box and the Mach-number arrows via `ARROB`. |
| BWHITE | 20909–20919 | 652–658 | none (globals YM(), MM()) | `GOSUB BWHITE` (20527, 20764) | Erases the panel (b) arrows via `ARROW`. |
| ARROB | 20920–20930 | 660–670 | none (globals XMH, MN(J), XM(), YM(), ZM; labels 216/217) | `GOSUB ARROB` from BBLACK (20904) | Draws one black Mach-number arrow for mesh J (direction from sign of MN(J)). |
| ARROW | 20931–20940 | 672–681 | none (globals MM(J), XM(), YM(), ZM; labels 218/219) | `GOSUB ARROW` from BWHITE (20911) | Draws one white/colour-30 Mach-number arrow for mesh J (direction from sign of MM(J)). |
| CLOCK | 20941–20946 | 683–688 | none (globals CYC, DEG, MRAT, PCYR) | `GOSUB CLOCK` (20530, 20766, 21100) | Prints the cycle number, crank angle, cylinder mass ratio and cylinder pressure. |
| CSET | 20947–20963 | 690–704 | none (globals XC1/XC2/XMHC, XCM(), PK, YC1/YC2/YC3) | `GOSUB CSET` (20483, 20713, 21097) | Sets up panel (c): the outwards-pulse pressure-ratio diagram. |
| CBLACK | 20964–20975 | 706–717 | none (globals PR(), YCM(), XCM()) | `GOSUB CBLACK` (20537, 20769, 21103) | Draws panel (c) axes and the outwards-pulse trace PR(). |
| CWHITE | 20976–20980 | 719–723 | none (globals XCM(), YCM()) | `GOSUB CWHITE` (20528, 20765) | Erases the panel (c) trace. |
| DSET | 20981–20995 | 725–739 | none (globals XC1/XMHC/XCM(), PK, YC3) | `GOSUB DSET` (20484, 20714, 21098) | Sets up panel (d): the inwards-pulse pressure-ratio diagram. |
| DBLACK | 20996–21015 | 741–756 | none (globals PL(), YDM(), XDM()) | `GOSUB DBLACK` (20538, 20772, 21104) | Draws panel (d) axes, its three ratio labels, and the inwards-pulse trace PL(). |
| DWHITE | 21016–21020 | 758–762 | none (globals XDM(), YDM()) | `GOSUB DWHITE` (20529) | Erases the panel (d) trace. |
| ESET | 21021–21046 | 764–788 | none (globals PCY, DEG) | `GOSUB ESET` (20485, 20715, 21099) | Sets up panel (e): the cylinder-pressure vs crank-angle trace and its 90/180/270/360° tick marks. |
| EBLACK | 21047–21069 | 790–810 | none (globals PS(1), PCYR, DEG, COUNT, PCOUNT, XG(), YGPC(), YGPP(), XEO/YSO/YCO; labels 503/511) | `GOSUB EBLACK` (20539, 20773, 21105) | Extends the panel (e) cylinder-pressure trace by one crank-angle increment. |
| NSET | 21070–21074 | 812–816 | none (globals TC1/TC2, PC1/PC2, MC1/MC2) | `GOSUB NSET` (20519, 20755) | Rolls the previous step's state into the "1" slots (TC1←TC2, PC1←PC2, MC1←MC2). |
| START | 21075–21083 | 818–826 | none (globals PCYL, TCYL, MCYL, XE1, PCY, DEG, CYC) | `GOSUB START` (20495, 20727) — `IF DEG>360 THEN GOSUB START` | Starts a new cycle: reloads cylinder state from PCYL/TCYL/MCYL, resets XEO/YC0, DEG−=360, CYC+=1. |
| CLIPDRAW | 21084–21113 | 828–853 | none (globals DEG, DEGTRIP, COUNT, PR$, ZS; label 509) | `GOSUB CLIPDRAW` (20498, 20730) — `IF CYC=CYCTRIP THEN GOSUB CLIPDRAW` | One-off hard-copy dump: asks Y/N, opens LPT1:, replays all ASET..EBLACK panels to the printer. |

### B1b — SUB blocks (entered with CALL)

| name | source lines | output lines | arguments (as declared) | arguments (as called elsewhere) | what it does |
|---|---|---|---|---|---|
| EXPORT | 21114–21120 | 855–861 | `DEG, DEO, AKD, AKM` | `CALL EXPORT(DEG,DEO,AKD,AKM)` (20514, 20750) | Ramps the exhaust-port area ratio AKD up and back down between 0 and AKM across the exhaust open period DEO. |
| STAB | 21121–21131 | 863–873 | `A(), B(), K, S, E` (+ SHARED DZ, DTM, DC, RPM) | `CALL STAB(AE(),BE(),KE,SDE,LEM)` (20492, 20720) | As section A, but initialises DZ=1 before scanning the meshes. |
| SETS | 21132–21137 | 875–880 | `A(), B(), K` | `CALL SETS(AE(),BE(),KE)` (20477, 20707) | Initialises K right- and left-going characteristic meshes to unity. |
| AREA | 21138–21148 | 882–892 | `DA, DB, KA, KB, DF(), F()` | `CALL AREA(DEPM,DEPM,KE1,KE,DFE(),FE())` (20479, 20709) | Fills duct area F() by linear taper and the area differences DF(). |
| PIPE | 21149–21184 | 894–927 | `KA, KB, A(), B(), DF(), F()` (+ SHARED DZ, A2(), B2()) | `CALL PIPE(KE1,KE,AE(),BE(),DFE(),FE())` (20499, 20731) | Two-characteristic mesh gas-dynamics step (labels 22/33/44/55). |
| SHOK | 21185–21199 | 929–943 | `A(), B(), KA, KB` | `CALL SHOK(AE(),BE(),KE1,KE)` (20524, 20760) | Shock-fitting correction across interfaces (labels 26/56). |
| PORT | 21200–21218 | 945–959 | `A, B, P, AK` (+ SHARED ABX(), BX(), AKA(), PA) | `CALL PORT(BE(KE),AE(KE),PA,AKO)` (20512, 20746); `CALL PORT(AE(1),BE(1),PC1,AKD)` (20515, 20751) | Port reflectivity by bilinear interpolation in the UFLO table. |
| NINT | 21219–21226 | 961–968 | `KI, PL, TE, TP` (no SHARED) | `CALL NINT(KE,LEP,TREF,TREF)` (20471, 20701) | Chooses mesh count: RI = PL·√(TE/TP)/30, rounded, then KI+=1. |
| FLOW | 21227–21242 | 970–985 | `A(), B(), KA, KB, F, PS(), PR(), PL(), MN()` (+ SHARED TREF, DREF, DA, SDE, TEP, MEP, CEP, GR) | `CALL FLOW(AE(),BE(),KE1,KE,FEP,PS(),PR(),PL(),MN())` (20516, 20752) | Whole-pipe post-processing: fills the pressure-ratio and Mach-number arrays used by the plot routines, and picks up the end values CEP/TEP/MEP. |
| BOX | 21243–21258 | 987–1000 | `PB1, PB2, TB1, TB2, VB, MB1, MB2, MDE, CE, TE` (+ SHARED CCP, CCV, DTM; label 103) | `CALL BOX(PC1,PC2,TC1,TC2,VC1,MC1,MC2,MEP,CEP,TEP)` (20517, 20753) | Simplest box energy step (no work term, no duct velocity): iterates twice (label 103) on TB2 then PB2. |
| BELMOUTH | 21259–21266 | 1002–1008 | `B, A, PA` | `CALL BELMOUTH(BE(KE),AE(KE),PA)` (20748) | Bellmouth reflection B = 2N−1 (PA declared but not referenced). |

---

## Section B2 — SUB PISTPOS, ProgList 1.1 definition (source 18704–18707)

| name | source lines | output lines | arguments (as declared) | arguments (as called elsewhere) | what it does |
|---|---|---|---|---|---|
| PISTPOS | 18704–18707 | 1015–1018 | `S, R, C, A, HT, HB` (no SHARED DTOR) | `CALL PISTPOS(ST,CRNK,CRL,ANGR,HT,HB)` (18659, PROG.1.1) | Piston position from crank angle **A already in radians**: HT = R+C−R·cos A−√(C²−(R·sin A)²), HB = S−HT. |

---

## Argument mismatches and call-site discrepancies

Every row below is a place where the declaration and the call site do not agree,
or where the same name is declared twice with incompatible signatures.

### 1. `BOX` — two incompatible declarations under one name  **[hard mismatch]**

| | Section A | Section B1 |
|---|---|---|
| declaration | `(PB1,PB2,TB1,TB2,VB1,VB2,MB1,MB2,MIN,MO,CIN,CO,HIN,HO,WORK)` — **15** | `(PB1,PB2,TB1,TB2,VB,MB1,MB2,MDE,CE,TE)` — **10** |
| call sites | 15 args (26242–26243, 26245–26246, 26252, 27046–27047, 27053–27054) | 10 args (20517, 20753) |

Each call site matches its own declaration, but the two are not compatible: A has
two volumes `VB1,VB2`, B1 has one `VB`; A's 9th/10th are mass flows `MIN,MO`,
B1's 9th/10th are `MDE,CE`. A program cannot link both.

### 2. `BOX` (B1) — declared parameters are incomplete  **[hard mismatch]**

`SUB BOX(PB1,PB2,TB1,TB2,VB,MB1,MB2,MDE,CE,TE)` uses three quantities that are
neither positional parameters nor in its `SHARED CCP,CCV,DTM` list:

* `DMI=MDI*DTM` — `MDI` (inlet mass flow) is never supplied (only `MDE` exists)
* `EI=DMI*(CCP*TI+.5*CI*CI)` — `TI` (inlet total temperature) is never supplied
* and `CI` (inlet velocity) is never supplied

The call site passes exactly 10 arguments, so three required inputs are missing.

### 3. `PISTPOS` — two incompatible declarations under one name  **[hard mismatch]**

| | Section A (28124) | Section B2 (18704) |
|---|---|---|
| declaration | `(S,R,C,D,HT,HB)` + `SHARED DTOR`, with `A=D*DTOR` | `(S,R,C,A,HT,HB)`, no `DTOR` |
| 4th argument | degrees | radians |
| call sites | `CALL PISTPOS(STM,CRNK,CRLM,DEG,HTDC,HBDC)` (26196, 27015) and `PORTSTART` passing EPO/EPFO/TPO/TPFO/IPO/IPFO — all **degrees** | `CALL PISTPOS(ST,CRNK,CRL,ANGR,HT,HB)` (18659) |

Same arity, same order, different units. Mixing the two definitions silently
returns a piston position near TDC's complement.

### 4. `NINT` — same arity, different dummy name and different number of outputs

Both versions take `(K, PL, TE, TP)` and every call site passes 4 arguments, so
arity is fine. But:

* Section A declares `K1` and also divides by `SHARED LMESH`; it writes **two**
  variables (`KI=KI+1` then `K1=KI+1`). Because 5.1/5.2 call it as
  `CALL NINT(KI,...)` / `CALL NINT(KE1,...)`, the caller's variable is incremented
  **twice**.
* Section B1 declares `KI`, divides by the literal `30`, and writes **one**
  variable. The caller's variable is incremented once.

### 5. `BELMOUTH` — declared argument never used

`SUB BELMOUTH(B,A,PA)` never references `PA`. Both declarations are identical and
both call sites (`20748`) pass `PA`, so this is harmless, but `PA` is dead.

### 6. `TRPORTOPEN` — one call site, two definitions

`GOSUB TRPORTOPEN` (26224, 27035) resolves to two different bodies (27730–27747
and 27750–27771). Only one may be present at link time.

### 7. `EXPORTOPEN` — call site variable undefined elsewhere

`CALL OUTFLOW(AE(1),BE(1),FEP1,TCT,HE1,CE1,ME1,D,CDE)` (27705, output line 158)
passes `TCT`, which appears nowhere else. The branch above it passes `TC1` and the
transfer/inlet equivalents pass `TC1`/`TCC1`. Marked `<UNRESOLVED>` in the output.

### 8. `INPORTOPEN` — same array passed twice into two different formals

`CALL FPORT(HTDC,HIOT,INHT,FIPRT,FIPRT,AKI,CCI)` (27781, output line 216) passes
`FIPRT` as both `FPRT` and `FPIP`, so the internal ratio `FPRT/FPIP` is always 1
and `AK = CC*FINST`. Exhaust and transfer passes pass two genuinely different
areas (`FEPRT/FEP1`, `FTPRT/FTDUCT`). This is what the book prints; it may be a
deliberate simplification or a transcription slip in the original.

### 9. `CYLINDER` — variable used but not in the SHARED list

`DPMAX` is read and written (`IF DELTAP>DPMAX THEN DPMAX=DELTAP`) but is absent
from the two `SHARED` statements, so it is local to `CYLINDER` and the caller
never sees it. All other written results (`PMAX`, `TKMAX`, `MAXDEG`, `CEFF`,
`TEFF`) are shared.

### 10. `STAB` — same signature, different body

Section A's `STAB` omits the `DZ=1` initialisation that Section B1 performs.
In Section A, `DZ` is therefore whatever the caller last left in it (a shared
variable), which makes the first `IF Z<DZ THEN DZ=Z` comparison depend on history.

### 11. `AREA`, `PIPE`, `PORT` — shared arrays not declared here

`SUB PIPE` uses `SHARED A2(),B2()`; `SUB PORT` uses `SHARED ABX(),BX(),AKA()`.
None of these are dimensioned or loaded anywhere inside either common block. The
caller must `DIM ABX(21,45),BX(45),AKA(45)` and load them from the `UFLO` file
(the only place this is shown is PROG.2.3, source 21270–21278).

### 12. `CLIPDRAW` calls two routines that are not in the block

`GOSUB DATASET` and `GOSUB SCALE` (21093–21094, output lines 842–843). `SCALE`
is the last routine of PROG.2.1's own text and ends at source 20835, one line
before the common block starts; `DATASET` is defined in each program.

---

## Subroutines referenced but **not present** in these blocks

| name | referenced at | where it actually lives |
|---|---|---|
| `EXPIPDAT` | `GOSUB EXPIPDAT` (26085, PROG.5.1) | inside PROG.5.1, source 26425 |
| `EXLENDAT` | `GOSUB EXLENDAT` (26895, PROG.5.2) | inside PROG.5.2, source 27224 |
| `EXDIADAT` | `GOSUB EXDIADAT` (26897, PROG.5.2) | inside PROG.5.2, source 27255 |
| `DATASET` | `GOSUB DATASET` (21093, 204?/207? in 2.1/2.2) | per-program |
| `SCALE` | `GOSUB SCALE` (21094) | PROG.2.1/2.2, ends at source 20835 |
| `FILED`, `FILING`, `FILESET` | `GOSUB …` throughout | per-program |
| `DATASETL`, `DATOUT`, `PRINTOUT` | `GOSUB …` (26323–26324, 27117–27118) | per-program |

None of these are part of either "COMMON SUBROUTINES" block, so their absence
here is expected — but `EXPIPDAT` in particular is easy to miss, because it sits
between `INPORTDAT` and `TRPIPDAT` in the data-entry menu yet is *not* in the
common block, while its neighbours are.

---

## Counts

| | entries | notes |
|---|---|---|
| Section A (27565–28192) | 31 | 16 labelled GOSUB routines + 15 SUB blocks; `TRPORTOPEN` counted twice |
| Section B1 (20836–21266) | 31 | 20 GOSUB routines + 11 SUB blocks |
| Section B2 (18704–18707) | 1 | `PISTPOS`, second definition |
| **total entries** | **63** | |
| **distinct names** | **52** | 11 names are declared twice (9 across A/B1, plus `TRPORTOPEN` and `PISTPOS`) |

* Output file: 1022 lines
* `<UNRESOLVED>` markers: 8 (the header legend line that spells out the marker form
  is not counted)

| # | output line | routine | issue |
|---|---|---|---|
| 1 | 158 | `EXPORTOPEN` | `TCT` passed to `OUTFLOW` — defined nowhere else; probably `TCC1` |
| 2 | 538 | `CYLINDER` | `IF DEGC<IGN THEN GOTO 20` — source prints `DEGOIGN`, operator illegible, branch unreachable either way |
| 3 | 554 | `CYLINDER` | `TRM1=(GE+1)*V2/(2*(GE-1))-VR` — trailing `-VR` may belong to the next expression; immediately overwritten |
| 4 | 708 | `CBLACK` | `YCM(J)=INT(YA1-...)` — should probably be `YC1`; glyphs read `YA1` |
| 5 | 823 | `START` | `YC0` (zero) vs `YCO` (letter O) in ESET/EBLACK |
| 6 | 991 | `BOX` (B1) | `MDI` neither parameter nor SHARED |
| 7 | 994 | `BOX` (B1) | `TI`, `CI` neither parameters nor SHARED |
| 8 | 998 | `BOX` (B1) | `PB2=(MB2*TB2*PB1*VB)/(MB1*TB1*VB)` — `VB` cancels exactly |
