function S = rate2nonhomPoisson(s,poissScaling,tau,Tend,dt)

    % 
    Npop = size(s,2);
    S_ini = zeros(Npop,1);
    
    rate = s .* poissScaling / 1000;        % Convert from 1/s to 1/ms
    interval = Tend;
    kick = 1;
    S = nonhomPoissonGeneratorSpikeTimes(S_ini,rate',tau,kick,Npop,interval,dt);
    
    S = S';
    
    
    
end