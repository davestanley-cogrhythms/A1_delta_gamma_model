

function data = addfield_IBphaselock_corrcoef_errbar (data)
    duty_cycle = 0.5;        % Set to -1 to use the pulse width to determine the duty cycle
    

    % For each simulation, pull out the on/off regions and calculate phase
    % locking
    Nsims = length(data);
    total_spks_pulse_on = cell(1,Nsims);
    total_spks_pulse_off = cell(1,Nsims);
    
    Ncycles = zeros(1,Nsims);
    for i = 1:Nsims
        % Get basic parameters of dataset
        downsample_factor = data(i).simulator_options.downsample_factor;
        dt = data(i).simulator_options.dt * downsample_factor;
        t = data(i).time;
        
        % Pull out spike times and pulse information
        variable = data(i).IB_NG_GABAall_gTH;    % Used later
        pulsetrain = data(i).IB_iPoissonNested_ampaNMDA_Allmasks;
        
        % Process pulses to get pulse onset and offset values
        pulsetrain = median(pulsetrain,2);
        dp = diff(pulsetrain);
            % This breaks the data down into on and off transients. Value
            % +1 mark onset, values -1 mark offset
        ons = find(dp > 0.5) + 1;   % All values >= ons are inside pulse
        offs = find(dp < -0.5) + 1;  % All values < offs are inside pulse
        
        % Convert to ms so it's in the same units as the spike times
        % Comment this out, so that we can stay working in indices
%         ons = ons * dt;
%         offs = offs * dt;
        
        % Loop through each cycle in the pulse train. Drop the last "on"
        % since this cycle is guaranteed to be incomplete.
        Ncycles(i) = length(ons)-1;
        total_spks_pulse_on{i} = zeros(1, Ncycles(i));
        total_spks_pulse_off{i} = zeros(1, Ncycles(i));
        for j = 1:Ncycles(i)
            % Start of current pulse
            mystart = ons(j);
            
            % Find corresponding ending of current pulse
            temp = find(offs > mystart,1,'first');

            mystart2 = ons(j+1);
            
            if duty_cycle > 0
                mystop = floor((mystart2 - mystart)*duty_cycle + mystart);             % mystop is duty_cycle fraction of the way between mystart and mystart2
            else
                mystop = offs(temp);
            end

            % Total spikes for the on portion of the  cycle
            mean_on{i}(j) = mean(mean(variable(mystart:mystop-1,:)));
            
            % Total spikes for the off portion of the cycle
            mean_off{i}(j) = mean(mean(variable(mystop:mystart2-1,:)));
        end
            
    end
    
    
    % Calculate phase locking ratio for all sims
    af = cell(1,Nsims);
    mu_af = zeros(1,Nsims);
    std_af = zeros(1,Nsims);
    ste_af = zeros(1,Nsims);
    
    for i = 1:Nsims
        af{i} = zeros(1,Ncycles(i));
        for j = 1:Ncycles(i)
            % Calculate contrast index
            af{i}(j) = (mean_on{i}(j) - mean_off{i}(j)) / (mean_on{i}(j) + mean_off{i}(j));
        end
    end
    
    for i = 1:Nsims
        mu_af(i) = mean(af{i});
        std_af(i) = std(af{i});
        ste_af(i) = std(af{i}) / sqrt(Nsims);
    end
    
    % Save to data
    for i = 1:Nsims
        data(i).IB_phaselock_CI_mu = mu_af(i);
        data(i).IB_phaselock_CI_ste = ste_af(i);
        data(i).labels = cat(2,data(i).labels,{'IB_phaselock_CI_mu','IB_phaselock_CI_ste'});
    end
    
end
