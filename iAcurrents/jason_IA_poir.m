% % iAPoirazi: fast inactivating K current (A in Poirazi, Brannon, & Mel 2003)
% # Jason?s email:
% # Here are two different A-type K+ current mechanisms I've implemented.
% # However, I have not worked with these much or carefully verified that
% # they are working properly. The reference for iAPoirazi.txt is included in
% # it; I don't remember where I got the model in iA.txt though.

%%
% Poirarzi IA
V=-100:0.01:100; V=V';

gA=7.5; EA=-80; IC=.1; IC_noise=.1; celsius=36;
qt=5^((celsius-24)/10)
an=exp((.001*(-1.8-(1./(1+exp((V+40)/5)))).*(V+1)*96480)./(8.315*(273.16+celsius)))
bn=exp((.001*(-1.8-(1./(1+exp((V+40)/5)))).*(V+1)*96480*.39)./(8.315*(273.16+celsius)))
al=exp((.001*(3).*(V+1)*96480)./(8.315*(273.16+celsius)))
ntau=max(.2,bn./(qt*.1*(1+an)))
ninf=1./(1+an)
linf=1./(1+al)
ltau=max(2,.26./(V+50))
% ltau=.26./(V+50)
% dn=(ninf-n)./ntau
% dl=(linf-l)./ltau
% n0)=IC+IC_noise.*rand(Npop,1)
% l(0)=IC+IC_noise.*rand(Npop,1)
% IA(V,n,l)=gA.*n.*l.*(V-EA)
% current => -IA(V,n,l)



figure; plot(V,[ninf linf]);
figure; plot(V,[ntau ltau]);
