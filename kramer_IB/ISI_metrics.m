function results = ISI_metrics(data, varargin)

v_pop = 'deepRS';

ref_name = 'CarracedoSpikes.mat';

ref = load(ref_name);
ref_ISIs = ref.ISIs;

spikes = data.([v_pop, '_V_spikes']);
time = data.time;

spike_times = time(logical(spikes))/1000;

ISIs = diff(spike_times);

[ISI_dist, ISI_bins] = hist(ISIs, 50);

max_ISI = max([ISIs(:); ref_ISIs(:)]);

edges = 0:(max_ISI/100):max_ISI;

current_dist = hist(ISIs, edges);
current_norm = current_dist(:)/sum(current_dist(:));
ref_dist = hist(ISIs, edges);
ref_norm = ref_dist(:)/sum(ref_dist(:));

distance = sqrt(sum((current_norm - ref_norm).^2));

results = struct('ISIs', ISIs, 'ISI_dist', ISI_dist, 'ISI_bins', ISI_bins, 'distance', distance);