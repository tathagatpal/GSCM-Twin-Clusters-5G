clc; clear; close all;

addpath /Users/tathagat/Desktop/Fall2024/EE635/project/ee635-project/Group1/Twin-Clusters


% Parameters
% rng(42); % Random seed for reproducibility
posUE = [-50, -50];
posBS = [100, 0];
directionAngle = pi / 4;
v_UE = 5; % UE velocity in m/s
dt = 1; % Time step duration in seconds
time_steps = 75; % Number of time steps
num_scatterers = 100; % Scatterers per cluster
r_maxBS = 30; % Max distance from BS
ringRadius = 30; % Radius of ring for cluster association
r_maxPlane = 300; % Max distance for scatterers in the plane
n_scatterersPlane = 100000; % Number of scatterers in the plane

% Initialize UE and BS positions
[pUE, pBS, v_UE_vec] = initializeUEandBS(posUE, posBS, directionAngle, v_UE);

% Generate scatterers across the plane
scatterers = placeClusterIndep(pBS, r_maxPlane, n_scatterersPlane);

% Simulation for a single time step
t = 1; % Example time step
pUE = pUE + v_UE_vec * dt * t; % Update UE position

% Place cluster near BS
dirUEtoBS = (pUE - pBS) / norm(pBS - pUE);
offsetBS = sqrt(rand) * norm(pBS - pUE) / 2;
theta1_rad = deg2rad(-15);
theta2_rad = deg2rad(15);
thetaOffset = theta1_rad + (theta2_rad - theta1_rad) * rand;
offsetBSCoord = offsetBS * [cos(thetaOffset), sin(thetaOffset)];
cluster1 = placeClusterClose(pBS, offsetBSCoord, r_maxBS, num_scatterers);

% Associate cluster near UE
cluster2 = associateCluster(pUE, ringRadius, scatterers);

% Visualization
figure;

% Scatterers across the plane
scatter(scatterers(:, 1), scatterers(:, 2), 1, 'm', 'filled', 'MarkerFaceAlpha', 0.6);
hold on;
plot(pBS(1), pBS(2), 'bs', 'MarkerSize', 10, 'LineWidth', 2); % BS position
plot(pUE(1), pUE(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % UE position
scatter(cluster1(:, 1), cluster1(:, 2), 10, 'green', 'filled'); % Cluster near BS
scatter(cluster2(:, 1), cluster2(:, 2), 10, 'cyan', 'filled', 'MarkerFaceAlpha', 0.1); % Cluster near UE
title('Scatterers and Clusters Near UE and BS');
xlabel('X Coordinate (m)');
ylabel('Y Coordinate (m)');
legend('Scatterers', 'BS Position', 'UE Position', 'Cluster Near BS', 'Cluster Near UE');
axis equal;
grid on;
