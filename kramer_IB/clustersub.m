



function clustersub(filename,cellID,Ncores,myhours)

%% Set up IDs
if nargin < 1
    filename = 'kramer_IB_deltapaper_scripts2.m'; end
if nargin < 2
    cellID = '3a'; end
if nargin < 3
    Ncores = 8; end
if nargin < 4
    myhours = 2; end

% %% Create dummy cluster submission file
% ct = 'clustertemp.m';
% mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/','');
% c=clock;
% sp = ['d' mydate '_t' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];
% tempname = [sp '_' ct];
%
%
% fid = fopen(tempname,'w');
% fprintf(fid,['chosen_cell = ''' cellID ''';\n']);
% fprintf(fid,[filename ';\n']);
% fprintf(fid,['exit\n']);
% fclose(fid);


%% Submit job to cluster

% % % % % Get currrent date time string
mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/',''); c=clock;
sp = ['d' mydate '_t' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];

% mycommand= ['qsub -l h_rt=' num2str(myhours) ':30:00 ' ...      % Sim runtime
%     '-pe omp ' num2str(Ncores) ' -l cpu_arch=broadwell ' ...             % Number of cores
%     'matlab_multi_node_batch.sh "setup_paths_n_run(@' filename ',''' cellID ''')" localOutput'];

mycommand= ['qsub -l h_rt=' num2str(myhours) ':30:00 ' ...      % Sim runtime
    '-pe omp ' num2str(Ncores) ...                                      % Number of cores
    ' -l cpu_arch=broadwell ' ...             
    '-o cluster_' filename '_' cellID '.o.' sp ' '...                   % Output file
    '-e cluster_' filename '_' cellID '.e.' sp ' '...                   % Error file
    '-N job' cellID ' ' ...                                             % Job name
    'matlab_multi_node_batch.sh "setup_paths_n_run(@' filename ',''' cellID ''')"'];

system([mycommand]);
%'mem_total=95G'

% %% Delete all temp name files
%
% system(['rm *' ct]);

end
