function results_cell = posthocPLV(name)

%% Defaults & arguments.

% boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

analysis_name = [name, '_PLV.mat'];

if exist([name, '_boundary_analysis.mat'], 'file')
    
    results_in = load([name, '_boundary_analysis.mat']);
    
    results_in = results_in.results;

else
    
    results_in = dsImportResults(name, @boundary_analysis);
    
end

% [no_spikes, v_spike_phases] = deal(nan(size(results_in)));
% 
% phase = nan(length(results_in(1).time), length(results_in));

output_fields = {'no_spikes', 'v_spike_phases', 'mrvs', 'phase'};

results_cell = cell(length(results_in), length(output_fields));

parfor i = 1:length(results_in)
    
    if ~any(cellfun(@isempty, struct2cell(results_in(i))))
        
        [results_cell{i, :}] = runPLV(results_in(i));
        
    end
   
end

results = cell2struct(results_cell, output_fields, 2);

save(analysis_name, '-v7.3', 'results')
    
end

function [no_spikes, v_spike_phases, mrvs, phase] = runPLV(results)

sampling_freq = round(length(results.time(results.time <= 1000))/1000);

bandpassed = wavelet_reduce(results.input, sampling_freq, 2:4, 2);

phase = angle(bandpassed);

no_spikes = sum(results.spikes);

v_spike_phases = nan(max(no_spikes), size(results.spikes, 2));

for i = 1:size(results.spikes, 2)
    
    v_spike_phases(1:no_spikes(i), i) = phase(logical(results.spikes(:, i)));
    
end

mrvs = nanmean(exp(sqrt(-1)*v_spike_phases));

end
