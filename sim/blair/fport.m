function AK = fport(HOT, HTDC, PHT, FPRT, FPIP, CC)
%FPORT  Public wrapper for SUB FPORT.
%
%   AK = FPORT(HOT, HTDC, PHT, FPRT, FPIP, CC)
%
%   SUB FPORT lives inside SUB_PAREA.M (the task layout puts PAREA and FPORT in
%   one file, and MATLAB allows one public function per file). This wrapper is
%   the call path the model uses, so that a call site reads like Blair's:
%       m.AKE = fport(m.HEOT, m.HTDC, m.EXHT, m.FEPRT, m.FEP1, m.CCE);
%   instead of
%       m.AKE = sub_parea('FPORT', ...);
%
%   No logic here: see SUB_PAREA for the source, the semantics and the
%   judgement calls (in particular: no lower clamp on FINST, and the inlet call
%   site's deliberately swapped argument order).
%
% See also SUB_PAREA.

AK = sub_parea('FPORT', HOT, HTDC, PHT, FPRT, FPIP, CC);

end
