function plotDprime(name, data, results, varargin)

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

measure_labels = {'extra_mod', 'missed_syl', 'dprime'}; % , 'excursion_sum'};

measure_titles = {'Extra Model Boundaries', 'Missed Syllable Boundaries', 'D Prime'}; % , 'Excursion Sum'};

no_bins = 25;

for m = 1:length(measure_labels)
    
    measures(:, m) = [results.(measure_labels{m})];
    
end

syl_count = sum([results.syl_indicator]);

mod_count = sum([results.mod_indicator]);

reg_hits = max(min(1 - measures(:, 2), 1./(2*syl_count')), 1 - 1./(2*syl_count'));
reg_fa = max(min(measures(:, 1), 1./(2*mod_count')), 1 - 1./(2*mod_count'));

measures(:, 3) = norminv(reg_hits, 0, 1) - norminv(reg_fa, 0, 1);

clear reg_hits reg_fa

% measures(:, 4) = measures(:, 2).*syl_count';
% 
% measures(:, 5) = measures(:, 1).*mod_count';

for m = 1:length(measure_labels)
    
    bins{m} = linspace(nanmin(measures(:, m)), nanmax(measures(:, m)), no_bins);
    
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
        
        this_indicator = this_Sfreq == Sfreq & this_gS == gS;
        
        for m = 1:length(measure_labels)
            
            this_measure = measures(this_indicator, m);
        
            counts(:, j, i, m) = histcounts(this_measure, bins{m});
            
        end
        
        this_hits = sum(measures(this_indicator, 1).*mod_count(this_indicator)');
        
        this_mod_count = sum(mod_count(this_indicator));
        
        this_fa = sum(measures(this_indicator, 2).*syl_count(this_indicator)');
        
        this_syl_count = sum(syl_count(this_indicator));

        reg_hits = max(min(1 - this_hits, 1/(2*this_syl_count)), 1 - 1/(2*this_syl_count));
        reg_fa = max(min(this_fa, 1/(2*this_mod_count)), 1 - 1/(2*this_mod_count));
        
        dPrime(j, i) = norminv(reg_hits, 0, 1) - norminv(reg_fa, 0, 1);
        
    end
    
end

save([name, label, '_dprime.mat'], 'counts', 'bins', 'measures', 'dPrime', 'gSs', 'Sfreqs', 'gS', 'Sfreq')

%% Plotting d-prime overall.
    
figure

imagesc(Sfreqs, gSs, dPrime)

colorbar

axis xy

xlabel({'Input Channel'; 'Center Freq. (kHz)'})

ylabel('Input Gain')

title('Sensitivity (D'')')
    
saveas(gcf, sprintf('%s%s_dprime.fig', name, label))

save_as_pdf(gcf, sprintf('%s%s_dprime', name, label))

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