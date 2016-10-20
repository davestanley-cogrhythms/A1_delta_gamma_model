function [m_inf, tau_m] = IBiMMich_activation_curves(X)

c_MaM = .625;
c_MbM = 2.75;
Qs = 3.209^2;
halfMM = -50;

aM = c_MaM.*(0.0001*Qs*(X-halfMM)) ./ (1-exp(-(X-halfMM)/10));
bM = c_MbM.*(-0.0001*Qs*(X-halfMM)) ./ (1-exp((X-halfMM)/10));
m_inf = aM./(aM + bM);
tau_m = 1./(aM + bM);