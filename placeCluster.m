%% Cluster Position
function cluster = placeCluster(center, r_min, r_max, num_scatterers)
    % Place scatterers in a circular region around a given center
    theta = 2 * pi * rand(num_scatterers, 1); % Uniform angles
    r = sqrt(rand(num_scatterers, 1)) * (r_max - r_min) + r_min; % Uniform radii
    cluster = [center(1) + r .* cos(theta), center(2) + r .* sin(theta)];
end
