% Model: Kramer 2008, PLoS Comp Bio
%%
tic
% Simulation mode
sim_mode = 1;   % 1 - normal sim
                % 2 - sim study IBdb inject
                % 3 - sim study IBs inject
                
                
% Cells to include in model
include_IB = 1;
include_FS = 1;
include_NG = 1;


% simulation controls
tspan=[0 1500]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% No noise simulation
no_noise = 0;


% number of cells per population
N=5;   % Number of excitatory cells
Nng=N;  % Number of FSNG cells
Nfs=N;  % Number of FS cells

% % % % % % % % % % % % %  Injected currents % % % % % % % % % % % % %  
% tonic input currents
Jd=-1; % apical: 23.5(25.5), basal: 23.5(42.5)
Js=1; % -4.5
Ja=1;   % -6(-.4)
Jng1=5;     % NG current injection; step1   % Do this to remove the first NG pulse
Jng2=1;     % NG current injection; step2
Jfs1=20;     % FS current injection; step1
Jfs2=1;     % FS current injection; step2

% Poisson IPSPs to IBdb (basal dendrite)
gRAN=.015;
ERAN=0;
tauRAN=2;
lambda = 1000;

% Periodic pulse stimulation to FS cells
PPstim = -10;

% % % % % % % % % % % % %  Synaptic connections % % % % % % % % % % % % %  
% compartmental connection strengths
gsd=.2;     % IBs -> IBda,IBdb
gds=.4;     % IBda,IBdb -> IBs
gas=.3;     % IBa -> IBs
gsa=.3;     % IBs -> IBa

% Gap junction connection
ggja=0;
ggja=.2/N;  % IBa -> IBa

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


% % Synaptic connection strengths
gAMPAee=0.1/N;      % IBa -> IBdb, 0(.04)
gNMDAee=10/N;
% 
gAMPAei=1/Nng;      % IBa -> IBdb, 0(.04)
% gNMDAei=10/Nng;
% 
gGABAaii=0.1/Nng;
gGABAbii=.3/Nng;
% % 
gGABAaie=0.1/N;
gGABAbie=.35/N;

gGABAaff=1.2/Nfs;

gGABAafe=.5/N;


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


% % % % % % % % % % % % %  Populations  % % % % % % % % % % % % %  

spec=[];
i=0;

if include_IB
    i=i+1;
    spec.populations(i).name = 'IBda';
    spec.populations(i).size = N;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'IBdbiPoissonExpJason','IBitonic','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',gl,...
      'stim',Jd,'onset',0,'V_noise',IBda_Vnoise,'gRAN',gRAN,'ERAN',ERAN,'tauRAN',tauRAN,'lambda',lambda,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',2,'E_M',E_EKDR,...
      'gCaH',2,'E_CaH',ECa,...
      };

    i=i+1;
    spec.populations(i).name = 'IBs';
    spec.populations(i).size = N;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'IBitonic','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',gl,...
      'stim',Js,'onset',0,'V_noise',IBs_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',0,'E_M',E_EKDR,...
      'gCaH',0,'E_CaH',ECa,...
      };

    i=i+1;
    spec.populations(i).name = 'IBa';
    spec.populations(i).size = N;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'IBitonic','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',gl,...
      'stim',Ja,'onset',0,'V_noise',IBa_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',2,'E_M',E_EKDR,...
      };

end

if include_NG
    i=i+1;
    spec.populations(i).name = 'NG';
    spec.populations(i).size = Nng;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'itonicPaired','IBnoise','FSiNaF','FSiKDR','IBleak','iAhuguenard'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',0.1,...
      'stim',Jng1,'onset',0,'offset',100,'stim2',Jng2,'onset2',100,'offset2',Inf,...
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
    spec.populations(i).mechanism_list = {'iPeriodicPulses','itonicPaired','IBnoise','FSiNaF','FSiKDR','IBleak'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',0.1,...
      'stim',Jfs1,'onset',0,'offset',360,'stim2',Jfs2,'onset2',360,'offset2',Inf,...
      'PPstim',PPstim,'ap_pulse_num',40,...
      'V_noise',FS_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      };
end



% % % % % % % % % % % %  Connections  % % % % % % % % % % % % %  
i=0;

% % IB->IB intracompartmental connections
if include_IB
    i=i+1;
    spec.connections(i).direction = 'IBda->IBs';
    spec.connections(i).mechanism_list = {'IBiCOM'};
    spec.connections(i).parameters = {'g_COM',gds,'comspan',.5};
    i=i+1;
    spec.connections(i).direction = 'IBs->IBda';
    spec.connections(i).mechanism_list = {'IBiCOM'};
    spec.connections(i).parameters = {'g_COM',gsd,'comspan',.5};
    i=i+1;
    spec.connections(i).direction = 'IBs->IBa';
    spec.connections(i).mechanism_list = {'IBiCOM'};
    spec.connections(i).parameters = {'g_COM',gsa,'comspan',.5};
    i=i+1;
    spec.connections(i).direction = 'IBa->IBs';
    spec.connections(i).mechanism_list = {'IBiCOM'};
    spec.connections(i).parameters = {'g_COM',gas,'comspan',.5};
end


% % IB->IB recurrent synaptic and gap connections
if include_IB
    i=i+1;
    spec.connections(i).direction = 'IBa->IBda';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPAee,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDAee,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
    i=i+1;
    spec.connections(i).direction = 'IBa->IBa';
    spec.connections(i).mechanism_list = {'IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_GAP',ggja,'fanout',inf};
end

% % IB->NG
if include_IB && include_NG
    i=i+1;
    spec.connections(i).direction = 'IBa->NG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPAei,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDAei,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

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
    spec.connections(i).direction = 'NG->IBda';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAaie,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAbie,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % FS->FS Synaptic connections
if include_FS
    i=i+1;
    spec.connections(i).direction = 'FS->FS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAaff,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


% % FS->IB Synaptic connections
if include_FS && include_IB
    i=i+1;
    spec.connections(i).direction = 'FS->IBda';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAafe,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end




switch sim_mode

    case 1
        % DynaSim code
        % data=SimulateModel(spec);
        %tic
        data=SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1);
        %toc
        PlotData(data,'plot_type','waveform');
        
        %PlotData(data,'variable','IBaIBdbiSYNseed_s','plot_type','waveform');
        %PlotData(data,'variable','ISYN','plot_type','waveform');
        %PlotData(data,'variable','iNMDA_s','plot_type','waveform');
        %PlotData(data,'variable','INMDA','plot_type','waveform');
        %PlotData(data,'variable','IGABAB','plot_type','waveform');
        %PlotData(data,'variable','iGABABAustin_g','plot_type','waveform');

%         figl;
%         subplot(311); plot(data.IBda_V); title('Apical dendrites');
%         subplot(312); plot(data.IBs_V); title('Soma');
%         subplot(313); plot(data.IBa_V); title('Axon');
        
    case 2
        
        vary = {'FS','PPstim',[0 -3 -6 -9 -12 -15]};
        data=SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary);
        PlotData(data,'plot_type','waveform');
        PlotData(data,'plot_type','rastergram');
        
    case 3
        vary = {'IBs','stim',[4 -1 -6 -11 -16]};
        tic
        data=SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary);
        toc
        PlotData(data,'plot_type','waveform');
        %PlotData(data,'plot_type','rastergram');

end

% PlotData(data,'plot_type','waveform');


toc





