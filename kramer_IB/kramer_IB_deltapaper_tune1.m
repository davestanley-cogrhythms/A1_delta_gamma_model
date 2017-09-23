
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m
%
% kramer_IB_deltapaper_scripts1 - Initial testing of network
% kramer_IB_deltapaper_scripts2 - Figures used in actual paper.

function kramer_IB_deltapaper_tune1(chosen_cell)

suffixname = '';

switch chosen_cell
    case '1a'
        %% Paper Figs 1a - Pulse train no AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1a' num2str(f) '_' suffixname];
        s{f}.ap_pulse_num = 0;
        
        datapf1a = kramer_IB_function_mode(s{f},f);
        
    case '1b'
        %% Paper Figs 1b - Pulse train AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1b' num2str(f) '_' suffixname];

        
        datapf1b = kramer_IB_function_mode(s{f},f);

    case '1c' 
        %% Paper Figs 1c - Spontaneous
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1c' num2str(f) '_' suffixname];
        s{f}.pulse_mode = 0;     % Turn off pulsemode
        
        datapf1c = kramer_IB_function_mode(s{f},f);
        
    case '2a'
        %% Paper Figs 2a - Tones
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig2a' num2str(f) '_' suffixname];
        s{f}.ap_pulse_num = 0;
        s{f}.kerneltype_IB = 4;         % Set to 4 for IB tones
        s{f}.poissScaling = 200;
        
        datapf2a = kramer_IB_function_mode(s{f},f);


     
        
end

end