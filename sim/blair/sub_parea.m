function varargout = sub_parea(op, varargin)
%SUB_PAREA  Port full-open area (SUB PAREA) and its opening ramp (SUB FPORT).
%
%   [FP, DP] = SUB_PAREA('PAREA', m, NP, WP, HP, RT, RB)
%   AK       = SUB_PAREA('FPORT', HOT, HTDC, PHT, FPRT, FPIP, CC)
%
%   Two entries in one file because the two routines are the same subject: the
%   geometric port model of section 5.2. MATLAB allows only ONE public function
%   per file, so this file is a two-entry dispatcher over the two local
%   functions below. FPORT also has a one-line public wrapper, FPORT.M, so that
%   the call sites read like Blair's CALL.
%
% -------------------------------------------------------------------------
% SOURCE - SUB PAREA, blair_clean.bas 1422-1426
%   SUB PAREA(NP,WP,HP,RT,RB,FP,DP)STATIC
%   SHARED PI
%   FP=NP*(WP*HP-(2-PI/2)*(RT*RT+RB*RB))
%   DP=SQR(4*FP/PI)
%   END SUB
%   Book source 28130-28135, Eqn.5.2.6.
%
%   READS  m.PI (SHARED), NP WP HP RT RB
%   WRITES FP, DP (returned)
%   NP = number of ports, WP = effective width of each [m], HP = port height [m]
%   (the piston travel between opening and full opening), RT/RB = top/bottom
%   corner radii [m]. FP = full-open flow area [m^2], DP = equivalent diameter.
%
%   This is the FULL-OPEN area only. The crank-angle ramp is FPORT's linear
%   piston-travel law. Do not "improve" it to the angle-resolved Eqs.5.2.1-5.2.5
%   of Prog.5.2 - the results would no longer be Blair's (BUILD_MANIFEST 9.8).
%
% -------------------------------------------------------------------------
% SOURCE - SUB FPORT, blair_clean.bas 1177-1181
%   SUB FPORT(HOT,HTDC,PHT,FPRT,FPIP,AK,CC)STATIC
%   FINST=(HTDC-HOT)/PHT
%   IF FINST>1 THEN FINST=1
%   AK=CC*FINST*FPRT/FPIP
%   END SUB
%   Book source 27946-27950.
%
%   READS  HOT, HTDC, PHT, FPRT, FPIP, CC
%   WRITES AK (returned), FINST (local)
%   HOT = piston travel at which the port opens [m], HTDC = current travel [m],
%   PHT = travel between opening and full opening [m], FPRT/FPIP = port area /
%   pipe area, CC = discharge coefficient.
%
%   NO LOWER CLAMP. FINST goes negative if HTDC < HOT. Blair relies on the
%   callers' guards to prevent it (EXPORTOPEN only runs when HTDC > HEOT;
%   INPORTOPEN only when HTDC < HIOT, with its arguments deliberately swapped),
%   and no clamp is added here. VERIFY_STRUCTURE.md 5 warns that "normalising"
%   the inlet call at blair_clean.bas 1039 (FPORT(HTDC,HIOT,...) against
%   HEOT,HTDC at 963 and HTOT,HTDC at 1001) inverts the inlet port area and
%   makes FINST negative. That call is used exactly as printed.
%
% JUDGEMENT CALLS
%   1. The dispatcher. See the note at the top.
%   2. PAREA writes FP and DP by reference; they are returned.
%   3. FPORT's CC is a coefficient, not a variable Blair's caller expects back.
%      Only AK is returned.
%
% See also FPORT, BLAIR_INIT, BLAIR_STEP.

switch upper(op)
    case 'PAREA'
        [varargout{1}, varargout{2}] = local_parea(varargin{:});
    case 'FPORT'
        varargout{1} = local_fport(varargin{:});
    otherwise
        error('sub_parea:badOp', ...
            'Unknown entry point "%s"; use ''PAREA'' or ''FPORT''.', op);
end

end


% =========================================================================
function [FP, DP] = local_parea(m, NP, WP, HP, RT, RB)
% 1423-1425
FP = NP*(WP*HP - (2 - m.PI/2)*(RT*RT + RB*RB));
DP = sqrt(4*FP/m.PI);
end


% =========================================================================
function AK = local_fport(HOT, HTDC, PHT, FPRT, FPIP, CC)
% 1178-1180
FINST = (HTDC - HOT)/PHT;
if FINST > 1
    FINST = 1;
end
AK = CC*FINST*FPRT/FPIP;
end
