
%% Plot curves of h-current

V = -120:0;

AR_V12 = [-87.5]
AR_k = [-5.5]
gAR = [115]
E_AR = [-25]
c_ARaM = [3]
c_ARbM = [3]
AR_L = [1]
AR_R = [1]
IC = [0]
IC_noise = [0.01]
 
minf = 1 ./ (1+exp((AR_V12-V)/AR_k))
mtau = 1./(AR_L.*exp(-14.6-.086*V)+AR_R.*exp(-1.87+.07*V))
aM = c_ARaM.*(minf ./ mtau)
bM = c_ARbM.*((1-minf)./mtau)

minf2 = aM ./ (aM + bM);
mtau2 = 1./(aM+bM);

figure; subplot(211);plot(V,minf2); subplot(212); plot(V,mtau2);

