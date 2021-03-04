function run_supp_segmentation

data_name = {'19-12-11/kramer_IB_22_16_54.07';...
%     '19-12-12/kramer_IB_13_1_56.61';...
%     '19-12-12/kramer_IB_13_3_35.33';...
%     '19-12-12/kramer_IB_13_5_11.52';...
%     '19-12-12/kramer_IB_13_16_24.98';...
    };

cd /projectnb/crc-nak/brpp/model-dnsim-kramer_IB/kramer_IB/Figs_Ben;
model_vary = get_model_vary(data_name);
cd ..;

no_bands = 8;
cochlearBands = getCochlearBands(no_bands)';
cochlearBands = cochlearBands(:, 1:2:end);

simulation_vary = {%'deepRS', 'mechanism_list', '+iSpeechInput';...
    'deepRS', 'SentenceIndex', .025:.025:1;... .001:.001:1;... .2:.2:1;... [.5 1];... 
    'deepRS', 'gSpeech', [0 .5 1 2];... 0:2;... 0:.1:2;... 0.1:0.1:0.5;... 
    'deepRS', '(SpeechLowFreq, SpeechHighFreq)', cochlearBands;...
    'deepRS', 'SpeechNorm', 0;...
    };

names = cell(length(data_name), 1);

Today = datestr(datenum(date),'yy-mm-dd');

Now = clock;

multipliers = [.5]; % [.333 .667 .75 1.25]; % 3]; %
Iapp_vec = [-6.25]; % [-12.6 -7.2 -7.8 -7.05]; %
gleak = [.27]; % [.78 .27 .27 0]; % 0];

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

sim_name = sprintf('supp_fig_2_segmentation_%s_%d', Today, Now(4));

save(['Figs_Ben/', Today, '/', sim_name, '.mat'], 'sim_name', 'names')