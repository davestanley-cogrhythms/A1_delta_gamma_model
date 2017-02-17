function kramer_IB_function_mode(sim_struct)

function_mode = 1;

kramer_IB

unpack_sim_struct

if sim_mode == 2

    data=SimulateModel(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',1,'cluster_flag',1,'overwrite_flag',1,...
        'save_data_flag',1,'study_dir','kramer_IB_sim_mode_2');

elseif sim_mode == 1
    
    data=SimulateModel(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,...
        'coder',0,'random_seed',random_seed,'vary',vary,'verbose_flag',0,'compile_flag',compile_flag);
    
else
    
    data=SimulateModel(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,...
        'coder',0,'random_seed',random_seed,'vary',vary,'verbose_flag',1,'parallel_flag',1,'compile_flag',compile_flag);
    
end

end