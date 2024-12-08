function DS_theoretical = calculateTheoreticalDS(PLOS, PNLOS, fc)
    % Function to calculate the theoretical delay spread (DS)
    % Inputs:
    %   PLOS: Probability of LOS
    %   PNLOS: Probability of NLOS
    %   fc: Carrier frequency in GHz
    % Output:
    %   DS_theoretical: Combined theoretical delay spread in seconds

    % Convert carrier frequency to GHz
    logTerm = log10(1 + fc);

    % LOS Delay Spread
    mu_lgDS_LOS = -0.24 * logTerm - 7.14; % UMi LOS Formula
    DS_LOS = 10^(mu_lgDS_LOS); % Convert to seconds

    % NLOS Delay Spread
    mu_lgDS_NLOS = -0.24 * logTerm - 6.83; % UMi NLOS Formula
    DS_NLOS = 10^(mu_lgDS_NLOS); % Convert to seconds

    % Combine LOS and NLOS Delay Spreads
    % DS_theoretical = PLOS * DS_LOS + PNLOS * DS_NLOS;
    % DS_theoretical = DS_NLOS;
    DS_theoretical = DS_LOS;

end
