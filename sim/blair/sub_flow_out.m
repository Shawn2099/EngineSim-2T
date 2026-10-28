function [H, C, M, D] = sub_flow_out(m, A, B, F, TR, CD)
%SUB_FLOW_OUT  Public wrapper for SUB OUTFLOW.
%
%   [H, C, M, D] = SUB_FLOW_OUT(m, A, B, F, TR, CD)
%
%   SUB OUTFLOW lives inside SUB_FLOW.M (the task layout puts OUTFLOW and
%   INFLOW in one file, and MATLAB allows one public function per file). This
%   wrapper is the call path the model uses:
%       [m.HE1, m.CE1, m.ME1, m.D] = sub_flow_out(m, m.AE(1), m.BE(1), ...
%                                                m.FEP1, m.TC1, m.CDE);
%
%   No logic here: see SUB_FLOW for the source, the sign convention that BOX's
%   mass balance depends on, and the dead stores (MN, P1, P2).
%
% See also SUB_FLOW, SUB_FLOW_IN.

[H, C, M, D] = sub_flow('OUTFLOW', m, A, B, F, TR, CD);

end
