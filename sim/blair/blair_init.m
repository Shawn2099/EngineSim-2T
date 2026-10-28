function mdl = blair_init(casepath)
%BLAIR_INIT  Build the Blair Prog.5.1 model for one case, ready to step.
%
%   MDL = BLAIR_INIT()          the reference QUB 400 deck (CONFIG below)
%   MDL = BLAIR_INIT(CASEPATH)  a case file in the format of LOAD_CASE
%
%   MDL = BLAIR_RUN(BLAIR_INIT(...), rpm, throttle) then runs to convergence.
%
% WHAT THIS FUNCTION IS
%   The whole of blair_clean.bas up to the head of the crank-angle loop
%   (line 256, label CYCLELOOP): the constants, the UFLO table, the unit
%   conversions, PORTSTART, the three PAREA calls, the four NINT mesh counts,
%   the four SETS/AREA duct initialisations, and the pre-loop initial
%   conditions at lines 232-255. It leaves MDL in exactly the state Blair has
%   just before the first `DZ=1`.
%
% MDL FIELDS
%   mdl.p        every input, in the user units of the case file (mm, deg,
%                rev/min, cm^3, degC), plus the hard-coded model constants.
%                This is the snapshot of what was applied; the live values are
%                the top-level fields, which are seeded from p here and are
%                authoritative from then on (BLAIR_RUN refreshes both).
%   mdl.uflo     the unsteady-flow boundary table as read from UFLO: 21 x 41,
%                rows = port/pipe area ratio AK = 0,.05,...,1.00, columns =
%                incoming amplitude B1/Xc = .60,.62,...,1.40.
%   mdl.meta     provenance: case path, UFLO path and its row-count resolution,
%                the DATASET echo of lines 479-512, and the notes below.
%   everything else
%                one field per Blair variable, with Blair's own name, so that
%                BLAIR_STEP can be read against the BASIC line it came from.
%                Every array is sized for the largest index Blair uses, 1-based:
%                  ABX 21x45   BX 45   AKA 45   DF 20   F 20
%                  AE BE FE DFE / AET BET FET DFET / AT BT FT DFT / AI BI FI DFI
%                       20 each   A2 B2 20
%                  XA YC YS YE 200   YI YV YP XXA YB 250   YF 13
%                  DELRAT PEAKP PEAKT PMEP CMEP BMEP POWER FUEL BSFC
%                  SEFFP TEFFP CEFFP SRMP SRVP EXRP 20
%                  (Blair's DIM(20) gives indices 0..20; MATLAB 1-based gives
%                   1..20, which holds every index the program actually uses.
%                   ABX needs 45 columns because SUB PORT reads column J+1.)
%   mdl.cyl      CYLINDER's STATIC locals, zeroed once (see SUB_CYLINDER and
%                the [FIX4] block in blair_clean.bas).
%   mdl.init     a snapshot of the pre-loop state, so BLAIR_RUN can restart
%                from here for every operating point.
%   mdl.results  the interface contract, pre-filled with NaN.
%
% THE TWO THINGS THAT ARE NOT A LITERAL TRANSLATION
%   1. The interactive data entry is replaced by a case file (LOAD_CASE). The
%      arithmetic of ENGINEDAT/FILESET and of the five port blocks is unchanged;
%      what disappears is the Y/N prompting. There is no other path into the
%      model: the .BOX branch of the menu is the same eight records.
%   2. MSC and CSC are only assigned inside six string tests at
%      blair_clean.bas 1046-1057. If SCAV matches none of them both stay 0, and
%      SEFF=1-EXP(0)=0 silently - a zero-result run with no diagnostic
%      (VERIFY_STRUCTURE.md 2.5). Here that raises an error naming MSC/CSC and
%      the line, which is the only place in the file where an uninitialised
%      value matters enough to stop.
%
% See also BLAIR_RUN, BLAIR_STEP, LOAD_CASE, LOAD_UFLO.

% -------------------------------------------------------------------------
% CONFIG - the only place in this file where a path or a tolerance appears
% -------------------------------------------------------------------------
CONFIG = struct();
CONFIG.default_case = 'C:\Users\malliath\Desktop\engine_sim\port\QUB400_INPUT.dat';
CONFIG.uflo         = 'C:\Users\malliath\Desktop\engine_sim\port\uflo.csv';
CONFIG.lmesh        = 30;      % blair_clean.bas 232: LMESH=30 [mm]
CONFIG.cycles_top   = 7;       % blair_clean.bas 223: CYCLESTOP=7
CONFIG.verbose      = false;   % true prints the DATASET echo of lines 479-512

if nargin < 1 || isempty(casepath)
    casepath = CONFIG.default_case;
end

% -------------------------------------------------------------------------
% 0. Inputs: the case file and the UFLO table
% -------------------------------------------------------------------------
p_case = load_case(casepath);
[m.uflo, bx41, uflo_meta] = load_uflo(CONFIG.uflo);

m.meta = struct();
m.meta.case_path  = casepath;
m.meta.uflo_path  = uflo_meta.source;
m.meta.uflo_rows  = uflo_meta.n_rows_in_file;
m.meta.uflo_note  = ['load_uflo drops the duplicated first axis row: ' ...
    'port/uflo.csv has 22 rows, the program reads 21 (VERIFY_STRUCTURE.md 8).'];
m.meta.source     = 'blair_clean.bas (blair_full.bas + CLEAN_LOG.md FIX1-FIX5)';

% -------------------------------------------------------------------------
% 1. Constants - blair_clean.bas 105-109 and 178-186
% -------------------------------------------------------------------------
m.PI   = 3.141593;                      % 105 Blair's PI, NOT pi. 3.141593,
m.RTOD = 180/m.PI;                      % 106 used by FPISTON, PAREA, FEP1...
m.DTOR = 1/m.RTOD;                      % 107
m.KO   = 1;                             % 109 first mesh index
m.GE   = 1.4;                           % 178
m.GK   = 287;                           % 179
m.CCP  = 1005;                          % 180 dead store
m.CCV  = 718;                           % 181 read nowhere (4.2)
m.GR   = m.GE*m.GK;                     % 182 dead store
m.N27  = 1/3.5;                         % 183 dead store
m.N17  = 1/7;                           % 184 dead store
m.PA   = 101325;                        % 185 ambient reference pressure [Pa]
m.TA   = 293;                           % 186 ambient temperature [K]
m.CVAL = 4.3e7;                         % 203 fuel calorific value [J/kg]
m.LMESH = CONFIG.lmesh;                 % 205 reference mesh length [mm]

% -------------------------------------------------------------------------
% 2. UFLO - blair_clean.bas 110-128
%
% Blair reads 21 x 41 values straight into ABX, then BX(J)=ABX(1,J) for
% J=1..41 and AKA(I)=AKA(I-1)+.05 for I=2..21.
%
% ABX IS 21 x 45, NOT 21 x 41. Blair DIMs ABX(21,45) and fills only columns
% 1..41; columns 42..45 stay ZERO, and SUB PORT's J+1 reaches column 42 for
% BX1 >= 1.40. The zero padding is reproduced here on purpose: it is the
% behaviour of the printed program, and SUB_PORT documents where that becomes
% undefined (VERIFY_STRUCTURE.md 3.2). mdl.uflo keeps the raw 21 x 41.
% -------------------------------------------------------------------------
m.ABX = zeros(21, 45);
m.ABX(:, 1:41) = m.uflo;                                  % 117

m.BX = zeros(1, 45);
m.BX(1:41) = m.uflo(1, :);                                % 123 BX(J)=ABX(1,J)

m.AKA = zeros(1, 45);
m.AKA(1) = 0;                                             % 125
for I = 2:21
    m.AKA(I) = m.AKA(I-1) + .05;                          % 127
end

% -------------------------------------------------------------------------
% 3. Case data, in user units - the state after ENGINEDAT/EXPORTDAT/
%    TRPORTDAT/INPORTDAT/EXPIPDAT/TRPIPDAT/INPIPDAT/COMBDAT have run
% -------------------------------------------------------------------------
m.BO   = p_case.BO;      m.ST  = p_case.ST;    m.CRL = p_case.CRL;
m.RPM  = p_case.RPM;     m.TCR = p_case.TCR;   m.CCR = p_case.CCR;
m.TEXC = p_case.TEXC;

m.EPO  = p_case.EPO;     m.EPFO = p_case.EPFO;
m.NEP  = p_case.NEP;     m.WEP  = p_case.WEP;
m.RTE  = p_case.RTE;     m.RBE  = p_case.RBE;

m.TPO  = p_case.TPO;     m.TPFO = p_case.TPFO;
m.NTP  = p_case.NTP;     m.WTP  = p_case.WTP;
m.RTT  = p_case.RTT;     m.RBT  = p_case.RBT;
m.SCAV = p_case.SCAV;                    % Blair's SCAV$ ('$' is not legal in a field name)

m.IPO  = p_case.IPO;     m.IPFO = p_case.IPFO;
m.NIP  = p_case.NIP;     m.WIP  = p_case.WIP;
m.RTI  = p_case.RTI;     m.RBI  = p_case.RBI;

m.LEP1 = p_case.LEP1;    m.DEP1 = p_case.DEP1;
m.LEP2 = p_case.LEP2;    m.DEP2 = p_case.DEP2;
m.VBOX = p_case.VBOX;    m.SIL  = p_case.SIL;   % Blair's SIL$

m.LTP  = p_case.LTP;     m.TRAR = p_case.TRAR;
m.LIP  = p_case.LIP;     m.DIP  = p_case.DIP;   m.THAR = p_case.THAR;

m.NC   = p_case.NC;      m.NE   = p_case.NE;
m.BEFF = p_case.BEFF;    m.BDEG = p_case.BDEG;  m.TAF  = p_case.TAF;

% -------------------------------------------------------------------------
% 4. Unit conversion - ENGINEDAT 1169-1178 and FILESET 449-478, which compute
%    the same expressions for the .BOX and the typed data paths
% -------------------------------------------------------------------------
m.BOM     = m.BO/1000;                              % 1169 / 449
m.STM     = m.ST/1000;                              % 1170 / 450
m.CRLM    = m.CRL/1000;                             % 1171 / 451
m.RPS     = m.RPM/60;                               % 1172 / 452
m.FPISTON = m.PI*m.BOM*m.BOM/4;                     % 1173 / 453
m.SV      = m.FPISTON*m.STM;                        % 1174 / 454
m.CCCV    = m.SV/(m.CCR-1);                         % 1175 / 455
m.CRNK    = m.STM/2;                                % 1176 / 456
m.FMEP    = 100*m.STM*m.RPM;                        % 1177 / 457  the whole
%                                                     friction model, in Pa
m.TEREF   = m.TEXC+273;                             % 1178 / 478

m.WEPM = m.WEP/1000;   m.RTEM = m.RTE/1000;   m.RBEM = m.RBE/1000;   % 1200-1202
m.WTPM = m.WTP/1000;   m.RTTM = m.RTT/1000;   m.RBTM = m.RBT/1000;   % 1227-1229
m.WIPM = m.WIP/1000;   m.RTIM = m.RTI/1000;   m.RBIM = m.RBI/1000;   % 1251-1253

m.LE1M = m.LEP1/1000;  m.LE2M = m.LEP2/1000;                        % 467-470
m.DE1M = m.DEP1/1000;  m.DE2M = m.DEP2/1000;
m.VBOXM = m.VBOX/1000000;                                           % 471 cm3->m3
m.FEP1  = m.PI*m.DE1M*m.DE1M/4;                                     % 472
m.FEP2  = m.PI*m.DE2M*m.DE2M/4;                                     % 473

m.LTM  = m.LTP/1000;                                                % 955
m.LIM  = m.LIP/1000;   m.DIPM = m.DIP/1000;                         % 971-972
m.FIPM = m.PI*m.DIPM*m.DIPM/4;                                      % 973 [D14]
%                                                                     dead

% -------------------------------------------------------------------------
% 5. PORTSTART - blair_clean.bas 1001-1044
%    The port-timing closure angles and the piston travel at every port edge.
% -------------------------------------------------------------------------
m.EPC  = 360 - m.EPO;                               % 1002
m.IPC  = 360 + m.IPO;                               % 1003
m.IPOD = 360 - m.IPO;                               % 1004
m.TPC  = 360 - m.TPO;                               % 1005

% 1006-1017: port widths, fill areas and heights. All 23 of these PORTSTART
% outputs are dead stores in PROG.5.1 (VERIFY_STRUCTURE.md 2.4); they are kept
% because they belong to the routine and document Blair's angle-resolved port
% model, which 5.1 does not use.
m.PFI = 0;  m.PFE = 0;  m.PFT = 0;
m.PFIM = 0; m.PFEM = 0; m.PFTM = 0;
m.PWE = m.WEPM - 2*m.RTEM;                          % 1012
m.PWT = m.WTPM - 2*m.RTTM;                          % 1013
m.PWI = m.WIPM - 2*m.RTIM;                          % 1014
m.PHE = 0;  m.PHT = 0;  m.PHI = 0;
% (PFI/PFE/PFT and PHE/PHT/PHI are set to 0 at 1006-1008 and 1015-1017.)

[m.HEOT, m.HEOB] = sub_pistpos(m, m.STM, m.CRNK, m.CRLM, m.EPO);   % 1018
[m.HEFT, m.HEFB] = sub_pistpos(m, m.STM, m.CRNK, m.CRLM, m.EPFO);  % 1019
m.EXHT = m.HEFT - m.HEOT;                           % 1020
m.HME  = m.EXHT - m.RTEM - m.RBEM;                  % 1021

[m.HTOT, m.HTOB] = sub_pistpos(m, m.STM, m.CRNK, m.CRLM, m.TPO);   % 1022
[m.HTFT, m.HTFB] = sub_pistpos(m, m.STM, m.CRNK, m.CRLM, m.TPFO);  % 1023
m.TRHT = m.HTFT - m.HTOT;                           % 1024
m.HMT  = m.TRHT - m.RTTM - m.RBTM;                  % 1025

[m.HIOT, m.HIOB] = sub_pistpos(m, m.STM, m.CRNK, m.CRLM, m.IPO);   % 1026
[m.HIFT, m.HIFB] = sub_pistpos(m, m.STM, m.CRNK, m.CRLM, m.IPFO);  % 1027
m.INHT = m.HIOT - m.HIFT;                           % 1028
% 1028 looks inverted next to EXHT and TRHT, but it is not: IPO is entered in
% deg BTDC and IPFO in deg ATDC, so for the reference case IPFO=0 gives
% HIFT=0 and INHT = HIOT > 0. BUILD_MANIFEST 9.4.
m.HMI  = m.INHT - m.RTIM - m.RBIM;                  % 1029

% ---- 1030-1041: the scavenging law selector -----------------------------
% SEFF = 1 - EXP(MSC*SR + CSC); the six (MSC,CSC) pairs are Fig.3.14 of the
% book. Blair's six IF/IF pairs leave both at 0 for any other string; that is
% an error here, because the result would be a silent SEFF=0 for the whole run.
switch upper(strtrim(m.SCAV))
    case 'UNIFLOW', m.MSC = -1.7827; m.CSC = .2094;   % 1030-1031
    case 'SCRE',    m.MSC = -1.6709; m.CSC = .1899;   % 1032-1033
    case 'YAM1',    m.MSC = -1.6993; m.CSC = .3053;   % 1034-1035
    case 'YAM6',    m.MSC = -1.3516; m.CSC = .1435;   % 1036-1037
    case 'CD',      m.MSC = -1.0104; m.CSC = -.117;   % 1038-1039
    case 'QUBCR',   m.MSC = -1.6325; m.CSC = .1397;   % 1040-1041
    otherwise
        error('blair:init:scavType', ...
            ['SCAV = "%s" matches none of the six scavenging types at\n' ...
             'blair_clean.bas 1030-1041 (UNIFLOW SCRE YAM1 YAM6 CD QUBCR).\n' ...
             'MSC and CSC would stay 0, and SEFF=1-EXP(0)=0 would be used for\n' ...
             'every cycle with no diagnostic (VERIFY_STRUCTURE.md 2.5).'], ...
            m.SCAV);
end

% -------------------------------------------------------------------------
% 6. Port full-open areas and equivalent diameters - 154-156
% -------------------------------------------------------------------------
[m.FEPRT, m.DEPRT] = sub_parea('PAREA', m, m.NEP, m.WEPM, m.EXHT, m.RTEM, m.RBEM);
[m.FTPRT, m.DTPRT] = sub_parea('PAREA', m, m.NTP, m.WTPM, m.TRHT, m.RTTM, m.RBTM);
[m.FIPRT, m.DIPRT] = sub_parea('PAREA', m, m.NIP, m.WIPM, m.INHT, m.RTIM, m.RBIM);

% -------------------------------------------------------------------------
% 7. The transfer duct and the three reference volumes - 157-162
% -------------------------------------------------------------------------
m.FTDUCT = m.TRAR*m.FTPRT;                          % 157
m.DTDUCT = sqrt(4*m.FTDUCT/m.PI);                   % 158
m.TSV    = m.FPISTON*m.HEOT;                        % 159 trapped swept volume
m.CYCV   = m.TSV/(m.TCR-1);                         % 160 clearance volume
m.VC1    = m.TSV + m.CYCV;                          % 161 volume at exh. opening
m.VCC1   = m.CCCV + m.FPISTON*m.HEOB;               % 162 crankcase at exh. opening

% -------------------------------------------------------------------------
% 8. Pre-run resets - 163-177
% -------------------------------------------------------------------------
m.CYC      = 1;        % 164  dead test at 286 compares it with CYCTRIP
m.NN       = 0;        % 165
m.JJ       = 0;        % 166
m.CCMEP    = 0;        % 167
m.CYMEP    = 0;        % 168
m.SEFF     = 0;        % 169
m.CEFF     = 0;        % 170
m.TEFF     = 0;        % 171
m.MBACK    = 0;        % 172  dead store
m.DRATIO   = 0;        % 173
m.SCRATIO  = 0;        % 174
m.EXRATIO  = 0;        % 175
m.DRAT     = 1;        % 176
m.SR       = 0;        % 177

% -------------------------------------------------------------------------
% 9. CYLSTART - 1260-1269
% -------------------------------------------------------------------------
m.TEREF = m.TEXC + 273;                             % 1261
m.TTREF = 320;                                      % 1262
m.TIREF = 300;                                      % 1263
m.SDE   = sqrt(m.GE*m.GK*m.TEREF);                  % 1264
m.SDT   = sqrt(m.GE*m.GK*m.TTREF);                  % 1265
m.SDI   = sqrt(m.GE*m.GK*m.TIREF);                  % 1266
m.DEREF = m.PA/(m.GK*m.TEREF);                      % 1267  dead store
m.DTREF = m.PA/(m.GK*m.TTREF);                      % 1268  dead store
m.DIREF = m.PA/(m.GK*m.TIREF);                      % 1269  dead store

% -------------------------------------------------------------------------
% 10. Pre-loop initial conditions - 188-227
% -------------------------------------------------------------------------
m.DA   = m.PA/(m.GK*m.TA);                          % 188
m.MREF = m.SV*m.DA;                                 % 189 reference air mass
m.PC1  = m.TCR*m.PA/2.5;                            % 190
m.TC1  = 1900;                                      % 191
m.DCYL = m.PC1/(m.GK*m.TC1);                        % 192
m.PCC1 = .9*m.CCR*m.PA;                             % 193
m.DCC  = m.PCC1/(m.GK*m.TTREF);                     % 194
m.TEXC = m.TEREF - 273;                             % 195 round trip, as printed
m.MC1  = m.VC1*m.DCYL;                              % 196
m.MCC1 = m.VCC1*m.DCC;                              % 197
m.TC1  = m.PC1*m.VC1/(m.GK*m.MC1);                  % 198 = 1900 again
m.TCC1 = m.PCC1*m.VCC1/(m.GK*m.MCC1);               % 199
m.PB1  = 1.1*m.PA;                                  % 200
m.TB1  = m.TEREF;                                   % 201
m.MB1  = m.PB1*m.VBOXM/(m.GK*m.TB1);                % 202

m.DEG  = m.EPO;                                     % 204
m.CYCLE = 1;                                        % 225
m.CYCLESTOP = CONFIG.cycles_top;                    % 226
m.CYCLEP    = m.CYCLESTOP + 10;                     % 227 printer replay [FIX5]

% -------------------------------------------------------------------------
% 11. Mesh counts - 206-213, then the mesh lengths
% -------------------------------------------------------------------------
m.KE1 = sub_nint(m, m.LEP1, m.TEREF, m.TEREF);      % 206
m.KE2 = sub_nint(m, m.LEP2, m.TEREF, m.TEREF);      % 207
m.KT  = sub_nint(m, m.LTP,  m.TEREF, m.TTREF);      % 208
m.KI  = sub_nint(m, m.LIP,  m.TEREF, m.TIREF);      % 209

m.LEM1   = m.LE1M/(m.KE1 - 1);                      % 210
m.LEM2   = m.LE2M/(m.KE2 - 1);                      % 211
m.LIMESH = m.LIM/(m.KI - 1);                        % 212
m.LTMESH = m.LTM/(m.KT - 1);                        % 213

% -------------------------------------------------------------------------
% 12. Duct initialisation - 214-221
% -------------------------------------------------------------------------
m.AE  = zeros(1,20);  m.BE  = zeros(1,20);
m.FE  = zeros(1,20);  m.DFE = zeros(1,20);
m.AET = zeros(1,20);  m.BET = zeros(1,20);
m.FET = zeros(1,20);  m.DFET = zeros(1,20);
m.AT  = zeros(1,20);  m.BT  = zeros(1,20);
m.FT  = zeros(1,20);  m.DFT = zeros(1,20);
m.AI  = zeros(1,20);  m.BI  = zeros(1,20);
m.FI  = zeros(1,20);  m.DFI = zeros(1,20);
m.A2  = zeros(1,20);  m.B2  = zeros(1,20);
m.DF  = zeros(1,20);  m.F   = zeros(1,20);

[m.AE,  m.BE]  = sub_sets(m.AE,  m.BE,  m.KE1);     % 214
[m.AET, m.BET] = sub_sets(m.AET, m.BET, m.KE2);     % 215
[m.AT,  m.BT]  = sub_sets(m.AT,  m.BT,  m.KT);      % 216
[m.AI,  m.BI]  = sub_sets(m.AI,  m.BI,  m.KI);      % 217

% AREA is called with the DUCT area, not the port area: pipe 1 and pipe 2 are
% constant-diameter, the transfer duct comes from TRAR, and the inlet duct is
% a linear taper from the inlet port area to the carburettor diameter.
[m.FET, m.DFET] = sub_area(m.DE2M,   m.DE2M,   m.KO, m.KE2, m.FET, m.DFET);  % 218
[m.FE,  m.DFE]  = sub_area(m.DE1M,   m.DE1M,   m.KO, m.KE1, m.FE,  m.DFE);   % 219
[m.FT,  m.DFT]  = sub_area(m.DTDUCT, m.DTDUCT, m.KO, m.KT,  m.FT,  m.DFT);   % 220
[m.FI,  m.DFI]  = sub_area(m.DIPRT,  m.DIPM,   m.KO, m.KI,  m.FI,  m.DFI);   % 221

% -------------------------------------------------------------------------
% 13. The remaining loop state at the head of CYCLELOOP
% -------------------------------------------------------------------------
m.KK     = 0;      % [FIX5] explicit step counter, incremented at 257
m.stop   = false;
m.COUNT  = 0;                                       % 222 dead store
m.PCOUNT = 0;                                       % 223 dead (see [D19])
m.CYCTRIP = 0;                                      % 286 never assigned in
%                                                     BASIC, so it is 0 there.
m.ANGD   = m.EPO;                                   % 224
m.DZ     = 0;                                       % set to 1 at 258
m.DTM    = 0;                                       % set by the first STAB
m.DC     = 0;                                       % set by the first STAB

% peak tracking: never initialised in BASIC, so they are 0 at program start
% (QBasic zeroes every variable). Written by CYLINDER only.
m.PMAX   = 0;
m.TKMAX  = 0;
m.MAXDEG = 0;

% flow/concentration diagnostics that the loop overwrites on its first pass
m.AK = 0;   m.CD = 0;   m.D = 0;
m.AKE = 0;  m.ME1 = 0;  m.HE1 = 0;  m.CE1 = 0;
m.AKT = 0;  m.MT1 = 0;  m.HT1 = 0;  m.CT1 = 0;
m.AKI = 0;  m.MI1 = 0;  m.HI1 = 0;  m.CI1 = 0;
m.MTKT = 0; m.CTKT = 0; m.HTKT = 0;
m.MEK1 = 0; m.CEK1 = 0; m.HEK1 = 0;
m.MET1 = 0; m.CET1 = 0; m.HET1 = 0;
m.BOXW = 0; m.CCWORK = 0; m.CYWORK = 0;
m.PC2 = 0;  m.TC2 = 0;  m.VC2 = 0;  m.MC2 = 0;
m.PCC2 = 0; m.TCC2 = 0; m.MCC2 = 0;
m.PB2 = 0;  m.TB2 = 0;  m.MB2 = 0;
m.PCR = 1;  m.PCCR = 1; m.PBR = 1;
m.PEX = 1;  m.PIR = 1;  m.PTR = 1;
m.PTRO = 1; m.PEXP = 1; m.PEXT = 1;
m.PC1R = 1; m.PCC1R = 1;
m.CCE = 0;  m.CDE = 0;  m.CCT = 0;  m.CDT = 0;  m.CCI = 0;  m.CDI = 0;
m.EXPAND = 0; m.VOLINC = 0; m.DSCAV = 0;
m.HTDC = 0; m.HBDC = 0;

% -------------------------------------------------------------------------
% 14. CYLINDER's STATIC locals - zeroed once per run (FIX4)
% -------------------------------------------------------------------------
m.cyl = struct( ...
    'HT1', 0, 'HT2', 0, 'DPMAX', 0, 'DELTAP', 0, ...
    'POLYINDEX', 0, 'MAIR', 0, 'IGN', 0, 'BURNEND', 0, 'TAILDEG', 0, ...
    'PEAK', 0, 'TAFB', 0, 'HEAT', 0, 'QMAX', 0, 'S1', 0, 'S2', 0, 'S3', 0);

% -------------------------------------------------------------------------
% 15. History and plot arrays
% -------------------------------------------------------------------------
m.DELRAT = zeros(1,20);  m.PEAKP  = zeros(1,20);  m.PEAKT = zeros(1,20);
m.PMEP   = zeros(1,20);  m.CMEP   = zeros(1,20);  m.BMEP  = zeros(1,20);
m.POWER  = zeros(1,20);  m.FUEL   = zeros(1,20);  m.BSFC  = zeros(1,20);
m.SEFFP  = zeros(1,20);  m.TEFFP  = zeros(1,20);  m.CEFFP = zeros(1,20);
m.SRMP   = zeros(1,20);  m.SRVP   = zeros(1,20);  m.EXRP  = zeros(1,20);

% Display-only arrays, allocated because Blair DIMs them (lines 56-58). The
% SPLOT routines that fill them are not translated.
m.XA = zeros(1,200); m.YC = zeros(1,200); m.YS = zeros(1,200); m.YE = zeros(1,200);
m.YI = zeros(1,250); m.YV = zeros(1,250); m.YP = zeros(1,250);
m.XXA = zeros(1,250); m.YB = zeros(1,250);
m.YF = zeros(1,13);

% -------------------------------------------------------------------------
% 16. The interface contract, and the p snapshot
% -------------------------------------------------------------------------
m.results = local_empty_results();
m.hist    = struct();

m.p = local_p_snapshot(m, p_case);

% -------------------------------------------------------------------------
% 17. Snapshot the pre-loop state so BLAIR_RUN can restart from it
% -------------------------------------------------------------------------
m.init = struct();
skip = {'p', 'uflo', 'meta', 'init', 'results', 'hist', 'cyl'};
f = fieldnames(m);
for i = 1:numel(f)
    if any(strcmp(f{i}, skip))
        continue
    end
    m.init.(f{i}) = m.(f{i});
end
m.init.cyl = m.cyl;

m.meta.dataset = local_dataset_lines(m);

if CONFIG.verbose
    fprintf('%s\n', m.meta.dataset{:});
end

mdl = m;

end % ===================== end blair_init =====================


% =========================================================================
function r = local_empty_results()
% The 14 fields of the interface contract, empty. BLAIR_RUN fills them.
r = struct( ...
    'power_kW', NaN, 'bmep_bar', NaN, 'imep_bar', NaN, 'pmep_bar', NaN, ...
    'fmep_bar', NaN, 'bsfc_gkWh', NaN, 'DR', NaN, 'SE', NaN, 'TE', NaN, ...
    'CE', NaN, 'pmax_bar', NaN, 'tmax_K', NaN, ...
    'converged', false, 'cycles', 0, ...
    'sr', NaN, 'srv', NaN, 'exhaust_flow_ratio', NaN, ...
    'peak_angle_deg', NaN, 'bsfc_kgkWh', NaN, 'swept_volume_cm3', NaN, ...
    'rpm', NaN, 'throttle', NaN);
end


% =========================================================================
function p = local_p_snapshot(m, p_case)
% Every input, in the units the user supplied, plus the hard-coded constants.
% The live values are the top-level fields of mdl; this is the record of what
% was applied, and BLAIR_RUN refreshes RPM and THAR here when they are
% overridden.
p = p_case;                                    % the 42 case fields
p.PI     = m.PI;       p.RTOD  = m.RTOD;   p.DTOR = m.DTOR;
p.KO     = m.KO;
p.GE     = m.GE;       p.GK    = m.GK;
p.CCP    = m.CCP;      p.CCV   = m.CCV;
p.CVAL   = m.CVAL;     p.PA    = m.PA;     p.TA   = m.TA;
p.LMESH  = m.LMESH;
p.CYCLESTOP = m.CYCLESTOP;
% p.SCAV and p.SIL are already the normalised strings from load_case.
end


% =========================================================================
function L = local_dataset_lines(m)
% The DATASET echo of blair_clean.bas 479-512, as text. Blair PRINTS this and
% asks "OK?(Y/N)" but does not test the answer (INPUT_FORMAT.md 1).
L = { ...
    'PROGRAM FOR PISTON-PORTED ENGINE WITH EXHAUST BOX SILENCER'
    'Prog.5.1, ENGINE WITH BOX SILENCER'
    'ALL DATA IN mm AND deg UNITS'
    'BORE STROKE CON-ROD REV/MIN TRAP-CR CRANKCASE-CR TEXC'
    sprintf('%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f', ...
        m.BO, m.ST, m.CRL, m.RPM, m.TCR, m.CCR, m.TEXC)
    'EXHAUST PORT DATA'
    'OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD'
    sprintf('%11.1f %11.1f %11.1f %11.1f %11.1f %11.1f', ...
        m.EPO, m.EPFO, m.NEP, m.WEP, m.RTE, m.RBE)
    ['TRANSFER PORT DATA WITH SCAVENGING DESCRIBED AS ' m.SCAV]
    'OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD'
    sprintf('%11.1f %11.1f %11.1f %11.1f %11.1f %11.1f', ...
        m.TPO, m.TPFO, m.NTP, m.WTP, m.RTT, m.RBT)
    'INLET PORT DATA'
    'OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD'
    sprintf('%11.1f %11.1f %11.1f %11.1f %11.1f %11.1f', ...
        m.IPO, m.IPFO, m.NIP, m.WIP, m.RTI, m.RBI)
    ['EXHAUST PIPE DATA WITH MUFFLER TYPE AS ' m.SIL]
    'LENGTH.1 DIAMETER.1 LENGTH.2 DIAMETER.2 BOX VOLUME, cm3'
    sprintf('%10.2f %10.2f %10.2f %10.2f %10.2f', ...
        m.LEP1, m.DEP1, m.LEP2, m.DEP2, m.VBOX)
    'TRANSFER AND INLET PIPE DATA'
    'LENGTH.T TRANSFER.AR LENGTH.I DIAMETER.I THROTTLE.AR'
    sprintf('%10.2f %10.2f %10.2f %10.2f %10.2f', ...
        m.LTP, m.TRAR, m.LIP, m.DIP, m.THAR)
    'COMBUSTION MODEL PARAMETERS'
    'INDECES, COMP. AND EXP. COMBUSTION.EFF BURN PERIOD AIR-TO-FUEL'
    sprintf('%11.2f %11.2f %11.2f %11.2f %11.2f', ...
        m.NC, m.NE, m.BEFF, m.BDEG, m.TAF)};
end
