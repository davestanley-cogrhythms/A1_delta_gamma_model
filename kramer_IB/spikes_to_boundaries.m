function [mod_indicator, mod_boundaries, spike_hist] = spikes_to_boundaries(spikes, time, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

dt = nanmean(diff(time));

%% Convolving w/ EPSP-like kernel.

tau_d = sum_window/(5*dt);
tau_r = tau_d/5;
kernel_x = 0:round(5*tau_d);
sum_kernel = exp(-kernel_x/tau_d); % - exp(-kernel_x/tau_r);
sum_kernel = [zeros(length(kernel_x), 1); sum_kernel'];
sum_kernel = sum_kernel/max(sum_kernel);

spike_hist = conv(sum(spikes, 2), sum_kernel, 'same');

smooth_kernel = normpdf(-round(smooth_window/dt):round(smooth_window/dt), 0, smooth_window/(4*dt));
smooth_kernel = smooth_kernel/sum(smooth_kernel);

spike_hist = conv(spike_hist, smooth_kernel, 'same');

%% Finding places sum goes above threshold.

over = spike_hist >= threshold*max(spike_hist(time < onset_time));

mod_boundaries = time(diff(over) == 1);

invalid_boundaries = diff(mod_boundaries) <= refractory;

mod_boundaries([false; invalid_boundaries(:)]) = [];

%% Creating indicator function for model boundaries.

mod_indicator = false(size(time));

for m = 1:length(mod_boundaries)
    
    mod_indicator(time == mod_boundaries(m) & time >= onset_time) = true;
    
end