%% Cluster Position
function cluster = placeClusterIndep(center, r_max, num_scatterers)
    % Place scatterers in the plane, limited by a circle that encompasses
    % all BSs and UEs
    theta = 2 * pi * rand(num_scatterers, 1); % Uniform angles
    r = sqrt(rand(num_scatterers, 1)) * (r_max); % Uniform radii
    cluster = [center(1) + r .* cos(theta), center(2) + r .* sin(theta)];
end
