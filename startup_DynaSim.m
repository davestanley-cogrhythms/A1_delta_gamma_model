

function startup_DynaSim

    % Set path to your copy of the DynaSim toolbox
    format compact
    restoredefaultpath
    
    set(0, 'DefaultFigureColor', 'White');
    
%     set(0, 'DefaultFigureColor', 'White', ...
%     'DefaultTextFontSize', get_fontlevel(4)*scaling_factor, ...
%     'DefaultAxesFontSize', get_fontlevel(2)*scaling_factor);
    
    addpath((fullfile('~','src','DynaSim')));
    addpath(genpath(fullfile('~','src','DynaSim','functions')));
    addpath(genpath(fullfile('~','src','DynaSim','models')));
    
    
    addpath(genpath(fullfile(pwd,'supporting_funcs')));
    
end