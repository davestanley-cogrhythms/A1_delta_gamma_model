

%% Delta paper figures

myhours = 4;        % By default codes adds 30 minutes wall time. Definitely shoudln't take longer than 30 minutes!


clustersub('kramer_IB_deltapaper_scripts2','1a1',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1b1',1,myhours);        % Click train with AP pulse
clustersub('kramer_IB_deltapaper_scripts2','1b2',1,myhours);        % As 1b1, but only superficial oscillator
clustersub('kramer_IB_deltapaper_scripts2','1c1',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1d',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1ac',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1dc',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1a4',1,myhours);        % Core input only
clustersub('kramer_IB_deltapaper_scripts2','1a5',1,myhours);        % Matrix input only

clustersub('kramer_IB_deltapaper_scripts2','3a',8,myhours);        % Sweep low frequency
clustersub('kramer_IB_deltapaper_scripts2','3a2',8,myhours);        % Sweep low frequencies only superficial oscillator
clustersub('kramer_IB_deltapaper_scripts2','3b',6,myhours);        % Sweep high frequency
clustersub('kramer_IB_deltapaper_scripts2','3b2',6,myhours);        % Sweep highf requency only superficial oscillator

clustersub('kramer_IB_deltapaper_scripts2','4a',8,myhours);         % Lakatos 2005 figure
clustersub('kramer_IB_deltapaper_scripts2','4a2',13,myhours);        % Lakatos 2005 figure with longer run time, higher downsampling

clustersub('kramer_IB_deltapaper_scripts2','5a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','5b',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','5c',8,myhours);

clustersub('kramer_IB_deltapaper_scripts2','6a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','6b',8,myhours);

clustersub('kramer_IB_deltapaper_scripts2','7a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','7a2',9,myhours);        % As 7a,  but with longer run time, higher downsampling
clustersub('kramer_IB_deltapaper_scripts2','7b',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','7c',8,myhours);

clustersub('kramer_IB_deltapaper_scripts2','8a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8b',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8c',8,myhours);
% clustersub('kramer_IB_deltapaper_scripts2','8d',16,myhours);

clustersub('kramer_IB_deltapaper_scripts2','9a',8,myhours);     % Polley figure defualt
% clustersub('kramer_IB_deltapaper_scripts2','9b',6,myhours);   % Lakatos version
clustersub('kramer_IB_deltapaper_scripts2','9c1',8,myhours);   % Sweep timing
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
clustersub('kramer_IB_deltapaper_scripts2','8e',8,myhours);     % As paper 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8f',8,myhours);     % As paper 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8g',8,myhours);     % As paper 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8h',8,myhours);     % As paper 8a, except different gFS5 -> IB conductance
clustersub('kramer_IB_deltapaper_scripts2','8i',8,myhours);     % As paper 8c - except non-zero IB PPStim

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
numcores = 4;
clustersub('kramer_IB_deltapaper_tune1','1a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b1',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b2',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1c',numcores,myhours);
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


%% Job progress
!qstat -u stanleyd
clc; !cat cluster_*.o.*
clc; !cat cluster_*.e.*

%% List temp output files progress
clc
!ls -la localOutput
!ls -la matlab_multi_node_batch.sh.*
!ls -la cluster_*




%% Delete all jobs
!qdel -u stanleyd


%% Delete study dirs
! rm -rf study_d18*


%% Remove temp output files
!rm localOutput 
!rm matlab_multi_node_batch.sh.*
!rm cluster_*.o.*
!rm cluster_*.e.*

