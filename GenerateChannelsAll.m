function MPCMatrix = GenerateChannelsAll(fc, timesteps, numScatterersTotal, numScattererBS, numBS, numUEperBS, xLim, yLim,...
                                    r_maxBS, vUE, dt, ringRadius, minDistToBS, maxDistToBS)
% fc = 3.5e9; % Carrier frequency in Hz
% timesteps = 75; % Number of time steps
% num_scatterers = 500; % Number of scatterers per cluster
% r_maxBS = 30; % Maximum distance from clusters to BS/UE in meters
% v_UE = 5; % UE velocity in m/s
% dt = 1; % Time step duration in seconds
% ringRadius = 30; % Radius of ring around BS/UE for cluster association
% % Target DS
% DS_theoretical = 50e-9; % Replace with a theoretical calculation if needed
% xLim, yLim, 2x1 vectors of limits for BS placement

% Random seed is set before calling this function

%%%%%% Place BSs and UEs %%%%%%%%%%

xMin = xLim(1);
xMax = xLim(2);
yMin = yLim(1);
yMax = yLim(2);

pBS_List = [xMin + (xMax - xMin) * rand(numBS, 1), yMin + (yMax - yMin) * rand(numBS, 1)];

theta = 2 * pi * rand(numBS, numUEperBS); % Uniform angles
% Add random r + whatever random variable within max and min dist
r = sqrt(rand(numBS, numUEperBS)) * (maxDistToBS - minDistToBS) + minDistToBS; % Uniform radii

% This is the positions of every UE for its BS
pUE_perBS(:,:,1) = pBS_List(:,1) + r .* cos(theta); 
pUE_perBS(:,:,2) = pBS_List(:,2) + r .* sin(theta);


%%%%%%% Generate MPCs for each time step for each UE for each BS %%%%%%%

scatterers = placeClusterIndep(mean([xLim;yLim],2),norm(xLim)*2, numScatterersTotal);

numUE = numBS*numUEperBS;
pUEall = reshape(pUE_perBS,[size(pUE_perBS,1)*size(pUE_perBS,2),2]);

% DS matrix
DS_simulated_all = zeros(numBS, numUE, timesteps);

% Random direction for each UE
directionAngle = 2*pi*rand(numUE,1);

% MPCMatrix: numBS x numUE x timesteps for storage of Lx6 MPCs matrix (for
% each MPC 6 params)
MPCMatrix = cell(numBS,numUE,timesteps);

% Main loop over time steps
disp('Computing MPCs:')

for t = 1:timesteps
    for iBS=1:numBS
        pBS = pBS_List(iBS,:);
        

        for iUE=1:numUE

            disp(['Timestep ',num2str(t),' BS: ',num2str(iBS),' UE: ',num2str(iUE)]);

            % Update UE position
            % Define UE movement direction (unit vector)                        
            v_UE_vec = vUE * [cos(directionAngle(iUE)), sin(directionAngle(iUE))];
            pUE = pUEall(iUE,:) + v_UE_vec * dt;

            % Place twin clusters
            % Initialize parameters for BS cluster
            offsetBS = sqrt(rand(1,1))*norm(pBS-pUE)/2;
            % thetaOffset = 2*pi*rand(1,1);
            theta1_rad = deg2rad(-15);
            theta2_rad = deg2rad(15);
            thetaOffset = theta1_rad + (theta2_rad - theta1_rad) * rand(1,1);
            offsetBSCoord = offsetBS*[cos(thetaOffset), sin(thetaOffset)];

            % Associate clusters to BS and UE
            % cluster1 = associateCluster(pBS, ringRadius, scatterers); % Near BS
            % This is for cluster CLOSE to BS not around BS, that is the case even for UMi
            cluster1 = placeClusterClose(pBS, offsetBSCoord, r_maxBS, numScattererBS); % Near BS
            cluster2 = associateCluster(pUE, ringRadius, scatterers); % Near UE
            
            %%%%%%%%% Plot %%%%%%%%%%%%%%%
            % figure;
            % scatter(scatterers(:,1), scatterers(:,2), 5, 'm', 'filled', 'DisplayName', 'Scatterers');
            % hold on;
            % scatter(cluster1(:, 1), cluster1(:, 2), 5, 'k', 'filled', 'DisplayName', 'Cluster 1 (BS)');
            % scatter(cluster2(:, 1), cluster2(:, 2), 5, 'g', 'filled', 'DisplayName', 'Cluster 2 (UE)');
            % legend;
            % plot(pBS_List(:,1),pBS_List(:,2),'r^', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'BS'); hold on;
            % xAll = squeeze(pUE_perBS(:,:,1));
            % yAll = squeeze(pUE_perBS(:,:,2));
            % xAll = xAll(:);
            % yAll = yAll(:);
            % plot(xAll,yAll,'bo', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'UE');
            % 
            % xlabel('X Position (m)');
            % ylabel('Y Position (m)');
            %%%%%%%%% End Plot %%%%%%%%%%%%%%

            % Launch rays through twin clusters
            [raysBSCluster1, distCluster1Cluster2, raysCluster2UE, isLOS] = ...
                launchTwinClusterRays2(pBS, pUE, cluster1, cluster2);

            % Compute MPCs
            MPCs = computeTwinClusterMPCs2(pUE, pBS, cluster1, cluster2, ...
                raysBSCluster1, distCluster1Cluster2, raysCluster2UE, ...
                isLOS, v_UE_vec / norm(v_UE_vec), vUE, fc);
            MPCMatrix{iBS, iUE, t} = MPCs;

            % Calculate simulated delay spread
            DS_simulated = calculateDelaySpread2(MPCs(:,3), abs(MPCs(:,1)).^2); %calculateDelaySpread2(raysBSCluster1, raysCluster1Cluster2, raysCluster2UE, isLOS);
            DS_simulated_all(iBS, iUE, t) = DS_simulated;
        end
    end

    % plotDelayDomain(MPCs, t);

end


end