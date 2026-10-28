function m = sub_stab(m, A, B, K, S, E)
%SUB_STAB  Courant stability limit for one duct -> DC and DTM.  SUB STAB.
%
%   m = SUB_STAB(m, A, B, K, S, E)
%
% SOURCE
%   blair_clean.bas 1190-1199  (blair_full.bas 1190-1199)
%       SUB STAB(A(),B(),K,S,E)STATIC
%       SHARED DZ,DTM,DC,RPM
%       C=60*S/(RPM*E)
%       FOR J=1 TO K
%       Z=2/((A(J)+B(J))+ABS(5*(A(J)-B(J))))
%       IF Z<DZ THEN DZ=Z
%       NEXT J
%       DC=360*DZ/C
%       DTM=DC/(6*RPM)
%       END SUB
%   Book source 27951-27963, [D1] the 5.0 body: NO DZ=1 initialiser here.
%
% READS    m.DZ   running minimum, set to 1 by the caller before the block of
%                 five calls and damped to .99*DZ after it
%          m.RPM  engine speed [rev/min]
%          A, B   the duct's two amplitude arrays, elements 1..K
%          K      mesh count, S = speed of sound [m/s], E = mesh length [m]
% WRITES   m.DZ   lowered to this duct's minimum Z (never raised)
%          m.DC   crank-angle step [deg]
%          m.DTM  time step [s]
% LOCALS   C, J, Z
%
% THE THREE STAGES ARE ONE CONTRACT
%   DZ is NOT reset inside STAB: the main loop sets DZ=1 once, calls STAB five
%   times so DZ becomes the minimum over all four ducts, then damps it .99*DZ.
%   DC is then formed from the global DZ but from the C of THIS call. Blair
%   calls STAB on the exhaust duct last, so DC uses the exhaust-duct Courant
%   number. Adding DZ=1 here ([D1]'s rejected alternative) would make each call
%   set its own step and the run would go unstable.
%
% UNITS
%   C = 60*S/(RPM*E) is the number of intervals of length E that a wave crosses
%   in one revolution: [m/s] / ([rev/min]*[m]) * 60 = 1/rev. DC = 360*DZ/C is
%   then degrees per step, and 6*RPM is [deg/s], so DTM = DC/(6*RPM) is [s].
%
% JUDGEMENT CALLS
%   1. m is returned because STAB is the only routine that writes DZ/DTM/DC,
%      which are exactly its SHARED set. Passing them as three separate
%      in/out values would hide the accumulation contract above.
%   2. The loop is FOR J = 1 TO K, as printed. If K=0 it does not execute and
%      DC keeps its previous value - Blair has no guard and neither does this.
%      (sub_nint now refuses K1<2, so K=0 cannot reach here from BLAIR_INIT.)
%
% See also BLAIR_STEP.

C = 60*S/(m.RPM*E);
for J = 1:K
    Z = 2/((A(J)+B(J)) + abs(5*(A(J)-B(J))));
    if Z < m.DZ
        m.DZ = Z;
    end
end
m.DC  = 360*m.DZ/C;
m.DTM = m.DC/(6*m.RPM);

end
