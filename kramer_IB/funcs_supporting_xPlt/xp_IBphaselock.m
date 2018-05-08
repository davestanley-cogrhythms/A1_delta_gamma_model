

function hxp = xp_IBphaselock (xp, op)
    % xp must be 1x1 (e.g. 0 dimensional)
    
    hxp = struct;
    
    if nargin < 2
        op = struct;
    end
    
    if isempty(op); op = struct; end;
    
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
    total_spks_pulse_on = zeros(1,Nsims);
    total_spks_pulse_off = zeros(1,Nsims);
    
    for i = 1:Nsims
        
        % Get basic parameters of dataset
        downsample_factor = data(i).simulator_options.downsample_factor;
        dt = data(i).simulator_options.dt * downsample_factor;
        t = data(i).time;
        ending = t(end);
        
        % Pull out spike times and pulse information
        spikes = data(i).IB_V_spike_times;    % Used later
        pulsetrain = data(i).IB_iPoissonNested_S2;
        
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
        
        
        % Loop through each pulse in the pulse train
        total_spks_pulse_on(i) = 0;                    % Total number of spikes when the pulse is on
        for j = 1:length(ons)
            % Start of current pulse
            mystart = ons(j);
            
            % Corresponding ending of current pulse
            temp = find(offs > mystart,1,'first');
            if ~isempty(temp); mystop = offs(temp);
            else; mystop = ending;    % If can't find it, just use end of dataset
            end
            
            total_spikes = count_spikes(spikes,mystart,mystop);
            total_spks_pulse_on(i) = total_spks_pulse_on(i) + total_spikes;
        end
        
        % Loop through each inter-pulse interval in the pulse train
        total_spks_pulse_off(i) = 0;                    % Total number of spikes occuring when pulse is off
        for j = 1:length(offs)
            % End of current pulse
            mystart = offs(j);
            
            % Beginnin gof next corresponding pulse
            temp = find(ons > mystart,1,'first');
            if ~isempty(temp); mystop = ons(temp);
            else; mystop = ending;    % If can't find it, just use end of dataset
            end
            
            total_spikes = count_spikes(spikes,mystart,mystop);
            total_spks_pulse_off(i) = total_spks_pulse_off(i) + total_spikes;
        end           
    end
    
    % Calculate phase locking ratio for all sims
    %aligned_fraction = zeros(1,Nsims);
    aligned_fraction = total_spks_pulse_on ./ (total_spks_pulse_on + total_spks_pulse_off);
    
    hxp.hcurr = bar(aligned_fraction);
    
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
    

