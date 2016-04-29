

function startup_DynaSim

    % Set path to your copy of the DynaSim toolbox
    restoredefaultpath
    addpath((fullfile('~','src','DynaSim')));
    addpath(genpath(fullfile('~','src','DynaSim','functions')));
    addpath(genpath(fullfile('~','src','DynaSim','models')));
    
end