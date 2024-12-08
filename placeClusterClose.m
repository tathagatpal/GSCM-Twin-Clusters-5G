%% Cluster Position
function cluster = placeClusterClose(center, offset, r_max, num_scatterers)
    % Now add offset to center to make cluster close and there is no need for r_min now, 
    % Place scatterers in a circular region around a given center
    % offset is now what determines the final delay spread along with the
    % choice of the distribution of the delays between clusters. Both must
    % be chosen such that we obtain on average a delay spread equal to the
    % mean of the DS in the standard in UMi scenarios
    theta = 2 * pi * rand(num_scatterers, 1); % Uniform angles
    r = sqrt(rand(num_scatterers, 1)) * (r_max); % Uniform radii
    cluster = [center(1)+offset(1) + r .* cos(theta), center(2)+offset(2) + r .* sin(theta)];
end
