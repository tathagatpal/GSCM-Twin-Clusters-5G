%% Cluster Rays Function
function [raysBSCluster1, distCluster1Cluster2, raysCluster2UE, isLOS] = ...
         launchTwinClusterRays2(pBS, pUE, cluster1, cluster2)
    % Generate rays for twin clusters
    raysBSCluster1 = cluster1 - pBS; % BS → Cluster 1

    % Instead of mean distance, use max distance as the average of the exp
    % RV for delay
    % Find pairwise distances between clusters and find maximum distance
    pairwiseDist = pdist2(cluster1, cluster2);
    distMax = max(pairwiseDist(:));
    % raysCluster1Cluster2 = cluster2 - cluster1; % Cluster 1 → Cluster 2

    % distMean = sqrt(sum(raysCluster1Cluster2.^2,2));
    % distMean = mean(distMean);

    Nrays = min(size(cluster2,1),size(cluster1,1));
    distCluster1Cluster2 = distMax + exprnd(distMax/3e8,Nrays,1)*3e8;
    raysCluster2UE = pUE - cluster2; % Cluster 2 → UE
    
    % LOS Probability (Example)
    distLOS = norm(pUE - pBS); % LOS distance
    PLOS = P_th(18, 36, 1, distLOS); % Calculate LOS probability
    isLOS = rand <= PLOS; % Random draw to determine LOS
end
