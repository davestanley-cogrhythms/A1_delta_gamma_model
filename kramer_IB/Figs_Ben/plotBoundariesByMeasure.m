function plotBoundariesByMeasure(measure_name, sim_name, varargin)

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

for n = 2:length(names)
    
    name = names{n};
    
    %% Loading chosen data for this particular analysis.
    
    if exist([name, label, '_', measure_name, '_boundaries.mat'], 'file') == 2
        
        load([name, label, '_', measure_name, '_boundaries.mat'])
        
    else
        
        label0 = textscan(label, '%s', 'Delimiter', {'_syncwin'});
        label0 = label0{1}{1};
        
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
        
        save([name, label, '_', measure_name, '_boundaries.mat'], '-v7.3', 'measure_name', 'measure', 'model_data', 'boundaries', 'no_chosen', 'chosen_indices', 'bands', 'gS', 'gSs', 'Sfreq', 'Sfreqs')
        
    end
    
    %% Plotting chosen data.
    
    model_data = reshape(model_data, [length(time), 128/length(bands), 2*no_chosen, length(boundary_fields), length(gSs), length(Sfreqs)]);
    
    boundaries = reshape(boundaries, [length(time), 2*no_chosen, length(boundary_fields), length(gSs), length(Sfreqs)]);
    
    chosen_indices = squeeze(cellfun(@(x, y) cat(2, x, y), chosen_indices(1, :, :), chosen_indices(2, :, :), 'unif', 0));
    
    no_plotted = min(2, no_chosen);
    
    plotted_indices = [1:no_plotted, (2*no_chosen - no_plotted + 1):(2*no_chosen)];
    
    model_data = model_data(:, :, plotted_indices, :, :, :, :);
    
    boundaries = boundaries(:, plotted_indices, :, :, :, :);
    
    chosen_indices = cellfun(@(x) x(plotted_indices), chosen_indices, 'unif', 0);
    
    for f = 1:length(Sfreqs)
        
        figure
        
        ha = tight_subplot(length(gSs), 2*no_plotted, [.02 .01], .025, .025);
        
        for g = 1:length(gSs)
            
            for c = 1:(2*no_plotted)
                
                %% Getting syllable boundaries.
                
                syl_bounds = boundaries(:, c, 1, g, f);
                
                if ~any(isnan(syl_bounds))
                    
                    syl_times = time(logical(syl_bounds));
                    mid_syl_times = conv(syl_times, [1 1]*.5, 'valid');
                    
                    start_time = min(syl_times) - 150;
                    end_time = max(syl_times) + 150;
                    selected_time = time >= start_time & time <= end_time;
                    
                    syl_times(syl_times < 1000 & syl_times > 3250) = [];
                    
                    %% Plotting speech input.
                    
                    axes(ha((g - 1)*2*no_plotted + c)) % ((s - 1)*(no_models + 1) + 1))
                    
                    h = imagesc(time(selected_time), 1:size(model_data, 2), model_data(selected_time, :, c, 2, g, f)');
                    
                    axis xy
                    
                    colors = get(gca, 'ColorOrder');
                    
                    colormap(gca, color_gradient(64, [1 1 1], .5*[1 1 1])) %colors(2, :)))
                    
                    set(gca, 'XTick', [], 'YTick', []) % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end))%% Plotting linguistic boundaries.
                    
                    hold on
                    
                    plot([syl_times(:), syl_times(:)]', repmat(ylim, length(syl_times), 1)', '--r', 'LineWidth', 0.5)
                    
                    hold on
                    
                    plot([mid_syl_times(:), mid_syl_times(:)]', repmat(ylim, length(mid_syl_times), 1)', 'r', 'LineWidth', 0.75)
                    
                    xlim(gca, [start_time end_time])
                    
                    %% Plotting rasters.
                    
                    set(h, 'AlphaData', 0.75)
                    
                    if c == 1
                        
                        ylabel({'Input';sprintf('Gain %.2g', gSs(g))}, 'Rotation', 0)
                        
                    end
                    
                    title(sprintf('%s = %.2g', measure_name, measure(chosen_indices{g, f}(c))))
                    
                    if g == length(gSs)
                        
                        set(gca, 'FontSize', 10, 'YAxisLocation', 'right',...
                            'XTick', start_time:500:end_time, 'XTickLabel', (start_time:500:end_time)/1000) %,...
                        % 'YTick', 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end))
                        
                        xtickangle(-45)
                        
                        xlabel('Time (ms)')
                        
                    else
                        
                        set(gca, 'FontSize', 10, 'XTick', [], 'YTick', []) 
                        % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end)) % 'YTick', [])
                        
                        % ylabel('Channel (kHz)')
                        
                    end
                    
                    new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
                    set(new_ax, 'FontSize', 10);
                    
                    plot_raster(new_ax, time(selected_time), model_data(selected_time, :, c, 1, g, f), 'k');
                    
                    %% Plotting model boundaries.
                    
                    hold on
                    
                    mod_indicator = boundaries(:, c, 2, g, f);
                    
                    mod_times = time(logical(mod_indicator));
                    
                    mod_times(mod_times < start_time & mod_times > end_time) = [];
                    
                    plot([mod_times(:), mod_times(:)]', repmat(ylim, length(mod_times), 1)', 'g', 'LineWidth', 0.75)
                    
                    xlim(new_ax, [start_time end_time])
                    
                    set(new_ax, 'Visible', 'off')
                    
                end
                
            end
            
        end
        
        set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 4 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 4 8])
        
        print_name = sprintf('%s%s_%s_%s_boundaries', name, label, band_labels{f}, measure_name);
        
        save_as_pdf(gcf, print_name)
        
        saveas(gcf, [print_name, '.fig'])
        
    end
    
end

end


