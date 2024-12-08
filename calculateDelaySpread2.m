%% Calculate Delay Spread
function DS = calculateDelaySpread2(delays, powers)
    Pm = sum(powers);
    Tm = sum(powers.*delays)/Pm;
    DS = sqrt( (sum(powers.*(delays.^2))/Pm) -Tm^2);
    % 
    % power = exp(-delays / mean(delays)); % Power weights
    % mean_delay = mean(delays .* power);
    % DS = sqrt(mean(delays.^2 .* power) - mean_delay^2);
end