
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m
%
% kramer_IB_deltapaper_scripts1 - Initial testing of network
% kramer_IB_deltapaper_scripts2 - Figures used in actual paper.

function kramer_IB_deltapaper_scripts2(chosen_cell)

switch chosen_cell
    case '1a'
        %% Paper Figs 1a - Pulse train no AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.sim_mode = 1;
        s{f}.repo_studyname = ['DeltaFig1a' num2str(f)];
        s{f}.ap_pulse_num = 0;
        
        datapf1a = kramer_IB_function_mode(s{f},f);
        
    case '1b'
        %% Paper Figs 1b - Pulse train AP
        
        clear s
        f = 1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.sim_mode = 1;
        s{f}.repo_studyname = ['DeltaFig1b' num2str(f)];
        
        datapf1b = kramer_IB_function_mode(s{f},f);
        
    case '1c' 
        %% Paper Figs 1c - Spontaneous
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.sim_mode = 1;
        s{f}.repo_studyname = ['DeltaFig1c' num2str(f)];
        s{f}.pulse_mode = 0;     % Turn off pulsemode
        s{f}.tspan=[0 2500];
        
        datapf1c = kramer_IB_function_mode(s{f},f);
        
        
        
    case '3a'
        %% Paper Fig 3a - Vary frequencies low
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig3a_lowfreq' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','PPfreq',[15,20,25,28,30,33,35,37]; ...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 1;
        s{f}.ap_pulse_num = 0;
        s{f}.PPonset = 0;
        
        datapf3a = kramer_IB_function_mode(s{f},f);
        
        
    case '3b'
        %% Paper Fig 3b - Vary frequency high
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig3b_highfreq' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','PPfreq',[50,65,85,105]; ...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 1;
        s{f}.ap_pulse_num = 0;
        s{f}.PPonset = 0;
        
        datapf3b = kramer_IB_function_mode(s{f},f);

    case '4a'
        %% Paper Fig 4a - Lakatos 2005 - Entrainment
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig4_lakatos' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','PPmaskfreq',[0.01,fliplr([1, 1.25, 1.5, 1.75, 2])];...
            };
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 5;
        s{f}.tspan=[0 5500];
        
        datapf4a = kramer_IB_function_mode(s{f},f);
        
    case '5a'
        %% Paper Fig 5a - Inverse PAC
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig5a_iPAC' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 18;
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 5;
        s{f}.tspan=[0 5500];
        
        datapf5a = kramer_IB_function_mode(s{f},f);
        
        
        
    case '5b'
        %% Paper Fig 5b - Inverse PAC part 2 - block IB PPStim
        
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig5b_iPAC' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 18;
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 5;
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
        s{f}.repo_studyname = ['DeltaFig5c_iPAC' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 18;
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 5;
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
        s{f}.repo_studyname = ['DeltaFig6a_onset' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','(PPonset)',[750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300];...
            };
        s{f}.kerneltype_IB = 4;
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 1;
        s{f}.ap_pulse_num = 0;
        s{f}.tspan=[0 2500];
        
        datapf3c = kramer_IB_function_mode(s{f},f);
        
        
             
    case '7a'
        %% Paper 7a - Characterize delta rhythm - block gamma input; sweep Poisson (use this one for paper, since pure tone)
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig7a_2HzPoisson' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0:.25:1.75]/10; ...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 5;
        s{f}.tspan=[0 5500];
        s{f}.deep_gNaF=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '7b'
        %% Paper 7b - Characterize delta rhythm - block gamma input; sweep Poisson 40 Hz
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig7b_2HzPoiss40Hz' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.kerneltype_IB = 2;
        s{f}.vary = {'IB','PP_gSYN',[0:.25:1.75]/10; ...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 5;
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
        s{f}.repo_studyname = ['DeltaFig7c_2Hz_FSIB40Hz' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.kerneltype_IB = 4;
        Nfs = 20;
        s{f}.vary = {'dFS5->IB','g_SYN',[0,0.1:0.05:0.35,0.5]/Nfs;...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 5;
        s{f}.tspan=[0 5500];
        s{f}.IB_PP_gSYN=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8a'
        %% Paper 8a - Characterize delta rhythm - block gamma input; sweep Poisson (use this one for paper, since pure tone)
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8a_OnsetPoisson' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0:.25:1.75]/10; ...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 1;
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 1200;
        s{f}.deep_gNaF=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8b'
        %% Paper 8b - Characterize delta rhythm - block gamma input; sweep Poisson 40 Hz
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8b_OnsetPoiss40Hz' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.kerneltype_IB = 2;
        s{f}.vary = {'IB','PP_gSYN',[0:.25:1.75]/10; ...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 1;
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 1200;
        s{f}.deep_gNaF=0;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8c'
        %% Paper 8c - Characterize delta rhythm - Poisson input, sweep gamma dFS->IB
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8c_Onset_FSIB40Hz' num2str(f)];
        s{f}.ap_pulse_num = 0;
        s{f}.sim_mode = 1;
        s{f}.kerneltype_IB = 2;
        Nfs = 20;
        s{f}.vary = {'dFS5->IB','g_SYN',[0,0.1:0.05:0.35,0.5]/Nfs;...
            };
        s{f}.parallel_flag = 1;
        s{f}.pulse_mode = 1;
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 1200;
        s{f}.IB_PP_gSYN=0;
        
        data = kramer_IB_function_mode(s{f},f);
end

end