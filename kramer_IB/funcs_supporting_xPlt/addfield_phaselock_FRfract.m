

function data = addfield_IBphaselock (data)
    % xp must be 1x1 (e.g. 0 dimensional)
    
    % Setup duty cycle
        % Duty cycle determines what fraction of the pulse cycle is
        % considered "on" and "off." Setting this to 50% will cause 50% of
        % the time following the start of the pulse to be considered on,
        % and the remaining to be considered off. 
        % This is used for calculating total_spks_pulse_on / off, or other
        % variables for measuring phase locking.
    duty_cycle = -1;        % Set to -1 to use the pulse width to determine the duty cycle

    
    % Remove NaNs introduced due to packing
    for i = 1:length(data)
        labels = data(i).labels;
        labels_sans_time = labels(~strcmp(labels,'time'));

        for j = 1:length(labels_sans_time)
            d = data(i).(labels_sans_time{j});
            ind = all(~isnan(d),1);
            d=d(:,ind);
            data(i).(labels_sans_time{j}) = d;
        end
    end
    
    
    % Calculate spike timings for data
    data = dsCalcFR(data);
    
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
        spikes = data(i).IB_V_spike_times;    % Used later
        pulsetrain = data(i).IB_iPoissonNested_ampaNMDA_Allmasks;
        
        % Process pulses to get pulse onset and offset values
        pulsetrain = median(pulsetrain,2);
        dp = diff(pulsetrain);
            % This breaks the data down into on and off transients. Value
            % +1 mark onset, values -1 mark offset
        ons = find(dp > 0.5) + 1;   % All values >= ons are inside pulse
        offs = find(dp < -0.5) + 1;  % All values < offs are inside pulse
        
        % Convert to ms so it's in the same units as the spike times
        ons = ons * dt;
        offs = offs * dt;
        
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
            
%             if isempty(temp)
%                 % If can't find it, then this means that the simulation
%                 % ended before the downstroke of the current pulse. In this
%                 % case, just abandon the data point
%                 %mystop = ending;    % If can't find it, just use end of dataset
%                 
%                 continue
%             end

            mystart2 = ons(j+1);
            
            if duty_cycle > 0
                mystop = floor((mystart2 - mystart)*duty_cycle + mystart);             % mystop is duty_cycle fraction of the way between mystart and mystart2
            else
                mystop = offs(temp);
            end

            % Total spikes for the on portion of the  cycle
            total_spks_pulse_on{i}(j) = count_spikes(spikes,mystart,mystop);
            
            % Total spikes for the off portion of the cycle
            total_spks_pulse_off{i}(j) = count_spikes(spikes,mystop,mystart2);
        end
            
    end
    
    
    % Calculate phase locking ratio for all sims
    mu_n = zeros(1,Nsims);
    mu_af = zeros(1,Nsims);
    std_af = zeros(1,Nsims);
    ste_af = zeros(1,Nsims);
    for i = 1:Nsims
        mu_n(i) = mean(total_spks_pulse_on{i} + total_spks_pulse_off{i});
    end
    
    for i = 1:Nsims
        for j = 1:Ncycles(i)
            af{i}(j) = total_spks_pulse_on{i}(j) / mu_n(i);     % Aligned fraction

        end
    end
    
    for i = 1:Nsims
        mu_af(i) = mean(af{i});
        std_af(i) = std(af{i});
        ste_af(i) = std(af{i}) / sqrt(Nsims);
    end
    
    % Save to data
    for i = 1:Nsims
        data(i).IB_phaselock_FR_mu = mu_af(i);
        data(i).IB_phaselock_FR_ste = ste_af(i);
        data(i).labels = cat(2,data(i).labels,{'IB_phaselock_FR_mu','IB_phaselock_FR_ste'});
    end
    
end

function total_spikes = count_spikes(spikes,mystart,mystop)
    % Counts the total number of spikes in cell array spikes occuring
    % between mystart and mystop. spikes is a cell array
    % of spike times, 1xNcells. (e.g., produced by dsCalcFR)

    total_spikes = 0;
    Ncells = length(spikes);
    for k = 1:Ncells
        % Pull out first cell
        spks = spikes{k};
        spks = double(spks);
        
        % Number of spike events falling in this range
        total_spikes = total_spikes + length(find(spks >= mystart & spks < mystop));    
    end

end
    
