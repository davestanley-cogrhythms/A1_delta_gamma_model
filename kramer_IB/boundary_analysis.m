function results = boundary_analysis(data, varargin)

%% Defaults & arguments.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

%% Getting spike field, time, etc.

spikes = data.(spike_field);

input = data.(input_field);

time = data.time;

dt = nanmean(diff(time));

%% Computing boundaries from spikes.

[mod_indicator, mod_boundaries, spike_hist] = spikes_to_boundaries(spikes, time, varargin{:});

%% Retrieving phonemes and their start and end times.

sentence_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/timit/TIMIT/';

file_list_id = fopen([sentence_dir, 'wavFileList.txt'], 'r');
file_list = textscan(file_list_id, '%s');
fclose(file_list_id);

file_list = file_list{1};

file_index = data.deepRS_SentenceIndex;

if isfloat(file_index) && file_index < 1 && file_index > 0
    file_index = round(file_index*length(file_list));
end

wavfile_name = file_list{file_index};
file_name = extractBefore(wavfile_name, '.WAV');
    
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

for m = 1:length(mod_boundaries)
    
    phone_index = phone_times(:, 1) <= mod_boundaries(m) & mod_boundaries(m) <= phone_times(:, 2);
    
    if any(phone_index)
        
        boundary_phones{index} = phones{phone_index};
        
        index = index + 1;
        
    end
    
end

%% Retrieving linguistic syllable boundaries from tsylb.

sentence_dir = '/projectnb/crc-nak/brpp/Speech_Stimuli/timit/TIMIT/';

file_list_id = fopen([sentence_dir, 'wavFileList.txt'], 'r');
file_list = textscan(file_list_id, '%s');
fclose(file_list_id);

file_list = file_list{1};

file_index = data.deepRS_SentenceIndex;

if isfloat(file_index) && file_index < 1 && file_index > 0
    file_index = round(file_index*length(file_list));
end

[syl_boundaries, syl_indicator] = getTSYLBfromSI(file_index, data.time, onset_time);

sentence_start = syl_boundaries(1) - 100/dt;
sentence_end = syl_boundaries(end) + 100/dt;

syl_boundaries = time(syl_boundaries);

mid_syl_boundaries = conv(syl_boundaries, [1 1]*.5, 'valid');
mid_syl_indicator = blocks_to_index([mid_syl_boundaries, mid_syl_boundaries], time);

%% Computing covariance of (smoothed, normalized) linguistic boundaries with model spiking and model boundaries.

boundary_kernel = normpdf(-round(boundary_window/dt):round(boundary_window/dt), 0, boundary_window/(4*dt)); % ones(round(boundary_window/dt), 1); % 
boundary_kernel = boundary_kernel/sum(boundary_kernel);

% mod_indicator_norm = conv(double(mod_boundaries), boundary_kernel, 'same');
% mod_indicator_norm = mod_indicator_norm/sum(mod_indicator_norm);

syl_indicator_norm = conv(syl_indicator, boundary_kernel, 'same');
syl_indicator_norm = syl_indicator_norm/sum(syl_indicator_norm);

% figure, plotyy(time(sentence_start:sentence_end), syl_indicator_norm(sentence_start:sentence_end),...
%     time(sentence_start:sentence_end), sum(spikes(sentence_start:sentence_end, :), 2))

[spike_r, spike_lag] = xcorr(syl_indicator_norm(sentence_start:sentence_end),...
    sum(spikes(sentence_start:sentence_end, :), 2));

[max_sr, max_si] = max(spike_r);

max_slag = spike_lag(max_si);

% figure, plotyy(time(sentence_start:sentence_end), syl_indicator_norm(sentence_start:sentence_end),...
%     time(sentence_start:sentence_end), mod_boundaries(sentence_start:sentence_end))

[boundary_r, boundary_lag] = xcorr(syl_indicator_norm(sentence_start:sentence_end),...
    mod_indicator(sentence_start:sentence_end));

[max_br, max_bi] = max(boundary_r);

max_blag = boundary_lag(max_bi);

% figure, plotyy(spike_lag, spike_r, boundary_lag, boundary_r)

%% Computing "boundary time tiling coefficient" (Cutts & Eglen 2014).

tiling_kernel = ones(boundary_window/dt, 1);

near_syl = conv(mid_syl_indicator(sentence_start:sentence_end), tiling_kernel, 'same');
time_near_syl = sum(near_syl > 0)/length(near_syl);
mod_for_comparison = mod_indicator(sentence_start:sentence_end);
mod_near_syl = sum(mod_for_comparison(logical(near_syl > 0)))/sum(mod_for_comparison);

bttc = (mod_near_syl - time_near_syl)/(1 - mod_near_syl*time_near_syl);

% near_mod = conv(mod_boundaries, tiling_kernel, 'same');
% time_near_mod = sum(near_mod > 0)/length(near_mod);
% syl_near_mod = syl_boundaries(logical(near_mod > 0))/sum(syl_boundaries);
% 
% syl_on_mod = (syl_near_mod - time_near_mod)/(1 - syl_near_mod*time_near_mod);

%% Computing Victor & Purpura's spike distance measure.

mid_syl_valid = mid_syl_boundaries(mid_syl_boundaries >= sentence_start & mid_syl_boundaries <= sentence_end);

mod_valid = mod_boundaries(mod_boundaries >= sentence_start & mod_boundaries <= sentence_end);

vpdist = VP_distance(synchrony_window, mid_syl_valid, mod_valid, vp_norm);

%% Computing statistics of alternation of boundaries.

syl_diff = mod_indicator - syl_indicator;

syl_diff(~syl_diff) = [];

sum_syl_diff = conv(syl_diff, [1 1], 'valid'); % cumsum(syl_diff);

mod_count = sum(mod_indicator);

extra_mod = sum(sum_syl_diff(1:(end - 1)) >= 1)/mod_count;

syl_count = sum(syl_indicator);

missed_syl = sum(sum_syl_diff(1:(end - 1)) <= -1)/syl_count;

missed_syl = max(missed_syl, eps);

reg_hits = max(min(1 - missed_syl, 1/(2*syl_count)), 1 - 1/(2*syl_count));
reg_fa = max(min(extra_mod, 1/(2*mod_count)), 1 - 1/(2*mod_count));

dprime = norminv(reg_hits, 0, 1) - norminv(reg_fa, 0, 1);

excursion_sum = 2*sum((extra_mod + missed_syl)/(sum(syl_indicator) + sum(mod_indicator)));

%% Saving results.

results = struct('time', time, 'spikes', spikes, 'input', input, 'spike_hist', spike_hist,...
    'mod_indicator', mod_indicator, 'mod_boundaries', mod_boundaries,...
    'syl_indicator', syl_indicator, 'syl_boundaries', syl_boundaries,...
    'mid_syl_indicator', mid_syl_indicator, 'mid_syl_boundaries', mid_syl_boundaries,...
    'phone_times', phone_times, 'phones', {phones}, 'boundary_phones', {boundary_phones},...
    'max_sr', max_sr, 'max_slag', max_slag, 'max_br', max_br, 'max_blag', max_blag, 'bttc', bttc, 'vpdist', vpdist,...
    'extra_mod', extra_mod, 'missed_syl', missed_syl, 'dprime', dprime, 'excursion_sum', excursion_sum);

end