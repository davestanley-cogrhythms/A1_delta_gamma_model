function [p, tbl, stats, comp, means] = runTIMITstats

%% Loading PLV.

plv_filename = '20-07-01/timit_20-07-01_18+6.mat';

names = load(plv_filename);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

plv_data = load([plv_filename(1:(end - 4)), '_PLV_data.mat']);

MRVs = plv_data.MRVs; % squeeze(nansum(plv_data.MRVs.*plv_data.Nspikes, 3));

Nspikes = plv_data.Nspikes; % squeeze(nansum(plv_data.Nspikes, 3));

% MRVs = MRVs./Nspikes;

PLV = ((abs(MRVs).^2).*Nspikes - 1)./(Nspikes - 1);

models = nan(size(PLV));

for i = 1:size(PLV, 4)

no_sims = size(PLV, 3);

plv_bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))';

plv_bands = nanmean(plv_bands');

no_plv_bands = length(plv_bands);

for b = 1:no_plv_bands

    plv_band_labels{b} = sprintf('%.2g', plv_bands(b)/1000);
    
end

plv_gains = get_vary_field(vary, 'gSpeech');

plv_sis = get_vary_field(vary, 'SentenceIndex');

predictor_values = {plv_gains, plv_bands, plv_sis, 1:length(names)};

ranges = {':', ':', ':', ':'};

for i = 1:length(predictor_values)
    
    predictor{i} = nan(size(PLV));
    
    for j = 1:length(predictor_values{i})
        
        this_ranges = ranges;
        
        this_ranges{i} = num2str(j, '%d');
        
        command = sprintf('predictor{i}(%s, %s, %s, %s) = predictor_values{i}(%d);', this_ranges{:}, j);
        
        eval(command)
        
    end
    
    group_cell{i} = predictor{i}(:);
    
end

varnames = {'Gain', 'Channel', 'Sentence', 'Model'};

[b, rstats] = robustfit(group_cell{1}, PLV(:));

[p, tbl, stats] = anovan(PLV(:), group_cell, 'model', 2, 'varnames', varnames, 'continuous', 1); 

for i = 2:length(varnames)
    
    [comp{i}, means{i}, handle] = multcompare(stats, 'Dimension', i);
    
    saveas(handle, sprintf('%s_%s_multcompare.fig', plv_filename(1:(end - 4)), varnames{i}))

end

save([plv_filename(1:(end - 4)), '_anova.mat'], 'PLV', 'group_cell', 'b', 'rstats', 'p', 'tbl', 'stats', 'comp', 'means')

end