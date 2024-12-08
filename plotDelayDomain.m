function plotDelayDomain(MPCs, t)
figure(1); clf;
stem(MPCs(:,3),MPCs(:,1),'x');
grid minor;
legend('MPC amplitude');
xlabel('Delay (s)');
ylabel('Amplitude');
title(['MPCs amplitude at time step ', num2str(t)]);
end