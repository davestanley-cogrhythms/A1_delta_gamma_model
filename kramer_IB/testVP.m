function [tbl, stats, comp, means] = testVP(sim_name, varargin)

if nargin < 2, varargin = {'suffix', '_vpdist_norm3_predictors_optimized.mat'}; end

if strcmp(varargin{1}, 'suffix')
    
    data_name = [sim_name, varargin{2}];
    
else
    
    suffix = '_vpdist';
    
    boundary_defaults %% See boundary_defaults.m, which is a script, not a function.
    
    data_name = [sim_name, label, suffix, '_predictors.mat'];
    
end

data = load(data_name);

predictors = permute(data.all_predictors, [1 3 2]);

predictor_size = size(predictors);

predictors = reshape(predictors, [prod(predictor_size(1:2)), predictor_size(3)]);

% predictors = mat2cell(predictors, size(predictors, 1), ones(size(predictors, 2), 1));

vpdist = reshape(data.all_vpdist, [numel(data.all_vpdist), 1]);

%% Adding predictor for models.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

models = cell(predictor_size(1), length(model_names));

for m = 1:length(model_names)

    models(:, m) = model_names(m);
    
end

%% Computing ANOVA.

varnames = {'Gain', 'Channel', 'Sentence','Model'};

[p, tbl, stats] = anovan(log(vpdist), {predictors(:, 1), predictors(:, 2), predictors(:, 3), models(:)},...
    'varnames', varnames, 'model', 3);

for i = 1:length(varnames)
    
    [comp{i}, means{i}, handle{i}] = multcompare(stats, 'Dimension', i);
    
    saveas(handle{i}, sprintf('%s_%s_multcompare.fig', data_name(1:(end - 4)), varnames{i}))

end

save([data_name(1:(end - 4)), '_anova.mat'], 'p', 'tbl', 'stats', 'comp', 'means')

end