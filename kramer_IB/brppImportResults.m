function results = dsImportResults(name, variable, format)

load([name, 'sim_struct.mat'])

vary_lengths = cellfun(@length, vary(:,3));

no_sims = prod(vary_lengths);

if strcmp(format, 'double')

    results = nan(no_sims, 1);

elseif strcmp(format, 'struct')
    
    results = struct([]);
    
else
    
    results = cell(no_sims, 1);
    
end

study_folder = [name, '/results'];

for s = 1:no_sims
    
    result = load(sprintf('%s/study_sim%d_analysis1_ISI_metrics.mat', study_folder, s));
    
    
    results(s) = result.result.(variable);

end

save([name, '_', variable, '.mat'], 'results')