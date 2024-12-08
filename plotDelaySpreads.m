%% Plot Delay Spreads
function plotDelaySpreads(DS_simulated_all, DS_theoretical_all, time_steps)
    figure;
    plot(1:time_steps, DS_simulated_all, 'r-', 'LineWidth', 1.5); hold on;
    plot(1:time_steps, DS_theoretical_all, 'b--', 'LineWidth', 1.5);
    plot(1:time_steps, mean(DS_simulated_all)*ones(size(1:time_steps)),'g--','LineWidth',1.5);
    xlabel('Time Step');
    ylabel('Delay Spread (s)');
    legend('Simulated DS', 'Theoretical DS','Average DS');
    title('Delay Spread Over Time');
    grid on;
end
