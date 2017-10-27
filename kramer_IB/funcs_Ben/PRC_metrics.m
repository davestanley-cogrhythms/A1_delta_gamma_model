function results = PRC_metrics(data, varargin)

time = data.time;

time_conversion = time(end)/length(time);

triggering_spike_time = unique(data.deepRS_iSpikeTriggeredPulse_triggeringSpikeTime);
triggering_spike_time = triggering_spike_time(end);

spike_times = find(data.deepRS_V_spikes)*time_conversion;

following_spike_times = spike_times(find(spike_times > triggering_spike_time + 10, 2, 'first'));

if isempty(following_spike_times), following_spike_times = nan; end

results = struct('following_spike_times', following_spike_times, 'triggering_spike_time', triggering_spike_time);