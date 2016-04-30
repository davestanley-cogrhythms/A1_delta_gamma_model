%% Model: Kramer 2008, PLoS Comp Bio

% simulation controls
tspan=[0 100]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% number of cells per population
N=2;

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

% constant biophysical parameters
Cm=.9;        % membrane capacitance
ENa=50;      % sodium reversal potential
E_EKDR=-95;  % potassium reversal potential for excitatory cells
IB_Eh=-25;   % h-current reversal potential for deep layer IB cells
ECa=125;     % calcium reversal potential
IC_noise=.01;% fractional noise in initial conditions

V_ICvar = -0;

spec=[];
% spec.nodes(1).label = 'IBda';
% spec.nodes(1).multiplicity = N;
% spec.nodes(1).dynamics = {'V''=(current)/Cm'};
% spec.nodes(1).mechanisms = {'IBdaitonic','IBdanoise','IBdaiNaF','IBdaiKDR','IBdaiAR','IBdaiM','IBdaiCaH','IBdaleak'};
% spec.nodes(1).parameters = {...
%   'V_IC',V_ICvar,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',2,...
%   'stim',Jd,'onset',0,'V_noise',.1,...
%   'gNaF',125,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
%   'gKDR',10,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
%   'gAR',gAR_d,'E_AR',IB_Eh,'AR_V12',-87.5,'AR_k',-5.5,'c_ARaM',2.75,'c_ARbM',3,'AR_L',1,'AR_R',1,...
%   'gM',.75,'E_M',E_EKDR,'c_MaM',1,'c_MbM',1,...
%   'gCaH',6.5,'E_CaH',ECa,'tauCaH',.33333,'c_CaHaM',3,'c_CaHbM',3,...
%   };
spec.nodes(1).label = 'IBs';
spec.nodes(1).multiplicity = N;
spec.nodes(1).dynamics = {'V''=(current)/Cm'};
spec.nodes(1).mechanisms = {'IBsitonic','IBsnoise','IBsiNaF','IBsiKDR','IBsleak'};
spec.nodes(1).parameters = {...
  'V_IC',V_ICvar,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',1,...
  'stim',Js,'onset',0,'V_noise',0,...
  'gNaF',50,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
  'gKDR',10,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
  };
% spec.nodes(3).label = 'IBdb';
% spec.nodes(3).multiplicity = N;
% spec.nodes(3).dynamics = {'V''=(current)/Cm'};
% spec.nodes(3).mechanisms = {'IBdbitonic','IBdbnoise','IBdbiNaF','IBdbiKDR','IBdbiAR','IBdbiM','IBdbiCaH','IBdbleak'};
% spec.nodes(3).parameters = {... % same as IBda except gAR=115, + IPSP params
%   'V_IC',V_ICvar,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',2,...
%   'stim',Jd,'onset',0,'V_noise',.1,'gRAN',gRAN,'ERAN',-80,'tauRAN',4,...
%   'gNaF',125,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
%   'gKDR',10,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
%   'gAR',115,'E_AR',IB_Eh,'AR_V12',-87.5,'AR_k',-5.5,'c_ARaM',2.75,'c_ARbM',3,'AR_L',1,'AR_R',1,...
%   'gM',.75,'E_M',E_EKDR,'c_MaM',1,'c_MbM',1,...
%   'gCaH',6.5,'E_CaH',ECa,'tauCaH',.33333,'c_CaHaM',3,'c_CaHbM',3,...
%   };

i=2;
spec.nodes(i).label = 'IBa';
spec.nodes(i).multiplicity = N;
spec.nodes(i).dynamics = {'V''=(current)/Cm'};
spec.nodes(i).mechanisms = {'IBaitonic','IBanoise','IBaiNaF','IBaiKDR','IBaiM','IBaleak'};
spec.nodes(i).parameters = {...
  'V_IC',V_ICvar,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',.25,...
  'stim',Ja,'onset',0,'V_noise',5.5,...
  'gNaF',100,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
  'gKDR',5,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
  'gM',1.5,'E_M',E_EKDR,'c_MaM',1.5,'c_MbM',.75,...
  };
% spec.connections(1,2).label = 'IBda-IBs';
% spec.connections(1,2).mechanisms = {'IBdaIBsiCOM'};
% spec.connections(1,2).parameters = {'g_COM',gds,'comspan',.5};
% spec.connections(2,1).label = 'IBs-IBda';
% spec.connections(2,1).mechanisms = {'IBsIBdaiCOM'};
% spec.connections(2,1).parameters = {'g_COM',gsd,'comspan',.5};
% spec.connections(2,3).label = 'IBs-IBdb';
% spec.connections(2,3).mechanisms = {'IBsIBdbiCOM'};
% spec.connections(2,3).parameters = {'g_COM',gsd,'comspan',.5};
% spec.connections(2,4).label = 'IBs-IBa';
% spec.connections(2,4).mechanisms = {'IBsIBaiCOM'};
% spec.connections(2,4).parameters = {'g_COM',gsa,'comspan',.5};
% spec.connections(3,2).label = 'IBdb-IBs';
% spec.connections(3,2).mechanisms = {'IBdbIBsiCOM'};
% spec.connections(3,2).parameters = {'g_COM',gds,'comspan',.5};
% spec.connections(4,2).label = 'IBa-IBs';
% spec.connections(4,2).mechanisms = {'IBaIBsiCOM'};
% spec.connections(4,2).parameters = {'g_COM',gas,'comspan',.5};
% spec.connections(4,3).label = 'IBa-IBdb';
% spec.connections(4,3).mechanisms = {'IBaIBdbiSYN'};
% spec.connections(4,3).parameters = {'g_SYN',gad,'E_SYN',0,'tauDx',100,'tauRx',.5,'fanout',inf,'IC_noise',0};
% spec.connections(4,4).label = 'IBa-IBa';
% spec.connections(4,4).mechanisms = {'IBaIBaiGAP'};
% spec.connections(4,4).parameters = {'g_GAP',ggja,'fanout',inf};
% 
% spec.connections(2,2).label = 'IBa-IBa';
% spec.connections(2,2).mechanisms = {'IBaIBaiGAP'};
% spec.connections(2,2).parameters = {'g_GAP',ggja,'fanout',inf};

% process specification and simulate model
rng(1);
data = runsim(spec,'timelimits',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0);


%plotv(data,spec,'varlabel','V');
figl;
N=length(data);
for i=1:N
    subplot(N,1,i); plot(squeeze(data(i).epochs.data(end,:,:)));
end

% % Plot other currents
% plotv(data,spec,'varlabel','iKDR_mKDR');
% plotv(data,spec,'varlabel','iCaH_mCaH');
% plotv(data,spec,'varlabel','iM_mM');
% plotv(data,spec,'varlabel','iAR_mAR');
% plotv(data,spec,'varlabel','iSYN_sSYNpre');


% dnsim(spec);

