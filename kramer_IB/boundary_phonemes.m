function results = boundary_phonemes(data, varargin)

%% Defaults & arguments.

variables = {'sum_window', 'smooth_window', 'threshold', 'refractory', 'onset_time'};

defaults = {50, 25, 2/3, 50, 1000};

options_struct = struct;

for v = 1:length(variables)
    
    options_struct.(variables{v}) = defaults{v};
    
end

if ~isempty(varargin)

    for v = 1:(length(varargin)/2)
        
        if sum(strcmp(varargin{2*v - 1}, variables)) == 1

            options_struct.(variables{strcmp(varargin{2*v - 1}, variables)}) = varargin{2*v};
            
        end

    end

end

fields = fieldnames(options_struct);

for f = 1:length(fields)
    
    eval(sprintf('%s = options_struct.%s;', fields{f}, fields{f}))
    
end

%% Getting spike field, time, etc.

spike_field = 'deepRS_V_spikes';

spikes = data.(spike_field);

input_field = 'deepRS_iSpeechInput_input';

input = data.(input_field);

time = data.time;

dt = nanmean(diff(time));

%% Convolving w/ EPSP-like kernel.

tau_d = sum_window/(5*dt);
tau_r = tau_d/5;
kernel_x = 0:round(5*tau_d);
sum_kernel = exp(-kernel_x/tau_d); % - exp(-kernel_x/tau_r);
sum_kernel = [zeros(length(kernel_x), 1); sum_kernel'];
sum_kernel = sum_kernel/max(sum_kernel);

spike_hist = conv(sum(spikes, 2), sum_kernel, 'same');

smooth_kernel = normpdf(-round(smooth_window/(2*dt)):round(smooth_window/(2*dt)), 0, smooth_window/(4*dt));
smooth_kernel = smooth_kernel/sum(smooth_kernel);

spike_hist = conv(spike_hist, smooth_kernel, 'same');

%% Finding places sum goes above threshold.

over = spike_hist >= threshold*max(spike_hist);

crossing = diff(over) == 1;

crossing_times = time(crossing);

invalid_crossings = diff(crossing_times) <= refractory;

crossing_times([false; invalid_crossings]) = [];

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

index = 1;

for c = 1:length(crossing_times)
    
    phone_index = phone_times(:, 1) <= crossing_times(c) & crossing_times(c) <= phone_times(:, 2);
    
    if any(phone_index)
        
        boundary_phones{index} = phones{phone_index};
        
        index = index + 1;
        
    end
    
end

%% Saving results.

results = struct('time', time, 'spikes', spikes, 'input', input, 'spike_hist', spike_hist,...
    'crossing', crossing, 'crossing_times', crossing_times, 'phone_times', phone_times,...
    'phones', {phones}, 'boundary_phones', {boundary_phones});

end