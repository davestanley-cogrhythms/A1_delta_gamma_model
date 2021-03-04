function plot_parsing_simulations(data_info_file, stim_value)

if nargin < 2, stim_value = []; end

if nargin < 1, data_info_file = []; end

if isempty(data_info_file)

    data_name = {'11_12_38.06', '11_13_44.43', '11_15_9.333', '11_16_25.31', '11_17_38.36'}; % {'17_30_29.7', '17_31_2.912', '17_31_48.55', '17_32_43.9', '17_33_34.26'};
    
    data_hour = data_name{1}(1:2);
    
    data_name = cellfun(@(x) ['kramer_IB_', x], data_name, 'unif', 0);
    
    data_date = '19-07-10'; % '19-06-21';
    
    plot_name = [data_date, '/parsing_', data_date, '_', data_hour];
    
else
    
    data_info = load(data_info_file);
    
    data_name = data_info.names;
    
    data_date = data_info.sim_name; data_date = data_date(9:16);
    
    plot_name = [data_date, '/', data_info_file(1:(end - 4))];
    
end
    
if ~contains(pwd, 'Figs_Ben'), cd 'Figs_Ben', end

if ~contains(pwd, data_date), cd (data_date), end

model_labels = {'M', 'I', 'IC', 'MC', 'MIC'};

for d = 1:length(data_name)
    
    name = data_name{d};
    
    sim_struct = load([name, '_sim_spec.mat']);
    
    band_limits = get_vary_field(sim_struct.vary, '(VPlowfreq, VPhighfreq'); % '(FMPlowfreq, FMPhighfreq)');
    band_width = diff(band_limits);
    
    stims = get_vary_field(sim_struct.vary, 'VPstim'); % 'FMPstim');
    
    data = dsImport(sim_struct.name);
    
    stim = [data.deepRS_VPstim]; % FMPstim];
    
    if isempty(stim_value), stim_value = min(stims); end
    
    selection = stim == stim_value;
    
    plot_2_vars(data(selection), 'deepRS_V', 'deepRS_iVariedPulses_input') % 'deepRS_iFMPulses_input')
    
    mtit(model_labels{d})
    
    saveas(gcf, [name, '_stim_', num2str(stim_value), '.fig'])
    
    plot_2_vars(data(selection), 'deepRS_V', 'deepRS_iVariedPulses_input', '', [10 11]*10^4) % 'deepRS_iFMPulses_input', '', [10 11]*10^4)
    
    mtit(model_labels{d})
    
    save_as_pdf(gcf, [name, '_stim_', num2str(stim_value)])
    
end