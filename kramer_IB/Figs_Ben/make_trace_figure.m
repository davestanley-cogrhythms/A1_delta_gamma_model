function make_trace_figure(data_info_file)

if nargin < 1, data_info_file = []; end

figure

stim_indices = [1 8];
time_window = [0 1]-.2;

if isempty(data_info_file)
    
    data_names = {'19-08-09/kramer_IB_10_50_34.76',...
        '19-12-03/kramer_IB_13_50_43.03',...
        '19-08-09/kramer_IB_10_53_29.11',...
        '19-08-09/kramer_IB_10_56_34.72',...
        '19-08-09/kramer_IB_10_58_32.43',...
        '19-08-09/kramer_IB_11_0_33.83'};
%     {'19-01-24/kramer_IB_17_6_31.38',...
%         '19-01-30/kramer_IB_11_20_58.05',...
%         '19-02-07/kramer_IB_14_54_48.77',...
%         '19-01-30/kramer_IB_17_6_54.67',...
%         '19-02-27/kramer_IB_15_27_0.6538'}; % '19-02-07/kramer_IB_17_41_33.11', % '19-01-24/kramer_IB_16_36_3.746'};

else
    
    data_info = load(data_info_file);
    
    data_names = data_info.names;
    
    if ~isfield(data_info, 'data_dates')
    
        data_date = data_info.sim_name; data_date = data_date(5:12);
   
        data_dates = cell(size(data_names));

        [data_dates{:}] = deal(data_date);
        
    else
        
        data_dates = data_info.data_dates;
        
        data_date = datestr(datenum(date),'yy-mm-dd');
        
    end
    
    data_names = cellfun(@(x, y) [x, '/', y], data_dates, data_names, 'unif', 0);
        
end

data_field = {'deepRS_iKs_n', 'deepRS_deepFS_IBaIBdbiSYNseed_s', 'deepRS_iKCaT_q'};

fields_plotted = {1, [2 1], 2, [3 2], [3 2 1], [3 1]}; % [3 1], [3 2 1]}; % {'deepRS_iKs_n', 'deepRS_iKCaT_q'}, {'deepRS_deepFS_IBaIBdbiSYNseed_s', 'deepRS_iKCaT_q'}};

% time_offset = [1.580 4.550 1.585 1.550 1.66] + .2; % 1.610 1.66] + .2; % 1.67];

ylabel_left = {'M', 'MI', 'I', 'IC', 'MIC', 'MC'}; % {'M Only', {'Inhibition'; 'Only'}, {'Inhibition &'; 'Ca-activated K'}, {'Ca-activated K'; '& M'}, 'All Mechanisms'};

color = [0 0 1; .9 0 .9; 0 .75 0];
    
for p = 1:length(data_names)
    
    data = dsImport(data_names{p});
    
    time = data(1).time/1000;
    
    Iapp_vec(p) = data.deepRS_I_app;
    
    STP = data.deepRS_iSpikeTriggeredPulse_input;
    
    pulse_index = find(diff(STP>0)==1);
    pulse_time = time(pulse_index);
    time = time - pulse_time;
    
    % stim_indices = [1 8];
    time_indices = time_window; % time_offset(p) + time_window;
    
    subplot(length(data_names), 1, p)
    
    [ax, h1, h2] = plotyy(time, [data(stim_indices).deepRS_V],... [data(stim_indices(1)).deepRS_V data(stim_indices(2)).deepRS_V],...
        time, [data(stim_indices).(data_field{fields_plotted{p}(1)})]); % [data(stim_indices(1)).(data_field{fields_plotted{p}(1)}) data(stim_indices(2)).(data_field{fields_plotted{p}(1)})]);
    
    axis(ax, 'tight')
    set(ax, 'FontSize', 12)
    
    hold(ax(1), 'on')
    
    spike_times = time(logical(data(stim_indices(2)).deepRS_V_spikes));
    
    first_spike_time = spike_times(find(spike_times > .1, 1)); % time_offset(p) + .35, 1));
    
    plot(ax(1), first_spike_time, max([data(stim_indices(2)).deepRS_V]), 'rp', 'MarkerSize', 10)
    
    plot(ax(1), time(STP>0), min([data(stim_indices(2)).deepRS_V])*ones(size(time(STP>0))), 'r', 'LineWidth', 2)
    
    xlim(ax, time_indices)
    
    if fields_plotted{p}(1) == 3, ylim(ax(2), [.5 1]), end
    
    ylabel(ax(1), ylabel_left{p})
    
    set(h1, 'LineWidth', 2, 'Color', 'k')
    set(h1(1), 'LineStyle', ':')
    
    if p == 2, legend(h1, {'No Input Pulse'; 'Input Pulse'}, 'Location', 'SouthEast'), end
    
    set(h2, 'LineWidth', 2, 'Color', color(fields_plotted{p}(1), :))
    set(h2(1), 'LineStyle', ':')
    
    if p == 1, legend_handles(p) = h1(2); end
    
    legend_handles(fields_plotted{p}(1)+1) = h2(2);
    
    box off
    
    if length(fields_plotted{p}) > 1
        
        hold(ax(2), 'on')
        
        for i = 2:length(fields_plotted{p})
            
            new_ax = axes('Position', get(ax(2), 'Position')); 
            set(new_ax, 'FontSize', 12);
        
            h = plot(new_ax, time, [data(stim_indices(1)).(data_field{fields_plotted{p}(i)}),...
                data(stim_indices(2)).(data_field{fields_plotted{p}(i)})]);
    
            axis(new_ax, 'tight')
            % set(new_ax, 'FontSize', 12)
            
            xlim(new_ax, time_indices)
            
            set(new_ax, 'Visible', 'off')
            
            set(h, 'LineWidth', 2, 'Color', color(fields_plotted{p}(i), :))
            set(h(1), 'LineStyle', ':')
            
        end
        
    end
    
end

stim_label = make_label('STPstim', [data(stim_indices).deepRS_STPstim], []);

legend(legend_handles, {'Voltage'; 'M activation '; 'Synaptic activation'; 'Ca-activated K activation'}, 'Location', 'NorthEast')

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 6 6], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 6 6])

saveas(gcf, ['trace_figure_w_MI', stim_label, '.fig'])

end