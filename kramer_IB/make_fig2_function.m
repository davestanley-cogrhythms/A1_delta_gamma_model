function make_fig2_function(name, plot_flag, plv_flag, trace_flag)

load([name, '_sim_spec.mat'])

freqs = vary{strcmp(vary(:,2), 'PPfreq'), 3}';

stims = vary{strcmp(vary(:,2), 'PPstim'), 3}';

I_app = vary{strcmp(vary(:,2), 'I_app'), 3};

%% Calculating PLV.

if plot_flag
    
    data = dsImport(name); % , 'variables', {'deepRS_V','deepRS_iPeriodicPulsesBen_input','time'});
    
    % Plotting traces (exploratory).
    
    PPfreq = [data.deepRS_PPfreq];
    
    freqs = unique(PPfreq);
    
    for i = 1:length(freqs), titles{i} = num2str(freqs(i), '%g'); end
    
    PPstim = [data.deepRS_PPstim];
    
    stims = unique(PPstim);
        
    window = min(1, floor(max(data(1).time)/6000) - 1);
    
    for s = 1:length(stims)
        
        plot_2_vars(data(PPstim == stims(s)), 'deepRS_V', 'deepRS_iPeriodicPulsesBen_input', [], (window + [0 1])*6*10^4 + [1 0], [length(data)/(2*length(stims)), 2], [], titles)
        
        saveas(gcf, [name, '_PPstim', num2str(stims(s), '%g'), sprintf('_%gto%g.fig', window + [1 2])])
        
        plot_2_vars(data(PPstim == stims(s)), 'deepRS_V', 'deepRS_iPeriodicPulsesBen_input', [], [], [length(data)/(2*length(stims)), 2], [], titles)
        
        saveas(gcf, [name, '_PPstim', num2str(stims(s), '%g'), '.fig'])
        
    end
    
    results = spike_locking_to_input_plot(data, [], name);
    
end

%% Plotting PLV.

if plv_flag
    
    if exist([name, '_PLV_data.mat'], 'file')
    
        load([name, '_PLV_data.mat'])
        
    end
    
    figure
    
    mrv_size = size(v_mean_spike_mrvs);
    
    mrvs = reshape(permute(v_mean_spike_mrvs, [2 1 3]), prod(mrv_size([1 2])), mrv_size(3));
    
    ns_size = size(no_spikes);
    
    nspikes = reshape(permute(no_spikes, [2 1 3]), prod(ns_size([1 2])), ns_size(3));
    
    adjusted_plv = ((abs(mrvs).^2).*nspikes - 1)./(nspikes - 1);
    
    adjusted_plv = adjusted_plv(:, 1:(end - 1)) - repmat(adjusted_plv(:, end), 1, mrv_size(3) - 1);
    
    subplot(3, 1, 1)
    
    cmap = summer(size(adjusted_plv, 2) + 1);
    set(gca, 'NextPlot', 'add', 'ColorOrder', cmap(1:(end - 1), :))
    plot(freqs, adjusted_plv(1:length(freqs), :), 'LineWidth', 1)
    
    hold on
    
    plot(freqs, nanmean(adjusted_plv(1:length(freqs), :), 2), 'k', 'LineWidth', 2)
    
    axis tight
    
    for s = 1:(length(stims) - 1)
        
        my_legend{s} = sprintf('Input strength = %g', abs(stims(s)));
        
    end
    
    legend(my_legend)
    
    title(sprintf('CBT, I_{app} = %g', I_app))
    
    xlabel('Input Freq. (Hz)')
    
    ylabel('Phase-Locking Value')
    
    % Saving.
    
    set(gcf, 'Units', 'inches', 'Position', [0 0 3 6], 'PaperUnits', 'inches', 'PaperPosition', [0 0 3 6])
    
    fig_name = sprintf('%s_fig2a_Iapp%g', name, I_app);
    
    print(gcf, '-painters', '-dpdf', '-r600', [fig_name, '.pdf'])
    
    saveas(gcf, [fig_name, '.fig'])
    
end

%% Plotting selected spike traces.

if trace_flag
    
    fig_for_plot = figure;
    
    selected_PPstim = -.5; % [-.5 -.5 -.5 -.5];
    
    if ~exist('data', 'var')
        
        fig_for_data = open([name, '_PPstim', num2str(selected_PPstim, '%g'), '.fig']);
        
    end
    
    selected_PPfreq = [.25 5 8 17];
    
    for c = 1:length(selected_PPfreq)
        
        if exist('data', 'var')
            
            current_index = PPstim == selected_PPstim & PPfreq == selected_PPfreq(c);
            
            current_data = data(current_index);
            
            time = current_data.time;
            
            I = current_data.deepRS_iPeriodicPulsesBen_input;
            
            V = current_data.deepRS_V;
            
        else
            
            axesObjs = get(fig_for_data, 'Children');
            
            dataObjs = get(axesObjs, 'Children');
            
            f_index = find(flipud(freqs) == selected_PPfreq(c));
            
            if f_index == 47
                
                I_index = 2*f_index;
                
            else
                
                I_index = 2*f_index - 1;
                
            end
            
            time = get(dataObjs{I_index}, 'XData')';
            
            I = get(dataObjs{I_index}, 'YData')';
            
            V = get(dataObjs{I_index + 1}, 'YData')';
            
            figure(fig_for_plot)
            
        end
        
        window = min(1, floor(max(time)/6000) - 1);
        
        time_index = time >= window*6000 & time <= (window + 1)*12000;
        
        sampling_freq = round(1000*length(time)/time(end));
        I_wav = wavelet_spectrogram(I - mean(I), sampling_freq, selected_PPfreq(c)/3, 7, 0, '');
        I_phase = angle(I_wav);
        
        subplot(6, 1, c + 2)
        
        yyaxis right
        
        line2 = plot(time(time_index), I(time_index), 'k', 'LineWidth', 1);
        
        axis tight, box off
        
        ylabel(sprintf('%g Hz Input', selected_PPfreq(c)))
        
        ylim([-.1 8])
        
        hold on
        
        % set(gca, 'XTickLabel', '', 'FontSize', 16, 'YColor', 'k', 'YTick', [])
        
        set(gca, 'Visible', 'off')
        
        yyaxis left
        
        % plot(t2, I_wav') % I_phase') %
        x = time(time_index)'; y = V(time_index)'; z = I_phase(time_index)';
        line1 = surface([x;x],[y;y],[z;z],'facecol','no','edgecol','interp','linew',2.5);
        
        axis tight, box off
        
        colormap('hsv')
        
    end
    
    % Saving.
    
    set(fig_for_plot, 'Units', 'inches', 'Position', [0 0 3 6], 'PaperUnits', 'inches', 'PaperPosition', [0 0 3 6])
    
    fig_name = sprintf('%s_fig2b_Iapp%g_stim%g_%gHz_%gHz_%gHz_%gHz', name, I_app, selected_PPstim, selected_PPfreq);
    
    print(fig_for_plot, '-painters', '-deps', '-r600', [fig_name, '.eps'])
    
    saveas(fig_for_plot, [fig_name, '.fig'])
    
end