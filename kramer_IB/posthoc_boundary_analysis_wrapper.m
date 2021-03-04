function results = posthoc_boundary_analysis_wrapper(name, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

analysis_name = [name, label, '_boundary_analysis.mat'];

if exist(analysis_name, 'file')

    results = load(analysis_name);
    
    return
    
elseif exist([name, '_boundary_analysis.mat'], 'file')
    
    results_in = load([name, '_boundary_analysis.mat']);
    
    results_in = results_in.results;

else
    
    results_in = dsImportResults(name, @boundary_analysis);
    
end

for i = 1:length(results_in)
    
    if ~any(cellfun(@isempty, struct2cell(results_in(i))))
    
        results(i) = boundary_analysis(results_in(i), varargin{:}, 'spike_field', 'spikes', 'input_field', 'input');
        
    end
    
%     [mod_indicator, mod_boundaries, spike_hist] = spikes_to_boundaries(results(i).spikes, results(i).time, varargin{:});
%     
%     results(i).mod_indicator = mod_indicator;
%     
%     results(i).mod_boundaries = mod_boundaries;
%     
%     results(i).spike_hist = spike_hist;
    
end

save(analysis_name, '-v7.3', 'results', 'varargin')
    
end

