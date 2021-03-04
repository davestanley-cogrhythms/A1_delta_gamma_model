function make_trace_figures(data_info_file)

if nargin < 1, data_info_file = []; end

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

Vfig = figure(); Afig = figure();

set(Vfig, 'Units', 'inches', 'Position', 1 + [0 0 6 6], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 6 6])

set(Afig, 'Units', 'inches', 'Position', 1 + [0 0 6 6], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 6 6])

%% For each simulation...
    
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
    
    %% Ploting voltage traces
    
    figure(Vfig)
    
    subplot(length(data_names), 1, p)
    
    h = plot(time, [data(stim_indices).deepRS_V]);
    
    axis(gca, 'tight')
    
    box off
    
    set(gca, 'FontSize', 12)
    
    hold(gca, 'on')
    
    spike_times = time(logical(data(stim_indices(2)).deepRS_V_spikes));
    
    first_spike_time = spike_times(find(spike_times > .1, 1)); % time_offset(p) + .35, 1));
    
    plot(gca, first_spike_time, max([data(stim_indices(2)).deepRS_V]), 'rp', 'MarkerSize', 10)
    
    plot(gca, time(STP>0), min([data(stim_indices(2)).deepRS_V])*ones(size(time(STP>0))), 'r', 'LineWidth', 2)
    
    xlim(gca, time_indices)
    
    ylabel(gca, ylabel_left{p})
    
    set(h, 'LineWidth', 2, 'Color', 'k')
    set(h(1), 'LineStyle', ':')
    
    if p == 1
        
        legend(h, {'No Input Pulse'; 'Input Pulse'}, 'Location', 'NorthEast'),
    
    end
    
    if p ~= length(data_names)
        
        set(gca, 'XTick', [], 'YTick', [])
    
    end
    
    %% Plotting activation variables
    
    figure(Afig)
    
    subplot(length(data_names), 1, p)
    
    plot_data = [data(stim_indices).(data_field{fields_plotted{p}(1)})];
    
    h = plot(time, plot_data);
    
    axis(gca, 'tight')
    
    box off
    
    set(gca, 'FontSize', 12)
    
    hold(gca, 'on')
    
    xlim(gca, time_indices)
    
    if fields_plotted{p}(1) == 3, ylim([.4 1]), end
    
    ylabel(gca, ylabel_left{p})
    
    set(h, 'LineWidth', 2, 'Color', color(fields_plotted{p}(1), :))
    set(h(1), 'LineStyle', ':')
    
    legend_handles(fields_plotted{p}(1)) = h(2);
    
    y_limits = ylim;
    
    plot(gca, first_spike_time, max(y_limits), 'rp', 'MarkerSize', 10)
    
    plot(gca, time(STP>0), min(y_limits)*ones(size(time(STP>0))), 'r', 'LineWidth', 2)
    
    for i = 2:length(fields_plotted{p})
        
        new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
        set(new_ax, 'FontSize', 12);
        
        plot_data = [data(stim_indices).(data_field{fields_plotted{p}(i)})];
        
        h = plot(new_ax, time, plot_data);
        
        axis(new_ax, 'tight')
        set(new_ax, 'FontSize', 12)
        
        xlim(new_ax, time_indices)
        
        set(h, 'LineWidth', 2, 'Color', color(fields_plotted{p}(i), :))
        set(h(1), 'LineStyle', ':')
        
        set(new_ax, 'Visible', 'off')
        
    end
    
    if p ~= 6
        
        set(gca, 'XTick', [])
        
        if p ~= 2 && p ~= 3
            
            set(gca, 'YTick', [])
            
        end
    
    end
    
end

stim_label = make_label('STPstim', [data(stim_indices).deepRS_STPstim], []);

legend(legend_handles, {'M activation '; 'Synaptic activation'; 'Ca-activated K activation'}, 'Location', 'NorthEast')

saveas(Vfig, ['trace_figure_V', stim_label, '.fig'])

% set(Afig, 'Units', 'inches', 'Position', 1 + [0 0 6 6], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 6 6])

saveas(Afig, ['trace_figure_A', stim_label, '.fig'])

end