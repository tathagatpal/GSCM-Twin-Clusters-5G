function visualizeDelayDomain(H, BW, sf)
    % Delay Domain Representation
    PDP = ifft(H); % Inverse FFT to transform to delay domain
    time_axis = linspace(0, 1 / sf, length(H)); % Delay axis in seconds
    figure;
    plot(time_axis, abs(PDP), 'k-', 'LineWidth', 1.5);
    xlabel('Delay (s)');
    ylabel('Power');
    title('Power Delay Profile (PDP)');
    grid on;
end
