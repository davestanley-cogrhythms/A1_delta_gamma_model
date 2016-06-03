% # A: A-current
% # Jason?s email:
% # Here are two different A-type K+ current mechanisms I've implemented.
% # However, I have not worked with these much or carefully verified that
% # they are working properly. The reference for iAPoirazi.txt is included in
% # it; I don't remember where I got the model in iA.txt though.


%%
% IA
V=-100:0.01:100; V=V';

gA=1; EA=-80;
ainf=1./(1+exp(-(V+60)/8.5))
atau=.37+1./(exp((V+46)/5)+exp(-(V+238)/37.5))
binf=1./(1+exp((V+78)/6))
btau=19+1./(exp((V+46)/5)+exp((V+238)/(-37.5)))
% IA(V,a,b)=gA.*a.^4.*b.*(V-EA)
% current => -IA(V,a,b)






figure; plot(V,[ainf.^4 binf]);
figure; plot(V,[atau btau]);