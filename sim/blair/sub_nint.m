function K1 = sub_nint(m, PL, TE, TP)
%SUB_NINT  Number of meshes for a duct.  SUB NINT.
%
%   K1 = SUB_NINT(m, PL, TE, TP)
%
% SOURCE
%   blair_clean.bas 1487-1495  (blair_full.bas 1489-1497)
%       SUB NINT(K1,PL,TE,TP)STATIC
%       SHARED LMESH
%       A=SQR(TE/TP)
%       RI=PL*A/LMESH
%       KI=INT(RI)
%       BI=RI-KI
%       IF BI>.5 THEN KI=KI+1
%       K1=KI+1
%       END SUB
%   Book source 28049-28059, [D7] the 5.0 body.
%
% READS    m.LMESH   reference mesh length [mm], 30, set once by the caller
% WRITES   K1        the caller's mesh count, returned
% LOCALS   A, RI, KI, BI   (all overwritten before use, see below)
%
% UNITS    PL is in mm (like LMESH) and TE/TP are K, so RI is a plain count.
%          The result is the number of MESHES, i.e. the largest array index,
%          not the number of cells.
%
% INDEX ARITHMETIC AND THE ASSERTION
%   Blair's K1 is a 1-based BASIC array bound: K1 = KI+1 where KI = INT(RI) is
%   a count of intervals. The duct arrays are DIM'd (20), i.e. they have
%   elements 0..20, and the program uses 1..KE with KE = K1. The assertions
%   below state the two limits that arithmetic imposes, which Blair states
%   nowhere (VERIFY_STRUCTURE.md 3.2):
%       K1 <= 20   the four duct arrays are DIM(20)
%       K1 >= 2    because the callers divide by (K1-1) for the mesh length,
%                  and NINT returns 1 for any pipe shorter than ~15 mm
%                  (or L = 0), which is an unguarded division by zero at
%                  blair_clean.bas 170-173.
%
% STATIC NOTE
%   KI is a STATIC local in Blair's SUB, but line 1489 assigns it
%   unconditionally before line 1492 reads it, so its persistence has no
%   effect. [D7]'s double-increment only appears if KI is made GLOBAL, because
%   the inlet call is CALL NINT(KI,...) and the two names would alias. KI is a
%   function local here, which is the correct reading.
%
% JUDGEMENT CALLS
%   INT() in BASIC is floor(), and it is used on a positive quantity, so
%   floor() reproduces it. round() would change the mesh counts.
%
% See also BLAIR_INIT.

A  = sqrt(TE/TP);
RI = PL*A/m.LMESH;
KI = floor(RI);            % BASIC INT()
BI = RI - KI;
if BI > .5
    KI = KI + 1;
end
K1 = KI + 1;

if K1 > 20
    error('sub_nint:meshTooFine', ...
        ['NINT returns K1=%d for PL=%g mm, TE/TP=%g/%g (blair_clean.bas 1493).\n' ...
         'The duct arrays are DIM(20) (blair_clean.bas 51-54), so K1 must be <= 20.\n' ...
         'Lengthen LMESH (currently %g mm) or shorten the duct.'], ...
        K1, PL, TE, TP, m.LMESH);
end
if K1 < 2
    error('sub_nint:meshTooCoarse', ...
        ['NINT returns K1=%d for PL=%g mm, TE/TP=%g/%g (blair_clean.bas 1493).\n' ...
         'K1=1 makes the callers divide by (K1-1)=0 at blair_clean.bas 170-173.\n' ...
         'A duct must be at least about LMESH/2 = %g mm long.'], ...
        K1, PL, TE, TP, m.LMESH/2);
end

end
