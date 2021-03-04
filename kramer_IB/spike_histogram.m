function results = spike_histogram(data, varargin)

sum_window = 50; % in ms

smooth_window = 25; % in ms

if ~isempty(varargin)

    for v = 1:(length(varargin)/2)

        if strcmp(varargin{2*v - 1}, 'sum_window')

            sum_window = varargin{2*v};

        end

        if strcmp(varargin{2*v - 1}, 'smooth_window')

            smooth_window = varargin{2*v};

        end

    end

end

spike_field = 'deepRS_V_spikes';

spikes = data.(spike_field);

dt = nanmean(diff(data.time));

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

results = struct('spike_hist', spike_hist);

end