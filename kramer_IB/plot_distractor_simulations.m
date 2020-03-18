function plot_distractor_simulations

data_name = {'17_30_27.67', '17_31_31.24', '17_32_30.89', '17_33_33.04', '17_34_35.89'}; % {'15_31_23.47', '15_31_55.62', '15_32_38.32', '15_33_19.94', '15_34_1.601'};

data_date = '19-06-27'; % '19-06-21';

model_labels = {'M', 'I', 'IC', 'MC', 'MIC'};

for d = 1:length(data_name)
    
    name = ['kramer_IB_', data_name{d}];
    
    sim_struct = load([name, '_sim_spec.mat']);
    
    band_limits = get_vary_field(sim_struct.vary, 'PDfreq'); % '(FMDlowfreq, FMDhighfreq)');
    band_width = band_limits; % diff(band_limits);
    
    stims = get_vary_field(sim_struct.vary, 'PPstim'); % 'FMDstim');
    
    data = dsImport(sim_struct.name);
    
    stim = [data.deepRS_PPstim]; % deepRS_FMPstim];
    
    selection = stim == min(stims);
    
    plot_2_vars(data(selection), 'deepRS_V', 'deepRS_iPeriodicDistractors_input') % 'deepRS_iFMDistractors_input')
    
    mtit(model_labels{d})
    
    saveas(gcf, [name, '_stim_', num2str(min(stims)), '.fig'])
    
    plot_2_vars(data(selection), 'deepRS_V', 'deepRS_iPeriodicDistractors_input', '', [10 11]*10^4) % iFMDistractors_input', '', [10 11]*10^4)
    
    mtit(model_labels{d})
    
    save_as_pdf(gcf, [name, '_stim_', num2str(min(stims))])
    
end