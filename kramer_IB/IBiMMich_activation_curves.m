function [m_inf, tau_m] = IBiMMich_activation_curves(X)

c_MaM = 1;
c_MbM = 1;
Qs = 3.209^2;

aM = c_MaM.*(0.0001*Qs*(X+35)) ./ (1-exp(-(X+35)/10));
bM = c_MbM.*(-0.0001*Qs*(X+35)) ./ (1-exp((X+35)/10));
m_inf = aM./(aM + bM);
tau_m = 1./(aM + bM);