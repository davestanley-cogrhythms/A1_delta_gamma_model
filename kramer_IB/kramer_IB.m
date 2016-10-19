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
                % 10 - Vary iPeriodicPulses in all cells
                
                
% Cells to include in model
include_RS = 1;
include_FS = 1;

% simulation controls
tspan=[0 2000]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=25; % downsample factor, applied after simulation

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
        PPonset = 250;    % ms, onset time
        PPoffset = tspan(end)-250;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 60;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 11;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        ap_pulse_num = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        width2_rise = .5;  % Not used for Gaussian pulse
        kernel_type = 1;
        IBPPstim = 0;
        NGPPstim = 0;
        RSPPstim = 0;
        FSPPstim = 0;
        supRSPPstim = 0;
        IBPPstim = -5;
        RSPPstim = -4;
        NGPPstim = -1;
%         FSPPstim = -5;
%         supRSPPstim = -7;

end


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

if ~no_synapses


% RS-FS circuit (deep connections)
% #mysynapses
gAMPA_rsrs=0.1/Nrs;
    gNMDA_RSRS=5/Nrs;
gAMPA_rsfs=0.4/Nrs;
    gNMDA_rsfs=0/Nrs;
gGABAaff=.5/Nfs;
gGABAa_fsrs=1.0/Nfs;

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
    
    case 9  % Vary RS cells in RS-FS network

        vary = { %'RS','stim2',linspace(3.5,1.5,4); ...
                 %'RS','PPstim',linspace(-5,-2,4); ...
                 'RS->FS','g_SYN',[.2:.1:.5]/Nrs;...
                 'FS->RS','g_SYN',[.6:.1:1.2]/Nfs;...

                 }; 

        
end

% % % % % % % % % % % % %  Populations  % % % % % % % % % % % % %  

spec=[];
i=0;


if include_RS
    i=i+1;
    spec.populations(i).name = 'RS';
    spec.populations(i).size = Nrs;
    spec.populations(i).equations = {['V''=(current)/Cm; V(0)=' num2str(IC_V) ]};
    spec.populations(i).mechanism_list = {'iPeriodicPulses','IBdbiPoissonExpJason','itonicPaired','IBnoise','IBiNaF','IBiKDR','IBiMMich','IBiCaH','IBleaknoisy'};
    spec.populations(i).parameters = {...
      'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'E_l_std',10,'g_l',gl,...
      'PPstim', RSPPstim, 'PPfreq', PPfreq,      'PPwidth', PPwidth,'PPshift',PPshift,...
      'PPonset', PPonset, 'PPoffset', PPoffset, 'ap_pulse_num', ap_pulse_num,...
      'ap_pulse_delay', ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'gRAN',RSgRAN,'ERAN',ERAN,'tauRAN',tauRAN,'lambda',lambda,...
      'stim',JRS1,'onset',0,'offset',RS_offset1,'stim2',JRS2,'onset2',RS_onset2,'offset2',Inf,...
      'V_noise',RSda_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      'gM',0.5,'E_M',E_EKDR,...
      'gCaH',0,'E_CaH',ECa,...
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
      'PPstim',FSPPstim,'PPfreq',PPfreq,'PPwidth',PPwidth,'PPshift',PPshift,...
      'PPonset',PPonset,'PPoffset',PPoffset,'ap_pulse_num',ap_pulse_num,...
      'ap_pulse_delay',ap_pulse_delay,'kernel_type', kernel_type, 'width2_rise', width2_rise,...
      'stim',Jfs,'onset',0,'offset',Inf,...
      'V_noise',FS_Vnoise,...
      'gNaF',100,'E_NaF',ENa,...
      'gKDR',80,'E_KDR',E_EKDR,...
      };
end



% % % % % % % % % % % %  Connections  % % % % % % % % % % % % %  
i=0;

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

% % FS->RS Synaptic connections
if include_FS && include_RS
    i=i+1;
    spec.connections(i).direction = 'FS->RS';                   % GABA_A
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_fsrs,'E_SYN',EGABA,...
        'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


% % % % % % % % % % % %  Run simulation  % % % % % % % % % % % % % 
data=SimulateModel(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,... % 'coder',0,'random_seed',1,'compile_flag',1,'vary',vary,...
    'parallel_flag',double(sim_mode ~= 1),'verbose_flag',1);
% SimulateModel(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary,'parallel_flag',0,...
%     'cluster_flag',1,'save_data_flag',1,'study_dir','kramerout_cluster_2','verbose_flag',1);

% Downsample data
data = DownsampleData(data,max(round(0.1/dt),1));   % Downsample so that sampling rate is 10000 Hz (dt = 0.1 ms)


% Calculate averages across cells (e.g. mean field)
data2 = CalcAverages(data);

toc;

% % % % % % % % % % % %  Plotting  % % % % % % % % % % % % % 
switch sim_mode
    case 1
        PlotData(data,'plot_type','waveform');
%          PlotData(data,'plot_type','rastergram');
        
        % PlotFR2(data);
    
    case 9
        %%
        %PlotData(data,'plot_type','waveform');
        %PlotData(data,'plot_type','power');
        
        PlotData(data2,'plot_type','waveform','variable','FS_FS_IBaIBdbiSYNseed_s');
        PlotData(data2,'plot_type','waveform','variable','RS_V');
        PlotData(data2,'plot_type','waveform','variable','FS_V');

        PlotData(data,'plot_type','rastergram','variable','RS_V');
        PlotData(data,'plot_type','rastergram','variable','FS_V');
        % PlotFR2(data,'variable','RS_V'); 
        % PlotFR2(data,'variable','FS_V'); 
        % PlotFR2(data,'variable','RS_V','plot_type','meanFR');
        % PlotFR2(data,'variable','FS_V','plot_type','meanFR');


        
        
    otherwise
        PlotData(data,'plot_type','waveform');
end


toc

%%




