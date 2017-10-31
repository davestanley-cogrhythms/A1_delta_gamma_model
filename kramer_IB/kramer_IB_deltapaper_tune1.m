
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m
%
% kramer_IB_deltapaper_scripts1 - Initial testing of network
% kramer_IB_deltapaper_scripts2 - Figures used in actual paper.

function kramer_IB_deltapaper_tune1(chosen_cell)


switch chosen_cell
    case '1a'
        %% Paper Figs 1a - Pulse train no AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1a' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.ap_pulse_delay = 0;
        s{f}.tspan=[0 2500];
        s{f}.PPonset=900;
        s{f}.PPoffset = 2000;
        
        datapf1a = kramer_IB_function_mode(s{f},f);
        
    case '1b'
        %% Paper Figs 1b - Pulse train AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1b' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.ap_pulse_delay = 11;
        s{f}.tspan=[0 2500];
        s{f}.PPonset=900;
        s{f}.PPoffset = 2000;
        
        datapf1b = kramer_IB_function_mode(s{f},f);

    case '1c' 
        %% Paper Figs 1c - Spontaneous
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1c' num2str(f)];
        s{f}.pulse_mode = 0;     % Turn off pulsemode
        s{f}.tspan=[0 2500];
        s{f}.PPonset=900;
        s{f}.PPoffset = 2000;
        
        datapf1c = kramer_IB_function_mode(s{f},f);
        
    case '1d'
        %% Paper Figs 1d - Tones - like 1a, except tones instead of 40 Hz
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1d' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.ap_pulse_delay = 0;
        s{f}.kerneltype_IB = 4;         % Set to 4 for IB tones
        s{f}.tspan=[0 2500];
        s{f}.PPonset=900;
        s{f}.PPoffset = 2000;
        
        datapf1d = kramer_IB_function_mode(s{f},f);


    case '4a'
        
        %% Paper Figs 4a - Lakatos
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig4_lakatos' num2str(f)];
        s{f}.kerneltype_IB = 4;         % Set to 4 for IB tones
        s{f}.pulse_mode = 5;
        s{f}.ap_pulse_delay = 0;
        s{f}.tspan=[0 5500];
        
        datapf4a = kramer_IB_function_mode(s{f},f);

    case '9a'
        %% Paper 9 - Polley figure
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9a_polley' num2str(f)];
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 3500];
        
        datapf9a = kramer_IB_function_mode(s{f},f);
        
        
    case '9b'
        %% Paper 9b - Tune Polley figure
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9b_polleytune' num2str(f)];
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 6500];

        datapf9b = kramer_IB_function_mode(s{f},f);
        


end

end