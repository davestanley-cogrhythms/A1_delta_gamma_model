

function startup_DynaSimDave

    % Set path to your copy of the DynaSim toolbox
    format compact
    restoredefaultpath
    
    set(0, 'DefaultFigureColor', 'White');
    
%     set(0, 'DefaultFigureColor', 'White', ...
%     'DefaultTextFontSize', get_fontlevel(4)*scaling_factor, ...
%     'DefaultAxesFontSize', get_fontlevel(2)*scaling_factor);
    
    % Add DynaSim
    addpath(genpath(fullfile(pwd,'DynaSim')));
    
    % Add libdave path
    addpath(genpath(fullfile('~','src','lib_dav')));
    
    % Add SigProc-Plott
    addpath(genpath(fullfile('~','src','SigProc-Plott')));
    
    % Add supporting functions
    addpath(genpath(fullfile(pwd,'supporting_funcs')));
    addpath(pwd);
    
    % Add kramerIB supporting functions
    addpath(genpath(fullfile(pwd,'kramer_IB','funcs_supporting')));
    addpath(genpath(fullfile(pwd,'kramer_IB','funcs_supporting_xPlt')));
    addpath(genpath(fullfile(pwd,'kramer_IB','funcs_Ben')));
    
    % Add chronux
    %addpath(genpath(fullfile(pwd,'kramer_IB','chronux')),'-END');
    
end