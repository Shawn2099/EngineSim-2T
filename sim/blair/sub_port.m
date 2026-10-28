function [A, AK] = sub_port(m, B, P, AK)
%SUB_PORT  Unsteady-flow boundary condition at a port, from the UFLO table.
%
%   [A, AK] = SUB_PORT(m, B, P, AK)
%
% SOURCE
%   blair_clean.bas 1299-1313  (blair_full.bas 1299-1313)
%       SUB PORT(A,B,P,AK)STATIC
%       SHARED ABX(),BX(),AKA(),PA
%       X1=(P/PA)^(1/7)
%       BX1=B/X1
%       IF AK>.95 THEN AK=.95
%       IF BX1<.6 THEN BX1=.6
%       I=INT(AK/.05)+1
%       J=INT((BX1-.6)/.02)+1
%       RA=(AK-AKA(I))/(AKA(I+1)-AKA(I))
%       AB1=RA*(ABX(I+1,J+1)-ABX(I,J+1))+ABX(I,J+1)
%       AB2=RA*(ABX(I+1,J)-ABX(I,J))+ABX(I,J)
%       RB=(BX1-BX(J))/(BX(J+1)-BX(J))
%       ABX1=RB*(AB1-AB2)+AB2
%       A=2*X1*ABX1-B
%       END SUB
%   Book source 28034-28048, [D6] the 5.0 body.
%
% READS    m.PA, m.ABX, m.BX, m.AKA     (SHARED)
%          B     incoming amplitude ratio B1/Xc at the port
%          P     the static pressure the port faces [Pa]
%          AK    port-to-pipe area ratio (the discharge coefficient here)
% WRITES   A     the outgoing amplitude ratio, returned
%          AK    clamped to .95, returned because Blair passes it by reference
% LOCALS   X1, BX1, I, J, RA, AB1, AB2, RB, ABX1
%
% WHAT IT COMPUTES
%   The boundary condition of Fig.2.7: given the pressure across the port and
%   the incoming wave B, look up (A+B)/Xc in the 21x41 table and return
%   A = 2*X1*ABX1 - B, where X1 = (p/PA)^(1/7) is the isentropic pressure
%   amplitude ratio for gamma = 1.4.
%
% ARGUMENT ORDER AT THE CALL SITES (do not normalise)
%   Callers pass (B,A) where the port sits at the OUTGOING end of the duct and
%   (A,B) where it sits at the incoming end (VERIFY_STRUCTURE.md 5). The first
%   argument is always the one PORT overwrites. blair_clean.bas 1039's FPORT
%   call has its first two arguments swapped relative to 963/1001 and is
%   correct as printed; it is not normalised here either.
%
% INDEX ARITHMETIC AND THE ASSERTIONS
%   Blair's I and J are 1-based and stay 1-based here - the arrays are not
%   shifted, so the same index arithmetic applies unchanged:
%       I = INT(AK/.05)+1  ->  1..20 for AK in 0...95, and ABX(I+1,..) reads
%                              rows 2..21, which is exactly ABX's 21 rows.
%       J = INT((BX1-.6)/.02)+1 -> 1..41 for BX1 in .60..1.40, and BX(J+1)
%                              reads up to column 42 of a 45-column array.
%   The 45 columns matter: UFLO fills only 1..41, so columns 42..45 are ZERO in
%   BASIC and are zero here (m.ABX and m.BX are zero-padded in BLAIR_INIT).
%   For BX1 just above 1.40 the code therefore interpolates against a zero
%   column, exactly as Blair does; that is VERIFY_STRUCTURE.md 3.2's defect and
%   it is deliberately NOT fixed. What is guarded is only what is undefined:
%       * J+1 > 45  would index past the array (BASIC corrupts memory, MATLAB
%         errors) - stopped with a named error;
%       * BX(J+1) == BX(J) is a 0/0 at 1310 for BX1 in [1.42,1.48) - stopped
%         with a named error, because BASIC raises "Division by zero" there too
%         and a silent NaN would poison every later step.
%
% JUDGEMENT CALLS
%   1. Blair's first argument A is a pure OUTPUT dummy: it is assigned at 1312
%      and never read. It is returned rather than passed in, so the signature
%      is (m, B, P, AK) -> [A, AK].
%   2. INT() is floor(). AK/.05 and (BX1-.6)/.02 are exact at the breakpoints,
%      and at a breakpoint either of the two adjacent I (or J) reproduces the
%      same interpolated value, so floor() and Blair's single-precision INT()
%      agree wherever the table is defined. They can differ at BX1 just below a
%      breakpoint; the resulting value is continuous there, so no jump appears.
%
% See also BLAIR_STEP, LOAD_UFLO.

X1  = (P/m.PA)^(1/7);
BX1 = B/X1;
if AK > .95
    AK = .95;
end
if BX1 < .6
    BX1 = .6;
end
I = floor(AK/.05) + 1;
J = floor((BX1-.6)/.02) + 1;

if I < 1 || I+1 > size(m.ABX,1)
    error('sub_port:indexI', ...
        ['PORT: I=%d from AK=%g (blair_clean.bas 1305) indexes rows %d/%d of a\n' ...
         '%dx%d ABX. AK must satisfy 0 <= AK <= .95. Check the caller''s AK.'], ...
        I, AK, I, I+1, size(m.ABX,1), size(m.ABX,2));
end
if J < 1 || J+1 > size(m.ABX,2) || J+1 > numel(m.BX)
    error('sub_port:indexJ', ...
        ['PORT: J=%d from BX1=%g (blair_clean.bas 1306) indexes column %d of a\n' ...
         '%d-column ABX / %d-element BX. BX1 = B/X1 must be <= 1.48 to keep this\n' ...
         'inside DIM ABX(21,45). This is VERIFY_STRUCTURE.md 3.2: SUB PORT has no\n' ...
         'upper clamp on BX1. The state that produced it: B=%g, P=%g Pa.'], ...
        J, BX1, J+1, size(m.ABX,2), numel(m.BX), B, P);
end
if m.BX(J+1) == m.BX(J)
    error('sub_port:bx1OffTable', ...
        ['PORT: BX1=%g falls in the untabulated band 1.42..1.48 (blair_clean.bas\n' ...
         '1310): BX(%d)=BX(%d)=0, so RB is 0/0. UFLO is only filled for columns\n' ...
         '1..41 (BX1 <= 1.40). The state that produced it: B=%g, P=%g Pa.\n' ...
         'Fix the table or bound the run - do not silently clamp here.'], ...
        BX1, J, J+1, B, P);
end

RA  = (AK - m.AKA(I))/(m.AKA(I+1) - m.AKA(I));
AB1 = RA*(m.ABX(I+1,J+1) - m.ABX(I,J+1)) + m.ABX(I,J+1);
AB2 = RA*(m.ABX(I+1,J)   - m.ABX(I,J))   + m.ABX(I,J);
RB  = (BX1 - m.BX(J))/(m.BX(J+1) - m.BX(J));
ABX1 = RB*(AB1 - AB2) + AB2;
A = 2*X1*ABX1 - B;

end
