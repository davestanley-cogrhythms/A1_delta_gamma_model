

%%

scaling_mode = 2;

V=-100:100
AR_V12 = [-87.5]
AR_k = [-5.5]
gAR = [115]
E_AR = [-25]
switch scaling_mode
    case 1
        % Kramer's original values
        c_ARaM = [1.75]
        c_ARbM = [.5]
    case 2
        % Jason's values
        c_ARaM = [2.75]
        c_ARbM = [3]
    case 3
        % Unmodified
        c_ARaM = [1]
        c_ARbM = [1]
end
AR_L = [1]
AR_R = [1]
IC = [0]
IC_noise = [0.01]
 
minf = 1 ./ (1+exp((AR_V12-V)/AR_k))
mtau = 1./(AR_L.*exp(-14.6-.086*V)+AR_R.*exp(-1.87+.07*V))
aM = c_ARaM.*(minf ./ mtau)
bM = c_ARbM.*((1-minf)./mtau)

figure;plot(V,aM./(aM+bM)); xlabel('Vm'); ylabel('AR mInf');
figure;plot(V,1./(aM+bM)); xlabel('Vm'); ylabel('AR mTau');

 
