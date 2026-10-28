function [PB1, PB2, TB1, TB2, VB1, MB1, MB2, WORK] = sub_box(m, ...
    PB1, PB2, TB1, TB2, VB1, VB2, MB1, MB2, MIN, MO, CIN, CO, HIN, HO)
%SUB_BOX  Lumped-volume (box) step: silencer box, crankcase, or open cylinder.
%
%   [PB1, PB2, TB1, TB2, VB1, MB1, MB2, WORK] = SUB_BOX(m, ...
%       PB1, PB2, TB1, TB2, VB1, VB2, MB1, MB2, MIN, MO, CIN, CO, HIN, HO)
%
% SOURCE
%   blair_clean.bas 1384-1402  (blair_full.bas 1384-1402)
%       SUB BOX(PB1,PB2,TB1,TB2,VB1,VB2,MB1,MB2,MIN,MO,CIN,CO,HIN,HO,WORK)STATIC
%       SHARED CCV,DTM,GK,GE
%       CV1=269.49*TB1^0.1667
%       DMI=MIN*DTM
%       DME=MO*DTM
%       MB2=MB1+DMI-DME
%       EIN=DMI*(HIN+.5*CIN*CIN)
%       EO=DME*(HO+.5*CO*CO)
%       DW=PB1*(VB2-VB1)
%       TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV1*MB2)
%       CV2=269.49*TB2^0.1667
%       TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV2*MB2)
%       PB2=MB2*GK*TB2/VB2
%       WORK=(PB1+PB2)*(VB2-VB1)/2
%       PB1=PB2 : TB1=TB2 : MB1=MB2 : VB1=VB2
%       END SUB
%   Book source 28093-28118, [D8] the 15-argument 5.0 body - the only one whose
%   argument list matches PROG.5.1's three call sites.
%
% READS    m.DTM, m.GK     (SHARED)
%          PB1 TB1 MB1 VB1  state at the start of the step
%          PB2 TB2 MB2 VB2  values the caller has already prepared for the end
%                           of the step (only VB2 is really used as an input:
%                           TB2 and MB2 are overwritten, PB2 is overwritten)
%          MIN MO           signed mass flows into and out of the box [kg/s]
%          CIN CO           velocities there [m/s]
%          HIN HO           specific enthalpies there [J/kg]
% WRITES   PB2 TB2 MB2     new state; WORK = p dV work [J]
%          PB1 TB1 MB1 VB1 the rolled state (= PB2, TB2, MB2, VB2)
% LOCALS   CV1 CV2 DMI DME EIN EO DW
%
% WHY VB1 IS RETURNED - A REAL BASIC SIDE EFFECT
%   Blair's SUB arguments are passed BY REFERENCE. The tail assignment
%   VB1=VB2 therefore writes the CALLER's variable. At the crankcase call
%   (blair_clean.bas 342, VB1=VCC1, VB2=VCC2) it sets
%       VCC1 := VCC2
%   which is exactly how the crankcase volume at the start of the next step is
%   supplied: VCC2 is recomputed from HBDC at line 279 every step, so VCC1 must
%   be the previous step's VCC2. Drop this and VCC1 stays frozen at its initial
%   value (line 122), DW and WORK are formed from a stale volume, and PMEP is
%   wrong. VB1 is therefore an OUTPUT here and every call site must assign it
%   back (see SUB_CYLINDER's equivalent V1=V2, which is explicit in Blair).
%   At the exhaust-box call VB1 and VB2 are both VBOXM, so the assignment is a
%   no-op; at the cylinder call it duplicates CYLINDER's V1=V2.
%
% THE TWO TEMPERATURE PASSES
%   TB2 is solved twice: once with CV1 (cv evaluated at TB1) and once with CV2
%   (cv evaluated at the TB2 from the first pass). That is Blair's one-step
%   fixed-point iteration for the variable specific heat and must not be
%   collapsed to a single pass.
%
% SHARED CCV AND GE ARE DECLARED BUT NOT USED
%   The body uses the hard-coded CV1=269.49*T^0.1667, not CCV, and never reads
%   GE (VERIFY_STRUCTURE.md 4.2). A port that "restores" the ideal-gas forms
%   from the SHARED list would change every box temperature. Left as printed.
%
% SIGN CONVENTION
%   MIN and MO are both fed OUTFLOW's signed C, so DMI and DME carry opposite
%   signs for one physical flow. MB2=MB1+DMI-DME closes only because of that.
%   Do not take absolute values.
%
% WORK IS ZERO FOR THE TWO FIXED-VOLUME BOXES
%   Both silencer calls pass VB1=VBOXM, VB2=VBOXM, hence DW=0 and WORK=0. That
%   is why BOXW is a dead store at the exhaust-box call site.
%
% See also BLAIR_STEP, SUB_FLOW.

CV1 = 269.49*TB1^0.1667;            % 1386
DMI = MIN*m.DTM;                    % 1387
DME = MO*m.DTM;                     % 1388
MB2 = MB1 + DMI - DME;              % 1389
EIN = DMI*(HIN + .5*CIN*CIN);       % 1390
EO  = DME*(HO  + .5*CO*CO);         % 1391
DW  = PB1*(VB2 - VB1);              % 1392
TB2 = (EIN - EO + CV1*MB1*TB1 - DW)/(CV1*MB2);   % 1393
CV2 = 269.49*TB2^0.1667;            % 1394
TB2 = (EIN - EO + CV1*MB1*TB1 - DW)/(CV2*MB2);   % 1395
PB2 = MB2*m.GK*TB2/VB2;             % 1396
WORK = (PB1 + PB2)*(VB2 - VB1)/2;   % 1397

PB1 = PB2;                          % 1398
TB1 = TB2;                          % 1399
MB1 = MB2;                          % 1400
VB1 = VB2;                          % 1401  <-- writes the caller's variable

end
