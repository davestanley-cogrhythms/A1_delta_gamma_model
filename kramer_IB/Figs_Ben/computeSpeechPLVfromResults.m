function [MRVs, Nspikes, dim_order] = computeSpeechPLVfromResults(name_mat, suffix)

if nargin < 2, suffix = []; end
if isempty(suffix), suffix = '_PLV_data.mat'; end

names = load(name_mat);

names = names.names;
        
load([names{1}, '_sim_spec.mat'])

dims = cellfun(@length, vary(:, 3));
dim_pops = vary(dims ~= 1, 1);
dim_order = vary(dims ~= 1, 2);
dims(dims == 1) = [];

dim_vars = dim_order;

for i = 1:length(dim_order)
   
    dim_vars{i} = split(dim_vars{i}, {'(', ', ', ')'});
    dim_vars{i}(cellfun(@isempty, dim_vars{i})) = [];
    dim_vars{i} = dim_vars{i}{1};
    
end

[MRVs, Nspikes] = deal(nan([dims', length(names)]));

for n = 1:length(names)
    
    name = names{n};

    studyinfo = load([name, '/studyinfo.mat']);
    
    parameter_vectors = get_parameter_vectors(studyinfo, dim_vars, dim_pops);
    
    for p  = 1:length(dim_order)
        
        parameter_values{p} = unique(parameter_vectors(:, p));
        
    end
        
    results = dsImportResults(name, @phase_metrics);
    
    metrics = nan(size(results, 1), 2);
    
    result_fields = fields(results);
    
    result_cell = struct2cell(results);
    
    v_spike_phases = squeeze(result_cell(strcmp(result_fields, 'v_spike_phases'), :));
    
    metrics(:, 1) = cellfun(@(x) nanmean(exp(sqrt(-1)*x(:, :, 1))), v_spike_phases);
    
    no_spikes_cell = squeeze(result_cell(strcmp(result_fields, 'no_spikes'), :));
    empty_cells = cellfun(@isempty, no_spikes_cell);
    no_spikes_cell(empty_cells) = {nan};
    
    metrics(:, 2) = cell2mat(no_spikes_cell);
    
    for i = 1:length(parameter_values{1})
        
        p1_value = parameter_values{1}(i);
        p1_index = parameter_vectors(:, 1) == p1_value;
        
        for j = 1:length(parameter_values{2})
            
            p2_value = parameter_values{2}(j);
            p2_index = parameter_vectors(:, 2) == p2_value;
            
            for k = 1:length(parameter_values{3})
                
                p3_value = parameter_values{3}(k);
                p3_index = parameter_vectors(:, 3) == p3_value;
        
                MRVs(i, j, k, n) = metrics(p1_index & p2_index & p3_index, 1);
                
                Nspikes(i, j, k, n) = metrics(p1_index & p2_index & p3_index, 2);
                
            end
            
        end
    end
    
    clear metrics
    
    metrics(:, :, :, 1) = MRVs(:, :, :, n);
    
    metrics(:, :, :, 2) = Nspikes(:, :, :, n);
    
%     metrics = reshape(metrics, [dims', 2]);
%     
%     MRVs(:, :, :, n) = metrics(:, :, :, 1); % squeeze(nansum(prod(metrics, 4), SI_dim));
%     
%     Nspikes(:, :, :, n) = metrics(:, :, :, 2); % squeeze(nansum(metrics(:, :, :, 2), SI_dim));
    
%     MRVs = MRVs./Nspikes;
%     
%     PLV(:, :, n) = ((abs(MRVs).^2).*Nspikes - 1)./(Nspikes - 1);

    save([name, '_PLV_data_from_results.mat'], 'metrics', 'dim_order')
    
end

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

function parameter_vectors = get_parameter_vectors(studyinfo, parameters, pops)

sims = studyinfo.studyinfo.simulations;

sims_fields = fields(sims);

sims_cell = struct2cell(sims);

mods_cell = squeeze(sims_cell(strcmp(sims_fields, 'modifications'), :, :));

modified_pops = mods_cell{1}(:, 1);

modified_pops = cellfun(@(x) replace(x, '->', '_'), modified_pops, 'unif', 0);

modified_variables = mods_cell{1}(:, 2);

parameter_vectors = nan(max(size(mods_cell)), length(parameters));

for p = 1:length(parameters)
    
    variable_index = false(size(modified_variables));
    
    var_subindex = cell(size(modified_variables));
    
    for i = 1:length(modified_variables)
        
        modified_variable = split(mods_cell{1}{i, 2}, {'(', ', ', ')'});
        
        modified_variable(cellfun(@isempty, modified_variable)) = [];
        
        for j = 1:length(modified_variable)
            
            var_subindex{i}(j) = contains(parameters{p}, modified_variable{j}) & contains(pops{p}, modified_pops{i});
            
        end
        
        variable_index(i) = any(var_subindex{i});
        
    end
    
    if length(var_subindex{variable_index}) > 1
        
        this_vary_mat = cell2mat(cellfun(@(x) squeeze(x{variable_index, 3})', mods_cell, 'unif', 0));
        
    else
        
        this_vary_mat = cellfun(@(x) [x{variable_index, 3}], mods_cell);
        
    end
    
    parameter_vectors(:, p) = this_vary_mat(:, var_subindex{variable_index});
    
end

end