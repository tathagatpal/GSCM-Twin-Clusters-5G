%% Compute MPCs for Twin-Clusters

function MPCs = computeTwinClusterMPCs2(pUE, pBS, cluster1, cluster2, ...
                                       raysBSCluster1, distCluster1Cluster2, raysCluster2UE, ...
                                       isLOS, v_unit, v_mag, fc)
    % Compute Multipath Components (MPCs) for twin clusters
    % v_unit: Unit velocity vector of the UE direction
    % v_mag: Magnitude of the UE velocity
    % fc: Carrier frequency
    
    % Number of scatterers in each cluster
    numPathsCluster1 = size(cluster1, 1);
    numPathsCluster2 = size(cluster2, 1);
    numPaths = min(numPathsCluster1, numPathsCluster2) + double(isLOS); %numPathsCluster1 + numPathsCluster2 + double(isLOS); % Total paths (LOS included)
    
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
    for i = 1:min(numPathsCluster1,numPathsCluster2)
        % Cluster 1 path
        rayBSCluster1 = raysBSCluster1(i, :);
        distCluster = distCluster1Cluster2(i, :);
        rayCluster2UE = raysCluster2UE(i, :);
        
        % Total delay
        delay = norm(rayBSCluster1) / 3e8 + ...
                distCluster / 3e8 + ...
                norm(rayCluster2UE) / 3e8;
        
        % Path Loss for this path
        total_distance = norm(rayBSCluster1) + distCluster + norm(rayCluster2UE);
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

    % Must enforce a exponential decay of PDP --> Multiply amplitude by
    % e^-tau/T (where T is decay constant (RMS spread?))
    DS = calculateDelaySpread2(MPCs(:,3), abs(MPCs(:,1)).^2);
    amplitudeNew = MPCs(:,1).*exp(-MPCs(:,3)./DS);

    MPCs(:,1) = amplitudeNew;
end