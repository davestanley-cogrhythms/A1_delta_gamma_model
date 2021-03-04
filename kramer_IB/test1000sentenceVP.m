function [tbl, stats, comp, means] = test1000sentenceVP(thresholds, sum_windows)

sim_name = 'segmentation_21-01-16_18+52';

sim_name_mat = load(sim_name);

names = sim_name_mat.names;

if nargin < 1
    
    anova_label = '_vpdist_norm3_predictors_optimized';
    
    predictors = load([sim_name, anova_label, '.mat']);
    
    all_vpdist = predictors.all_vpdist;
    
    all_SI = predictors.all_predictors(:, strcmp(predictors.predictor_names, 'SI'), :);
    
else
    
    anova_label = make_label('_thresh', thresholds, ones(size(thresholds)));
    anova_label = [label, make_label('_thresh', sum_windows, ones(size(sum_windows)))];
    
    if isscalar(thresholds), thresholds = thresholds*ones(size(names)); end
    
    if isscalar(sum_windows), sum_windows = sum_windows*ones(size(names)); end
    
    varargin = {'threshold', thresholds(1), 'sum_window' sum_windows(1), 'vp_norm', 3};
    
    boundary_defaults
    
    test_data = load([names{1}, label, '_vpdist.mat']);
    
    [all_vpdist, all_SI] = deal(nan(length(test_data.vpdist), length(names)));
    
    all_vpdist(:, 1) = test_data.vpdist;
    
    all_SI(:, 1) = test_data.SI;
    
    clear vpdist SI
    
    for n = 1:length(names)
        
        varargin = {'threshold', thresholds(n), 'sum_window' sum_windows(n), 'vp_norm', 3};
        
        boundary_defaults
        
        data = load([names{n}, label, '_vpdist.mat']);
        
        all_vpdist(1:length(vpdist), n) = data.vpdist;
        
        all_SI(1:length(SI), n) = data.SI;
        
        clear vpdist SI
        
    end
    
end

model = cumsum(ones(size(all_vpdist)), 2);

% vpdist_isnan = sum(isnan(all_vpdist), 2) > 0;
% 
% model(vpdist_isnan, :) = [];
% all_SI(vpdist_isnan, :) = [];
% all_vpdist(vpdist_isnan, :) = [];

varnames = {'Model', 'Sentence'};

[~, tbl, stats] = anovan(log(all_vpdist(:)), {model(:), all_SI(:)}, 'varnames', varnames);

for i = 1:length(varnames)
    
    [comp{i}, means{i}, handle{i}] = multcompare(stats, 'Dimension', i);
    
    saveas(handle{i}, sprintf('%s%s_%s_multcompare.fig', sim_name, anova_label, varnames{i}))

end

save([sim_name, anova_label, '_anova2.mat'], 'model', 'all_SI', 'all_vpdist', 'tbl', 'stats', 'comp', 'means', '-v7.3')

end