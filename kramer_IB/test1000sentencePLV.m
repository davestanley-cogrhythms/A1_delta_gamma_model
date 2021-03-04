function [tbl, stats, comp, means] = test1000sentencePLV

sim_name = 'segmentation_21-01-16_18+52';

sim_name_mat = load(sim_name);

names = sim_name_mat.names;

%% Loading PLV.

PLV_struct = load([sim_name, '_PLV_outcomes.mat']);

MRV = abs(PLV_struct.all_MRV);

nspikes = PLV_struct.all_no_spikes;

plv = (nspikes.*MRV.^2 - 1)./(nspikes - 1);

%% Adding predictor for models.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

models = cell(size(plv, 1), size(plv, 2), length(model_names));

for m = 1:length(model_names)

    models(:, :, m) = model_names(m);
    
end

%% Constructing predictor for channels.

CF = 440 * 2 .^ ((-30:97)/24 - 1);

cochlearBands = getCochlearBands(8)';

bandFreqs = mean(cochlearBands);

channels = nan(size(plv));

[~, f] = min(abs(bandFreqs - 300));

these_freqs = CF(CF >= cochlearBands(1, f) & CF <= cochlearBands(2, f));

for m = 1:length(model_names)
    
    channels(:, :, m) = repmat(these_freqs, [size(channels, 1), 1]);
    
end

varnames = {'Channel', 'Model'};

[p, tbl, stats] = anovan(plv(:), {channels(:), models(:)}, 'varnames', varnames);

for i = 1:length(varnames)
    
    [comp{i}, means{i}, handle{i}] = multcompare(stats, 'Dimension', i);
    
    saveas(handle{i}, sprintf('%s_PLV_%s_multcompare.fig', sim_name, varnames{i}))

end

channel_values = unique(channels(:));

[~, channel_index] = min(abs(channel_values - 233));

% channel_indicator = channels == channel_values(channel_index);

plv_for_test = squeeze(plv(:, channel_index, :));

plv_for_test(any(isnan(plv_for_test), 2), :) = [];

[p1, tbl1, stats1] = friedman(plv_for_test, 1);

% plv_vec = plv(:); channel_vec = channels(:); model_vec = models(:);
% 
% channel_indicator = channel_vec == channel_values(channel_index);
% 
% [p1, tbl1, stats1] = kruskalwallis(plv_vec(channel_indicator), model_vec(channel_indicator));

[comp1, means1, handle1] = multcompare(stats1);

save([sim_name, '_PLV_anova.mat'], 'plv', 'models', 'channels', 'p', 'tbl', 'stats', 'comp', 'means',...
    'p1', 'tbl1', 'stats1', 'comp1', 'means1', '-v7.3')

end