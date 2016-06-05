% Model: Kramer 2008, PLoS Comp Bio
%%

clear 

tic
% Simulation mode
sim_mode = 2;   % 1 - normal sim
                % 2 - sim study IBdb inject
                % 3 - sim study IBs inject
                

% simulation controls
tspan=[0 500]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% No noise simulation
no_noise = 0;


% number of cells per population
N=10;   % Number of excitatory cells
Nng=10;  % Number of FSNG cells
Nfs=10;

% % % % % % % % % % % % %  Injected currents % % % % % % % % % % % % %  
% tonic input currents
Jd=-1; % apical: 23.5(25.5), basal: 23.5(42.5)
Js=1; % -4.5
Ja=1;   % -6(-.4)
Jfs1=1;
Jfs2=10;

% Poisson IPSPs to IBdb (basal dendrite)
FSgRAN=.015;
FSERAN=0;
FStauRAN=2;
FSlambda = 40*10;  % 40 Hz * 100 cells
FSfreq=40;
FSac=40*10;


% % % % % % % % % % % % %  Synaptic connections % % % % % % % % % % % % %  
% compartmental connection strengths
gsd=.2;     % IBs -> IBda,IBdb
gds=.4;     % IBda,IBdb -> IBs
gas=.3;     % IBa -> IBs
gsa=.3;     % IBs -> IBa

% Gap junction connection

% Synapse heterogenity
gsyn_hetero = 0;

% Synaptic connection strengths zeros
gGABAaii=0;


% % Synaptic connection strengths
gGABAaii=8/Nng;


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
FS_Vnoise = .3;

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
    FSgRAN=0;
end

IC_V = -65;


% % % % % % % % % % % % %  Populations  % % % % % % % % % % % % %  

spec=[];
i=0;

i=i+1;
spec.populations(i).name = 'FS';
spec.populations(i).size = Nfs;
spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
spec.populations(i).mechanism_list = {'IBdbiPoissonExpJason','itonic_paired','IBnoise','FSiNaF','FSiKDR','IBleak'};
spec.populations(i).parameters = {...
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',0.1,...
  'gRAN',FSgRAN,'ERAN',FSERAN,'tauRAN',FStauRAN,'lambda',FSlambda,'freq',FSfreq,'ac',FSac...
  'stim',Jfs1,'onset',0,'offset',100,'stim2',Jfs2,'onset2',100,'offset2',Inf,...
  'V_noise',FS_Vnoise,...
  'gNaF',100,'E_NaF',ENa,...
  'gKDR',80,'E_KDR',E_EKDR,...
  };



% % % % % % % % % % % %  Connections  % % % % % % % % % % % % %  
i=0;

% % NG->NG Synaptic connections
i=i+1;
spec.connections(i).direction = 'FS->FS';                   % GABA_A
spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
spec.connections(i).parameters = {'g_SYN',gGABAaii,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
    };


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
        
        vary = {'FS','stim2',[1 0.5 0 -0.5 -1 -1.5]+.5};
        tic
        data=SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary);
        toc
        PlotData(data,'plot_type','waveform');
        PlotData(data,'plot_type','power');
        
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





