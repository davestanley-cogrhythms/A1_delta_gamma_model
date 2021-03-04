function plot_PLV_traces(data_info_file, stim_value)

if nargin < 2, stim_value = []; end

if nargin < 1, data_info_file = []; end

if isempty(data_info_file)

    data_name = {'11_12_38.06', '11_13_44.43', '11_15_9.333', '11_16_25.31', '11_17_38.36'}; % {'17_30_29.7', '17_31_2.912', '17_31_48.55', '17_32_43.9', '17_33_34.26'};
    
    data_hour = data_name{1}(1:2);
    
    data_name = cellfun(@(x) ['kramer_IB_', x], data_name, 'unif', 0);
    
    data_date = '19-07-10'; % '19-06-21';
    
    plot_name = [data_date, '/PLV_sims_', data_date, '_', data_hour];
    
else
    
    data_info = load(data_info_file);
    
    data_name = data_info.names;
    
    data_date = data_info.sim_name; data_date = data_date(10:17);
    
    plot_name = [data_date, '/', data_info_file(1:(end - 4))];
    
end
    
if ~contains(pwd, 'Figs_Ben'), cd 'Figs_Ben', end

if ~contains(pwd, data_date), cd (data_date), end

model_labels = {'M', 'MI', 'I', 'IS', 'MS', 'MIS'};

for d = 1:length(data_name)
    
    name = data_name{d};
    
    sim_struct = load([name, '_sim_spec.mat']);
    
    % freqs = get_vary_field(sim_struct.vary, 'PPfreq');
    
    stims = get_vary_field(sim_struct.vary, 'PPstim'); % 'FMPstim');
    
    data = dsImport(sim_struct.name);
    
    stim = [data.deepRS_PPstim]; % FMPstim];
    
    if isempty(stim_value), stim_value = min(stims); end
    
    selected = stim == stim_value;
    
    subplot(length(data_name), 1, d)
    
    time = data(selected).time/10^3 - 10;
    
    [ax, h1, h2] = plotyy(time, data(selected).deepRS_V, time, data(selected).deepRS_iPeriodicPulsesBen_input);
    
%     if d == length(data_name)
        
        set(ax, 'YTick', [])
        
        axis(ax, 'tight')
        
        xlim(ax, [1 3])
        
%     else
%         
%         xlim(ax, [1 2])
%         
%         set(ax, 'YTick', [], 'XTick', [])
%         
%     end
    
    box off
    
    set(h1, 'Color', 'k', 'LineWidth', 2)
    
    set(h2, 'Color', 'r', 'LineWidth', 2)
    
    ylabel(model_labels{d})
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 4 4], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 4 4])
    
save_as_pdf(gcf, [data_info_file(1:(end - 4)), '_stim_', num2str(stim_value)])