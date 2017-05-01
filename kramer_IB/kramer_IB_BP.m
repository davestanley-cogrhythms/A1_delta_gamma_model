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
                % 11 - Vary FS cells
                % 12 - Vary IB cells
                % 13 - Vary LTS cell synapses
                % 14 - Vary random parameter in order to get repeat sims
                
               
% Cells to include in model
include_RS = 1;
include_FS = 1;

% simulation controls
tspan=[0 2000]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=25; % downsample factor, applied after simulation

% % Simulation switches
no_noise = 0;
no_synapses = 0;
NMDA_block = 0; 


%% ##2.0 Model parameters
% Note: For some of these parameters I will define them twice - once I will
% initially define them as set to zero, and then I will define them a
% second time. I do this so that you can easily comment out the second
% definition as way to disable things (e.g. setting synapses to zero).
% 
% Note2: SupRS and SupFS cells represent superficial RS and FS cells.
% However, I've since switched the RS, FS, and LTS cells to representing
% superficial cells. So these ones now are disabled. I'm leaving the code
% in the network, however, incase we want to re-enable them later or use
% them for something else.

% % Number of cells per population
N=30;   % Number of excitatory cells
Nrs=N; % Number of RS cells
Nng=N;  % Number of FSNG cells
Nfs=N;  % Number of FS cells
Nlts=N; % Number of LTS cells
NsupRS = 30; 
NsupFS = N;
NdeepRS = 1;    % Number of deep theta-resonant RS cells

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
JdeepRS = -0.3;   % Ben's RS theta cells

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
        PPonset = 250;    % ms, onset time
        PPoffset = tspan(end)-250;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 60;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 11;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        ap_pulse_num = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
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
        IBPPstim = -5;
        RSPPstim = -4;
        NGPPstim = -1;
%         FSPPstim = -5;
%         supRSPPstim = -7;

end


% % % % % % % % % % % % %  ##2.2 Synaptic connectivity parameters % % % % % % % % % % % % %  
% % Gap junction connections
% % Deep cells
ggjaRS=.2/N;  % RS -> RS
ggja=.2/N;  % IB -> IB 
ggjFS=.2/Nfs;  % FS -> FS
ggjLTS=.0/Nlts;  % LTS -> LTS
    warning('Need to set LTS gap junctions to 0.2. Probably need to increase Vnoise to compensate.');
% % Sup cells
ggjasupRS=.00/(NsupRS);  % supRS -> supRS         % Disabled RS-RS gap junctions because otherwise the Eleaknoise doesn't have any effect
ggjsupFS=.2/NsupFS;  % supFS -> supFS


% % Synapse heterogenity
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
    spec.populations(i).equations = {['V''=(@current)/Cm; V(0)=' num2str(IC_V) ]};
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
    spec.populations(i).equations = {['V''=(@current)/Cm; V(0)=' num2str(IC_V) ]};
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

% % % % % % % % % % ##3.2 Connections % % % % % % % % %
include_kramer_IB_synapses;


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
data=dsSimulate(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,... % 'coder',0,'random_seed',1,'compile_flag',1,'vary',vary,...
    'parallel_flag',double(sim_mode ~= 1),'verbose_flag',1);
% dsSimulate(spec,'tspan',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0,'random_seed',1,'compile_flag',1,'vary',vary,'parallel_flag',0,...
%     'cluster_flag',1,'save_data_flag',1,'study_dir','kramerout_cluster_2','verbose_flag',1);

% Downsample data
data = DownsampleData(data,max(round(0.1/dt),1));   % Downsample so that sampling rate is 10000 Hz (dt = 0.1 ms)


% Calculate averages across cells (e.g. mean field)
data2 = CalcAverages(data);


% % % % % % % % % % ##4.2 Post process simulation data % % % % % % % % % %
% % Crop data within a time range
% t = data(1).time; data = CropData(data, t > 100 & t <= t(end));

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

end

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
%             PlotData_with_AP_line(data2,'plot_type','waveform','variable','RS_V');
    

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


toc

%%




