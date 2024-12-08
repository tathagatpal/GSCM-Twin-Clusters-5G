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
