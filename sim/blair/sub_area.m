function [F, DF] = sub_area(DA, DB, KA, KB, F, DF)
%SUB_AREA  Linear-taper duct area distribution.  SUB AREA.
%
%   [F, DF] = SUB_AREA(DA, DB, KA, KB, F, DF)
%
% SOURCE
%   blair_clean.bas 1218-1228  (blair_full.bas 1218-1228)
%       SUB AREA(DA,DB,KA,KB,DF(),F())STATIC
%       C=(DB-DA)/(KB-KA)
%       FOR J=KA TO KB
%       A=J-KA
%       F(J)=((DA+C*A)^2)*.7854
%       NEXT J
%       KC=KB-1
%       FOR J=KA TO KC
%       DF(J)=F(J+1)-F(J)
%       NEXT J
%       END SUB
%   Book source 27970-27980, [D3] (the ProgList 2.0 twin is byte-identical).
%
% READS    DA, DB   diameter at mesh KA and at mesh KB [m]
%          KA, KB   first and last mesh index
%          F, DF    (overwritten)
% WRITES   F(J)     flow area at mesh J [m^2], KA..KB
%          DF(J)    area change F(J+1)-F(J), KA..KB-1
% LOCALS   C, A, J, KC
%
% TWO PRINTED ODDITIES, BOTH KEPT
%   1. .7854, not PI/4. Blair's area is 0.7854*d^2, i.e. pi/4 to 4 significant
%      figures. Replacing it with pi/4 would change every duct area by 2.3e-5
%      relative. Left as printed: this is Blair's constant, not a bug to fix.
%   2. The diameter is linearly tapered between the two END meshes over the
%      whole span, so a real stepped junction is modelled as a one-mesh taper
%      (INPUT_FORMAT.md section 8). That is the model, not an error.
%
% INDEX ARITHMETIC
%   The assertion below states Blair's implicit requirement: KA >= 1 (arrays are
%   1-based here) and KB <= numel(F). A = J-KA is the 0-based offset inside the
%   taper, so A=0 at the first mesh.
%
% See also BLAIR_INIT.

if KA < 1 || KB > numel(F) || KB > numel(DF)
    error('sub_area:indexRange', ...
        ['AREA called with KA=%d KB=%d but the arrays hold %d/%d elements\n' ...
         '(blair_clean.bas 1220-1227). Mesh counts must satisfy 1<=KA<=KB<=size.'], ...
        KA, KB, numel(F), numel(DF));
end

C = (DB - DA)/(KB - KA);
for J = KA:KB
    A = J - KA;
    F(J) = ((DA + C*A)^2)*.7854;
end
KC = KB - 1;
for J = KA:KC
    DF(J) = F(J+1) - F(J);
end

end
