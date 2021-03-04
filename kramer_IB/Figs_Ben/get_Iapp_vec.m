function Iapp_vec = get_Iapp_vec(data_names, data_dates)

Iapp_vec = nan(1, length(data_names));

for p = 1:length(data_names)
    
    sim_spec = load([data_dates{p}, '/', data_names{p}, '_sim_spec.mat']);
    
    Iapp_vec(p) = get_vary_field(sim_spec.vary, 'I_app');
    
end