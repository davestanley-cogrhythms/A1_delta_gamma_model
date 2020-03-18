function run_supp_fig_1_FI

data_name = {
    '19-01-07/kramer_IB_21_18_58.89';...
    };

cd /projectnb/crc-nak/brpp/model-dnsim-kramer_IB/kramer_IB/Figs_Ben; model_vary = get_model_vary(data_name); cd ..;

names = cell(length(data_name), 1);

Today = datestr(datenum(date),'yy-mm-dd');

Now = clock;

Iapp=-7.5:-.25:-9.5;

simulation_vary = {
    'deepRS', 'PPstim', 0:-.4:-4;...
    'deepRS', 'PPfreq', [0.25 .5 1:23];
    'deepRS', 'PPduty', 0.25;...
    'deepRS', 'kernel_type', 25;...
    'deepRS', 'PPnorm', 0;...
    'deepRS', 'FMPstim', 0;...
    'deepRS', 'STPstim', 0;...
    };

for i = 1:length(Iapp)
    
    vary = set_vary_field(model_vary{1}, 'I_app', Iapp(i));
    
    vary = [vary; simulation_vary]
    
    sim_struct = init_sim_struct('vary', vary, 'include_deepRS', 1,...
        'include_deepFS', 1, 'tspan', [0 6000],...
        'cluster_flag', 1, 'parallel_flag', 0, 'save_data_flag', 1, 'sim_mode', 3,...
        'note', ['PLV simulations for model MS with I_app set at ', num2str(Iapp(i)), '.'],...
        'parent', data_name{1});
    
    [~, names{i}] = kramer_IB_function_mode(sim_struct);

end

sim_name = sprintf('supp_fig_1_%s_%d', Today, Now(4));

save(['Figs_Ben/', Today, '/', sim_name, '.mat'], 'sim_name', 'names')