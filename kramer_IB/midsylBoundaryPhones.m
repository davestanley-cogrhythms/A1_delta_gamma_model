function results = midsylBoundaryPhones(SI)

time = 0:.1:10000;

onset_time = 1000;

name = sprintf('midsylBPhistograms_%dsentences', length(SI));

for s = 1:length(SI)
    
    sentence_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/timit/TIMIT/';
    
    file_list_id = fopen([sentence_dir, 'wavFileList.txt'], 'r');
    file_list = textscan(file_list_id, '%s');
    fclose(file_list_id);
    
    file_list = file_list{1};
    
    file_index = SI(s);
    
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
    
    %% Retrieving linguistic syllable boundaries from tsylb.
    
    [syl_boundaries, ~] = getTSYLBfromSI(file_index, time, onset_time);
    
    syl_boundaries = time(syl_boundaries);
    
    mid_syl_boundaries = conv(syl_boundaries, [1 1]*.5, 'valid');
    
    boundaries = {mid_syl_boundaries, syl_boundaries};
    
    %% Retrieving phonemes at each putative boundary.
    
    boundary_phones = cell(1, length(boundaries));
    
    for b = 1:2
        
        boundary_phones{b} = {}; index = 1;
        
        for m = 1:length(boundaries{b})
            
            phone_index = phone_times(:, 1) <= boundaries{b}(m) & boundaries{b}(m) <= phone_times(:, 2);
            
            if any(phone_index)
                
                boundary_phones{b}{index} = phones{phone_index};
                
                index = index + 1;
                
            end
            
        end
        
    end
    
    %% Saving results.
    
    results(s) = struct('mid_syl_boundaries', mid_syl_boundaries, 'syl_boundaries', syl_boundaries,...
        'phone_times', phone_times, 'phones', {phones}, 'boundary_phones', {boundary_phones});
    
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

no_boundary_types = length(bp_cell{1});

hists = nan(length(class_names), no_boundary_types);

for b = 1:no_boundary_types
    
    this_hist = zeros(size(timit_phonemes));
    
    this_bp = cellfun(@(x) x{b}, bp_cell, 'unif', 0);
    
    this_bp_cat = categorical(cat(2, this_bp{:}));
    
    [counts, cats] = histcounts(this_bp_cat);
    
    for c = 1:length(cats)
        
        this_hist(strcmp(timit_phonemes, cats{c})) = counts(c);
        
    end
    
    this_hist = (class_indicator')*this_hist;
    
    % this_hist = this_hist/sum(this_hist);
    
    hists(:, b) = this_hist;
    
end

hists_norm = nan(size(hists));

for k = 1:size(hists, 2)
    
    hists_norm(:, k) = hists(:, k)./sum(hists(:, k));
    
end

save([name, '.mat'], 'hists', 'hists_norm', 'results',...
    'class_names', 'class_indicator', 'timit_phonemes')

hist_labels = {'Mid-Syllable Boundaries', 'Syllable Boundaries'};

plotBPHistograms(name, class_names, hist_labels, hists)

plotBPHistograms([name, '_pdfnorm'], class_names, hist_labels, hists_norm)

end

function plotBPHistograms(name, class_names, hist_labels, hists)

%% Plotting histograms.

figure

imagesc(1:length(class_names), 1:size(hists, 2), hists')

colormap('hot')

set(gca, 'XTickLabel', class_names)

xtickangle(-45)

set(gca, 'YTick', 1:size(hists, 2), 'YTickLabel', hist_labels)

ytickangle(-90)

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