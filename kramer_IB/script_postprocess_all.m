

%% Postprocess all data

D = dir('study_*');
names = {D.name};

for i = 1:length(names)
    study_dir = fullfile(names{i});
    load(fullfile('.',study_dir,'sim_vars.mat'))
    data = dsImport(study_dir);
    
end