REM ==========================================================================
REM  BLAIR PROG.5.1 - "ENGINE MODEL NO.1" - ASSEMBLED SINGLE-FILE SOURCE
REM  Assembled from, and ONLY from:
REM    port/blair_prog51_basic.txt       (main program, transcript lines 1-683)
REM    port/blair_subroutines_basic.txt  (Section A = book source 27565-28192)
REM  Every conflict resolution is logged as [Dnn] and explained one-for-one in
REM  port/BUILD_MANIFEST.md. Nothing here is rewritten: only merged, and where
REM  two definitions of one name exist, one was chosen and the other dropped.
REM
REM  ORDER: main program (with the subroutines Blair prints inline in it),
REM         then the ProgList 5.0 common block in the book's own order.
REM         Each unit is preceded by a REM line giving its book source range
REM         and its range in the transcription file.
REM
REM  LABEL SCOPE - READ BEFORE TRANSLATING [D23]
REM    * Labels (line numbers) at the head of a statement OUTSIDE any SUB block
REM      live in ONE namespace - the main module - whether they belong to the
REM      main loop or to a GOSUB-style routine (15 16 17 18 19 20 21 22 25 50
REM      305 307 310 405 407 410 426 427 428 430 431 433 434 439 500 501 502
REM      631 632 633 634 635 639 911). They are unique in this file.
REM    * Labels INSIDE a SUB...END SUB block (FPORT, STAB, SETS, AREA, PIPE,
REM      SHOK, PORT, NINT, OUTFLOW, INFLOW, BOX, PISTPOS, PAREA, CYLINDER) are
REM      local to that SUB under QBasic STATIC semantics. As printed,
REM      CYLINDER's 20 30 50 60 70 80 90, PIPE's 23 33 44 55 and SHOK's 26 56
REM      do NOT collide with the main module, but CYLINDER's 20 and 50 do once
REM      the label space is flattened - they are renamed below [FIX2].
REM
REM  SUB-LOCAL LABELS ARE RENAMED FOR A FLAT NAMESPACE [FIX2]
REM    CYLINDER's 20 and 50 collide with the main module's 20 (TRPIPDAT) and
REM    50 (main data menu). They are renamed C20 and C50, together with their
REM    three references. CYLINDER's 30 60 70 80 90, PIPE's 23 33 44 55 and
REM    SHOK's 26 56 are unique across the whole file and are left as printed.
REM
REM ==========================================================================
REM  STATIC - THE FROZEN DECISION [FIX4]  ***read this before translating***
REM
REM    DECISION: every SUB in this file is STATIC, and STATIC IS HONOURED.
REM    A SUB's local variables PERSIST BETWEEN CALLS. They are zeroed once,
REM    at program start, and are NOT re-zeroed on entry. They are still
REM    private to the SUB: a SUB local never aliases a main-module variable of
REM    the same name.
REM
REM    WHY THIS HAD TO BE FROZEN: the file as assembled contradicted itself -
REM    the header (blair_full.bas 28-31) claimed locals "start at 0 on every
REM    call", i.e. automatic, while all 14 SUB statements end in STATIC. The
REM    printed keyword wins, because three of Blair's results depend on it:
REM
REM      * CYLINDER HT1 (read 1475, written 1495): with STATIC, HT1 holds the
REM        PREVIOUS call's HT2, so QHT=DC*(HT1+HT2)/2 is the TRAPEZOIDAL rule.
REM        With automatic locals it would be a rectangle rule (HT1=0). This
REM        changes total heat release by roughly a factor of two, hence PEAK
REM        PRESSURE, PEAK TEMPERATURE and IMEP. See [D15].
REM      * CYLINDER HT2: it is assigned only on the combustion path (1469,
REM        1472, 1474). On the two GOTO 90 paths it keeps the value from the
REM        previous call. Only STATIC makes that well defined.
REM      * CYLINDER S1 S2 S3 IGN BURNEND TAILDEG PEAK QMAX HEAT MAIR: for a
REM        call with DEGC>EPC+5 they are read without being re-assigned in
REM        that call, so they are the previous call's values.
REM      * CYLINDER DELTAP DPMAX: DELTAP is only written when P2>P1 (1487),
REM        then compared with the persistent DPMAX (1491).
REM      * NINT's KI is a local, so the caller's mesh count is incremented
REM        exactly once at 1331. With KI made global, CALL NINT(KI,...) for
REM        the inlet duct would alias it and increment it twice. See [D7].
REM
REM    A port MUST therefore carry HT1 HT2 DPMAX DELTAP and the combustion
REM    block as per-SUB persistent state, initialised to 0 once per run, and
REM    must NOT lift them to the main-module namespace: the main module
REM    already uses HT1 as the transfer-port enthalpy (written at 1005/1006,
REM    consumed by BOX at 265). Aliasing those two is [D15]'s failure mode.
REM ==========================================================================
REM
REM  BLOCKERS: this file applies the five fixes listed in port/CLEAN_LOG.md
REM  (title block, the two colliding CYLINDER labels, the pressure-ratio order,
REM  the STATIC decision, the PRINTOUT replay). The other 25 non-blocking
REM  defects of VERIFY_STRUCTURE.md are deliberately left as printed.
REM  The external artefact is the data file "UFLO" (21 rows x 41 columns,
REM  ASCII, comma separated) opened below. It is not printed in either book,
REM  but port/uflo.csv is the regenerated table - install it as "UFLO" (no
REM  extension) in the working directory. See BUILD_MANIFEST.md sec.8.
REM ==========================================================================


REM ==========================================================================
REM  MAIN PROGRAM  -  PROG.5.1
REM  book source 26032-26424 | transcription lines 4-232
REM ==========================================================================
REM [FIX1] deleted: the book's listing title block (blair_full.bas 45-47)
REM PROGRAM Prog.5.1
REM ProgList.5.1
DIM ABX(21,45),BX(45),AKA(45),DF(20),F(20)
DIM AE(20),BE(20),FE(20),DFE(20)
DIM AI(20),BI(20),FI(20),DFI(20)
DIM AT(20),BT(20),FT(20),DFT(20)
DIM AET(20),BET(20),FET(20),DFET(20)
DIM A2(20),B2(20)
DIM XA(200),YC(200),YS(200),YE(200),YI(250)
DIM YF(13)
DIM YV(250),YP(250),XXA(250),YB(250)
REM [D20] ADDED BY ASSEMBLY - not a line of Blair's listing. The per-cycle
REM history arrays below are never DIMed in the book; QBasic silently gives
REM them 11 elements (0..10). Indices used are 1..CYCLESTOP (7). Declared here
REM so a translator cannot invent a different (or absent) bound.
DIM DELRAT(20),PEAKP(20),PEAKT(20),PMEP(20),CMEP(20),BMEP(20),POWER(20),FUEL(20)
DIM BSFC(20),SEFFP(20),TEFFP(20),CEFFP(20),SRMP(20),SRVP(20),EXRP(20)
PI=3.141593
RTOD=180/PI
DTOR=1/RTOD
TAF=13
KO=1
OPEN"I",#1,"UFLO"
REM <UNRESOLVED #1: "OPENT\#l."UFLO"> file mode character is legible only as
REM  "T"; no such mode exists. Assumed "I" (input) because ABX is read from it.
REM  [D21] - this is the only unresolved marker in the file that is resolved
REM  by inference from the code that follows it. See BUILD_MANIFEST.md.
FOR I=1 TO 21 STEP 1
FOR J=1 TO 41 STEP 1
INPUT#1,ABX(I,J)
NEXT J
NEXT I
FINISH:
CLOSE#1
FOR J=1 TO 41
BX(J)=ABX(1,J)
NEXT J
AKA(1)=0
FOR I=2 TO 21
AKA(I)=AKA(I-1)+.05
NEXT I
50 INPUT "RESPONSE FOR NEW DATA IS 'N' AND FILED DATA IS 'F'";H$
IF H$="F" THEN GOSUB FILED
IF H$="F" THEN GOSUB FILESET
IF H$="F" THEN GOTO 502
CLS
INPUT "NEW BASIC ENGINE DATA(Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB ENGINEDAT
INPUT "NEW EXHAUST PORT DATA (Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB EXPORTDAT
INPUT "NEW TRANSFER PORT DATA (Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB TRPORTDAT
INPUT "NEW INLET PORT DATA (Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB INPORTDAT
INPUT "NEW EXHAUST PIPE DATA (Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB EXPIPDAT
INPUT "NEW TRANSFER PIPE DATA (Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB TRPIPDAT
INPUT "NEW INLET PIPE DATA (Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB INPIPDAT
INPUT "NEW DATA FOR CLOSED CYCLE(Y/N?)";ANS$
IF ANS$="Y" THEN GOSUB COMBDAT
502 GOSUB DATASET
GOSUB PORTSTART
INPUT "TYPE 'RUN' FOR CALCULATION OR NEW FOR A DATA CHANGE";Z$
IF Z$="NEW" THEN GOTO 50
CALL PAREA(NEP,WEPM,EXHT,RTEM,RBEM,FEPRT,DEPRT)
CALL PAREA(NTP,WTPM,TRHT,RTTM,RBTM,FTPRT,DTPRT)
CALL PAREA(NIP,WIPM,INHT,RTIM,RBIM,FIPRT,DIPRT)
FTDUCT=TRAR*FTPRT
DTDUCT=SQR(4*FTDUCT/PI)
TSV=FPISTON*HEOT
CYCV=TSV/(TCR-1)
VC1=TSV+CYCV
VCC1=CCCV+FPISTON*HEOB
CLS
CYC=1
NN=0
JJ=0
CCMEP=0
CYMEP=0
SEFF=0
CEFF=0
TEFF=0
MBACK=0
DRATIO=0
SCRATIO=0
EXRATIO=0
DRAT=1
SR=0
GE=1.4
GK=287
CCP=1005
CCV=718
GR=GE*GK
N27=1/3.5
N17=1/7
PA=101325!
TA=293
GOSUB CYLSTART
DA=PA/(GK*TA)
MREF=SV*DA
PC1=TCR*PA/2.5
TC1=1900
DCYL=PC1/(GK*TC1)
PCC1=.9*CCR*PA
DCC=PCC1/(GK*TTREF)
TEXC=TEREF-273
MC1=VC1*DCYL
MCC1=VCC1*DCC
TC1=PC1*VC1/(GK*MC1)
TCC1=PCC1*VCC1/(GK*MCC1)
PB1=1.1*PA
TB1=TEREF
MB1=PB1*VBOXM/(GK*TB1)
CVAL=4.3E+07
DEG=EPO
LMESH=30
CALL NINT(KE1,LEP1,TEREF,TEREF)
CALL NINT(KE2,LEP2,TEREF,TEREF)
CALL NINT(KT,LTP,TEREF,TTREF)
CALL NINT(KI,LIP,TEREF,TIREF)
LEM1=LE1M/(KE1-1)
LEM2=LE2M/(KE2-1)
LIMESH=LIM/(KI-1)
LTMESH=LTM/(KT-1)
CALL SETS(AE(),BE(),KE1)
CALL SETS(AET(),BET(),KE2)
CALL SETS(AT(),BT(),KT)
CALL SETS(AI(),BI(),KI)
CALL AREA(DE2M,DE2M,KO,KE2,DFET(),FET())
CALL AREA(DE1M,DE1M,KO,KE1,DFE(),FE())
CALL AREA(DTDUCT,DTDUCT,KO,KT,DFT(),FT())
CALL AREA(DIPRT,DIPM,KO,KI,DFI(),FI())
COUNT=0
PCOUNT=0
ANGD=EPO
CYCLE=1
CYCLESTOP=7
CYCLEP=CYCLESTOP+10
REM ==========================================================================
REM  [FIX5] THE PRINTOUT REPLAY - EXPLICIT MODE FLAG, NO FOR/NEXT IMBALANCE
REM ------------------------------------------------------------------------
REM  As printed in blair_full.bas this was a coroutine: the FOR KK loop at 188
REM  was left by GOTO 500 (line 206), re-entered at label 430 by PRINTOUT
REM  (340), left again by GOTO 431 (205), and its FOR frame was finally popped
REM  by NEXT KK (286) only if the user asked for a printout. NEXT without FOR
REM  on the second P, and no TRANSLATABLE return path out of PRINTOUT at all.
REM
REM  Replaced by:
REM    * PRINTMODE, an explicit flag. 0 = normal run, 1 = printer replay.
REM    * an explicit step counter KK, incremented at the bottom of the body,
REM      with the loop entered at ONE point, label CYCLELOOP (the old 188).
REM    * PRINTOUT now RETURNS to its caller: it prints the tables, opens the
REM      printer, sets PRINTMODE=1 and unwinds. The replay itself is started
REM      from the 500 menu by the flag test, and it ends at label 431, which
REM      closes the printer, clears the flag and returns to the 500 menu.
REM
REM  Behaviour preserved: P still prints the data tables, still computes one
REM  further revolution (CYCLE=17=CYCLEP) with the plots going to the printer,
REM  and still returns to the menu. What changes is only where that revolution
REM  is entered - at the loop head instead of in the middle of the body, which
REM  costs one extra DC of crank angle in the printed plot and nothing else.
REM  That revolution's results are discarded (JJ is not advanced into the
REM  history) exactly as before.
REM ==========================================================================
PRINTMODE=0
KK=0
CYCLELOOP:
KK=KK+1
DZ=1
NN=NN+1
CALL STAB(AET(),BET(),KE2,SDE,LEM2)
CALL STAB(AT(),BT(),KT,SDT,LTMESH)
CALL STAB(AI(),BI(),KI,SDI,LIMESH)
CALL STAB(AE(),BE(),KE1,SDE,LEM1)
REM [D18] Blair's listing calls STAB twice on the same exhaust duct here (the
REM  5th call repeats the 4th). Kept: STAB is idempotent on a second pass
REM  (it only ever lowers DZ), so the duplicate changes nothing. See the same
REM  duplication of SHOK below, [D17].
CALL STAB(AE(),BE(),KE1,SDE,LEM1)
DZ=.99*DZ
DEG=DEG+DC
ANGD=ANGD+DC
IF ANGD>360+EPO THEN CYCLE=CYCLE+1
IF PRINTMODE=1 AND CYCLE=CYCLEP THEN GOTO 430
IF PRINTMODE=1 AND CYCLE=CYCLEP+1 THEN GOTO 431
IF PRINTMODE=0 AND CYCLE=CYCLESTOP THEN GOTO 500
430 IF ANGD>360+EPO THEN ANGD=ANGD-360
IF DEG>540 THEN GOSUB RESETBDC
IF DEG>360+DC THEN GOTO 25
IF DEG>360 THEN GOSUB RESETTDC
25 CALL PISTPOS(STM,CRNK,CRLM,DEG,HTDC,HBDC)
VC2=CYCV+HTDC*FPISTON
VCC2=CCCV+HBDC*FPISTON
REM [D19] CYCTRIP is defined nowhere; in BASIC it is 0, so this test is never
REM  true and PCOUNT never increments. PCOUNT is read only by EBLACK, which
REM  PROG.5.1 never calls, so the dead test is harmless. Left as printed.
IF CYC=CYCTRIP THEN PCOUNT=PCOUNT+1
CALL PIPE(KO,KE1,AE(),BE(),DFE(),FE())
CALL PIPE(KO,KE2,AET(),BET(),DFET(),FET())
CALL PIPE(KO,KT,AT(),BT(),DFT(),FT())
CALL PIPE(KO,KI,AI(),BI(),DFI(),FI())
IF AE(KE1)>=BE(KE1) THEN AK=.9
IF AE(KE1)<BE(KE1) THEN AK=.75
IF SIL$="ABSORPTION" THEN AK=.6
CALL PORT(BE(KE1),AE(KE1),PB1,AK)
IF AET(1)>=BET(1) THEN AK=.75
IF AET(1)<BET(1) THEN AK=.9
CALL PORT(AET(1),BET(1),PB1,AK)
IF AET(KE2)>=BET(KE2) THEN AK=.9
IF AET(KE2)<BET(KE2) THEN AK=.75
CALL PORT(BET(KE2),AET(KE2),PA,AK)
AK=THAR
CALL PORT(BI(KI),AI(KI),PA,AK)
IF AT(KT)>=BT(KT) THEN AK=.9
IF AT(KT)<BT(KT) THEN AK=.75
CALL PORT(BT(KT),AT(KT),PCC1,AK)
REM [FIX3] PEX PIR PTR PTRO PEXP PEXT moved here from 273-278, i.e. from
REM  AFTER the boundary calls that consume them to immediately BEFORE them.
REM  They must be evaluated after the PIPE and PORT calls above (those rewrite
REM  AE(1), BE(1), AI(1), BI(1), AT(1), BT(1)) and before the port open/shut
REM  routines, which test them at 961/962 (PEX), 999/1003 (PTR) and 1032/1041
REM  (PIR). As printed in blair_full.bas, step 1 of every run decided the
REM  inlet boundary from PIR=0 and every later step used one-step-stale values.
PEX=((AE(1)+BE(1))/2)^7
PIR=((AI(1)+BI(1))/2)^7
PTR=((AT(1)+BT(1))/2)^7
PTRO=((AT(KT)+BT(KT))/2)^7
PEXP=((AE(KE1)+BE(KE1))/2)^7
PEXT=((AET(1)+BET(1))/2)^7
IF HTDC<=HEOT THEN GOSUB EXPORTSHUT
IF HTDC>HEOT THEN GOSUB EXPORTOPEN
IF HTDC<=HTOT THEN GOSUB TRPORTSHUT
IF HTDC>HTOT THEN GOSUB TRPORTOPEN
IF HTDC<HIOT THEN GOSUB INPORTOPEN
IF HTDC>HIOT THEN GOSUB INPORTSHUT
CALL SHOK(AE(),BE(),KO,KE1)
REM <UNRESOLVED #2: "CALL SHORTAE( ).BE( ),KO.KE1)>" - the first name reads
REM  SHORTAE against SHOK in the three following lines. [D17] Read as SHOK:
REM  this is a duplicate of the call immediately above (same arrays), the
REM  wording "SHOK"+"AE" having been split by the OCR. Kept as a second SHOK
REM  call, which is idempotent (a second pass finds |R1|<1 everywhere).
CALL SHOK(AE(),BE(),KO,KE1)
CALL SHOK(AET(),BET(),KO,KE2)
CALL SHOK(AT(),BT(),KO,KT)
CALL SHOK(AI(),BI(),KO,KI)
IF AT(KT)>=BT(KT) THEN CD=.9
IF AT(KT)<BT(KT) THEN CD=.75
CALL OUTFLOW(BT(KT),AT(KT),FTDUCT,TCC1,HTKT,CTKT,MTKT,D,CD)
IF AE(KE1)>=BE(KE1) THEN CD=1
IF AE(KE1)<BE(KE1) THEN CD=.75
CALL OUTFLOW(AE(KE1),BE(KE1),FEP1,TC1,HEK1,CEK1,MEK1,D,CD)
IF AET(1)>=BET(1) THEN CD=.75
IF AET(1)<BET(1) THEN CD=1
CALL OUTFLOW(AET(1),BET(1),FEP2,TB1,HET1,CET1,MET1,D,CD)
CALL BOX(PB1,PB2,TB1,TB2,VBOXM,VBOXM,MB1,MB2,MEK1,MET1,CEK1,CET1,HEK1,HET1,BOXW)
CALL BOX(PCC1,PCC2,TCC1,TCC2,VCC1,VCC2,MCC1,MCC2,MI1,MTKT,CI1,CTKT,HI1,HTKT,CCWORK)
IF HTDC<=HEOT THEN CALL CYLINDER(PC1,PC2,TC1,TC2,VC1,VC2,MC2,CYWORK)
IF HTDC>HEOT THEN CALL BOX(PC1,PC2,TC1,TC2,VC1,VC2,MC1,MC2,MT1,ME1,CT1,CE1,HT1,HE1,CYWORK)
IF CYCLE>1 THEN GOTO 426 ELSE GOTO 427
427 IF DEG<180 THEN GOTO 428
426 CCMEP=CCMEP+CCWORK/SV
CYMEP=CYMEP+CYWORK/SV
428 PCR=PC2/PA
PCCR=PCC2/PA
PBR=PB2/PA
REM [FIX3] PEX PIR PTR PTRO PEXP PEXT now computed above, at the head of the
REM  boundary section, where they are first used (blair_full.bas 273-278).
IF ANGD>EPC THEN GOTO 310
IF ANGD>EPO THEN GOTO 305 ELSE GOTO 307
305 IF ANGD<=EPO+DC THEN GOSUB SPLOT1
307 IF ANGD>EPO THEN GOSUB SPLOT2
310 IF ANGD>EPC THEN GOTO 405 ELSE GOTO 407
405 IF ANGD<=EPC+DC THEN GOSUB SPLOT3
407 IF ANGD>EPC THEN GOSUB SPLOT4
REM [FIX5] NEXT KK replaced by an explicit counter test. The run-exit tests
REM  (CYCLE=CYCLESTOP and the replay's CYCLE=CYCLEP+1) are still taken at the
REM  head of the body, where blair_full.bas 204-206 put them, so the number of
REM  steps computed is unchanged; only the loop machinery is explicit. KK is
REM  incremented once per pass, at CYCLELOOP.
IF KK>=20000 THEN GOTO 500
GOTO CYCLELOOP
500 INPUT "RESPONSE FOR RECALCULATION IS 'R', PRINTING IS 'P', FILING DATA IS 'F', OR QUITTING IS 'Q'";D$
IF D$="R" THEN GOTO 50
IF D$="F" THEN GOSUB FILING
IF D$="Q" THEN GOTO 501
IF D$="P" THEN GOSUB PRINTOUT
REM [FIX5] PRINTOUT has returned. If it opened the printer it also set
REM  PRINTMODE=1; run the replay revolution and come back here at 431.
IF PRINTMODE=1 THEN GOTO CYCLELOOP
GOTO 500
501 END


REM ==========================================================================
REM  DATOUT    book source: inside PROG.5.1 | transcription lines 233-253
REM  Called by PRINTOUT (GOSUB).
REM ==========================================================================
DATOUT:
KON=100000&
LPRINT
LPRINT "OUTPUT DATA"
LPRINT "POWER,kW BMEP,bar BSFC,kg/kWh IMEP,bar PMEP,bar FMEP,bar"
FOR JJJ=2 TO CYCLESTOP-2
LPRINT USING"######.###";POWER(JJJ),BMEP(JJJ)/KON,BSFC(JJJ),CMEP(JJJ)/KON,-PMEP(JJJ)/KON,FMEP/KON
NEXT JJJ
LPRINT
LPRINT "DELIVERY RATIO SEFF TEFF CEFF SR(mass) SR(vol) exFLOWratio"
FOR JJJ=2 TO CYCLESTOP-2
LPRINT
LPRINT USING"######.###";DELRAT(JJJ),SEFFP(JJJ),TEFFP(JJJ),CEFFP(JJJ),SRMP(JJJ),SRVP(JJJ),EXRP(JJJ)
NEXT JJJ
LPRINT
LPRINT "PEAK PRESSURE, bar and TEMPERATURE, K, from the combustion conditions"
FOR JJJ=2 TO CYCLESTOP-2
LPRINT USING"############.#";PEAKP(JJJ),PEAKT(JJJ)
NEXT JJJ
LPRINT
RETURN


REM ==========================================================================
REM  PRINTOUT  book source: inside PROG.5.1 | transcription lines 254-268
REM  [FIX5] Called by the 500 menu (GOSUB). PRINTS and then RETURNS: it no
REM  longer jumps into the middle of the main loop. The replay of one engine
REM  revolution to the printer is now driven by the caller through PRINTMODE.
REM ==========================================================================
PRINTOUT:
CYCLE=CYCLEP
INPUT "TYPE IN A TITLE FOR THE PRINTOUT";TI$
LPRINT TI$;" on Prog.5.1. ENGINE WITH BOX SILENCER"
GOSUB DATASETL
GOSUB DATOUT
FOR NNN=1 TO 20
LPRINT
NEXT NNN
OPEN "LPT1:" FOR OUTPUT AS #2
REM <UNRESOLVED #3: "OPEN'LPTl :PROMPT" FOR OUTPUT AS#2> - the stray token
REM  between the device name and FOR has no BASIC meaning. [D22] Deleted.
WINDOW OUTPUT#2
REM [FIX5] arm the replay and return to the menu, which starts it. The wrap
REM  that the old "GOTO 430" performed is done here, so that the first replay
REM  pass does not immediately re-cross 360+EPO and bump CYCLE to CYCLEP+1.
PRINTMODE=1
KK=1
IF ANGD>360+EPO THEN ANGD=ANGD-360
RETURN

REM [FIX5] End of the replay: the loop reaches here when CYCLE=CYCLEP+1.
REM  This is the only way out of print mode, and it returns to the 500 menu.
431 CLOSE #2
PRINTMODE=0
GOTO 500


REM ==========================================================================
REM  FILESET   book source: inside PROG.5.1 | transcription lines 269-300
REM  Called after FILED (GOSUB): converts the .BOX file's mm/deg data to SI.
REM ==========================================================================
FILESET:
BOM=BO/1000
STM=ST/1000
CRLM=CRL/1000
RPS=RPM/60
FPISTON=PI*BOM*BOM/4
SV=FPISTON*STM
CCCV=SV/(CCR-1)
CRNK=STM/2
FMEP=100*STM*RPM
WEPM=WEP/1000
RTEM=RTE/1000
RBEM=RBE/1000
WTPM=WTP/1000
RTTM=RTT/1000
RBTM=RBT/1000
WIPM=WIP/1000
RTIM=RTI/1000
RBIM=RBI/1000
LE1M=LEP1/1000
LE2M=LEP2/1000
DE1M=DEP1/1000
DE2M=DEP2/1000
VBOXM=VBOX/1000000!
FEP1=PI*DE1M*DE1M/4
FEP2=PI*DE2M*DE2M/4
LTM=LTP/1000
LIM=LIP/1000
DIPM=DIP/1000
FIPM=PI*DIPM*DIPM/4
TEREF=TEXC+273
RETURN


REM ==========================================================================
REM  RESETBDC  book source: inside PROG.5.1 | transcription lines 301-330
REM  Called when DEG>540 (GOSUB): closes the cycle at BDC.
REM ==========================================================================
RESETBDC:
DEG=DEG-360
JJ=JJ+1
DELRAT(JJ)=DRATIO
PEAKP(JJ)=PMAX
PEAKT(JJ)=TKMAX
PMEP(JJ)=CCMEP
CMEP(JJ)=CYMEP
BMEP(JJ)=CMEP(JJ)+PMEP(JJ)-FMEP
POWER(JJ)=(CMEP(JJ)+PMEP(JJ)-FMEP)*SV*RPS/1000
FUEL(JJ)=DRATIO*MREF/TAF
BSFC(JJ)=FUEL(JJ)*RPS*3600/POWER(JJ)
LOCATE 21,1:PRINT "ENGINE SPEED, rpm=";RPM
LOCATE 22,1:PRINT "POWER, kW=";USING"##.#";POWER(JJ)
LOCATE 22,20:PRINT"BSFC,kg/kWh=";USING"#.###";BSFC(JJ)
LOCATE 22,40:PRINT "BMEP, bar=";USING"##.##";BMEP(JJ)/(100000!)
LOCATE 23,1:PRINT"IMEP,bar=";USING"##.##";CMEP(JJ)/(100000!)
LOCATE 23,20:PRINT"PMEP,bar=";USING"##.##";-PMEP(JJ)/(100000!)
LOCATE 23,40:PRINT"FMEP, bar=";USING "##.##";FMEP/(100000!)
LOCATE 24,1:PRINT "DELIVERY RATIO=";USING"#.###";DRATIO
LOCATE 25,1:PRINT "PEAK CYLINDER PRESS., bar=";USING"###.#";PMAX
LOCATE 25,28:PRINT "and TEMP., K=";USING"####.";TKMAX
LOCATE 25,44:PRINT "at deg.ATDC=";USING"##.#";MAXDEG
IF CYCLE=CYCLEP THEN GOTO 433
LOCATE 26,1:LINE INPUT "PRESS RETURN TO CONTINUE";A$
433 CCMEP=0
CYMEP=0
DRAT=DRATIO
DRATIO=0
RETURN


REM ==========================================================================
REM  RESETTDC  book source: inside PROG.5.1 | transcription lines 331-350
REM  Called when DEG>360 and <=360+DC (GOSUB): closes the scavenging period.
REM ==========================================================================
RESETTDC:
SEFFP(JJ)=SEFF
TEFFP(JJ)=TEFF
CEFFP(JJ)=CEFF
SRMP(JJ)=SCRATIO
SRVP(JJ)=SR
EXRP(JJ)=EXRATIO
LOCATE 22,1:PRINT "SCAVENGING EFF.=";USING"#.###";SEFF
LOCATE 22,23:PRINT "TRAPPING EFF.=";USING"#.###";TEFF
LOCATE 22,45:PRINT "CHARGING EFF.=";USING"#.###";CEFF
LOCATE 23,1:PRINT "SCAV. RATIO(mass)=";USING"#.###";SCRATIO
LOCATE 23,23:PRINT "SCAV. RATIO(vol)=";USING"#.###";SR
LOCATE 23,45:PRINT "EX. FLOW RATIO=";USING"#.###";EXRATIO
IF CYCLE=CYCLEP THEN GOTO 434
LOCATE 25,1:LINE INPUT "PRESS RETURN TO CONTINUE";A$
434 MBACK=0
SCRATIO=0
EXRATIO=0
SR=0
RETURN


REM ==========================================================================
REM  EXPIPDAT  book source 26425-26448 | transcription lines 351-374
REM  GOSUB from the data-entry menu. NOT in the 5.0 common block - lives here.
REM ==========================================================================
EXPIPDAT:
19 INPUT "NEW DATA FOR INITIAL EXHAUST PIPE LENGTH(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT "TYPE IN INITIAL EXHAUST PIPE LENGTH(LEP1)";LEP1
INPUT "NEW DATA FOR INITIAL EXHAUST PIPE DIAMETER(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT "TYPE IN INITIAL EXHAUST PIPE DIAMETER(DEP1)";DEP1
INPUT "NEW DATA FOR OUTLET EXHAUST PIPE LENGTH(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT "TYPE IN OUTLET EXHAUST PIPE LENGTH(LEP2)";LEP2
INPUT "NEW DATA FOR OUTLET EXHAUST PIPE DIAMETER(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT "TYPE IN OUTLET EXHAUST PIPE DIAMETER(DEP2)";DEP2
INPUT "NEW DATA FOR EXHAUST BOX VOLUME(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT "TYPE IN EXHAUST BOX VOLUME(VBOX AS cm3)";VBOX
INPUT "IS THE MUFFLER OF THE ABSORPTION TYPE(Y/N?)";ANS$
SIL$="PLAIN BOX"
IF ANS$="Y" THEN INPUT "TYPE IN THE WORD ABSORPTION";SIL$
INPUT "MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 19
LE1M=LEP1/1000
LE2M=LEP2/1000
DE1M=DEP1/1000
DE2M=DEP2/1000
VBOXM=VBOX/1000000!
FEP1=PI*DE1M*DE1M/4
FEP2=PI*DE2M*DE2M/4
RETURN


REM ==========================================================================
REM  DATASET   book source: inside PROG.5.1 | transcription lines 375-410
REM ==========================================================================
DATASET:
PRINT "PROGRAM FOR PISTON-PORTED ENGINE WITH EXHAUST BOX SILENCER"
PRINT "Prog.5.1, ENGINE WITH BOX SILENCER"
PRINT "ALL DATA IN mm AND deg UNITS"
PRINT "BORE STROKE CON-ROD REV/MIN TRAP-CR CRANKCASE-CR TEXC"
PRINT USING"######.##";BO,ST,CRL,RPM,TCR,CCR,TEXC
PRINT
PRINT "EXHAUST PORT DATA"
PRINT
PRINT "OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD"
PRINT USING"#########.#";EPO,EPFO,NEP,WEP,RTE,RBE
PRINT
PRINT "TRANSFER PORT DATA WITH SCAVENGING DESCRIBED AS ";SCAV$
PRINT
PRINT "OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD"
PRINT USING"#########.#";TPO,TPFO,NTP,WTP,RTT,RBT
PRINT
PRINT "INLET PORT DATA"
PRINT
PRINT "OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD"
PRINT USING"#########.#";IPO,IPFO,NIP,WIP,RTI,RBI
PRINT
PRINT "EXHAUST PIPE DATA WITH MUFFLER TYPE AS ";SIL$
PRINT "LENGTH.1 DIAMETER.1 LENGTH.2 DIAMETER.2 BOX VOLUME, cm3"
PRINT USING"######.##";LEP1,DEP1,LEP2,DEP2,VBOX
PRINT
PRINT "TRANSFER AND INLET PIPE DATA"
PRINT "LENGTH.T TRANSFER.AR LENGTH.I DIAMETER.I THROTTLE.AR"
PRINT USING"######.##";LTP,TRAR,LIP,DIP,THAR
PRINT
PRINT "COMBUSTION MODEL PARAMETERS"
PRINT "INDECES, COMP. AND EXP. COMBUSTION.EFF BURN PERIOD AIR-TO-FUEL"
PRINT USING"########.##";NC,NE,BEFF,BDEG,TAF
PRINT
INPUT"OK?.(Y/N)";S$
RETURN


REM ==========================================================================
REM  DATASETL  book source: inside PROG.5.1 | transcription lines 411-439
REM  Printer twin of DATASET; called by PRINTOUT.
REM ==========================================================================
DATASETL:
LPRINT "BORE STROKE CON-ROD REV/MIN TRAP-CR CRANKCASE-CR TEXC"
LPRINT USING"######.##";BO,ST,CRL,RPM,TCR,CCR,TEXC
LPRINT
LPRINT "EXHAUST PORT DATA"
LPRINT "OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD"
LPRINT USING"#########.#";EPO,EPFO,NEP,WEP,RTE,RBE
LPRINT
LPRINT "TRANSFER PORT DATA WITH SCAVENGING DESCRIBED AS ";SCAV$
LPRINT "OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD"
LPRINT USING"#########.#";TPO,TPFO,NTP,WTP,RTT,RBT
LPRINT
LPRINT "INLET PORT DATA"
LPRINT "OPENS FULL-OPEN NUMBER-OFF WIDTH-EACH TOP-RAD BOTTOM-RAD"
LPRINT USING"#########.#";IPO,IPFO,NIP,WIP,RTI,RBI
LPRINT
LPRINT "EXHAUST PIPE DATA WITH MUFFLER TYPE AS ";SIL$
LPRINT "LENGTH.1 DIAMETER.1 LENGTH.2 DIAMETER.2 BOX VOLUME, cm3"
LPRINT USING"######.##";LEP1,DEP1,LEP2,DEP2,VBOX
LPRINT
LPRINT "TRANSFER AND INLET PIPE DATA"
LPRINT "LENGTH.T TRANSFER.AR LENGTH.I DIAMETER.I THROTTLE.AR"
LPRINT USING"######.##";LTP,TRAR,LIP,DIP,THAR
LPRINT
LPRINT "COMBUSTION MODEL PARAMETERS"
LPRINT " COMBUSTION.EFF BURN PERIOD AIR-TO-FUEL COMP. AND EXP. INDECES"
LPRINT USING"#########.##";BEFF,BDEG,TAF,NC,NE
LPRINT
RETURN


REM ==========================================================================
REM  SPLOT1  book source: inside PROG.5.1 | transcription lines 440-528
REM  Panel 1 of the screen plot: exhaust-open window. Also the axis scaler.
REM  Labels used: 410 439 (main module).
REM ==========================================================================
SPLOT1:
NCOUNT=1
IF NCOUNT>=2 THEN GOTO 410
M=1
MG2=1
X0=50
Y0=250
YT=20
YZ=30
X2=460
X1=(X2+X0)/2
EP=2*(180-EPO)
DR=(X2-X0)/EP
BD=DR*(TPO-EPO)
X3=X0+BD
X4=X2-BD
GPS=1!
GSS=1.2
GTS=1500
GYS=(Y0-YZ)/GPS
YEF=(Y0-YZ)/GSS
YTT=(Y0-YZ)/GTS
REM [FIX5] D$ was being used as an implicit mode flag here. Use the explicit one.
IF PRINTMODE=1 THEN GOTO 439
CLS
439 LOCATE 19,4
PRINT "CRANK-ANGLE from EXHAUST PORT OPENING to EXHAUST PORT CLOSING"
LOCATE 17,6
PRINT "EPO"
LOCATE 17,14
PRINT "TPO"
LOCATE 17,31
PRINT "BDC"
LOCATE 17,48
PRINT "TPC"
LOCATE 17,57
PRINT "EPC"
LOCATE 4,11
PRINT "CYLINDER"
LOCATE 9,9
PRINT "EXHAUST-"
LOCATE 9,33
PRINT "CRANKCASE"
LOCATE 4,2
PRINT "P."
LOCATE 5,2
PRINT "A"
LOCATE 6,2
PRINT "T"
LOCATE 7,2
PRINT "M"
LOCATE 2,2
PRINT "2.0"
LOCATE 9,2
PRINT "1.5"
LOCATE 16,2
PRINT "1.0"
YY1=Y0-.1*GYS
YY2=Y0-.2*GYS
YY3=Y0-.3*GYS
YY4=Y0-.4*GYS
YY5=Y0-.5*GYS
YY6=Y0-.6*GYS
YY7=Y0-.7*GYS
YY8=Y0-.8*GYS
YY9=Y0-.9*GYS
YYU=Y0-GYS
YT1=Y0-1500*YTT
YT2=Y0-1000*YTT
YT3=Y0-500*YTT
LINE(X0,YY1)-(X0+5,YY1)
LINE(X0,YY2)-(X0+5,YY2)
LINE(X0,YY3)-(X0+5,YY3)
LINE(X0,YY4)-(X0+5,YY4)
LINE(X0,YY5)-(X0+5,YY5)
LINE(X0,YY6)-(X0+5,YY6)
LINE(X0,YY7)-(X0+5,YY7)
LINE(X0,YY8)-(X0+5,YY8)
LINE(X0,YY9)-(X0+5,YY9)
LINE(X0,YYU)-(X0+5,YYU)
LINE(X0,Y0)-(X2,Y0)
LINE(X0,Y0)-(X0,YT)
LINE(X2,Y0)-(X2,YT)
LINE(X3,Y0)-(X3,YT)
LINE(X1,Y0)-(X1,YT)
LINE(X4,Y0)-(X4,YT)
FOR K=1 TO 13
YF(K)=Y0-K*YEF/10
NEXT K
410 RETURN


REM ==========================================================================
REM  SPLOT2  book source: inside PROG.5.1 | transcription lines 529-544
REM  Panel 1 trace. Label used: 633 (main module, unique - see [D23]).
REM ==========================================================================
SPLOT2:
IF PCR>2! THEN PCR=2!
ZC=(PCR-1)*GYS
ZS=(PCCR-1)*GYS
ZE=(PEX-1)*GYS
XA(M)=INT(DR*(ANGD-EPO))+X0
YC(M)=Y0-ZC
YS(M)=Y0-ZS
YE(M)=Y0-ZE
IF M=1 THEN GOTO 633
LINE(XA(M),YS(M))-(XA(M-1),YS(M-1))
LINE(XA(M),YC(M))-(XA(M-1),YC(M-1))
LINE(XA(M),YE(M))-(XA(M-1),YE(M-1))
633 M=M+1
MG=MG+1
RETURN


REM ==========================================================================
REM  SPLOT3  book source: inside PROG.5.1 | transcription lines 545-640
REM  Panel 2 axes: exhaust-closed window. Labels used: 631 632 634 635.
REM ==========================================================================
SPLOT3:
XX0=50
YY0=180
YYB=260
YYT=5
YYZ=10
XX2=460
XX1=(XX2+XX0)/2
EP2=2*EPO
DR2=(XX2-XX0)/EP2
BD2=DR2*IPO
XX3=XX1+BD2
XX4=XX1-BD2
YPS=GYS/10
YVS=YEF/10
CLS
LOCATE 19,4
PRINT "CRANK-ANGLE from EXHAUST PORT CLOSING to EXHAUST PORT OPENING"
LOCATE 17,7
PRINT "EPC"
LOCATE 17,16
PRINT "TPO"
LOCATE 17,33
PRINT "TDC"
LOCATE 17,46
PRINT "TPC"
LOCATE 17,56
PRINT "EPO"
LOCATE 6,36
PRINT "CYLINDER"
LOCATE 7,15
PRINT "DELIVERY RATIO"
LOCATE 14,9
PRINT "CRANKCASE"
LOCATE 13,51
PRINT "INLET"
LOCATE 13,59
PRINT "E"
LOCATE 14,59
PRINT "F"
LOCATE 15,59
PRINT "F."
LOCATE 7,2
PRINT "P."
LOCATE 8,2
PRINT "A"
LOCATE 9,2
PRINT "T"
LOCATE 10,2
PRINT "M"
LOCATE 12,59
PRINT "0.0"
LOCATE 11,59
PRINT "0.1"
LOCATE 10,59
PRINT "0.2"
LOCATE 8,59
PRINT "0.3"
LOCATE 7,59
PRINT "0.4"
LOCATE 6,59
PRINT "0.5"
LOCATE 5,59
PRINT "0.6"
LOCATE 4,59
PRINT "0.7"
LOCATE 3,59
PRINT "0.8"
LOCATE 2,59
PRINT "0.9"
LOCATE 5,2
PRINT " 1.5"
LOCATE 12,2
PRINT " 1.0"
LOCATE 16,2
PRINT " 0.7"
LINE(XX0,YY0)-(XX2,YY0)
LINE(XX0,YYB)-(XX0,YYT)
LINE(XX2,YYB)-(XX2,YYT)
LINE(XX3,YYB)-(XX3,YYT)
LINE(XX1,YYB)-(XX1,YYT)
LINE(XX4,YYB)-(XX4,YYT)
Z=INT((YYB-YY0)/YPS)
Y=YY0+Z*YPS
YBL=Y
LINE(XX0,YBL)-(XX2,YBL)
631 LINE(XX0,Y)-(XX0+5,Y)
Y=Y-YPS
IF Y<YYZ THEN GOTO 632
GOTO 631
632 Y=YY0
635 LINE(XX2,Y)-(XX2-5,Y)
Y=Y-YVS
IF Y<YYZ THEN GOTO 634
GOTO 635
634 RETURN


REM ==========================================================================
REM  SPLOT4  book source: inside PROG.5.1 | transcription lines 641-660
REM  Panel 2 trace. Labels used: 639.
REM ==========================================================================
SPLOT4:
M=MG2
ZB=(PCR-1)*GYS/40
ZI=(PIR-1)*GYS
ZP=(PCCR-1)*GYS
ZV=DRATIO*YEF
XXA(M)=INT(DR2*(ANGD-EPC))+XX0
YI(M)=YY0-ZI
YP(M)=YY0-ZP
YV(M)=YY0-ZV
IF YV(M)>YY0 THEN YV(M)=YY0
YB(M)=YBL-ZB
IF MG2=1 THEN GOTO 639
LINE(XXA(M),YP(M))-(XXA(M-1),YP(M-1))
LINE(XXA(M),YB(M))-(XXA(M-1),YB(M-1))
LINE(XXA(M),YI(M))-(XXA(M-1),YI(M-1))
IF XXA(M)>=XX3 THEN GOTO 639
LINE(XXA(M),YV(M))-(XXA(M-1),YV(M-1))
639 MG2=MG2+1
RETURN


REM ==========================================================================
REM  FILING  book source: inside PROG.5.1 | transcription lines 661-671
REM  Writes the .BOX case file. Twin of FILED.
REM ==========================================================================
FILING:
INPUT "TYPE IN TITLE NEEDED FOR THE FILE WITH '.BOX' END CODE";P$
OPEN P$ FOR OUTPUT AS #1
WRITE#1,BO,ST,CRL,RPM,TCR,CCR,TEXC
WRITE#1,EPO,EPFO,NEP,WEP,RTE,RBE
WRITE#1,TPO,TPFO,NTP,WTP,RTT,RBT,SCAV$
WRITE#1,IPO,IPFO,NIP,WIP,RTI,RBI
WRITE#1,LEP1,DEP1,LEP2,DEP2,VBOX,SIL$,LTP,TRAR,LIP,DIP,THAR
WRITE#1,NC,NE,BEFF,BDEG,TAF
CLOSE#1
RETURN


REM ==========================================================================
REM  FILED  book source: inside PROG.5.1 | transcription lines 672-683
REM  Reads the .BOX case file, then FILESET converts it.
REM ==========================================================================
FILED:
INPUT "TYPE IN THE FILENAME WITH A '.BOX' END CODE";FIL$
OPEN"I",#1,FIL$
REM <UNRESOLVED #4: "OPEN'T',#l,FIL$"> as at the UFLO open, the mode character
REM  reads "T". [D21] Assumed "I" (input): the file is written by FILING and
REM  read here.
INPUT#1,BO,ST,CRL,RPM,TCR,CCR,TEXC
INPUT#1,EPO,EPFO,NEP,WEP,RTE,RBE
INPUT#1,TPO,TPFO,NTP,WTP,RTT,RBT,SCAV$
INPUT#1,IPO,IPFO,NIP,WIP,RTI,RBI
INPUT#1,LEP1,DEP1,LEP2,DEP2,VBOX,SIL$,LTP,TRAR,LIP,DIP,THAR
INPUT#1,NC,NE,BEFF,BDEG,TAF
CLOSE#1
RETURN


REM ==========================================================================
REM  ############  PROGLIST 5.0 COMMON SUBROUTINE BLOCK  ####################
REM  book source 27565-28192. Order below is the book's order.
REM  Excluded from this file, with reasons in BUILD_MANIFEST.md [D24]:
REM    [D10] BELMOUTH (never called by 5.1/5.2), and the whole ProgList 2.1/2.2
REM    block (ASET..CLIPDRAW, EXPORT, FLOW, BOX-10-arg [D8]/[D9], NINT-KI [D7],
REM    STAB-with-DZ [D1],
REM    PISTPOS-radians) which belongs to PROG.2.1/2.2, not to PROG.5.1.
REM ==========================================================================


REM ==========================================================================
REM  TRPIPDAT   book source 27570-27591 | transcription lines 61-69
REM ==========================================================================
TRPIPDAT:
20 INPUT"NEW DATA FOR TRANSFER PIPE LENGTH(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN TRANSFER PIPE LENGTH(LTP)";LTP
INPUT"NEW DATA FOR TRANSFER PORT TO PIPE AREA RATIO(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN TRANSFER PORT TO PIPE AREA RATIO(TRAR)";TRAR
INPUT"MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 20
LTM=LTP/1000
RETURN


REM ==========================================================================
REM  INPIPDAT   book source 27592-27611 | transcription lines 71-83
REM ==========================================================================
INPIPDAT:
21 INPUT"NEW DATA FOR INLET PIPE LENGTH(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN INLET PIPE LENGTH(LIP)";LIP
INPUT"NEW DATA FOR INLET PIPE DIAMETER(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN INLET PIPE DIAMETER(DIP)";DIP
INPUT"NEW DATA FOR THROTTLE AREA RATIO(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN THROTTLE AREA RATIO(THAR)";THAR
INPUT"MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 21
LIM=LIP/1000
DIPM=DIP/1000
FIPM=PI*DIPM*DIPM/4
RETURN


REM ==========================================================================
REM  COMBDAT    book source 27612-27648 | transcription lines 85-98
REM  NOTE [D4]: label 22 here is the reason PIPE keeps label 23, not 22.
REM ==========================================================================
COMBDAT:
22 INPUT"NEW DATA FOR POLYTROPIC COMPRESSION INDEX(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN POLYTROPIC COMPRESSION INDEX(NC)";NC
INPUT"NEW DATA FOR POLYTROPIC EXPANSION INDEX(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN POLYTROPIC EXPANSION INDEX(NE)";NE
INPUT"NEW DATA FOR COMBUSTION EFFICIENCY(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN COMBUSTION EFFICIENCY(BEFF)";BEFF
INPUT"NEW DATA FOR COMBUSTION PERIOD(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN COMBUSTION PERIOD(BDEG)";BDEG
INPUT"NEW DATA FOR TRAPPED AIR-FUEL RATIO(default value is 13)(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN TRAPPED AIR-FUEL RATIO(TAF)";TAF
INPUT"MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 22
RETURN


REM ==========================================================================
REM  PORTSTART  book source 27649-27692 | transcription lines 100-141
REM  Calls PISTPOS six times, in degrees.
REM ==========================================================================
PORTSTART:
EPC=360-EPO
IPC=360+IPO
IPOD=360-IPO
TPC=360-TPO
PFI=0
PFE=0
PFT=0
PFIM=0
PFEM=0
PFTM=0
PWE=WEPM-2*RTEM
PWT=WTPM-2*RTTM
PWI=WIPM-2*RTIM
PHE=0
PHT=0
PHI=0
CALL PISTPOS(STM,CRNK,CRLM,EPO,HEOT,HEOB)
CALL PISTPOS(STM,CRNK,CRLM,EPFO,HEFT,HEFB)
EXHT=HEFT-HEOT
HME=EXHT-RTEM-RBEM
CALL PISTPOS(STM,CRNK,CRLM,TPO,HTOT,HTOB)
CALL PISTPOS(STM,CRNK,CRLM,TPFO,HTFT,HTFB)
TRHT=HTFT-HTOT
HMT=TRHT-RTTM-RBTM
CALL PISTPOS(STM,CRNK,CRLM,IPO,HIOT,HIOB)
CALL PISTPOS(STM,CRNK,CRLM,IPFO,HIFT,HIFB)
INHT=HIOT-HIFT
HMI=INHT-RTIM-RBIM
IF SCAV$="UNIFLOW" THEN MSC=-1.7827
IF SCAV$="UNIFLOW" THEN CSC=.2094
IF SCAV$="SCRE" THEN MSC=-1.6709
IF SCAV$="SCRE" THEN CSC=.1899
IF SCAV$="YAM1" THEN MSC=-1.6993
IF SCAV$="YAM1" THEN CSC=.3053
IF SCAV$="YAM6" THEN MSC=-1.3516
IF SCAV$="YAM6" THEN CSC=.1435
IF SCAV$="CD" THEN MSC=-1.0104
IF SCAV$="CD" THEN CSC=-.117
IF SCAV$="QUBCR" THEN MSC=-1.6325
IF SCAV$="QUBCR" THEN CSC=.1397
RETURN


REM ==========================================================================
REM  EXPORTSHUT  book source 27693-27697 | transcription lines 143-147
REM ==========================================================================
EXPORTSHUT:
AKE=0
ME1=0
AE(1)=BE(1)
RETURN


REM ==========================================================================
REM  EXPORTOPEN  book source 27698-27722 | transcription lines 149-160
REM  Calls FPORT, PORT, OUTFLOW. [D13] applies at the second OUTFLOW call.
REM ==========================================================================
EXPORTOPEN:
PC1R=PC1/PA
IF PEX<=PC1R THEN CCE=.8
IF PEX>PC1R THEN CCE=.8
CALL FPORT(HEOT,HTDC,EXHT,FEPRT,FEP1,AKE,CCE)
CALL PORT(AE(1),BE(1),PC1,AKE)
IF PEX<=PC1R THEN CDE=.75
IF PEX>PC1R THEN CDE=.75
IF PEX<=PC1R THEN CALL OUTFLOW(AE(1),BE(1),FEP1,TC1,HE1,CE1,ME1,D,CDE)
REM <UNRESOLVED #5: "CALL OUTFLOW(AE(1),BE(1),FEP1,TCT,...)"> the reference
REM  temperature "TCT" appears nowhere else in the listing. [D13] Resolved to
REM  TC1, not TCC1 and not TB1: TC1 is the same reference the branch line above
REM  passes, it is a glyph-adjacent misread of TC1 ("1" read as "T"), and it is
REM  the only candidate that is guaranteed defined at this point. Blair prints
REM  many such IF/IF pairs with identical right-hand sides. See D13 for what
REM  breaks under the alternatives.
IF PEX>PC1R THEN CALL OUTFLOW(AE(1),BE(1),FEP1,TC1,HE1,CE1,ME1,D,CDE)
EXRATIO=EXRATIO+ME1*DTM/MREF
RETURN


REM ==========================================================================
REM  TRPORTSHUT  book source 27723-27729 | transcription lines 162-166
REM ==========================================================================
TRPORTSHUT:
AKT=0
MT1=0
AT(1)=BT(1)
RETURN


REM ==========================================================================
REM  TRPORTOPEN  book source 27730-27747 | transcription lines 168-185
REM  SCAVENGING MODEL NO.1 - Eqn.5.1.1. [D11] This is the retained body;
REM  the model-2 body (book 27750-27771) is NOT in this file. Its exact diff
REM  is reproduced in BUILD_MANIFEST.md so it can be swapped back in.
REM ==========================================================================
REM SCAVENGING MODEL NO.1 IN SUBROUTINE "TRPORTOPEN"
REM Eqn.5.1.1 is being programmed here
TRPORTOPEN:
IF PTR<=PC1R THEN CCT=.8
IF PTR>PC1R THEN CCT=.8
CALL FPORT(HTOT,HTDC,TRHT,FTPRT,FTDUCT,AKT,CCT)
CALL PORT(AT(1),BT(1),PC1,AKT)
IF PTR<=PC1R THEN CDT=.75
IF PTR>PC1R THEN CDT=.75
IF PTR<=PC1R THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TC1,HT1,CT1,MT1,DSCAV,CDT)
IF PTR>PC1R THEN CALL OUTFLOW(BT(1),AT(1),FTDUCT,TCC1,HT1,CT1,MT1,DSCAV,CDT)
EXPAND=PTR/PC1R
VOLINC=CT1*FTDUCT*DTM*EXPAND/VC1
SCRATIO=SCRATIO+MT1*DTM/MREF
IF SCRATIO<0 THEN GOTO 911
SR=SR+VOLINC
SEFF=1-EXP(MSC*SR+CSC)
911 RETURN


REM ==========================================================================
REM  INPORTSHUT  book source 27772-27776 | transcription lines 207-211
REM ==========================================================================
INPORTSHUT:
AKI=0
MI1=0
AI(1)=BI(1)
RETURN


REM ==========================================================================
REM  INPORTOPEN  book source 27777-27791 | transcription lines 213-224
REM  Calls FPORT, PORT, OUTFLOW, INFLOW. [D14] applies at the FPORT call.
REM ==========================================================================
INPORTOPEN:
PCC1R=PCC1/PA
IF PIR<=PCC1R THEN CCI=.8
IF PIR>PCC1R THEN CCI=.9
REM [D14] Blair passes FIPRT twice - FPRT and FPIP are the same variable, so
REM  the internal area ratio FPRT/FPIP is identically 1 and AKI=CCI*FINST.
REM  Kept verbatim. FIPM (inlet pipe area, set in INPIPDAT/FILESET) is computed
REM  and never used, which is circumstantial evidence that FPIP was meant to be
REM  FIPM. Not changed: see D14.
CALL FPORT(HTDC,HIOT,INHT,FIPRT,FIPRT,AKI,CCI)
CALL PORT(AI(1),BI(1),PCC1,AKI)
IF PIR<=PCC1R THEN CDI=.75
IF PIR>PCC1R THEN CDI=.9
IF PIR<=PCC1R THEN CALL OUTFLOW(BI(1),AI(1),FIPRT,TCC1,HI1,CI1,MI1,D,CDI)
IF PIR>PCC1R THEN CALL INFLOW(BI(1),AI(1),FIPRT,TIREF,HI1,CI1,MI1,D,CDI)
DRATIO=DRATIO+MI1*DTM/MREF
RETURN


REM ==========================================================================
REM  ENGINEDAT  book source 27792-27834 | transcription lines 226-253
REM ==========================================================================
ENGINEDAT:
15 INPUT"NEW DATA FOR CYLINDER BORE(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN CYLINDER BORE(B)";BO
INPUT"NEW DATA FOR CYLINDER STROKE(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN CYLINDER STROKE(S)";ST
INPUT"NEW DATA FOR CONNECTING ROD LENGTH(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN CONNECTING ROD LENGTH(CRL)";CRL
INPUT"NEW DATA FOR ENGINE SPEED(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN ENGINE SPEED(RPM)";RPM
INPUT"NEW DATA FOR CYLINDER COMPRESSION RATIO(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN CYLINDER COMPRESSION RATIO(TCR)";TCR
INPUT"NEW DATA FOR CRANKCASE COMPRESSION RATIO(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN CRANKCASE COMPRESSION RATIO(CCR)";CCR
INPUT"NEW DATA FOR EXHAUST TEMPERATURE(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN EXHAUST PIPE REFERENCE TEMPERATURE,DEG.C";TEXC
INPUT"MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 15
BOM=BO/1000
STM=ST/1000
CRLM=CRL/1000
RPS=RPM/60
FPISTON=PI*BOM*BOM/4
SV=FPISTON*STM
CCCV=SV/(CCR-1)
CRNK=STM/2
FMEP=100*STM*RPM
TEREF=TEXC+273
RETURN


REM ==========================================================================
REM  EXPORTDAT  book source 27835-27867 | transcription lines 255-273
REM ==========================================================================
EXPORTDAT:
16 INPUT"NEW DATA FOR EXHAUST PORT OPENING TIMING(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN EXHAUST PORT OPENING,DEG. ATDC";EPO
INPUT"NEW DATA FOR EXHAUST PORT FULLY OPEN TIMING(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN EXHAUST PORT FULLY OPEN TIMING,DEG. ATDC";EPFO
INPUT"NEW DATA FOR NUMBER OF EXHAUST PORTS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN NUMBER OF EXHAUST PORTS";NEP
INPUT"NEW DATA FOR MAXIMUM WIDTH OF EACH EXHAUST PORT(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN MAXIMUM WIDTH OF EACH EXHAUST PORT(WE)";WEP
INPUT"NEW DATA FOR EXHAUST PORT TOP RADIUS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN EXHAUST PORT TOP RADIUS(RTE)";RTE
INPUT"NEW DATA FOR EXHAUST BOTTOM RADIUS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN EXHAUST BOTTOM RADIUS(RBE)";RBE
INPUT"MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 16
WEPM=WEP/1000
RTEM=RTE/1000
RBEM=RBE/1000
RETURN


REM ==========================================================================
REM  TRPORTDAT  book source 27868-27903 | transcription lines 275-296
REM ==========================================================================
TRPORTDAT:
17 INPUT"NEW DATA FOR TRANSFER PORT OPENING TIMING(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN TRANSFER PORT OPENING,DEG. ATDC";TPO
INPUT"NEW DATA FOR TRANSFER PORT FULLY OPEN TIMING(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN TRANSFER PORT FULLY OPEN TIMING,DEG. ATDC";TPFO
INPUT"NEW DATA FOR NUMBER OF TRANSFER PORTS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN NUMBER OF TRANSFER PORTS";NTP
INPUT"NEW DATA FOR MAXIMUM WIDTH OF EACH TRANSFER PORT(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN MAXIMUM WIDTH OF EACH TRANSFER PORT(WE)";WTP
INPUT"NEW DATA FOR TRANSFER PORT TOP RADIUS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN TRANSFER PORT TOP RADIUS(RTE)";RTT
INPUT"NEW DATA FOR TRANSFER PORT BOTTOM RADIUS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN TRANSFER PORT BOTTOM RADIUS(RBT)";RBT
INPUT"NEW DATA FOR SCAVENGING QUALITY(Y/N?)";ANS$
IF ANS$="Y" THEN PRINT"TYPE IN 'UNIFLOW',OR 'SCRE',OR 'YAM1',OR 'YAM6',OR 'CD',OR 'QUBCR'"
IF ANS$="Y" THEN INPUT"AS DESCRIBED IN Fig.3.14 of Sect.3.3.1 of Chapter 3";SCAV$
INPUT"MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 17
WTPM=WTP/1000
RTTM=RTT/1000
RBTM=RBT/1000
RETURN


REM ==========================================================================
REM  INPORTDAT  book source 27904-27933 | transcription lines 298-316
REM ==========================================================================
INPORTDAT:
18 INPUT"NEW DATA FOR INLET PORT OPENING TIMING(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN INLET PORT OPENING,DEG. BTDC";IPO
INPUT"NEW DATA FOR INLET PORT FULLY OPEN TIMING(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN INLET PORT FULLY OPEN TIMING,DEG. ATDC";IPFO
INPUT"NEW DATA FOR NUMBER OF INLET PORTS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN NUMBER OF INLET PORTS";NIP
INPUT"NEW DATA FOR MAXIMUM WIDTH OF EACH INLET PORT(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN MAXIMUM WIDTH OF EACH INLET PORT(WIP)";WIP
INPUT"NEW DATA FOR INLET PORT TOP RADIUS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN INLET PORT TOP RADIUS(RTI)";RTI
INPUT"NEW DATA FOR INLET PORT BOTTOM RADIUS(Y/N?)";ANS$
IF ANS$="Y" THEN INPUT"TYPE IN INLET PORT BOTTOM RADIUS(RBI)";RBI
INPUT"MORE DATA.(Y/N?)";ANS$
IF ANS$="Y" THEN GOTO 18
WIPM=WIP/1000
RTIM=RTI/1000
RBIM=RBI/1000
RETURN


REM ==========================================================================
REM  CYLSTART  book source 27934-27945 | transcription lines 318-328
REM ==========================================================================
CYLSTART:
TEREF=TEXC+273
TTREF=320
TIREF=300
SDE=SQR(GE*GK*TEREF)
SDT=SQR(GE*GK*TTREF)
SDI=SQR(GE*GK*TIREF)
DEREF=PA/(GK*TEREF)
DTREF=PA/(GK*TTREF)
DIREF=PA/(GK*TIREF)
RETURN


REM ==========================================================================
REM  SUB FPORT  book source 27946-27950 | transcription lines 330-334
REM  Linear port-opening ramp. Pure function of its arguments, no SHARED.
REM ==========================================================================
SUB FPORT(HOT,HTDC,PHT,FPRT,FPIP,AK,CC)STATIC
FINST=(HTDC-HOT)/PHT
IF FINST>1 THEN FINST=1
AK=CC*FINST*FPRT/FPIP
END SUB


REM ==========================================================================
REM  SUB STAB  book source 27951-27963 | transcription lines 336-345
REM  [D1] The 5.0 body. It has NO DZ=1 initialiser: the caller sets DZ=1 at
REM  line 139 of the main loop, immediately before the five CALL STAB lines.
REM  Do not add DZ=1 here - see D1.
REM ==========================================================================
SUB STAB(A(),B(),K,S,E)STATIC
SHARED DZ,DTM,DC,RPM
C=60*S/(RPM*E)
FOR J=1 TO K
Z=2/((A(J)+B(J))+ABS(5*(A(J)-B(J))))
IF Z<DZ THEN DZ=Z
NEXT J
DC=360*DZ/C
DTM=DC/(6*RPM)
END SUB


REM ==========================================================================
REM  SUB SETS  book source 27964-27969 | transcription lines 347-352
REM  [D2] Identical twin dropped (ProgList 2.0, book 21132).
REM ==========================================================================
SUB SETS(A(),B(),K)STATIC
FOR J=1 TO K
A(J)=1
B(J)=1
NEXT J
END SUB


REM ==========================================================================
REM  SUB AREA  book source 27970-27980 | transcription lines 354-364
REM  [D3] Identical twin dropped (ProgList 2.0, book 21138).
REM ==========================================================================
SUB AREA(DA,DB,KA,KB,DF(),F())STATIC
C=(DB-DA)/(KB-KA)
FOR J=KA TO KB
A=J-KA
F(J)=((DA+C*A)^2)*.7854
NEXT J
KC=KB-1
FOR J=KA TO KC
DF(J)=F(J+1)-F(J)
NEXT J
END SUB


REM ==========================================================================
REM  SUB PIPE  book source 27981-28018 | transcription lines 366-399
REM  [D4] The 5.0 body, which uses label 23 for QA=0. The ProgList 2.0 twin
REM  is byte-identical except that it uses label 22, which is COMBDAT's label.
REM  Arrays A2(),B2() are SHARED and DIMed at main line 14.
REM ==========================================================================
SUB PIPE(KA,KB,A(),B(),DF(),F())STATIC
SHARED DZ,A2(),B2()
G1=3
G2=2
KC=KB-1
FOR J=KA TO KC
AA=DZ*A(J+1)*B(J)
BB=DZ*A(J)*B(J+1)
Y=(1+DZ*(G1*(A(J+1)-A(J))-G2*(B(J+1)-B(J))))
Z=(1+DZ*(G1*(B(J)-B(J+1))-G2*(A(J)-A(J+1))))
WA=(A(J+1)+G2*AA-G2*BB)/Y
RA=(A(J)-G1*BB+G1*AA)/Z
WB=(B(J+1)+G1*AA-G1*BB)/Y
RB=(B(J)+G2*AA-G2*BB)/Z
AA=WA-WB
BB=RA-RB
CC=WA+WB
DD=RA+RB
IF AA=0 THEN GOTO 23
QA=-DZ*CC*AA*DF(J)/(4*F(J))
GOTO 33
23 QA=0
33 IF BB=0 THEN GOTO 44
QB=-DZ*BB*DD*DF(J)/(4*F(J))
GOTO 55
44 QB=0
55 A2(J+1)=WA+QA
B2(J)=RB+QB
NEXT J
FOR J=KA TO KC
A(J+1)=A2(J+1)
B(J)=B2(J)
NEXT J
END SUB


REM ==========================================================================
REM  SUB SHOK  book source 28019-28033 | transcription lines 401-415
REM  [D5] Identical twin dropped (ProgList 2.0, book 21185).
REM ==========================================================================
SUB SHOK(A(),B(),KA,KB)STATIC
FOR J=KA TO KB
R1=5*ABS(A(J)-B(J))/(A(J)+B(J))
IF R1<1 THEN GOTO 56
R2=SQR((R1*R1+5)/(7*R1*R1-1))
R3=(A(J)+B(J))*((7*R1*R1-1)/6)^(1/7)
IF A(J)>B(J) THEN GOTO 26
A(J)=(5-R2)*R3/10
B(J)=(5+R2)*R3/10
GOTO 56
26 A(J)=(5+R2)*R3/10
B(J)=(5-R2)*R3/10
56 R1=0
NEXT J
END SUB


REM ==========================================================================
REM  SUB PORT  book source 28034-28048 | transcription lines 417-431
REM  SHARED ABX(21,45),BX(45),AKA(45) must already hold the UFLO table.
REM  [D6] Identical twin dropped (ProgList 2.0, book 21200).
REM ==========================================================================
SUB PORT(A,B,P,AK)STATIC
SHARED ABX(),BX(),AKA(),PA
X1=(P/PA)^(1/7)
BX1=B/X1
IF AK>.95 THEN AK=.95
IF BX1<.6 THEN BX1=.6
I=INT(AK/.05)+1
J=INT((BX1-.6)/.02)+1
RA=(AK-AKA(I))/(AKA(I+1)-AKA(I))
AB1=RA*(ABX(I+1,J+1)-ABX(I,J+1))+ABX(I,J+1)
AB2=RA*(ABX(I+1,J)-ABX(I,J))+ABX(I,J)
RB=(BX1-BX(J))/(BX(J+1)-BX(J))
ABX1=RB*(AB1-AB2)+AB2
A=2*X1*ABX1-B
END SUB


REM ==========================================================================
REM  SUB NINT  book source 28049-28059 | transcription lines 433-441
REM  [D7] The 5.0 body. K1 is the caller's variable; KI here is a LOCAL
REM  (STATIC), so the caller's mesh count is incremented exactly once. If a
REM  translator makes KI global, then because the call is CALL NINT(KI,...)
REM  for the inlet duct the two names alias and KI is incremented TWICE.
REM  Keep KI local. LMESH must be 30 (set at main line 115) before the calls.
REM ==========================================================================
SUB NINT(K1,PL,TE,TP)STATIC
SHARED LMESH
A=SQR(TE/TP)
RI=PL*A/LMESH
KI=INT(RI)
BI=RI-KI
IF BI>.5 THEN KI=KI+1
K1=KI+1
END SUB


REM ==========================================================================
REM  SUB OUTFLOW  book source 28060-28076 | transcription lines 443-458
REM  9 arguments, all positional; only GK,GE,PA are SHARED.
REM ==========================================================================
SUB OUTFLOW(A,B,F,TR,H,C,M,D,CD)STATIC
SHARED GK,GE,PA
CP=481.17*TR^.25
GAM=1.7847/(TR^.417)
AB=(A+B)/2
TREF=TR/AB^2
REM TR IS REGARDED AS THE SUPERPOSITION TEMPERATURE
SD=SQR(GAM*GK*TREF)
C=SD*(A-B)/(GAM-1)
H=CP*TR
D=AB^.5*PA/(GK*TREF)
M=CD*C*F*D
MN=C/SQR(GAM*GK*TR)
P1=(.5*(A+1))^7
P2=(.5*(B+1))^7
END SUB


REM ==========================================================================
REM  SUB INFLOW  book source 28077-28092 | transcription lines 460-474
REM ==========================================================================
SUB INFLOW(A,B,F,TR,H,C,M,D,CD)STATIC
SHARED GK,GE,PA
CP=481.17*TR^.25
GAM=1.7847/(TR^.417)
AB=(A+B)/2
SD=SQR(GAM*GK*TR)
C=2.5*SD*(A-B)
T=TR*AB*AB
H=CP*T
D=AB^.5*PA/(GK*TR)
M=CD*C*F*D
MN=C/SQR(GAM*GK*T)
PR=(.5*(A+1))^7
PL=(.5*(B+1))^7
END SUB


REM ==========================================================================
REM  SUB BOX  book source 28093-28118 | transcription lines 476-494
REM  [D8] The 15-argument 5.0 body - the ONLY one that matches PROG.5.1's
REM  call sites. Two volumes VB1/VB2 and the three mass-flow/enthalpy pairs.
REM  It also rolls the state (PB1=PB2 etc.), which is how PC1/TC1/MC1/VC1 get
REM  their previous-step values - do not remove those four lines.
REM ==========================================================================
SUB BOX(PB1,PB2,TB1,TB2,VB1,VB2,MB1,MB2,MIN,MO,CIN,CO,HIN,HO,WORK)STATIC
SHARED CCV,DTM,GK,GE
CV1=269.49*TB1^0.1667
DMI=MIN*DTM
DME=MO*DTM
MB2=MB1+DMI-DME
EIN=DMI*(HIN+.5*CIN*CIN)
EO=DME*(HO+.5*CO*CO)
DW=PB1*(VB2-VB1)
TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV1*MB2)
CV2=269.49*TB2^0.1667
TB2=(EIN-EO+CV1*MB1*TB1-DW)/(CV2*MB2)
PB2=MB2*GK*TB2/VB2
WORK=(PB1+PB2)*(VB2-VB1)/2
PB1=PB2
TB1=TB2
MB1=MB2
VB1=VB2
END SUB


REM ==========================================================================
REM  SUB PISTPOS  book source 28124-28129 | transcription lines 502-507
REM  [D12] The DEGREE version. D is in crank degrees and is converted with the
REM  main program's DTOR. All eight call sites in this file pass degrees.
REM ==========================================================================
SUB PISTPOS(S,R,C,D,HT,HB)STATIC
SHARED DTOR
A=D*DTOR
HT=R+C-R*COS(A)-SQR(C*C-(R*SIN(A))^2)
HB=S-HT
END SUB


REM ==========================================================================
REM  SUB PAREA  book source 28130-28135 | transcription lines 509-513
REM  Full-open port area and equivalent diameter (Eqn.5.2.6), once per run.
REM ==========================================================================
SUB PAREA(NP,WP,HP,RT,RB,FP,DP)STATIC
SHARED PI
FP=NP*(WP*HP-(2-PI/2)*(RT*RT+RB*RB))
DP=SQR(4*FP/PI)
END SUB


REM ==========================================================================
REM  SUB CYLINDER  book source 28136-28192 | transcription lines 515-568
REM  Closed-cycle model, called only while HTDC<=HEOT (exhaust port shut).
REM  SUB-local labels 20 30 50 60 70 80 90. [FIX2] 20 and 50 are renamed C20
REM  and C50 here and at their three references, because they collide with the
REM  main module's 20 (TRPIPDAT) and 50 (main data menu). 30 60 70 80 90 are
REM  unique across the whole file and are kept as printed.
REM  [D15] HT1 is deliberately NOT added to SHARED. [D16] same for DPMAX.
REM  Both, and HT2 DELTAP S1 S2 S3 IGN BURNEND TAILDEG PEAK QMAX HEAT MAIR,
REM  persist between calls - see the STATIC decision at the head of this file.
REM ==========================================================================
SUB CYLINDER(P1,P2,T1,T2,V1,V2,MC,WORK)STATIC
SHARED GK,GE,NE,NC,DEG,SEFF,DC,BEFF,BDEG,TAF,CVAL,EPC,PA
SHARED PMAX,TKMAX,MAXDEG,MREF,CEFF,TEFF,DRAT
DEGC=DEG
IF DEGC<=360 THEN POLYINDEX=NC
IF DEGC>360 THEN POLYINDEX=NE
IF DEGC>EPC+5 THEN GOTO 30
MAIR=SEFF*MC
CEFF=MAIR/MREF
TEFF=MAIR/(DRAT*MREF)
IGN=360-BDEG/6
BURNEND=IGN+BDEG
TAILDEG=BURNEND-BDEG/3
PEAK=IGN+BDEG/3
TAFB=13
IF TAF>TAFB THEN TAFB=TAF
HEAT=BEFF*CVAL*MAIR^TAFB
QMAX=36*HEAT/(14*BDEG)
S1=3*QMAX/BDEG
S2=5*QMAX/(2*BDEG)
S3=QMAX/(2*BDEG)
30 IF DEGC<=IGN THEN GOTO 90
IF DEGC>=BURNEND THEN GOTO 90
REM <UNRESOLVED #6: "IF DEGOIGN THEN GOTO 20"> the relational operator between
REM  DEGC and IGN is illegible. [D25] Read as DEGC<IGN, which is dead code
REM  (label 30 above already branched on DEGC<=IGN) and is therefore
REM  behaviour-neutral under any reading.
IF DEGC<IGN THEN GOTO C20
IF DEGC<=BURNEND THEN GOTO C20
90 P2=P1*(V1/V2)^POLYINDEX
T2=P2*V2/(MC*GK)
GOTO C50
C20: IF DEGC>PEAK THEN GOTO 60
HT2=S1*(DEGC-IGN)
GOTO 80
60 IF DEGC<=TAILDEG THEN GOTO 70
HT2=(BURNEND-DEGC)*S3
GOTO 80
70 HT2=(TAILDEG-DEGC)*S2
80 QHT=DC*(HT1+HT2)/2
VR=V1/V2
VRN=VR^POLYINDEX
REM RASSWEILER AND WITHROW THEORY
REM <UNRESOLVED #7: "TRM1=(GE+1)*V2/(2*(GE-I))-VR"> the trailing -VR may belong
REM  to the next expression; the next line overwrites TRM1 unconditionally, so
REM  the value is discarded either way. [D26] Kept exactly as printed.
TRM1=(GE+1)*V2/(2*(GE-1))-VR
TRM1=V2/(GE-1)
P2=(QHT/TRM1)+P1*VRN
T2=P2*V2/(MC*GK)
C50: WORK=(P1+P2)*(V2-V1)/2
IF P2>P1 THEN DELTAP=(P2-P1)/(100000!*DC)
IF P2>P1 THEN PMAX=P2/100000!
IF P2>P1 THEN MAXDEG=DEGC-360
IF T2>T1 THEN TKMAX=T2
IF DELTAP>DPMAX THEN DPMAX=DELTAP
P1=P2
T1=T2
V1=V2
HT1=HT2
END SUB


REM ==========================================================================
REM  END OF ASSEMBLED FILE. Nothing follows. Every CALL/GOSUB target used above
REM  is defined above. See port/BUILD_MANIFEST.md for the decision log,
REM  the call graph and the shared-variable/array-dimension tables.
REM ==========================================================================
