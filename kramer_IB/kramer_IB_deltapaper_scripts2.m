
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

namesuffix = '_gar0.25';
% namesuffix = '_gar0.0';
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
        s{f}.random_seed = 4;
        
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
        s{f}.random_seed = 4;
        
        datapf1b = kramer_IB_function_mode(s{f},f);
        
    case '1c' 
        %% Paper Figs 1c - Spontaneous
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.sim_mode = 1;
        s{f}.repo_studyname = ['DeltaFig1c'  num2str(f) '' namesuffix];
        s{f}.tspan=[0 3000];
        s{f}.pulse_mode = 0;
        s{f}.random_seed = 4;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 5500];
        s{f}.random_seed = 'shuffle';
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        
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
        s{f}.vary = { '(RS,FS,LTS,IB,NG,dFS5)','(PPonset)',[[750,800,850,900,950,1000,1050,1100,1150,1200,1250]-200, 1999];...
            };
        s{f}.kerneltype_IB = 4;
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2000];
        s{f}.random_seed = 5;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 5500];
        s{f}.deep_gNaF=0;
        s{f}.random_seed = 4;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 5500];
        s{f}.deep_gNaF=0;
        s{f}.random_seed = 4;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 5500];
        s{f}.IB_PP_gSYN=0;
        s{f}.random_seed = 4;
        %s{f}.PPmaskfreq = 1.5;
        %s{f}.PPmaskduration = 100;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        s{f}.gGABAa_fs5ib = 0;
        s{f}.random_seed = 2;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        s{f}.gGABAa_fs5ib = 0;
        s{f}.random_seed = 2;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        s{f}.IB_PP_gSYN=0;
        s{f}.random_seed = 2;
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '9a'
        %% Paper 9a - Polley figure - as in Guo, Polley 2017
            % Same simulation and sweep across random seeds; averaging
            % plots together.
        % Setup
        short_mode = false;  % If true, do a shorter sim
        blk_h_current = false;        
        blk_m_current = false;
        clear s
        
        PPmaskduration = 50;
        [s,f] = setupf_9a_sf(maxNcores,namesuffix,chosen_cell,short_mode,blk_h_current,blk_m_current,PPmaskduration);

        data = kramer_IB_function_mode(s{f},f);
        
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
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 5500];

        datapf9b = kramer_IB_function_mode(s{f},f);
        
    case '9c'
        %% Paper 9c - Sweep timing of dFS stimulation
        % Setup
        blk_h_current = false;        
        blk_m_current = false;
        clear s
        f=1;
        s{f} = struct;
        
        s{f}.PPmaskduration = 50;
        namesuffix1 = namesuffix;
        
        namesuffix1 = [namesuffix1 '_pulse_' num2str(s{f}.PPmaskduration) 'ms'];
        
        if blk_h_current
            namesuffix1 = [namesuffix1 '_blkgAR'];
            s{f}.gAR_d = 0;
        end
        
        if blk_m_current
            namesuffix1 = [namesuffix1 '_blkgM'];
            s{f}.gM_d = 0.5;        % Don't fully block, just reduce it substantially
        end
        
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig9c_polley'  num2str(f) '' namesuffix1];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 6;
        
        % Make NG stim longer
%         s{f}.IB_offset1 = 100;
%         s{f}.IB_onset2=100;
        
        % PPStim stuff
        s{f}.pulse_train_preset = 0;
        s{f}.PPmaskfreq = 0.01;    % 1 pulse every 100 seconds. This should make only pulse ever happen.
        if strcmp(namesuffix,'blkgAR')
            % Do this one if AR current is off
            s{f}.vary = { ...
                '(RS,FS,LTS,NG,dFS5)','PPmaskshift',[750:50:1250,3000];...
            };
        else
            % Do this one otherwise
            s{f}.vary = { ...
                '(RS,FS,LTS,NG,dFS5)','PPmaskshift',[750:50:1250,3000];...
            };
        end

        % Reduce Ncells
%         s{f}.Nrs = 20;

        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.pulse_mode = 6;
        s{f}.tspan=[0 2000];
        
        
        % Same seed on every sim
        s{f}.random_seed = 3;    
        

        datapf9c = kramer_IB_function_mode(s{f},f);
        
    case '9d'
        %% Paper 9d - As Fig 9a, but different PPmaskduration
        % Setup
        short_mode = false;  % If true, do a shorter sim
        blk_h_current = false;        
        blk_m_current = false;
        clear s
        
        PPmaskduration = 10;
        [s,f] = setupf_9a_sf(maxNcores,namesuffix,chosen_cell,short_mode,blk_h_current,blk_m_current,PPmaskduration);

        data = kramer_IB_function_mode(s{f},f);
    case '9e'
        %% Paper 9d - As Fig 9a, but different PPmaskduration
        % Setup
        short_mode = false;  % If true, do a shorter sim
        blk_h_current = false;        
        blk_m_current = false;
        clear s
        
        PPmaskduration = 20;
        [s,f] = setupf_9a_sf(maxNcores,namesuffix,chosen_cell,short_mode,blk_h_current,blk_m_current,PPmaskduration);

        data = kramer_IB_function_mode(s{f},f);
    case '9f'
        %% Paper 9d - As Fig 9a, but different PPmaskduration
        % Setup
        short_mode = false;  % If true, do a shorter sim
        blk_h_current = false;        
        blk_m_current = false;
        clear s
        
        PPmaskduration = 100;
        [s,f] = setupf_9a_sf(maxNcores,namesuffix,chosen_cell,short_mode,blk_h_current,blk_m_current,PPmaskduration);

        data = kramer_IB_function_mode(s{f},f);
    case '9g'
        %% Paper 9d - As Fig 9a, but different PPmaskduration
        % Setup
        short_mode = false;  % If true, do a shorter sim
        blk_h_current = false;        
        blk_m_current = false;
        clear s
        
        PPmaskduration = 200;
        [s,f] = setupf_9a_sf(maxNcores,namesuffix,chosen_cell,short_mode,blk_h_current,blk_m_current,PPmaskduration);

        data = kramer_IB_function_mode(s{f},f);
    case '9h'
        %% Paper 9d - As Fig 9a, but block h current
        % Setup
        short_mode = false;  % If true, do a shorter sim
        blk_h_current = true;        
        blk_m_current = false;
        clear s
        
        PPmaskduration = 50;
        [s,f] = setupf_9a_sf(maxNcores,namesuffix,chosen_cell,short_mode,blk_h_current,blk_m_current,PPmaskduration);

        data = kramer_IB_function_mode(s{f},f);
        
    case '9i'
        %% Paper 9d - As Fig 9a, but block m current
        % Setup
        short_mode = false;  % If true, do a shorter sim
        blk_h_current = false;        
        blk_m_current = true;
        clear s
        
        PPmaskduration = 50;
        [s,f] = setupf_9a_sf(maxNcores,namesuffix,chosen_cell,short_mode,blk_h_current,blk_m_current,PPmaskduration);

        data = kramer_IB_function_mode(s{f},f);
        
%% % % % % % % % % % % % % % % % % % For supplementary figures % % % % % % % % % % % % % % % % % % % % 
    case '8e'
        %% As paper 8a, except different gFS5 -> IB conductance
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8e_OnsetPoisson'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        
        s{f}.Nfs = 20;
        s{f}.gGABAa_fs5ib = 0.05/s{f}.Nfs;
        s{f}.random_seed = 2;
        s{f}.repo_studyname = [s{f}.repo_studyname '_gfs5ib' num2str(s{f}.gGABAa_fs5ib * s{f}.Nfs)];
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8f'
        %% As paper 8a, except different gFS5 -> IB conductance
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8f_OnsetPoisson'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        
        s{f}.Nfs = 20;
        s{f}.gGABAa_fs5ib = 0.1/s{f}.Nfs;
        s{f}.random_seed = 2;
        s{f}.repo_studyname = [s{f}.repo_studyname '_gfs5ib' num2str(s{f}.gGABAa_fs5ib * s{f}.Nfs)];
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8g'
        %% As paper 8a, except different gFS5 -> IB conductance
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8g_OnsetPoisson'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        
        s{f}.Nfs = 20;
        s{f}.gGABAa_fs5ib = 0.15/s{f}.Nfs;
        s{f}.random_seed = 2;
        s{f}.repo_studyname = [s{f}.repo_studyname '_gfs5ib' num2str(s{f}.gGABAa_fs5ib * s{f}.Nfs)];
        
        data = kramer_IB_function_mode(s{f},f);
        
        
    case '8h'
        %% As paper 8a, except different gFS5 -> IB conductance
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8h_OnsetPoisson'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;
        s{f}.vary = {'IB','PP_gSYN',[0,0.1:.2:1.3]/10; ...
            };
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        
        s{f}.Nfs = 20;
        s{f}.gGABAa_fs5ib = 0.2/s{f}.Nfs;
        s{f}.random_seed = 2;
        s{f}.repo_studyname = [s{f}.repo_studyname '_gfs5ib' num2str(s{f}.gGABAa_fs5ib * s{f}.Nfs)];
        
        data = kramer_IB_function_mode(s{f},f);
        
    case '8i'
        %% As paper 8c - except non-zero IB PPStim
        % Setup
        clear s
        f=1;
        s{f} = struct;
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
        s{f}.repo_studyname = ['DeltaFig8i_Onset_FSIB40Hz'  num2str(f) '' namesuffix];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 1; s{f}.pulse_train_preset = 0;
        s{f}.kerneltype_IB = 4;
        s{f}.Nfs = 20;
        s{f}.vary = {'dFS5->IB','g_SYN',[0:0.05:0.25]/s{f}.Nfs;...
            };
        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.tspan=[0 2500];
        s{f}.PPonset = 400;
        s{f}.PPoffset = 1500;
        s{f}.IB_PP_gSYN=0.05;
        s{f}.random_seed = 2;
        s{f}.repo_studyname = [s{f}.repo_studyname '_IBPPStim' num2str(s{f}.IB_PP_gSYN)];
        
        data = kramer_IB_function_mode(s{f},f);

end

end

