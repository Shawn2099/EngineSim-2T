function [A, B] = sub_pipe(m, KA, KB, A, B, DF, F)
%SUB_PIPE  One step of the mesh (method of characteristics) solution.  SUB PIPE.
%
%   [A, B] = SUB_PIPE(m, KA, KB, A, B, DF, F)
%
% SOURCE
%   blair_clean.bas 1237-1270  (blair_full.bas 1237-1270)
%       SUB PIPE(KA,KB,A(),B(),DF(),F())STATIC
%       SHARED DZ,A2(),B2()
%       G1=3 : G2=2 : KC=KB-1
%       FOR J=KA TO KC
%         AA=DZ*A(J+1)*B(J) : BB=DZ*A(J)*B(J+1)
%         Y=(1+DZ*(G1*(A(J+1)-A(J))-G2*(B(J+1)-B(J))))
%         Z=(1+DZ*(G1*(B(J)-B(J+1))-G2*(A(J)-A(J+1))))
%         WA=(A(J+1)+G2*AA-G2*BB)/Y : RA=(A(J)-G1*BB+G1*AA)/Z
%         WB=(B(J+1)+G1*AA-G1*BB)/Y : RB=(B(J)+G2*AA-G2*BB)/Z
%         AA=WA-WB : BB=RA-RB : CC=WA+WB : DD=RA+RB
%         IF AA=0 THEN GOTO 23 : QA=-DZ*CC*AA*DF(J)/(4*F(J)) : GOTO 33
%       23 QA=0
%       33 IF BB=0 THEN GOTO 44 : QB=-DZ*BB*DD*DF(J)/(4*F(J)) : GOTO 55
%       44 QB=0
%       55 A2(J+1)=WA+QA : B2(J)=RB+QB
%       NEXT J
%       FOR J=KA TO KC : A(J+1)=A2(J+1) : B(J)=B2(J) : NEXT J
%       END SUB
%   Book source 27981-28018, [D4] the 5.0 body (label 23, not 22).
%
% READS    m.DZ     step ratio, from STAB
%          A, B     the duct amplitudes, 1..KB
%          DF, F    area change between meshes, and area, both 1..KB
%          KA, KB   first and last mesh index (=1 and KE/KT/KI)
% WRITES   A, B     updated in place, returned
% LOCALS   G1 G2 KC J AA BB Y Z WA RA WB RB CC DD QA QB
%
% A2() AND B2()
%   Blair declares A2(),B2() SHARED and DIMs them (20). They are pure scratch:
%   the first loop writes A2(KA+1..KB) and B2(KA..KB-1) and the second loop
%   reads exactly those elements back. Nothing is read before being written and
%   nothing survives the call, so the port keeps them LOCAL (sized to the duct)
%   rather than adding two arrays to the model struct. This is the one SHARED
%   declaration in the file that is not reproduced.
%
% THE TWO GOTO PAIRS
%   Both are forward jumps around a division; they are the guards against a
%   0/0 in QA and QB, so they are written as if/else, not simplified away.
%   The original labels 23/33/44/55 are kept in the comments.
%
% See also BLAIR_STEP.

G1 = 3;
G2 = 2;
KC = KB - 1;
DZ = m.DZ;

A2 = zeros(1, numel(A));
B2 = zeros(1, numel(B));

for J = KA:KC
    AA = DZ*A(J+1)*B(J);
    BB = DZ*A(J)*B(J+1);
    Y  = (1 + DZ*(G1*(A(J+1)-A(J)) - G2*(B(J+1)-B(J))));
    Z  = (1 + DZ*(G1*(B(J)-B(J+1)) - G2*(A(J)-A(J+1))));
    WA = (A(J+1) + G2*AA - G2*BB)/Y;
    RA = (A(J)   - G1*BB + G1*AA)/Z;
    WB = (B(J+1) + G1*AA - G1*BB)/Y;
    RB = (B(J)   + G2*AA - G2*BB)/Z;
    AA = WA - WB;
    BB = RA - RB;
    CC = WA + WB;
    DD = RA + RB;
    if AA == 0
        QA = 0;                       % 1258  23 QA=0
    else
        QA = -DZ*CC*AA*DF(J)/(4*F(J));
    end
    if BB == 0
        QB = 0;                       % 1262  44 QB=0
    else
        QB = -DZ*BB*DD*DF(J)/(4*F(J));
    end
    A2(J+1) = WA + QA;                % 1263  55
    B2(J)   = RB + QB;
end

for J = KA:KC
    A(J+1) = A2(J+1);
    B(J)   = B2(J);
end

end
