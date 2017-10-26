
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
        s{f}.ap_pulse_num = 0;
        s{f}.tspan=[0 3500];
        s{f}.PPonset=1200;
        s{f}.PPoffset = 2500;
        
        datapf1a = kramer_IB_function_mode(s{f},f);
        
    case '1b'
        %% Paper Figs 1b - Pulse train AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1b' num2str(f)];
        s{f}.tspan=[0 3500];
        s{f}.PPonset=1200;
        s{f}.PPoffset = 2500;
        
        datapf1b = kramer_IB_function_mode(s{f},f);

    case '1c' 
        %% Paper Figs 1c - Spontaneous
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1c' num2str(f)];
        s{f}.pulse_mode = 0;     % Turn off pulsemode
        s{f}.tspan=[0 3500];
        s{f}.PPonset=1200;
        s{f}.PPoffset = 2500;
        
        datapf1c = kramer_IB_function_mode(s{f},f);
        
    case '2a'
        %% Paper Figs 2a - Tones
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig2a' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.kerneltype_IB = 4;         % Set to 4 for IB tones
        s{f}.tspan=[0 3500];
        s{f}.PPonset=1200;
        s{f}.PPoffset = 2500;
        
        datapf2a = kramer_IB_function_mode(s{f},f);


    case '4a'
        
        %% Paper Figs 4a - Lakatos
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig4_lakatos' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.kerneltype_IB = 4;         % Set to 4 for IB tones
        s{f}.pulse_mode = 5;
        s{f}.tspan=[0 5500];
        
        datapf4a = kramer_IB_function_mode(s{f},f);

    case '9'
        %% Paper 9 - Polley figure
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9a_polley' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.ap_pulse_num = 0;
        s{f}.tspan=[0 1000];
        
        % Turn off stimulus to RS and IB cells; turn on to FS cells
        s{f}.IB_PP_gSYN = 0;    
        s{f}.RS_PP_gSYN = 0;
        s{f}.dFS_PP_gSYN = 0.35;
        
        % Adjust timing of stimuli to coincide with pulse at 450 ms
        s{f}.PPonset = 440;    % ms, onset time
        s{f}.PPoffset = 465;   % ms, offset time

        datapf9a = kramer_IB_function_mode(s{f},f);
        
        dsPlot2_PPStim(datapf9a(end),'plot_type','waveform')

end

end