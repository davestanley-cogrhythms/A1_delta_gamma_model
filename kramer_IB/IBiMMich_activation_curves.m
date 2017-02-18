function [m_inf, tau_m] = IBiMMich_activation_curves(X)

c_MaM = 1; % .625; % .69; % 
c_MbM = 1; %  2.75; % 3; %
Qs = 3.209; % 3.209^2; %
halfMM = -35; % -50; % -47; %
MM_denom = 9; % 10;

aM = c_MaM.*(0.0001*Qs*(X-halfMM)) ./ (1-exp(-(X-halfMM)/MM_denom));
bM = c_MbM.*(-0.0001*Qs*(X-halfMM)) ./ (1-exp((X-halfMM)/MM_denom));
m_inf = aM./(aM + bM);
tau_m = 1./(aM + bM);