function [data, name] = kramer_IB_function_mode(sim_struct)

if nargin < 1; sim_struct = []; end
if isempty(sim_struct); sim_struct = struct; end

Today = datestr(datenum(date),'yy-mm-dd');
mkdir(Today);

savepath = fullfile('Figs_Ben',Today);
mkdir(savepath);

function_mode = 1;

kramer_IB

unpack_sim_struct
% vars_pull(sim_struct);

include_kramer_IB_populations;

include_kramer_IB_synapses;

if cluster_flag
    
    data = SimulateModel(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'cluster_flag',1,'overwrite_flag',1,...
        'save_data_flag',1,'study_dir',name);
    
    return

else
    
    data=SimulateModel(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'parallel_flag',parallel_flag,...
        'compile_flag',compile_flag);

end

PlotData(data)

save_as_pdf(gcf, fullfile(savepath, name))

save(fullfile(Today, [name, '_sim_struct.mat']), 'sim_struct');

end