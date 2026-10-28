function varargout = sub_flow(op, varargin)
%SUB_FLOW  Port mass flow and enthalpy: SUB OUTFLOW and SUB INFLOW.
%
%   [H, C, M, D] = SUB_FLOW('OUTFLOW', m, A, B, F, TR, CD)
%   [H, C, M, D] = SUB_FLOW('INFLOW',  m, A, B, F, TR, CD)
%
%   Two entries in one file because they are one subject: the unsteady
%   port-flow relations at a duct end. MATLAB allows only ONE public function
%   per file, so this file is a two-entry dispatcher over the two local
%   functions below. Public wrappers SUB_FLOW_OUT.M and SUB_FLOW_IN.M exist so
%   that call sites read like Blair's CALL.
%
% -------------------------------------------------------------------------
% SOURCE - SUB OUTFLOW, blair_clean.bas 1339-1354
%   SUB OUTFLOW(A,B,F,TR,H,C,M,D,CD)STATIC
%   SHARED GK,GE,PA
%   CP=481.17*TR^.25
%   GAM=1.7847/(TR^.417)
%   AB=(A+B)/2
%   TREF=TR/AB^2                      'TR IS THE SUPERPOSITION TEMPERATURE
%   SD=SQR(GAM*GK*TREF)
%   C=SD*(A-B)/(GAM-1)
%   H=CP*TR
%   D=AB^.5*PA/(GK*TREF)
%   M=CD*C*F*D
%   MN=C/SQR(GAM*GK*TR)
%   P1=(.5*(A+1))^7
%   P2=(.5*(B+1))^7
%   END SUB
%   Book source 28060-28076.
%
% -------------------------------------------------------------------------
% SOURCE - SUB INFLOW, blair_clean.bas 1360-1374
%   SUB INFLOW(A,B,F,TR,H,C,M,D,CD)STATIC
%   SHARED GK,GE,PA
%   CP=481.17*TR^.25
%   GAM=1.7847/(TR^.417)
%   AB=(A+B)/2
%   SD=SQR(GAM*GK*TR)
%   C=2.5*SD*(A-B)
%   T=TR*AB*AB
%   H=CP*T
%   D=AB^.5*PA/(GK*TR)
%   M=CD*C*F*D
%   MN=C/SQR(GAM*GK*T)
%   PR=(.5*(A+1))^7
%   PL=(.5*(B+1))^7
%   END SUB
%   Book source 28077-28092.
%
% READS    m.GK, m.PA (SHARED) - m.GE is declared SHARED but never used by
%          either body (VERIFY_STRUCTURE.md 4.2): the gas properties are the
%          hard-coded CP and GAM correlations, not GE.
%          A, B   amplitude ratios at the port, F = reference flow area [m^2],
%          TR = reference temperature [K], CD = discharge coefficient
%
%          *** TWO CONSTANTS ARE REPAIRED AGAINST THE BOOK PAGE ***
%          CP and GAM are printed here as TR^.125 and TR^.0417. The
%          transcription (blair_clean.bas 1341-1342, 1362-1363) has TR^.25 and
%          TR^.417, having lost the "0.1" and the "0" of the exponents; the
%          damaged form makes GAM < 1, so GAM-1 is negative and every flow
%          reverses sign. Book page 310 of
%          references/Blair, G.P. - The Basic Design of Two-Stroke Engines
%          (SAE).pdf was rendered and read to settle it. See local_outflow.
% WRITES   H  specific enthalpy [J/kg], C = velocity [m/s], M = mass flow [kg/s],
%          D = density [kg/m^3]
% LOCALS   CP GAM AB TREF SD T (and MN, P1, P2, PR, PL - all dead stores)
%
% SIGN CONVENTION (load-bearing, do not "fix")
%   C = SD*(A-B)/(GAM-1) is positive when A > B, i.e. flow from the A side to
%   the B side, and M = CD*C*F*D carries that sign. BOX is fed the same signed
%   quantity as both its inflow MIN and its outflow MO, so its mass balance
%   MB2 = MB1 + DMI - DME only closes if the signs are preserved. Callers pass
%   the arguments in the order that makes the sign mean "into the device":
%   e.g. CALL OUTFLOW(BT(KT),AT(KT),...) at blair_clean.bas 334 means flow from
%   the crankcase into the transfer duct (A = BT(KT) is the crankcase side).
%
% UNUSED OUTPUTS
%   MN, P1, P2 (OUTFLOW) and PR, PL (INFLOW) are computed and never read
%   (VERIFY_STRUCTURE.md 2.4). They are kept so the bodies map line for line,
%   and marked as dead.
%
% JUDGEMENT CALLS
%   1. The dispatcher. See the note at the top.
%   2. AB^.5 is written as AB^0.5, not sqrt(AB). Blair uses the power operator
%      on a quantity that is physically positive; keeping the operator makes
%      any excursion into a negative AB visible as a complex result instead of
%      being silently transformed.
%   3. H, C, M, D are returned because Blair writes them through the argument
%      list.
%
% See also SUB_FLOW_OUT, SUB_FLOW_IN, SUB_BOX.

switch upper(op)
    case 'OUTFLOW'
        [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = local_outflow(varargin{:});
    case 'INFLOW'
        [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = local_inflow(varargin{:});
    otherwise
        error('sub_flow:badOp', ...
            'Unknown entry point "%s"; use ''OUTFLOW'' or ''INFLOW''.', op);
end

end


% =========================================================================
function [H, C, M, D] = local_outflow(m, A, B, F, TR, CD)
% 1341-1353
%
% *** SOURCE REPAIR, VERIFIED AGAINST THE BOOK PAGE (book p.600) ***
% The transcription in blair_clean.bas 1341-1342 reads
%       CP=481.17*TR^.25      GAM=1.7847/(TR^.417)
% The printed page reads
%       CP=481.17*TR^.125     GAM=1.7847/(TR^.0417)
% and both source notes (port/blair_subroutines_basic.txt 445-446 and
% port/blair_prog52_basic.txt 1128-1129) lost the "0" of "0.0417" and the
% "0.1" of "0.125". The transcribed form is unusable - GAM=1.7847/T^.417 is
% 0.164 at 300 K and 0.073 at 2000 K, i.e. GAM-1 NEGATIVE, so C and M come out
% with the wrong sign and the energy equation of SUB BOX is fed an enthalpy
% 2-3x too large (CP=2003 J/kgK at 300 K against cv=697). The printed form
% gives GAM=1.4074 at 300 K and 1.299 at 2000 K, and CP=982 at 300 K against
% cv+R=984, which is what Fig.5.6/5.7 of the book plot. Verified by rendering
% book page 310 (Computer Program Appendix - ProgList 5.0) from
% references/Blair, G.P. - The Basic Design of Two-Stroke Engines (SAE).pdf.
CP   = 481.17*TR^.125;           % printed TR^.125  (transcribed TR^.25)
GAM  = 1.7847/(TR^.0417);        % printed TR^.0417 (transcribed TR^.417)
AB   = (A+B)/2;
TREF = TR/AB^2;                  % TR is the superposition temperature
SD   = sqrt(GAM*m.GK*TREF);
C    = SD*(A-B)/(GAM-1);
H    = CP*TR;
D    = AB^.5*m.PA/(m.GK*TREF);
M    = CD*C*F*D;
MN   = C/sqrt(GAM*m.GK*TR);      % dead store, as printed
P1   = (.5*(A+1))^7;             % dead store, as printed
P2   = (.5*(B+1))^7;             % dead store, as printed
end


% =========================================================================
function [H, C, M, D] = local_inflow(m, A, B, F, TR, CD)
% 1362-1373. Same CP/GAM repair as local_outflow (book page 310 shows
% CP=481.17*TR^.125 and GAM=1.7847/(TR^.0417) in INFLOW too).
CP  = 481.17*TR^.125;            % printed TR^.125  (transcribed TR^.25)
GAM = 1.7847/(TR^.0417);         % printed TR^.0417 (transcribed TR^.417)
AB  = (A+B)/2;
SD  = sqrt(GAM*m.GK*TR);
C   = 2.5*SD*(A-B);
T   = TR*AB*AB;
H   = CP*T;
D   = AB^.5*m.PA/(m.GK*TR);
M   = CD*C*F*D;
MN  = C/sqrt(GAM*m.GK*T);        % dead store, as printed
PR  = (.5*(A+1))^7;              % dead store, as printed
PL  = (.5*(B+1))^7;              % dead store, as printed
end
