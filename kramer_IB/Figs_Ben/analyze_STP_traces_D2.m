function analyze_STP_traces_D2(data_info_file)

if nargin < 1, data_info_file = []; end

stim_indices = [1 8];
%time_window = [0 1]-.2;

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

data_field = {'deepRS_iKs_n', 'deepRS_deepFS_IBaIBdbiSYNseed_s', 'deepRS_iKCaT_q', 'deepRS_iNaP_m'};

figure

sims = [6 6]; no_sims = length(sims);

fields = [1 4; 1 3];

x_labels = {'$I_{inh}$ Activation', '$I_{m}$ Activation', '$I_{m}$ Activation', '$\Delta$ ($I_{m}$ Activation)'};

y_labels = {'$I_{K_{SS}}$ Activation', '$I_{K_{SS}}$ Activation', '$$I_{Na_P}$ Activation', '$\Delta^2$ ($I_{m}$ Activation)'};
    
linestyles = {':', '-'};

for s = 1:no_sims
    
    subplot(1, no_sims, s)
    
    data = dsImport(data_names{sims(s)});
    
    time = data(s).time/1000;
    
    STP = data.deepRS_iSpikeTriggeredPulse_input;
    
    pulse_index = find(diff(STP > 0) == 1);
    pulse_time = time(pulse_index);
    time = time - pulse_time;
    
    % stim_indices = [1 8];
    %time_indices = time_window; % time_offset(p) + time_window;
    
    spike_indicator = logical([data(stim_indices).deepRS_V_spikes]) & [ones(size(STP)), STP <= 0] & (time + pulse_time) > 1;
        
    spike_times = time(spike_indicator(:, 2));
    
    first_spike_indicator = time == spike_times(find(spike_times > .1, 1));
    
    spike_indicator(:, 2) = spike_indicator(:, 2) & ~first_spike_indicator;
    
    activation_1 = [data(stim_indices).(data_field{fields(s, 1)})];
    
    activation_2 = [data(stim_indices).(data_field{fields(s, 2)})];
    
    if s == 2
        
        activation_1 = diff(activation_1);
        
        activation_2 = diff(activation_1, 2);
        
    end
    
    for c = 1:2
        
        plotx = activation_1((time(1:(end - 1)) + pulse_time) > 1, c);
        
        ploty = activation_2((time(1:(end - 3)) + pulse_time) > 1, c);
        
        plot(plotx(1:(end - 2)), ploty, linestyles{c}, 'Color', [.5 .5 .5], 'LineWidth', 0.25)
        
        hold on
        
    end
    
%     if s == 3
%         
%         %activation_2 = diff([activation_1; activation_1(end, :)], 2);
%         
%         for c = 1:2
%         
%             plot(activation_1((time + pulse_time) > 1, c), activation_2((time + pulse_time) > 1, c),...
%                 linestyles{c}, 'Color', [.5 .5 .5], 'LineWidth', 0.5)
%         
%             hold on
%             
%         end
%         
%     end
    
    pre_spike_indicator = circshift(spike_indicator, -1);
    
    for i = 1:2
        
        pre_spike_1 = activation_1(pre_spike_indicator(:, i), i);
        
        pre_spike_2 = activation_2(pre_spike_indicator(:, i), i);
        
        h(i) = plot(pre_spike_1, pre_spike_2, 'k*');
        
        hold on
        
    end
    
    set(h(1), 'Marker', 'x', 'MarkerSize', 10, 'LineWidth', 1.5)
    
    set(h(2), 'Marker', 'o', 'MarkerSize', 5, 'LineWidth', 1.5)
    
    pre_first_spike_indicator = circshift(first_spike_indicator, -1);
    
    h(3) = plot(activation_1(pre_first_spike_indicator, 2), activation_2(pre_first_spike_indicator, 2), 'rp', 'MarkerSize', 10, 'LineWidth', 1.5);
    
    legend(h(1:3), {'No Input Pulse'; 'Input Pulse'; 'First Post-Input Spike'}, 'Location', 'NorthEast')
    
    xlabel(x_labels{s}, 'interpreter', 'Latex')
    
    ylabel(y_labels{s}, 'interpreter', 'Latex')
    
    box off
    
    axis tight
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 3 6], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 3 6])
    
saveas(gcf, 'STP_analysis_D2.fig')

end