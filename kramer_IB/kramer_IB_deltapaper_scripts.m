
% This script runs multiple simulations with pre-defined parameters. This
% will reproduce all the figures in the paper. It works by calling
% kramer_IB_function_mode, which in turn runs kramer_IB.m

%% Setup
f = 0;
clear s

%% Figures
f = f + 1;
s{f} = struct;
s{f}.parallel_flag = 1;
i=0;
i=i+1; s{f}.vary{i} = {'(IB,RS)','PP_gSYN',[0.25, 0.2]};     % Rows are applied to populations
i=i+1; s{f}.vary{i} = {'(IB,RS)','PP_gSYN',[0.00, 0.2]};
i=i+1; s{f}.vary{i} = {'(IB,RS)','PP_gSYN',[0.25, 0.0]};

clear data;
for f = 1:length(s)
    data{f} = kramer_IB_function_mode(s{f});
end

