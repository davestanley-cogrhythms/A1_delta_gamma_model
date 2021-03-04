function makeSegmentationFigureOptimized(sim_name, vp_norm) % synchrony_window, vpnorm, 

thresholds = fliplr([.667, .6, .55, .5, .45, .4, .333]);

sum_windows = 25:5:75;

sim_struct = load(sim_name);

names = sim_struct.names;

suffix = sprintf('_vpnorm%d_optimized', vp_norm); 

%% Loading vpdist measure.

% if exist(sprintf('%s_all_vpdist_norm_%d.mat', sim_name, vp_norm), 'file') == 2
%     
%     load(sprintf('%s_all_vpdist_norm_%d.mat', sim_name, vp_norm))
%     
% else
    
    varargin = {'threshold', thresholds(1), 'sum_window', sum_windows(1), 'synchrony_window', 50, 'vp_norm', vp_norm};
    
    boundary_defaults %% See boundary_defaults.m, which is a script, not a function.
    
    load([names{1}, label, '_vpdist.mat'])
    
    [all_vpdist, all_vpdist_noinput] = deal(nan([size(meanlogVPdist), length(sum_windows), length(thresholds), length(names)]));
    
    for s = 1:length(sum_windows)
        
        for t = 1:length(thresholds)
            
            %% Defaults & arguments.
            
            varargin = {'threshold', thresholds(t), 'sum_window', sum_windows(s), 'synchrony_window', 50, 'vp_norm', vp_norm};
            
            boundary_defaults %% See boundary_defaults.m, which is a script, not a function.
            
            for m = 1:length(names)
                
                vpdist_mat = load([names{m}, label, '_vpdist.mat']);
                
                this_vpdist = vpdist_mat.meanlogVPdist;
                
                % this_vpdist = this_vpdist - ones(size(this_vpdist))*diag(this_vpdist(1, :));
                
                all_vpdist_noinput(:, :, s, t, m) = ones(size(this_vpdist))*diag(this_vpdist(1, :));
                
                all_vpdist(:, :, s, t, m) = this_vpdist;
                
            end
            
        end
        
    end
    
    if size(all_vpdist, 1) > 1 && size(all_vpdist, 2) > 1
        
        min_vpdist = squeeze(min(min(all_vpdist), [], 2)); % squeeze(mean(mean(all_vpdist, 2)));
        
    else
        
        min_vpdist = squeeze(all_vpdist);
        
    end
    
    [~, s_for_min] = min(min(min_vpdist, [], 2));
    s_for_min = squeeze(s_for_min);
    
    [~, t_for_min] = min(squeeze(min(min_vpdist)));
    t_for_min = squeeze(t_for_min);
    
    for m = 1:length(names)
        
        [~, g_for_min(m)] = min(min(all_vpdist(:, :, s_for_min(m), t_for_min(m), m), [], 2));
        
        [~, f_for_min(m)] = min(min(all_vpdist(:, :, s_for_min(m), t_for_min(m), m)), [], 2);
        
    end
    
    save(sprintf('%s_all_vpdist_norm_%d.mat', sim_name, vp_norm), 'all_vpdist',...
        'all_vpdist_noinput', 's_for_min', 't_for_min', 'g_for_min', 'f_for_min',...
        'sum_windows', 'thresholds', 'names', 'gSs', 'Sfreqs')
    
% end

%% Plotting vpdist.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

rows = length(names); columns = 1; % rows = length(names); % columns = 1;

figure

ha = tight_subplot(rows, columns, [.025, .025], [.1, .05], [.15, .175]);

gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));

gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);

vpdist_for_plot = nan([length(gSs), length(Sfreqs), length(names)]);

for m = 1:length(names)
    
    vpdist_for_plot(:, :, m) = all_vpdist(:, :, s_for_min(m), t_for_min(m), m); %,...
        % all_vpdist_noinput(:, :, s_for_min(m), t_for_min(m), m)); % max(0, -all_vpdist(2:end, :, :));
    
end

vpdist_range = [all_dimensions(@min, vpdist_for_plot), all_dimensions(@max, vpdist_for_plot)];
    
cmap = colormap('parula');
    
for m = 1:length(names)
    
    axes(ha(m))
    
    imagesc(Sfreqs, gSs, vpdist_for_plot(:, :, m)) % 1./all_vpdist(:, :, m))
    
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

saveas(gcf, [sim_name, suffix, '.fig'])

print(gcf, '-painters', '-depsc', '-r600', [sim_name, suffix, '.eps'])

%% Plotting across thresholds.

vpdist_for_plot = nan([length(gSs), length(Sfreqs), length(thresholds), length(names)]);

for t = 1:length(thresholds)
    
    for m = 1:length(names)
        
        vpdist_for_plot(:, :, t, m) = all_vpdist(:, :, 1, t, m); % ,...
            % all_vpdist_noinput(:, :, end, t, m)); % max(0, -all_vpdist(2:end, :, :));
        
    end
    
end

vpdist_range = [all_dimensions(@min, vpdist_for_plot), all_dimensions(@max, vpdist_for_plot)];

figure

thresholds_for_plot = thresholds(1:2:end);

no_t4plot = length(thresholds_for_plot);


ha = tight_subplot(length(names), no_t4plot, [.025, .025], [.1, .05], [.15, .15]);

for t = 1:no_t4plot
    
    for m = 1:length(names)
        
        axes(ha((m - 1)*no_t4plot + t))
        
        imagesc(Sfreqs, gSs, vpdist_for_plot(:, :, 2*t - 1, m)) % 1./all_vpdist(:, :, m))
        
        colormap(gca, flipud(cmap))
        
        axis xy
        
        caxis(sort(vpdist_range)) % sort(1./vpdist_range))
        
        if m == length(names)
                
            set(gca, 'XTick', [], 'YTick', [])
            
            if t == 1
                
                x_lims = xlim;
                
                x_ticks = (x_lims(1):diff(x_lims)/length(Sfreqs):x_lims(2)) + diff(x_lims)/(2*length(Sfreqs));
                
                y_lims = ylim;
                
                y_ticks = (y_lims(1):diff(y_lims)/length(gSs):y_lims(2)) + diff(y_lims)/(2*length(gSs));
                
                set(gca, 'Ytick', y_ticks(1:4:end), 'YTickLabel', gSs(1:4:end),...
                    'XTick', x_ticks(1:2:end), 'XTickLabel', round(Sfreqs(1:2:end)/1000, 2),...
                    'FontSize', 12)
                
                xtickangle(-45)
                
                xlabel('Input Center Freq. (kHz)')
                
                ylabel('Input Gain')
                
            elseif t == no_t4plot
                
                nochange_colorbar(gca)
                
            end
            
        else
            
            set(gca, 'YTick', [], 'XTick', [])
            
        end
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 9 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 9 8])

thresh_plot_name = sprintf('%s_sumwin_75_vpnorm_%d_by_threshold', sim_name, vp_norm);

saveas(gcf, [thresh_plot_name, '.fig'])

print(gcf, '-painters', '-depsc', '-r600', [thresh_plot_name, '.eps'])

%% Loading histograms.

for m = 1:length(names)
    
    varargin = {'threshold', thresholds(t_for_min(m)), 'sum_window', sum_windows(s_for_min(m)), 'synchrony_window', 50, 'vp_norm', vp_norm};
    
    boundary_defaults %% See boundary_defaults.m, which is a script, not a function.
    
    if exist([names{m}, label, '_boundary_phoneme_histograms.mat'], 'file') ~= 2
        
        posthocBoundaryPhones(names{m}, varargin{:})
        
    end
    
end

sim_spec = load([names{1}, '_sim_spec.mat']);

SIs = get_vary_field(sim_spec.vary, 'SentenceIndex');

midsylBPhists = load(sprintf('midsylBPhistograms_%dsentences.mat', length(SIs)));
midsylBPhists = [midsylBPhists.hists(:, 1) midsylBPhists.hists_norm(:, 1)];

load(sprintf('%s_thresh_%.2g_sumwin_%d_vpnorm_3_boundary_phoneme_histograms.mat', names{1}, thresholds(t_for_min(1)), sum_windows(s_for_min(1))))

all_hists = nan([size(hists, 1), size(hists, 2) + 0, size(hists, 3), length(names), 2]);

for m = 1:length(names)
    
    varargin = {'threshold', thresholds(t_for_min(m)), 'sum_window', sum_windows(s_for_min(m)), 'synchrony_window', 50, 'vp_norm', vp_norm};
    
    boundary_defaults %% See boundary_defaults.m, which is a script, not a function.
    
    load([names{m}, label, '_boundary_phoneme_histograms.mat'])
    
    % all_hists(:, 1, :, m, 1) = repmat(midsylBPhists(:, 1), [1 1 size(all_hists, 3)]);
    
    all_hists(:, 0 + (1:size(hists, 2)), :, m, 1) = hists;
    
    % all_hists(:, 1, :, m, 2) = repmat(midsylBPhists(:, 2), [1 1 size(all_hists, 3)]);
    
    hists_norm = nan(size(hists));
    
    for k = 1:size(hists, 3)
        
        hists_norm(:, :, k) = hists(:, :, k)*diag(1./sum(hists(:, :, k)));
        
    end
    
    all_hists(:, 0 + (1:size(hists_norm, 2)), :, m, 2) = hists_norm;
    
end

save([sim_name, suffix, '_BPhistograms.mat'], 'all_hists', 'gSs', 'names', 'Sfreqs')

%% Plotting histograms.

bars = length(gSs); rows = length(names); columns = 1; % rows = length(Sfreqs); columns = length(names);

fig_labels = {'', '_pdfnorm'};

[~, Sfreq_index] = min(abs(Sfreqs - 300));

for f = 1:length(fig_labels)
    
    figure
    
    ha = tight_subplot(rows, columns, [.025, .025], [.1, .05], [.15, .175]);
    
    % colors = cool(bars - 1);
    
    gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));
    
    gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);
    
    histmax = all_dimensions(@max, all_hists(:, 1:end, :, :, f));
    
    for i = 1:rows
        
        for j = 1:columns
            
            axes(ha((i - 1)*columns + j))
            
            % set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
            
            insertion = [midsylBPhists(:, f)'; nan(size(midsylBPhists(:, f)'))];
            
            imagesc([insertion; all_hists(:, 1:end, f_for_min(i), i, f)']) % bar(all_hists(:, 2:end, i, j, f))
            
            axis xy
            
            cmap = colormap('hot');
            
            colormap(gca, cmap) % flipud(cmap))
            
            box off
            
            set(gca, 'XTickLabel', '')
            
            caxis([0 histmax])
            
            % set(gca, 'YTick', [0 histmax], 'YTickLabel', [0 histmax])
            
            if i == rows
                
                x_lims = xlim(gca);
                
                x_interval = range(x_lims)/size(all_hists, 1);
                
                x_ticks = (min(x_lims):x_interval:max(x_lims)) + x_interval/2;
                
                set(gca, 'FontSize', 12, 'XTick', x_ticks, 'XTickLabel', class_names)
                
                xtickangle(-45)
                
                %             elseif i == 1 && j == 1
                %
                %                 % legend(gS_legend(2:end))
                %
                %             end
                %
                %             if j == 1
                
                ylabel('Input Gain') % {'Input Freq.'; sprintf('%.2g kHz', Sfreqs(i)/1000)}, 'Rotation', 0)
                
                y_lims = ylim(gca);
                
                y_interval = range(y_lims)/(size(all_hists, 2) + 2);
                
                y_ticks = ((min(y_lims) + 2*y_interval):(2*y_interval):max(y_lims)) + y_interval/2;
                
                set(gca, 'YTick', y_ticks, 'YTickLabel', gSs(1:2:end))
                
                nochange_colorbar(gca)
                
            else
                
                set(gca, 'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', [])
                
            end
            
        end
        
    end
    
    fig_suffix = sprintf('%s_optimized_BPfig', fig_labels{f});

    set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 2 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 2 8])
    
    saveas(gcf, [sim_name, fig_suffix, '.fig'])
    
    print(gcf, '-painters', '-depsc', '-r600', [sim_name, fig_suffix, '.eps'])
    
end

end