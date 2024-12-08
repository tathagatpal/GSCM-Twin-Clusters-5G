%% Plot Doppler Spectrum
% function plotDopplerSpectrumTwinClusters(MPCs, fc, v_UE, isLOS)
%     % Exclude LOS if present
%     if isLOS
%         doppler_shifts = MPCs(2:end, 6); % Exclude LOS Doppler
%     else
%         doppler_shifts = MPCs(:, 6); % Use all Doppler shifts
%     end
% 
%     c = 3e8; % Speed of light in m/s
%     fD = fc * v_UE / c; % Maximum Doppler shift
%     num_bins = 1000;
%     [counts, edges] = histcounts(doppler_shifts, num_bins, 'Normalization', 'pdf');
%     centers = (edges(1:end-1) + edges(2:end)) / 2;
% 
%     f = linspace(-fD, fD, 1000);
%     jakes_spectrum = (1 / (pi * fD)) ./ sqrt(1 - (f / fD).^2);
%     jakes_spectrum(abs(f) > fD) = 0;
% 
%     figure;
%     plot(centers, counts, 'r-', 'LineWidth', 1.5); hold on;
%     plot(f, jakes_spectrum, 'b--', 'LineWidth', 1.5);
%     xlabel('Doppler Frequency (Hz)');
%     ylabel('Normalized Spectrum');
%     legend('Simulated Spectrum', 'Jake''s Spectrum');
%     title('Doppler Spectrum Comparison (Twin Clusters)');
%     grid on;
% end

function plotDopplerSpectrumTwinClusters(MPCs, fc, v_UE, isLOS)
    % Filter Doppler shifts
    threshold = 1e-3; % Threshold to filter small Doppler shifts
    doppler_shifts = MPCs(:, 6);
    doppler_shifts = doppler_shifts(abs(doppler_shifts) > threshold); % Remove near-zero Doppler shifts
    
    % Maximum Doppler shift
    c = 3e8; % Speed of light in m/s
    fD = fc * v_UE / c; % Maximum Doppler shift
    
    % Histogram of Doppler shifts
    num_bins = 300;
    [counts, edges] = histcounts(doppler_shifts, num_bins, 'Normalization', 'pdf');
    centers = (edges(1:end-1) + edges(2:end)) / 2;
    
    % Theoretical Jakes Spectrum
    f = linspace(-fD, fD, 1000);
    jakes_spectrum = (1 / (pi * fD)) ./ sqrt(1 - (f / fD).^2);
    jakes_spectrum(abs(f) > fD) = 0;
    
    % Plot the Doppler Spectrum
    figure;
    plot(centers, counts, 'r-', 'LineWidth', 1.5); % Simulated spectrum
    hold on;
    plot(f, jakes_spectrum, 'b--', 'LineWidth', 1.5); % Jakes spectrum
    xlabel('Doppler Frequency (Hz)');
    ylabel('Normalized Spectrum');
    legend('Filtered Spectrum', 'Jake''s Spectrum');
    title('Filtered Doppler Spectrum Comparison');
    grid on;
end



% function plotDopplerSpectrumTwinClusters(MPCs, fc, v_UE, isLOS)
%     % Extract Doppler shifts from MPCs
%     doppler_shifts = MPCs(:, 6); % Include all Doppler shifts
% 
%     % Remove LOS Doppler shift if LOS is present
%     if isLOS
%         doppler_shifts = doppler_shifts(2:end); % Exclude LOS component
%     end
% 
%     % Normalize Doppler shifts
%     doppler_shifts = doppler_shifts / max(abs(doppler_shifts));
% 
%     % Maximum Doppler shift
%     c = 3e8; % Speed of light in m/s
%     fD = fc * v_UE / c; % Maximum Doppler shift
% 
%     % Histogram of simulated Doppler shifts
%     num_bins = 500; % Higher resolution
%     [counts, edges] = histcounts(doppler_shifts, num_bins, 'Normalization', 'pdf');
%     centers = (edges(1:end-1) + edges(2:end)) / 2; % Compute bin centers
% 
%     % Normalize histogram
%     counts = counts / max(counts);
% 
%     % Theoretical Jakes Spectrum
%     f = linspace(-fD, fD, 1000); % Doppler frequency range
%     jakes_spectrum = (1 / (pi * fD)) ./ sqrt(1 - (f / fD).^2); % Jakes formula
%     jakes_spectrum(abs(f) > fD) = 0; % Remove undefined values outside [-fD, fD]
%     jakes_spectrum = jakes_spectrum / max(jakes_spectrum); % Normalize Jakes spectrum
% 
%     figure;
%     histogram(doppler_shifts, num_bins, 'Normalization', 'pdf');
%     title('Raw Doppler Shifts');
%     xlabel('Doppler Frequency (Hz)');
%     ylabel('Density');
%     grid on;
% 
%     % Plot the Doppler Spectrum
%     figure;
%     plot(centers, counts, 'r-', 'LineWidth', 1.5); % Simulated Doppler spectrum
%     hold on;
%     plot(f, jakes_spectrum, 'b--', 'LineWidth', 1.5); % Theoretical Jakes spectrum
%     xlabel('Doppler Frequency (Hz)');
%     ylabel('Normalized Spectrum');
%     legend('Simulated Spectrum', 'Theoretical Jakes Spectrum');
%     title('Doppler Spectrum Comparison (Twin Clusters)');
%     grid on;
% end
