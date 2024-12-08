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
