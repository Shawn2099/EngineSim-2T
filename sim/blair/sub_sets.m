function [A, B] = sub_sets(A, B, K)
%SUB_SETS  Initialise a duct to A=B=1 (the reference state).  SUB SETS.
%
%   [A, B] = SUB_SETS(A, B, K)
%
% SOURCE
%   blair_clean.bas 1206-1211  (blair_full.bas 1206-1211)
%       SUB SETS(A(),B(),K)STATIC
%       FOR J=1 TO K
%       A(J)=1 : B(J)=1
%       NEXT J
%       END SUB
%   Book source 27964-27969, [D2] (the ProgList 2.0 twin is byte-identical).
%
% READS/WRITES  A, B   elements 1..K
% LOCALS        J
%
% A=B=1 means "still at the reference state": both Riemann variables equal the
% ambient value, so p = PA, u = 0. SUB AREA then sets the areas, and the run
% builds up from there.
%
% No SHARED variables, no judgement calls.
%
% See also SUB_AREA, BLAIR_INIT.

for J = 1:K
    A(J) = 1;
    B(J) = 1;
end

end
