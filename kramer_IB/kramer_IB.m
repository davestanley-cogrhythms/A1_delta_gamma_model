% Model: Kramer 2008, PLoS Comp Bio
%% Initialize
tv1 = tic;

if ~exist('function_mode','var'); function_mode = 0; end

addpath(genpath(fullfile(pwd,'funcs_supporting')));
addpath(genpath(fullfile(pwd,'funcs_supporting_xPlt')));
addpath(genpath(fullfile(pwd,'funcs_Ben')));

%% % % % % % % % % % % % %  ##0.0 Simulation master parameters % % % % % % % % % % % % %
% There are some partameters that are derived from other parameters. Put
% these master parameters first!

tspan=[0 2500];
sim_mode = 11;               % % % % Choice normal sim (sim_mode=1) or parallel sim options
                            % 2 - Vary I_app in deep RS cells
                            % 9 - sim study FS-RS circuit vary RS stim
                            % 10 - Inverse PAC
                            % 11 - Vary iPeriodicPulses in all cells
                            % 12 - Vary IB cells
                            % 13 - Vary LTS cell synapses
                            % 14 - Vary random parameter in order to get repeat sims
pulse_mode = 1;             % % % % Choise of periodic pulsing input
                            % 0 - No stimulation
                            % 1 - Gamma pulse train
                            % 2 - Median nerve stimulation
                            % 3 - Auditory clicks @ 10 Hz
save_figures = 1;           % 1 - Don't produce any figures; instead save for offline viewing
                            % 0 - Display figures normally
Cm_Ben = 2.7;
Cm_factor = Cm_Ben/.25;


if function_mode
    unpack_sim_struct       % Unpack sim struct to override these defaults if necessary
end

% % % % % % Parameter modifier flags
high_IB_IB_connectivity = true;

%% % % % % % % % % % % % %  ##1.0 Simulation parameters % % % % % % % % % % % % %

% % % % % Options for saving figures to png for offline viewing
save_figures_move_to_Figs_repo = false;
repo_studyname = 'batch01';
ind_range = [tspan(1) tspan(2)];
if save_figures
    universal_options = {'format','png','visible','off','figheight',.9,'figwidth',.9,};
    

    plot_func = @(xp, op) xp_plot_AP_timing1b_RSFS_Vm(xp,op,[400 600]);

    plot_options = {...
                    {universal_options{:},'plot_type','rastergram','crop_range',ind_range,'population','all'}, ...       
                    {universal_options{:},'plot_type','waveform','crop_range',ind_range,'population','all','max_num_overlaid',2}, ...    
                    };
%                 {universal_options{:},'plot_type','waveform','crop_range',ind_range,'plot_handle',@xp1D_matrix_plot_with_AP}, ...
%                 {universal_options{:},'plot_type','waveform','crop_range',ind_range}, ...
%                     {universal_options{:},'plot_type','waveform','crop_range',ind_range,'plot_handle',@xp1D_matrix_plot_with_AP}, ...

%                     {universal_options{:},'plot_type','waveform','crop_range',ind_range,'population','all','force_last','populations','do_overlay_shift',true,'overlay_shift_val',40,'plot_handle',@xp1D_matrix_plot_with_AP}, ...
%                     {universal_options{:},'plot_type','waveform','crop_range',[100, 300]}, ...       
%                     {universal_options{:},'plot_type','waveform','crop_range',[400 600]}, ...       
%                     {universal_options{:},'plot_type','imagesc','crop_range',[400 600],'population','LTS','zlims',[-100 -20],'plot_handle',@xp_matrix_imagesc_with_AP}, ...

%                 {universal_options{:},'plot_type','imagesc','crop_range',ind_range,'population','LTS','zlims',[-100 -20],'plot_handle',@xp_matrix_imagesc_with_AP}, ...
%                 {universal_options{:},'plot_type','power','crop_range',[ind_range(1), tspan(end)],'xlims',[0 80],'population','RS'}, ...
%               {universal_options{:},'plot_handle',plot_func,'Ndims_per_subplot',3,'force_last',{'populations','variables'},'population','all','variable','all','ylims',[-.3 1.2],'lock_axes',false}, ...
                    %{universal_options{:},'plot_type','waveform','crop_range',ind_range,'variable','Mich','do_mean',true}, ...    
            
else
    plot_options = [];
end

% % % % % Get currrent date time string
mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/',''); c=clock;
sp = ['d' mydate '_t' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];

% % % % % Mechanism overrides
do_jason_sPING = 0;
do_jason_sPING_syn = 0;

% % % % % Display options
plot_on = 1;
visible_flag = 'on';
compile_flag = 1;
parallel_flag = double(any(sim_mode == [8:14]));            % Sim_modes 9 - 14 are for Dave's vary simulations. Want par mode on for these.
cluster_flag = 0;
save_data_flag = 0;
save_results_flag = double(~isempty(plot_options));         % If plot_options is supplied, save the results.
verbose_flag = 1;
random_seed = 'shuffle';
random_seed = 2;
study_dir = ['study_' sp];
% study_dir = [];
% study_dir = ['study_dave'];

if isempty(plot_options); plot_functions = [];
else; plot_functions = repmat({@dsPlot2},1,length(plot_options));
end
plot_args = {'plot_functions',plot_functions,'plot_options',plot_options};
% plot_args = 


Now = clock;

% % % % % Simulation controls
dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=max(round(0.1/dt),1); % downsample factor, applied after simulation

% % % % % Simulation switches
no_noise = 0;
no_synapses = 0;
NMDA_block = 0;

% % % % % Cells to include in model
include_IB = 1;
include_RS = 1;
include_FS = 1;
include_LTS =1;
include_NG = 1;
include_dFS5 = 1;
include_supRS = 0;
include_supFS = 0;
include_deepRS = 0;
include_deepFS = 0;

%% % % % % % % % % % % % %  ##2.0 Biophysical parameters % % % % % % % % % % % % %
% Moved by BRPP on 1/19, since Cm_factor is required to define parameters
% for deep RS cells.
% constant biophysical parameters
Cm=.9;        % membrane capacitance
gl=.1;
ENa=50;      % sodium reversal potential
E_EKDR=-95;  % potassium reversal potential for excitatory cells
IB_Eh=-25;   % h-current reversal potential for deep layer IB cells
ECa=125;     % calcium reversal potential
IC_noise=.25;% fractional noise in initial conditions
if no_noise
    IC_noise = 0;
    IBda_Vnoise = 0;
    IBs_Vnoise = 0;
    IBdb_Vnoise = 0;
    IBa_Vnoise = 0;
    gRAN=0;
    FSgRAN=0;
end

IC_V = -65;         % Starting membrane potential

% % % % % Offsets for deep FS cells
NaF_offset = 10;
KDR_offset = 20;




% % % % % Parameters for deep RS cells.
gKs = Cm_factor*0.124;
gNaP_denom = 3.36;
gKCa = Cm_factor*0.005;
bKCa = .002;
gCa = Cm_factor*.05;
CAF = 24/Cm_factor;
gl_dRS = Cm_factor*.025;
gNa_dRS = Cm_factor*12.5;
gKDR_dRS = Cm_factor*5;
I_const = 0;

tau_fast = 5;
slow_offset = 0;
slow_offset_correction = 0;
fast_offset = 0;


%% % % % % % % % % % % %  ##2.1 Number of cells % % % % % % % % % % % % % 
% Note: For some of these parameters I will define them twice - once I will
% initially define them as set to zero, and then I will define them a
% second time. I do this so that you can easily comment out the second
% definition as way to disable things (e.g. setting synapses to zero).
%
% Note2: deepRS cells represent deep RS cells.
% However, I've since switched the RS, FS, and LTS cells to representing
% deep cells. So these ones now are disabled. I'm leaving the code
% in the network, however, incase we want to re-enable them later or use
% them for something else.

% % % % % % Number of cells per population
N=20;   % Default number of cells
Nib=N;   % Number of excitatory cells
Nrs=80; % Number of RS cells
Nng=N;  % Number of FSNG cells
Nfs=N;  % Number of FS cells
Nlts=N; % Number of LTS cells
% NdeepRS = 30;
NdeepFS = N;
NdeepRS = 1;    % Number of deep theta-resonant RS cells


%% % % % % % % % % % % % % ##2.2 Injected currents % % % % % % % % % % % % %

% % % % % % Tonic input currents.
    % Note: IB, NG, and RS cells use two different values for tonic current
    % injection. This is because I generally hyperpolarize these cells for a
    % few hundred milliseconds to allow things to settle (see
    % itonicPaired.txt). The hyperpolarizing value is listed first (e.g. JRS1)
    % and then the value that kicks in after this is second (e.g. JRS2).
    % Note2: Positive values are hyperpolarizing, negative values are
    % depolarizing.
% #mystim
Jd1=5;    % IB cells
Jd2=0;    %         
Jng1=-7;   % NG cells
Jng2=1;   %
JRS1 = -1.5; % RS cells
JRS2 = -1.5; %
if include_NG
    JRS1 = -2.1; % RS cells
    JRS2 = -2.1; %
end
Jfs=1;    % FS cells
Jlts1=-2.5; % LTS cells
Jlts2=-2.5; % LTS cells
deepJRS1 = 5;    % RS deep cells
deepJRS2 = 0.75;
deepJfs = 1;     % FS deep cells
JdeepRS = -10;   % Ben's RS theta cells

% % % % % % Tonic current onset and offset times
    % Times at which injected currents turn on and off (in milliseconds). See
    % itonicPaired.txt. Setting these to 0 essentially removes the first
    % hyperpolarization step.
IB_offset1=50;
IB_onset2=50;
RS_offset1=000;         % 200 is a good settling time for RS cells
RS_onset2=000;

% % Poisson EPSPs to IB and RS cells (synaptic noise)
gRAN=.05;      % synaptic noise conductance IB cells
ERAN=0;
tauRAN=2;
lambda = 100;  % Mean frequency Poisson IPSPs
RSgRAN=0.05;   % synaptic noise conductance to RS cells
deepRSgRAN = 0.005; % synaptic noise conductance to deepRS cells

% % Magnitude of injected current Gaussian noise
% #mynoise
IBda_Vnoise = 12;
NG_Vnoise = 12;
FS_Vnoise = 12;
LTS_Vnoise = 12;
RSda_Vnoise = 12;
deepRSda_Vnoise = .3;
deepFS_Vnoise = 3;




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

%% % % % % % % % % % % % %  ##2.3 Synaptic connectivity parameters % % % % % % % % % % % % %
% % Gap junction connections.
% % Deep cells
% #mygap
ggjaRS=.01/Nib;  % RS -> RS
ggja=.02/Nib;  % IB -> IB
ggjFS=.01/Nfs;  % FS -> FS
ggjLTS=.02/Nlts;  % LTS -> LTS
% % deep cells
ggjadeepRS=.00/(NdeepRS);  % deepRS -> deepRS         % Disabled RS-RS gap junctions because otherwise the Eleaknoise doesn't have any effect
ggjdeepFS=.02/NdeepFS;  % deepFS -> deepFS

% % Chemical synapses, ZEROS - set everything to zero by default
% % Synapse heterogenity
gsyn_hetero = .3;

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
gAMPA_ibib=0;
gNMDA_ibib=0;

gAMPA_ibng=0;
gNMDA_ibng=0;

gGABAa_ngng=0;
gGABAb_ngng=0;

gGABAa_ngib=0;
gGABAb_ngib=0;

% % IB to LTS
gAMPA_ibLTS=0;
gNMDA_ibLTS=0;

% % Delta -> Gamma oscillator connections
gAMPA_ibrs = 0;
gNMDA_ibrs = 0;
gGABAa_ngrs = 0;
gGABAb_ngrs = 0;
gGABAa_ngfs = 0;
gGABAb_ngfs = 0;
gGABAa_nglts = 0;
gGABAb_nglts = 0;

% % Gamma oscillator (RS-FS-LTS circuit)
gAMPA_rsrs=0;
gNMDA_rsrs=0;
gAMPA_rsfs=0;
gNMDA_rsfs=0;
gGABAa_fsfs=0;
gGABAa_fsrs=0;

gAMPA_rsLTS = 0;
gNMDA_rsLTS = 0;
gGABAa_LTSrs = 0;

gGABAa_fsLTS = 0;
gGABAa_LTSfs = 0;

% % Gamma oscillator, deep (RS-FS circuit)
gAMPA_deepRSdeepRS=0;
gNMDA_deepRSdeepRS=0;
gAMPA_deepRSdeepFS=0;
gGABA_deepFSdeepFS=0;
gGABAa_deepFSdeepRS=0;

% % Deep -> deep connections (including NG - really should model this separately!)
gAMPA_IBdeepRS = 0;
gNMDA_IBdeepRS = 0;
gAMPA_IBdeepFS = 0;
gNMDA_IBdeepFS = 0;
gAMPA_RSdeepRS = 0;
gGABAa_NGdeepRS=0;
gGABAb_NGdeepRS=0;

% % deep -> Deep connections
gAMPA_deepRSRS = 0;
gAMPA_deepRSIB = 0;

% % Gamma -> Delta connections
gGABAa_fsib = 0;
gAMPA_rsib= 0;
gAMPA_rsng = 0;
gNMDA_rsng = 0;
gGABAa_LTSib = 0;

%% % ##2.3.1 Chemical Synapses, DEFINITIONS. % %

if ~no_synapses
    % % Synaptic connection strengths
    % #mysynapses
    
    % % % % % Delta oscillator (IB-NG circuit) % % % % % % % % % % % % % % % %
    gAMPA_ibib=0.02/Nib;                          % IB -> IB
    if high_IB_IB_connectivity
        gAMPA_ibib = 0.1/Nib;
    end
    if ~NMDA_block; gNMDA_ibib=7/Nib; end        % IB -> IB NMDA
    
    gAMPA_ibng=0.02/Nib;                          % IB -> NG
    if ~NMDA_block; gNMDA_ibng=7/Nib; end        % IB -> NG NMDA
    
    gGABAa_ngng=0.4/Nng;                       % NG -> NG
    gGABAb_ngng=0.15/Nng;                       % NG -> NG GABA B
    
    gGABAa_ngib=0.1/Nng;                       % NG -> IB
    gGABAb_ngib=1.1/Nng;                       % NG -> IB GABA B
    
    % % IB -> LTS
%     gAMPA_ibLTS=0.02/Nib;
%     if ~NMDA_block; gNMDA_ibLTS=5/Nib; end
    
    % % Delta -> Gamma oscillator connections
    gAMPA_ibrs = 0.08/Nib;
    if ~NMDA_block
        gNMDA_ibrs = 8/Nib;
        if high_IB_IB_connectivity
            gNMDA_ibrs = 5/Nib;
        end
    end
%     gGABAa_ngrs = 0.05/Nng;
    gGABAb_ngrs = 0.8/Nng;
%     gGABAa_ngfs = 0.05/Nng;
%     gGABAb_ngfs = 0.6/Nng;
%     gGABAa_nglts = 0.05/Nng;
%     gGABAb_nglts = 0.6/Nng;
    
    % % Gamma oscillator (RS-FS-LTS circuit)
    gAMPA_rsrs=.1/Nrs;                     % RS -> RS
    %     gNMDA_rsrs=5/Nrs;                 % RS -> RS NMDA
    gAMPA_rsfs=1.5/Nrs;                     % RS -> FS
    %     gNMDA_rsfs=0/Nrs;                 % RS -> FS NMDA
    gGABAa_fsfs=1.0/Nfs;                      % FS -> FS
    gGABAa_fsrs=1.0/Nfs;                     % FS -> RS
    
    gAMPA_rsLTS = 0.2/Nrs;                 % RS -> LTS
    %     gNMDA_rsLTS = 0/Nrs;              % RS -> LTS NMDA
    gGABAa_LTSrs = 0.5/Nlts;                  % LTS -> RS
    
    gGABAa_fsLTS = 1/Nfs;                  % FS -> LTS
    gGABAa_LTSfs = 0.5/Nlts;                % LTS -> FS
    
    % % Theta oscillator (deep RS-FS circuit).
    gAMPA_deepRSdeepRS=0.1/(NdeepRS);
    gNMDA_deepRSdeepRS=0.0/(NdeepRS);
    gAMPA_deepRSdeepFS=1/(NdeepRS);        % Increased by 4x due to sparse firing of deep principal cells.
    gGABA_deepFSdeepFS=0.5/NdeepFS;
    gGABAa_deepFSdeepRS=0.2/NdeepFS;       % Decreased by 3x due to reduced stimulation of deep principal cells
    
    % % Delta -> Theta connections (including NG - really should model this separately!)
    gAMPA_IBdeepRS = 0.01/Nib;
    % gNMDA_IBdeepRS = 0.2/Nib;
    % gAMPA_IBdeepFS = 0.01/Nib;
    % gNMDA_IBdeepFS = 0.1/Nib;
    gAMPA_deepRSRS = 0.15/Nrs;
    % gGABAa_NGdeepRS=0.01/Nng;
    % gGABAb_NGdeepRS=0.05/Nng;
    
    % deep -> Deep connections
    gAMPA_RSdeepRS = 0.15/NdeepRS;
    
    % % Gamma -> Delta connections
    gGABAa_fsib=0.1/Nfs;                        % FS -> IB
    if high_IB_IB_connectivity
        gGABAa_fsib=0.2/Nfs;                        % FS -> IB
    end
    gAMPA_rsib=0.1/Nrs;                         % RS -> IB
%     gAMPA_rsng = 0.3/Nrs;                       % RS -> NG
%     if ~NMDA_block; gNMDA_rsng = 2/Nrs; end     % RS -> NG NMDA
    gGABAa_LTSib = 0.1/Nlts;                     % LTS -> IB
    
    
end


% % % % % Synaptic time constants & reversals
tauAMPAr_LTS = .25;
tauAMPAd_LTS = 1;
tauAMPAr=.25;  % ms, AMPA rise time; Jung et al
tauAMPAd=1;   % ms, increased to be slightly longer to allow greater overlap
tauNMDAr=5; % ms, NMDA rise time; Jung et al
tauNMDAd=100; % ms, NMDA decay time; Jung et al
tauGABAar=.5;  % ms, GABAa rise time; Jung et al
tauGABAad=8;   % ms, GABAa decay time; Jung et al
tauGABAaLTSr = .5;  % ms, LTS rise time; Jung et al
tauGABAaLTSd_FS = 20;  % ms, LTS decay time; Jung et al
tauGABAaLTSd_RS = 20; % ms, LTS decay time onto RS cells        % Using longer version
tauGABAaLTSd_IB = 20; % ms, LTS decay time onto RS cells        % Using longer version
tauGABAbr=38;  % ms, GABAa rise time; From NEURON Delta simulation
tauGABAbd=150;   % ms, GABAa decay time; From NEURON Delta simulation
EAMPA=0;
EGABA=-95;
TmaxGABAB=0.5;      % See iGABABAustin.txt


% NMDA kinetics
% Shift Rd and Rr to make NMDA desensitize more...
increase_NMDA_desens = 1;
if increase_NMDA_desens; Rd_delta = 2*8.4*10^-3;
else Rd_delta = 0;
end
Rd = 8.4*10^-3 - Rd_delta;
Rr = 6.8*10^-3 + Rd_delta;


%% % % % % % % % % % % % %  ##2.4 Set up parallel sims % % % % % % % % % % % % %
switch sim_mode
    case 1                                                                  % Everything default, single simulation
        
        vary = [];
        
    case 2
        
        [include_IB, include_NG, include_RS, include_FS, include_LTS] = deal(0);
        [include_deepRS, include_deepFS] = deal(1);
        
        tspan = [0 6000];
        vary = {
            'deepRS', 'I_app', -6:-.1:-9;...
            % 'deepFS->deepRS', 'g_SYN', .2:.2:1,...
            };
        
    case 3
        
        include_IB = 1;
        include_NG = 1;
        include_deepRS = 0;
        include_deepFS = 0;
        
        tspan = [0 6000];
        
        vary = {'IB', 'stim2', -6.3:.01:-6.2};
        
        % vary = {'IB', 'PPfreq', [1, 2, 4, 8, 16, 32]};
        
    case 8
        vary = { ...
            %'LTS','gM',[6,8]; ...
            %'IB','stim2',-1*[-0.5:0.5:1]; ...
            %'RS','stim2',-1*[1.6:.2:2.2]; ...
            %'RS->LTS','g_SYN',[0.2:0.2:0.8]/Nrs;...
            'IB','PP_gSYN',[.1:.05:0.25]; ...
            };
    case 9  % Vary RS cells in RS-FS network
        vary = { %'RS','stim2',-1*[-.5:1:5]; ...
            %'LTS','stim',[.75:.25:1.5]; ...
            %'RS','PP_gSYN',[.0:0.05:.3]; ...
            %'NG','PP_gSYN',[.0:0.05:.15]; ...
            %'RS->FS','g_SYN',[0.2:0.2:.8]/Nrs;...
            %'FS','PP_gSYN',[.1]; ...
            %'FS->FS','g_SYN',[1,1.5]/Nfs;...
            %'RS->FS','g_SYN',[1:.5:3 4]/Nrs;...
            %'FS->RS','g_SYN',[1:.5:3 4]/Nfs;...
            %'LTS','PP_gSYN',[.0:.03:.2]; ...
            %'RS->LTS','g_SYN',[0:0.1:0.3]/Nrs;...
            %'FS->LTS','g_SYN',[.3:.2:1.5]/Nfs;...
            %'LTS->RS','g_SYN',[0.5:0.25:1.25]/Nlts;...
            %'LTS->FS','g_SYN',[0.05:0.05:.2]/Nlts;...
            %'LTS->IB','g_SYN',[0.0:0.5:1.5]/Nlts;...
            %'LTS','shuffle',[1:4];...
            %'IB->NG','g_SYN',[.4:0.2:1]/Nib;...
            %'IB->NG','gNMDA',[7:10]/Nib;...
            %'NG->IB','gGABAB',[.9:.1:1.2]/Nng;...
            %'NG->NG','g_SYN',[.1:.1:.4]/Nng;...
            %'NG->NG','gGABAB',[.15:.05:.3]/Nng;...
%             'RS','stim2',-1*[1.9:.2:2.5]; ...
            %'RS->NG','g_SYN',[0.1:0.1:0.4]/Nrs;...
            %'IB','PP_gSYN',[.15:.05:.3]; ...
            %'NG->RS','gGABAB',[0.4:0.2:1.0]/Nng;...
            };
        
    case 10     % Inverse phase amplitude coupling tests
        stretchfactor = [1:.5:2.5];
        freq_temp = [2,2,2,2];
        width_temp = [100,100,100,100];
        temp = [freq_temp ./ stretchfactor; width_temp .* stretchfactor];
        vary = { %'(RS,FS,LTS,IB,NG)','PPonset',[1350,1450,1550,1650]; ...
                 %'RS','PPshift',[1050,1150,1250,1350]; ...
                 %'RS','PP_gSYN',[0.05:0.025:0.125]; ...
                 'RS','(PPfreq,PPwidth)',temp; ...
            };
        
    case 11     % Vary PP stimulation frequency to all input cells
        vary = { %'(RS,FS,LTS,IB,NG)','PPshift',[950,1050,1150,1250,1350,1450];...
                 %'IB','PPshift',[1050,1150,1250];...
                 '(RS,FS,LTS,IB,NG)','(PPonset,PPoffset)',[950,1050,1150,1250,1350,1450; 1050,1150,1250,1350,1450,1550];...
                 %'RS','PPshift',[1050,1150,1250,1350]; ...
                 %'RS','PP_gSYN',[0.05:0.025:0.125]; ...
            };
        
    case 12     % Vary IB cells
        vary = { %'IB','PPstim',[-1:-1:-5]; ...
            %'NG','PPstim',[-7:1:-1]; ...
            %'IB','stim2',[-2]; ...
            %                  'IB','g_l2',[.30:0.02:.44]/Nng; ...
            %'IB->IB','g_SYN',[0:0.01:0.05]/Nib;...
            %'dFS5->IB','g_SYN',[0, 0.1:0.025:0.2]/Nfs;...
            %'RS->IB','g_SYN',[0:0.1:0.3]/Nrs;...
            %'LTS->IB','g_SYN',[0:0.05:0.15]/Nlts;...
%             'RS->NG','gNMDA',[1:1:6]/Nib;...
            %'RS->NG','gNMDA',[0:1:5]/Nib*0.00001;...
            %'FS->IB','g_SYN',[.5:.1:.7]/Nfs;...
            %'IB->RS','g_SYN',[0.01:0.003:0.03]/Nib;...
            'IB->RS','gNMDA',[3:8]/Nib;...
            %'IB->NG','gNMDA',[5,7,9,11]/Nib;...
            % For NMDA block conditions
            %'IB->NG','gNMDA',[0.005,0.007,0.009,0.011]/Nib;...
            %'RS->NG','g_SYN',[.1:.1:.3]/Nfs;...
            %'(IB,NG,RS)', 'ap_pulse_num',[25:5:70];...
            };
        
    case 13         % LTS Cell synapses
        vary = { 'RS->LTS','g_SYN',[.1:.025:.2]/Nrs;...
            'FS->LTS','g_SYN',[.1:.1:.6]/Nfs;...
            %'LTS','stim',[-.5:.1:.5]; ...
            
            };
        
    case 14         % Vary random parameter to force shuffling random seed
        vary = {'RS','asdfasdfadf',1:4 };       % shuffle starting seed 8 times
        random_seed = 'shuffle';                % Need shuffling to turn on, otherwise this is pointless.
        
        
end

%% % % % % % % % % % % % %  ##2.5 Periodic pulse parameters % % % % % % % % % % % % %
% #myppstim
IB_PP_gNMDA = 0;               
IB_PP_gSYN = 0;
RS_PP_gSYN = 0;
NG_PP_gSYN = 0;
FS_PP_gSYN = 0;
LTS_PP_gSYN = 0;

IB_PP_gSYN = 0.25;
% IB_PP_gNMDA = 0.5;
RS_PP_gSYN = 0.2;
% NG_PP_gSYN = 0.125;
% FS_PP_gSYN = 0.15;
% LTS_PP_gSYN = 0.1;
do_FS_reset_pulse = 0;
jitter_fall = 0.0;
jitter_rise = 0.0;
PPtauDx_LTS = tauAMPAd_LTS + jitter_fall;
PPtauRx_LTS = tauAMPAr_LTS + jitter_rise;
PP_width = 0.25;
PPwidth2_rise = 0.25;

switch pulse_mode
    case 0                  % No stimulation
        PPfreq = 4; % in Hz
        PPtauDx = tauAMPAd+jitter_fall; % in ms        % Broaden by fixed amount due to presynaptic jitter
        PPshift = 0; % in ms
        PPonset = 10;    % ms, onset time
        PPoffset = tspan(end)-0;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_num = 0;        % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 0;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        PPtauRx = tauAMPAr+jitter_rise;      % Broaden by fixed amount due to presynaptic jitter
        kernel_type = 1;
        PPFacTau = 100;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
        RSPPFacTau = 100;
        IB_PP_gNMDA = 0;               
        IB_PP_gSYN = 0;
        RS_PP_gSYN = 0;
        NG_PP_gSYN = 0;
        FS_PP_gSYN = 0;
        LTS_PP_gSYN = 0;
        deepRSPPstim = 0;
        IB_PP_gNMDA = 0;
    case 1                  % Gamma stimulation (with aperiodicity)
        PPfreq = 40; % in Hz
        PPtauDx = tauAMPAd+jitter_fall; % in ms        % Broaden by fixed amount due to presynaptic jitter
        PPshift = 0; % in ms
        PPonset = 550;    % ms, onset time
        %PPoffset = tspan(end);   % ms, offset time
        PPoffset = tspan(end)-300;   % ms, offset time
        %PPoffset=270;   % ms, offset time
        %ap_pulse_num = round((tspan(end))/(1000/PPfreq))-10;     % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_num = round((tspan(end)-300)/(1000/PPfreq))-10;     % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 11;                        % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        %ap_pulse_num = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 1;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        PPtauRx = tauAMPAr+jitter_rise;      % Broaden by fixed amount due to presynaptic jitter
        kernel_type = 1;
        PPFacTau = 100;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
        RSPPFacTau = 100;
        deepRSPPstim = 0;
        deepRSPPstim = -.5;
        deepRSgSpike = 0;
        %         deepRSPPstim = -7;
        
    case 2                  % Median nerve stimulation
        % Disabled for now...
    case 3                  % Amplitude --> Phase modulation
        PPfreq = 2; % in Hz
        PPtauDx = tauAMPAd+jitter_fall; % in ms        % Broaden by fixed amount due to presynaptic jitter
        PPshift = 750; % in ms
        PPonset = 0;    % ms, onset time
        PPoffset = tspan(end);   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_delay = 11;                        % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        ap_pulse_num = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 1;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        PPtauRx = tauAMPAr+jitter_rise;      % Broaden by fixed amount due to presynaptic jitter
        kernel_type = 1;
        PPFacTau = 100;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
        RSPPFacTau = 100;
        deepRSPPstim = 0;
        deepRSPPstim = -.5;
        deepRSgSpike = 0;
        %         deepRSPPstim = -7;
            % Turn off IB stim; leave RS stim on
        IB_PP_gSYN = 0;
        IB_PP_gNMDA = 0;
        RS_PP_gSYN = 0.15;
        
        PP_width = 100;
        
    case 4                  % Amplitude --> Phase modulation LONG
        stretchfactor = 1;
        PPfreq = 2/stretchfactor; % in Hz
        PPtauDx = tauAMPAd+jitter_fall; % in ms        % Broaden by fixed amount due to presynaptic jitter
        PPshift = 500; % in ms
        PPonset = 0;    % ms, onset time
        PPoffset = tspan(end);   % ms, offset time
        %PPoffset=270;   % ms, offset time
        ap_pulse_delay = 11;                        % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        ap_pulse_num = 0;  % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 1;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        PPtauRx = tauAMPAr+jitter_rise;      % Broaden by fixed amount due to presynaptic jitter
        kernel_type = 1;
        PPFacTau = 100;
        PPFacFactor = 1.0;
        IBPPFacFactor = 1.0;
        RSPPFacFactor = 1.0;
        RSPPFacTau = 100;
        deepRSPPstim = 0;
        deepRSPPstim = -.5;
        deepRSgSpike = 0;
        %         deepRSPPstim = -7;
            % Turn off IB stim; leave RS stim on
        IB_PP_gSYN = 0;
        IB_PP_gNMDA = 0;
        RS_PP_gSYN = 0.20;
        
        PP_width = 100*stretchfactor;
end

% if function_mode, return, end
if function_mode
    unpack_sim_struct       % Unpack sim struct to override these defaults if necessary
end

%% % % % % % % % % % % % %  ##3.0 Build populations and synapses % % % % % % % % % % % % %
% % % % % % % % % % ##3.1 Populations % % % % % % % % %
include_kramer_IB_populations;

% % % % % % % % % % ##3.2 Connections % % % % % % % % %
include_kramer_IB_synapses;

%% % % % % % % % % % % % %  ##4.0 Run simulation & post process % % % % % % % % % % % % %

include_kramer_IB_simulate;

%% ##5.0 Plotting

% Load figures from save if necessary
if plot_on && save_figures
    % mysaves
    data_img = dsImportPlots(study_dir); xp_img_temp = dsAll2mdd(data_img);
    xp_img = calc_synaptic_totals(xp_img_temp,pop_struct); clear xp_img_temp
    if exist('data_old','var')
        data_img = dsMergeData(data_img,data_old);
    end
    save_path = fullfile(study_dir,'Figs_Composite');                       % For saving figures with save_figures flag turned on
    
    p = gcp('nocreate');
    if ~isempty(p)
        parfor i = 1:length(xp_img.data{1}); dsPlot2(xp_img,'saved_fignum',i,'supersize_me',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false); end
    else
        for i = 1:length(xp_img.data{1}); dsPlot2(xp_img,'saved_fignum',i,'supersize_me',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false); end
    end
   
    %NMDA_s, NMDAgbar, AMPANMDA_gTH, AMPAonly_gTH, NMDAonly_gTH
    
    
    if include_IB && include_NG && include_FS
        i=i+1;
        dsPlot2(data,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.35],'force_last','variable','LineWidth',2,...
            'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false)
    end
    
    if include_RS && include_LTS
        i=i+1;
        dsPlot2(data,'population','/RS|LTS/','variable','Mich','xlims',ind_range,'do_mean',true,'LineWidth',2,...
            'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false)
    end
    
    
    % Compare different IB->IB currents (NMDA, AMPA, total)
    if include_IB
%         i=i+1;
%         dsPlot2(data,'population','IB','variable','/AMPANMDA_gTH|NMDAonly_gTH|AMPAonly_gTH/','do_mean',true,'xlims',ind_range,'force_last','variable','LineWidth',2,...
%             'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false)
    end

end


if plot_on && ~save_figures
    % % Do different plots depending on which parallel sim we are running
    switch sim_mode
        case {1,11}            
            %%
            dsPlot2(data,'variable','/RS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','do_mean',true)
            %%
            % #myfigs1
            % dsPlot(data,'plot_type','waveform');
            inds = 1:1:length(data);
            h = dsPlot2(data(inds),'population','all','force_last',{'populations'},'supersize_me',false,'do_overlay_shift',true,'overlay_shift_val',40,'plot_handle',@xp1D_matrix_plot_with_AP,'crop_range',ind_range);
            
            %dsPlot_with_AP_line(data,'plot_type','rastergram');
            dsPlot2(data(inds),'plot_type','imagesc','crop_range',ind_range,'population','LTS','zlims',[-100 -20],'plot_handle',@xp_matrix_imagesc_with_AP);
            
            plot_func = @(xp, op) xp_plot_AP_timing1b_RSFS_Vm(xp,op,ind_range);
            dsPlot2(data,'plot_handle',plot_func,'Ndims_per_subplot',3,'force_last',{'populations','variables'},'population','all','variable','all','ylims',[-.3 1.2],'lock_axes',false);
            
            if include_IB && include_NG && include_FS; dsPlot(data,'plot_type','waveform','variable',{'IB_NG_GABA_gTH','IB_THALL_GABA_gTH','IB_FS_GABA_gTH'});
%             elseif include_IB && include_NG; dsPlot(data2,'plot_type','waveform','variable',{'IB_NG_GABA_gTH'});
            elseif include_IB && include_FS; dsPlot(data2,'plot_type','waveform','variable',{'IB_FS_GABA_gTH'});
            elseif include_FS;
                %dsPlot(data2,'plot_type','waveform','variable',{'FS_GABA2_gTH'});
            end
            
            %             dsPlot(data,'plot_type','power');
            
            %elseif include_FS; dsPlot(data2,'plot_type','waveform','variable',{'FS_GABA2_gTH'}); end
            %PlotFR(data);
        case {2,3}
            dsPlot(data,'plot_type','waveform');
            % dsPlot(data,'variable','IBaIBdbiSYNseed_s','plot_type','waveform');
            % dsPlot(data,'variable','iNMDA_s','plot_type','waveform');
            
            save_as_pdf(gcf, sprintf('kramer_IB_sim_%d', sim_mode))
            
        case {5,6}
            dsPlot(data,'plot_type','waveform','variable','IB_V');
        case {8,9,10,12}

            
            %%
            % #myfigs9

                inds = 1:length(data);
                h = dsPlot2(data(inds),'population','all','force_last',{'populations'},'supersize_me',false,'do_overlay_shift',true,'overlay_shift_val',40,'plot_handle',@xp1D_matrix_plot_with_AP,'crop_range',ind_range);

                dsPlot2(data(inds),'plot_type','imagesc','crop_range',ind_range,'population','RS','zlims',[-100 -20],'plot_handle',@xp_matrix_imagesc_with_AP);

                h = dsPlot2(data(inds),'plot_type','rastergram','crop_range',ind_range,'xlim',ind_range,'plot_handle',@xp_PlotData_with_AP);
                h = dsPlot2(data(inds),'plot_type','rastergram','crop_range',ind_range,'xlim',ind_range,'supersize_me',true)
                %dsPlot2(data,'do_mean',1,'plot_type','power','crop_range',[ind_range(1), tspan(end)],'xlims',[0 120]);

                plot_func = @(xp, op) xp_plot_AP_timing1b_RSFS_Vm(xp,op,ind_range);
                dsPlot2(data(inds),'plot_handle',plot_func,'Ndims_per_subplot',3,'force_last',{'populations','variables'},'population','all','variable','all','supersize_me',false,'ylims',[-.3 .5],'lock_axes',false);

            
            
            
%             for i = 1:4:8;  dsPlot2(data,'plot_type','imagesc','varied1',i:i+3,'population','RS','varied2',[1:2:6],'do_zoom',0,'crop_range',[200 300]);end
%             
%             for i = 1:4:8; dsPlot2(data,'plot_type','heatmap_sortedFR','varied1',i:i+3,'population','RS','varied2',[1:6],'do_zoom',0); end
% 
%             for i = 1:4:8;dsPlot2(data,'plot_type','power','varied1',i:i+3,'population','RS','varied2',[1:2:6],'do_zoom',0,'do_mean',1,'xlims',[0 80]); end
% 
%             for i = 1:4:8;  dsPlot2(data,'plot_type','waveform','varied1',i:i+3,'population','LTS','varied2',[1:1:6],'do_zoom',0,'crop_range',[0 300],'do_mean',1);end



            
            %dsPlot(data,'plot_type','waveform');
            %dsPlot(data,'plot_type','power');
            
            %dsPlot(data2,'plot_type','waveform','variable','FS_FS_IBaIBdbiSYNseed_s');
            %dsPlot(data,'variable','RS_V'); dsPlot(data,'variable','FS_V');
%             
%             tfs = 10;
%             dsPlot_with_AP_line(data,'textfontsize',tfs,'plot_type','waveform','max_num_overlaid',10);
%             
%             t = data(1).time; data3 = CropData(data, t > 350 & t <= t(end));
%             dsPlot_with_AP_line(data3,'textfontsize',tfs,'max_num_overlaid',10,'variable','FS_V','plot_type','waveform')
%             
%             dsPlot_with_AP_line(data3,'textfontsize',tfs,'max_num_overlaid',10,'variable','FS_V','plot_type','rastergram')

            
            %PlotFR2(data,'plot_type','meanFR')
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','RS_V','plot_type','power'); end
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','RS_V'); end
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','FS_V'); end
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','RS_FS_IBaIBdbiSYNseed_s'); end
            %             PlotStudy(data,@plot_AP_decay1_RSFS)
            %             PlotStudy(data,@plot_AP_timing1_RSFS)
            %         dsPlot(data,'plot_type','rastergram','variable','RS_V'); dsPlot(data,'plot_type','rastergram','variable','FS_V')
            %         dsPlot(data2,'plot_type','waveform','variable','RS_V');
            %         dsPlot(data2,'plot_type','waveform','variable','FS_V');
            
            %         dsPlot(data,'plot_type','rastergram','variable','RS_V');
            %         dsPlot(data,'plot_type','rastergram','variable','FS_V');
            %         PlotFR2(data,'variable','RS_V');
            %         PlotFR2(data,'variable','FS_V');
            %         PlotFR2(data,'variable','RS_V','plot_type','meanFR');
            %         PlotFR2(data,'variable','FS_V','plot_type','meanFR');
            
%             save_as_pdf(gcf, 'kramer_IB')
            
            
        case 14
            %% Case 14
            data_var = dsCalcAverages(data);                  % Average all cells together
            data_var = RearrangeStudies2Neurons(data);      % Combine all studies together as cells
            dsPlot_with_AP_line(data_var,'plot_type','waveform')
            dsPlot_with_AP_line(data_var,'variable',{'RS_V','RS_LTS_IBaIBdbiSYNseed_s','RS_RS_IBaIBdbiSYNseed_s'});
            opts.save_std = 1;
            data_var2 = dsCalcAverages(data_var,opts);         % Average across cells/studies & store standard deviation
            figl;
            subplot(211);plot_data_stdev(data_var2,'RS_LTS_IBaIBdbiSYNseed_s',[]); ylabel('LTS->RS synapse');
            subplot(212); plot_data_stdev(data_var2,'RS_V',[]); ylabel('RS Vm');
            xlabel('Time (ms)');
            %plot_data_stdev(data_var2,'RS_RS_IBaIBdbiSYNseed_s',[]);
            
            %dsPlot_with_AP_line(data,'variable','RS_V','plot_type','rastergram')
            dsPlot_with_AP_line(data(5),'plot_type','waveform')
            dsPlot_with_AP_line(data(5),'plot_type','rastergram')
            
            
        otherwise
            if 0
                dsPlot(data,'plot_type','waveform');
                %dsPlot_with_AP_line(data,'plot_type','waveform','variable','LTS_V','max_num_overlaid',50);
                %dsPlot_with_AP_line(data,'plot_type','rastergram','variable','LTS_V');
                %dsPlot_with_AP_line(data2,'plot_type','waveform','variable','RS_LTS_IBaIBdbiSYNseed_s');
                %dsPlot_with_AP_line(data2,'plot_type','waveform','variable','LTS_IBiMMich_mM');
            end
            
            if 0
                %% Plot overlaid Vm data
                data_cat = cat(3,data.RS_V,data.FS_V,data.LTS_V);
                figure; plott_matrix3D(data_cat);
            end
            
    end
end
    if 0        % Other plotting code that is run manually
        %% myfigs
        
        ind = 1:4;
        dsPlot_with_AP_line(data(ind))
        dsPlot(data(ind),'plot_type','raster')
        dsPlot_with_AP_line(data(ind),'variable','RS_V')
        dsPlot_with_AP_line(data(ind),'variable','LTS_V')
        
        %%
        ind = 5:8;
        dsPlot_with_AP_line(data(ind))
        dsPlot(data(ind),'plot_type','raster')
        dsPlot_with_AP_line(data(ind),'variable','RS_V')
        dsPlot_with_AP_line(data(ind),'variable','LTS_V')
        
        %%
        
        dsPlot2(data,'do_mean',true,'force_last','varied1','plot_type','waveform','Ndims_per_subplot',2,'variable','/RS_IBaIBdbiSYNseed_s|FS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        dsPlot2(data,'do_mean',true,'force_last','varied1','plot_type','waveform','Ndims_per_subplot',2,'variable','/IB_IBaIBdbiSYNseed_s|NG_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        
        %dsPlot2(data,'do_mean',false,'force_last','varied1','plot_type','waveformErr','Ndims_per_subplot',2,'variable','/RS_IBaIBdbiSYNseed_s|FS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        %dsPlot2(data,'do_mean',false,'force_last','varied1','plot_type','waveformErr','Ndims_per_subplot',2,'variable','/IB_IBaIBdbiSYNseed_s|NG_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        
        
        %%
        dsPlot2(data,'force_last','populations','plot_type','imagesc')
        dsPlot2(data,'force_last','populations','plot_type','raster')
        dsPlot2(data,'plot_type','raster','population','RS')
        dsPlot2(data,'plot_type','waveform','population','NG')
        %dsPlot2(data,'population','IB','variable','/IBaIBdbiSYNseed_s/','do_mean',true,'force_last','variable')
        dsPlot2(data,'population','RS','variable','/RS_IBaIBdbiSYNseed_s|FS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','do_mean',true,'force_last','variable')
        dsPlot2(data,'population','RS','variable','/NMDA_s|LTS_IBaIBdbiSYNseed_s/','do_mean',true,'force_last','variable')
        dsPlot2(data,'population','IB','variable','NG_iGABABAustin_g','do_mean',true)
        dsPlot2(data,'population','IB','variable','/NMDA_s|NG_GABA_gTH|Mich/','do_mean',true,'force_last','variable')
        
        
        
        dsPlot2(data,'plot_type','raster','xlims',[400 1500]);
        dsPlot2(data,'population','IB','variable','/NMDA_s|NG_GABA_gTH/','xlims',[400 1500],'do_mean',true,'force_last','variable')
        dsPlot2(data,'population','/RS|LTS/','variable','Mich','xlims',[tspan(1) tspan(2)],'do_mean',true)
        
        dsPlot2(data,'plot_type','raster','xlims',[1150 1325],'plot_handle',@xp_PlotData_with_AP)
        
        % Play Hallelujah
        load handel.mat;
        sound(y, 1*Fs);
    end

    
spec_all.spec = spec;
spec_all.pop_struct = pop_struct;
%% ##6.0 Move composite figures and individual figs to Figs repo.
if save_figures_move_to_Figs_repo && save_figures
    save_allfigs_Dave(study_dir,spec_all,[],false,repo_studyname)
end

toc(tv1)

%%