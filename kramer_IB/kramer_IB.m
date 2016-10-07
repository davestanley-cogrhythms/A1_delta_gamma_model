% Model: Kramer 2008, PLoS Comp Bio
%%
tic
clear
% Simulation mode
sim_mode = 12;   % 1 - normal sim
                % 2 - sim study IB disconnected; iM and iCaH
                % 3 - sim study IB disconnected; current injection
                % 4 - sim study IB connected; vary AMPA, NMDA injection
                % 5 - sim study IB connected; gamma input
                % 6 - sim study IB connected; single pulse
                % 7 - sim study NG; gamma input
                % 8 - sim study Median Nerve phase
                % 9 - sim study FS-RS circuit vary RS stim
                % 10 - Vary iPeriodicPulses in all cells
                
                
% Cells to include in model
include_IB = 1;
include_RS = 1;
include_FS = 1;
include_NG = 1;
include_supRS = 0;
include_supFS = 0;

% simulation controls
tspan=[0 2000]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% Simulation switches
no_noise = 0;
no_synapses = 0;

% number of cells per population
N=5;   % Number of excitatory cells
Nrs=24; % Number of RS cells
Nng=N;  % Number of FSNG cells
Nfs=24;  % Number of FS cells
NsupRS = 30; 
NsupFS = N;

% % % % % % % % % % % % %  Injected currents % % % % % % % % % % % % %  
% tonic input currents
Jd1=5; % apical: 23.5(25.5), basal: 23.5(42.5)
Jd2=0; % apical: 23.5(25.5), basal: 23.5(42.5)
Jng1=3;     % NG current injection; step1   % Do this to remove the first NG pulse
Jng2=1;     % NG current injection; step2
Jfs=1.25;     % FS current injection; step1
JRS1 = 3;
JRS2 = 1.7;
supJRS1 = 5;
supJRS2 = 0.75;
supJfs = 1;

IB_offset1=0;
IB_onset2=0;
RS_offset1=0;
RS_onset2=0;

% Poisson IPSPs to IBdb (basal dendrite)
gRAN=.015;
ERAN=0;
tauRAN=2;
lambda = 1000;
RSgRAN=0.005;
supRSgRAN = 0.005;


% % Periodic pulse stimulation
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
        width2_rise = 0.75;  % Not used for Gaussian pulse
        kernel_type = 2;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        supRSPPstim = 0;
    case 1                  % Gamma stimulation
        PPfreq = 40; % in Hz
        PPwidth = 2; % in ms
        PPshift = 0; % in ms
        PPonset = 600;    % ms, onset time
        PPoffset = tspan(end)-250;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 60;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 11;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        %ap_pulse_num = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        width2_rise = .5;  % Not used for Gaussian pulse
        kernel_type = 1;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        supRSPPstim = 0;
        IBPPstim = -3;
        RSPPstim = -4;
        NGPPstim = -2;
%         FSPPstim = -5;
%         supRSPPstim = -7;

    case 2                  % Median nerve stimulation
        PPfreq = 2; % 2 Hz delta
        PPwidth = 10; % in ms
        PPshift = 0; % in ms
        PPonset = 10;    % ms, onset time
        PPoffset = tspan(end)-0;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 0;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        width2_rise = 2.5;  % Not used for Gaussian pulse
        kernel_type = 2;
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
        width2_rise = 0.75;  % Not used for Gaussian pulse
        kernel_type = 1;
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


% % % % % % % % % % % % %  Synaptic connections % % % % % % % % % % % % %  
% compartmental connection strengths
gsd=.2;     % IBs -> IBda,IBdb
gds=.4;     % IBda,IBdb -> IBs
gas=.3;     % IBa -> IBs
gsa=.3;     % IBs -> IBa

% Gap junction connection
ggjaRS=0;
ggja=0;
ggjFS=0;
% % Deep cells
ggjaRS=.0/N;  % RS -> RS
ggja=.2/N;  % IBa -> IBa
ggjFS=.2/Nfs;  % IBa -> IBa
% % Sup cells
ggjasupRS=.00/(NsupRS);  % RS -> RS         % Disabled RS-RS gap junctions because otherwise the Eleaknoise doesn't have any effect
ggjsupFS=.2/NsupFS;  % IBa -> IBa


% Synapse heterogenity
gsyn_hetero = 0;

% Synaptic connection strengths zeros
gAMPAee=0;
gNMDAee=0;

gAMPAei=0;
gNMDAei=0;

gGABAaii=0;
gGABAbii=0;

gGABAaie=0;
gGABAbie=0;


gGABAafe=0;

% Delta -> Gamma oscillator connections
gAMPA_ibrs = 0;
gNMDA_ibrs = 0;
gGABAa_ngrs = 0;
gGABAb_ngrs = 0;

% RS-FS circuit (deep connections)
gAMPA_rsrs=0;
    gNMDA_RSRS=0;
gAMPA_rsfs=0;
    gNMDA_rsfs=0;
gGABAaff=0;
gGABAa_fsrs=0;

% RS-FS circuit (supra connections)
gAMPA_supRSsupRS=0;
gNMDA_supRSsupRS=0;
gAMPA_supRSsupFS=0;
gGABA_supFSsupFS=0;
gGABAa_supFSsupRS=0;

% Deep -> Supra connections
gAMPA_IBsupRS = 0;
gNMDA_IBsupRS = 0;
gAMPA_IBsupFS = 0;
gNMDA_IBsupFS = 0;
gAMPA_RSsupRS = 0;
gGABAa_NGsupRS=0;
gGABAb_NGsupRS=0;

% Supra -> Deep connections
gAMPA_supRSRS = 0;
gAMPA_supRSIB = 0;


% Gamma -> Delta connections 
gGABAafe=0;
gAMPA_rsng = 0;
gNMDA_rsng = 0;

if ~no_synapses
% % Synaptic connection strengths
gAMPAee=0.1/N;      % IBa -> IBdb, 0(.04)
gNMDAee=5/N;
% 
gAMPAei=0.1/N;      % IBa -> IBdb, 0(.04)
gNMDAei=5/N;
% 
gGABAaii=0.1/Nng;
gGABAbii=0.3/Nng;
% % 
gGABAaie=0.1/Nng;
gGABAbie=0.3/Nng;

% Delta -> Gamma oscillator connections
% gAMPA_ibrs = 0.013/N;
% gNMDA_ibrs = 0.02/N;
% gGABAa_ngrs = 0.05/Nng;
% gGABAb_ngrs = 0.08/Nng;

% RS-FS circuit (deep connections)
% #mysynapses
gAMPA_rsrs=0.1/Nrs;
    gNMDA_RSRS=5/Nrs;
gAMPA_rsfs=0.4/Nrs;
%     gNMDA_rsfs=0/Nrs;
gGABAaff=.5/Nfs;
gGABAa_fsrs=1.0/Nfs;

% RS-FS circuit (supra connections)
gAMPA_supRSsupRS=0.1/(NsupRS);
        gNMDA_supRSsupRS=0.0/(NsupRS);
gAMPA_supRSsupFS=1/(NsupRS);        % Increased by 4x due to sparse firing of sup principle cells.
gGABA_supFSsupFS=0.5/NsupFS;
gGABAa_supFSsupRS=0.2/NsupFS;       % Decreased by 3x due to reduced stimulation of sup principle cells

% Deep -> Supra connections (including NG - really should model this separately!)
% gAMPA_IBsupRS = 0.01/N;
gNMDA_IBsupRS = 0.2/N;
% gAMPA_IBsupFS = 0.01/N;
% gNMDA_IBsupFS = 0.1/N;
gAMPA_RSsupRS = 0.15/Nrs;
% gGABAa_NGsupRS=0.01/Nng;
gGABAb_NGsupRS=0.05/Nng;

% Supra -> Deep connections
% gAMPA_supRSRS = 0.15/NsupRS;
% gAMPA_supRSIB = 0.15/NsupRS;

% Gamma -> Delta connections 
gGABAafe=.6/Nfs;
% gAMPA_rsng = 0.1/Nfs;
%gNMDA_rsng = 0.01/Nfs;

end

% % % % % % % % % % % % % % % % % % % % % % 



% Synaptic time constants & reversals
tauAMPAr=.25;  % ms, AMPA rise time; Jung et al
tauAMPAd=1;   % ms, AMPA decay time; Jung et al
tauNMDAr=5; % ms, NMDA rise time; Jung et al
tauNMDAd=100; % ms, NMDA decay time; Jung et al
tauGABAar=.5;  % ms, GABAa rise time; Jung et al
tauGABAad=8;   % ms, GABAa decay time; Jung et al
tauGABAbr=38;  % ms, GABAa rise time; From NEURON Delta simulation
tauGABAbd=150;   % ms, GABAa decay time; From NEURON Delta simulation
EAMPA=0;
EGABA=-95;
TmaxGABAB=0.5;



% Current injection noise levels
IBda_Vnoise = .3;
IBs_Vnoise = .1;
IBdb_Vnoise = .3;
IBa_Vnoise = .1;
NG_Vnoise = 3;
FS_Vnoise = 3;
RSda_Vnoise = .3;
supRSda_Vnoise = .3;
supFS_Vnoise = 3;


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


% % % % % % % % % % % % % % % % Override some defaults % % % % % % % % % % 
switch sim_mode
    case 1                                                                  % Everything default, single simulation
        vary = [];
    case 2                                                                  % IB only, no synapse, no gamma
        include_IB = 1; include_FS = 0; include_NG = 0; include_RS = 0;
        gAMPAee=0; gNMDAee=0;
        IBPPstim = 0; NGPPstim = 0; FSPPstim = 0;
        N=2;
        
        vary_mode = 1;
        switch vary_mode 
            case 1
                vary = { 'IB','gCaH',[.5 1 1.5 2];
                     'IB','gM',[.5 1 2 4]};
            case 2
                vary = { 'IB','stim2',[1.5 1 0.5 0 -0.5 -1 -1.5]};
        end
        
    case 4                                                                  % IB only, no gamma
        include_IB = 1; include_FS = 0; include_NG = 0; include_RS = 0;
        IBPPstim = 0; NGPPstim = 0; FSPPstim = 0;
        
        vary = { 'IB->IB','g_SYN',[0, 0.1, 0.5 1]/N; % AMPA conductance
                 'IB->IB','gNMDA',[0 1 5]/N};        % NMDA conductance
        
    case 5                                                                  % IB, FS, and NG cells.
        include_IB = 1; include_FS = 1; include_NG = 1; include_RS = 0;
        
        vary_mode = 1;
        switch vary_mode
            case 1
                vary = { 'IB','PPstim',[-1 -2 -3 -4 -5];     % IBPPstim
                         'FS->IB','g_SYN',[.1 .2 .3 .4 .5]/N}; % gGABAafe
            case 2
                vary = { 'IB->IB','g_SYN',[.2 .5 .3]/N;     % gAMPAee
                         'FS->IB','g_SYN',[.8 1 1.3 1.5]/N}; % gGABAafe
             case 3
                vary = { 'IB->IB','gNMDA',[1 2 3]/N;               % IBPPstim
                         'FS->IB','g_SYN',[.3 .5 .6]/N};         % gGABAafe
        end
    case 6                                                                  % IB cell with single gamma pulse
        include_IB = 1; include_FS = 1; include_NG = 0; include_RS = 0;
        FSPPstim = -5;
        PPoffset=270;

    case 7                                                                  % NG only, no gamma
        include_IB = 0; include_FS = 0; include_NG = 1; include_RS = 0;
        vary = { 'NG','PPstim',[-2 -3.5 -5 -6.5 -8]; % AMPA conductance
                 'NG->NG','g_SYN',[.1 .3 .6 1 2]/Nng};        % NMDA conductance
        vary = { 'NG','PPstim',[-3.5 -5 ]; % AMPA conductance
                 'NG->NG','g_SYN',[.3 .6 ]/Nng};        % NMDA conductance
%          vary = [];


    case 8
        PPfreq = 1/tspan(end); % 1 spike per cycle. 
        PPwidth = 10; % in ms
        PPshift = 600; % in ms
        PPonset = 10;    % ms, onset time
        PPoffset = tspan(end)-0;   % ms, offset time
        ap_pulse_num = 0;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        width2_rise = 2.5;  % Not used for Gaussian pulse
        kernel_type = 2;
        IBPPstim = 0;
        NGPPstim = 0;
        FSPPstim = 0;
        IBPPstim = -3;
        % NGPPstim = -4;
        % FSPPstim = -5;

        vary = { 'IB','PPstim',[-2 -5 -10];   
                 'IB','PPshift',[350 400 575 650 750]}; 
%         vary = [];

    case 9  % Vary RS cells in RS-FS network

        vary = { %'RS','stim2',linspace(3.5,1.5,4); ...
                 %'RS','PPstim',linspace(-5,-2,4); ...
                 %'RS->FS','g_SYN',[.2:.1:.5]/Nrs;...
                 'FS->RS','g_SYN',[.6:.1:1.2]/Nfs;...

                 }; 

             
             
    case 10     % Vary PP stimulation frequency to all cells
        vary = { '(IB,NG,RS,FS,supRS)','PPfreq',[1,2,4,8];
                 }; 
             
    case 11     % Vary just FS cells
        vary = { 'FS','stim',linspace(0,1.25,2); ...
                 %'FS','PPstim',linspace(-2,0,2); ...
                 }; 
    case 12     % Vary IB cells
        vary = { 'IB','PPstim',[-3, -4]; ...
                 'NG','PPstim',[-7:1:-1]; ...
                 %'IB->RS','g_SYN',linspace(0.05,0.10,8)/N;...
                 %'FS->IB','g_SYN',[.4:.05:.7]/Nfs;...
                 %'IB->RS','g_SYN',[0.01:0.003:0.03]/N;...
                 %'IB->RS','gNMDA',[0,0.02,0.05]/N;...
                 %'RS->NG','g_SYN',[0:.1:0.8]/Nfs;...
                 }; 
             
        

        
end

% % % % % % % % % % % % %  Populations  % % % % % % % % % % % % %  

spec=[];
i=0;

if include_IB
    i=i+1;
    spec.populations(i).name = 'IB';
    spec.populations(i).size = N;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','IBdbiPoissonExpJason','itonicPaired','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',gl,...
      'PPstim', IBPPstim, 'PPfreq', PPfreq,      'PPwidth', PPwidth,'PPshift',PPshift,                    'PPonset', PPonset, 'PPoffset', PPoffset, 'ap_pulse_num', ap_pulse_num, 'ap_pulse_delay', ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'gRAN',gRAN,'ERAN',ERAN,'tauRAN',tauRAN,'lambda',lambda,...
      'stim',Jd1,'onset',0,'offset',IB_offset1,'stim2',Jd2,'onset2',IB_onset2,'offset2',Inf,...
      'V_noise',IBda_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',2,'E_M',E_EKDR,...
      'gCaH',2,'E_CaH',ECa,...
      };
end

if include_RS
    i=i+1;
    spec.populations(i).name = 'RS';
    spec.populations(i).size = Nrs;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','IBdbiPoissonExpJason','itonicPaired','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleaknoisy'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'E_l_std',10,'g_l',gl,...
      'PPstim', RSPPstim, 'PPfreq', PPfreq,      'PPwidth', PPwidth,'PPshift',PPshift,                    'PPonset', PPonset, 'PPoffset', PPoffset, 'ap_pulse_num', ap_pulse_num, 'ap_pulse_delay', ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'gRAN',RSgRAN,'ERAN',ERAN,'tauRAN',tauRAN,'lambda',lambda,...
      'stim',JRS1,'onset',0,'offset',RS_offset1,'stim2',JRS2,'onset2',RS_onset2,'offset2',Inf,...
      'V_noise',RSda_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',0.5,'E_M',E_EKDR,...
      'gCaH',0,'E_CaH',ECa,...
      };
end

if include_NG
    i=i+1;
    spec.populations(i).name = 'NG';
    spec.populations(i).size = Nng;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','itonicPaired','IBnoise','FSiNaF','FSiKDR','IBleak','iAhuguenard'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',0.1,...
      'PPstim',NGPPstim,'PPfreq',PPfreq,'PPwidth',PPwidth,'PPshift',PPshift,'PPonset',PPonset,'PPoffset',PPoffset,'ap_pulse_num',ap_pulse_num,'ap_pulse_delay',ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'stim',Jng1,'onset',0,'offset',50,'stim2',Jng2,'onset2',50,'offset2',Inf,...
      'V_noise',NG_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gA',20,'E_A',E_EKDR, ...
      };
end

if include_FS
    i=i+1;
    spec.populations(i).name = 'FS';
    spec.populations(i).size = Nfs;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','IBitonic','IBnoise','FSiNaF','FSiKDR','IBleaknoisy'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'E_l_std',20,'g_l',0.1,...
      'PPstim',FSPPstim,'PPfreq',PPfreq,'PPwidth',PPwidth,'PPshift',PPshift,'PPonset',PPonset,'PPoffset',PPoffset,'ap_pulse_num',ap_pulse_num,'ap_pulse_delay',ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'stim',Jfs,'onset',0,'offset',Inf,...
      'V_noise',FS_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      };
end


if include_supRS
    i=i+1;
    spec.populations(i).name = 'supRS';
    spec.populations(i).size = NsupRS;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','IBdbiPoissonExpJason','itonicPaired','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleaknoisy'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'g_l',gl,'E_l',-67,'E_l_std',5,...
      'PPstim', supRSPPstim, 'PPfreq', PPfreq,      'PPwidth', PPwidth,'PPshift',PPshift,                    'PPonset', PPonset, 'PPoffset', PPoffset, 'ap_pulse_num', ap_pulse_num, 'ap_pulse_delay', ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'gRAN',supRSgRAN,'ERAN',ERAN,'tauRAN',tauRAN,'lambda',lambda,...
      'stim',supJRS1,'onset',0,'offset',RS_offset1,'stim2',supJRS2,'onset2',RS_onset2,'offset2',Inf,...
      'V_noise',supRSda_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',2,'E_M',E_EKDR,...
      'gCaH',.5,'E_CaH',ECa,...
      };
end

if include_supFS
    i=i+1;
    spec.populations(i).name = 'supFS';
    spec.populations(i).size = NsupFS;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'IBitonic','IBnoise','FSiNaF','FSiKDR','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',0.1,...
      'stim',supJfs,'onset',0,'offset',Inf,...
      'V_noise',supFS_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      };
end

% % % % % % % % % % % %  Connections  % % % % % % % % % % % % %  
i=0;
% % % % %  IB Cells  % % % % %
% % IB->IB recurrent synaptic and gap connections
if include_IB
    i=i+1;
    spec.connections(i).direction = 'IB->IB';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPAee,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDAee,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        'g_GAP',ggja,...
        };
end

% % IB->NG
if include_IB && include_NG
    i=i+1;
    spec.connections(i).direction = 'IB->NG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPAei,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDAei,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

% % IB->RS
if include_IB && include_RS
    i=i+1;
    spec.connections(i).direction = 'IB->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibrs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibrs,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

% % % % %  NG Cells  % % % % %
% % NG->NG Synaptic connections
if include_NG
    i=i+1;
    spec.connections(i).direction = 'NG->NG';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAaii,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAbii,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero,  ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % NG->IB Synaptic connections
if include_NG && include_IB
    i=i+1;
    spec.connections(i).direction = 'NG->IB';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAaie,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAbie,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % NG->RS Synaptic connections
if include_NG && include_RS
    i=i+1;
    spec.connections(i).direction = 'NG->RS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_ngrs,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_ngrs,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end


% % % % %  RS Cells  % % % % %
% % RS->RS recurrent synaptic and gap connections
if include_RS
    i=i+1;
    spec.connections(i).direction = 'RS->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsrs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_RSRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        'g_GAP',ggjaRS,...
        };
end

% % RS->FS synaptic connection
if include_RS && include_FS
    i=i+1;
    spec.connections(i).direction = 'RS->FS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsfs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_rsfs,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

% % RS->NG synaptic connection
if include_RS && include_NG
    i=i+1;
    spec.connections(i).direction = 'RS->NG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsng,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_rsng,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

% % % % %  FS Cells  % % % % %
% % FS->FS Synaptic connections
if include_FS
    i=i+1;
    spec.connections(i).direction = 'FS->FS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gGABAaff,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'g_GAP',ggjFS,...
        };
end


% % FS->IB Synaptic connections
if include_FS && include_IB
    i=i+1;
    spec.connections(i).direction = 'FS->IB';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAafe,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

% % FS->RS Synaptic connections
if include_FS && include_RS
    i=i+1;
    spec.connections(i).direction = 'FS->RS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_fsrs,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

% % % % % % % % % % % %  Supraficial connections (RS-FS) % % % % % % % % % % % % % 
% % % % %  supRS Cells  % % % % %
% % supRS->supRS recurrent synaptic and gap connections
if include_supRS
    i=i+1;
    spec.connections(i).direction = 'supRS->supRS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_supRSsupRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_supRSsupRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        'g_GAP',ggjasupRS,...
        };
end

% % supRS->supFS synaptic connection
if include_supRS && include_supFS
    i=i+1;
    spec.connections(i).direction = 'supRS->supFS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_supRSsupFS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % % % %  supFS Cells  % % % % %
% % supFS->supFS Synaptic connections
if include_supFS
    i=i+1;
    spec.connections(i).direction = 'supFS->supFS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gGABA_supFSsupFS,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'g_GAP',ggjsupFS,...
        };
end

% % supFS->supRS Synaptic connections
if include_supFS && include_supRS
    i=i+1;
    spec.connections(i).direction = 'supFS->supRS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_supFSsupRS,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


% % NG->supRS Synaptic connections           % Exactly the same as Deep NG->RS connection
if include_NG && include_supRS
    i=i+1;
    spec.connections(i).direction = 'NG->supRS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_NGsupRS,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_NGsupRS,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % % % % % % % % % % %  Deep->Supraficial connections % % % % % % % % % % % % % 
% % IB->supRS
if include_IB && include_supRS
    i=i+1;
    spec.connections(i).direction = 'IB->supRS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_IBsupRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_IBsupRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

% % IB->supFS
if include_IB && include_supFS
    i=i+1;
    spec.connections(i).direction = 'IB->supFS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_IBsupFS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_IBsupFS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

% % RS->supRS
if include_RS && include_supRS
    i=i+1;
    spec.connections(i).direction = 'RS->supRS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_RSsupRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end




% % % % % % % % % % % %  Supraficial->Deep connections % % % % % % % % % % % % % 
% % supRS->RS
if include_RS && include_supRS
    i=i+1;
    spec.connections(i).direction = 'supRS->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_supRSRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % supRS->IB
if include_RS && include_supRS
    i=i+1;
    spec.connections(i).direction = 'supRS->IB';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_supRSIB,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end



% % % % % % % % % % % %  Run simulation  % % % % % % % % % % % % % 
data=SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary,'parallel_flag',double(sim_mode ~= 1),'verbose_flag',1);
% SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary,'parallel_flag',0,...
%     'cluster_flag',1,'save_data_flag',1,'study_dir','kramerout_cluster_2','verbose_flag',1);

% Downsample data
data = DownsampleData(data,max(round(0.1/dt),1));   % Downsample so that sampling rate is 10000 Hz (dt = 0.1 ms)

% Calculate Thevenin equivalents of GABA B conductances
if include_IB && include_NG && include_FS; data = ThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB','IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'IB_GABA'); end
if include_IB && include_NG; data = ThevEquiv(data,{'IB_NG_iGABABAustin_IGABAB'},'IB_V',[-95],'NG_GABA'); end           % GABA B only
if include_IB && include_FS; data = ThevEquiv(data,{'IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'FS_GABA'); end  % GABA A only

% Calculate averages across cells (e.g. mean field)
data2 = CalcAverages(data);

toc;

% % % % % % % % % % % %  Plotting  % % % % % % % % % % % % % 
switch sim_mode
    case {1,11}
        PlotData(data,'plot_type','waveform');
%          PlotData(data,'plot_type','rastergram');
        
        if include_IB && include_NG && include_FS; PlotData(data,'plot_type','waveform','variable',{'NG_GABA_gTH','IB_GABA_gTH','FS_GABA_gTH'});
        elseif include_IB && include_NG; PlotData(data2,'plot_type','waveform','variable',{'NG_GABA_gTH'});
        elseif include_IB && include_FS; PlotData(data2,'plot_type','waveform','variable',{'FS_GABA_gTH'}); end
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
        
        PlotData(data2,'plot_type','waveform','variable','FS_FS_IBaIBdbiSYNseed_s');
        PlotData(data2,'plot_type','waveform','variable','RS_V');
        PlotData(data2,'plot_type','waveform','variable','FS_V');

        PlotData(data,'plot_type','rastergram','variable','RS_V');
        PlotData(data,'plot_type','rastergram','variable','FS_V');
        PlotFR2(data,'variable','RS_V'); 
        PlotFR2(data,'variable','FS_V'); 
        PlotFR2(data,'variable','RS_V','plot_type','meanFR');
        PlotFR2(data,'variable','FS_V','plot_type','meanFR');

    case 12
         %%
        %PlotData(data,'plot_type','rastergram','variable','RS_V');
        if include_IB && include_NG && include_FS; PlotData(data,'plot_type','waveform','variable',{'NG_GABA_gTH','IB_GABA_gTH','FS_GABA_gTH'});
        elseif include_IB && include_NG; PlotData(data,'plot_type','waveform','variable',{'NG_GABA_gTH'});
        elseif include_IB && include_FS; PlotData(data,'plot_type','waveform','variable',{'FS_GABA_gTH'}); end
        
        %PlotData(data2,'plot_type','waveform','variable','FS_FS_IBaIBdbiSYNseed_s');
        
        PlotData(data,'variable','IB_V','plot_type','waveform');

%         PlotData(data,'plot_type','rastergram','variable','RS_V');
%         PlotData(data,'plot_type','rastergram','variable','FS_V');
%         PlotFR2(data,'variable','RS_V'); 
        PlotFR2(data,'variable','FS_V'); 
%         PlotFR2(data,'variable','RS_V','plot_type','meanFR');
        PlotFR2(data,'variable','FS_V','plot_type','meanFR');


        
        
    otherwise
        PlotData(data,'plot_type','waveform');
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




