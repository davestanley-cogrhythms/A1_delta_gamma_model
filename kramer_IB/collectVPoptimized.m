function collectVPoptimized(sim_name, vp_norm) % synchrony_window, vpnorm, 

%% Defaults & arguments.

suffix = sprintf('_vpdist_norm%d', vp_norm); 

sim_struct = load(sim_name);

names = sim_struct.names;

optimized = load(sprintf('%s_all_vpdist_norm_%d.mat', sim_name, vp_norm));

t_for_min = optimized.thresholds(optimized.t_for_min);
s_for_min = optimized.sum_windows(optimized.s_for_min);

load(sprintf('%s_thresh_%.2g_sumwin_%d_vpnorm_%d_vpdist.mat', names{1}, t_for_min(1), s_for_min(1), vp_norm))

all_vpdist = nan([length(vpdist), length(names)]);

predictor_names = {'gS', 'Sfreq', 'SI'};

all_predictors = nan(length(vpdist), length(predictor_names), length(names));


%% Checking analysis files exist & collecting vpdist & predictors.

for n = 1:length(names)
    
    varargin = {'threshold', t_for_min(n), 'sum_window', s_for_min(n), 'vp_norm', vp_norm};

    boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

    if exist([names{n}, label, '_vpdist.mat'], 'file') ~= 2
        
        calcVPdist(names{n}, varargin{:})
        
    end
    
    vpdist_mat = load([names{n}, label, '_vpdist.mat']);
    
    all_vpdist(:, n) = vpdist_mat.vpdist;
    
    for p = 1:length(predictor_names)
        
        all_predictors(:, p, n) = vpdist_mat.(predictor_names{p});
        
    end
    
end

save([sim_name, suffix, '_predictors_optimized.mat'], 'all_vpdist', 'all_predictors', 'predictor_names')

end