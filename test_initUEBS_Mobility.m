clc; clear; close all;

addpath /Users/tathagat/Desktop/Fall2024/EE635/project/ee635-project/Group1/Twin-Clusters

% Parameters
posUE = [-50, -50];
posBS = [100, 0];
directionAngle = pi / 4; % 45 degrees
v_UE = 5; % UE velocity in m/s
time_steps = 75;
dt = 1;

% Initialize UE and BS
[pUE, pBS, v_UE_vec] = initializeUEandBS(posUE, posBS, directionAngle, v_UE);

% Store UE positions over time for visualization
positions = zeros(time_steps, 2);
positions(1, :) = pUE;

% Mobility simulation
for t = 2:time_steps
    pUE = pUE + v_UE_vec * dt;
    positions(t, :) = pUE;
end

% Select specific time steps for visualization
time_plot = [1, round(time_steps / 3), round(2 * time_steps / 3), time_steps];

% Visualization
figure;
for i = 1:4
    subplot(2, 2, i);
    scatter(positions(1:time_plot(i), 1), positions(1:time_plot(i), 2), 'b', 'filled'); % UE trajectory
    hold on;
    plot(pBS(1), pBS(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % BS position
    plot(positions(time_plot(i), 1), positions(time_plot(i), 2), 'go', 'MarkerSize', 8, 'LineWidth', 2); % Current UE position
    hold off;
    axis equal;
    xlim([-300, 300]);
    ylim([-300, 300]);
    title(['Time Step: ', num2str(time_plot(i))]);
    xlabel('X Coordinate (m)');
    ylabel('Y Coordinate (m)');
    legend('UE Trajectory', 'Base Station (BS)', 'Current UE Position');
    grid on;
end

sgtitle('UE Mobility Over Time');
