function [MRVs, Nspikes, dim_order] = collectSpeechPLV(name_mat, suffix)

if nargin < 2, suffix = []; end
if isempty(suffix), suffix = '_PLV_data.mat'; end

names = load(name_mat);

names = names.names;
        
load([names{1}, '_sim_spec.mat'])

dims = cellfun(@length, vary(:, 3));
dim_order = vary(dims ~= 1, 2);
dims(dims == 1) = [];

[MRVs, Nspikes] = deal(nan([dims', length(names)]));

for n = 1:length(names)
    
    if exist([names{n}, suffix]) == 2
    
        PLV_data = load([names{n}, suffix]);
        
%         if any(strcmp(fieldnames(PLV_data), 'results'))
%         
%             PLV_data = PLV_data.results;
%             
%         end
%         
%     else
%         
%        results = dsImportResults(names{1}, @phase_metrics);
%        
%        save([names{1}, '_PLV_data.mat'], 'results', 'name', 'vary', 'sim_spec', 'sim_struct', '-v7.3')
%        
%        PLV_data = results;
        
    end
    
    PLV_dims = make_unique(size(PLV_data.v_mean_spike_mrvs));
    
    [permutation, ~] = find((PLV_dims == make_unique(dims))');
    
%     this_MRVs = reshape(permute(PLV_data.v_mean_spike_mrvs, [2, 1, 3]), [20, 16, 11]);
%     
%     this_Nspikes = reshape(permute(PLV_data.no_spikes, [2, 1, 3]), [20, 16, 11]);
    
    MRVs(:, :, :, n) = permute(PLV_data.v_mean_spike_mrvs, permutation'); % permute(this_MRVs, [3, 2, 1]);
    
    Nspikes(:, :, :, n) = permute(PLV_data.no_spikes, permutation'); % permute(this_Nspikes, [3, 2, 1]);
    
end

% dim_order = dim_order(permutation);
% dim_order{end + 1} = 'model';

save([name_mat(1:(end - 4)), suffix], 'names', 'MRVs', 'Nspikes', 'dim_order')

end

function dims_out = make_unique(dims)

dims_out = dims;

dim_entries = unique(dims);

for e = 1:length(dim_entries)
    
    entry_indicator = dims == dim_entries(e);
   
    if sum(entry_indicator) > 1
       
       steps = linspace(0, 1, sum(entry_indicator) + 1);
       
       dims_out(entry_indicator) = dim_entries(e) + steps(1:(end - 1));
       
    end
   
end

end