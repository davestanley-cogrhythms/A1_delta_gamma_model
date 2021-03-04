function max_cross = speechCovary

%% Loading traces.

trace_filename = '20-07-29/timit_20-07-29_14+52.mat';

names = load(trace_filename);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

trace_bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_trace_bands = length(trace_bands);

for b = 1:no_trace_bands

    trace_y_labels{b} = sprintf('%.2g', trace_bands(b, 1)/1000);
    
end

gS = get_vary_field(vary, 'gSpeech');

SI = get_vary_field(vary, 'SentenceIndex');

tspan = sim_spec.sim_struct.tspan;

time = tspan(1):.1:tspan(2);
selected_time = time >= 1000 & time <= 3250;

data = load([trace_filename(1:(end - 4)), '_traces.mat']);

all_data = data.all_data;

all_spikes = reshape(permute(squeeze(all_data(:, 3, 3:end, :, :, 1)), [1, 2, 4, 3]), [60001, 20, 6]);

all_speech = reshape(permute(squeeze(all_data(:, 3, 3:end, :, :, 2)), [1, 2, 4, 3]), [60001, 20, 6]);

all_f_inst = nan(size(all_spikes));

for n = 1:length(names)
    
    for d2 = 1:size(all_spikes, 2)
        
        [~, ~, all_f_inst(:, d2, n)] = spikes_to_boundaries(all_spikes(:, d2, n), time);
        
    end
    
end

all_f_inst = reshape(all_f_inst(selected_time, :, :), [sum(selected_time)*size(all_spikes, 2), size(all_spikes, 3)]);

all_speech = reshape(all_speech(selected_time, :, :), [sum(selected_time)*size(all_spikes, 2), size(all_spikes, 3)]);

figure

max_cross = nan(size(names));

for n = 1:length(names)
    
    subplot(length(names), 1, n)
    
    all_speech_norm = all_speech(:, n)/sqrt(sum(all_speech(:, n).^2));
    all_fi_norm = all_f_inst(:, n)/sqrt(sum(all_f_inst(:, n).^2));
    
    cross = xcorr(all_speech_norm, all_fi_norm);
    
    max_cross(n) = max(cross);
    
    plot(cross)
    
%     plotyy(1:size(all_speech, 1), all_speech(:, n), 1:size(all_f_inst, 1), all_f_inst(:, n))
    
%     hist3([all_f_inst(:, n), all_speech(:, n)], [25, 25], 'CdataMode', 'auto')
%     
%     view(2)
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 2.5 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 2.5 8])

saveas(gcf, 'TIMIT_traces_covary.fig')

end