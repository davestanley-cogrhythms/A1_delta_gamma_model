function plotBAaggregate(sim_name, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

sim_struct = load(sim_name);

names = sim_struct.names;

%% Checking analysis files exist.

for n = 1:length(names)
    
%     if ~exist([names{n}, '_boundary_stats.mat'], 'file')
%         
%         % disp(sprintf('Results file not available for %s', name))
%         
%         data = dsImport(name);
%         
%         plotBoundaryAlternation(names{n}, data)
%         
%     end
    
    if ~exist([names{n}, label, '_boundary_stats.mat'])
        
        if exist([names{n}, label, '_boundary_analysis.mat'], 'file')
            
            plotBoundaryAlternation(names{n}, [], [], varargin{:})
            
        else
            
            posthoc_boundary_analysis_wrapper(names{n}, varargin{:})
            
            plotBoundaryAlternation(names{n}, [], [], varargin{:})
            
        end
        
    end
    
end

%% Loading, collecting, & calculating histograms of analyzed measures.

load([names{1}, label, '_boundary_stats.mat'])

all_measures = nan([size(measures), length(names)]);

for n = 1:length(names)
    
    load([names{n}, label, '_boundary_stats.mat'])
    
    all_measures(:, :, n) = measures;
    
end

clear counts

for m = 1:size(measures, 2)
    
    bins{m} = linspace(all_dimensions(@min, all_measures(:, m, :)), all_dimensions(@max, all_measures(:, m, :)), 25);
    
    for n = 1:length(names)
        
        for i = 1:length(gSs)
            
            for j = 1:length(Sfreqs)
                
                counts(:, i, j, n, m) = histcounts(all_measures(gS == gSs(i) & Sfreq == Sfreqs(j), m, n), bins{m});
                
            end
            
        end
        
    end
    
end

%% Plotting measure histograms.

% measure_labels = {'max_sr', 'max_slag', 'max_br', 'max_blag', 'bttc', 'extra_mod', 'missed_syl', 'dprime', 'excursion_sum'};
% 
% measure_titles = {'Spike-Boundary Correlation', 'Spike-Boundary Time Lag',...
%     'Boundary-Boundary Correlation', 'Boundary-Boundary Time Lag',...
%     'Boundary Time Tiling Coefficient', 'Extra Model Boundaries',...
%     'Missed Syllable Boundaries', 'Sensitivity (D'')', 'Excursion Sum'};

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

no_lines = length(gSs); rows = length(Sfreqs); columns = length(names);

fig_labels = {''}; %, '_pdfnorm'};

for m = 1:size(measures, 2)
    
    figure
    
    ha = tight_subplot(rows, columns, [.025, .025], .075, .06);
    
    colors = cool(no_lines - 1);
    
    gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));
    
    gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);
    
    histmax = all_dimensions(@max, counts(:, 2:end, :, :, m));
    
    bin_centers = conv(bins{m}, [1 1]*.5, 'valid');
    
    for i = 1:rows
        
        for j = 1:columns
            
            axes(ha((i - 1)*columns + j))
            
            set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
            
            plot(bin_centers, counts(:, 2:end, i, j, m))
            
            box off
            
            set(gca, 'XTickLabel', '')
            
            xlim([min(bin_centers), max(bin_centers)])
            
            ylim([0 histmax])
            
            set(gca, 'YTick', [0 histmax], 'YTickLabel', [0 histmax])
            
            if i == 1
                
                title(model_names{j})
                
            elseif i == rows
                
                xticks = bin_centers(1:floor(length(bin_centers)/5):end);
                
                set(gca, 'XTick', xticks, 'XTickLabel', xticks)
                
                xtickangle(-45)
                
                xlabel(measure_titles{m})
                
            end
            
            if j == 1
            
                ylabel({'Input Freq.'; sprintf('%.2g kHz', Sfreqs(i)/1000)}, 'Rotation', 0)
                
            end
            
            if i == 1 && j == 1
                
                legend(gS_legend(2:end))
                
            end
            
        end
        
    end
    
    fig_suffix = sprintf('_%s_BAhist', measure_labels{m});
    
    saveas(gcf, [sim_name, label, fig_suffix, '.fig'])
    
    save_as_pdf(gcf, [sim_name, label, fig_suffix])
    
end