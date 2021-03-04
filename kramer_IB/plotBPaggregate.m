function plotBPaggregate(sim_name, varargin)

sim_mat = load(sim_name);

sim_name = sim_mat.sim_name;

names = sim_mat.names;

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

%% Ensuring histogram files exist.

for n = 1:length(names)
    
    if exist([names{n}, label, '_boundary_phoneme_histograms.mat'], 'file') ~= 2
        
        label_no_vp_params = split(label, {'_syncwin', '_vpnorm'});
        label_no_vp_params = label_no_vp_params{1};
        
        if exist([names{n}, label, '_boundary_phonemes.mat'], 'file') ~= 2
            
            if exist([names{n}, label, '_boundary_analysis.mat'], 'file') == 2
                
                system(sprintf('cp %s%s_boundary_analysis.mat %s%s_boundary_phonemes.mat', names{n}, label, names{n}, label))
                
            elseif exist([names{n}, label_no_vp_params, '_boundary_analysis.mat'], 'file') == 2 
                
                system(sprintf('cp %s%s_boundary_analysis.mat %s%s_boundary_phonemes.mat', names{n}, label_no_vp_params, names{n}, label))
                
            else
                
                fprintf(sprintf('Results file not available for %s.\n', name))
                
            end
            
        end
            
        plotBoundaryPhones(names{n}, [], [], varargin{:})
        
    end
    
end

%% Loading, collecting, & normalizing histograms.

load([names{1}, label, '_boundary_phoneme_histograms.mat'])

all_hists = nan([size(hists), length(names), 2]);

for n = 1:length(names)
    
    load([names{n}, label, '_boundary_phoneme_histograms.mat'])
    
    all_hists(:, :, :, n, 1) = hists;
    
    hists_norm = nan(size(hists));
    
    for k = 1:size(hists, 3)
        
        hists_norm(:, :, k) = hists(:, :, k)*diag(1./sum(hists(:, :, k)));
        
    end
    
    all_hists(:, :, :, n, 2) = hists_norm;
    
end

%% Plotting histograms.

bars = length(gSs); rows = length(Sfreqs); columns = length(names);

fig_labels = {'', '_pdfnorm'};

for f = 1:length(fig_labels)
    
    figure
    
    ha = tight_subplot(rows, columns);
    
    colors = cool(bars - 1);
    
    gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));
    
    gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);
    
    histmax = all_dimensions(@max, all_hists(:, 2:end, :, :, f));
    
    for i = 1:rows
        
        for j = 1:columns
            
            axes(ha((i - 1)*columns + j))
            
            % set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
            
            imagesc(all_hists(:, 2:end, i, j, f)') % bar(all_hists(:, 2:end, i, j, f))
            
            axis xy
            
            cmap = colormap('cool');
            
            colormap(gca, cmap) % flipud(cmap))
            
            box off
            
            set(gca, 'XTickLabel', '')
            
            caxis([0 histmax])
            
            % set(gca, 'YTick', [0 histmax], 'YTickLabel', [0 histmax])
            
            if i == rows
                
                x_lims = xlim(gca);
                
                x_interval = range(x_lims)/size(all_hists, 1);
                
                x_ticks = (min(x_lims):(x_interval):max(x_lims)) + x_interval/2;
                
                set(gca, 'XTick', x_ticks, 'XTickLabel', class_names)
                
                xtickangle(-45)
                
            elseif i == 1 && j == 1
                
                % legend(gS_legend(2:end))
                
            end
            
            if j == 1
                
                ylabel({'Input Freq.'; sprintf('%.2g kHz', Sfreqs(i)/1000)}, 'Rotation', 0)
                
                y_lims = xlim(gca);
                
                y_interval = range(y_lims)/size(all_hists, 1);
                
                y_ticks = (min(y_lims):(y_interval):max(y_lims)) + y_interval/2;
                
                set(gca, 'YTick', y_ticks, 'YTickLabel', gSs)
                
            else
                
                set(gca, 'YTick', [], 'YTickLabel', [])
                
            end
            
        end
        
    end
    
    fig_suffix = sprintf('%s_BPhist', fig_labels{f});
    
    saveas(gcf, [sim_name, label, fig_suffix, '.fig'])
    
    save_as_pdf(gcf, [sim_name, label, fig_suffix])
    
end