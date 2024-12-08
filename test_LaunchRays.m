clc; clear; close all;

addpath /Users/tathagat/Desktop/Fall2024/EE635/project/ee635-project/Group1/Twin-Clusters

% Parameters
posBS = [70,85];
posUE = [200,300];
num_scatterers = 50; % Reduced for visualization clarity
r_maxBS = 30; % Maximum radius for cluster near BS
ringRadius = 30; % Radius for cluster near UE

% Generate clusters
rng(42); % Random seed for reproducibility
offsetBS = [10, 10]; % Example offset for BS cluster
offsetUE = [5, 5]; % Example offset for UE cluster
cluster1 = placeClusterClose(posBS, offsetBS, r_maxBS, num_scatterers); % Near BS
scatterers = placeClusterIndep(posBS, 300, 10000); % Large scatterer pool
cluster2 = associateCluster(posUE, ringRadius, scatterers); % Near UE

% Launch rays
[raysBSCluster1, distCluster1Cluster2, raysCluster2UE, isLOS] = ...
    launchTwinClusterRays2(posBS, posUE, cluster1, cluster2);

% Visualization
figure;
hold on;

% Plot BS and UE
plot(posBS(1), posBS(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % BS position
plot(posUE(1), posUE(2), 'go', 'MarkerSize', 10, 'LineWidth', 2); % UE position

% Plot clusters
scatter(cluster1(:, 1), cluster1(:, 2), 20, 'b', 'filled'); % Cluster 1
scatter(cluster2(:, 1), cluster2(:, 2), 20, 'm', 'filled'); % Cluster 2

% Plot rays (select a few for clarity)
num_rays_to_plot = 10;
for i = 1:num_rays_to_plot
    % Ray from BS to Cluster 1
    plot([posBS(1), cluster1(i, 1)], [posBS(2), cluster1(i, 2)], 'b');
    % Ray from Cluster 1 to Cluster 2
    plot([cluster1(i, 1), cluster2(i, 1)], [cluster1(i, 2), cluster2(i, 2)], 'g');
    % Ray from Cluster 2 to UE
    plot([cluster2(i, 1), posUE(1)], [cluster2(i, 2), posUE(2)], 'm');
end

% Display LOS information
if isLOS
    plot([posBS(1), posUE(1)], [posBS(2), posUE(2)], 'k', 'LineWidth', 1.5); % LOS path
    legend('Base Station (BS)', 'User Equipment (UE)', 'Cluster 1', 'Cluster 2', ...
        'Rays (BS → Cluster 1)', 'Rays (Cluster 1 → Cluster 2)', ...
        'Rays (Cluster 2 → UE)', 'LOS Path');
else
    legend('Base Station (BS)', 'User Equipment (UE)', 'Cluster 1', 'Cluster 2', ...
        'Rays (BS → Cluster 1)', 'Rays (Cluster 1 → Cluster 2)', ...
        'Rays (Cluster 2 → UE)');
end

title('Visualization of Launching Rays');
xlabel('X Coordinate (m)');
ylabel('Y Coordinate (m)');
axis equal;
grid on;
hold off;