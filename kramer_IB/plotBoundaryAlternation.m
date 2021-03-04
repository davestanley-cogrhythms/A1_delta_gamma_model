function plotBoundaryAlternation(name, data, results, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

if isempty(results)
    
    if ~isempty(data)
    
        results = dsAnalyze(data, @boundary_analysis, 'save_results_flag', 1, 'result_file', [name, '_boundary_analysis.mat']);
    
    else
        
        results = load([name, label, '_boundary_analysis.mat']);
    
        results = results.results;
        
    end
    
end

%% Getting results.

measure_labels = {'max_sr', 'max_slag', 'max_br', 'max_blag', 'vpdist',... 'bttc', 
    'extra_mod', 'missed_syl', 'dprime', 'excursion_sum'};

measure_titles = {'Spike-Boundary Correlation', 'Spike-Boundary Time Lag',...
    'Boundary-Boundary Correlation', 'Boundary-Boundary Time Lag',...
    'Victor-Purpura Distance',... 'Boundary Time Tiling Coefficient', 
    'Extra Model Boundaries', 'Missed Syllable Boundaries',...
    'D Prime', 'Excursion Sum'};

no_bins = 25;

for m = 1:length(measure_labels)
    
    measures(:, m) = [results.(measure_labels{m})];
    
    bins{m} = linspace(nanmin(measures(:, m)), nanmax(measures(:, m)), no_bins);
    
end

if max(measures(:, 6)) > 1
    
    syl_count = sum([results.syl_indicator]);
    
    mod_count = sum([results.mod_indicator]);
    
    measures(:, 6) = (measures(:, 6).*syl_count')./mod_count';
    
    bins{6} = linspace(nanmin(measures(:, 6)), nanmax(measures(:, 6)), no_bins);
    
end

if any(isinf(measures(:, 8))) || any(diff(bins{8}) == 0)
    
    reg_hits = min(max(1 - measures(:, 7), eps), 1 - eps);
    reg_fa = min(max(measures(:, 6), eps), 1 - eps);
    
    measures(:, 8) = norminv(reg_hits, 0, 1) - norminv(reg_fa, 0, 1);
    
    bins{8} = linspace(nanmin(measures(:, 8)), nanmax(measures(:, 8)), no_bins);
    
end

%% Getting varied parameters.

if isempty(data)
    
    if ~any(contains(fieldnames(results), 'deepRS_SentenceIndex'))
    
        results0 = load([name, '_boundary_analysis.mat']);
        
        results0 = results0.results;
    
    else
    
        results0 = results;
        
    end
        
else
    
    results0 = data;
    
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
onset = 1000;

%% Collecting various measures.

rows = length(Sfreqs); columns = length(gSs);

boundary_phones = cell(rows, columns);

hists = nan(no_bins, columns, rows);

for i = 1:rows
    
    this_Sfreq = Sfreqs(i);
    
    for j = 1:columns
        
        this_gS = gSs(j);
        
        for m = 1:length(measure_labels)
            
            this_measure = measures(this_Sfreq == Sfreq & this_gS == gS, m);
        
            counts(:, j, i, m) = histcounts(this_measure, bins{m});
            
        end
        
    end
    
end

save([name, label, '_boundary_stats.mat'], '-v7.3', 'measure_labels', 'measure_titles', 'counts', 'bins', 'measures', 'gSs', 'Sfreqs', 'gS', 'Sfreq')

%% Plotting histograms.

for m = 1:length(measure_labels)
    
    figure
    
    ha = tight_subplot(rows, 1);
    
    colors = cool(length(gSs));
    
    gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));
    
    gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);
    
    for i = 1:rows
        
        this_Sfreq = Sfreqs(i);
        
        axes(ha(i))
        
        set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
        
        bin_centers = conv(bins{m}, .5*[1 1], 'valid');
        
        plot(bin_centers, counts(:, :, i, m))
        
        box off
        
        if i ~= rows
            
            set(gca, 'XTickLabel', '')
            
        else
            
            set(gca, 'XTick', bin_centers(1:9:end), 'XTickLabel', bin_centers(1:9:end))
            
        end
        
        if i == 1
        
            title(measure_titles{m})
            
            legend(gS_legend)
            
        end
        
        ylabel({'Input Freq.'; sprintf('%.2g kHz', this_Sfreq/1000)}, 'Rotation', 0)
        
    end
    
    saveas(gcf, sprintf('%s%s_%s_histograms.fig', name, label, measure_labels{m}))
    
    save_as_pdf(gcf, sprintf('%s%s_%s_histograms', name, label, measure_labels{m}))
    
end