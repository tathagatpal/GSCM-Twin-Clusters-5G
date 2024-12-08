clc; clear; %close all;


% Parameters
rng(42); % Random seed for reproducibility
fc = 3.5e9; % Carrier frequency in Hz
BW = 90e6; % Bandwidth in Hz
sf = 15e3; % Subcarrier spacing in Hz
time_steps = 75; % Number of time steps
num_scatterers = 500; % Number of scatterers per cluster
r_min = 10; % Minimum distance from clusters to BS/UE in meters
r_max = 20; % Maximum distance from clusters to BS/UE in meters
v_UE = 5; % UE velocity in m/s
dt = 1; % Time step duration in seconds

% Initialize UE and BS positions
posUE = [-50,-50];
posBS = [200,0]; 
directionAngle = pi/4;

[pUE, pBS, v_UE_vec] = initializeUEandBS(posUE, posBS, directionAngle, v_UE);

% Main loop over time steps
DS_simulated_all = zeros(time_steps, 1);
DS_theoretical_all = zeros(time_steps, 1);

for t = 1:time_steps
    % Update UE position
    pUE = pUE + v_UE_vec * dt;

    % Place twin clusters
    % Place clusters in direction of BS to UE
    dirUEtoBS = (pUE-pBS)/norm(pBS-pUE);
    offsetBS = sqrt(rand(1,1))*norm(pBS-pUE)/10;
    thetaOffset = 2*pi*rand(1,1);
    offsetBSCoord = offsetBS*[cos(thetaOffset), sin(thetaOffset)];
    
    dirBStoUE = (pBS-pUE)/norm(pBS-pUE);
    offsetUE = sqrt(rand(1,1))*norm(pBS-pUE)/10;
    thetaOffset = 2*pi*rand(1,1);
    offsetUECoord = offsetUE*[cos(thetaOffset), sin(thetaOffset)];

    cluster1 = placeClusterClose(pBS, offsetBSCoord, r_max, num_scatterers); % Near BS
    cluster2 = placeClusterClose(pUE, offsetUECoord, r_max, num_scatterers); % Near UE

    % Launch rays through twin clusters
    [raysBSCluster1, distCluster1Cluster2, raysCluster2UE, isLOS] = ...
        launchTwinClusterRays2(pBS, pUE, cluster1, cluster2);

    % Compute MPCs
    MPCs = computeTwinClusterMPCs2(pUE, pBS, cluster1, cluster2, ...
                                   raysBSCluster1, distCluster1Cluster2, raysCluster2UE, ...
                                   isLOS, v_UE_vec / norm(v_UE_vec), v_UE, fc);
    % total_power = sum(MPCs(:, 1).^2); % Total power of all paths
    % MPCs(:, 1) = MPCs(:, 1) / sqrt(total_power); % Normalize amplitudes

    % Calculate simulated delay spread
    DS_simulated = calculateDelaySpread2(MPCs(:,3), abs(MPCs(:,1)).^2); %calculateDelaySpread2(raysBSCluster1, raysCluster1Cluster2, raysCluster2UE, isLOS);
    DS_simulated_all(t) = DS_simulated;

    % Calculate theoretical delay spread (example formula)
    DS_theoretical = 50e-9; % Replace with a theoretical calculation if needed
    DS_theoretical_all(t) = DS_theoretical;

    % Print progress
    fprintf('Time Step: %d, Simulated DS: %.2e, Theoretical DS: %.2e\n', t, DS_simulated, DS_theoretical);

    plotTwinClusterPositions(pBS, pUE, cluster1, cluster2, t);

end

% Generate channel matrix
H = generateChannelMatrix(MPCs, BW, sf);

% Plot delay spreads over time
plotDelaySpreads(DS_simulated_all, DS_theoretical_all, time_steps);

% Plot Doppler Spectrum
plotDopplerSpectrumTwinClusters(MPCs, fc, v_UE, isLOS);

% visualizeDelayDomain(H, BW, sf);

disp('Simulation completed.');
