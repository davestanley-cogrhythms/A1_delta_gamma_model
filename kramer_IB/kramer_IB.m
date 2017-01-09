% Model: Kramer 2008, PLoS Comp Bio
%%
tic
clear


addpath(genpath(fullfile('.','funcs_supporting')));

%% #1.0 Simulation switches
% % Display options
plot_on = 1;
save_plots = 0;
visible_flag = 'on';
compile_flag = 1;
random_seed = 'shuffle';
random_seed = 2;

% % Choice normal sim (sim_mode=1) or parallel sim options
sim_mode = 1;   % 1 - normal sim
                % 9 - sim study FS-RS circuit vary RS stim
                % 10 - Vary iPeriodicPulses in all cells
                % 11 - Vary FS cells
                % 12 - Vary IB cells
                % 13 - Vary LTS cell synapses
                % 14 - Vary random parameter in order to get repeat sims
                
                
% % Cells to include in model
include_IB = 0;
include_RS = 1;
include_FS = 1;
include_LTS = 1;
include_NG = 0;
include_supRS = 0;
include_supFS = 0;

% % Simulation controls
tspan=[0 500]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=max(round(0.1/dt),1); % downsample factor, applied after simulation

% % Simulation switches
no_noise = 0;
no_synapses = 0;
NMDA_block = 0; 


%% ##2.0 Model parameters
% Note: For some of these parameters I will define them twice - once I will
% initially define them as set to zero, and then I will define them a
% second time. I do this so that you can easily comment out the second
% definition as way to disable things (e.g. setting synapses to zero).

% % Number of cells per population
N=30;   % Number of excitatory cells
Nrs=N; % Number of RS cells
Nng=N;  % Number of FSNG cells
Nfs=N;  % Number of FS cells
Nlts=N; % Number of LTS cells
NsupRS = 30; 
NsupFS = N;

% % % % % % % % % % % % % ##2.1 Injected currents % % % % % % % % % % % % %  
% % Tonic input currents.
% Note: IB, NG, and RS cells use two different values for tonic current
% injection. This is because I generally hyperpolarize these cells for a
% few hundred milliseconds to allow things to settle (see
% itonicPaired.txt). The hyperpolarizing value is listed first (e.g. JRS1)
% and then the value that kicks in after this is second (e.g. JRS2).
% Note2: Positive values are hyperpolarizing, negative values are
% depolarizing.
Jd1=5;    % IB cells
Jd2=0;    %         
Jng1=3;   % NG cells
Jng2=1;   %
JRS1 = 5; % RS cells
JRS2 = 1; %
Jfs=1;    % FS cells
Jlts=.75; % LTS cells
supJRS1 = 5;    % RS superficial cells
supJRS2 = 0.75;
supJfs = 1;     % FS superficial cells


% % Tonic current onset and offset times
% Times at which injected currnets turn on and off (in milliseconds). See
% itonicPaired.txt. Setting these to 0 essentailly removes the first
% hyperpolarization step.
IB_offset1=0;
IB_onset2=0;
RS_offset1=0;
RS_onset2=0;

% % Poisson EPSPs to IB and RS cells (synaptic noise)
gRAN=.015;      % synaptic noise conductance IB cells 
ERAN=0;
tauRAN=2;
lambda = 1000;  % Mean frequency Poisson IPSPs
RSgRAN=0.005;   % synaptic noise conductance to RS cells
supRSgRAN = 0.005; % synaptic noise conductance to supRS cells

% % Magnitude of injected current Gaussian noise
IBda_Vnoise = .3;
IBs_Vnoise = .1;
IBdb_Vnoise = .3;
IBa_Vnoise = .1;
NG_Vnoise = 3;
FS_Vnoise = 3;
LTS_Vnoise = 6;
RSda_Vnoise = .3;
supRSda_Vnoise = .3;
supFS_Vnoise = 3;

% % Periodic pulse stimulation parameters
pulse_mode = 1;
switch pulse_mode
    case 0                  % No stimulation
        PPfreq = 4; % in Hz
        PPwidth = 2; % in ms
        PPshift = 0; % in ms
        PPonset = 10;    % ms, onset time
        PPoffset = tspan(end)-0;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 0;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 0;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        width2_rise = 0.75;  % Not used for Gaussian pulse
        kernel_type = 2;
        PPFacTau = 200;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
            RSPPFacTau = 200;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        supRSPPstim = 0;
    case 1                  % Gamma stimulation (with aperoidicity)
        PPfreq = 40; % in Hz
        PPwidth = 2; % in ms
        PPshift = 0; % in ms
        PPonset = 0;    % ms, onset time
        PPoffset = tspan(end);   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 12;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 11;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        %ap_pulse_num = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 1;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        width2_rise = .5;  % Not used for Gaussian pulse
        kernel_type = 1;
        PPFacTau = 100;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
            RSPPFacTau = 100;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        supRSPPstim = 0;
        IBPPstim = -1;
        RSPPstim = -10;
%         NGPPstim = -4;
%         FSPPstim = -5;
%         supRSPPstim = -7;

    case 2                  % Median nerve stimulation
        PPfreq = 2; % 2 Hz delta
        PPwidth = 10; % in mscd
        PPshift = 0; % in ms
        PPonset = 10;    % ms, onset time
        PPoffset = tspan(end)-0;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 0;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 0;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        width2_rise = 2.5;  % Not used for Gaussian pulse
        kernel_type = 2;
        PPFacTau = 200;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
            RSPPFacTau = 200;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        supRSPPstim = 0;
        IBPPstim = -5;
        % RSPPstim = -5;
        % NGPPstim = -4;
        % FSPPstim = -5;
        % supRSPPstim = -5;
    case 3                  % Auditory stimulation at 10Hz (possibly not used...)
        PPfreq = 10; % in Hz
        PPwidth = 2; % in ms
        PPshift = 0; % in ms
        PPonset = 10;    % ms, onset time
        PPoffset = tspan(end)-10;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 0;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 0;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        width2_rise = 0.75;  % Not used for Gaussian pulse
        kernel_type = 1;
        PPFacTau = 200;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
            RSPPFacTau = 200;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        supRSPPstim = 0;
        % IBPPstim = -3;
        % RSPPstim = -3;
        % NGPPstim = -4;
        % FSPPstim = -5;
        supRSPPstim = -3;        
end


% Steps for tuning
%     1) Get delta oscillation
%     2) Get delta oscillation with NG firing at gamma. This NG gamma
%     should start after GABA B has decayed a bit. The later the
%     better, since this will cause GABA B to decay faster. It's okay if
%     the IB cells still start bursting.
%     3) Add FS inputs. This will provide the remainder of the inhibition
%     that stops the IB cells from bursting again. It's okay to put in too
%     much so that it interrupts the first IB burst.
% 


% % % % % % % % % % % % %  ##2.2 Synaptic connectivity parameters % % % % % % % % % % % % %  
% % Gap junction connections
% % Deep cells
ggjaRS=.2/N;  % RS -> RS
ggja=.2/N;  % IB -> IB 
ggjFS=.2/Nfs;  % FS -> FS
ggjLTS=.2/Nlts;  % LTS -> LTS
    warning('Need to enable LTS gap junctions');
% % Sup cells
ggjasupRS=.00/(NsupRS);  % supRS -> supRS         % Disabled RS-RS gap junctions because otherwise the Eleaknoise doesn't have any effect
ggjsupFS=.2/NsupFS;  % supFS -> supFS


% % Synapse heterogenity
gsyn_hetero = 0;

% % Eleak heterogenity (makes excitability of cells variable)
RS_Eleak_std = 0;
FS_Eleak_std = 0;
LTS_Eleak_std = 0;
% RS_Eleak_std = 10;
% FS_Eleak_std = 20;

% % Synaptic connection strengths
% Initially set everything to zero, so that commenting out below will
% disable synaptic connections.

% % Delta oscillator (IB-NG circuit)
gAMPAee=0;
gNMDAee=0;

gAMPAei=0;
gNMDAei=0;

gGABAaii=0;
gGABAbii=0;

gGABAaie=0;
gGABAbie=0;

% % IB to LTS
gAMPA_ibLTS=0;
gNMDA_ibLTS=0;

% % Delta -> Gamma oscillator connections
gAMPA_ibrs = 0;
gNMDA_ibrs = 0;
gGABAa_ngrs = 0;
gGABAb_ngrs = 0;

% % Gamma oscillator (RS-FS-LTS circuit)
gAMPA_rsrs=0;
    gNMDA_RSRS=0;
gAMPA_rsfs=0;
    gNMDA_rsfs=0;
gGABAaff=0;
gGABAa_fsrs=0;

gAMPA_rsLTS = 0;
    gNMDA_rsLTS = 0;
gGABAa_LTSrs = 0;

gGABAa_fsLTS = 0;
gGABAa_LTSfs = 0;

% % Gamma oscillator, superficial (RS-FS circuit)
gAMPA_supRSsupRS=0;
gNMDA_supRSsupRS=0;
gAMPA_supRSsupFS=0;
gGABA_supFSsupFS=0;
gGABAa_supFSsupRS=0;

% % Deep -> Supra connections (including NG - really should model this separately!)
gAMPA_IBsupRS = 0;
gNMDA_IBsupRS = 0;
gAMPA_IBsupFS = 0;
gNMDA_IBsupFS = 0;
gAMPA_RSsupRS = 0;
gGABAa_NGsupRS=0;
gGABAb_NGsupRS=0;

% % Supra -> Deep connections
gAMPA_supRSRS = 0;
gAMPA_supRSIB = 0;


% % Gamma -> Delta connections 
gGABAafe=0;
gAMPA_rsng = 0;
gNMDA_rsng = 0;
gGABAa_LTSe = 0;

if ~no_synapses
% % Synaptic connection strengths
% #mysynapses

% % Delta oscillator (IB-NG circuit)
gAMPAee=0.1/N;                          % IB -> IB
if ~NMDA_block; gNMDAee=5/N; end        % IB -> IB NMDA

gAMPAei=0.1/N;                          % IB -> NG
if ~NMDA_block; gNMDAei=5/N; end        % IB -> NG NMDA

gGABAaii=0.1/Nng;                       % NG -> NG
gGABAbii=0.3/Nng;                       % NG -> NG GABA B

gGABAaie=0.1/Nng;                       % NG -> IB
gGABAbie=0.3/Nng;                       % NG -> IB GABA B

% % IB -> LTS
gAMPA_ibLTS=0.1/N;
if ~NMDA_block; gNMDA_ibLTS=5/N; end

% % Delta -> Gamma oscillator connections
% gAMPA_ibrs = 0.013/N;
% gNMDA_ibrs = 0.02/N;
% gGABAa_ngrs = 0.05/Nng;
% gGABAb_ngrs = 0.08/Nng;

% % Gamma oscillator (RS-FS-LTS circuit)
gAMPA_rsrs=0.1/Nrs;                     % RS -> RS
%     gNMDA_RSRS=5/Nrs;                 % RS -> RS NMDA
gAMPA_rsfs=0.4/Nrs;                     % RS -> FS
%     gNMDA_rsfs=0/Nrs;                 % RS -> FS NMDA
gGABAaff=1/Nfs;                         % FS -> FS
gGABAa_fsrs=.6/Nfs;                     % FS -> RS

gAMPA_rsLTS = 0.15/Nrs;                 % RS -> LTS
%     gNMDA_rsLTS = 0/Nrs;              % RS -> LTS NMDA
gGABAa_LTSrs = 3/Nlts;                  % LTS -> RS
% 
gGABAa_fsLTS = .2/Nfs;                  % FS -> LTS
% gGABAa_LTSfs = 5/Nlts;                % LTS -> FS


% % Gamma oscillator, superficial (RS-FS circuit)
gAMPA_supRSsupRS=0.1/(NsupRS);
        gNMDA_supRSsupRS=0.0/(NsupRS);
gAMPA_supRSsupFS=1/(NsupRS);        % Increased by 4x due to sparse firing of sup principle cells.
gGABA_supFSsupFS=0.5/NsupFS;
gGABAa_supFSsupRS=0.2/NsupFS;       % Decreased by 3x due to reduced stimulation of sup principle cells


% % Deep -> Supra connections (including NG - really should model this separately!)
% gAMPA_IBsupRS = 0.01/N;
gNMDA_IBsupRS = 0.2/N;
% gAMPA_IBsupFS = 0.01/N;
% gNMDA_IBsupFS = 0.1/N;
gAMPA_RSsupRS = 0.15/Nrs;
% gGABAa_NGsupRS=0.01/Nng;
gGABAb_NGsupRS=0.05/Nng;

% % Supra -> Deep connections
% gAMPA_supRSRS = 0.15/NsupRS;
% gAMPA_supRSIB = 0.15/NsupRS;

% % Gamma -> Delta connections 
gGABAafe=1.3/Nfs;                           % FS -> IB 
gAMPA_rsng = 0.1/Nrs;                       % RS -> NG
if ~NMDA_block; gNMDA_rsng = 2/Nrs; end     % RS -> NG NMDA
gGABAa_LTSe = 1.3/Nfs;                      % LTS -> RS

end



% Synaptic time constants & reversals
tauAMPAr=.25;  % ms, AMPA rise time; Jung et al
tauAMPAd=1;   % ms, AMPA decay time; Jung et al
tauNMDAr=5; % ms, NMDA rise time; Jung et al
tauNMDAd=100; % ms, NMDA decay time; Jung et al
tauGABAar=.5;  % ms, GABAa rise time; Jung et al
tauGABAad=8;   % ms, GABAa decay time; Jung et al
tauGABAaLTSr = .5;  % ms, LTS rise time; Jung et al
tauGABAaLTSd = 20;  % ms, LTS decay time; Jung et al
EAMPA=0;
EGABA=-95;
TmaxGABAB=0.5;      % See iGABABAustin.txt


% % % % % % % % % % % % %  ##2.3 Biophysical parameters % % % % % % % % % % % % %  
% constant biophysical parameters
Cm=.9;        % membrane capacitance
gl=.1;
ENa=50;      % sodium reversal potential
E_EKDR=-95;  % potassium reversal potential for excitatory cells
IB_Eh=-25;   % h-current reversal potential for deep layer IB cells
ECa=125;     % calcium reversal potential
IC_noise=.25;% fractional noise in initial conditions
if no_noise
    IC_noise= 0;
    IBda_Vnoise = 0;
    IBs_Vnoise = 0;
    IBdb_Vnoise = 0;
    IBa_Vnoise = 0;
    gRAN=0;
    FSgRAN=0;
end

IC_V = -65;


% % % % % % % % % % % % % % % % ##2.4 Set up parallel sims % % % % % % % % % % 
switch sim_mode
    case 1                                                                  % Everything default, single simulation
        vary = [];
    case 9  % Vary RS cells in RS-FS network

        vary = { %'RS','stim2',linspace(2,-2,12); ...
                 %'RS','PPstim',linspace(-10,-2,8); ...
                 'RS->FS','g_SYN',[0.2:0.2:.8]/Nrs;...
                 'FS->RS','g_SYN',[0.2:0.2:1]/Nfs;...
                 }; 

    case 10     % Vary PP stimulation frequency to all cells
        vary = { '(IB,NG,RS,FS,LTS)','PPfreq',[1,2,4,8];
                 }; 
             
    case 11     % Vary just FS cells
        vary = { %'FS','stim',linspace(-2,1,1); ...
                 'FS','PPstim',linspace(-6,0,8); ...
                 'FS->FS','g_SYN', linspace(0.2,1,4)/Nfs...
                 }; 
    case 12     % Vary IB cells
        vary = { %'IB','PPstim',[-1:-1:-5]; ...
                 %'NG','PPstim',[-7:1:-1]; ...
                 %'IB','stim2',[-2]; ...
%                  'IB','g_l2',[.30:0.02:.44]/Nng; ...
                 %'IB->RS','g_SYN',linspace(0.05,0.10,8)/N;...
                 %'FS->IB','g_SYN',[0.3:0.1:.5]/Nfs;...
                 'FS->IB','g_SYN',[.1:.1:.7]/Nfs;...
                 'RS->NG','gNMDA',[1:1:6]/N;...
                 %'RS->NG','gNMDA',[0:1:5]/N*0.00001;...
                 %'FS->IB','g_SYN',[.5:.1:.7]/Nfs;...
                 %'IB->RS','g_SYN',[0.01:0.003:0.03]/N;...
                 %'IB->NG','gNMDA',[5,7,9,11]/N;...
                    % For NMDA block conditions
                 %'IB->NG','gNMDA',[0.005,0.007,0.009,0.011]/N;...
                 %'RS->NG','g_SYN',[.1:.1:.3]/Nfs;...
                 %'(IB,NG,RS)', 'ap_pulse_num',[25:5:70];...
                 }; 
             
    case 13         % LTS Cell synapses
        vary = { 'RS->LTS','g_SYN',[.1:.025:.2]/Nrs;...
                 'FS->LTS','g_SYN',[.1:.1:.6]/Nfs;...
                 %'LTS','stim',[-.5:.1:.5]; ...
                 
                 }; 
             
    case 14         % Vary random parameter to force shuffling random seed
        vary = {'RS','asdfasdfadf',1:8 };       % shuffle starting seed 8 times
        random_seed = 'shuffle';                % Need shuffling to turn on, otherwise this is pointless.     
        

        
end

%% ##3.0 Build populations and synapses
% % % % % % % % % % ##3.1 Populations % % % % % % % % %
include_kramer_IB_populations;

% % % % % % % % % % ##3.2 Connections % % % % % % % % %
include_kramer_IB_synapses;


%% ##4.0 Run simulation & post process

% % % % % % % % % % ##4.1 Run simulation % % % % % % % % % %
data=SimulateModel(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,'random_seed',random_seed,'compile_flag',compile_flag,'vary',vary,'parallel_flag',double(sim_mode ~= 1),'verbose_flag',1);
% SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary,'parallel_flag',0,...
%     'cluster_flag',1,'save_data_flag',1,'study_dir','kramerout_cluster_2','verbose_flag',1);


% % % % % % % % % % ##4.2 Post process simulation data % % % % % % % % % %
% % Crop data within a time range
% t = data(1).time; data = CropData(data, t > 100 & t <= t(end));

% % Add Thevenin equivalents of GABA B conductances to data structure
if include_IB && include_NG && include_FS; data = ThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB','IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'IB_GABA'); end
if include_IB && include_NG; data = ThevEquiv(data,{'IB_NG_iGABABAustin_IGABAB'},'IB_V',[-95],'NG_GABA'); end           % GABA B only
if include_IB && include_FS; data = ThevEquiv(data,{'IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'FS_GABA'); end  % GABA A only
if include_FS; data = ThevEquiv(data,{'FS_FS_IBaIBdbiSYNseed_ISYN'},'FS_V',[-95,-95,-95],'FS_GABA2'); end  % GABA A only

% % Calculate averages across cells (e.g. mean field)
data2 = CalcAverages(data);

toc;

%% ##5.0 Plotting
if plot_on
    % % Do different plots depending on which parallel sim we are running
    switch sim_mode
        case {1,11}
            %%
            % PlotData(data,'plot_type','waveform');
            
            PlotData_with_AP_line(data,'plot_type','waveform','max_num_overlaid',50);
            %PlotData_with_AP_line(data,'plot_type','rastergram');
            %PlotData_with_AP_line(data2,'plot_type','waveform','variable','RS_LTS_IBaIBdbiSYNseed_s');
            PlotData_with_AP_line(data2,'plot_type','waveform','variable','RS_V');
    

            if include_IB && include_NG && include_FS; PlotData(data,'plot_type','waveform','variable',{'NG_GABA_gTH','IB_GABA_gTH','FS_GABA_gTH'});
            elseif include_IB && include_NG; PlotData(data2,'plot_type','waveform','variable',{'NG_GABA_gTH'});
            elseif include_IB && include_FS; PlotData(data2,'plot_type','waveform','variable',{'FS_GABA_gTH'});
            elseif include_FS;
                %PlotData(data2,'plot_type','waveform','variable',{'FS_GABA2_gTH'});
            end
            
%             PlotData(data,'plot_type','power');
            
            %elseif include_FS; PlotData(data2,'plot_type','waveform','variable',{'FS_GABA2_gTH'}); end
            %PlotFR(data);
        case {2,3}
            PlotData(data,'plot_type','waveform');
            PlotData(data,'variable','IBaIBdbiSYNseed_s','plot_type','waveform');
            PlotData(data,'variable','iNMDA_s','plot_type','waveform');

        case {5,6}
            PlotData(data,'plot_type','waveform','variable','IB_V');
        case 9
            %%
            %PlotData(data,'plot_type','waveform');
            %PlotData(data,'plot_type','power');

            %PlotData(data2,'plot_type','waveform','variable','FS_FS_IBaIBdbiSYNseed_s');
            %PlotData(data,'variable','RS_V'); PlotData(data,'variable','FS_V');
            PlotData(data,'plot_type','waveform')
            %PlotFR2(data,'plot_type','meanFR')
%             for i = 1:9:54; PlotData(data(i:i+8),'variable','RS_V','plot_type','power'); end
%             for i = 1:9:54; PlotData(data(i:i+8),'variable','RS_V'); end
%             for i = 1:9:54; PlotData(data(i:i+8),'variable','FS_V'); end
%             for i = 1:9:54; PlotData(data(i:i+8),'variable','RS_FS_IBaIBdbiSYNseed_s'); end
%             PlotStudy(data,@plot_AP_decay1_RSFS)
%             PlotStudy(data,@plot_AP_timing1_RSFS)
    %         PlotData(data,'plot_type','rastergram','variable','RS_V'); PlotData(data,'plot_type','rastergram','variable','FS_V')
    %         PlotData(data2,'plot_type','waveform','variable','RS_V');
    %         PlotData(data2,'plot_type','waveform','variable','FS_V');

    %         PlotData(data,'plot_type','rastergram','variable','RS_V');
    %         PlotData(data,'plot_type','rastergram','variable','FS_V');
    %         PlotFR2(data,'variable','RS_V'); 
    %         PlotFR2(data,'variable','FS_V'); 
    %         PlotFR2(data,'variable','RS_V','plot_type','meanFR');
    %         PlotFR2(data,'variable','FS_V','plot_type','meanFR');

        case 12
             %%
            %PlotData(data,'plot_type','rastergram','variable','RS_V');
%             if include_IB && include_NG && include_FS; PlotData(data2,'plot_type','waveform','variable',{'IB_GABA_gTH','NG_GABA_gTH','FS_GABA_gTH'},'visible',visible_flag);
%             elseif include_IB && include_NG; PlotData(data2,'plot_type','waveform','variable',{'NG_GABA_gTH'},'visible',visible_flag);
%             elseif include_IB && include_FS; PlotData(data2,'plot_type','waveform','variable',{'FS_GABA_gTH'},'visible',visible_flag); end
            close all
            PlotData(data2,'plot_type','waveform','variable',{'NG_GABA_gTH'},'visible',visible_flag);

            %PlotData(data2,'plot_type','waveform','variable','FS_FS_IBaIBdbiSYNseed_s');

            PlotData(data,'variable','IB_V','plot_type','waveform','visible',visible_flag);
            PlotData(data2,'variable','IB_V','plot_type','waveform','visible',visible_flag);
            %PlotData(data,'variable','IB_V','plot_type','rastergram');
            %PlotData(data,'plot_type','rastergram');


    %         PlotData(data,'plot_type','rastergram','variable','RS_V');
    %         PlotData(data,'plot_type','rastergram','variable','FS_V');
    %         PlotFR2(data,'variable','RS_V'); 
    %         PlotFR2(data,'variable','FS_V'); 
    %         PlotFR2(data,'variable','RS_V','plot_type','meanFR');
    %         PlotFR2(data,'variable','FS_V','plot_type','meanFR');

%             t = data(1).time; data3 = CropData(data, t > 1200 & t < 2300);
%             PlotData(data3,'variable','IB_V','plot_type','waveform');
%             PlotData(data3,'variable','IB_V','plot_type','power','ylim',[0 12]);

            if save_plots
                h = figure('visible','off'); 
                h2 = double(h);
                save_allfigs(1:h2-1);
                close(h);  % Get most recent figure handle
                clear h h2
            end
            
            
        case 14
            %% Case 14
            data_var = CalcAverages(data);                  % Average all cells together
            data_var = RearrangeStudies2Neurons(data);      % Combine all studies together as cells
                PlotData_with_AP_line(data_var,'plot_type','waveform')
                PlotData_with_AP_line(data_var,'variable',{'RS_V','RS_LTS_IBaIBdbiSYNseed_s','RS_RS_IBaIBdbiSYNseed_s'});
            opts.save_std = 1;
            data_var2 = CalcAverages(data_var,opts);         % Average across cells/studies & store standard deviation
            figl;
            subplot(211);plot_data_stdev(data_var2,'RS_LTS_IBaIBdbiSYNseed_s',[]); ylabel('LTS->RS synapse');
            subplot(212); plot_data_stdev(data_var2,'RS_V',[]); ylabel('RS Vm');
            xlabel('Time (ms)');
            %plot_data_stdev(data_var2,'RS_RS_IBaIBdbiSYNseed_s',[]);
            
            %PlotData_with_AP_line(data,'variable','RS_V','plot_type','rastergram')
            PlotData_with_AP_line(data(5),'plot_type','waveform')
            PlotData_with_AP_line(data(5),'plot_type','rastergram')


        otherwise
            if 0
                PlotData(data,'plot_type','waveform');
                %PlotData_with_AP_line(data,'plot_type','waveform','variable','LTS_V','max_num_overlaid',50);
                %PlotData_with_AP_line(data,'plot_type','rastergram','variable','LTS_V');
                %PlotData_with_AP_line(data2,'plot_type','waveform','variable','RS_LTS_IBaIBdbiSYNseed_s');
                %PlotData_with_AP_line(data2,'plot_type','waveform','variable','LTS_IBiMMich_mM');
            end
            
            if 0
                %% Plot overlaid Vm data
                data_cat = cat(3,data.RS_V,data.FS_V,data.LTS_V);
                figure; plott_matrix3D(data_cat);
            end
            
    end
end


%         PlotData(data,'plot_type','waveform','variable','RS_V');
%         PlotData(data,'plot_type','waveform','variable','FS_V');

%PlotData(data,'plot_type','rastergram');
%PlotData(data,'variable','IBaIBdbiSYNseed_s','plot_type','waveform');
%PlotData(data,'variable','ISYN','plot_type','waveform');
%PlotData(data,'variable','iNMDA_s','plot_type','waveform');
%PlotData(data,'variable','INMDA','plot_type','waveform');
%PlotData(data,'variable','IGABAB','plot_type','waveform');
%PlotData(data,'variable','iGABABAustin_g','plot_type','waveform');
%PlotData(data,'variable','IBiMMich_mM','plot_type','waveform');

% Remove some entries from data structure
% %%
% data2=data;
% % str = data2.labels; str = str(~strcmp_anysubstring(str,'IB_')); data2.labels = str;     % Remove IB
% str = data2.labels; str = str(~strcmp_anysubstring(str,'NG_')); data2.labels = str;     % Remove NG
% % str = data2.labels; str = str( ~(strcmp_anysubstring(str,'RS') & ~strcmp_anysubstring(str,'supRS')) ); data2.labels = str;     % Remove RS (but not supRS)
% str = data2.labels; str = str( ~(strcmp_anysubstring(str,'FS') & ~strcmp_anysubstring(str,'supFS')) ); data2.labels = str;     % Remove FS (but not supFS)
% % str = data2.labels; str = str(~strcmp_anysubstring(str,'supRS')); data2.labels = str;     % Remove supRS
% % str = data2.labels; str = str(~strcmp_anysubstring(str,'supFS')); data2.labels = str;     % Remove supFS
% 
% %%
% PlotData(data2,'plot_type','waveform');
% PlotData(data2,'plot_type','rastergram');
% PlotFR(data2);

toc

%%




