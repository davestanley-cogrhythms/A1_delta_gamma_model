

function data = addfield_phaselock_FRstats (data)
    % xp must be 1x1 (e.g. 0 dimensional)
    
    % Setup duty cycle
        % Duty cycle determines what fraction of the pulse cycle is
        % considered "on" and "off." Setting this to 50% will cause 50% of
        % the time following the start of the pulse to be considered on,
        % and the remaining to be considered off. 
        % This is used for calculating total_spks_pulse_on / off, or other
        % variables for measuring phase locking.
    duty_cycle = -1;        % Set to -1 to use the pulse width to determine the duty cycle    
    
    % Calculate spike timings for data (only if not present already)
    if ~isfield(data,'IB_V_spike_times')
        data = dsCalcFR(data);
    end
    
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
        mean_spks_pulse_on{i} = zeros(1, Ncycles(i));
        mean_spks_pulse_off{i} = zeros(1, Ncycles(i));
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
            
            % Total spikes for the on portion of the  cycle (normalize by
            % window length)
            mean_spks_pulse_on{i}(j) = count_spikes(spikes,mystart,mystop) / (mystop-mystart) / dt;
            
            % Total spikes for the off portion of the cycle (normalize by
            % window length)
            mean_spks_pulse_off{i}(j) = count_spikes(spikes,mystop,mystart2) / (mystart2-mystop) / dt;
        end
            
    end
    
    
    % % % % % % Calculate FRfract for all sims (mean and standard deviation) % % % % % %
    for i = 1:Nsims
        foo = total_spks_pulse_on{i} / mean(total_spks_pulse_on{i} + total_spks_pulse_off{i});
        mu_af(i) = mean(foo);
        std_af(i) = std(foo);
        ste_af(i) = std(foo) / sqrt(Nsims);
        
        data(i).IB_phaselock_FRfract_mu = mu_af(i);
        data(i).IB_phaselock_FRfract_ste = ste_af(i);
        data(i).labels = cat(2,data(i).labels,{'IB_phaselock_FRfract_mu','IB_phaselock_FRfract_ste'});
    end
    
    % % % % % % Calculate FRtot for all sims (mean and standard deviation) % % % % % %
    for i = 1:Nsims
        mu_af(i) = mean(mean_spks_pulse_on{i});
        std_af(i) = std(mean_spks_pulse_on{i});
        ste_af(i) = std(mean_spks_pulse_on{i}) / sqrt(Nsims);
        
        data(i).IB_phaselock_FRtot_mu = mu_af(i);
        data(i).IB_phaselock_FRtot_ste = ste_af(i);
        data(i).labels = cat(2,data(i).labels,{'IB_phaselock_FRtot_mu','IB_phaselock_FRtot_ste'});
    end
    
    % % % % % % Calculate FRfract * FRtot for all sims (mean and standard deviation) % % % % % %
    for i = 1:Nsims
        foo = (total_spks_pulse_on{i} / mean(total_spks_pulse_on{i} + total_spks_pulse_off{i})) * mean(mean_spks_pulse_on{i});
        mu_af(i) = mean(foo);
        std_af(i) = std(foo);
        ste_af(i) = std(foo) / sqrt(Nsims);
        
        data(i).IB_phaselock_FRfract_x_total_mu = mu_af(i);
        data(i).IB_phaselock_FRfract_x_total_ste = ste_af(i);
        data(i).labels = cat(2,data(i).labels,{'IB_phaselock_FRfract_x_total_mu','IB_phaselock_FRfract_x_total_ste'});
    end
    
    % % % % % % Calculate FRfract * FRtot for all sims (mean and standard deviation) % % % % % %
    % This formula is slightly different than the above, in that the
    % muliplication is done before taking the mean across trials. This
    % allows us to get more accurate error bars, but it might not be the
    % exact statistic we want...
    for i = 1:Nsims
        foo = (total_spks_pulse_on{i} / mean(total_spks_pulse_on{i} + total_spks_pulse_off{i})) .* mean_spks_pulse_on{i};
        mu_af(i) = mean(foo);
        std_af(i) = std(foo);
        ste_af(i) = std(foo) / sqrt(Nsims);
        
        data(i).IB_phaselock_FR3fract_x_total_mu = mu_af(i);
        data(i).IB_phaselock_FR3fract_x_total_ste = ste_af(i);
        data(i).labels = cat(2,data(i).labels,{'IB_phaselock_FR3fract_x_total_mu','IB_phaselock_FR3fract_x_total_ste'});
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
    

