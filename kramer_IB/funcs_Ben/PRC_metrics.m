function results = PRC_metrics(data, varargin)

triggering_spike_time = unique(data.deepRS_iSpikeTriggeredPulse_triggeringSpikeTime);
triggering_spike_time = triggering_spike_time(end);

spike_times = find(data.deepRS_V_spikes)/10;

first_spike_time = spike_times(find(spike_times > triggering_spike_time + 10, 1, 'first'));

if isempty(first_spike_time), first_spike_time = nan; end

results = struct('first_spike_time', first_spike_time, 'triggering_spike_time', triggering_spike_time);