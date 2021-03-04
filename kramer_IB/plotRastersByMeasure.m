function plotRastersByMeasure(measure_name, sim_name, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

%% Loading data.

if contains(sim_name, '.mat'), sim_name = sim_name(1:(end - 4)); end

names = load(sim_name);

names = names.names;

no_models = length(names);

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_bands = length(bands);

for b = 1:no_bands

    band_labels{b} = sprintf('_%.2gkHz', mean(bands(b, :))/1000);
    
end

gS = get_vary_field(vary, 'gSpeech');

gSs = unique(gS);

SI = get_vary_field(vary, 'SentenceIndex');

SIs = unique(SI);

tspan = sim_spec.sim_struct.tspan; dt = 0.1;

time = tspan(1):dt:tspan(2);

boundaries = load([sim_name, '_boundaries.mat']);

all_boundaries = boundaries.all_boundaries;

all_model_data = boundaries.all_model_data;

subplot_dims = [length(names), length(gS)];

%% Plotting speech data.

for b = 1:no_bands
    
    figure;
    
    ha = tight_subplot(no_models + 1, length(chosenSI), [.025 .025], [.15, .06], .06);
        
        for m = 1:(no_models + 1)
    
    for s = 1:length(chosenSI)
        
        syl_bounds = all_boundaries(:, b, 2, 1, s, 2);
        
        syl_times = time(logical(syl_bounds));
        
        start_time = min(syl_times) - 150;
        end_time = max(syl_times) + 150;
        selected_time = time >= start_time & time <= end_time;
        
        syl_times(syl_times < 1000 & syl_times > 3250) = [];
            
            axes(ha((m - 1)*length(chosenSI) + s)) % ((s - 1)*(no_models + 1) + 1))
            
            %% Plotting speech input.
            
            h = imagesc(time(selected_time), 1:size(all_model_data, 2), all_model_data(selected_time, :, b, 2, 1, s, 2)');
            
            axis xy
            
            colors = get(gca, 'ColorOrder');
            
            colormap(gca, color_gradient(64, [1 1 1], .5*[1 1 1])) %colors(2, :)))
            
            set(gca, 'XTick', [], 'YTick', []) % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end))
            
            %% Plotting linguistic boundaries.
            
            hold on
            
            plot([syl_times(:), syl_times(:)]', repmat(ylim, length(syl_times), 1)', 'r')
                
            xlim(gca, [start_time end_time])
            
            if m > 1
                
                %% Plotting rasters.
                
                set(h, 'AlphaData', 0.75)
                
                if m == no_models + 1
                    
                    set(gca, 'FontSize', 12, 'YAxisLocation', 'right', 'XTick', start_time:500:end_time, 'XTickLabel', (start_time:500:end_time)/1000) %,...
                        % 'YTick', 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end))
                    
                    %xtickangle(-45)
                    
                    ylabel('Channel (kHz)')
                    
                    xlabel('Time (s)')
                    
                else
                    
                    set(gca, 'XTick', [], 'YTick', []) % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end)) % 'YTick', [])
                    
                    % ylabel('Channel (kHz)')
                    
                end
                
                new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
                set(new_ax, 'FontSize', 12);
                
                plot_raster(new_ax, time(selected_time), all_model_data(selected_time, :, b, 2, m - 1, s, 1), 'k');
                
                %% Plotting model boundaries.
                
                hold on
                
                if recalculate_flag
                    
                    mod_indicator = spikes_to_boundaries(all_model_data(:, :, b, 2, m - 1, s, 1), time, varargin{:});
                    
                else
                
                    mod_indicator = all_boundaries(:, b, 2, m - 1, s, 1);
                    
                end
                
                mod_times = time(logical(mod_indicator));
                
                mod_times(mod_times < start_time & mod_times > end_time) = [];
                
                plot([mod_times(:), mod_times(:)]', repmat(ylim, length(mod_times), 1)', 'g')
                
                xlim(new_ax, [start_time end_time])
                
                set(new_ax, 'Visible', 'off')
                
            end
            
        end
        
        set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 4 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 4 8])
        
        saveas(gcf, sprintf('%s%s%s_boundaries.fig', sim_name, label, band_labels{b}))
        
    end
    
end

end