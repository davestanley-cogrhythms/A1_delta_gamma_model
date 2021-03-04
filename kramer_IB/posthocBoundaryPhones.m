function [results, hists_norm, boundary_phones] = posthocBoundaryPhones(name, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

label_no_vp_params = split(label, {'_syncwin', '_vpnorm'});
label_no_vp_params = label_no_vp_params{1};

%% Loading from vpdist.

time = 0:.1:6000;

onset_time = 1000;

vpdist_struct = load([name, label, '_vpdist.mat']);

vpdist_fields = fieldnames(vpdist_struct);

numeric_fields = zeros(size(vpdist_fields));

for f = 1:length(vpdist_fields)
    
    numeric_fields(f) = isnumeric(vpdist_struct(1).(vpdist_fields{f}));
    
end

for f = 1:length(vpdist_fields)
    
    command = sprintf('%s = vpdist_struct.%s;', vpdist_fields{f}, vpdist_fields{f});
    
    eval((command));
    
end

SIs = unique(SI);
SIs(isnan(SIs)) = [];

gSs = unique(gS);
gSs(isnan(gSs)) = [];

Sfreqs = unique(Sfreq);
Sfreqs(isnan(Sfreqs)) = [];

%% Getting list of sentences.
    
sentence_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/timit/TIMIT/';

file_list_id = fopen([sentence_dir, 'wavFileList.txt'], 'r');
file_list = textscan(file_list_id, '%s');
fclose(file_list_id);

file_list = file_list{1};

for b = 1:length(mod_boundaries)
    
    if ~isempty(mod_boundaries{b}) && ~isnan(SI(b))
        
        %% Retrieving filename for sentence.
        
        file_index = SI(b);
        
        if isfloat(file_index) && file_index < 1 && file_index > 0
            file_index = round(file_index*length(file_list));
        end
        
        wavfile_name = file_list{file_index};
        file_name = extractBefore(wavfile_name, '.WAV');
        
        %% Retrieving phonemes and their start and end times.
        
        phone_filename = [sentence_dir, file_name, '.PHN'];
        fid = fopen(phone_filename, 'r');
        phone_data = textscan(fid, '%s');
        fclose(fid);
        phone_data = phone_data{1};
        phone_data = reshape(phone_data, 3, length(phone_data)/3);
        
        phones = phone_data(3, :);
        
        phone_indices = cellfun(@str2num, phone_data(1:2, :));
        phone_times = (phone_indices/16 + onset_time)';
        
        %% Retrieving phonemes at each putative boundary.
        
        boundary_phones = {}; index = 1;
        
        for m = 1:length(mod_boundaries{b})
            
            phone_index = phone_times(:, 1) <= mod_boundaries{b}(m) & mod_boundaries{b}(m) <= phone_times(:, 2);
            
            if any(phone_index)
                
                boundary_phones{index} = phones{phone_index};
                
                index = index + 1;
                
            end
            
        end
        
        %% Saving results.
        
        results(b) = struct('mod_boundaries', mod_boundaries{b}, 'mid_syl_boundaries', mid_syl_boundaries{b}, 'syl_boundaries', syl_boundaries{b},...
            'phone_times', phone_times, 'phones', {phones}, 'boundary_phones', {boundary_phones});
        
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
    
hists_norm = nan(size(hists));

for k = 1:size(hists, 3)
    
    hists_norm(:, :, k) = hists(:, :, k)*diag(1./sum(hists(:, :, k)));
    
end

save([name, label, '_boundary_phoneme_histograms.mat'], 'results', 'hists', 'hists_norm', 'boundary_phones', 'gSs',...
    'Sfreqs', 'class_names', 'class_indicator', 'timit_phonemes')

end

function plotBPHistograms(name, class_names, hist_labels, hists)

%% Plotting histograms.

figure

imagesc(1:length(class_names), 1:size(hists, 2), hists')

colormap('cool')

set(gca, 'XTickLabel', class_names)

xtickangle(-45)

set(gca, 'YTick', 1:size(hists, 2), 'YTickLabel', hist_labels)

nochange_colorbar(gca)

% rows = size(hists, 2);
% 
% ha = tight_subplot(rows, 1);
% 
% for i = 1:rows
%     
%     axes(ha(i))
%     
%     bar(hists(:, i))
%     
%     box off
%     
%     set(gca, 'XTickLabel', '')
%     
%     if i == rows
%         
%         set(gca, 'XTickLabel', class_names)
%         
%         xtickangle(-45)
%         
%     end
%     
%     ylabel(hist_labels{i}, 'Rotation', 0)
%     
% end

saveas(gcf, [name, '_BPhistograms.fig'])

save_as_pdf(gcf, [name, '_BPhistograms'])

end