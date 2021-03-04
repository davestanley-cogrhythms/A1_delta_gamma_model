function plotSegmentationTraces(sim_name, varargin) % synchrony_window, vpnorm, 

%% Defaults & arguments.

if nargin == 1
    
    varargin = {'threshold', .667, 'sum_window', 75, 'synchrony_window', 50, 'vp_norm', 1};

    boundary_defaults %% See boundary_defaults.m, which is a script, not a function.
    
elseif strcmp(varargin{1}, 'suffix')
    
    label = varargin{2};
    
end

suffix = '_segmentation'; 

sim_struct = load(sim_name);

names = sim_struct.names;

%% Checking analysis files exist.

for n = 1:length(names)
    
    if exist([names{n}, label, '_vpdist.mat']) ~= 2
        
        if exist([names{n}, label, '_boundary_analysis.mat'], 'file') == 2
            
            plotVPdist(names{n}, varargin{:})
            
        else
            
            posthoc_boundary_analysis_wrapper(names{n}, varargin{:})
            
            plotVPdist(names{n}, varargin{:})
            
        end
        
    end
    
end

%% Loading vpdist measure.

load([names{1}, label, '_vpdist.mat'])

all_vpdist = nan([size(meanVPdist), length(names)]);

for n = 1:length(names)
    
    vpdist_mat = load([names{n}, label, '_vpdist.mat']);
    
    this_vpdist = vpdist_mat.meanVPdist;
    
    % this_vpdist = this_vpdist - ones(size(this_vpdist))*diag(this_vpdist(1, :)); 
    
    all_vpdist_noinput(:, :, n) = ones(size(this_vpdist))*diag(this_vpdist(1, :));
    
    all_vpdist(:, :, n) = this_vpdist;
    
end

%% Plotting vpdist.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

rows = length(names); columns = 1; % rows = length(names); % columns = 1;

figure

ha = tight_subplot(rows, columns, [.025, .025], [.1, .05], [.15, .175]);

gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));

gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);

vpdist_for_plot = min(all_vpdist, all_vpdist_noinput); % max(0, -all_vpdist(2:end, :, :));

vpdist_range = [all_dimensions(@min, vpdist_for_plot), all_dimensions(@max, vpdist_for_plot)];
    
for m = 1:length(names)
    
    axes(ha(m))
    
    imagesc(Sfreqs, gSs, vpdist_for_plot(:, :, m)) % 1./all_vpdist(:, :, m))
    
    cmap = colormap('parula');
    
    colormap(gca, flipud(cmap))
    
    axis xy
    
    caxis(sort(vpdist_range)) % sort(1./vpdist_range))
    
    if m == length(names)
        
        x_lims = xlim;
        
        x_ticks = (x_lims(1):diff(x_lims)/length(Sfreqs):x_lims(2)) + diff(x_lims)/(2*length(Sfreqs));
        
        set(gca,... 'Ytick', gSs(2:2:end), 'YTickLabel', gSs(2:2:end),...
            'XTick', x_ticks, 'XTickLabel', round(Sfreqs/1000, 2),...
            'FontSize', 12)
        
        xtickangle(-45)
        
        xlabel('Input Center Freq. (kHz)')
        
        ylabel('Input Gain')
        
        nochange_colorbar(gca)
        
    else
        
        set(gca, 'YTick', [], 'XTick', [])
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 2.5 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 2.5 8])

saveas(gcf, [sim_name, label, suffix, '.fig'])

print(gcf, '-painters', '-depsc', '-r600', [sim_name, label, suffix, '.eps'])

%% Plotting chosen data.
        
no_plotted = 1;

data_fields = {'spikes', 'input'};

boundary_fields = {'syl_indicator', 'mod_indicator'};

[~, f_for_plot] = min(squeeze(min(all_vpdist)));
[~, g_for_plot] = min(squeeze(min(all_vpdist, [], 2)));

fig_types = {'_bymean', ''};

CF = 440 * 2 .^ ((-30:97)/24 - 1);

for fig_type = 1:length(fig_types)
    
    figure
    
    ha = tight_subplot(2*length(names), 2*no_plotted, [.05, .05], .05, .05);
    
    for m = 1:length(names)
        
        name = names{m};
        
        %% Loading simulation parameters.
        
        results0 = load([name, '_boundary_analysis.mat']);
        
        results0 = results0.results;
        
        SI = [results0.deepRS_SentenceIndex];
        SIs = unique(SI);
        
        gS = [results0.deepRS_gSpeech];
        gSs = unique(gS);
        
        Shigh = [results0.deepRS_SpeechHighFreq];
        Slow = [results0.deepRS_SpeechLowFreq];
        Sfreq = (Shigh + Slow)/2;
        Sfreqs = unique(Sfreq);
        
        time = results0(1).time;
        
        %% Loading boundaries.
        
        load([name, label, '_vpdist_boundaries.mat'])
        
        model_data = reshape(model_data, [size(model_data, 1), 128/length(bands), 2*no_chosen, length(boundary_fields), length(gSs), length(Sfreqs)]);
        
        boundaries = reshape(boundaries, [size(model_data, 1), 2*no_chosen, length(boundary_fields), length(gSs), length(Sfreqs)]);
        
        chosen_indices = squeeze(cellfun(@(x, y) cat(2, x, y), chosen_indices(1, :, :), chosen_indices(2, :, :), 'unif', 0));
        
        no_plotted = min(no_plotted, no_chosen);
        
        plotted_indices = [1:no_plotted, (2*no_chosen - no_plotted + 1):(2*no_chosen)];
        
        model_data = model_data(:, :, plotted_indices, :, :, :, :);
        
        boundaries = boundaries(:, plotted_indices, :, :, :, :);
        
        chosen_indices = cellfun(@(x) x(plotted_indices), chosen_indices, 'unif', 0);
        
        % [~, f] = min(abs(Sfreqs - 300));
        
        if fig_type == 1
            
            f = f_for_plot(m)*ones(1, 2*no_plotted);
            g = g_for_plot(m)*ones(1, 2*no_plotted);
            
        else
            
            min_vp = cell2mat(cellfun(@(x) min(measure(x)), chosen_indices, 'unif', 0));
            
            gS_indices = 2:length(gSs);
            [~, f_for_min_vp] = min(min(min_vp(gS_indices, :))); % (end - 3):end, :)));
            [~, g_for_min_vp] = min(min(min_vp(gS_indices, :), [], 2)); % (end - 3):end, :)'));
            g_for_min_vp = g_for_min_vp + min(gS_indices) - 1;
            
            max_vp = cell2mat(cellfun(@(x) max(measure(x)), chosen_indices, 'unif', 0));
            
            [~, f_for_max_vp] = max(max(max_vp(gS_indices, :))); % (end - 3):end, :)));
            [~, g_for_max_vp] = max(max(max_vp(gS_indices, :), [], 2)); % (end - 3):end, :)'));
            g_for_max_vp = g_for_max_vp + min(gS_indices) - 1;
            
            f = [f_for_min_vp*ones(1, no_plotted), f_for_max_vp*ones(1, no_plotted)];
            
            g = [g_for_min_vp*ones(1, no_plotted), g_for_max_vp*ones(1, no_plotted)];
            
        end
        
        for c = 1:(2*no_plotted)
            
            %% Getting syllable boundaries.
            
            syl_bounds = boundaries(:, c, 1, g(c), f(c));
            
            if ~isempty(syl_bounds)
                
                syl_times = time(logical(syl_bounds));
                mid_syl_times = conv(syl_times, [1 1]*.5, 'valid');
                
                start_time = min(syl_times) - 150;
                end_time = max(syl_times) + 150;
                selected_time = time >= start_time & time <= end_time;
                
                syl_times(syl_times < start_time & syl_times > end_time) = [];
                
                %% Plotting speech input.
                
                axes(ha(2*(m - 1)*2*no_plotted + c)) % ((s - 1)*(no_models + 1) + 1))
                
                h = imagesc(time(selected_time), 1:size(model_data, 2), model_data(selected_time, :, c, 2, g(c), f(c))');
                
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
                
                plot_raster(new_ax, time(selected_time), model_data(selected_time, :, c, 1, g(c), f(c)), .35*[1 1 1]);
                
                %% Plotting model boundaries.
                
                hold on
                
                mod_indicator = boundaries(:, c, 2, g(c), f(c));
                
                mod_times = time(logical(mod_indicator));
                
                mod_times(mod_times < start_time & mod_times > end_time) = [];
                
                plot([mod_times(:), mod_times(:)]', repmat(ylim, length(mod_times), 1)', 'g', 'LineWidth', 1)
                
                xlim(new_ax, [start_time end_time])
                
                set(gca, 'FontSize', 12, 'YTick', [], 'XTick', [])
                
                trace_y_labels = CF((f(c) - 1)*16 + (1:16));
                
                % set(new_ax, 'Visible', 'off')
                
                if c == 1 || fig_type == 2 % m == length(names)
                    
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
    
    print_name = sprintf('%s%s%s_traces', sim_name, label, suffix, fig_types{fig_type});
    
    saveas(gcf, [print_name, '.fig'])
    
    print(gcf, '-painters', '-depsc', '-r600', [print_name, '.eps'])
    
end

end