function [syl_boundaries, syl_indicator] = getTSYLBfromSI(sentence_index, time, onset)

sentence_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/timit/TIMIT/';

file_list_id = fopen([sentence_dir, 'wavFileList.txt'], 'r');
file_list = textscan(file_list_id, '%s');
fclose(file_list_id);

file_list = file_list{1};

if isempty(sentence_index)
    sentence_index = round(rand*length(file_list));
elseif isfloat(sentence_index) && sentence_index < 1 && sentence_index > 0
    sentence_index = round(sentence_index*length(file_list));
end

wavfile_name = file_list{sentence_index};

this_wavfile = audioread([sentence_dir, wavfile_name]);
wavfile_length = length(this_wavfile)/16;

sentence_length = ceil(max(length(time), (wavfile_length + onset)/nanmean(diff(time))));

file_name = extractBefore(wavfile_name, '.WAV');

syl_boundaries = load([sentence_dir, file_name, '.TSYLB']);

syl_boundaries = round((syl_boundaries/16 + onset)/nanmean(diff(time)));

syl_indicator = zeros(sentence_length, 1);

syl_indicator(syl_boundaries) = 1;

% syllable_indicator = conv(syllable_indicator, ones(1,500)/500, 'same');