%%

%% Adjust params
% Utility for making parameters uniform - useful for reducing the spam
% output of dsSpecDiff. 
% 
% This should be run using brakepoints, to insert it before
% include_kramer_IB_populations is run. 
% 
% Used for creating specs.mat file
% See also specs.txt

tspan = [0 2000];
PPfreq = 40;
PPonset = 350;
PPoffset = 2000;
ap_pulse_num = round(min(PPoffset,tspan(end))/(1000/PPfreq))-10;
IB_offset1 = 50;
IB_onset2 = 50;

PPmaskfreq = 2.0;
pulse_train_preset = 1;

