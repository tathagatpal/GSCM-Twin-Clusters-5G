%% Path Loss
function PL = calculatePathLoss(d, fc, isLOS)
    % Calculate Path Loss (PL) based on LOS or NLOS
    hBSprime = 10 - 1;    % Effective height of BS
    hUEprime = 1.5 - 1;   % Effective height of UE
    d_break = 4 * hBSprime * hUEprime * fc / 3e8; % Breakpoint distance

    if isLOS
        % LOS Path Loss
        if d <= d_break
            PL = 32.4 + 21 * log10(d) + 20 * log10(fc);
        else
            PL = 32.4 + 40 * log10(d) + 20 * log10(fc) - ...
                 9.5 * log10(d_break^2 + (10 - 1.5)^2);
        end
    else
        % NLOS Path Loss
        if d <= d_break
            PL_LOS = 32.4 + 21*log10(d) + 20*log10(fc);
        else
            PL_LOS = 32.4 + 40*log10(d) + 20*log10(fc) - 9.5*log10(d_break^2+ (10-1.5)^2);
        end
        PL_NLOS = 35.3*log10(d) + 22.4 + 21.3*log10(fc) - 0.3*(1.5-1.5);

        PL = max(PL_NLOS, PL_LOS);

        % PL_LOS = 32.4 + 21 * log10(distance) + 20 * log10(fc);
        % PL_NLOS = 35.3 * log10(distance) + 22.4 + 21.3 * log10(fc) - ...
        %           0.3 * (1.5 - 1.5);
        % PL = max(PL_LOS, PL_NLOS); % Choose the worst path loss
    end
end

