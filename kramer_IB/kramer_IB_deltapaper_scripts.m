
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m

%% Figures 1 Test turning on/off PPStim for various populations
% Setup
clear s
f = 0;

% Simulation batch 1
f = f + 1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.sim_mode = 1;
s{f}.parallel_flag = 1;
i=0;
i=i+1; s{f}.vary{i} = {'(IB,RS,FS)','PP_gSYN',[0.25, 0.2, 0.2]};     % Rows are applied to populations
i=i+1; s{f}.vary{i} = {'(IB,RS,FS)','PP_gSYN',[0.00, 0.2, 0.1]};
i=i+1; s{f}.vary{i} = {'(IB,RS,FS)','PP_gSYN',[0.25, 0.0, 0.0]};

clear data;
for f = 1:length(s)
    datac{f} = kramer_IB_function_mode(s{f});
end
data = datac{1};



%% Figures 2 Test varying stim frequency

% Setup
clear s
f = 0;

% Simulation batch 1
f = f + 1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.parallel_flag = 1;
s{f}.vary = {'(IB,RS,FS)','PPfreq',[10,30,50,70]};     % Rows are applied to populations

clear data;
for f = 1:length(s)
    datac{f} = kramer_IB_function_mode(s{f});
end
data = datac{1};


%% Figures 2 Test everything default

% Setup
clear s
f = 0;

% Simulation batch 1
f = f + 1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['Batch2p' num2str(f)];

clear data;
for f = 1:length(s)
    datac{f} = kramer_IB_function_mode(s{f});
end
data = datac{1};



%% Figures 3 Test without RS PPStim

% Setup
clear s
f = 0;

% Simulation batch 1
f = f + 1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.RS_PP_gSYN = 0;     % Set RS PPStim to zero
s{f}.repo_studyname = ['Batch3p' num2str(f)];

clear data;
for f = 1:length(s)
    datac{f} = kramer_IB_function_mode(s{f});
end
data = datac{1};




%% Paper Figs 1 - Pulse train & spontaneous

% Setup
clear s
f = 0;

% Default sim with PP
f = f + 1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig1p' num2str(f)];
s{f}.ap_pulse_num = 0;

% Default sim with AP
f = f + 1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig1p' num2str(f)];

% Spontaneous
f = f + 1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig1p' num2str(f)];
s{f}.pulse_mode = 0;     % Turn off pulsemode

clear data;
parfor f = 1:length(s)
    datac{f} = kramer_IB_function_mode(s{f},f);
end
data = datac{1};

%% Paper Fig 3a - Vary frequencies low

% Setup
clear s
f=1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig3a_lowfreq' num2str(f)];
s{f}.ap_pulse_num = 0;
s{f}.sim_mode = 15;
s{f}.pulse_mode = 1;
s{f}.ap_pulse_num = 0;
s{f}.PPonset = 0;

datapf3a = kramer_IB_function_mode(s{f},f);



%% Paper Fig 3b - Vary frequency high

% Setup
clear s
f=1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig3b_highfreq' num2str(f)];
s{f}.ap_pulse_num = 0;
s{f}.sim_mode = 16;
s{f}.pulse_mode = 1;
s{f}.ap_pulse_num = 0;
s{f}.PPonset = 0;

datapf3b = kramer_IB_function_mode(s{f},f);


%% Paper Fig 3c - Vary onset

% Setup
clear s
f=1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig3c_onset' num2str(f)];
s{f}.ap_pulse_num = 0;
s{f}.sim_mode = 11;
s{f}.pulse_mode = 1;
s{f}.ap_pulse_num = 0;
s{f}.tspan=[0 2500];

datapf3c = kramer_IB_function_mode(s{f},f);


%% Paper Fig 4 - Lakatos 2005 - Entrainment

% Setup
clear s
f=1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig4_lakatos' num2str(f)];
s{f}.ap_pulse_num = 0;
s{f}.sim_mode = 17;
s{f}.pulse_mode = 5;
s{f}.tspan=[0 5500];

datapf4 = kramer_IB_function_mode(s{f},f);



%% Paper Fig 5a - Inverse PAC

% Setup
clear s
f=1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig5a_iPAC' num2str(f)];
s{f}.ap_pulse_num = 0;
s{f}.sim_mode = 18;
s{f}.pulse_mode = 5;
s{f}.tspan=[0 5500];

datapf5a = kramer_IB_function_mode(s{f},f);




%% Paper Fig 5b - Inverse PAC part 2 - block IB PPStim

% Setup
clear s
f=1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig5b_iPAC' num2str(f)];
s{f}.ap_pulse_num = 0;
s{f}.sim_mode = 18;
s{f}.pulse_mode = 5;
s{f}.tspan=[0 5500];
s{f}.IB_PP_gSYN=0;

datapf5b = kramer_IB_function_mode(s{f},f);



%% Paper Fig 5c - Inverse PAC part 3 - block DeepFS

% Setup
clear s
f=1;
s{f} = struct;
s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1;
s{f}.repo_studyname = ['DeltaFig5c_iPAC' num2str(f)];
s{f}.ap_pulse_num = 0;
s{f}.sim_mode = 18;
s{f}.pulse_mode = 5;
s{f}.tspan=[0 5500];
s{f}.deep_gNaF=0;

datapf5c = kramer_IB_function_mode(s{f},f);


