

function hxp = xp_IBphaselock_corrcoef_errbar (xp, op)
    % xp must be 1x1 (e.g. 0 dimensional)
    % Produces phase locking trace using correlation coefficient instead of
    % earlier phase locking ratio method.
    
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
    
    
    % For each simulation, pull out the on/off regions and calculate phase
    % locking
    Nsims = length(data);
    
    r_all = zeros(1,Nsims);
    p_all = zeros(1,Nsims);
    rlo_all = zeros(1,Nsims);
    rup_all = zeros(1,Nsims);
    
    for i = 1:Nsims
        
        % Pull out spike times and pulse information
        synaptic_potential = data(i).IB_THALL_GABA_gTH;    % Used later
        pulsetrain = data(i).IB_iPoissonNested_S2;
        
        synaptic_potential = mean(synaptic_potential,2);
        pulsetrain = mean(pulsetrain,2);
        
        [R,P,RLO,RUP] = corrcoef(pulsetrain,synaptic_potential);
        r_all(i) = R(1,2);
        p_all(i) = P(1,2);
        rlo_all(i) = RLO(1,2);
        rup_all(i) = RUP(1,2);
      
    end
    
    errY = cat(3,rlo_all,rup_all);
    
    hxp.hcurr = barwitherr(errY,r_all,'FaceColor',[0.5,0.5,0.5]);
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
    

