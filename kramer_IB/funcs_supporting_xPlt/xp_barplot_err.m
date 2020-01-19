

function hxp = xp_barplot_err (xp, op)

    hxp = struct;
    
    if nargin < 2
        op = struct;
    end
    
    
    data = dsMdd2ds(xp);
    
    % Pull out labels
    labels = data(1).labels;
    
    % Find mu label
    idx = ~cellfun(@isempty,strfind(labels,'mu'));
    label_mu = labels{idx};
    
    % Find ste label
    idx = ~cellfun(@isempty,strfind(labels,'ste'));
    label_ste = labels{idx};
    
    % Varied field
    varied_field = data(1).varied{1};
    
    
    % Extract mean, standard deviation, and varied label of each simulation
    Nsims = length(data);
    ste_af = zeros(1,Nsims);
    mu_af = zeros(1,Nsims);
    varied_val = cell(1,Nsims);
    for i = 1:Nsims
        ste_af(i) = data(i).(label_ste);
        mu_af(i) = data(i).(label_mu);
        varied_val{i} = data(i).(varied_field);
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
    

