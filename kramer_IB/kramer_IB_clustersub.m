

%% Delta paper figures

myhours = 2;        % By default codes adds 30 minutes wall time. Definitely shoudln't take longer than 30 minutes!


clustersub('kramer_IB_deltapaper_scripts2','1a1',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1b',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1c1',1,myhours);

clustersub('kramer_IB_deltapaper_scripts2','3a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','3b',4,myhours);

clustersub('kramer_IB_deltapaper_scripts2','4a',8,myhours);

clustersub('kramer_IB_deltapaper_scripts2','5a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','5b',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','5c',8,myhours);

clustersub('kramer_IB_deltapaper_scripts2','6a',12,myhours);

clustersub('kramer_IB_deltapaper_scripts2','7a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','7b',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','7c',8,myhours);

clustersub('kramer_IB_deltapaper_scripts2','8a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8b',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8c',8,myhours);
% clustersub('kramer_IB_deltapaper_scripts2','8d',16,myhours);

clustersub('kramer_IB_deltapaper_scripts2','9a',16,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9b',6,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9c1',12,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9c2',12,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9d',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9e',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9f',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9g',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9h',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','9i',8,myhours);

%% Supplemental figures
clustersub('kramer_IB_deltapaper_scripts2','8e',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8f',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8g',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8h',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','8i',8,myhours);

% Block NMDA
clustersub('kramer_IB_deltapaper_scripts2','1c2',1,myhours);

% Block L2/3 -> L5 connections
clustersub('kramer_IB_deltapaper_scripts2','1a2',1,myhours);

% Block L5 -> L2/3 connections
clustersub('kramer_IB_deltapaper_scripts2','1c3',1,myhours);

% Figures for detailing operation of delta oscillator
clustersub('kramer_IB_deltapaper_scripts2','11a',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','11b',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','11c',1,myhours);


%% Delta training figures

myhours = 1;        % By default codes adds 30 minutes wall time. Definitely shoudln't take longer than 30 minutes!
numcores = 6;
clustersub('kramer_IB_deltapaper_tune1','1a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1b',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1c',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','1d',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','4a',numcores,myhours);
clustersub('kramer_IB_deltapaper_tune1','9b',numcores,myhours);

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
! rm -rf study_d17*


%% Remove temp output files
!rm localOutput 
!rm matlab_multi_node_batch.sh.*
!rm cluster_*.o.*
!rm cluster_*.e.*

