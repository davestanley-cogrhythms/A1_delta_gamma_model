function [tbl, stats, comp, means] = testPLV(sim_name)

%% Loading PLV.

PLV_struct = load([sim_name, '_PLV_outcomes.mat']);

MRV = abs(PLV_struct.all_MRV);

nspikes = PLV_struct.all_no_spikes;

plv = (nspikes.*MRV.^2 - 1)./(nspikes - 1);

for n = 1:size(plv, 3)
    
    this_plv = plv(:, :, n);
    
    figure
   
    histogram(log(1 + log(1 + this_plv(:))))
    
    [h(n), p(n)] = kstest(log(1 + log(1 + this_plv(:))));
    
end

%% Adding predictor for models.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

models = cell(size(plv, 1), size(plv, 2), length(model_names));

for m = 1:length(model_names)

    models(:, :, m) = model_names(m);
    
end

%% Loading other predictors.

predictor_name = [sim_name, '_vpdist_norm3_predictors_optimized.mat'];

predictor_struct = load(predictor_name);

predictors = predictor_struct.all_predictors;

%% Constructing predictor for channels.

CF = 440 * 2 .^ ((-30:97)/24 - 1);

cochlearBands = getCochlearBands(8)';

bandFreqs = mean(cochlearBands);

channels = nan(size(plv));

Sfreq_indicator = strcmp('Sfreq', predictor_struct.predictor_names);

for f = 1:size(cochlearBands, 2)
    
    these_freqs = CF(CF >= cochlearBands(1, f) & CF <= cochlearBands(2, f));
    
    for m = 1:length(model_names)
        
        f_indicator = predictors(:, Sfreq_indicator, m) == bandFreqs(f);
        
        channels(f_indicator, :, m) = repmat(these_freqs, [sum(f_indicator), 1]);
        
    end
    
end

%% Reshaping predictors & replacing "channels" predictor.

predictors = permute(repmat(predictor_struct.all_predictors, [1 1 1 size(plv, 2)]), [1 4 3 2]);

predictors(:, :, :, Sfreq_indicator) = channels;

predictor_size = size(predictors);

predictors = reshape(predictors, [prod(predictor_size(1:3)), predictor_size(4)]);

save([sim_name, '_PLV_variables'], 'plv', 'predictors', 'models', '-v7.3')

%% Computing ANOVA.

varnames = {'Gain', 'Channel', 'Sentence','Model'};

[p, tbl, stats] = anovan(plv(:), {predictors(:, 1), predictors(:, 2), predictors(:, 3), models(:)},...
    'varnames', varnames, 'continuous', 1, 'model', 2);

for n = 2:length(varnames)
    
    [comp{n}, means{n}, handle] = multcompare(stats, 'Dimension', n);
    
    saveas(handle, sprintf('%s_PLV_%s_multcompare.fig', sim_name, varnames{n}))

end

save([sim_name, '_PLV_anova.mat'], 'p', 'tbl', 'stats', 'comp', 'means')

end