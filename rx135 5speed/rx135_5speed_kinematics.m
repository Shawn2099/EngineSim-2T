% rx135_5speed_kinematics.m
% Crank-angle-resolved piston kinematics + cylinder volume for the
% Yamaha RX135 5-speed (Indian). Uses rx135_5speed_params().
% Port timing (opening angles) are NOT FOUND -> left as NaN and the
% port-state logic is stubbed. Run: rx135_5speed_kinematics

function rx135_5speed_kinematics()
    P = rx135_5speed_params();

    % Convert mm -> m
    B = P.bore/1000;            % bore
    S = P.stroke/1000;          % stroke
    L = P.conn_rod_mm/1000;     % connecting rod (UNVERIFIED 98 mm)
    r = S/2;                    % crank radius
    Vd = pi/4*B^2*S;            % displacement (m^3)

    % Crank angle grid over 2 revolutions (720 deg) for a 2-stroke
    % (one power cycle per rev, but grid over 720 for completeness)
    theta = linspace(0, 720, 7201);   % deg
    th = deg2rad(theta);

    % Piston position from TDC (positive downward) for slider-crank
    % x = r*(1 - cos th) + (L - sqrt(L^2 - (r*sin th).^2))
    % (standard; theta=0 at TDC)
    x = r*(1 - cos(th)) + (L - sqrt(L.^2 - (r*sin(th)).^2));

    % Cylinder volume above piston (clearance volume + swept)
    % Clearance volume from CR: Vc = Vd/(CR-1)
    Vc = Vd/(P.CR_geometric - 1);
    V  = Vc + pi/4*B^2.*x;     % m^3

    % Port state placeholders (NaN -> unknown). When port timing is measured,
    % replace the NaN tests below with real opening angles.
    % Exhaust opens at exhaust_open_BTDC (deg BTDC) -> theta_exo = 360 - P.exhaust_open_BTDC
    % Transfer opens at transfer_open_ATDC (deg ATDC from TDC) -> theta_tro = P.transfer_open_ATDC
    exo = P.exhaust_open_BTDC;
    tro = P.transfer_open_ATDC;
    if isnan(exo) || isnan(tro)
        fprintf('Port timing NOT FOUND - port states set to unknown (NaN).\n');
        exhaust_open = false(size(theta));
        transfer_open = false(size(theta));
    else
        exhaust_open  = (theta >= (360 - exo)) & (theta <= (360 + exo));  % crude
        transfer_open = (theta >= tro) & (theta <= (360 - tro));
    end

    % --- Plots ---
    figure('Name','RX135 5-speed kinematics');
    subplot(3,1,1);
    plot(theta, x*1000); grid on;
    xlabel('Crank angle (deg)'); ylabel('Piston from TDC (mm)');
    title('Piston position vs crank angle');

    subplot(3,1,2);
    plot(theta, V*1e6); grid on;
    xlabel('Crank angle (deg)'); ylabel('Cylinder volume (cm^3)');
    title(sprintf('Cylinder volume (CR = %.1f:1, Vd = %.1f cc)', P.CR_geometric, Vd*1e6));

    subplot(3,1,3);
    plot(theta, double(exhaust_open), 'r', theta, double(transfer_open), 'b');
    grid on; ylim([-0.1 1.1]);
    xlabel('Crank angle (deg)'); ylabel('Port open (0/1)');
    legend('Exhaust (unknown)','Transfer (unknown)','Location','best');
    title('Port state (placeholder - timing NOT FOUND)');

    % Print summary
    fprintf('\n--- RX135 5-speed kinematics summary ---\n');
    fprintf('Bore = %.1f mm, Stroke = %.1f mm, Rod = %.1f mm (UNVERIFIED)\n', P.bore, P.stroke, P.conn_rod_mm);
    fprintf('Displacement = %.2f cc, Clearance volume = %.2f cc\n', Vd*1e6, Vc*1e6);
    fprintf('CR = %.1f:1 (factory T1)\n', P.CR_geometric);
    fprintf('Peak cylinder volume = %.2f cc\n', max(V)*1e6);
    fprintf('Port timing = NOT FOUND (fill P.exhaust_open_BTDC etc.)\n');
end
