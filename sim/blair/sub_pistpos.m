function [HT, HB] = sub_pistpos(m, S, R, C, D)
%SUB_PISTPOS  Slider-crank piston position.  SUB PISTPOS (degrees version).
%
%   [HT, HB] = SUB_PISTPOS(m, S, R, C, D)
%
% SOURCE
%   blair_clean.bas 1410-1415  (blair_full.bas 1410-1415)
%       SUB PISTPOS(S,R,C,D,HT,HB)STATIC
%       SHARED DTOR
%       A=D*DTOR
%       HT=R+C-R*COS(A)-SQR(C*C-(R*SIN(A))^2)
%       HB=S-HT
%       END SUB
%   Book source 28124-28129, [D12] the DEGREE version. All eight call sites in
%   the program pass crank degrees.
%
% READS    m.DTOR            (SHARED)
% WRITES   HT, HB            (returned)
% LOCALS   A                 (the angle in radians)
%
% CONVENTIONS
%   S = stroke [m], R = crank radius [m], C = connecting-rod length [m],
%   D = crank angle [deg ATDC], HT = piston travel from TDC [m],
%   HB = piston travel from BDC [m].  HT+HB = S always.
%
% JUDGEMENT CALLS
%   1. Blair passes S,R,C,D by value and writes HT,HB by reference. MATLAB has
%      no reference arguments, so HT and HB are returned.
%   2. m is passed only because DTOR is SHARED. Any caller that already holds
%      DTOR could inline it; keeping the struct argument preserves the
%      SHARED declaration one-for-one.
%   3. SQR is sqrt. No domain clamp is added: C*C-(R*SIN(A))^2 is positive for
%      every legal engine (C > R, checked by load_case), and Blair has no clamp.
%
% See also BLAIR_INIT, BLAIR_STEP.

A  = D*m.DTOR;
HT = R + C - R*cos(A) - sqrt(C*C - (R*sin(A))^2);
HB = S - HT;

end
