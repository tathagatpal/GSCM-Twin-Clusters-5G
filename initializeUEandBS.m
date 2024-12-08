%% Initialize UE and BS
function [pUE, pBS, v_UE_vec] = initializeUEandBS(posUE, posBS, directionAngle, v_UE)
    % Initialize positions of UE and BS
    pUE = posUE; %[-50, -50]; % UE position at origin
    pBS = posBS; %[150, 0]; % BS position at (150, 0)

    % Define UE movement direction (unit vector)
    direction_angle = directionAngle; %pi / 4; % 45 degrees (example direction)
    v_UE_vec = v_UE * [cos(direction_angle), sin(direction_angle)];
end
