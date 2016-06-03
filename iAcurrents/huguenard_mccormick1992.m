% # A: A-current
% Simulation of the Currents Involved in Rhythmic Oscillations in Thalamic
% Relay Neurons

%%
% IA
V=-120:0.01:100; V=V';


% IA 1
a1inf=1./(1+exp(-(V+60)/8.5));
a1tau=.37+1./(exp((V+35.8)/19.7)+exp((V+79.7)/-12.7));
b1inf=1./(1+exp((V+78)/6));
b1tau=(1./(exp((V+46)/5)+exp((V+238)/(-37.5)))) .* (V<-63) + 19 * (V>=-63);

% IA 2
a2inf=1./(1+exp(-(V+36)/20));
a2tau=.37+1./(exp((V+35.8)/19.7)+exp((V+79.7)/-12.7));
b2inf=1./(1+exp((V+78)/6));
b2tau = b1tau .* (V<-73) + 60 * (V>=-73);
% b2tau=1./(exp((V+46)/5)+exp((V+238)/(-37.5)));


% ainf=1./(1+exp(-(V+60)/8.5))
% atau=.37+1./(exp((V+46)/5)+exp(-(V+238)/37.5))
% binf=1./(1+exp((V+78)/6))
% btau=19+1./(exp((V+46)/5)+exp((V+238)/(-37.5)))
% IA(V,a,b)=gA.*a.^4.*b.*(V-EA)
% current => -IA(V,a,b)






figure; subplot(211); plot(V,[a1inf b1inf]); ylabel('x_{inf}'); xlabel('Vm'); title ('Huguenard iA 1');
subplot(212); plot(V,[a1tau b1tau]); ylabel('Tau'); xlabel('Vm');

figure; subplot(211); plot(V,[a2inf b2inf]); ylabel('x_{inf}'); xlabel('Vm'); title ('Huguenard iA 2');
subplot(212); plot(V,[a2tau b2tau]); ylabel('Tau'); xlabel('Vm');