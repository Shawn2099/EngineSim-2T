function mdl = blair_run(mdl, rpm, throttle)
%BLAIR_RUN  Run the Blair Prog.5.1 model to cyclic convergence.
%
%   MDL = BLAIR_RUN(MDL)               the case's own RPM and THAR
%   MDL = BLAIR_RUN(MDL, RPM)          override the engine speed
%   MDL = BLAIR_RUN(MDL, RPM, THR)     override the speed and the load
%
%   MDL.RESULTS is filled with the interface contract:
%     power_kW  [kW]        bmep_bar [bar]   imep_bar [bar]
%     pmep_bar  [bar]       fmep_bar [bar]   bsfc_gkWh [g/kWh]
%     DR        [-]         SE [-]           TE [-]     CE [-]
%     pmax_bar  [bar]       tmax_K  [K]
%     converged [logical]   cycles  [int]
%
% WHAT A RUN IS
%   Blair's crank-angle loop, from the pre-loop state BLAIR_INIT leaves behind,
%   until the loop's own exit test fires: CYCLE reaches CYCLESTOP at the head of
%   the body (blair_clean.bas 275). With CYCLESTOP=7 that is six full
%   revolutions - the seventh begins and the loop leaves immediately - which is
%   Blair's fixed run length, and the reason DATOUT prints cycles 2..5.
%
%   A cycle is complete when RESETBDC fires (DEG>540, blair_clean.bas 487-497);
%   that is what increments JJ and fills the history. This function watches JJ
%   and tests convergence after each completed cycle:
%
%     converged when, between two consecutive completed cycles, every one of
%     DR, IMEP, PMEP and BMEP changes by less than CONFIG.tol relative
%     (a small absolute floor keeps a near-zero PMEP from forcing the test to
%     fail forever).
%
%   The run stops at the first converged cycle, or at Blair's CYCLESTOP-1
%   completed cycles, whichever comes first. CONFIG.min_cycles=5 prevents a
%   stop before the cycle Blair reports (Fig.5.9 is the fifth), so a default run
%   always computes exactly what Blair's does.
%
%   A WORD ON WHAT "CONVERGED" CAN MEAN HERE. Blair's model at CYCLESTOP=7 does
%   five complete revolutions, and on the QUB 400 case cycle-to-cycle changes
%   settle to about 0.1-1 % and then drift slowly (DR climbs ~0.15 %/cycle for
%   the next ten cycles) - the coarse mesh and the lumped scavenging correlation
%   do not converge to four digits. CONFIG.tol=1e-2 (1 %) therefore reports what
%   the model can actually deliver: the last two cycles agree to within 1 %.
%   RESULTS.CONVERGED=false is a meaningful answer, not a failure.
%
%   Removing the fixed 6-cycle stride is the only behaviour change: Blair
%   always runs to CYCLESTOP whatever the answer, and reports cycle 5. With the
%   default CONFIG the QUB 400 case stops at cycle 5 either way, so the numbers
%   are Blair's own fifth cycle. MDL.HIST carries every cycle.
%
%   Set MDL.CYCLESTOP higher before calling (the history arrays hold 20 slots,
%   so up to 19 completed cycles) if you want a longer run; BLAIR_RUN preserves
%   it across the restart.
%
% RESTART
%   The run always starts from MDL.INIT, the snapshot BLAIR_INIT took at the
%   head of the loop, so calling BLAIR_RUN twice on the same MDL with different
%   operating points gives independent results (SWEEP relies on this).
%
% RPM AND THROTTLE
%   RPM and THAR are the only two inputs that may be overridden. RPM also
%   re-derives RPS=RPM/60 and FMEP=100*STM*RPM (blair_clean.bas 1172/1177), and
%   both are written back into MDL.P so the record matches what was run.
%   Nothing else is re-derived: TCR, PA and the initial PC1/TC1/PCC1 do not
%   depend on speed.
%
% RESULTS COME FROM THE LAST COMPLETED CYCLE
%   results.* are taken at index n = the last completed cycle, from
%   POWER(n), BMEP(n), CMEP(n), PMEP(n), DELRAT(n), SEFFP(n), TEFFP(n),
%   CEFFP(n), PEAKP(n), PEAKT(n). Note SEFFP/TEFFP/CEFFP are stored one slot
%   HIGHER than Blair stores them, so that all of a cycle's quantities share one
%   index - see the index note in SUB_CYLINDER's caller, BLAIR_STEP/RESETTDC,
%   and CLEAN_LOG.md. The physics is untouched by that.
%
% ERRORS
%   blair:run:notInitialised   mdl has no .init snapshot
%   blair:run:badInput         rpm/throttle not a positive finite scalar
%   blair:run:noCycle          the loop left before completing one cycle
%
% See also BLAIR_INIT, BLAIR_STEP, SWEEP.

% -------------------------------------------------------------------------
% CONFIG
% -------------------------------------------------------------------------
CONFIG = struct();
CONFIG.tol        = 1e-2;   % relative change per cycle that counts as converged
CONFIG.min_cycles = 5;      % Blair reports the fifth cycle (Fig.5.9); never
                            % stop before it, or the transient is reported as a
                            % result
CONFIG.max_steps  = 20000;  % Blair's own FOR KK=1 TO 20000 guard

% -------------------------------------------------------------------------
% 0. Arguments
% -------------------------------------------------------------------------
if nargin < 1 || ~isstruct(mdl) || ~isfield(mdl, 'init')
    error('blair:run:notInitialised', ...
        'blair_run needs the struct blair_init returns (missing .init snapshot).');
end
if nargin < 2
    rpm = [];
end
if nargin < 3
    throttle = [];
end
if ~isempty(rpm)
    if ~isnumeric(rpm) || ~isscalar(rpm) || ~isfinite(rpm) || rpm <= 0
        error('blair:run:badInput', 'rpm must be a positive finite scalar, got %s.', ...
            mat2str(rpm));
    end
end
if ~isempty(throttle)
    if ~isnumeric(throttle) || ~isscalar(throttle) || ~isfinite(throttle) || ...
            throttle <= 0 || throttle > 1
        error('blair:run:badInput', ...
            'throttle (the THAR area ratio) must be in (0,1], got %s.', mat2str(throttle));
    end
end

% -------------------------------------------------------------------------
% 1. Restart from the pre-loop snapshot
% -------------------------------------------------------------------------
m = mdl;
% CYCLESTOP is a run control, not state: a caller who raises it (the history
% arrays hold 20 slots, so up to 19 completed cycles) must not have it reset by
% the snapshot.
cycles_top = m.CYCLESTOP;
f = fieldnames(m.init);
for i = 1:numel(f)
    m.(f{i}) = m.init.(f{i});
end
m.cyl = m.init.cyl;
m.CYCLESTOP = cycles_top;
m.CYCLEP    = m.CYCLESTOP + 10;

m.stop = false;

% -------------------------------------------------------------------------
% 2. Apply the operating point
% -------------------------------------------------------------------------
if ~isempty(rpm)
    m.RPM = rpm;
    m.RPS = m.RPM/60;                       % 1172
    m.FMEP = 100*m.STM*m.RPM;               % 1177
    m.p.RPM = rpm;
end
if ~isempty(throttle)
    m.THAR = throttle;
    m.p.THAR = throttle;
end

% -------------------------------------------------------------------------
% 3. The crank-angle loop
%
% One pass of BLAIR_STEP is one pass of Blair's body. The loop-exit tests stay
% inside the step, where blair_clean.bas 275 put them, so the number of steps
% is Blair's. Convergence is tested here, between cycles, because it is a run
% concept and not a statement of Blair's.
% -------------------------------------------------------------------------
prev = [];          % [DR IMEP PMEP BMEP] of the previous completed cycle
nprev = 0;          % JJ at that moment
converged = false;

while ~m.stop
    m = blair_step(m);

    if m.JJ > nprev                          % a cycle just completed
        nprev = m.JJ;
        cur = [m.DELRAT(nprev), m.CMEP(nprev), m.PMEP(nprev), m.BMEP(nprev)];
        if ~isempty(prev)
            converged = local_converged(prev, cur, CONFIG.tol);
        end
        prev = cur;
        if converged && nprev >= CONFIG.min_cycles
            m.stop = true;
        end
    end

    if m.KK >= CONFIG.max_steps
        m.stop = true;
    end
end

% -------------------------------------------------------------------------
% 4. Results
% -------------------------------------------------------------------------
n = m.JJ;
if n < 1
    error('blair:run:noCycle', ...
        ['The loop left after %d step(s) without completing one cycle ' ...
         '(CYCLESTOP=%d). No result can be reported.'], m.KK, m.CYCLESTOP);
end

r = mdl.results;            % keep the contract's field order and any extra
r.power_kW  = m.POWER(n);           % 495  [kW]
r.bmep_bar  = m.BMEP(n)/100000;     % 494
r.imep_bar  = m.CMEP(n)/100000;     % 493
r.pmep_bar  = -m.PMEP(n)/100000;    % 492  DATOUT prints -PMEP (blair 506)
r.fmep_bar  = m.FMEP/100000;        % 1177
r.bsfc_gkWh = m.BSFC(n)*1000;       % 497  [kg/kWh] -> [g/kWh]
r.DR        = m.DELRAT(n);          % 489
r.SE        = m.SEFFP(n);           % 523  (index note above)
r.TE        = m.TEFFP(n);           % 524
r.CE        = m.CEFFP(n);           % 525
r.pmax_bar  = m.PEAKP(n);           % 490  PMAX is already in bar
r.tmax_K    = m.PEAKT(n);           % 491
r.converged = logical(converged);
r.cycles    = n;

% Beyond the 14 contract fields. The scavenge ratios and the peak-pressure
% angle are printed by Blair (DATOUT 489-508 and RESETBDC 508) and are scored by
% sim/blair/check_qub400.m; they cost nothing to carry and make the port usable
% without reaching into mdl.hist.
r.sr                = m.SRMP(n);        % 526  scavenge ratio, mass basis
r.srv               = m.SRVP(n);        % 527  scavenge ratio, volume basis
r.exhaust_flow_ratio = m.EXRP(n);       % 528
r.peak_angle_deg    = m.MAXDEG;         % 508  deg ATDC
r.bsfc_kgkWh        = m.BSFC(n);        % 497  same number, kg/kWh
r.swept_volume_cm3  = m.SV*1e6;
r.rpm               = m.RPM;
r.throttle          = m.THAR;

m.results = r;

% -------------------------------------------------------------------------
% 5. The per-cycle history, for callers that want a different cycle
% -------------------------------------------------------------------------
m.hist = struct( ...
    'cycles', (1:n)', ...
    'DR',     m.DELRAT(1:n)',  'SE',   m.SEFFP(1:n)', 'TE',   m.TEFFP(1:n)', ...
    'CE',     m.CEFFP(1:n)',   'SR',   m.SRMP(1:n)',  'SRV',  m.SRVP(1:n)', ...
    'EXR',    m.EXRP(1:n)',    'IMEP', m.CMEP(1:n),   'PMEP', m.PMEP(1:n), ...
    'BMEP',   m.BMEP(1:n),     'POWER', m.POWER(1:n), 'BSFC', m.BSFC(1:n), ...
    'PEAKP',  m.PEAKP(1:n),    'PEAKT', m.PEAKT(1:n), 'FUEL', m.FUEL(1:n));

mdl = m;

end % ===================== end blair_run =====================


% =========================================================================
function tf = local_converged(a, b, tol)
% True when every quantity changed by less than tol relative, with an absolute
% floor so that a quantity passing through zero cannot keep the test failing.
floor_abs = 1e-9;
d = abs(b - a)./max(abs(b), floor_abs);
tf = all(d < tol);
end
