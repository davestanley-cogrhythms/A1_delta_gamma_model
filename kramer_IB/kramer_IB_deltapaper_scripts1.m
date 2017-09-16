
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m
% 
% kramer_IB_deltapaper_scripts1 - Initial testing of network
% kramer_IB_deltapaper_scripts2 - Figures used in actual paper.

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

clear datac;
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

clear datac;
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

clear datac;
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

clear datac;
for f = 1:length(s)
    datac{f} = kramer_IB_function_mode(s{f});
end
data = datac{1};



