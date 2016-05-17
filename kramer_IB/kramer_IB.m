% Model: Kramer 2008, PLoS Comp Bio

% simulation controls
tspan=[0 250]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% No noise simulation
no_noise = 0;

% number of cells per population
N=1;

% tonic input currents
Jd=2; % apical: 23.5(25.5), basal: 23.5(42.5)
Js=1; % -4.5
Ja=1;   % -6(-.4)

% Poisson IPSPs to IBdb (basal dendrite)
gRAN=3;
ERAN=0;
tauRAN=2;
lambda = 20;

% some intrinsic currents
gAR_L=50;  % 50,  LTS - max conductance of h-channel
gAR_d=155; % 155, IBda - max conductance of h-channel

% connection strengths
gad=0;      % IBa -> IBdb, 0(.04)
gsd=.2;     % IBs -> IBda,IBdb
gds=.4;     % IBda,IBdb -> IBs
gas=.3;     % IBa -> IBs
gsa=.3;     % IBs -> IBa
ggja=.002;  % IBa -> IBa

% Current injection noise levels
IBda_Vnoise = .3;
IBs_Vnoise = .1;
IBdb_Vnoise = .3;
IBa_Vnoise = .1;

% constant biophysical parameters
Cm=.9;        % membrane capacitance
gl=0.1;
ENa=50;      % sodium reversal potential
E_EKDR=-95;  % potassium reversal potential for excitatory cells
IB_Eh=-25;   % h-current reversal potential for deep layer IB cells
ECa=125;     % calcium reversal potential
IC_noise=.01;% fractional noise in initial conditions
if no_noise
    IC_noise= 0;
    IBda_Vnoise = 0;
    IBs_Vnoise = 0;
    IBdb_Vnoise = 0;
    IBa_Vnoise = 0;
    gRAN=0;
end

IC_V = -65;

spec=[];
i=0;

i=i+1;
spec.populations(i).name = 'IBda';
spec.populations(i).size = N;
spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
spec.populations(i).mechanism_list = {'IBdbiPoissonExp','IBitonic','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleak'};
spec.populations(i).parameters = {...
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',gl,...
  'stim',Jd,'onset',0,'V_noise',IBda_Vnoise,'gRAN',gRAN,'ERAN',ERAN,'tauRAN',tauRAN,'lambda',lambda,...
  'gNaF',100,'E_NaF',ENa,...
  'gKDR',80,'E_KDR',E_EKDR,...
  'gM',4,'E_M',E_EKDR,...
  'gCaH',4,'E_CaH',ECa,...
  };

i=i+1;
spec.populations(i).name = 'IBs';
spec.populations(i).size = N;
spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
spec.populations(i).mechanism_list = {'IBitonic','IBnoise','IBiNaF','IBiKDR','IBleak'};
spec.populations(i).parameters = {...
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'g_l',gl,...
  'stim',Js,'onset',0,'V_noise',IBs_Vnoise,...
  'gNaF',100,'E_NaF',ENa,...
  'gKDR',80,'E_KDR',E_EKDR,...
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

i=0;

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
% i=i+1;
% spec.connections(i).direction = 'IBa->IBdb';
% spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
% spec.connections(i).parameters = {'g_SYN',gad,'E_SYN',0,'tauDx',100,'tauRx',.5,'fanout',inf,'IC_noise',0};
% i=i+1;
% spec.connections(i).direction = 'IBa->IBa';
% spec.connections(i).mechanism_list = {'IBaIBaiGAP'};
% spec.connections(i).parameters = {'g_GAP',ggja,'fanout',inf};
% 


% DynaSim code
% data=SimulateModel(spec);
tic
data=SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1);
toc
%PlotData(data);

figl;
subplot(311); plot(data.IBda_V); title('Apical dendrites');
subplot(312); plot(data.IBs_V); title('Soma');
subplot(313); plot(data.IBa_V); title('Axon');

% PlotData(data,'plot_type','waveform');
