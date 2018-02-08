function S = rate2nonhomPoisson(s,poissScaling,tau,Tend,dt)

    % 
    Npop = size(s,2);
    S_ini = zeros(Npop,1);
    
    rate = s .* poissScaling / 1000;        % Convert from 1/s to 1/ms
    interval = Tend;
    kick = 1;
    
    % Store current state of random number generator, so sims won't be
    % affected by vary statements
    scurr = rng;
    
    % Generate poisson process
    S = nonhomPoissonGeneratorSpikeTimes(S_ini,rate',tau,kick,Npop,interval,dt);
    
    % Restore current state of rng
    rng(scurr);
    
    S = S';
    
    
    
end