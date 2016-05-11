% Model: Kramer 2008, PLoS Comp Bio

% simulation controls
tspan=[0 250]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% No noise simulation
no_noise = 0;

% number of cells per population
N=10;

% tonic input currents
Jd=23.5; % apical: 23.5(25.5), basal: 23.5(42.5)
Js=-4.5; % -4.5
Ja=-6;   % -6(-.4)

% Poisson IPSPs to IBdb (basal dendrite)
gRAN=125;

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
IBda_Vnoise = .1;
IBs_Vnoise = 0;
IBdb_Vnoise = .1;
IBa_Vnoise = 5.5;

% constant biophysical parameters
Cm=.9;        % membrane capacitance
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
spec.populations(i).mechanism_list = {'IBdaitonic','IBanoise','IBdaiNaF','IBdaiKDR','IBdaiAR','IBdaiM','IBdaiCaH','IBdaleak'};
spec.populations(i).parameters = {...
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',2,...
  'stim',Jd,'onset',0,'V_noise',IBda_Vnoise,...
  'gNaF',125,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
  'gKDR',10,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
  'gAR',gAR_d,'E_AR',IB_Eh,'AR_V12',-87.5,'AR_k',-5.5,'c_ARaM',2.75,'c_ARbM',3,'AR_L',1,'AR_R',1,...
  'gM',.75,'E_M',E_EKDR,'c_MaM',1,'c_MbM',1,...
  'gCaH',6.5,'E_CaH',ECa,'tauCaH',.33333,'c_CaHaM',3,'c_CaHbM',3,...
  };

i=i+1;
spec.populations(i).name = 'IBs';
spec.populations(i).size = N;
spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
spec.populations(i).mechanism_list = {'IBsitonic','IBanoise','IBsiNaF','IBsiKDR','IBsleak'};
spec.populations(i).parameters = {...
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',1,...
  'stim',Js,'onset',0,'V_noise',IBs_Vnoise,...
  'gNaF',50,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
  'gKDR',10,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
  };

i=i+1;
spec.populations(i).name = 'IBdb';
spec.populations(i).size = N;
spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
spec.populations(i).mechanism_list = {'IBdbiPoissonExp','IBdbitonic','IBanoise','IBdbiNaF','IBdbiKDR','IBdbiAR','IBdbiM','IBdbiCaH','IBdbleak'};
spec.populations(i).parameters = {... % same as IBda except gAR=115, + IPSP params
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',2,...
  'stim',Jd,'onset',0,'V_noise',IBdb_Vnoise,'gRAN',gRAN,'ERAN',-80,'tauRAN',4,...
  'gNaF',125,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
  'gKDR',10,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
  'gAR',115,'E_AR',IB_Eh,'AR_V12',-87.5,'AR_k',-5.5,'c_ARaM',2.75,'c_ARbM',3,'AR_L',1,'AR_R',1,...
  'gM',.75,'E_M',E_EKDR,'c_MaM',1,'c_MbM',1,...
  'gCaH',6.5,'E_CaH',ECa,'tauCaH',.33333,'c_CaHaM',3,'c_CaHbM',3,...
  };

i=i+1;
spec.populations(i).name = 'IBa';
spec.populations(i).size = N;
spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
spec.populations(i).mechanism_list = {'IBaitonic','IBanoise','IBaiNaF','IBaiKDR','IBaiM','IBaleak'};
spec.populations(i).parameters = {...
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',.25,...
  'stim',Ja,'onset',0,'V_noise',IBa_Vnoise,...
  'gNaF',100,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
  'gKDR',5,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
  'gM',1.5,'E_M',E_EKDR,'c_MaM',1.5,'c_MbM',.75,...
  };

i=0;

i=i+1;
spec.connections(i).direction = 'IBda->IBs';
spec.connections(i).mechanism_list = {'IBsIBdbiCOM'};
spec.connections(i).parameters = {'g_COM',gds,'comspan',.5};
i=i+1;
spec.connections(i).direction = 'IBs->IBda';
spec.connections(i).mechanism_list = {'IBsIBdbiCOM'};
spec.connections(i).parameters = {'g_COM',gsd,'comspan',.5};
i=i+1;
spec.connections(i).direction = 'IBs->IBdb';
spec.connections(i).mechanism_list = {'IBsIBdbiCOM'};
spec.connections(i).parameters = {'g_COM',gsd,'comspan',.5};
i=i+1;
spec.connections(i).direction = 'IBs->IBa';
spec.connections(i).mechanism_list = {'IBsIBdbiCOM'};
spec.connections(i).parameters = {'g_COM',gsa,'comspan',.5};
i=i+1;
spec.connections(i).direction = 'IBdb->IBs';
spec.connections(i).mechanism_list = {'IBsIBdbiCOM'};
spec.connections(i).parameters = {'g_COM',gds,'comspan',.5};
i=i+1;
spec.connections(i).direction = 'IBa->IBs';
spec.connections(i).mechanism_list = {'IBsIBdbiCOM'};
spec.connections(i).parameters = {'g_COM',gas,'comspan',.5};
i=i+1;
spec.connections(i).direction = 'IBa->IBdb';
spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
spec.connections(i).parameters = {'g_SYN',gad,'E_SYN',0,'tauDx',100,'tauRx',.5,'fanout',inf,'IC_noise',0};
i=i+1;
spec.connections(i).direction = 'IBa->IBa';
spec.connections(i).mechanism_list = {'IBaIBaiGAP'};
spec.connections(i).parameters = {'g_GAP',ggja,'fanout',inf};



% DynaSim code
% data=SimulateModel(spec);
tic
data=SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1);
toc
%PlotData(data);

figl;
subplot(411); plot(data.IBda_V)
subplot(412); plot(data.IBs_V)
subplot(413); plot(data.IBdb_V)
subplot(414); plot(data.IBa_V)

% PlotData(data,'plot_type','waveform');

%% DNSim code
% process specification and simulate model
data = runsim(spec,'timelimits',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0);
plotv(data,spec,'varlabel','V');


% % Plot other currents
% plotv(data,spec,'varlabel','iKDR_mKDR');
% plotv(data,spec,'varlabel','iCaH_mCaH');
% plotv(data,spec,'varlabel','iM_mM');
% plotv(data,spec,'varlabel','iAR_mAR');
% plotv(data,spec,'varlabel','iSYN_sSYNpre');


% dnsim(spec);

