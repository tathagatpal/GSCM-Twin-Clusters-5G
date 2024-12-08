function P_theoretical = P_th(U,W,F, r)
% Computes P_LOS theoretical according to modified 3gpp equation
% Input: U: cutoff parameter
%        W: exponentaial decay parameter
%        F: scaling parameter
%        r: distance values at which to compute the probability

P_theoretical = zeros(length(r),1);     % Initialize

%%%%%%%%%% Equation 7 & 24 %%%%%%%%%%
for i=1:length(r)   % Loop over r points
    if r(i)<=U      % For points less than cutoff distance: PLOS=1
        P_theoretical(i) = 1;
    else            % For points > cutoff distance: use modified 3GPP Equation
        P_theoretical(i) = F.*((U./r(i)).*(1-exp(-r(i)./W)) + exp(-r(i)./W));
%         P_theoretical(i) = F*((U/r(i))+(exp(-r(i)/W))*(1-U/r(i)));
    end
end
end



% function P_theoretical = P_th(U,W,F, r)
% % Computes P_LOS theoretical according to modified 3gpp equation
% % Input: U: cutoff parameter
% %        W: exponentaial decay parameter
% %        F: scaling parameter
% %        r: distance values at which to compute the probability
% 
% P_theoretical = zeros(length(r),1);     % Initialize
% 
% %%%%%%%%%% Equation 7 & 24 %%%%%%%%%%
% for i=1:length(r)   % Loop over r points
%     if r(i)<=U      % For points less than cutoff distance: PLOS=1
%         P_theoretical(i) = 1;
%     else            % For points > cutoff distance: use modified 3GPP Equation
%         P_theoretical(i) = F*((U/r(i))*(1-exp(-r(i)/W)) + exp(-r(i)/W));
% %         P_theoretical(i) = F*((U/r(i))+(exp(-r(i)/W))*(1-U/r(i)));
%     end
% end
% end