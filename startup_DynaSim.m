

function startup_DynaSim

    % Set path to your copy of the DynaSim toolbox
    format compact
    restoredefaultpath
    addpath((fullfile('~','src','DynaSim')));
    addpath(genpath(fullfile('~','src','DynaSim','functions')));
    addpath(genpath(fullfile('~','src','DynaSim','models')));
    
    
    addpath(genpath(fullfile(pwd,'supporting_funcs')));
    
end