function run_STP_simulations

data_name = {'18-12-21/kramer_IB_13_46_54.96';...
    '19-07-19/kramer_IB_1_41_36.13';... % '18-12-18/kramer_IB_16_3_5.302';...
    '19-07-29/kramer_IB_15_5_45.59';... % '18-10-30/kramer_IB_21_32_17.93';... % '18-12-14/kramer_IB_15_23_16.83';...
    '19-07-30/kramer_IB_13_37_2.42';... 19-07-19/kramer_IB_16_50_25.92';... % 
    '19-01-07/kramer_IB_21_18_58.89';...
    % '19-01-04/kramer_IB_16_24_21.91';...
    }; % {'19-07-29/kramer_IB_15_5_45.59'}; % {'19-07-29/kramer_IB_14_53_1.01'}; % {'19-07-19/kramer_IB_16_50_25.92'};
% {'19-07-18/kramer_IB_16_23_57.85'}; % {'18-10-30/kramer_IB_21_17_9.546', '18-10-30/kramer_IB_21_32_17.93'}; 
% {'19-01-24/kramer_IB_17_6_31.38', '19-01-30/kramer_IB_11_20_58.05',...
%     '19-02-07/kramer_IB_14_54_48.77', '19-01-30/kramer_IB_17_6_54.67',...
%     '19-02-27/kramer_IB_15_27_0.6538'};

model_names = {'M', 'I', 'IC', 'MC', 'MIC'};

cd /projectnb/crc-nak/brpp/model-dnsim-kramer_IB/kramer_IB/Figs_Ben; model_vary = get_model_vary(data_name); cd ..;

include_deepFS = [0 1 1 1 0];

% simulation_vary = {'deepRS', 'mechanism_list', '+iFMPulses';...
%     'deepRS', '(FMPlowfreq, FMPhighfreq)', [.5:.5:6.5; fliplr(7.5:.5:13.5)];
%     'deepRS', 'FMPstim', [0 -.75:-.25:-2.5];...
%     'deepRS', 'PPstim', 0;...
%     };

simulation_vary = {'deepRS', 'mechanism_list', '+iSpikeTriggeredPulse';...
        'deepRS', 'STPstim', 0:-100:-1000;...
        'deepRS', 'STPshift', 0;...
        'deepRS', 'STPkernelType', 25;...
        'deepRS', 'STPonset', 2000;...
        'deepRS', 'STPwidth', 50;...
        'deepRS', 'PPstim', 0;...
        'deepRS', 'FMPstim', 0;...
        % 'deepRS', 'Inoise', .25;...
        };
    

names = cell(length(data_name), 1);

Today = datestr(datenum(date),'yy-mm-dd');

Now = clock;

for m = 1:length(model_vary)
    
    vary = [flip_synapses(model_vary{m}); simulation_vary];
    
    if m == 2
        
        vary = set_vary_field(vary, 'STPonset', 5000)
    
    else 
       
        vary
        
    end
    
    sim_struct = init_sim_struct('vary', vary, 'include_deepRS', 1, 'solver', 'euler',...
        'include_deepFS', include_deepFS(m), 'tspan', [0 6000],...
        'cluster_flag', 0, 'parallel_flag', 1, 'save_data_flag', 1, 'sim_mode', 3,...
        'note', ['Parsing (frequency-modulated input) simulations for model ', model_names{m}],...
        'parent', data_name{m});
    
    [~, names{m}] = kramer_IB_function_mode(sim_struct);

end

sim_name = sprintf('STP_%s_%d', Today, Now(4));

save(['Figs_Ben/', Today, '/', sim_name, '.mat'], 'sim_name', 'names')

end

function vary = flip_synapses(vary)

FStoRS = strcmp(vary(:, 1), 'deepFS->deepRS');

RStoFS = strcmp(vary(:, 1), 'deepRS->deepFS');

vary(FStoRS, 1) = {'deepRS->deepFS'};

vary(RStoFS, 1) = {'deepFS->deepRS'};

end