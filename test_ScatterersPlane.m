clc; clear; close all;

addpath /Users/tathagat/Desktop/Fall2024/EE635/project/ee635-project/Group1/Twin-Clusters

% Parameters for visualization
posUE = [-50, -50];
posBS = [100, 0];
directionAngle = pi / 4;

% Initialize UE and BS positions
v_UE = 5; % UE velocity in m/s (not used in visualization but part of initialization)
[pUE, pBS, v_UE_vec] = initializeUEandBS(posUE, posBS, directionAngle, v_UE);

% Scatterer parameters
n_scatterersPlane = 100000; % Number of scatterers
r_maxPlane = 300;           % Maximum radius for scatterers

% Generate scatterers around BS
scatterers = placeClusterIndep(pBS, r_maxPlane, n_scatterersPlane);

% Visualization
figure;
hold on;
scatter(scatterers(:, 1), scatterers(:, 2), 1, 'm', 'filled', 'MarkerFaceAlpha', 0.6);
plot(pBS(1), pBS(2), 'bs', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'BS'); hold on;
plot(pUE(1), pUE(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'UE');
axis equal;
xlim([pBS(1) - r_maxPlane - 50, pBS(1) + r_maxPlane + 50]);
ylim([pBS(2) - r_maxPlane - 50, pBS(2) + r_maxPlane + 50]);
title('Scatterer Distribution Around BS');
xlabel('X Coordinate (m)');
ylabel('Y Coordinate (m)');
legend('Scatterers', 'Base Station (BS)', 'User Equipment (UE)');
grid on;