if ~exist('figure_number', 'vary'), figure_number = 2; end

%% Simulating.

% if ~exist('I_app', 'var'), I_app = -9; end

vary = {'deepRS', 'PPfreq', [.25 .5:.5:23];... 1:10;...
    'deepRS', 'PPstim', [0 -.3:-.05:-.5];...
    'deepRS', 'I_app', I_app;... -7.5:-.5:-9.5;... -6.5:-.5:-8.5;...
    'deepRS', 'PPduty', .25;...
    'deepRS', 'kernel_type', 25;... 7;...
    'deepRS', 'PPnorm', 0;... % 1;...
    'deepRS', 'FMPstim', 0;...
    % 'deepRS', 'STPstim', 0;...
    'deepRS', 'Inoise', .25;...
    % 'deepRS', 'gKCa', 0;...
    };

sim_struct = init_sim_struct('include_deepRS', 1, 'vary', vary, 'tspan', [0 30000], 'cluster_flag', 1);

[~, name] = kramer_IB_function_mode(sim_struct);

%% Loading data.

data = dsImport(name, 'variables', {'deepRS_V','deepRS_iPeriodicPulsesBen_input','time'});

PPfreq = [data.deepRS_PPfreq];

freqs = unique(PPfreq);

PPstim = [data.deepRS_PPstim];

stims = unique(PPstim);

%% Calculating PLV.

results = spike_locking_to_input_plot(data, [], name);

%%  Plotting traces (exploratory).

for i = 1:length(freqs), titles{i} = num2str(freqs(i), '%g'); end
        
window = min(1, floor(max(data(1).time)/6000) - 1);

for s = 1:length(stims)
    
    plot_2_vars(data(PPstim == stims(s)), 'deepRS_V', 'deepRS_iPeriodicPulsesBen_input', [], (window + [0 1])*6*10^4 + [1 0], [length(data)/(2*length(stims)), 2], [], titles)
    
    saveas(gcf, [name, '_PPstim', num2str(stims(s), '%g'), sprintf('_%gto%g.fig', window + [0 1])])
    
    plot_2_vars(data(PPstim == stims(s)), 'deepRS_V', 'deepRS_iPeriodicPulsesBen_input', [], [], [length(data)/(2*length(stims)), 2], [], titles)
    
    saveas(gcf, [name, '_PPstim', num2str(stims(s), '%g'), '.fig'])
    
end

%% Plotting PLV.

load([name, '_PLV_data.mat'])

if ~exist('data', 'var')
    
    freqs = vary{1, 3}';
    
    stims = flipud(vary{2, 3}');
    
    I_app = vary{3, 3};
        
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

xlabel('Input Freq. (Hz)', 'FontSize', 12)

ylabel('Phase-Locking Value', 'FontSize', 12)

% Saving.

set(gca, 'FontSize', 12)
    
set(gcf, 'Units', 'inches', 'Position', [0 0 8 6], 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6])

fig_name = sprintf('fig2a_Iapp%g', I_app);

print(gcf, '-painters', '-dpdf', '-r600', [fig_name, '.pdf'])

print(gcf, '-painters', '-deps', '-r600', [fig_name, '.eps'])

saveas(gcf, [fig_name, '.fig'])

%% Plotting selected spike traces.

fig_for_plot = figure;

selected_PPstim = -.4; % -.45; % [-.5 -.5 -.5 -.5];

selected_PPfreq = [0.25 3 7.5 9 12];

if ~exist('data', 'var')
        
    fig_for_data = open([name, '_PPstim', num2str(selected_PPstim, '%g'), '.fig']);
    
    load([name, '_sim_spec.mat'])
    
    freqs = vary{1, 3}';
    
    stims = flipud(vary{2, 3}');
    
    I_app = vary{3, 3};
        
end

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
    
    time_index = time >= 18500 & time <= 21500;
    
    sampling_freq = round(1000*length(time)/time(end));
    I_wav = wavelet_spectrogram(I - mean(I), sampling_freq, selected_PPfreq(c), 7, 0, '');
    I_phase = angle(I_wav);
    
    subplot(6, 1, c + 1) 
    
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
    
set(fig_for_plot, 'Units', 'inches', 'Position', [0 0 6 6], 'PaperUnits', 'inches', 'PaperPosition', [0 0 6 6])

fig_name = sprintf('fig2b_Iapp%g_stim%g_%gHz_%gHz_%gHz_%gHz_%gHz', I_app, selected_PPstim, selected_PPfreq);

%print(fig_for_plot, '-painters', '-deps', '-r600', [fig_name, '.eps'])

%saveas(fig_for_plot, [fig_name, '.fig'])

%% Plotting selected rose plots.

selected_PPstim = -.45; % [-.5 -.5 -.5 -.5];

selected_PPfreq = [0.25 3 6.5 7 7.5 8 9 12]; % .5:.5:12];

if ~exist('results', 'var')
    
    load([name, '_PLV_data.mat'])
    
end

I_app = unique([results.deepRS_I_app]);

stims = [0 -.3:-.05:-.5];

freqs = [0.25 .5:.5:23];

PPstim = repmat(stims', [1 length(freqs)]);

PPstim = PPstim(:);

PPfreq = repmat(freqs, [length(stims) 1]);

PPfreq = PPfreq(:);

for c = 1:length(selected_PPfreq)
    
    % figure
    
    current_index = PPstim == selected_PPstim & PPfreq == selected_PPfreq(c);
    
    current_results = results(current_index);
    
    % axxes(c) = subplot(3, 2, c);
    
    [theta, rho] = rose(current_results.v_spike_phases(:, 1, 1), 45);
    
    x_known = find(theta ~= 0);
    v_known = theta(x_known);
    x_queried = find(theta == 0);
    v_queried = interp1(x_known, v_known, x_queried, 'linear', 'extrap');
    theta_interp = theta;
    theta_interp(x_queried) = v_queried;
    theta_interp(isnan(theta_interp)) = theta(isnan(theta_interp));
    
    % plotyy(1:length(theta_interp), theta_interp, 1:length(theta_interp), rho)
    
    fig_for_plot = figure;
    
    axxes(c) = gca;
    
    theta_interp = mod(theta_interp + pi, 2*pi) - pi;
    
    x = rho.*cos(theta);
    y = rho.*sin(theta);
    % z = x + sqrt(-1)*y;
    
    % phi = angle(z);
    % x_known = find(phi ~= 0);
    % v_known = phi(x_known);
    % x_queried = find(phi == 0);
    % v_queried = interp1(x_known, v_known, x_queried, 'linear', 'extrap'); % , 'nearest');
    % phi_interp = phi;
    % phi_interp(x_queried) = v_queried;
    % phi_interp(isnan(phi_interp)) = phi(isnan(phi_interp));
    %     phi_nan(phi == 0) = nan;
    %     phi_nan = nanconv(phi_nan', ones(10, 1)/10, 'same');
    %     phi(phi == 0) = phi_nan(phi == 0);
    
    surface([x;x],[y;y],[theta_interp;theta_interp],'facecol','no','edgecol','interp','linew',2.5)
    
    axis tight
    
    set(axxes(c), 'FontSize', 16)
    
    lim = max([abs(xlim), abs(ylim)]);
    
    lims = [-1 1]*lim;
    
    xlim(lims), ylim(lims)
    
    hold on
    
    mrv = lim*mean(exp(sqrt(-1)*current_results.v_spike_phases(:, 1, 1)));
    
    arrow([0, 0], [real(mrv), imag(mrv)], 'LineWidth', 2)
    
    colormap('hsv')
    
    set(axxes(c), 'XAxisLocation', 'origin', 'YColor', 'w')
    
    xtick = get(axxes(c), 'XTick');
    
    xtick(xtick < 0) = [];
    
    set(axxes(c), 'XTick', xtick)
    
    viscircles([0, 0], xtick(end), 'Color', 'k', 'LineWidth', .5)
    
    children = get(axxes(c), 'Children');
    
    set(axxes(c), 'DrawMode', 'fast', 'Children', children([2 3 1]))
    
    % Saving.
    
    plot_dims = [0 0 3 3]; % [0 0 5*3 5*2];
    
    set(gcf, 'Units', 'inches', 'Position', plot_dims,...
        'PaperUnits', 'inches', 'PaperPosition', plot_dims)
    
    fig_name = sprintf('fig2b_Iapp%g_stim%g_%gHz_rose', I_app, selected_PPstim, selected_PPfreq(c));
    
    saveas(fig_for_plot, [fig_name, '.fig'])
    
    set(axxes(c), 'XTick', [], 'YColor', 'w')
    
    % print(fig_for_plot, '-painters', '-deps', '-r600', [fig_name, '.eps'])
    
    print(fig_for_plot, '-painters', '-dpng', '-r600', [fig_name, '.png'])
    
end

% sync_axes(axxes)