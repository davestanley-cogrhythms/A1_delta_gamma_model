
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m
%
% kramer_IB_deltapaper_scripts1 - Initial testing of network
% kramer_IB_deltapaper_scripts2 - Figures used in actual paper.

function kramer_IB_deltapaper_scripts2(chosen_cell,maxNcores)

if nargin < 2
    maxNcores = Inf;
end

namesuffix = '_gar0.25_shortpulse2_50ms';
% namesuffix = '';

switch chosen_cell
    case '0a'
        %% Compile - compile for all cells
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures = 0;
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1;
        
        % % % % % Cells to include in model
        s{f}.include_IB =   1;
        s{f}.include_RS =   1;
        s{f}.include_FS =   1;
        s{f}.include_LTS =  1;
        s{f}.include_NG =   1;
        s{f}.include_dFS5 = 1;
        s{f}.include_deepRS = 0;
        s{f}.include_deepFS = 0;
        
        datapf0a = kramer_IB_function_mode(s{f},f);
        
        
        %% Compile - compile for just delta oscillator + FS resetter
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures = 0;
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1;
        
        % % % % % Cells to include in model
        s{f}.include_IB =   1;
        s{f}.include_RS =   0;
        s{f}.include_FS =   0;
        s{f}.include_LTS =  0;
        s{f}.include_NG =   1;
        s{f}.include_dFS5 = 1;
        s{f}.include_deepRS = 0;
        s{f}.include_deepFS = 0;
        
        datapf0a = kramer_IB_function_mode(s{f},f);
        
        %% Compile - Small jobs - Just delta oscillator
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures = 0;
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1;
        
        % % % % % Cells to include in model
        s{f}.include_IB =   1;
        s{f}.include_RS =   0;
        s{f}.include_FS =   0;
        s{f}.include_LTS =  0;
        s{f}.include_NG =   1;
        s{f}.include_dFS5 = 0;
        s{f}.include_deepRS = 0;
        s{f}.include_deepFS = 0;
        
        datapf0a = kramer_IB_function_mode(s{f},f);
        
        %% Compile - Small jobs - Just IB cells
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures = 0;
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1;
        
        % % % % % Cells to include in model
        s{f}.include_IB =   1;
        s{f}.include_RS =   0;
        s{f}.include_FS =   0;
        s{f}.include_LTS =  0;
        s{f}.include_NG =   0;
        s{f}.include_dFS5 = 0;
        s{f}.include_deepRS = 0;
        s{f}.include_deepFS = 0;
        
        datapf0a = kramer_IB_function_mode(s{f},f);        
        
        
    case '1a'
        %% Paper Figs 1a - Pulse train no AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.sim_mode = 1;
        s{f}.repo_studyname = ['DeltaFig1a'  num2str(f) '' namesuffix];
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.tspan=[0 2000];
        s{f}.PPoffset = 1500;
        s{f}.random_seed = 'shuffle';
        
        datapf1a = kramer_IB_function_mode(s{f},f);
        
    case '1b'
        %% Paper Figs 1b - Pulse train AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.sim_mode = 1;
        s{f}.repo_studyname = ['DeltaFig1b'  num2str(f) '' namesuffix];
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 1;
        s{f}.tspan=[0 2000];
        s{f}.PPoffset = 1500;
        s{f}.random_seed = 'shuffle';
        
        datapf1b = kramer_IB_function_mode(s{f},f);
        
    case '1c' 
        %% Paper Figs 1c - Spontaneous
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.sim_mode = 1;
        s{f}.repo_studyname = ['DeltaFig1c'  num2str(f) '' namesuffix];
        s{f}.tspan=[0 5000];
        s{f}.pulse_mode = 0;
        s{f}.random_seed = 'shuffle';
        
        datapf1c = kramer_IB_function_mode(s{f},f);
        
        
        
    case '3a'
        %% Paper Fig 3a - Vary frequencies low
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig3a_lowfreq'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1;
        s{f}.pulse_train_preset = 0;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','PPfreq',[15,20,25,28,30,33,35,37]; ...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.PPonset = 0;
        
        datapf3a = kramer_IB_function_mode(s{f},f);
        
        
    case '3b'
        %% Paper Fig 3b - Vary frequency high
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig3b_highfreq'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1;
        s{f}.pulse_train_preset = 0;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','PPfreq',[50,65,85,105]; ...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.PPonset = 0;
        
        datapf3b = kramer_IB_function_mode(s{f},f);

    case '4a'
        %% Paper Fig 4a - Lakatos 2005 - Entrainment
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig4_lakatos'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 5;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','PPmaskfreq',[0.01,fliplr([1, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4])];...
            };
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 5500];
        
        datapf4a = kramer_IB_function_mode(s{f},f);
        
    case '5a'
        %% Paper Fig 5a - Inverse PAC
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig5a_iPAC'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 18;
        s{f}.pulse_mode = 5;
        
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 5500];
        
        datapf5a = kramer_IB_function_mode(s{f},f);
        
        
        
    case '5b'
        %% Paper Fig 5b - Inverse PAC part 2 - block IB PPStim
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig5b_iPAC'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 18;
        s{f}.pulse_mode = 5;
        
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        
        s{f}.tspan=[0 5500];
        s{f}.IB_PP_gSYN=0;
        
        datapf5b = kramer_IB_function_mode(s{f},f);
        
        
    case '5c'
        %% Paper Fig 5c - Inverse PAC part 3 - block DeepFS
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig5c_iPAC'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 18;
        s{f}.pulse_mode = 5;
        
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        
        s{f}.tspan=[0 5500];
        s{f}.deep_gNaF=0;
        
        datapf5c = kramer_IB_function_mode(s{f},f);
   
    case '6a'
        %% Paper Fig 6a - Vary onset
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig6a_onset'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','(PPonset)',[750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300];...
            };
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 3000];
        
        datapf6a = kramer_IB_function_mode(s{f},f);
        
        
             
    case '7a'
        %% Paper 7a - Characterize delta rhythm - block gamma input; sweep IB Poisson (use this one for paper, since pure tone)
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig7a_2HzPoisson'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 5;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 5500];
        s{f}.deep_gNaF=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '7b'
        %% Paper 7b - Characterize delta rhythm - block gamma input; sweep IB Poisson 40 Hz
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig7b_2HzPoiss40Hz'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 5;
        s{f}.kerneltype_IB = 2;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 5500];
        s{f}.deep_gNaF=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '7c'
        %% Paper 7c - Characterize delta rhythm - block Poisson input; allow FS gamma
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig7c_2Hz_FSIB40Hz'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 5;
        s{f}.kerneltype_IB = 4;
        Nfs = 20;
        s{f}.vary = {'dFS5->IB','g_SYN',[0,0.1:0.05:0.35,0.5]/Nfs;...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 5500];
        s{f}.IB_PP_gSYN=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8a'
        %% Paper 8a - Characterize delta rhythm - block gamma input; sweep IB Poisson (use this one for paper, since pure tone)
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8a_OnsetPoisson'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 2000];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        s{f}.deep_gNaF=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
        
    case '8b'
        %% Paper 8b - Characterize delta rhythm - block gamma input; sweep IB Poisson 40 Hz
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8b_OnsetPoiss40Hz'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 2;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 2000];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        s{f}.deep_gNaF=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8c'
        %% Paper 8c - Characterize delta rhythm - Poisson input, sweep gamma dFS->IB
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8c_Onset_FSIB40Hz'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 2;
        s{f}.Nfs = 20;
        s{f}.vary = {'dFS5->IB','g_SYN',[0:0.05:0.35]/s{f}.Nfs;...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 2000];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        s{f}.IB_PP_gSYN=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8d'
        %% Paper 8d - Sweep both IB Poisson and gamma input strength
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8d_2D'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;
        s{f}.Nfs = 20;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
                     'dFS5->IB','g_SYN',[0:0.05:0.35]/s{f}.Nfs;...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.tspan=[0 2000];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '9a'
        %% Paper 9a - Polley figure - as in Guo, Polley 2017
            % Same simulation and sweep across random seeds; averaging
            % plots together.
        % Setup
        short_mode = false;  % If true, do a shorter sim
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9a_polley'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 6;
        
        
        s{f}.PPmaskfreq = 1;    % Do a pulse every 1 second
        s{f}.PPonset = 3950;    % Just let the pulse at 4000 through
        s{f}.PPoffset = 4500;
        
%         % Shuffle through a bunch of values        
        s{f}.vary = { ...
            'RS','myshuffle',1:16;...
            };
%         s{f}.vary = { ...
%             'IB','stim2',[0:0.5:1.5, 2:5];...
%             };

        % Reduce Ncells
%         s{f}.Nrs = 20;

        s{f}.random_seed = 'shuffle';
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 5500];
        
        % Shorten some sim parameters for short mode
        if short_mode
          s{f}.tspan=[0 2500];
          s{f}.PPonset = 950;
          s{f}.PPoffset = 1500;
          s{f}.vary = {'RS','myshuffle',1:8};
        end
        
        % Modifications to each sim have random IC's and independent noise
        s{f}.Jng1=1;   % NG cells
        %s{f}.IC_noise = 0.5;
        s{f}.syn_ngib_IC_noise = 0.5;
        s{f}.random_seed = 'shuffle';
        
        % Add a plot
        plot_options.linecolor = 'k';
        chosen_height = 1/3;
        s{f}.plot_func = @dsPlot2;
        % Full range
        s{f}.parallel_plot_entries_additional{1} = {'population','IB','variable','/V/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,'plot_options',plot_options,...
            'figheight',chosen_height};
        s{f}.parallel_plot_entries_additional{2} = {'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|AMPANMDA_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,...
            'figheight',chosen_height};
        
        % 1000 ms
        s{f}.parallel_plot_entries_additional{3} = {'population','IB','variable','/V/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,'plot_options',plot_options,...
            'xlims',[4000,5500],'figheight',chosen_height};
        s{f}.parallel_plot_entries_additional{4} = {'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|AMPANMDA_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,...
            'xlims',[4000,5500],'figheight',chosen_height};
        
        % Adjust AR
        % s{f}.gAR_d=0.5;

        datapf9a = kramer_IB_function_mode(s{f},f);
        
    case '9b'
        %% Paper 9b - Polley figure - Lakatos version (vary frequency)
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9b_polley'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 6;
        
        temp = [400:50:800,10000]; temp = 1000./(100+temp);
        s{f}.vary = { %'IB','PPstim',[-1:-1:-5]; ...
            '(IB,NG,RS,FS,LTS,dFS5)','(PPmaskfreq)',[temp];...
            };
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 5500];

        datapf9b = kramer_IB_function_mode(s{f},f);
        
    case '9c'
        %% Paper 9c - As 9a but block m current
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9c_mblk'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 6;
        
        
        s{f}.PPmaskfreq = 1;    % Do a pulse every 1 second
        s{f}.PPonset = 3950;    % Just let the pulse at 4000 through
        s{f}.PPoffset = 4500;
        
        % Shuffle through a bunch of values
        s{f}.vary = { ...
            'RS','myshuffle',1:8;...
            };
        s{f}.random_seed = 'shuffle';
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 5500];
        
        s{f}.gM_d = 0.5;        % Don't fully block, just reduce it substantially

        datapf9c = kramer_IB_function_mode(s{f},f);
    case '9d'
        %% Paper 9d - As 9a but block h current
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9d_hblk'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 6;
        
        
        s{f}.PPmaskfreq = 1;    % Do a pulse every 1 second
        s{f}.PPonset = 3950;    % Just let the pulse at 4000 through
        s{f}.PPoffset = 4500;
        
        % Shuffle through a bunch of values
        s{f}.vary = { ...
            'RS','myshuffle',1:8;...
            };
        s{f}.random_seed = 'shuffle';
        s{f}.parallel_flag = 1; s{f}.maxNcores = maxNcores;
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 5500];
        
        s{f}.gAR_d = 0;

        datapf9c = kramer_IB_function_mode(s{f},f);
end

end