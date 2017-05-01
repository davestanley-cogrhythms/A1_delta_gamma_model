% Model: Kramer 2008, PLoS Comp Bio
%%
tic
clear
% Simulation mode
sim_mode = 1;   % 1 - normal sim
                % 2 - sim study IB disconnected; iM and iCaH
                % 3 - sim study IB disconnected; current injection
                % 4 - sim study IB connected; vary AMPA, NMDA injection
                % 5 - sim study IB connected; gamma input
                % 6 - sim study IB connected; single pulse
                % 7 - sim study NG; gamma input
                % 8 - sim study Median Nerve phase
                % 9 - sim study FS-RS circuit vary RS stim
                
                
% Cells to include in model
include_IB = 1;
include_RS = 1;
include_FS = 1;
include_NG = 1;

% simulation controls
tspan=[0 2000]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% Simulation switches
no_noise = 0;
no_synapses = 0;

% number of cells per population
N=15;   % Number of excitatory cells
Nrs=N; % Number of RS cells
Nng=N;  % Number of FSNG cells
Nfs=N;  % Number of FS cells

% % % % % % % % % % % % %  Injected currents % % % % % % % % % % % % %  
% tonic input currents
Jd1=5; % apical: 23.5(25.5), basal: 23.5(42.5)
Jd2=0; % apical: 23.5(25.5), basal: 23.5(42.5)
Jng1=-1;     % NG current injection; step1   % Do this to remove the first NG pulse
Jng2=1;     % NG current injection; step2
Jfs=1;     % FS current injection; step1
JRS1 = 5;
JRS2 = 0;
    

IB_offset1=245;
IB_onset2=245;
RS_offset1=245;
RS_onset2=245;

% Poisson IPSPs to IBdb (basal dendrite)
gRAN=.015;
ERAN=0;
tauRAN=2;
lambda = 1000;
RSgRAN=0.005;

% % Periodic pulse stimulation
pulse_mode = 1;
switch pulse_mode
    case 0                  % No stimulation
        PPfreq = 4; % in Hz
        PPwidth = 3; % in ms
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
    case 1                  % Gamma stimulation
        PPfreq = 40; % in Hz
        PPwidth = 2; % in ms
        PPshift = 0; % in ms
        PPonset = 250;    % ms, onset time
        PPoffset = tspan(end)-150;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 44;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 11;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
%         ap_pulse_delay = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        width2_rise = 0.25;  % Not used for Gaussian pulse
        kernel_type = 1;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        IBPPstim = -1;
        RSPPstim = -7;
        NGPPstim = -6;
%         FSPPstim = -5;

    case 2                  % Median nerve stimulation
        PPfreq = 2; % 2 Hz delta
        PPwidth = 10; % in ms
        PPshift = 400; % in ms
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
        IBPPstim = -5;
        % RSPPstim = -5;
        % NGPPstim = -4;
        % FSPPstim = -5;
    case 3                  % Auditory stimulation at delta (possibly not used...)
        PPfreq = 4; % in Hz
        PPwidth = 3; % in ms
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
        % IBPPstim = -3;
        % RSPPstim = -3;
        % NGPPstim = -4;
        % FSPPstim = -5;
        
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
ggjaRS=.2/N;  % RS -> RS
ggja=.2/N;  % IBa -> IBa
ggjFS=.2/Nfs;  % IBa -> IBa

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

gGABAaff=0;

gGABAafe=0;

% IB and NG to RS connections
gAMPA_ibrs = 0;
gNMDA_ibrs = 0;
gGABAa_ngrs = 0;
gGABAb_ngrs = 0;

% RS-FS circuit
gAMPA_rsrs=0;
gAMPA_rsfs=0;
gGABAa_fsrs=0;

% FS circuit and FS->IB connections
gGABAaff=0;
gGABAafe=0;

if ~no_synapses
% % Synaptic connection strengths
gAMPAee=0.1/N;      % IBa -> IBdb, 0(.04)
gNMDAee=5/N;
% 
gAMPAei=0.1/Nng;      % IBa -> IBdb, 0(.04)
gNMDAei=5/Nng;
% 
gGABAaii=0.1/Nng;
gGABAbii=0.3/Nng;
% % 
gGABAaie=0.1/N;
gGABAbie=0.3/N;

% IB and NG to RS connections
gAMPA_ibrs = 0.1/Nrs;
gNMDA_ibrs = 1.0/Nrs;
gGABAa_ngrs = 0.1/Nrs;
gGABAb_ngrs = 0.1/Nng;

% RS-FS circuit
gAMPA_rsrs=0.1/Nrs;
gAMPA_rsfs=0.3/Nfs;
gGABAaff=0.5/Nfs;
gGABAa_fsrs=0.3/Nrs;


% FS circuit and FS->IB connections
gGABAafe=.7/N;
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

    case 9
        include_IB = 0; include_FS = 1; include_NG = 0; include_RS = 1;
        vary = { 'RS','stim2',[-2 -1 0 1];
                 }; 
        
end

% % % % % % % % % % % % %  Populations  % % % % % % % % % % % % %  

spec=[];
i=0;

if include_IB
    i=i+1;
    spec.populations(i).name = 'IB';
    spec.populations(i).size = N;
    spec.populations(i).equations = {['V''=(@current)/Cm; V(0)=' num2str(IC_V) ]};
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
    spec.populations(i).equations = {['V''=(@current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','IBdbiPoissonExpJason','itonicPaired','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',gl,...
      'PPstim', RSPPstim, 'PPfreq', PPfreq,      'PPwidth', PPwidth,'PPshift',PPshift,                    'PPonset', PPonset, 'PPoffset', PPoffset, 'ap_pulse_num', ap_pulse_num, 'ap_pulse_delay', ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'gRAN',RSgRAN,'ERAN',ERAN,'tauRAN',tauRAN,'lambda',lambda,...
      'stim',JRS1,'onset',0,'offset',RS_offset1,'stim2',JRS2,'onset2',RS_onset2,'offset2',Inf,...
      'V_noise',RSda_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',2,'E_M',E_EKDR,...
      'gCaH',.5,'E_CaH',ECa,...
      };
end

if include_NG
    i=i+1;
    spec.populations(i).name = 'NG';
    spec.populations(i).size = Nng;
    spec.populations(i).equations = {['V''=(@current)/Cm; V(0)=' num2str(IC_V) ]};
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
    spec.populations(i).equations = {['V''=(@current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','IBitonic','IBnoise','FSiNaF','FSiKDR','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',0.1,...
      'PPstim',FSPPstim,'PPfreq',PPfreq,'PPwidth',PPwidth,'PPshift',PPshift,'PPonset',PPonset,'PPoffset',PPoffset,'ap_pulse_num',ap_pulse_num,'ap_pulse_delay',ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'stim',Jfs,'onset',0,'offset',Inf,...
      'V_noise',FS_Vnoise,...
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
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsrs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'g_GAP',ggjaRS,...
        };
end

if include_RS && include_FS
    i=i+1;
    spec.connections(i).direction = 'RS->FS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsfs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
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


% % % % % % % % % % % %  Run simulation  % % % % % % % % % % % % % 
data=dsSimulate(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary);


% % % % % % % % % % % %  Plotting  % % % % % % % % % % % % % 
switch sim_mode
    case 1
        PlotData(data,'plot_type','waveform');
    case {2,3}
        PlotData(data,'plot_type','waveform');
        PlotData(data,'variable','IBaIBdbiSYNseed_s','plot_type','waveform');
        PlotData(data,'variable','iNMDA_s','plot_type','waveform');
        
    case {5,6}
        PlotData(data,'plot_type','waveform','variable','IB_V');
    case 9
        PlotData(data,'plot_type','waveform','variable','RS_V');
        %PlotData(data,'plot_type','power');
    otherwise
        PlotData(data,'plot_type','waveform');
end



%PlotData(data,'plot_type','rastergram');
%PlotData(data,'variable','IBaIBdbiSYNseed_s','plot_type','waveform');
%PlotData(data,'variable','ISYN','plot_type','waveform');
%PlotData(data,'variable','iNMDA_s','plot_type','waveform');
%PlotData(data,'variable','INMDA','plot_type','waveform');
%PlotData(data,'variable','IGABAB','plot_type','waveform');
%PlotData(data,'variable','iGABABAustin_g','plot_type','waveform');
%PlotData(data,'variable','IBiMMich_mM','plot_type','waveform');

toc





