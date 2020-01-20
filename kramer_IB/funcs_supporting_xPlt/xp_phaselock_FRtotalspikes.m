

function hxp = xp_phaselock_FRtotalspikes (xp, op)
    % ** Outdated. Use addfield_phaselock_FRstats to calculate statistics and
    % then xp_barplot_err to do the plotting **
    
    % xp must be 1x1 (e.g. 0 dimensional)
    % Gets average spikes during pulse on stage
    % Note - this is not the total spikes, even though the func name says
    % it is! It is the average spiking rate during the pulse on period (or
    % duty cycle, if duty_cycle is not -1)
    
    hxp = struct;
    
    if nargin < 2
        op = struct;
    end
    
    if isempty(op); op = struct; end;
    
    % Setup duty cycle
        % Duty cycle determines what fraction of the pulse cycle is
        % considered "on" and "off." Setting this to 50% will cause 50% of
        % the time following the start of the pulse to be considered on,
        % and the remaining to be considered off. 
        % This is used for calculating total_spks_pulse_on / off, or other
        % variables for measuring phase locking.
    duty_cycle = -1;        % Set to -1 to use the pulse width to determine the duty cycle
    
%     op = struct_addDef(op,'args',{});
%     op = struct_addDef(op,'imagesc_zlims',[]);
%     op = struct_addDef(op,'lineplot_ylims',[]);
%         % These are the min and max limits associated with the lineplots
%         % (GABA A and B). If left empty, they will be auto-estimated to the
%         % min and max of the data to be plotted. This option is useful for
%         % ensuring a uniform min and max across multiple subplots
%     op = struct_addDef(op,'show_imagesc',false);             % Imagesc background showing GABA B conductance as shading
%     op = struct_addDef(op,'show_lineplot_FS_GABA',false);       % Line plot with just FS conductance
%     op = struct_addDef(op,'show_lineplot_NG_GABA',false);      % Line plot with just NG conductances
%     op = struct_addDef(op,'show_lineplot_NGFS_GABA',false);      % Line plot with both NG and FS conductances
    
    
%     xlims = op.xlims;
%     ylims = op.ylims;
%     imagesc_zlims = op.imagesc_zlims;
%     lineplot_ylims = op.lineplot_ylims;
%     show_imagesc = op.show_imagesc;
%     show_lineplot_FS_GABA = op.show_lineplot_FS_GABA;
%     show_lineplot_NG_GABA = op.show_lineplot_NG_GABA;
%     show_lineplot_NGFS_GABA = op.show_lineplot_NGFS_GABA;

    % Squeeze out any 1D placeholder axes ("Dim X"). These can be created
    % by the unpacking operation above. 
    xp = xp.squeezeRegexp('Dim');

    % Fix labels
    xp.meta.dynasim.labels{strcmp(xp.meta.dynasim.labels,'IB_V')} = 'NG_V';
    xp.meta.dynasim.labels{1} = 'IB_V';     % Cheap hack - reset first value in labels so that it gets the correct population. Otherwise, it will assume NG cells.
    
    % Convert xp to DynaSim data struct
    data = dsMdd2ds(xp);
    
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

            if duty_cycle > 0
                mystop = floor((mystart2 - mystart)*duty_cycle + mystart);             % mystop is duty_cycle fraction of the way between mystart and mystart2
            else
                mystop = offs(temp);
            end
            mystart2 = ons(j+1);

            % Total spikes for the on portion of the  cycle (normalize by
            % window length)
            total_spks_pulse_on{i}(j) = count_spikes(spikes,mystart,mystop) / (mystop-mystart) / dt;
            
            % Total spikes for the off portion of the cycle (normalize by
            % window length)
            total_spks_pulse_off{i}(j) = count_spikes(spikes,mystop,mystart2) / (mystart2-mystop) / dt;
        end
            
    end
    
    
    % Calculate mean number of spikes in each sim
    mu_af = zeros(1,Nsims);
    std_af = zeros(1,Nsims);
    ste_af = zeros(1,Nsims);    
    for i = 1:Nsims
        mu_af(i) = mean(total_spks_pulse_on{i});
        std_af(i) = std(total_spks_pulse_on{i});
        ste_af(i) = std(total_spks_pulse_on{i}) / sqrt(Nsims);
    end
    
    hxp.hcurr = barwitherr(ste_af,mu_af,'k');
%     ylim([0,1.2]);
    
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
    

