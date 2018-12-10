% Model: Kramer 2008, PLoS Comp Bio
%% Initialize
tv1 = tic;

if ~exist('function_mode','var'); function_mode = 0; end

% addpath(fullfile(pwd,'.'));
addpath(genpath(fullfile(pwd,'funcs_supporting')));
addpath(genpath(fullfile(pwd,'funcs_supporting_xPlt')));
addpath(genpath(fullfile(pwd,'funcs_Ben')));

%% % % % % % % % % % % % %  ##0.0 Simulation master parameters % % % % % % % % % % % % %
% There are some partameters that are derived from master parameters. Put
% these master parameters first!

% List loaded modules
!module list
!pwd
path

tspan=[0 2000];
sim_mode = 12;               % % % % Choice normal sim (sim_mode=1) or parallel sim options
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
save_figures = 0;               % Master switch for saving any figures in the simulation. Controls saving figures within dsSimulate.
    save_combined_figures = 1;      % Flag for saving dsPlot2 across all simulations in data.
    save_composite_figures = 0;     % Flag for saving composite figures comprised of multiple subfigures.
Cm_Ben = 2.7;
Cm_factor = Cm_Ben/.25;

% % % % % Simulation switches
no_noise = 0;
no_synapses = 0;
NMDA_block = 0;



% % % % % Cells to include in model
include_IB =   1;
include_RS =   1;
include_FS =   1;
include_LTS =  1;
include_NG =   1;
include_dFS5 = 1;
include_deepRS = 0;
include_deepFS = 0;

% % % % % % Number of cells per population
% #mynumcells
N=20;    % Default number of cells
Nib=N;  % Number of excitatory cells
Nng=N;  % Number of FSNG cells
Nrs=80; % Number of RS cells
Nfs=N;  % Number of FS cells
Nlts=N; % Number of LTS cells
% NdeepRS = 30;
NdeepFS = N;
NdeepRS = 1;    % Number of deep theta-resonant RS cells


% % % % % PPStim parameters
%PPoffset = tspan(end)-0;   % ms, offset time
PPoffset = Inf;
%PPoffset = 1500;
kerneltype_IB = 2;

% % % % % Default repo study name
%#gar
%#gar
% gAR_d=155; % 155, IBda - max conductance of h-channel
% gAR_d=4; % 155, IBda - max conductance of h-channel
% gAR_d=2; % 155, IBda - max conductance of h-channel
gAR_d=0.5; % 155, IBda - max conductance of h-channel
% gAR_d=0; % 155, IBda - max conductance of h-channel
repo_studyname = ['batch01a_gar_' num2str(gAR_d)];

% IB Ca and M current
gM_d = 2;
gCaH_d = 2;


% Cluster info
cluster_flag = 0;

% Overwrite master parameters as needed, before deriving the rest.
if function_mode
    unpack_sim_struct       % Unpack sim struct to override these defaults if necessary
end


%% % % % % % % % % % % % %  ##1.0 Simulation parameters % % % % % % % % % % % % %

% % % % % Options for saving figures to png for offline viewing
save_figures_move_to_Figs_repo = true;
ind_range = [tspan(1) tspan(2)];
if save_figures
    universal_options = {'format','png','visible','off','figheight',.9,'figwidth',.9,};
    


    plot_options = {...
                    {universal_options{:},'plot_type','rastergram','crop_range',ind_range,'population','all'}, ...        
                    
                    
                    };
%                 {universal_options{:},'plot_type','power','crop_range',[ind_range(1), tspan(end)],'xlims',[0 80],'population','IB'}, ...
%                 {universal_options{:},'plot_type','FRpanel','crop_range',ind_range,'population','all'}, ...         
%                 {universal_options{:},'plot_type','waveform','crop_range',ind_range,'population','all','max_num_overlaid',2,'ylims',[-85 45]}, ...     
                  
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
plot_on = 0;
visible_flag = 'on';
compile_flag = 1;
parallel_flag = double(sim_mode >= 8 && ~cluster_flag);     % Sim_modes 9 - 14 are for Dave's vary simulations. Want par mode on for these.
maxNcores = 1;
save_data_flag = 0;
save_results_flag = double(~isempty(plot_options));         % If plot_options is supplied, save the results.
verbose_flag = 1;
random_seed = 'shuffle';
% random_seed = 8;
study_dir = ['study_' sp '_' repo_studyname];               % Adding repo_studyname to make sure study_dir is unique!
% study_dir = [];
% study_dir = ['study_dave'];

if isempty(plot_options); plot_functions = [];
else; plot_functions = repmat({@dsPlot2_PPStim},1,length(plot_options));
end
plot_args = {'plot_functions',plot_functions,'plot_options',plot_options};
% plot_args = 


Now = clock;

% % % % % Simulation controls
dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=max(round(0.1/dt),1); % downsample factor, applied after simulation

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
syn_ngib_IC_noise = 0; % noise in initial conditions of GABAB synapse from NG to IB cells

IC_V = -65;         % Starting membrane potential

% % % % % Offsets for deep FS cells
NaF_offset = 10;
KDR_offset = 20;

% % % % % Default ionic current values
deep_gNaF = 100;
FS_gM = 0;
%#gar
% gAR_d=155; % 155, IBda - max conductance of h-channel
% gAR_d=4; % 155, IBda - max conductance of h-channel
% gAR_d=0; % 155, IBda - max conductance of h-channel


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
Jd2=1.5;    %         
Jng1=-7;   % NG cells
Jng2=1;   %
JRS1 = -1.5; % RS cells
JRS2 = -1.5; %
if include_NG
    JRS1 = -2.1; % RS cells
    JRS2 = -2.1; %
end
Jfs=1;    % FS cells
Jdfs5=2;    % FS cells
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
IB_offset2 = Inf;
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


if no_noise
    IC_noise = 0;
    
    % Intrinsic noise
    IBda_Vnoise = 0;
    NG_Vnoise = 0;
    FS_Vnoise = 0;
    LTS_Vnoise = 0;
    RSda_Vnoise = 0;
    deepRSda_Vnoise = 0;
    deepFS_Vnoise = 0;
    
    % SYnapse noise
    gRAN=0;      % synaptic noise conductance IB cells
    RSgRAN=0;   % synaptic noise conductance to RS cells
    deepRSgRAN = 0; % synaptic noise conductance to deepRS cells
end

%% % % % % % % % % % % % %  ##2.3 Synaptic connectivity parameters % % % % % % % % % % % % %
% % Gap junction connections.
% % Deep cells
% #mygap
warning('RS gap junction normalization is wrong - should be normalized by 80, not 20');
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
g_NMDA_hetero = .3;

% % Eleak heterogenity (makes excitability of cells variable)
IB_Eleak_std = 0;
NG_Eleak_std = 0;
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

gAMPA_rsfs5=0;
gGABAa_fs5fs5 = 0;

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
gGABAa_fs5ib = 0;
gAMPA_rsib= 0;
gAMPA_rsng = 0;
gNMDA_rsng = 0;
gGABAa_LTSib = 0;

%% % ##2.3.1 Chemical Synapses, DEFINITIONS. % %

if ~no_synapses
    % % Synaptic connection strengths
    % #mysynapses
    
    % % % % % Delta oscillator (IB-NG circuit) % % % % % % % % % % % % % % % %
    gAMPA_ibib=0.1/Nib;                          % IB -> IB

    if ~NMDA_block; gNMDA_ibib=7/Nib; end        % IB -> IB NMDA
    
    gAMPA_ibng=0.02/Nib;                          % IB -> NG
    if ~NMDA_block; gNMDA_ibng=5/Nib; end        % IB -> NG NMDA
    
    gGABAa_ngng=0.6/Nng;                       % NG -> NG
    gGABAb_ngng=0.2/Nng;                       % NG -> NG GABA B
    
    gGABAa_ngib=0.1/Nng;                       % NG -> IB
    gGABAb_ngib=0.6/Nng;                       % NG -> IB GABA B
    
    
    % % IB -> LTS
%     gAMPA_ibLTS=0.02/Nib;
%     if ~NMDA_block; gNMDA_ibLTS=5/Nib; end
    
    % % Delta -> Gamma oscillator connections
    gAMPA_ibrs = 0.08/Nib;
    if ~NMDA_block
        gNMDA_ibrs = 5/Nib;
    end
%     gGABAa_ngrs = 0.05/Nng;
    gGABAb_ngrs = 0.7/Nng;
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
    
    gAMPA_rsfs5=0.5/Nrs;
    gGABAa_fs5fs5 = 1.0/Nfs;                    % dFS5 -> dFS5
    
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
    gGABAa_fsib=0.3/Nfs;                        % FS -> IB
    gGABAa_fs5ib=0.3/Nfs;
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
            'IB','PP_gSYN',[0:.125:.875]/10; ...
            %'IB','poissScaling',[100,200,300,500,700,1000]; ...
            };
    case 9  % Vary RS cells in RS-FS network
        vary = { %'RS','stim2',-1*[-.5:1:5]; ...
            %'IB','stim2',[-1:0.25:.75]; ...
            %'IB','stim',[1:.25:1.75]; ...
            %'RS','PP_gSYN',[.0:0.05:.3]; ...
            %'NG','PP_gSYN',[.0:0.05:.15]; ...
            %'RS->dFS5','g_SYN',[0, .3:.2:1.5]/Nrs;...
            %'dFS5','PP_gSYN',[0, 0.15, 0.2, 0.25]; ...
            %'FS->FS','g_SYN',[1,1.5]/Nfs;...
            %'RS->dFS5','g_SYN',[linspace(0.1,1.2,8)]/Nrs;...
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
            %'NG->IB','gGABAB',[.4:.1:1.1]/Nng;...
            %'NG->IB','gGABAB',[0,0.3,0.6]/Nng;...
            %'NG->NG','g_SYN',[.1:.1:.4]/Nng;...
            %'NG->NG','gGABAB',[.15:.05:.3]/Nng;...
%             'RS','stim2',-1*[1.9:.2:2.5]; ...
            %'RS->NG','g_SYN',[0.1:0.1:0.4]/Nrs;...
            %'IB','PP_gSYN',[0, 0.025:0.01:0.085]; ...
            %'IB','myshuffle',[1:3];...
            };
        
    case 10     % Previous inverse PAC code
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
                %myonsets = [950,1050,1150,1250,1350,1450];
                %myonsets = [550,750,950,1150,1350,1550];
                myonsets = [750,850,950,1050,1150,1250];
                myoffsets = myonsets + 100;
        vary = { %'(RS,FS,LTS,IB,NG)','PPshift',[950,1050,1150,1250,1350,1450];...
                 %'IB','PPshift',[1050,1150,1250];...
                 %'(RS,FS,LTS,IB,NG)','(PPonset,PPoffset)',[myonsets; myoffsets];...
                 %'(RS,FS,LTS,IB,NG)','(PPonset)',[300, 350,400,450, 500, 550, 600, 650, 700, 750];...
                 '(RS,FS,LTS,IB,NG)','(PPonset)',[750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300];...
                 %'RS','PPshift',[1050,1150,1250,1350]; ...
                 %'RS','PP_gSYN',[0.05:0.025:0.125]; ...
            };
        
    case 12     % Vary IB cells
        temp = [400:25:550,600,650,700, 750, 800];
        %temp = [300,350,375,550,600];
        temp = 1000./(100+temp);
        vary = { %'IB','PPstim',[-1:-1:-5]; ...
            %'NG','PPstim',[-7:1:-1]; ...
            %'IB','stim2',[0:0.5:1.5, 2:5]; ...
            %'(IB,NG,dFS5)','PPmaskshift',[1100:100:1800];...
            %                  'IB','g_l2',[.30:0.02:.44]/Nng; ...
            %'IB->IB','g_SYN',[0:0.01:0.05]/Nib;...
            %'IB','PP_gSYN',[0:.25:1]/10; ...
            %'dFS5->IB','g_SYN',[linspace(0.2,0.8,8)]/Nfs;...
            %'(IB,NG,RS,FS,LTS,dFS5)','(PPmaskfreq)',[temp];...
            %'IB','gAR',[0,2]; ...
            'NG->RS','gGABAB',[0.4:0.05:0.75]/Nng;...
            %'RS->IB','g_SYN',[0:0.1:0.3]/Nrs;...
            %'LTS->IB','g_SYN',[0:0.05:0.15]/Nlts;...
%             'RS->NG','gNMDA',[1:1:6]/Nib;...
            %'RS->NG','gNMDA',[0:1:5]/Nib*0.00001;...
            %'FS->IB','g_SYN',[.5:.1:.7]/Nfs;...
            %'IB->RS','g_SYN',[0.01:0.003:0.03]/Nib;...
            %'IB->RS','gNMDA',[6.5:0.5:10]/Nib;...ds
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
        
        
        
    case 18     % Inverse PAC with new nested PPStim method
        inter_train_interval=250;
        PPmaskdurations = [250:250:2000];
        PPmaskfreqs = 1000 ./ [PPmaskdurations + inter_train_interval];
        vary = { '(RS,FS,LTS,IB,NG)','(PPmaskfreq,PPmaskduration)',[PPmaskfreqs; PPmaskdurations];...
            };
end

%% % % % % % % % % % % % %  ##2.5 Periodic pulse parameters % % % % % % % % % % % % %
% #myppstim             
IB_PP_gSYN = 0;
RS_PP_gSYN = 0;
NG_PP_gSYN = 0;
FS_PP_gSYN = 0;
LTS_PP_gSYN = 0;
dFS_PP_gSYN = 0;

IB_PP_gSYN = 0.075;
RS_PP_gSYN = 0.2;
% NG_PP_gSYN = 0.125;
% FS_PP_gSYN = 0.15;
% LTS_PP_gSYN = 0.1;
% dFS_PP_gSYN = 0.35;
if ~include_RS; dFS_PP_gSYN = 0.2;  % If not including RS, then add pseudo stimulation to deep FS cells
else dFS_PP_gSYN = 0;
end

do_FS_reset_pulse = 0;
jitter_fall = 0.0;
jitter_rise = 0.0;
PPtauDx_LTS = tauAMPAd_LTS + jitter_fall;
PPtauRx_LTS = tauAMPAr_LTS + jitter_rise;
PPtauDx = tauAMPAd+jitter_fall; % in ms        % Broaden by fixed amount due to presynaptic jitter
PPtauRx = tauAMPAr+jitter_rise;      % Broaden by fixed amount due to presynaptic jitter
ap_pulse_delay = 11;                        % ms, the amount the spike should be delayed. 0 for no aperiodicity.
ap_pulse_num = 0;                           % ms, the amount the spike should be delayed. 0 for no aperiodicity.
PP_width = 0.25;
PPwidth2_rise = 0.25;
PPmaskfreq = 2.0;
PPmaskduration = 100;
PPmaskshift = 0;

% IB Poisson Noise
poissScaling = 1000;
if kerneltype_IB == 4
    poissScaling = 200;
end
poissTau = 2;

IB_PP_width = 2;

switch pulse_mode
    case 0                  % No stimulation
        PPfreq = 0.01; % in Hz
        
        PPshift = 0; % in ms
        PPonset = 10;    % ms, onset time
        pulse_train_preset = 0;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        kernel_type = 1;         
        IB_PP_gSYN = 0;
        RS_PP_gSYN = 0;
        NG_PP_gSYN = 0;
        FS_PP_gSYN = 0;
        LTS_PP_gSYN = 0;
        dFS_PP_gSYN = 0;
        deepRSPPstim = 0;
        do_nested_mask = 0;
    case 1                  % Gamma stimulation (with aperiodicity)
        PPfreq = 40; % in Hz
        PPshift = 0; % in ms
        PPonset = 350;    % ms, onset time
        %PPoffset = tspan(end)-500;   % ms, offset time
        ap_pulse_num = round(min(PPoffset,tspan(end))/(1000/PPfreq))-10;     % The pulse number that should be delayed. 0 for no aperiodicity.
        %ap_pulse_num = round((tspan(end)-500)/(1000/PPfreq))-10;     % The pulse number that should be delayed. 0 for no aperiodicity.
        ap_pulse_delay = 11;                        % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        %ap_pulse_delay = 0;                         % ms, the amount the spike should be delayed. 0 for no aperiodicity.
        pulse_train_preset = 1;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        kernel_type = 1;
        deepRSPPstim = -.5;
        deepRSgSpike = 0;
        do_nested_mask = 0;
        
    case 2                  % Median nerve stimulation
        % Disabled for now...
        
    case 5
        PPfreq = 40; % in Hz
        PPshift = 0; % in ms
        PPonset = 0;    % ms, onset time
        pulse_train_preset = 0;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        kernel_type = 1;
        deepRSPPstim = -.5;
        deepRSgSpike = 0;
        %         deepRSPPstim = -7;
        do_nested_mask = 1;
        
    case 6                                  % Polley stim
        % Stimulate deep FS cells, everything else set to zero.
        dFS_PP_gSYN = 0.65;
        IB_PP_gSYN = 0;
        RS_PP_gSYN = 0;
        NG_PP_gSYN = 0;
        FS_PP_gSYN = 0;
        LTS_PP_gSYN = 0;
        
        PPfreq = 110; % in Hz               % See Polley et al, 2017 - peak at 110 Hz; harmonic at 220 Hz.
        PPshift = 0; % in ms
        PPonset = 0;    % ms, onset time
        PPmaskshift = 300;
        %PPoffset = tspan(end)-500;   % ms, offset time
        pulse_train_preset = 0;     % Preset number to use for manipulation on pulse train (see getDeltaTrainPresets.m for details; 0-no manipulation; 1-aperiodic pulse; etc.)
        kernel_type = 1;
        deepRSPPstim = -.5;
        deepRSgSpike = 0;
        do_nested_mask = 1;
        
        PPmaskfreq = 2;
        PPmaskduration = 100;

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

if ~cluster_flag
    include_kramer_IB_plotting
end

