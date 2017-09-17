

%% Submit jobs

myhours = 0;        % By default codes adds 30 minutes wall time. Definitely shoudln't take longer than 30 minutes!


clustersub('kramer_IB_deltapaper_scripts2','1a',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1b',1,myhours);
clustersub('kramer_IB_deltapaper_scripts2','1c',1,myhours);

clustersub('kramer_IB_deltapaper_scripts2','3a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','3b',4,myhours);
clustersub('kramer_IB_deltapaper_scripts2','3c',8,myhours);

clustersub('kramer_IB_deltapaper_scripts2','4a',6,myhours);



clustersub('kramer_IB_deltapaper_scripts2','5a',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','5b',8,myhours);
clustersub('kramer_IB_deltapaper_scripts2','5c',8,myhours);

%% Job progress
!qstat -u stanleyd
clc; !cat localOutput
clc; !cat matlab_multi_node_batch.sh.*


%% List temp output files progress
clc
!ls -la localOutput
!ls -la matlab_multi_node_batch.sh.*



%% Delete all jobs
!qdel -u stanleyd


%% Delete study dirs
! rm -rf study_d17*


%% Remove temp output files
!rm localOutput 
!rm matlab_multi_node_batch.sh.*


