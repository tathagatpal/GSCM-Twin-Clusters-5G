%% Plot Twin Clusters
function plotTwinClusterPositions(pBS, pUE, cluster1, cluster2, t)
    % Plot positions of BS, UE, and twin clusters
    figure(1); clf;
    plot(pBS(1), pBS(2), 'bs', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'BS'); hold on;
    plot(pUE(1), pUE(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'UE');
    scatter(cluster1(:, 1), cluster1(:, 2), 5, 'k', 'filled', 'DisplayName', 'Cluster 1 (BS)');
    scatter(cluster2(:, 1), cluster2(:, 2), 5, 'g', 'filled', 'DisplayName', 'Cluster 2 (UE)');
    legend;
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    title(['Twin Clusters at Time Step ', num2str(t)]);
    axis equal;
    axis([-300 300 -300 300]); % Adjust as necessary
    grid on;
    drawnow;
end
