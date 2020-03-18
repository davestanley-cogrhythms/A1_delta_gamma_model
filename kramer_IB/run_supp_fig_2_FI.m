function run_supp_fig_2_FI

data_name = {
    '19-07-30/kramer_IB_13_37_2.42';... 
    };

cd /projectnb/crc-nak/brpp/model-dnsim-kramer_IB/kramer_IB/Figs_Ben; model_vary = get_model_vary(data_name); cd ..;

names = cell(length(data_name), 1);

Today = datestr(datenum(date),'yy-mm-dd');

Now = clock;

gKs = 1.4472;
gSYN = .2;

multipliers = [.25 .333 .667 .75 1.25 1.5 3];
Iapp_range = [20 20 20 20 40 40 40];
gleak = [.78 .78 .27 .27 0 0 0];

for m = 5:length(multipliers)
    
    vary = set_vary_field(model_vary{1}, {'deepRS', 'gKs'}, gKs*multipliers(m));
    
    vary = set_vary_field(vary, {'deepRS->deepFS','g_SYN'}, gSYN*multipliers(m));
    
    vary = set_vary_field(vary, 'I_app', 0:-(Iapp_range(m)/200):-Iapp_range(m));
    
    vary = set_vary_field(vary, 'gl', gleak(m));
    
    vary = set_vary_field(vary, {'deepRS', 'PPstim'}, 0)
    
    sim_struct = init_sim_struct('vary', vary, 'include_deepRS', 1,...
        'include_deepFS', 1, 'tspan', [0 6000],...
        'cluster_flag', 1, 'parallel_flag', 0, 'save_data_flag', 1, 'sim_mode', 3,...
        'note', ['FI simulations for model MIS with m- and inhibitory currents set at ', num2str(multipliers(m)), ' regular value.'],...
        'parent', data_name{1});
    
    [~, names{m}] = kramer_IB_function_mode(sim_struct);

end

sim_name = sprintf('supp_fig_2_FI_%s_%d', Today, Now(4));

save(['Figs_Ben/', Today, '/', sim_name, '.mat'], 'sim_name', 'names')