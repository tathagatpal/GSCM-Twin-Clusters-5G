%%%%%% Test Generate Channel All UEs to All BSs %%%%%%%%%%%

% Parameters
rng(42); % Random seed for reproducibility
fc = 3.5e9; % Carrier frequency in Hz
timesteps = 15; % Number of time steps
numScatterersTotal = 1e5; % Number of scatterers per cluster
numScattererBS = 50;
r_maxBS = 30; % Maximum distance from clusters to BS/UE in meters
vUE = 5; % UE velocity in m/s
dt = 1; % Time step duration in seconds
ringRadius = 30; % Radius of ring around BS/UE for cluster association
minDistToBS = 15; % Minimum distance of UE to BS
maxDistToBS = 150; % Maximum distance of UE to BS

numBS = 5;
numUEperBS = 10;
xLim = [-500,500];
yLim = [-500, 500];

MPCMatrix = GenerateChannelsAll(fc, timesteps, numScatterersTotal, numScattererBS, numBS, numUEperBS, xLim, yLim,...
                                    r_maxBS, vUE, dt, ringRadius, minDistToBS, maxDistToBS);

% 
% for iBS=1:size(MPCMatrix,1)
%     for iUE = 1:size(MPCMatrix,2)
%         for t=1:timesteps
%             DSns(iBS, iUE, t) = real(calculateDelaySpread2(MPCMatrix{iBS,iUE,t}(:,3), abs(MPCMatrix{iBS,iUE,t}(:,1)).^2))/1e-9;
%         end        
%     end
% end
% 
% for t=1:timesteps
%     figure; histogram(unroll(DSns(:,:,t)))
% end