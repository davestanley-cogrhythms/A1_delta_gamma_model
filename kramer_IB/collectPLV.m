function collectPLV(sim_name) % synchrony_window, vpnorm, 

%% Defaults & arguments.

suffix = '_PLV';

sim_struct = load(sim_name);

names = sim_struct.names;

%% Collecting PLV.

load([names{1}, suffix, '.mat'])

[all_MRV, all_no_spikes] = deal(nan([length(results), size(results(1).no_spikes, 2), length(names)]));

for n = 1:length(names)
    
    PLV_mat = load([names{n}, suffix, '.mat']);
    PLV_mat = PLV_mat.results;
    
    this_no_spikes = fill_struct_empty_field(PLV_mat, 'no_spikes', nan);
    
    all_no_spikes(:, :, n) = reshape(this_no_spikes, size(all_no_spikes(:, :, n)));
    
    parfor i = 1:length(PLV_mat)
        
        if ~isempty(PLV_mat(i).v_spike_phases)
            
            all_MRV(i, :, n) = nanmean(exp(sqrt(-1)*PLV_mat(i).v_spike_phases));
            
        end
        
    end
    
end

save([sim_name, suffix, '_outcomes.mat'], 'all_no_spikes', 'all_MRV')

end