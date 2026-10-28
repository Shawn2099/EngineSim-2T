function m = sub_cylinder(m)
%SUB_CYLINDER  Closed-cycle combustion and heat-release step.  SUB CYLINDER.
%
%   m = SUB_CYLINDER(m)
%
% SOURCE
%   blair_clean.bas 1541-1600  (blair_full.bas 1436-1496)
%       SUB CYLINDER(P1,P2,T1,T2,V1,V2,MC,WORK)STATIC
%       SHARED GK,GE,NE,NC,DEG,SEFF,DC,BEFF,BDEG,TAF,CVAL,EPC,PA
%       SHARED PMAX,TKMAX,MAXDEG,MREF,CEFF,TEFF,DRAT
%       ... (see the line-by-line comments in the body)
%       END SUB
%   Book source 28136-28192. Called only while HTDC<=HEOT (exhaust port shut).
%   Labels 20 and 50 are C20 and C50 in blair_clean.bas [FIX2].
%
% READS  (SHARED)  m.GK m.GE m.NE m.NC m.DEG m.SEFF m.DC m.BEFF m.BDEG m.TAF
%                  m.CVAL m.EPC m.MREF m.DRAT   (m.PA is declared SHARED and
%                  never used - VERIFY_STRUCTURE.md 4.2)
%        (ARGS)    m.PC1 m.TC1 m.VC1  [P1 T1 V1]  and m.MC2 [MC]
% WRITES (SHARED)  m.PMAX m.TKMAX m.MAXDEG m.CEFF m.TEFF
%        (ARGS)    m.PC2 m.TC2 m.CYWORK [P2 T2 WORK], and rolls
%                  m.PC1 m.TC1 m.VC1  (P1=P2, T1=T2, V1=V2 at 1593-1595)
% STATIC LOCALS    m.cyl.*  - see below
%
% ---------------------------------------------------------------------------
% THE STATIC LOCALS - THE POINT OF THE WHOLE ROUTINE
% ---------------------------------------------------------------------------
% Frozen decision [FIX4] in blair_clean.bas: SUBs are STATIC, so these persist
% between calls. They are zeroed once at program start and never re-zeroed.
% They are private to CYLINDER: in particular CYLINDER's HT1 is NOT the main
% module's HT1 (the transfer-port enthalpy written at blair_clean.bas 1005/1006
% and consumed by BOX at 344). Aliasing them is [D15]'s failure mode, which
% would integrate QHT = DC*(1e6 + HT2)/2 on the first closed-cycle step of every
% cycle. They live in m.cyl and are copied in at the top and out at the bottom
% so that the body reads exactly like Blair's source.
%
%   HT1       read at 1576 (QHT=DC*(HT1+HT2)/2), written at 1596 (HT1=HT2).
%             Because it holds the PREVIOUS call's HT2, the heat integration is
%             the TRAPEZOIDAL rule. Under automatic locals it would be a
%             rectangle rule and total heat release would change by roughly a
%             factor of two - hence PMAX, TKMAX, IMEP.
%   HT2       assigned only on the combustion path (1570, 1573, 1575). On the
%             two GOTO 90 paths it keeps the previous call's value. Only STATIC
%             makes that well defined.
%   DELTAP    written only when P2>P1 (1588), then compared with DPMAX (1592).
%             VERIFY_STRUCTURE.md 4.3 calls DELTAP "always assigned before use";
%             under the frozen STATIC reading that is not true, and it persists.
%   DPMAX     the accumulating diagnostic [D16]. Never read by any caller.
%   IGN BURNEND TAILDEG PEAK TAFB HEAT QMAX S1 S2 S3 MAIR POLYINDEX
%             for a call with DEGC > EPC+5 the block at 1443-1456 is skipped
%             (line 1442 jumps straight to label 30), yet IGN/BURNEND/... are
%             still READ at 1457-1458 and the S1/S2/S3 set is still USED inside
%             the combustion window. So they are the previous call's values.
%             This is a genuine (if small) numerical property of the printed
%             code: for EPC+5 < DEGC < IGN+BDEG the heat release uses the
%             S1/S2/S3 computed from the last MAIR, not the current one.
%
% ---------------------------------------------------------------------------
% CONTROL FLOW
% ---------------------------------------------------------------------------
% Every GOTO in this routine is forward, so the label graph is written as
% nested if/else with the original label named in a comment:
%   1442 -> 30      1465 -> 90 (polytropic)      1467 -> C50 (work)
%   1468 -> C20     1471 -> 60   1472 -> 70      1470/1473 -> 80 (QHT)
%   1459-1464 is the illegible [D25] test; it is dead under every reading,
%   because label 30 has already branched away on DEGC<=IGN and 1458 has already
%   branched away on DEGC>=BURNEND. The C20 path is therefore reached through
%   1464 (DEGC<=BURNEND, always true there) and the 1463 test never fires.
%
% POLYINDEX is set by two separate IFs (1440/1441), not by if/else, so that a
% DEGC exactly 360 takes NC: both statements are reproduced.
%
% See also BLAIR_STEP, SUB_BOX.

% ---- CYLINDER's STATIC locals, in --------------------------------------
c = m.cyl;
HT1 = c.HT1;   HT2 = c.HT2;   DPMAX = c.DPMAX;   DELTAP = c.DELTAP;
POLYINDEX = c.POLYINDEX;   MAIR = c.MAIR;
IGN = c.IGN;   BURNEND = c.BURNEND;   TAILDEG = c.TAILDEG;   PEAK = c.PEAK;
TAFB = c.TAFB; HEAT = c.HEAT; QMAX = c.QMAX;
S1 = c.S1;     S2 = c.S2;     S3 = c.S3;

% ---- the call-by-reference arguments -----------------------------------
DEGC = m.DEG;                              % 1439
P1 = m.PC1;  P2 = m.PC2;                   % P1/P2 are module globals
T1 = m.TC1;  T2 = m.TC2;
V1 = m.VC1;  V2 = m.VC2;
MC = m.MC2;                                % passed as MC2, not MC1

% ---- 1440-1441 --------------------------------------------------------
if DEGC <= 360
    POLYINDEX = m.NC;
end
if DEGC > 360
    POLYINDEX = m.NE;
end

% ---- 1442: IF DEGC>EPC+5 THEN GOTO 30 ---------------------------------
if DEGC <= m.EPC + 5
    % 1443-1456: gas exchange and the heat-release schedule
    MAIR    = m.SEFF*MC;                        % 1443
    m.CEFF  = MAIR/m.MREF;                      % 1444
    m.TEFF  = MAIR/(m.DRAT*m.MREF);             % 1445
    IGN     = 360 - m.BDEG/6;                   % 1446
    BURNEND = IGN + m.BDEG;                     % 1447
    TAILDEG = BURNEND - m.BDEG/3;               % 1448
    PEAK    = IGN + m.BDEG/3;                   % 1449
    TAFB    = 13;                               % 1450
    if m.TAF > TAFB
        TAFB = m.TAF;                           % 1451
    end
    % *** SOURCE REPAIR, VERIFIED AGAINST THE BOOK PAGE (book p.603) ***
    % blair_clean.bas 1452 reads  HEAT=BEFF*CVAL*MAIR^TAFB
    % The printed page reads        HEAT=BEFF*CVAL*MAIR/TAFB
    % The transcriptions (port/blair_prog51_basic.txt, prog52 line 28154) and
    % BUILD_MANIFEST's decision log all carry the "^" form, and neither flags
    % it. It cannot be Blair's: MAIR is the trapped air mass, of order 2e-4 kg,
    % and TAFB is 13, so MAIR^TAFB ~ 1e-48 J - there would be no combustion at
    % all, in any cycle of any engine. The divided form is the release of
    % BEFF*CVAL per kg of FUEL, the fuel mass being MAIR/TAF, and it is what
    % QMAX=36*HEAT/(14*BDEG) is dimensioned for. The same repair is recorded
    % as D9 in port/blair_prog52_basic.txt 1285-1294, which is why the "^" in
    % the merged file is a merge defect rather than a reading.
    % TAFB, not TAF, is used: TAFB=max(TAF,13) is the lean clamp that makes the
    % substitution meaningful.
    HEAT = m.BEFF*m.CVAL*MAIR/TAFB;             % 1452  (printed /TAFB)
    QMAX = 36*HEAT/(14*m.BDEG);                 % 1453
    S1   = 3*QMAX/m.BDEG;                       % 1454
    S2   = 5*QMAX/(2*m.BDEG);                   % 1455
    S3   = QMAX/(2*m.BDEG);                     % 1456
end

% ---- 1457 label 30: IF DEGC<=IGN THEN GOTO 90 -------------------------
% ---- 1458           IF DEGC>=BURNEND THEN GOTO 90 ---------------------
if DEGC <= IGN || DEGC >= BURNEND
    % 1465 label 90: no heat release this step, pure polytropic compression
    % or expansion.
    P2 = P1*(V1/V2)^POLYINDEX;                  % 1465
    T2 = P2*V2/(MC*m.GK);                       % 1466
    % 1467 GOTO C50 -> work (below)
else
    % 1463/1464 ([D25], see the header) -> label C20
    if DEGC > PEAK
        if DEGC <= TAILDEG
            HT2 = (TAILDEG - DEGC)*S2;          % 1474 label 70
        else
            HT2 = (BURNEND - DEGC)*S3;          % 1472 label 60
        end
    else
        HT2 = S1*(DEGC - IGN);                  % 1469 label C20
    end
    % ---- 1475 label 80: Rassweiler and Withrow heat release -------------
    QHT = m.DC*(HT1 + HT2)/2;
    VR  = V1/V2;                                % 1476
    VRN = VR^POLYINDEX;                         % 1477
    TRM1 = (m.GE+1)*V2/(2*(m.GE-1)) - VR;       % 1482 [D26] dead, kept
    TRM1 = V2/(m.GE-1);                         % 1483 Eqn.4.2.13
    P2 = (QHT/TRM1) + P1*VRN;                   % 1484
    T2 = P2*V2/(MC*m.GK);                       % 1485
end

% ---- 1486 label C50: work, peaks, roll -------------------------------------
WORK = (P1 + P2)*(V2 - V1)/2;                   % 1587
if P2 > P1
    DELTAP   = (P2 - P1)/(100000*m.DC);         % 1588
    m.PMAX   = P2/100000;                       % 1589  [bar]
    m.MAXDEG = DEGC - 360;                      % 1590
end
if T2 > T1
    m.TKMAX = T2;                               % 1591
end
if DELTAP > DPMAX
    DPMAX = DELTAP;                             % 1592  [D16] diagnostic only
end
P1 = P2;                                        % 1593
T1 = T2;                                        % 1594
V1 = V2;                                        % 1595
HT1 = HT2;                                      % 1596  <-- the trapezoidal rule

% ---- write the outputs back -------------------------------------------
m.PC2 = P2;
m.TC2 = T2;
m.CYWORK = WORK;
m.PC1 = P1;                                     % rolled
m.TC1 = T1;                                     % rolled
m.VC1 = V1;                                     % rolled

% ---- CYLINDER's STATIC locals, out -------------------------------------
c.HT1 = HT1;   c.HT2 = HT2;   c.DPMAX = DPMAX;   c.DELTAP = DELTAP;
c.POLYINDEX = POLYINDEX;   c.MAIR = MAIR;
c.IGN = IGN;   c.BURNEND = BURNEND;   c.TAILDEG = TAILDEG;   c.PEAK = PEAK;
c.TAFB = TAFB; c.HEAT = HEAT; c.QMAX = QMAX;
c.S1 = S1;     c.S2 = S2;     c.S3 = S3;
m.cyl = c;

end
