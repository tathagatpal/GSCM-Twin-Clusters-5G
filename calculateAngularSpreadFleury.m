%% Calculate Delay Spread
function AS = calculateAngularSpreadFleury(az, powers)
    dPhi = az(2) - az(1);
    PPhi = sum(powers.*dPhi);
    muPhi = sum(exp(1j*az).*powers.*dPhi)/PPhi;
    
    AS = sqrt( (sum( (abs( exp(1j.*az) - muPhi ).^2).*powers.*dPhi ))./PPhi );

    % power = exp(-delays / mean(delays)); % Power weights
    % mean_delay = mean(delays .* power);
    % DS = sqrt(mean(delays.^2 .* power) - mean_delay^2);
end
