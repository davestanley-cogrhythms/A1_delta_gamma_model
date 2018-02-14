%% Simulating.

if ~exist('I_app', 'var'), I_app = -6; end

vary = {'deepRS', 'PPfreq', [.25 .5:.5:23];... 1:10;...
    'deepRS', 'PPstim', [0 -.3:-.05:-.5];...
    'deepRS', 'I_app', I_app;... -7.5:-.5:-9.5;... -6.5:-.5:-8.5;...
    'deepRS', 'PPduty', .25;...
    'deepRS', 'kernel_type', 25;... 7;...
    'deepRS', 'PPnorm', 0;... % 1;...
    'deepRS', 'FMPstim', 0;...
    'deepRS', 'STPstim', 0;...
    'deepRS', 'Inoise', .25;...
    };

sim_struct = init_sim_struct('include_deepRS', 1, 'vary', vary, 'tspan', [0 30000], 'cluster_flag', 1);

[~, name] = kramer_IB_function_mode(sim_struct);

%% Calculating PLV.

data = dsImport(name, 'variables', {'deepRS_V','deepRS_iPeriodicPulsesBen_input','time'});

results = spike_locking_to_input_plot(data, [], name);

load([name, '_PLV_data.mat'])

%% Plotting traces (exploratory).

PPfreq = [data.deepRS_PPfreq];

freqs = unique(PPfreq);

for i = 1:length(freqs), titles{i} = num2str(freqs(i), '%g'); end

PPstim = [data.deepRS_PPstim];

stims = unique(PPstim);
    
for s = 1:length(stims)
    
    plot_2_vars(data(PPstim == stims(s)), 'deepRS_V', 'deepRS_iPeriodicPulsesBen_input', [], [6 12]*10^4, [24, 2], [], titles)
    
    saveas(gcf, [name, '_PPstim', num2str(stims(s), '%g'), '_6to12s.fig'])
    
    plot_2_vars(data(PPstim == stims(s)), 'deepRS_V', 'deepRS_iPeriodicPulsesBen_input', [], [], [24, 2], [], titles)
    
    saveas(gcf, [name, '_PPstim', num2str(stims(s), '%g'), '.fig'])

end

%% Plotting PLV.

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

%% Plotting selected spike traces.

selected_PPstim = [-.4 -.4 -.4 -.4];
selected_PPfreq = [.25 4 9 16];

for c = 1:length(selected_PPstim)

    current_index = PPstim == selected_PPstim(c) & PPfreq == selected_PPfreq(c);
    
    current_data = data(current_index);
    
    time = current_data.time;
    time_index = time >= 6000 & time <= 12000;
    I = current_data.deepRS_iPeriodicPulsesBen_input;
    V = current_data.deepRS_V;
    
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

%% Saving.
    
set(gcf, 'Units', 'inches', 'Position', [0 0 3 6], 'PaperUnits', 'inches', 'PaperPosition', [0 0 3 6])

fig_name = sprintf('fig2_Iapp%g_%gHz_%gHz_%gHz_%gHz', I_app, selected_PPfreq);

print(gcf, '-painters', '-dpdf', '-r600', [fig_name, '.pdf'])

saveas(gcf, [fig_name, '.fig'])