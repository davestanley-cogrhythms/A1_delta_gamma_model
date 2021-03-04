function sentence = getSentence(time, no_channels, file_index, onset, lowfreq, highfreq, norm)

if nargin < 2, no_channels = []; end
if isempty(no_channels), no_channels = 1; end
if nargin < 3, file_index = []; end
if nargin < 4, onset = []; end
if isempty(onset), onset = 0; end
if nargin < 5, lowfreq = []; end
if isempty(lowfreq), lowfreq = 0; end
if nargin < 5, highfreq = []; end
if isempty(highfreq), highfreq = inf; end
if nargin < 6, norm = []; end
if isempty(norm), norm = 0; end

nsltools_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/nsltools/';addpath(genpath(nsltools_dir))
sentence_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/timit/TIMIT/';

file_list_id = fopen([sentence_dir, 'wavFileList.txt'], 'r');
file_list = textscan(file_list_id, '%s');
fclose(file_list_id);

file_list = file_list{1};

if isempty(file_index)
    file_index = round(rand*length(file_list));
elseif isfloat(file_index) && file_index < 1 && file_index > 0
    file_index = round(file_index*length(file_list));
end

wavfile_name = file_list{file_index};
file_name = extractBefore(wavfile_name, '.WAV');

sentence = struct('filename', file_name);

%% Getting wav file & applying cochlear filterbank.

this_wavfile = audioread([sentence_dir, wavfile_name]);
wavfile_length = 100*length(this_wavfile)/16;

loadload, paras(1) = 1;% paras(4) = 0;
this_auditory = wav2aud(this_wavfile, paras);

CF = 440 * 2 .^ ((-30:97)/24 - 1);
CF_included = CF(CF >= lowfreq & CF <= highfreq);
%CF_limits = [min(CF_included), max(CF_included)];
this_auditory = this_auditory(:, CF >= lowfreq & CF <= highfreq);

[~, aud_cols] = size(this_auditory);

sentence_length = ceil(max(length(time), wavfile_length + onset*100));

cochlear = zeros(sentence_length, no_channels);

channels_averaged = floor(aud_cols/no_channels);
for c = 1:no_channels
    %this_channel_freqs(c, :) = CF_included([(c - 1)*channels_averaged + 1, c*channels_averaged]);
    this_channel = nanmean(this_auditory(:,((c - 1)*channels_averaged + 1):c*channels_averaged), 2);
    this_channel = interp(interp(this_channel, 5), 10);
    if norm == 1
        this_channel = this_channel/sum(this_channel);
    elseif norm == 2
        this_channel = this_channel/max(this_channel);
    end
    cochlear(onset*100 + (1:length(this_channel)), c) = conv(this_channel, ones(1,500)/500, 'same');  
end

sentence.cochlear = cochlear;

%% Getting syllable boundaries.

syl_boundaries = load([sentence_dir, file_name, '.TSYLB']);

syl_boundaries = round(100*syl_boundaries/16);

syllable_indicator = zeros(size(cochlear, 1), 1);

syllable_indicator(onset*100 + syl_boundaries) = 1;

syllable_indicator = conv(syllable_indicator, ones(1,500)/500, 'same');

sentence.syllables = syllable_indicator;



