function [H, C, M, D] = sub_flow_in(m, A, B, F, TR, CD)
%SUB_FLOW_IN  Public wrapper for SUB INFLOW.
%
%   [H, C, M, D] = SUB_FLOW_IN(m, A, B, F, TR, CD)
%
%   SUB INFLOW lives inside SUB_FLOW.M (the task layout puts OUTFLOW and INFLOW
%   in one file, and MATLAB allows one public function per file). This wrapper
%   is the call path the model uses:
%       [m.HI1, m.CI1, m.MI1, m.D] = sub_flow_in(m, m.BI(1), m.AI(1), ...
%                                                m.FIPRT, m.TIREF, m.CDI);
%
%   INFLOW differs from OUTFLOW in exactly three places: the speed of sound uses
%   the reference temperature rather than the superposition temperature, C is
%   2.5*SD*(A-B) instead of SD*(A-B)/(GAM-1), and the enthalpy uses
%   T = TR*AB^2. blair_clean.bas 1044 chooses between them on PIR vs PCC1R.
%
%   No logic here: see SUB_FLOW for the source and the sign convention.
%
% See also SUB_FLOW, SUB_FLOW_OUT.

[H, C, M, D] = sub_flow('INFLOW', m, A, B, F, TR, CD);

end
