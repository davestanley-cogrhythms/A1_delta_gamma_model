function plotSegmentationTracesOptimized(sim_name, vp_norm)

thresholds = fliplr([.667, .6, .55, .5, .45, .4, .333]);

sum_windows = 25:5:75;

sim_struct = load(sim_name);

names = sim_struct.names;

opti_struct = load(sprintf('%s_all_vpdist_norm_%d.mat', sim_name, vp_norm)); 
s_for_min = opti_struct.s_for_min;
t_for_min = opti_struct.t_for_min;
g_for_min = opti_struct.g_for_min;
f_for_min = opti_struct.f_for_min;

%% Plotting chosen data.
        
no_plotted = 1;

data_fields = {'spikes', 'input'};

boundary_fields = {'syl_indicator', 'mod_indicator'};

CF = 440 * 2 .^ ((-30:97)/24 - 1);

figure

ha = tight_subplot(2*length(names), 2*no_plotted, [.01, .01], .05, .05);
    
boundary_fields = {'syl_boundaries', 'mid_syl_boundaries', 'mod_boundaries'};

for m = 1:length(names)
    
    name = names{m};
    
    %% Loading data.
    
    varargin = {'threshold', thresholds(t_for_min(m)), 'sum_window', sum_windows(s_for_min(m)), 'synchrony_window', 50, 'vp_norm', vp_norm};
    
    boundary_defaults %% See boundary_defaults.m, which is a script, not a function.
    
    results_struct = load([name, '_boundary_analysis.mat']);
    results = results_struct.results;
    
    time = results(1).time;
    
    vpdist_struct = load([name, label, '_vpdist.mat']);
    
    vpdist = vpdist_struct.vpdist;
    gS = vpdist_struct.gS;
    gSs = vpdist_struct.gSs;
    Sfreq = vpdist_struct.Sfreq;
    Sfreqs = vpdist_struct.Sfreqs;
    
    %% Finding indices for min/max vpdist.
    
    this_indicator = gS == gSs(g_for_min(m)) & Sfreq == Sfreqs(f_for_min(m));
    these_indices = find(this_indicator);
    
    this_vpdist = vpdist(this_indicator);
    
    [~, min_indicator] = min(this_vpdist);
    [~, max_indicator] = max(this_vpdist);
    
    min_index = these_indices(min_indicator);
    max_index = these_indices(max_indicator);
    
    %% Collecting boundaries & speech data.
    
    for f = 1:length(boundary_fields)
    
        boundaries(f, :) = vpdist_struct.(boundary_fields{f})([min_index, max_index]);
        
    end
    
    spikes = reshape([results([min_index, max_index]).spikes], [size(results(1).spikes), 2]);
    
    input = reshape([results([min_index, max_index]).input], [size(results(1).spikes), 2]);
    
    for c = 1:(2*no_plotted)
        
        %% Getting syllable boundaries.
        
        syl_times = boundaries{1, c};
        
        if ~isempty(syl_times)
            
            % syl_times = time(logical(syl_bounds));
            mid_syl_times = boundaries{2, c};
            
            start_time = min(syl_times) - 150;
            end_time = max(syl_times) + 150;
            selected_time = time >= start_time & time <= end_time;
            
            syl_times(syl_times < start_time & syl_times > end_time) = [];
            
            %% Plotting speech input.
            
            axes(ha(2*(m - 1)*2*no_plotted + c)) % ((s - 1)*(no_models + 1) + 1))
            
            h = imagesc(time(selected_time), 1:size(input, 2), input(selected_time, :, c)');
            
            axis xy
            
            box off
            
            % colors = get(gca, 'ColorOrder');
            
            colormap(gca, color_gradient(64, [1 1 1], .35*[1 1 1])) %colors(2, :)))
            
            hold on
            
            plot([syl_times(:), syl_times(:)]', repmat(ylim, length(syl_times), 1)', '--r', 'LineWidth', 0.5)
            
            hold on
            
            plot([mid_syl_times(:), mid_syl_times(:)]', repmat(ylim, length(mid_syl_times), 1)', 'r', 'LineWidth', 1)
            
            set(gca, 'XAxisLocation', 'top', 'XTick', [], 'YTick', []) % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end))%% Plotting linguistic boundaries.
            
            xlim(gca, [start_time end_time])
            
            %% Plotting rasters.
            
            axes(ha((2*m - 1)*2*no_plotted + c))
            
            new_ax = gca;
            
            % set(h, 'AlphaData', 0.75)
            %
            % new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
            % set(new_ax, 'FontSize', 10);
            
            plot_raster(new_ax, time(selected_time), spikes(selected_time, :, c), .35*[1 1 1]);
            
            %% Plotting model boundaries.
            
            hold on
            
            mod_times = boundaries{3, c};
            
            % mod_times = time(logical(mod_indicator));
            
            mod_times(mod_times < start_time & mod_times > end_time) = [];
            
            plot([mod_times(:), mod_times(:)]', repmat(ylim, length(mod_times), 1)', 'g', 'LineWidth', 1)
            
            xlim(new_ax, [start_time end_time])
            
            set(gca, 'FontSize', 12, 'YTick', [], 'XTick', [])
            
            trace_y_labels = CF((f_for_min(m) - 1)*16 + (1:16));
            
            % set(new_ax, 'Visible', 'off')
            
            if c == 2
                
                set(gca, 'FontSize', 10,... 'YAxisLocation', 'right',...
                    'YTick', [1, length(trace_y_labels)], 'YTickLabel', round(10*trace_y_labels([1, end]))/10)
                
                ylabel('Freq. (Hz)')
                
            end
            
            if m == length(names)
                
                xlabel('Time (s)')
                
            end
            
            set(gca, 'FontSize', 10,...
                'XTick', start_time:500:end_time, 'XTickLabel', round((start_time:500:end_time)/100)/10)
            
            % xtickangle(-45)
            
            % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end)) % 'YTick', [])
            
            % ylabel('Channel (kHz)')
            
        end
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 7 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 7 8])

print_name = sprintf('%s_all_vpdist_norm_%d_traces', sim_name, vp_norm);

saveas(gcf, [print_name, '.fig'])

print(gcf, '-painters', '-depsc', '-r600', [print_name, '.eps'])

end