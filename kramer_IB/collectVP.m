function collectVP(sim_name, varargin) % synchrony_window, vpnorm, 

%% Defaults & arguments.

suffix = '_vpdist'; 

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

sim_struct = load(sim_name);

names = sim_struct.names;

%% Checking analysis files exist.

for n = 1:length(names)
    
    if exist([names{n}, label, suffix, '.mat'], 'file') ~= 2
        
        calcVPdist(names{n}, varargin{:})
        
    end
    
end

%% Collecting vpdist & predictors.

load([names{1}, label, suffix, '.mat'])

all_vpdist = nan([length(vpdist), length(names)]);

predictor_names = {'gS', 'Sfreq', 'SI'};

all_predictors = nan(length(vpdist), length(predictor_names), length(names));

for n = 1:length(names)
    
    vpdist_mat = load([names{n}, label, '_vpdist.mat']);
    
    all_vpdist(:, n) = vpdist_mat.vpdist;
    
    for p = 1:length(predictor_names)
        
        all_predictors(:, p, n) = vpdist_mat.(predictor_names{p});
        
    end
    
end

save([sim_name, label, suffix, '_predictors.mat'], 'all_vpdist', 'all_predictors', 'predictor_names')

end