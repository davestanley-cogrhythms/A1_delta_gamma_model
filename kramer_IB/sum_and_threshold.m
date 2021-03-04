function results = sum_and_threshold(data, varargin)

%% Defaults & arguments.

sum_window = 50; % in ms

smooth_window = 25; % in ms

threshold = 2/3;

refractory = 50;

variables = {'sum_window', 'smooth_window', 'threshold', 'refractory'};

options_struct = struct;

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

%% Saving results.

results = struct('spike_hist', spike_hist, 'crossing_times', crossing_times);

end