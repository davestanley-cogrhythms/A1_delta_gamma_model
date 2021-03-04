function collectBoundariesByMeasure(measure_name, sim_name, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

%% Loading data.

sim_mat = load(sim_name);

names = sim_mat.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_bands = length(bands);

for b = 1:no_bands
    
    band_labels{b} = sprintf('%.2g kHz', mean(bands(b, :))/1000);
    
end

% gSs = get_vary_field(vary, 'gSpeech');
% 
% SIs = get_vary_field(vary, 'SentenceIndex');
% 
% Shighs = get_vary_field(vary, 'SpeechHighFreq');
% % Slows = get_vary_field(vary, 'SpeechLowFreq');
% Sfreqs = mean(Shighs);

tspan = sim_spec.sim_struct.tspan;

time = tspan(1):.1:tspan(2);

%% Reshaping and saving data.

no_chosen = 5;

data_fields = {'spikes', 'input'};

boundary_fields = {'syl_indicator', 'mod_indicator'};

for n = 3:length(names)
    
    name = names{n};
    
    %% Loading chosen data for this particular analysis.
    
    label0 = split(label, {'_syncwin', '_vpnorm'});
    label0 = label0{1};
    
    if exist([name, label, '_boundary_analysis.mat'], 'file') == 2
        
        results = load([name, label, '_boundary_analysis.mat']);
        
        if any(strcmp(fieldnames(results), 'result'))
            
            results = results.result;
            
        elseif any(strcmp(fieldnames(results), 'results'))
            
            results = results.results;
            
        end
    
    if exist([name, label0, '_boundary_analysis.mat'], 'file') == 2
        
        results = load([name, label0, '_boundary_analysis.mat']);
        
        if any(strcmp(fieldnames(results), 'result'))
            
            results = results.result;
            
        elseif any(strcmp(fieldnames(results), 'results'))
            
            results = results.results;
            
        end
        
    else
        
        try
            
            data = dsImport(name);
            
            results = dsAnalyze(data, @boundary_analysis, 'function_options', varargin,...
                'save_results_flag', 1, 'result_file', [name, '_boundary_analysis.mat']);
            
        catch
            
            posthoc_boundary_analysis_wrapper(name, varargin{:})
            
            results = load([name, label, '_boundary_analysis.mat']);
            
            if any(strcmp(fieldnames(results), 'result'))
                
                results = results.result;
                
            elseif any(strcmp(fieldnames(results), 'results'))
                
                results = results.results;
                
            end
            
        end
        
    end
    
    if exist([name, label, '_', measure_name, '.mat'], 'file') == 2
        
        measure = load([name, label, '_', measure_name, '.mat']);
        
        measure = measure.(measure_name);
        
    else
        
        measure = [results.(measure_name)];
        
    end
    
    %% Loading simulation parameters.
    
    if ~any(contains(fieldnames(results), 'deepRS_SentenceIndex'))
        
        results0 = load([name, '_boundary_analysis.mat']);
        
        results0 = results0.results;
        
    else
        
        results0 = results;
        
    end
    
    SI = [results0.deepRS_SentenceIndex];
    SIs = unique(SI);
    
    gS = [results0.deepRS_gSpeech];
    gSs = unique(gS);
    
    Shigh = [results0.deepRS_SpeechHighFreq];
    Slow = [results0.deepRS_SpeechLowFreq];
    Sfreq = (Shigh + Slow)/2;
    Sfreqs = unique(Sfreq);
    
    time = results0(1).time;
    
    %% Retrieving chosen data.
    
    chosen_indices = cell(2, length(gSs), length(Sfreqs));
    
    model_data = nan(length(time), 128/length(bands), no_chosen, 2, length(data_fields), length(gSs), length(Sfreqs));
    
    boundaries = nan(length(time), no_chosen, 2, length(boundary_fields), length(gSs), length(Sfreqs));
    
    for f = 1:length(Sfreqs)
        
        for g = 1:length(gSs)
            
            Sfreq_index = find(Sfreq == Sfreqs(f) & gS == gSs(g));
            
            if ~isempty(measure(Sfreq_index))
                
                [measure_sorted, measure_index] = sort(measure(Sfreq_index));
                
                measure_index(isnan(measure_sorted)) = [];
                
                low_indices = Sfreq_index(measure_index(1:min(no_chosen, end)));
                
                chosen_indices{1, g, f} = low_indices;
                
                high_indices = Sfreq_index(measure_index(max(1, end - no_chosen + 1):end));
                
                chosen_indices{2, g, f} = high_indices;
                
                for side = 1:2
                    
                    these_indices = chosen_indices{side, g, f};
                    
                    for field = 1:length(data_fields)
                        
                        this_model_data = fill_struct_empty_field(results(these_indices), data_fields{field}, nan);
                        
                        this_model_data = reshape(this_model_data(1:(length(time)*length(these_indices)), :),...
                            [length(time), length(these_indices), 128/length(bands)]);
                        
                        this_model_data = permute(this_model_data, [1 3 2]);
                        
                        model_data(:, :, 1:length(these_indices), side, field, g, f) = this_model_data;
                        
                    end
                    
                    for field = 1:length(boundary_fields)
                        
                        this_boundaries = fill_struct_empty_field(results(chosen_indices{side, g, f}), boundary_fields{field}, nan);
                        
                        this_boundaries = reshape(this_boundaries(1:(length(time)*length(these_indices)), :),...
                            [length(time), length(these_indices)]);
                        
                        boundaries(:, 1:length(these_indices), side, field, g, f) = this_boundaries;
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
    save([name, label, '_', measure_name, '_boundaries.mat'], '-v7.3', 'measure_name', 'measure', 'model_data', 'boundaries', 'no_chosen', 'chosen_indices', 'bands', 'SI', 'SIs', 'gS', 'gSs', 'Sfreq', 'Sfreqs')
    
end

end
