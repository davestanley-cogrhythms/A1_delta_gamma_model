function [data, name, sim_spec, result] = kramer_IB_function_mode(sim_struct)

if nargin < 1; sim_struct = []; end
if isempty(sim_struct); sim_struct = struct; end

Today = datestr(datenum(date),'yy-mm-dd');
% mkdir(Today);

start_dir = pwd;
kramer_IB_dir
% if exist('project_folder', 'var')
%     cd (project_folder)
% elseif exist('research_folder', 'var')
%     cd (research_folder)
% end

savepath = fullfile(pwd, 'Figs_Ben', Today);
mkdir(savepath);

Now = clock;
name = sprintf('kramer_IB_%g_%g_%.4g', Now(4), Now(5), Now(6));

function_mode = 1;

kramer_IB

unpack_sim_struct
% vars_pull(sim_struct);

include_kramer_IB_populations;

include_kramer_IB_synapses;

save(fullfile(savepath, [name, '_sim_spec.mat']), 'sim_spec', 'sim_struct', 'vary', 'name');

solver

if cluster_flag
    
    data = dsSimulate(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'cluster_flag',cluster_flag,...
        'debug_flag',debug_flag,'compile_flag',compile_flag,...
        'analysis_functions',analysis_functions,'analysis_options',analysis_options,...
        'overwrite_flag',1,'one_solve_file_flag',1,'qsub_mode',qsub_mode,...
        'save_data_flag',1,'study_dir',fullfile(savepath, name));
    
    cd (start_dir)
    
    return

else
    
    tic;
    
    data = dsSimulate(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,... % [data, ~, result]
        'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'parallel_flag',parallel_flag,'num_cores',num_cores,...
        'debug_flag',debug_flag,'compile_flag',compile_flag,...
        'analysis_functions',analysis_functions,'analysis_options',analysis_options,...
        'save_data_flag',0,'study_dir',fullfile(savepath, name));
    
    toc;
        
end

close('all')

dsPlot(data)

figHandles = findobj('Type', 'Figure');

for f = 1:length(figHandles)

    save_as_pdf(figHandles(f), fullfile(savepath, [name, '_', num2str(f)]))
    
end

cd (start_dir)

end