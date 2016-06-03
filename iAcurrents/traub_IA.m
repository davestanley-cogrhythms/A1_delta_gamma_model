
% # A: A-current
% Traub 1991


%%
% IA
V=-100:0.01:100; V=V';

aalpha=0.02*(13.1-V) ./ (exp((13.1-V)/10)-1);
abeta = 0.0175*(V-40.1) ./ (exp((V-40.1)/10)-1);

balpha = 0.0016*exp((-13-V)./18);
bbeta = 0.05 ./ (1+exp((10.1-V)/5));


atau = 1./(aalpha + abeta);
btau = 1./(balpha + bbeta);


ainf = aalpha .* atau;
binf = balpha .* btau;


figure; plot(V,[ainf.^4 binf]);
figure; plot(V,[atau btau]);