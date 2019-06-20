function results = ISI_metrics(data, varargin)

v_pop = 'deepRS';

ref_name = 'CarracedoSpikes.mat';

ref = load(ref_name);
ref_ISIs = ref.ISIs;

if isfield(data, [v_pop, '_V_spikes'])
    
    spikes = data.([v_pop, '_V_spikes']);
    
else
    
    V = data.([v_pop, '_V']);
    spikes = diff(V >= 0) == 1;
    
end
    
time = data.time;

spike_times = time(logical(spikes))/1000;

ISIs = diff(spike_times);

[ISI_dist, ISI_bins] = hist(ISIs, 50);

max_ISI = max([ISIs(:); ref_ISIs(:)]);

edges = 0:(max_ISI/100):max_ISI;

current_distribution = hist(ISIs, edges);
ref_distribution = hist(ref_ISIs, edges);

current_unit = current_distribution(:)/sqrt(sum(current_distribution(:).^2));
ref_unit = ref_distribution(:)/sqrt(sum(ref_distribution(:).^2));
angle = acos(sum(current_unit.*ref_unit));

current_pdf = current_distribution(:)/sum(current_distribution(:));
current_cumulative = cumsum(current_pdf);
ref_pdf = ref_distribution(:)/sum(ref_distribution(:));
ref_cumulative = cumsum(ref_pdf);
distance = max(abs(current_cumulative - ref_cumulative));

results = struct('ISIs', ISIs, 'ISI_dist', ISI_dist, 'ISI_bins', ISI_bins, 'angle', angle, 'distance', distance);