function collectBoundaries(name_mat, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

%% Loading data.

names = load(name_mat);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_bands = length(bands);

for b = 1:no_bands

    x_labels{b} = sprintf('%.2g kHz', mean(bands(b, :))/1000);
    
end

gSs = get_vary_field(vary, 'gSpeech');

SIs = get_vary_field(vary, 'SentenceIndex');

tspan = sim_spec.sim_struct.tspan;

time = tspan(1):.1:tspan(2);

%% Reshaping and saving data.

all_model_data = nan(length(time), 128/length(bands), length(bands), length(gSs), length(names), length(SIs), 2);

all_boundaries = nan(length(time), length(bands), length(gSs), length(names), length(SIs), 2);

for n = 1:length(names)
    
    name = names{n};
    
    if exist([name, label, '_boundary_analysis.mat'], 'file')
        
        results = load([name, label, '_boundary_analysis.mat']);
        
        results = results.result;
        
    else
    
        data = dsImport(name);
    
        results = dsAnalyze(data, @boundary_analysis, 'save_results_flag', 1, 'result_file', [name, '_boundary_analysis.mat']);
        
    end
    
    model_data_raw(:, :, 1) = [results.spikes];
    
    model_data_raw(:, :, 2) = [results.input];
    
    model_data = reshape(model_data_raw, [length(time), 128/length(bands), size(model_data_raw, 2)/(128/length(bands)), 2]);
    
    boundaries(:, :, 1) = [results.mod_indicator];
    
    boundaries(:, :, 2) = [results.syl_indicator];
    
    gS = [results.deepRS_gSpeech];
    
    SI = [results.deepRS_SentenceIndex];
    
    for sindex = 1:length(SIs)
       
        for gspeech = 1:length(gSs)
            
            for f = 1:2
                
                all_model_data(:, :, :, gspeech, n, sindex, f) = model_data(:, :, gS == gSs(gspeech) & SI == SIs(sindex), f);
            
                all_boundaries(:, :, gspeech, n, sindex, f) = boundaries(:, gS == gSs(gspeech) & SI == SIs(sindex), f);
                
            end
            
        end
        
    end
    
end

save([name_mat(1:(end - 4)), label, '_boundaries.mat'], '-v7.3', 'all_model_data', 'all_boundaries', 'names', 'bands', 'gS', 'gSs', 'SI', 'SIs')

