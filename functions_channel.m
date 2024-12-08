function functions_channel()
    % This can be empty if you're not calling it directly.
end

%% Initialize UE and BS
function [pUE, pBS, v_UE_vec] = initializeUEandBS(v_UE)
    % Initialize positions of UE and BS
    pUE = [0, 0]; % UE position at origin
    pBS = [100, 0]; % BS position at (100, 0)

    % Define UE movement direction (unit vector)
    direction_angle = pi / 4; % 45 degrees (example direction)
    v_UE_vec = v_UE * [cos(direction_angle), sin(direction_angle)];
end


%% Cluster Position
function cluster = placeCluster(center, r_min, r_max, num_scatterers)
    % Place scatterers in a circular region around a given center
    theta = 2 * pi * rand(num_scatterers, 1); % Uniform angles
    r = sqrt(rand(num_scatterers, 1)) * (r_max - r_min) + r_min; % Uniform radii
    cluster = [center(1) + r .* cos(theta), center(2) + r .* sin(theta)];
end

% Path Loss
function PL = calculatePathLoss(distance, fc, isLOS)
    Calculate Path Loss (PL) based on LOS or NLOS
    hBSprime = 10 - 1;    % Effective height of BS
    hUEprime = 1.5 - 1;   % Effective height of UE
    d_break = 4 * hBSprime * hUEprime * fc / 3e8; % Breakpoint distance

    if isLOS
        LOS Path Loss
        if distance <= d_break
            PL = 32.4 + 21 * log10(distance) + 20 * log10(fc);
        else
            PL = 32.4 + 40 * log10(distance) + 20 * log10(fc) - ...
                 9.5 * log10(d_break^2 + (10 - 1.5)^2);
        end
    else
        NLOS Path Loss
        PL_LOS = 32.4 + 21 * log10(distance) + 20 * log10(fc);
        PL_NLOS = 35.3 * log10(distance) + 22.4 + 21.3 * log10(fc) - ...
                  0.3 * (1.5 - 1.5);
        PL = max(PL_LOS, PL_NLOS); % Choose the worst path loss
    end
end

%% Cluster Rays Function
function [raysBSCluster1, raysCluster1Cluster2, raysCluster2UE, isLOS] = ...
         launchTwinClusterRays(pBS, pUE, cluster1, cluster2)
    % Generate rays for twin clusters
    raysBSCluster1 = cluster1 - pBS; % BS → Cluster 1
    raysCluster1Cluster2 = cluster2 - cluster1; % Cluster 1 → Cluster 2
    raysCluster2UE = pUE - cluster2; % Cluster 2 → UE
    
    % LOS Probability (Example)
    distLOS = norm(pUE - pBS); % LOS distance
    PLOS = P_th(18, 36, 1, distLOS); % Calculate LOS probability
    isLOS = rand <= PLOS; % Random draw to determine LOS
end

%% Compute MPCs for Twin-Clusters

function MPCs = computeTwinClusterMPCs(pUE, pBS, cluster1, cluster2, ...
                                       raysBSCluster1, raysCluster1Cluster2, raysCluster2UE, ...
                                       isLOS, v_unit, v_mag, fc)
    % Compute Multipath Components (MPCs) for twin clusters
    % v_unit: Unit velocity vector of the UE direction
    % v_mag: Magnitude of the UE velocity
    % fc: Carrier frequency
    
    % Number of scatterers in each cluster
    numPathsCluster1 = size(cluster1, 1);
    numPathsCluster2 = size(cluster2, 1);
    numPaths = numPathsCluster1 + numPathsCluster2 + double(isLOS); % Total paths (LOS included)
    
    MPCs = zeros(numPaths, 6); % Initialize MPC matrix
    
    % Combine LOS and NLOS paths
    if isLOS
        % LOS Path
        LOS_ray = pUE - pBS; % LOS ray direction
        LOS_distance = norm(LOS_ray); % LOS path distance
        LOS_tau = LOS_distance / 3e8; % LOS delay
        
        % LOS Doppler shift
        LOS_k = LOS_ray / norm(LOS_ray); % LOS ray unit vector
        LOS_cosGamma = dot(LOS_k, v_unit);
        LOS_nu = -(fc / 3e8) * v_mag * LOS_cosGamma; % LOS Doppler shift
        
        % LOS Path Loss
        LOS_PL = calculatePathLoss(LOS_distance, fc, true); % Use LOS path loss formula
        LOS_amplitude = sqrt(10^(-LOS_PL / 10)); % Convert to linear scale
        
        % Populate LOS path into MPCs
        MPCs(1, :) = [LOS_amplitude, rand * 2 * pi, LOS_tau, ...
                      atan2(LOS_ray(2), LOS_ray(1)), atan2(-LOS_ray(2), -LOS_ray(1)), LOS_nu];
    end
    
    % Combine NLOS paths (BS → Cluster 1 → Cluster 2 → UE)
    for i = 1:numPathsCluster1
        % Cluster 1 path
        rayBSCluster1 = raysBSCluster1(i, :);
        rayCluster1Cluster2 = raysCluster1Cluster2(i, :);
        rayCluster2UE = raysCluster2UE(i, :);
        
        % Total delay
        delay = norm(rayBSCluster1) / 3e8 + ...
                norm(rayCluster1Cluster2) / 3e8 + ...
                norm(rayCluster2UE) / 3e8;
        
        % Path Loss for this path
        total_distance = norm(rayBSCluster1) + norm(rayCluster1Cluster2) + norm(rayCluster2UE);
        PL = calculatePathLoss(total_distance, fc, false); % Use NLOS path loss formula
        amplitude = sqrt(10^(-PL / 10)); % Convert to linear scale
        
        % Doppler shift
        ray_to_UE = rayCluster2UE; % Direction of the last hop
        k = ray_to_UE / norm(ray_to_UE); % Unit vector of the ray
        cosGamma = dot(k, v_unit); % Angle with UE velocity
        doppler = -(fc / 3e8) * v_mag * cosGamma;
        
        % Angles
        phiRX = atan2(ray_to_UE(2), ray_to_UE(1)); % RX angle
        phiTX = atan2(rayBSCluster1(2), rayBSCluster1(1)); % TX angle
        
        % Populate the MPC matrix
        MPCs(i + double(isLOS), :) = [amplitude, rand * 2 * pi, delay, phiRX, phiTX, doppler];
    end
end

%% Generate Channel Matrix
function H = generateChannelMatrix(MPCs, BW, sf)
    % Generate the Channel Matrix (frequency-domain representation)
    num_subcarriers = round(BW / sf);
    amplitudes = MPCs(:, 1); % MPC amplitudes
    phases = MPCs(:, 2);     % MPC phases
    delays = MPCs(:, 3);     % MPC delays
    H = zeros(num_subcarriers, 1);
    for k = 1:num_subcarriers
        fk = (k - 1) * sf; % Subcarrier frequency
        H(k) = sum(amplitudes .* exp(-1j * 2 * pi * fk * delays + 1j * phases));
    end
end

%% Calculate Delay Spread
function DS = calculateDelaySpread(raysBSCluster1, raysCluster1Cluster2, raysCluster2UE, isLOS)
    % Calculate Delay Spread (DS) for Twin Cluster Model
    delays = vecnorm(raysBSCluster1, 2, 2) / 3e8 + ...
             vecnorm(raysCluster1Cluster2, 2, 2) / 3e8 + ...
             vecnorm(raysCluster2UE, 2, 2) / 3e8;

    if isLOS
        LOS_delay = norm(raysBSCluster1(1, :)) / 3e8 + ...
                    norm(raysCluster1Cluster2(1, :)) / 3e8 + ...
                    norm(raysCluster2UE(1, :)) / 3e8;
        delays = [LOS_delay; delays];
    end

    power = exp(-delays / mean(delays)); % Power weights
    mean_delay = mean(delays .* power);
    DS = sqrt(mean(delays.^2 .* power) - mean_delay^2);
end

%% Plot Delay Spreads
function plotDelaySpreads(DS_simulated_all, DS_theoretical_all, time_steps)
    figure;
    plot(1:time_steps, DS_simulated_all, 'r-', 'LineWidth', 1.5); hold on;
    plot(1:time_steps, DS_theoretical_all, 'b--', 'LineWidth', 1.5);
    xlabel('Time Step');
    ylabel('Delay Spread (seconds)');
    legend('Simulated DS', 'Theoretical DS');
    title('Delay Spread Over Time');
    grid on;
end

%% Plot Doppler Spectrum
function plotDopplerSpectrumTwinClusters(MPCs, fc, v_UE)
    doppler_shifts = MPCs(:, 6);
    c = 3e8; % Speed of light in m/s
    fD = fc * v_UE / c; % Maximum Doppler shift
    num_bins = 200;
    [counts, edges] = histcounts(doppler_shifts, num_bins, 'Normalization', 'pdf');
    centers = (edges(1:end-1) + edges(2:end)) / 2;

    f = linspace(-fD, fD, 1000);
    jakes_spectrum = (1 / (pi * fD)) ./ sqrt(1 - (f / fD).^2);
    jakes_spectrum(abs(f) > fD) = 0;

    figure;
    plot(centers, counts, 'r-', 'LineWidth', 1.5); hold on;
    plot(f, jakes_spectrum, 'b--', 'LineWidth', 1.5);
    xlabel('Doppler Frequency (Hz)');
    ylabel('Normalized Spectrum');
    legend('Simulated Spectrum', 'Jake''s Spectrum');
    title('Doppler Spectrum Comparison (Twin Clusters)');
    grid on;
end


