function plotBoundaryPhones(name, data, results, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

label_no_vp_params = split(label, {'_syncwin', '_vpnorm'});
label_no_vp_params = label_no_vp_params{1};

%% Loading data.

if exist([name, label, '_boundary_phoneme_histograms.mat'], 'file') == 2
    
    load([name, label, '_boundary_phoneme_histograms.mat'])
    
    plotBPHistograms([name, label], class_names, gSs, Sfreqs, hists)
    
    hists_norm = nan(size(hists));
    
    for k = 1:size(hists, 3)
        
        hists_norm(:, :, k) = hists(:, :, k)*diag(1./sum(hists(:, :, k)));
        
    end
    
    plotBPHistograms([name, label, '_pdfnorm'], class_names, gSs, Sfreqs, hists_norm)
    
    return
    
elseif exist([name, label, '_boundary_analysis.mat'], 'file') == 2
                
    load([name, label, '_boundary_analysis.mat'])
    
elseif exist([name, label_no_vp_params, '_boundary_analysis.mat'], 'file') == 2
    
    load([name, label_no_vp_params, '_boundary_analysis.mat'])
    
else
    
    if nargin < 3, results = []; end
    
    if nargin < 2, data = []; end
    
    if isempty(results)
        
        if isempty(data)
            
            disp('DynaSim data or results file needed to compute boundary phonemes.')
            
        else
    
            results = dsAnalyze(data, @boundary_analysis, 'function_options', varargin,...
                'save_results_flag', 1, 'result_file', [name, label, '_boundary_analysis.mat']);
            
        end
        
    end
    
end

%% Getting lists of phonemes (and phoneme classes) used in TIMIT.

timit_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/timit/TIMIT/';

timit_phonemes_file = [timit_dir, 'DOC/TIMITphones.txt'];
fid = fopen(timit_phonemes_file, 'r');
timit_phonemes = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
timit_phonemes = timit_phonemes{1};

class_borders = [find(contains(timit_phonemes, '%%')); length(timit_phonemes) + 1];

class_indicator = false(length(timit_phonemes), length(class_borders) - 1);

for b = 1:(length(class_borders) - 1)
    
    class_indicator((class_borders(b) + 1):(class_borders(b + 1) - 1), b) = true;
    
end

class_names = timit_phonemes(class_borders(1:(end - 1)));

class_names = cellfun(@(x) x(4:end), class_names, 'unif', 0);

class_indicator(class_borders(1:(end - 1)), :) = [];

timit_phonemes(class_borders(1:(end - 1))) = [];

timit_phonemes = cellfun(@(x) textscan(x, '%s'), timit_phonemes, 'unif', 0);
timit_phonemes = cellfun(@(x) x{:}, timit_phonemes, 'unif', 0);
timit_phonemes = cellfun(@(x) x{:}, timit_phonemes, 'unif', 0);

% for p = 1:length(timit_phonemes)
%     
%     this_phone = textscan(timit_phonemes{p}, '%s');
%     
%     this_phone = this_phone{:};
%     
%     timit_phonemes{p} = this_phone{:}; % tsylb_substitutions(this_phone{:});
%     
% end

% timit_phonemes(cellfun(@isempty, timit_phonemes)) = [];

%% Getting varied parameters.

if isempty(data)
    
    if isempty(results)
    
        results0 = load([name, '_boundary_analysis.mat']);
        
        results0 = results0.results;
        
    else
    
        if ~any(contains(fieldnames(results), 'deepRS_SentenceIndex'))
            
            results0 = load([name, '_boundary_analysis.mat']);
            
            results0 = results0.results;
            
        else
            
            results0 = results;
            
        end
        
    end
        
else
    
    results0 = data;
    
end

gS = [results0.deepRS_gSpeech];
gSs = unique(gS);

Shigh = [results0.deepRS_SpeechHighFreq];
Slow = [results0.deepRS_SpeechLowFreq];
Sfreq = (Shigh + Slow)/2;
Sfreqs = unique(Sfreq);

%% Turning boundary phones from a structure array to a cell array.
results_cell = struct2cell(results);
bp_cell = squeeze(results_cell(strcmp(fieldnames(results), 'boundary_phones'), :, :));

%% Collecting boundary phone histograms across sentences.

rows = length(Sfreqs); columns = length(gSs);

boundary_phones = cell(rows, columns);

hists = nan(length(class_names), columns, rows);

for i = 1:rows
    
    this_Sfreq = Sfreqs(i);
    
    for j = 1:columns
        
        this_gS = gSs(j);
        
        this_hist = zeros(size(timit_phonemes));
        
        this_bp = bp_cell(this_Sfreq == Sfreq & this_gS == gS);
        
        boundary_phones{i, j} = categorical(cat(2, this_bp{:}));
        
        [counts, cats] = histcounts(boundary_phones{i,j});
        
        for c = 1:length(cats)
            
            this_hist(strcmp(timit_phonemes, cats{c})) = counts(c);
            
        end
        
        this_hist = (class_indicator')*this_hist;
        
        % this_hist = this_hist/sum(this_hist);
        
        hists(:, j, i) = this_hist;
        
    end
    
end

save([name, label, '_boundary_phoneme_histograms.mat'], 'hists', 'boundary_phones', 'gSs',...
    'Sfreqs', 'class_names', 'class_indicator', 'timit_phonemes')
    
plotBPHistograms([name, label], class_names, gSs, Sfreqs, hists)
    
hists_norm = nan(size(hists));

for k = 1:size(hists, 3)
    
    hists_norm(:, :, k) = hists(:, :, k)*diag(1./sum(hists(:, :, k)));
    
end

plotBPHistograms([name, label, '_pdfnorm'], class_names, gSs, Sfreqs, hists_norm)

end

function plotBPHistograms(name, class_names, gSs, Sfreqs, hists)

%% Plotting histograms.

figure

rows = length(Sfreqs);

ha = tight_subplot(rows, 1);

colors = cool(length(gSs));

gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));

gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);

histmax = all_dimensions(@max, hists);

for i = 1:rows
    
    axes(ha(i))

    set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
    
    bar(hists(:, :, i))
    
    box off
    
    set(gca, 'XTickLabel', '')
    
    ylim([0 histmax])
    
    set(gca, 'YTick', [0 histmax], 'YTickLabel', [0 histmax])
    
    if i == rows
        
        set(gca, 'XTickLabel', class_names)
        
        xtickangle(-45)
        
    elseif i == 1
        
        legend(gS_legend)
        
    end
    
    ylabel({'Input Freq.'; sprintf('%.2g kHz', Sfreqs(i)/1000)}, 'Rotation', 0)
    
end

saveas(gcf, [name, '_boundary_phone_histograms.fig'])

save_as_pdf(gcf, [name, '_boundary_phone_histograms'])

end

% for i = 1:rows
%     
%     this_Sfreq = Sfreqs(i);
%     
%     for j = 1:columns
%         
%         this_gS = gSs(j);
%         
%         % subplot(rows, columns, (i - 1)*columns + j)
%         
%         axes(ha((i - 1)*columns + j))
%         
%         bar(hists(:, j, i))
%         
%         set(gca, 'XTickLabel', '')
%         
%         ylim([0 1])
%         
%         if i == 1
%             
%             title(sprintf('Input Gain %g', this_gS))
%             
%         elseif i == rows
%             
%             set(gca, 'XTickLabel', class_names)
%             
%             xtickangle(-45)
%             
%         end
%         
%         if j == 1
%             
%             ylabel({'Center Freq.'; sprintf('%.2g kHz', this_Sfreq/1000)})
%             
%         end
%         
%     end
%     
% end

% function phone = tsylb_substitutions(phone)
% 
% phones_to_sub = {'cl', 'h#', 'hv', 'epi', 'pau', 'ng', 'ax-h';...
%     'q', '#', '', '', '', '', 'ax'};
% 
% for p = 1:length(phones_to_sub)
%     
%     if contains(phone, phones_to_sub{1, p})
%         
%         phone = phones_to_sub{2, p};
%         
%     end
%     
% end
%     
% end