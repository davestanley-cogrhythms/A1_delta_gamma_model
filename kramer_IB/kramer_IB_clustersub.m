

%% Delta paper figures

myhours = 4;        % By default codes adds 30 minutes wall time. Definitely shoudln't take longer than 30 minutes!

% Full network, single run
clustersub('kramer_IB_deltapaper_scripts2','1a1',1,myhours);        % No AP pulse
clustersub('kramer_IB_deltapaper_scripts2','1b1',1,myhours);        % Click train with AP pulse
clustersub('kramer_IB_deltapaper_scripts2','1b2',1,myhours);        % As 1b1, but only superficial oscillator
clustersub('kramer_IB_deltapaper_scripts2','1c1',1,myhours);        % Spontaneous oscillations
clustersub('kramer_IB_deltapaper_scripts2','1d',1,myhours);         % 1a1, but with Poisson input instead of 
clustersub('kramer_IB_deltapaper_scripts2','1ac',1,myhours);        % Figs 1a and 1c together to do spectrogram 
clustersub('kramer_IB_deltapaper_scripts2','1dc',1,myhours);        % Do both Figs 1d and 1c together to do spectrogram comparison (Poisson input)
clustersub('kramer_IB_deltapaper_scripts2','1a4',1,myhours);        % Core input only
clustersub('kramer_IB_deltapaper_scripts2','1a5',1,myhours);        % Matrix input only
clustersub('kramer_IB_deltapaper_scripts2','1a6',1,myhours);        % As 1a1, but low-gamma click train (~30 Hz)
clustersub('kramer_IB_deltapaper_scripts2','1a7',1,myhours);        % As 1a1, but high-gamma click train (~80 Hz)


% Repeated runs with shuffling (not sure what the point of this was)
clustersub('kramer_IB_deltapaper_scripts2','1a1_shuffle',4,myhours);

% Sweep through different frequency click trains.
clustersub('kramer_IB_deltapaper_scripts2','3a',8,myhours);        % Sweep low frequency
clustersub('kramer_IB_deltapaper_scripts2','3a2',8,myhours);        % Sweep low frequencies only superficial oscillator
clustersub('kramer_IB_deltapaper_scripts2','3b',6,myhours);        % Sweep high frequency
clustersub('kramer_IB_deltapaper_scripts2','3b2',6,myhours);        % Sweep high frequency only superficial oscillator

% Lakatos delta entrainment figures
clustersub('kramer_IB_deltapaper_scripts2','4a',8,myhours);         % Lakatos 2005 figure
clustersub('kramer_IB_deltapaper_scripts2','4a2',13,myhours);        % Lakatos 2005 figure with longer run time, higher downsampling
clustersub('kramer_IB_deltapaper_scripts2','4b',8,myhours);         % As Fig 4a, except use gamma 40 Hz stim instead of Poisson
clustersub('kramer_IB_deltapaper_scripts2','13a',28,myhours);        % 2D sweeps
clustersub('kramer_IB_deltapaper_scripts2','13a_p1',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p2',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p3',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p4',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p5',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p6',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p7',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p8',28,myhours);     % 2D sweeps (break into parts).
clustersub('kramer_IB_deltapaper_scripts2','13a_p9',28,myhours);     % 2D sweeps (break into parts).

% Inverse phase-amplitude coupling figures
clustersub('kramer_IB_deltapaper_scripts2','5a',8,myhours);        % Inverse PAC  
clustersub('kramer_IB_deltapaper_scripts2','5a2',16,myhours);        % Inverse PAC - long run
clustersub('kramer_IB_deltapaper_scripts2','5b',8,myhours);        % Inverse PAC part 2 - block IB PPStim
clustersub('kramer_IB_deltapaper_scripts2','5c',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','5d',8,myhours);        % Inverse PAC - as Fig5a, but with gamma click train stim

% Vary onset timing of PPStim
clustersub('kramer_IB_deltapaper_scripts2','6a',8,myhours);         % Vary onset, Poisson stim.
clustersub('kramer_IB_deltapaper_scripts2','6a_core',8,myhours);    % As 6a, but core stim only
clustersub('kramer_IB_deltapaper_scripts2','6b',8,myhours);         % As Fig 6a except 40 Hz Thalamic input instead of poisson
clustersub('kramer_IB_deltapaper_scripts2','6a2',16,myhours);       % As 6a, but doing a reset figure like Fig9c
clustersub('kramer_IB_deltapaper_scripts2','6a2_core',16,myhours);  % As 6a2, but core stim only

% No longer used. Shows entrainment (as in Fig 4a, Lakatos figure) for
% varying synaptic strengths. Uses same synaptic pathways as 8.
clustersub('kramer_IB_deltapaper_scripts2','7a',8,myhours);         % Block gamma input; sweep IB Poisson
clustersub('kramer_IB_deltapaper_scripts2','7a2',9,myhours);        % As 7a,  but with longer run time, higher downsampling
clustersub('kramer_IB_deltapaper_scripts2','7b',8,myhours);         % Block gamma input; sweep IB Poisson 40 Hz
clustersub('kramer_IB_deltapaper_scripts2','7c',8,myhours);         % Block Poisson input; sweep FS gamma

% Vary synaptic input strengths for a single long-duration stimulus (as in
% Fig 1a). 
clustersub('kramer_IB_deltapaper_scripts2','8a',8,myhours);         % block gamma input; sweep IB Poisson (use this one for paper, since pure tone)
clustersub('kramer_IB_deltapaper_scripts2','8a_shuffle',16,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8b',8,myhours);         % block gamma input; sweep IB Poisson 40 Hz
clustersub('kramer_IB_deltapaper_scripts2','8c',8,myhours);         % Poisson input, sweep gamma dFS->IB
clustersub('kramer_IB_deltapaper_scripts2','8c_shuffle',16,myhours);
% clustersub('kramer_IB_deltapaper_scripts2','8d',16,myhours);      % Sweep both IB Poisson and gamma input strength (not used)


clustersub('kramer_IB_deltapaper_scripts2','10a',16,myhours);     % Vary AP delay figure

clustersub('kramer_IB_deltapaper_scripts2','9a',16,myhours);     % Polley figure defualt
% clustersub('kramer_IB_deltapaper_scripts2','9b',6,myhours);   % Lakatos version
clustersub('kramer_IB_deltapaper_scripts2','9c1',8,myhours);   % Sweep timing
clustersub('kramer_IB_deltapaper_scripts2','9c1_shuffle',28,myhours);   % Sweep timing
clustersub('kramer_IB_deltapaper_scripts2','9c2',8,myhours);   % Sweep timing with AR block
clustersub('kramer_IB_deltapaper_scripts2','9c3',8,myhours);   % Sweep timing with M block
clustersub('kramer_IB_deltapaper_scripts2','9c4',8,myhours);   % Sweep timing with NMDA block
clustersub('kramer_IB_deltapaper_scripts2','9d',8,myhours);     % Polley fig 10 ms
clustersub('kramer_IB_deltapaper_scripts2','9e',8,myhours);     % Polley fig 20 ms
clustersub('kramer_IB_deltapaper_scripts2','9f',8,myhours);     % Polley fig 100 ms
clustersub('kramer_IB_deltapaper_scripts2','9g',8,myhours);     % Polley fig 200 ms
clustersub('kramer_IB_deltapaper_scripts2','9h',8,myhours);     % Polley defualt block h-current
clustersub('kramer_IB_deltapaper_scripts2','9i',8,myhours);     % Polley default block m-current
clustersub('kramer_IB_deltapaper_scripts2','9j',8,myhours);     % Polley fig 10 ms block h-current
clustersub('kramer_IB_deltapaper_scripts2','9k',8,myhours);     % Polley fig 20 ms block h-current
clustersub('kramer_IB_deltapaper_scripts2','9l',8,myhours);     % Polley fig 100 ms block h-current
clustersub('kramer_IB_deltapaper_scripts2','9m',8,myhours);     % Polley fig 200 ms block h-current


%% Supplemental figures
clustersub('kramer_IB_deltapaper_scripts2','8e',8,myhours);     % As 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8f',8,myhours);     % As 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8g',8,myhours);     % As 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8h',8,myhours);     % As 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8i',8,myhours);     % As 8c - except non-zero IB PPStim

% Block NMDA (for spontaneous activity)
clustersub('kramer_IB_deltapaper_scripts2','1c2',1,myhours);

% Block NMDA (for click train, no AP)
clustersub('kramer_IB_deltapaper_scripts2','1a3',1,myhours);

% Block L2/3 -> L5 connections
clustersub('kramer_IB_deltapaper_scripts2','1a2',1,myhours);

% Block L5 <-> L2/3 connections spontaneous
clustersub('kramer_IB_deltapaper_scripts2','1c3',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1c4',1,myhours);

% Figures for detailing operation of delta oscillator
clustersub('kramer_IB_deltapaper_scripts2','11a',1,myhours);    % Only IB cells, unconnected
clustersub('kramer_IB_deltapaper_scripts2','11b',1,myhours);    % Only IB cells, connected
clustersub('kramer_IB_deltapaper_scripts2','11c',1,myhours);    % Only IB and NG cells, connected

% Sweep M-current in delta oscillator
clustersub('kramer_IB_deltapaper_scripts2','11d',8,myhours);    % Only IB cells, connected
clustersub('kramer_IB_deltapaper_scripts2','11e',8,myhours);    % Only IB and NG cells, connected


% Characterize IB burstiness vs gM and gCa. Delta oscillator only
clustersub('kramer_IB_deltapaper_scripts2','12a',8,myhours);    % Default gM and gCa
clustersub('kramer_IB_deltapaper_scripts2','12b',8,myhours);    % High gM and gCa
clustersub('kramer_IB_deltapaper_scripts2','12c',8,myhours);    % Low gM and gCa

%% Delta training figures

myhours = 1;        % By default codes adds 30 minutes wall time. Definitely shoudln't take longer than 30 minutes!
numcores = 8;

% Basic sims
clustersub('kramer_IB_deltapaper_tune1','0a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','0b',numcores,myhours);

% 4D Sweeps
clustersub('kramer_IB_deltapaper_tune1','20',16,myhours);
clustersub('kramer_IB_deltapaper_tune1','21',16,myhours);


myhours = 1;        % By default codes adds 30 minutes wall time. Definitely shoudln't take longer than 30 minutes!
numcores = 8;
clustersub('kramer_IB_deltapaper_tune1','1a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1b',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2b',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1c',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2c',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1d',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2d',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1e',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2e',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1f',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2f',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1g',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2g',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1c',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1c2',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1d',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','4a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','9b',numcores,myhours);

% Supplementary - sweep PPFreq
clustersub('kramer_IB_deltapaper_tune1','1b1_32Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2_32Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1_26Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2_26Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1_21Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2_21Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1_17Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2_17Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1_14Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2_14Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1_11Hz',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2_11Hz',numcores,myhours);



%% Supp figs paper3

clustersub('kramer_IB_deltapaper_scripts2','1b1_30Hz',1,myhours);        % Click train with AP pulse
clustersub('kramer_IB_deltapaper_scripts2','1b2_30Hz',1,myhours);        % As 1b1, but only superficial oscillator



%% Job progress
!qstat -u stanleyd
clc; !cat cluster_*.o.*
clc; !cat cluster_*.e.*

! qstat  | grep " r " | wc -l
! qstat  | grep " qw " | wc -l


%% List temp output files progress
clc
!ls -la localOutput
!ls -la matlab_multi_node_batch.sh.*
!ls -la cluster_*




%% Delete all jobs
!qdel -u stanleyd


%% Delete study dirs
! rm -rf study_d18*
! rm -rf study_d19*
! rm -rf study_d20*

%% Remove temp output files
!rm localOutput 
!rm matlab_multi_node_batch.sh.*
!rm cluster_*.o.*
!rm cluster_*.e.*

