function [A, B] = sub_shok(A, B, KA, KB)
%SUB_SHOK  Shock (discontinuity) correction at a mesh.  SUB SHOK.
%
%   [A, B] = SUB_SHOK(A, B, KA, KB)
%
% SOURCE
%   blair_clean.bas 1277-1291  (blair_full.bas 1277-1291)
%       SUB SHOK(A(),B(),KA,KB)STATIC
%       FOR J=KA TO KB
%       R1=5*ABS(A(J)-B(J))/(A(J)+B(J))
%       IF R1<1 THEN GOTO 56
%       R2=SQR((R1*R1+5)/(7*R1*R1-1))
%       R3=(A(J)+B(J))*((7*R1*R1-1)/6)^(1/7)
%       IF A(J)>B(J) THEN GOTO 26
%       A(J)=(5-R2)*R3/10 : B(J)=(5+R2)*R3/10 : GOTO 56
%      26 A(J)=(5+R2)*R3/10 : B(J)=(5-R2)*R3/10
%      56 R1=0
%       NEXT J
%       END SUB
%   Book source 28019-28033, [D5] the 5.0 body. No SHARED, no array arguments
%   in effect - it only reads and writes A and B.
%
% READS/WRITES  A, B   amplitudes at meshes KA..KB
% LOCALS        J R1 R2 R3
%
% FORWARD JUMPS
%   1280 GOTO 56 skips the whole correction when |R1| < 1: the mesh is
%   subsonic. 1283 GOTO 26 selects which of the pair is the up-running wave.
%   The 56 label is only `R1=0`, a dead store (VERIFY_STRUCTURE.md 2.4); it is
%   kept so the loop body matches the source line for line.
%
% TWO CALL SITES ARE DUPLICATES
%   The main loop calls SHOK twice on the exhaust duct (blair_clean.bas 322 and
%   328, [D17]). The second call finds |R1|<1 everywhere and changes nothing, so
%   the duplicate is harmless. It is KEPT, both here and at the call site: it is
%   Blair's statement flow, not a defect to repair.
%
% JUDGEMENT CALLS
%   R2 = sqrt(...) is only evaluated when R1 >= 1, exactly as printed, so the
%   7*R1*R1-1 denominator can never be zero or negative here.
%
% See also BLAIR_STEP.

for J = KA:KB
    R1 = 5*abs(A(J)-B(J))/(A(J)+B(J));
    if R1 < 1
        % 1280 GOTO 56 - subsonic, nothing to correct
    else
        R2 = sqrt((R1*R1 + 5)/(7*R1*R1 - 1));
        R3 = (A(J)+B(J))*((7*R1*R1 - 1)/6)^(1/7);
        if A(J) > B(J)
            A(J) = (5 + R2)*R3/10;      % 1287  26
            B(J) = (5 - R2)*R3/10;
        else
            A(J) = (5 - R2)*R3/10;      % 1284
            B(J) = (5 + R2)*R3/10;
        end
    end
    R1 = 0;                             % 1289  56 R1=0 (dead store, as printed)
end

end
