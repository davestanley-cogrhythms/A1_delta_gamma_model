function run_supp_fig_2

data_name = {%'19-12-11/kramer_IB_22_16_54.07';...
    '19-12-12/kramer_IB_13_1_56.61';...
    '19-12-12/kramer_IB_13_3_35.33';...
    '19-12-12/kramer_IB_13_5_11.52';...
    '19-12-12/kramer_IB_13_16_24.98';...
    };

cd /projectnb/crc-nak/brpp/model-dnsim-kramer_IB/kramer_IB/Figs_Ben;
model_vary = get_model_vary(data_name);
cd ..;

simulation_vary = {
    'deepRS', 'PPstim', 0:-.2:-4;...
    'deepRS', 'PPfreq', [0.25 .5:.5:23];
    'deepRS', 'PPduty', 0.25;...
    'deepRS', 'kernel_type', 25;...
    'deepRS', 'PPnorm', 0;...
    };

names = cell(length(data_name), 1);

Today = datestr(datenum(date),'yy-mm-dd');

Now = clock;



multipliers = [.333 .667 .75 1.25]; % 3]; %[.5];
Iapp_vec = [-12.6 -7.2 -7.8 -7.05]; %[-6.25];
gleak = [.78 .27 .27 0 0];

for d = 1:length(data_name)
    
    vary = set_vary_field(model_vary{d}, 'I_app', Iapp_vec(d));
    
    vary = [vary; simulation_vary]
    
    sim_struct = init_sim_struct('vary', vary, 'include_deepRS', 1,...
        'include_deepFS', 1, 'tspan', [0 30000],...
        'cluster_flag', 1, 'parallel_flag', 0, 'save_data_flag', 1, 'sim_mode', 3,...
        'note', ['PLV simulations for MIS w/ inhibitory conductance multiplied by a factor of ',...
            num2str(multipliers(d)), ' w/ I_app=', num2str(Iapp_vec(d))],...
        'parent', data_name{d});
    
    [~, names{d}] = kramer_IB_function_mode(sim_struct);

end

sim_name = sprintf('supp_fig_2_PLV_%s_%d', Today, Now(4));

save(['Figs_Ben/', Today, '/', sim_name, '.mat'], 'sim_name', 'names')