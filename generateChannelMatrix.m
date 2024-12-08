%% Generate Channel Matrix
function H = generateChannelMatrix(MPCs, BW, sf)
    % Generate the Channel Matrix (frequency-domain representation)
    num_subcarriers = round(BW / sf);
    amplitudes = MPCs(:, 1); % MPC amplitudes
    phases = MPCs(:, 2);     % MPC phases
    delays = MPCs(:, 3);     % MPC delays
    H = zeros(num_subcarriers, 1);
    for k = 1:num_subcarriers
        fk = (k - 1) * sf; % Subcarrier frequency
        H(k) = sum(amplitudes .* exp(-1j * 2 * pi * fk * delays + 1j * phases));
    end
end
