
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m
%
% kramer_IB_deltapaper_scripts1 - Initial testing of network
% kramer_IB_deltapaper_scripts2 - Figures used in actual paper.

function kramer_IB_deltapaper_tune1(chosen_cell,maxNcores)


if nargin < 2
    maxNcores = Inf;
end

namesuffix = '_hcurrent6';
% namesuffix = '_IBPPStim0.05';
% namesuffix = '_gar0.0';
% namesuffix = '';

switch chosen_cell
    case '1a1'
        %% Paper Figs 1a - Pulse train no AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1a1' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.pulse_train_preset = 0;
        s{f}.tspan=[0 2500];
        s{f}.PPonset=400;
        s{f}.PPoffset = 2000;
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active
        
        s{f}.random_seed = 'shuffle';
        
        datapf1a = kramer_IB_function_mode(s{f},f);
        
    case '1b1'
        %% Paper Figs 1b - Pulse train AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1b1' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.pulse_train_preset = 1;
        s{f}.tspan=[0 2500];
        s{f}.PPonset=400;
        s{f}.PPoffset = 2000;
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active
        
        s{f}.random_seed = 'shuffle';
        
        datapf1b = kramer_IB_function_mode(s{f},f);
        
    case '1b2'
        %% Paper Figs 1b - Pulse train AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1b2' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.pulse_train_preset = 1;
        s{f}.tspan=[0 2500];
        s{f}.PPonset=400;
        s{f}.PPoffset = 2000;
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active
        
        s{f}.random_seed = 'shuffle';
        
        % % Only superficial oscillator
        s{f}.include_IB =   0;
        s{f}.include_RS =   1;
        s{f}.include_FS =   1;
        s{f}.include_LTS =  1;
        s{f}.include_NG =   0;
        s{f}.include_dFS5 = 0;
        s{f}.include_deepRS = 0;
        s{f}.include_deepFS = 0;
        
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
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active
        
        s{f}.random_seed = 'shuffle';
        
        datapf1c = kramer_IB_function_mode(s{f},f);
        
    case '1d'
        %% Paper Figs 1d - Tones - like 1a, except tones instead of 40 Hz
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['tune1Fig1d' num2str(f)];
        s{f}.pulse_mode = 1;
        s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;         % Set to 4 for IB tones
        s{f}.tspan=[0 2500];
        s{f}.PPonset=900;
        s{f}.PPoffset = 2000;
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active
        
        s{f}.random_seed = 'shuffle';
        
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
        s{f}.tspan=[0 5500];
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active
        
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
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active
        
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
        s{f}.tspan=[0 5500];
        s{f}.maxNcores = maxNcores; s{f}.parallel_flag = 1;     % Parallel flag and Ncores should always be active

        datapf9b = kramer_IB_function_mode(s{f},f);
        


end

end