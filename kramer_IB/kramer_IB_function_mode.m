function [data, name] = kramer_IB_function_mode(sim_struct)

Today = datestr(datenum(date),'yy-mm-dd');

mkdir(Today)

function_mode = 1;

kramer_IB

unpack_sim_struct

include_kramer_IB_populations;

include_kramer_IB_synapses;

Now = clock;

name = [Today, '/kramer_IB_%g_%g_%.4g', Now(4), Now(5), Now(6)];

if cluster_flag
    
    data = SimulateModel(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'cluster_flag',1,'overwrite_flag',1,...
        'save_data_flag',1,'study_dir',name);

else
    
    data=SimulateModel(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'parallel_flag',parallel_flag,...
        'compile_flag',compile_flag,'save_data_flag',save_data_flag,'study_dir',name);

end

PlotData(data)

save_as_pdf(gcf, name)

save([name, '_sim_struct.mat'], 'sim_struct')