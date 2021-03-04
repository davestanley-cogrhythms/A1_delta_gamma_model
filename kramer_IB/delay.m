function results = delay(data, varargin)

spike_field = 'deepRS_V_spikes';
    
time = data.time; % In ms
min_delay = 10; % In ms

data_fields = fields(data);

stems = {'iSpikeTriggeredPulse_input', 'STPstim', 'STPonset'};

for s = 1:3
    
    stem_field = data_fields{contains(fields(data), stems{s})};
    eval([stems{s}, ' = data.', stem_field, ';'])
    
end

STP = iSpikeTriggeredPulse_input;
spikes = data.(spike_field);

pulse_index = find(diff(STP > 0) == 1);
pulse_time = time(pulse_index);
time = time - pulse_time;

spike_indicator = logical(spikes) & ~(abs(STPstim)*STP > 0) & (time + pulse_time > STPonset/2);

spike_times = time(spike_indicator);

delay_time = spike_times(find(spike_times > min_delay, 1));

results = struct('delay_time', delay_time);