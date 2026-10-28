function m = blair_step(m)
%BLAIR_STEP  Advance the Blair Prog.5.1 model by one crank-angle step.
%
%   m = BLAIR_STEP(m)
%
%   One pass of the crank-angle loop of blair_clean.bas 256-370 (the loop Blair
%   writes as FOR KK=1 TO 20000 with the PRINTOUT replay bolted on; [FIX5] made
%   it an explicit counted loop with one entry point, label CYCLELOOP).
%
%   The whole model state is the struct m: every Blair variable is a field with
%   Blair's own name, so a statement here can be read against the BASIC line it
%   came from. Nothing is vectorised, nothing is reordered.
%
% SETS      m.stop = true when Blair's loop would leave for the 500 menu, i.e.
%           when CYCLE reaches CYCLESTOP at the head of the body (line 275) or
%           when the 20000-step guard trips (line 369). BLAIR_RUN tests it.
%
% READS/WRITES
%           arrays  AE BE FE DFE AET BET FET DFET AT BT FT DFT AI BI FI DFI
%           scalars DZ DTM DC DEG ANGD CYCLE KK NN HTDC HBDC VC2 VCC2
%                   PC1 PC2 TC1 TC2 VC1 VC2 PCC1 PCC2 TCC1 TCC2
%                   PB1 PB2 TB1 TB2 MB1 MB2 MC1 MC2 MCC1 MCC2
%                   AK CD D AKE ME1 HE1 CE1 AKT MT1 HT1 CT1 AKI MI1 HI1 CI1
%                   MTKT CTKT HTKT MEK1 CEK1 HEK1 MET1 CET1 HET1
%                   BOXW CCWORK CYWORK PEX PIR PTR PTRO PEXP PEXT
%                   PCR PCCR PBR PC1R PCC1R CCE CDE CCT CDT CCI CDI
%                   EXPAND VOLINC DSCAV EXRATIO DRATIO SCRATIO SR SEFF
%                   CCMEP CYMEP PMAX TKMAX MAXDEG CEFF TEFF, and the per-cycle
%                   history slots written by RESETBDC/RESETTDC
%           m.cyl   CYLINDER's STATIC locals (see SUB_CYLINDER)
%
% WHAT IS NOT TRANSLATED, AND WHY
%   * SPLOT1..4 (blair_clean.bas 357-363 and the routines at 655-894) draw the
%     two screen panels. They read state and write only plot arrays; no physics
%     reads them back. Skipped, with the dispatch lines left as comments.
%   * The LOCATE/PRINT/USING diagnostics inside RESETBDC and RESETTDC (lines
%     498-510, 529-537) and the "press return" pauses. The numbers they display
%     are stored in the history arrays, which is what BLAIR_RUN reports.
%   * The PRINTOUT replay (CYCLE=CYCLEP, PRINTMODE) - there is no printer in the
%     physics core. The state it would need is unaffected by this omission.
%
% LINE MAPPING
%   Every statement carries the blair_clean.bas line it comes from. Where a
%   GOTO had to be restructured, the original label is named in the comment and
%   the test mirrors the original condition exactly.
%
% See also BLAIR_INIT, BLAIR_RUN, SUB_CYLINDER, SUB_BOX.

% =========================================================================
% 256 label CYCLELOOP: 257 KK=KK+1
% =========================================================================
m.KK = m.KK + 1;                                            % 257

m.DZ = 1;                                                   % 258
m.NN = m.NN + 1;                                            % 259

% ---- 260-268: the five STAB calls. The 4th and 5th are identical ([D18]);
%      STAB only ever lowers DZ, so the repeat is a no-op. Kept.
m = sub_stab(m, m.AET, m.BET, m.KE2, m.SDE, m.LEM2);         % 260
m = sub_stab(m, m.AT,  m.BT,  m.KT,  m.SDT, m.LTMESH);       % 261
m = sub_stab(m, m.AI,  m.BI,  m.KI,  m.SDI, m.LIMESH);       % 262
m = sub_stab(m, m.AE,  m.BE,  m.KE1, m.SDE, m.LEM1);         % 263
m = sub_stab(m, m.AE,  m.BE,  m.KE1, m.SDE, m.LEM1);         % 268 [D18]

m.DZ  = .99*m.DZ;                                           % 269
m.DEG  = m.DEG  + m.DC;                                     % 270
m.ANGD = m.ANGD + m.DC;                                     % 271

if m.ANGD > 360 + m.EPO                                    % 272
    m.CYCLE = m.CYCLE + 1;
end

% ---- 273-275: the three exit tests. PRINTMODE is a printer concept and is
%      not part of the physics core; the two CYCLEP tests existed only to
%      re-enter and leave the PRINTOUT replay.
if m.CYCLE == m.CYCLESTOP                                   % 275
    m.stop = true;                                          % GOTO 500
    return
end

% ---- 276 label 430: IF ANGD>360+EPO THEN ANGD=ANGD-360
if m.ANGD > 360 + m.EPO
    m.ANGD = m.ANGD - 360;
end

% ---- 277: IF DEG>540 THEN GOSUB RESETBDC
if m.DEG > 540
    m = local_reset_bdc(m);
end

% ---- 278: IF DEG>360+DC THEN GOTO 25  /  279: IF DEG>360 THEN GOSUB RESETTDC
if m.DEG > 360 + m.DC
    % GOTO 25 - skip RESETTDC this step
elseif m.DEG > 360
    m = local_reset_tdc(m);
end

% =========================================================================
% 280 label 25: piston position and the two volumes for this crank angle
% =========================================================================
[m.HTDC, m.HBDC] = sub_pistpos(m, m.STM, m.CRNK, m.CRLM, m.DEG);   % 280
m.VC2  = m.CYCV  + m.HTDC*m.FPISTON;                        % 281
m.VCC2 = m.CCCV  + m.HBDC*m.FPISTON;                        % 282

% ---- 286: IF CYC=CYCTRIP THEN PCOUNT=PCOUNT+1  ([D19] CYCTRIP is never
%      assigned, so in BASIC it is 0 and CYC is 1: the test is dead. Kept, with
%      CYCTRIP an explicit 0 in BLAIR_INIT, so the dead test stays visible.)
if m.CYC == m.CYCTRIP
    m.PCOUNT = m.PCOUNT + 1;
end

% =========================================================================
% 287-290: the four ducts
% =========================================================================
[m.AE,  m.BE]  = sub_pipe(m, m.KO, m.KE1, m.AE,  m.BE,  m.DFE,  m.FE);    % 287
[m.AET, m.BET] = sub_pipe(m, m.KO, m.KE2, m.AET, m.BET, m.DFET, m.FET);   % 288
[m.AT,  m.BT]  = sub_pipe(m, m.KO, m.KT,  m.AT,  m.BT,  m.DFT,  m.FT);    % 289
[m.AI,  m.BI]  = sub_pipe(m, m.KO, m.KI,  m.AI,  m.BI,  m.DFI,  m.FI);    % 290

% =========================================================================
% 291-305: the five fixed boundary conditions
%
% Duct orientations, read from the argument order (do not normalise):
%   AE/BE    index 1 = cylinder end,     KE1 = silencer-box end
%   AET/BET  index 1 = silencer-box end, KE2 = open end to atmosphere
%   AT/BT    index 1 = transfer port,    KT  = crankcase end
%   AI/BI    index 1 = inlet port,       KI  = throttle / atmosphere end
% Where the port is at the outgoing end the caller passes (B,A); where it is at
% the incoming end it passes (A,B). PORT always overwrites its FIRST argument.
% =========================================================================

% ---- 291-294: exhaust duct, silencer-box end, against PB1
if m.AE(m.KE1) >= m.BE(m.KE1)
    m.AK = .9;
end
if m.AE(m.KE1) < m.BE(m.KE1)
    m.AK = .75;
end
if strcmp(m.SIL, 'ABSORPTION')
    m.AK = .6;
end
[tmp, m.AK] = sub_port(m, m.AE(m.KE1), m.PB1, m.AK);        % 294 PORT(BE(KE1),AE(KE1),PB1,AK)
m.BE(m.KE1) = tmp;

% ---- 295-297: exhaust diffuser, silencer-box end, against PB1
if m.AET(1) >= m.BET(1)
    m.AK = .75;
end
if m.AET(1) < m.BET(1)
    m.AK = .9;
end
[tmp, m.AK] = sub_port(m, m.BET(1), m.PB1, m.AK);           % 297 PORT(AET(1),BET(1),PB1,AK)
m.AET(1) = tmp;

% ---- 298-300: exhaust diffuser, open end, against PA
if m.AET(m.KE2) >= m.BET(m.KE2)
    m.AK = .9;
end
if m.AET(m.KE2) < m.BET(m.KE2)
    m.AK = .75;
end
[tmp, m.AK] = sub_port(m, m.AET(m.KE2), m.PA, m.AK);        % 300 PORT(BET(KE2),AET(KE2),PA,AK)
m.BET(m.KE2) = tmp;

% ---- 301-302: inlet duct, throttle end, against PA. AK is the throttle area
%      ratio THAR, i.e. this is the load control.
m.AK = m.THAR;
[tmp, m.AK] = sub_port(m, m.AI(m.KI), m.PA, m.AK);          % 302 PORT(BI(KI),AI(KI),PA,AK)
m.BI(m.KI) = tmp;

% ---- 303-305: transfer duct, crankcase end, against PCC1
if m.AT(m.KT) >= m.BT(m.KT)
    m.AK = .9;
end
if m.AT(m.KT) < m.BT(m.KT)
    m.AK = .75;
end
[tmp, m.AK] = sub_port(m, m.AT(m.KT), m.PCC1, m.AK);        % 305 PORT(BT(KT),AT(KT),PCC1,AK)
m.BT(m.KT) = tmp;

% =========================================================================
% 306-318: the port pressure ratios [FIX3]
%
% These were at blair_clean.bas 355-356 as printed (blair_full.bas 273-278),
% i.e. AFTER the port routines that consume them. Moved here, between the last
% PORT call and the first consumer. They must be after both PIPE and PORT,
% which rewrite AE(1), BE(1), AI(1), BI(1), AT(1), BT(1).
%
% m.ratio_order='late' reproduces Blair's own order instead, so the size of
% the FIX3 effect can be measured without editing this file. The default is
% 'early', i.e. the fixed order. On the QUB 400 case the two agree to 4
% significant figures: for the transfer duct the amplitudes AT(1)/BT(1) are
% not touched between the two positions, and the exhaust and inlet branches
% that PEX/PIR select are either identical (CCE/CDE) or differ only on the
% step where the port is at the exact opening height.
% =========================================================================
if ~(isfield(m, 'ratio_order') && strcmp(m.ratio_order, 'late'))
    m.PEX  = ((m.AE(1)      + m.BE(1))/2)^7;                % 313
    m.PIR  = ((m.AI(1)      + m.BI(1))/2)^7;                % 314
    m.PTR  = ((m.AT(1)      + m.BT(1))/2)^7;                % 315
    m.PTRO = ((m.AT(m.KT)   + m.BT(m.KT))/2)^7;             % 316  dead
    m.PEXP = ((m.AE(m.KE1)  + m.BE(m.KE1))/2)^7;            % 317  dead
    m.PEXT = ((m.AET(1)     + m.BET(1))/2)^7;               % 318  dead
end

% =========================================================================
% 319-324: the six port-state dispatches
%
% The inlet cascade has NO case for HTDC=HIOT: neither branch runs and AI(1),
% BI(1), AKI carry over unchanged for that one step (VERIFY_STRUCTURE.md 1.4).
% Reproduced, not repaired.
% =========================================================================
if m.HTDC <= m.HEOT
    m = local_export_shut(m);                               % 319
end
if m.HTDC > m.HEOT
    m = local_export_open(m);                               % 320
end
if m.HTDC <= m.HTOT
    m = local_trport_shut(m);                               % 321
end
if m.HTDC > m.HTOT
    m = local_trport_open(m);                               % 322
end
if m.HTDC < m.HIOT
    m = local_inport_open(m);                               % 323
end
if m.HTDC > m.HIOT
    m = local_inport_shut(m);                               % 324
end

% ---- Blair's own (stale) ratio position, for the A/B test in m.ratio_order
if isfield(m, 'ratio_order') && strcmp(m.ratio_order, 'late')
    m.PEX  = ((m.AE(1)      + m.BE(1))/2)^7;
    m.PIR  = ((m.AI(1)      + m.BI(1))/2)^7;
    m.PTR  = ((m.AT(1)      + m.BT(1))/2)^7;
    m.PTRO = ((m.AT(m.KT)   + m.BT(m.KT))/2)^7;
    m.PEXP = ((m.AE(m.KE1)  + m.BE(m.KE1))/2)^7;
    m.PEXT = ((m.AET(1)     + m.BET(1))/2)^7;
end

% =========================================================================
% 325-334: shock corrections. 325 and 331 are the duplicate [D17], kept.
% =========================================================================
[m.AE,  m.BE]  = sub_shok(m.AE,  m.BE,  m.KO, m.KE1);       % 325
[m.AE,  m.BE]  = sub_shok(m.AE,  m.BE,  m.KO, m.KE1);       % 331 [D17]
[m.AET, m.BET] = sub_shok(m.AET, m.BET, m.KO, m.KE2);       % 332
[m.AT,  m.BT]  = sub_shok(m.AT,  m.BT,  m.KO, m.KT);        % 333
[m.AI,  m.BI]  = sub_shok(m.AI,  m.BI,  m.KO, m.KI);        % 334

% =========================================================================
% 335-343: the three flows into the two fixed-volume boxes
% =========================================================================

% ---- 335-337: transfer duct, crankcase end, out of the crankcase
if m.AT(m.KT) >= m.BT(m.KT)
    m.CD = .9;
end
if m.AT(m.KT) < m.BT(m.KT)
    m.CD = .75;
end
[m.HTKT, m.CTKT, m.MTKT, m.D] = sub_flow_out(m, ...
    m.BT(m.KT), m.AT(m.KT), m.FTDUCT, m.TCC1, m.CD);        % 337

% ---- 338-340: exhaust duct, silencer-box end, into the box
if m.AE(m.KE1) >= m.BE(m.KE1)
    m.CD = 1;
end
if m.AE(m.KE1) < m.BE(m.KE1)
    m.CD = .75;
end
[m.HEK1, m.CEK1, m.MEK1, m.D] = sub_flow_out(m, ...
    m.AE(m.KE1), m.BE(m.KE1), m.FEP1, m.TC1, m.CD);         % 340

% ---- 341-343: exhaust diffuser, silencer-box end, out of the box
if m.AET(1) >= m.BET(1)
    m.CD = .75;
end
if m.AET(1) < m.BET(1)
    m.CD = 1;
end
[m.HET1, m.CET1, m.MET1, m.D] = sub_flow_out(m, ...
    m.AET(1), m.BET(1), m.FEP2, m.TB1, m.CD);               % 343

% =========================================================================
% 344-347: the three box integrations
% =========================================================================

% ---- 344: the silencer box. VB1 and VB2 are BOTH VBOXM, so p dV work is
%      zero and BOXW is a dead store (VERIFY_STRUCTURE.md 2.4).
[m.PB1, m.PB2, m.TB1, m.TB2, m.VB1, m.MB1, m.MB2, m.BOXW] = sub_box(m, ...
    m.PB1, m.PB2, m.TB1, m.TB2, m.VBOXM, m.VBOXM, ...
    m.MB1, m.MB2, m.MEK1, m.MET1, m.CEK1, m.CET1, m.HEK1, m.HET1);

% ---- 345: the crankcase. VB1=VCC1, VB2=VCC2 and BOX's VB1=VB2 assigns the
%      caller's variable (BASIC passes by reference), so VCC1 must be taken
%      back from the returned VB1 - that is how the crankcase volume for the
%      next step is supplied. See SUB_BOX.
[m.PCC1, m.PCC2, m.TCC1, m.TCC2, m.VCC1, m.MCC1, m.MCC2, m.CCWORK] = sub_box(m, ...
    m.PCC1, m.PCC2, m.TCC1, m.TCC2, m.VCC1, m.VCC2, ...
    m.MCC1, m.MCC2, m.MI1, m.MTKT, m.CI1, m.CTKT, m.HI1, m.HTKT);

% ---- 346-347: the cylinder. Closed cycle (CYLINDER) while the exhaust port
%      is shut, open volume (BOX) while it is open. MC2 is passed to CYLINDER as
%      the mass (BUILD_MANIFEST 9.3: MC2, not MC1 - not "fixed" here).
if m.HTDC <= m.HEOT
    m = sub_cylinder(m);                                    % 346
else
    [m.PC1, m.PC2, m.TC1, m.TC2, m.VC1, m.MC1, m.MC2, m.CYWORK] = sub_box(m, ...
        m.PC1, m.PC2, m.TC1, m.TC2, m.VC1, m.VC2, ...
        m.MC1, m.MC2, m.MT1, m.ME1, m.CT1, m.CE1, m.HT1, m.HE1);   % 347
end

% =========================================================================
% 348-351: the two MEP integrals
%
% 348 IF CYCLE>1 THEN GOTO 426 ELSE GOTO 427
% 349 427 IF DEG<180 THEN GOTO 428
% 350 426 CCMEP=CCMEP+CCWORK/SV
% 351     CYMEP=CYMEP+CYWORK/SV
% 352 428
%
% The first cycle is 444 deg long (it starts at EPO, not at BDC), so its
% increment below DEG=180 is dropped; every later cycle is exactly 360 deg.
% =========================================================================
if m.CYCLE > 1
    m.CCMEP = m.CCMEP + m.CCWORK/m.SV;
    m.CYMEP = m.CYMEP + m.CYWORK/m.SV;
elseif m.DEG >= 180
    m.CCMEP = m.CCMEP + m.CCWORK/m.SV;
    m.CYMEP = m.CYMEP + m.CYWORK/m.SV;
end

% =========================================================================
% 352-354: the three remaining pressure ratios
% (PEX PIR PTR PTRO PEXP PEXT were moved to 303-315 by [FIX3])
% =========================================================================
m.PCR  = m.PC2/m.PA;                                        % 352
m.PCCR = m.PCC2/m.PA;                                       % 353
m.PBR  = m.PB2/m.PA;                                        % 354

% =========================================================================
% 357-370: the screen plot dispatch and the bottom of the loop
%
% 357 IF ANGD>EPC THEN GOTO 310 : 358 IF ANGD>EPO THEN GOTO 305 ELSE GOTO 307
% 359 305 IF ANGD<=EPO+DC THEN GOSUB SPLOT1
% 360 307 IF ANGD>EPO THEN GOSUB SPLOT2
% 361 310 IF ANGD>EPC THEN GOTO 405 ELSE GOTO 407
% 362 405 IF ANGD<=EPC+DC THEN GOSUB SPLOT3
% 363 407 IF ANGD>EPC THEN GOSUB SPLOT4
% Not translated: SPLOT1..4 are display only (see the file header).
% =========================================================================

% ---- 369: IF KK>=20000 THEN GOTO 500 (the FOR KK=1 TO 20000 guard, [FIX5])
if m.KK >= 20000
    m.stop = true;
end

end


% =========================================================================
%  RESETBDC - blair_clean.bas 486-515   "close the cycle at BDC"
% =========================================================================
function m = local_reset_bdc(m)
% Called from 277 when DEG>540. Rolls the per-cycle results into the history
% arrays and clears the two MEP integrals.

m.DEG = m.DEG - 360;                                        % 487
m.JJ  = m.JJ + 1;                                           % 488

m.DELRAT(m.JJ) = m.DRATIO;                                  % 489
m.PEAKP(m.JJ)  = m.PMAX;                                    % 490
m.PEAKT(m.JJ)  = m.TKMAX;                                   % 491
m.PMEP(m.JJ)   = m.CCMEP;                                   % 492
m.CMEP(m.JJ)   = m.CYMEP;                                   % 493
m.BMEP(m.JJ)   = m.CMEP(m.JJ) + m.PMEP(m.JJ) - m.FMEP;      % 494
m.POWER(m.JJ)  = (m.CMEP(m.JJ) + m.PMEP(m.JJ) - m.FMEP)*m.SV*m.RPS/1000;  % 495
m.FUEL(m.JJ)   = m.DRATIO*m.MREF/m.TAF;                     % 496

% 497: BSFC(JJ)=FUEL(JJ)*RPS*3600/POWER(JJ). Blair has no guard: if FMEP
% reaches CMEP+PMEP the division is by zero. In BASIC that is a runtime
% error; here it yields Inf, which BLAIR_RUN reports rather than hides.
m.BSFC(m.JJ) = m.FUEL(m.JJ)*m.RPS*3600/m.POWER(m.JJ);       % 497

% 498-508: LOCATE/PRINT of the cycle results - display only, not translated.
% 509: IF CYCLE=CYCLEP THEN GOTO 433 (skip the pause) - display only.

m.CCMEP  = 0;                                               % 510
m.CYMEP  = 0;                                               % 511
m.DRAT   = m.DRATIO;                                        % 512
m.DRATIO = 0;                                               % 513

end


% =========================================================================
%  RESETTDC - blair_clean.bas 522-541   "close the scavenging period"
% =========================================================================
function m = local_reset_tdc(m)
% Called from 279 when 360 < DEG <= 360+DC, i.e. at TDC.
%
% INDEX OFFSET (the one place the port does not use Blair's index)
%   Blair stores SEFFP(JJ) at 523-528 and only THEN, at 488 in RESETBDC, does
%   JJ become the cycle number. So cycle n's scavenging data lands in slot
%   n-1 - slot 0 for the first cycle, which BASIC allows and MATLAB does not -
%   while cycle n's MEPs land in slot n. DATOUT then prints both rows from the
%   same subscript and pairs them one cycle apart (VERIFY_STRUCTURE.md 7.1).
%   The port stores at JJ+1, so that slot n holds cycle n's scavenging and
%   matches DELRAT(n), CMEP(n) ... in RESETBDC. The physics is untouched; which
%   cycle a printed row belongs to is corrected, and that correction is why
%   BLAIR_RUN can report SE/TE/CE and DR from the same cycle index.
%
%   Blair's offset is left in blair_clean.bas: this is a translation decision,
%   not a fix to the BASIC.

n = m.JJ + 1;
if n > numel(m.SEFFP)
    error('blair_step:historyOverflow', ...
        ['RESETTDC would write history slot %d of %d (blair_clean.bas 523).\n' ...
         'Raise the DIMs at blair_clean.bas 63-64 with CYCLESTOP, or lower ' ...
         'CYCLESTOP (currently %d).'], n, numel(m.SEFFP), m.CYCLESTOP);
end

m.SEFFP(n) = m.SEFF;                                        % 523
m.TEFFP(n) = m.TEFF;                                        % 524
m.CEFFP(n) = m.CEFF;                                        % 525
m.SRMP(n)  = m.SCRATIO;                                     % 526
m.SRVP(n)  = m.SR;                                          % 527
m.EXRP(n)  = m.EXRATIO;                                     % 528

% 529-539: LOCATE/PRINT - display only, not translated.
% 540: IF CYCLE=CYCLEP THEN GOTO 434 - display only.

m.MBACK   = 0;                                              % 541
m.SCRATIO = 0;                                              % 542
m.EXRATIO = 0;                                              % 543
m.SR      = 0;                                              % 544

end


% =========================================================================
%  EXPORTSHUT - blair_clean.bas 1048-1052
% =========================================================================
function m = local_export_shut(m)
m.AKE  = 0;                                                 % 1049
m.ME1  = 0;                                                 % 1050
m.AE(1) = m.BE(1);                                          % 1051
end


% =========================================================================
%  EXPORTOPEN - blair_clean.bas 1059-1077
% =========================================================================
function m = local_export_open(m)
% The two IF/IF pairs at 1060/1061 (CCE) and 1066/1067 (CDE) have identical
% right-hand sides: dead conditionals left by [D13]. VERIFY_STRUCTURE.md 7.2
% warns that 1005/1006 (the TC1/TCC1 pair in TRPORTOPEN) LOOKS the same and is
% not. All of them are kept as printed.

m.PC1R = m.PC1/m.PA;                                        % 1060
if m.PEX <= m.PC1R
    m.CCE = .8;
end
if m.PEX > m.PC1R
    m.CCE = .8;
end
m.AKE = fport(m.HEOT, m.HTDC, m.EXHT, m.FEPRT, m.FEP1, m.CCE);   % 1063
[tmp, m.AKE] = sub_port(m, m.BE(1), m.PC1, m.AKE);          % 1064
m.AE(1) = tmp;
if m.PEX <= m.PC1R
    m.CDE = .75;
end
if m.PEX > m.PC1R
    m.CDE = .75;
end
% 1067/1075: the reference temperature is TC1 in BOTH branches ([D13]: the
% transcription reads "TCT" in the second one; TC1 is the resolved reading, and
% the two branches are numerically identical as a result).
if m.PEX <= m.PC1R
    [m.HE1, m.CE1, m.ME1, m.D] = sub_flow_out(m, ...
        m.AE(1), m.BE(1), m.FEP1, m.TC1, m.CDE);            % 1067
end
if m.PEX > m.PC1R
    [m.HE1, m.CE1, m.ME1, m.D] = sub_flow_out(m, ...
        m.AE(1), m.BE(1), m.FEP1, m.TC1, m.CDE);            % 1075
end
m.EXRATIO = m.EXRATIO + m.ME1*m.DTM/m.MREF;                 % 1076
end


% =========================================================================
%  TRPORTSHUT - blair_clean.bas 1083-1087
% =========================================================================
function m = local_trport_shut(m)
m.AKT  = 0;                                                 % 1084
m.MT1  = 0;                                                 % 1085
m.AT(1) = m.BT(1);                                          % 1086
end


% =========================================================================
%  TRPORTOPEN - blair_clean.bas 1098-1113
% =========================================================================
function m = local_trport_open(m)
% SCAVENGING MODEL No.1, Eqn.5.1.1. The model-2 body is not in this file
% ([D11]; its three-line diff is in BUILD_MANIFEST.md section 3a).

if m.PTR <= m.PC1R
    m.CCT = .8;                                             % 1099
end
if m.PTR > m.PC1R
    m.CCT = .8;                                             % 1100   identical
end
m.AKT = fport(m.HTOT, m.HTDC, m.TRHT, m.FTPRT, m.FTDUCT, m.CCT);  % 1101
[tmp, m.AKT] = sub_port(m, m.BT(1), m.PC1, m.AKT);          % 1102
m.AT(1) = tmp;
if m.PTR <= m.PC1R
    m.CDT = .75;                                            % 1103
end
if m.PTR > m.PC1R
    m.CDT = .75;                                            % 1104   identical
end
% 1105/1106: THIS pair is not identical - it passes TC1 in one branch and
% TCC1 in the other. Do not collapse it with the pairs above ([D13]).
if m.PTR <= m.PC1R
    [m.HT1, m.CT1, m.MT1, m.DSCAV] = sub_flow_out(m, ...
        m.BT(1), m.AT(1), m.FTDUCT, m.TC1, m.CDT);          % 1105
end
if m.PTR > m.PC1R
    [m.HT1, m.CT1, m.MT1, m.DSCAV] = sub_flow_out(m, ...
        m.BT(1), m.AT(1), m.FTDUCT, m.TCC1, m.CDT);         % 1106
end
m.EXPAND  = m.PTR/m.PC1R;                                   % 1107
% *** BOOK-PAGE REPAIR, VERIFIED AGAINST THE BOOK PAGE (book p.594) ***
% blair_clean.bas 1108 and the printed page 594 agree character for character:
%       VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1
% so this is NOT a transcription defect - it is an inconsistency inside Blair's
% own printed code. Section 5.1.5 (Eqs.5.1.6/5.1.7, pp.217-219) defines
%       dVF = dt*CGt1*Ft1          dMF = Dt1*dVF
% i.e. the mass increment is the density times the SAME volume increment, and
% Eq.5.1.12 sums dVF with no coefficient in it. But SUB OUTFLOW (p.310) returns
% an INVISCID velocity C and applies the discharge coefficient only to the mass,
%       M=CD*C*F*D
% so the mass accumulator two statements below (SCRATIO, via MT1) and the volume
% accumulator here (SR, via VOLINC) integrate flows differing by 1/CD. That is
% the measured SRv/SRm = 1.547 against the book's 1.134/0.874 = 1.2975.
% CDT is the coefficient the routine itself sets at 1103/1104 (.75, both
% branches) and the one already passed to OUTFLOW - not a fitted number.
% Evidence and measurements: SRV_INVESTIGATION.md secs.4-6.
% The old (as-printed) value remains switchable for the record: set
%   m.VOLINC_AS_PRINTED = true
% before BLAIR_RUN to restore line 1108 verbatim (SRv 1.4225, power 13.83 kW).
if isfield(m, 'VOLINC_AS_PRINTED') && m.VOLINC_AS_PRINTED
    m.VOLINC = m.CT1*m.FTDUCT*m.DTM*m.EXPAND/m.VC1;         % 1108 as printed
else
    m.VOLINC = m.CDT*m.CT1*m.FTDUCT*m.DTM*m.EXPAND/m.VC1;   % 1108 + missing CDT
end
m.SCRATIO = m.SCRATIO + m.MT1*m.DTM/m.MREF;                 % 1109
if m.SCRATIO < 0
    return                                                  % 1110 GOTO 911
end
m.SR   = m.SR + m.VOLINC;                                   % 1111
m.SEFF = 1 - exp(m.MSC*m.SR + m.CSC);                       % 1112
end


% =========================================================================
%  INPORTSHUT - blair_clean.bas 1119-1123
% =========================================================================
function m = local_inport_shut(m)
m.AKI  = 0;                                                 % 1120
m.MI1  = 0;                                                 % 1121
m.AI(1) = m.BI(1);                                          % 1122
end


% =========================================================================
%  INPORTOPEN - blair_clean.bas 1130-1146
% =========================================================================
function m = local_inport_open(m)
m.PCC1R = m.PCC1/m.PA;                                      % 1131
if m.PIR <= m.PCC1R
    m.CCI = .8;                                             % 1132
end
if m.PIR > m.PCC1R
    m.CCI = .9;                                             % 1133
end
% 1139: FIPRT is passed TWICE, for both FPRT and FPIP, so the area ratio is
% identically 1 and AKI=CCI*FINST ([D14]). FIPM - the inlet pipe area, computed
% in BLAIR_INIT and read nowhere - is the likely intended second argument.
% Not changed: that would be rewriting logic, not translating it.
% The first two arguments are (HTDC,HIOT), the reverse of the sibling calls at
% 1063 and 1101. That is correct as printed and must NOT be normalised: it
% makes FINST ramp 0->1 as HTDC FALLS from HIOT to HIFT ([D12]/VERIFY_STRUCTURE.md 5).
m.AKI = fport(m.HTDC, m.HIOT, m.INHT, m.FIPRT, m.FIPRT, m.CCI);   % 1139
[tmp, m.AKI] = sub_port(m, m.BI(1), m.PCC1, m.AKI);         % 1140
m.AI(1) = tmp;
if m.PIR <= m.PCC1R
    m.CDI = .75;                                            % 1141
end
if m.PIR > m.PCC1R
    m.CDI = .9;                                             % 1142
end
if m.PIR <= m.PCC1R
    [m.HI1, m.CI1, m.MI1, m.D] = sub_flow_out(m, ...
        m.BI(1), m.AI(1), m.FIPRT, m.TCC1, m.CDI);          % 1143
end
if m.PIR > m.PCC1R
    [m.HI1, m.CI1, m.MI1, m.D] = sub_flow_in(m, ...
        m.BI(1), m.AI(1), m.FIPRT, m.TIREF, m.CDI);         % 1144
end
m.DRATIO = m.DRATIO + m.MI1*m.DTM/m.MREF;                   % 1145
end
