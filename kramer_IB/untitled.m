%% Generate pulse train 
T=0:0.01:2000;
Npop = 3;

% Pulse train properties
PPfreq = 40; % in Hz
PPwidth = 1; % in ms        % Pseudo Action potential width
PPshift = 0; % in ms

% Time series properties
Tend=T(end); 	    % ms, max simulation duration
dt=0.01;        % ms, time step duration
PPonset = 300;    % ms, onset time
PPoffset = Inf;   % ms, offset time

% Aperiodic pulse specification
ap_pulse_num = 0;        % The pulse number that should be delayed. 0 for no aperiodicity.
ap_pulse_delay = 12.5;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.

% Pulse train preset (codes for different presets of pulse train; see getDeltaTrainPresets.m for details)
pulse_train_preset = 1;

kernel_type = 1;
width2_rise = 0.25;

% Synaptic response properties
PP_gSYN = [0]		% mS/cm2, maximal conductance
E_SYN = [0]             % mV, reversal potential
tauDx = [100]
tauRx = [.5]
IC = [0.0]
IC_noise = [0]
PP_g_SYN_hetero = 0

PPgsyn0=unifrnd(PP_gSYN*(1-PP_g_SYN_hetero),PP_gSYN*(1+PP_g_SYN_hetero),[Npop 1])'
PPgsyn=PPgsyn0.* double(PPgsyn0 > 0)

% Build pulse train
s0 = getDeltaTrainPresets2(PPfreq,PPshift,Tend,dt,ap_pulse_num,ap_pulse_delay,pulse_train_preset);
%%
% Build masking pulse train
PPmaskfreq = 2
PPmaskduration = 100
do_nested_mask = 1


s0_mask = getDeltaTrainPresets2(PPmaskfreq,0,Tend,dt,0,0,0);
s0_maskb = convolveDeltaTrainwithKernel(s0_mask,dt,PPmaskduration,1,3,-dt);

s1 = applyMasks(s0,PPonset,PPoffset,Tend,dt,do_nested_mask,s0_maskb);


s2 = convolveDeltaTrainwithKernel(s1,dt,PPwidth,Npop,kernel_type,width2_rise);



%%
% Convert train to pseudo Vm (action potentials)
X_pseudo = 100*s2(k,:) - 60;           % Membrane voltage of simulated pre-synaptic cell action potentials goes from -60 to +40 mV 


% iSYN: Generic 2-state synapse
ISYN(X,s) = (PPgsyn.*s.*(X-E_SYN))
 
s' = -s./tauDx + ((1-s)/tauRx).*(1+tanh(X_pseudo(k)/10));
s(0) = IC*ones(Npop,1)+IC_noise.*rand(Npop,1)

monitor ISYN % always record the synaptic current
 
% Linkers
@current += -ISYN(X,s)

