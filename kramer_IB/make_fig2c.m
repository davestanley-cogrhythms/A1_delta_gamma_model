if ~exist('figure_number', 'var'), figure_number = 2; end

%% Simulating.

if ~exist('I_app', 'var'), I_app = -8.5; end

vary = {'deepRS', 'FMPstim', [0 -.8:-.1:-1.2];... % 0:-.2:-1;... % -1;... % 
    'deepRS', '(FMPhighfreq, FMPlowfreq)', [7 8 9 9 11 11 13 14; 4 3.5 3 2 3 2 1 .5];... [7 8 9 10 11; 1 2 3 4 5];... [9 11 13 14; 3 2 1 .5];...
    'deepRS', 'I_app', I_app;...
    'deepRS', 'PPstim', 0;...
    'deepRS', 'STPstim', 0;...
    'deepRS', 'Inoise', .25;...
    };

sim_struct = init_sim_struct('include_deepRS', 1, 'vary', vary, 'tspan', [0 30000], 'cluster_flag', 1);

[~, name] = kramer_IB_function_mode(sim_struct);

%% Loading data.

data = dsImport(name); % , 'variables', {'deepRS_V','deepRS_iPeriodicPulsesBen_input','time'});

FMPstim = [data.deepRS_FMPstim];

stims = fliplr(unique(FMPstim));

FMPhighfreq = [data.deepRS_FMPhighfreq];

highfreqs = unique(FMPhighfreq);

if length(highfreqs) == size(vary{2,3}, 1)
    
    islattice = true;
    
else
    
    islattice = false;
    
    highfreqs = vary{2,3};
    highfreqs = highfreqs(1, :);
    
end

FMPlowfreq = [data.deepRS_FMPlowfreq];

if islattice
    
    lowfreqs = fliplr(unique(FMPlowfreq));
    
else
    
    lowfreqs = vary{2,3};
    lowfreqs = lowfreqs(2, :);
    
end

I_app = vary{3,3};

%%  Plotting traces (exploratory).

for f = 1:length(highfreqs)
    
    freq_titles{f} = sprintf('FMPfreqs = [%g %g]', lowfreqs(f), highfreqs(f));
    
    for s = 1:length(stims)
    
        titles{(s - 1)*length(highfreqs) + f} = sprintf('FMPstim = %g, FMPfreqs = [%g %g]', stims(s), lowfreqs(f), highfreqs(f));
            
    end

end

plot_2_vars(data, 'deepRS_V', 'deepRS_iFMPulses_input', [], [6 12]*10^4, [length(lowfreqs), round(length(data)/length(lowfreqs))], 'column', titles)

saveas(gcf, [name, '_6to12s.fig'])

for s = 1:length(stims)
    
    plot_2_vars(data(FMPstim == stims(s)), 'deepRS_V', 'deepRS_iFMPulses_input', [], [], [length(data)/length(lowfreqs), 1], [], freq_titles)
    
    saveas(gcf, sprintf('%s_FMPstim%g.fig', name, stims(s)))
    
end

%% Calculating PLV.

if islattice

    results = spike_locking_to_input_plot(data, [], name, 'i_field', 'deepRS_iFMPulses_input', 'input_transform', 'hilbert');
    
else
    
    results = dsAnalyze(data, @phase_metrics, 'i_field', 'deepRS_iFMPulses_input', 'input_transform', 'hilbert');
    
end

%% Plotting selected spike traces.

fig_for_plot = figure;

selected_FMPstim = -1.2; % [-.5 -.5 -.5 -.5];

selected_FMPhighfreq = [9 11];
selected_FMPlowfreq = [3 2];

time_start = 15000; time_stop = 21000;

if ~exist('data', 'var')
        
    fig_for_data = open([name, '.fig']);
    
    load([name, '_sim_spec.mat'])
    
    stims = flipud(vary{1, 3}');
    
    freqs = vary{2, 3}';
    
    I_app = vary{3, 3};
        
end

cmap = colormap('cool');
cmap = [flipud(cmap); cmap];

for c = 1:length(selected_FMPhighfreq)

    if exist('data', 'var')
    
        current_index = abs(FMPstim - selected_FMPstim) < 2*eps...
            & FMPhighfreq == selected_FMPhighfreq(c)...
            & FMPlowfreq == selected_FMPlowfreq(c);
    
        current_data = data(current_index);
        
        time = current_data.time;
        
        I = current_data.deepRS_iFMPulses_input;
        
        V = current_data.deepRS_V;
        
    else
        
%         axesObjs = get(fig_for_data, 'Children');
%         
%         dataObjs = get(axesObjs, 'Children');
%         
%         f_index = find(flipud(freqs) == selected_PPfreq(c));
%         
%         if f_index == 47
%             
%             I_index = 2*f_index;
%             
%         else
%             
%             I_index = 2*f_index - 1;
%             
%         end
%         
%         time = get(dataObjs{I_index}, 'XData')';
%         
%         I = get(dataObjs{I_index}, 'YData')';
%         
%         V = get(dataObjs{I_index + 1}, 'YData')';
%     
%         figure(fig_for_plot)
        
    end
    
    time_index = time >= time_start & time <= time_stop;
    
    sampling_freq = round(1000*length(time)/time(end));
    I_complex = hilbert(I - mean(I));
    I_phase = angle(I_complex);
    
    subplot(3, 1, c + 1) 
    
    yyaxis right
    
    line2 = plot(time(time_index), I(time_index), 'k', 'LineWidth', 1);
    
    axis tight, box off
    
    ylabel(sprintf('%g - %g Hz Input', selected_FMPhighfreq(c), selected_FMPlowfreq(c)))
    
    ylim([-.1 2])
    
    hold on
    
    % set(gca, 'XTickLabel', '', 'FontSize', 16, 'YColor', 'k', 'YTick', [])
    
    set(gca, 'Visible', 'off')
    
    yyaxis left
    
    % plot(t2, I_wav') % I_phase') % 
    x = time(time_index)'; y = V(time_index)'; z = I_phase(time_index)';
    line1 = surface([x;x],[y;y],[z;z],'facecol','no','edgecol','interp','linew',2.5);
    
    axis tight, box off
    
    colormap(cmap);
    
end

% Saving.
    
set(fig_for_plot, 'Units', 'inches', 'Position', [0 0 6 6], 'PaperUnits', 'inches', 'PaperPosition', [0 0 6 6])

fig_name = sprintf('%s_fig2c_Iapp%g_stim%g_%gHz_%gHz_%gHz_%gHz_%gto%g', name, I_app,...
    selected_FMPstim, selected_FMPlowfreq, selected_FMPhighfreq,...
    time_start/1000, time_stop/1000);

print(fig_for_plot, '-painters', '-deps', '-r600', [fig_name, '.eps'])

saveas(fig_for_plot, [fig_name, '.fig'])

%% Plotting PLV.

if islattice

    load([name, '_PLV_data.mat'])

else
    
    for i = 1:length(results)
        
        mean_spike_mrvs = nanmean(exp(sqrt(-1)*results(i).v_spike_phases));
        
        v_mean_spike_mrvs(i) = mean_spike_mrvs(1);
        
        no_spikes(i) = size(results(i).v_spike_phases, 1);
        
    end
    
    v_mean_spike_mrvs = fliplr(reshape(v_mean_spike_mrvs, length(highfreqs), length(stims)));
    
    no_spikes = fliplr(reshape(no_spikes, length(highfreqs), length(stims)));
    
end


if ~exist('data', 'var')
    
    freqs = vary{1, 3}';
    
    stims = flipud(vary{2, 3}');
    
    I_app = vary{3, 3};
        
end

figure

mrvs = v_mean_spike_mrvs;

nspikes = no_spikes;

adjusted_plv = ((abs(mrvs).^2).*nspikes - 1)./(nspikes - 1);

adjusted_plv = adjusted_plv(:, 1:(end - 1)) - repmat(adjusted_plv(:, end), 1, size(adjusted_plv, 2) - 1);

%plot_indices = [1:3 6:8];
ap_for_plot = adjusted_plv; %(plot_indices, :);

subplot(3, 1, 1)

cmap = summer(size(adjusted_plv, 2) + 1);
set(gca, 'NextPlot', 'add', 'ColorOrder', cmap(1:(end - 1), :))
plot(1:size(ap_for_plot, 1), flipud(ap_for_plot), 'LineWidth', 1)

for s = 2:length(stims)
   
    mylegend{s - 1} = num2str(stims(length(stims) - s + 2));
    
end

legend(mylegend, 'Location', 'Northwest')

hold on

plot(1:size(ap_for_plot, 1), nanmean(flipud(ap_for_plot), 2), 'k', 'LineWidth', 2)

for f = 1:length(highfreqs)
    
    my_xticks{length(highfreqs) - f + 1} = sprintf('[%g %g]', lowfreqs(f), highfreqs(f));
    
end

set(gca, 'XTick', 1:length(my_xticks(plot_indices)), 'XTickLabel', my_xticks) % (plot_indices)) % {'.5-14 Hz', '1-13 Hz', '2-11 Hz', '3-9 Hz'})

axis tight

ylim([0 1])

fig_name = sprintf('%s_fig2c_Iapp%g', name, I_app);
    
print(gcf, '-painters', '-dpdf', '-r600', [fig_name, '.pdf'])

saveas(gcf, [fig_name, '.fig'])

%% Plotting selected rose plots.

selected_FMPstim = -1.2; % [-.5 -.5 -.5 -.5];

selected_FMPhighfreq = highfreqs; % [7 8 9 10 11]; %[9 11 13 14]; % 13.5 18 27];
selected_FMPlowfreq = lowfreqs; % [1 2 3 4 5]; % [3 2 1 .5]; % 2 1.5 1];

if ~exist('data', 'var')
        
    fig_for_data = open([name, '.fig']);
    
    load([name, '_sim_spec.mat'])
    
    stims = flipud(vary{1, 3}');
    
    freqs = vary{2, 3}';
    
    I_app = vary{3, 3};
        
end

cmap = colormap('cool');
cmap = [cmap; flipud(cmap)];

if ~exist('results', 'var')
    
    load([name, '_PLV_data.mat'])
    
end

for c = 1:length(selected_FMPhighfreq)
    
    figure
    
    axxes(c) = gca;
    
    current_index = abs(FMPstim - selected_FMPstim) < 2*eps...
        & FMPhighfreq == selected_FMPhighfreq(c); %...
        %& FMPlowfreq == selected_FMPlowfreq(c);
    
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
    
    x = rho.*cos(theta);
    y = rho.*sin(theta);
    % z = x + sqrt(-1)*y;
    % 
    % phi = angle(z);
    % x_known = find(phi ~= 0);
    % v_known = phi(x_known);
    % x_queried = find(phi == 0);
    % v_queried = interp1(x_known, v_known, x_queried);
    % phi_interp = phi;
    % phi_interp(x_queried) = v_queried;
    % phi_interp(isnan(phi_interp)) = phi(isnan(phi_interp));
    %     phi_nan(phi == 0) = nan;
    %     phi_nan = nanconv(phi_nan', ones(10, 1)/10, 'same');
    %     phi(phi == 0) = phi_nan(phi == 0);
    
    surface([x;x],[y;y],[theta_interp;theta_interp],'facecol','no','edgecol','interp','linew',2.5)
    
    axis tight
    
    lim = max([abs(xlim), abs(ylim)]);
    
    lims = [-1 1]*lim;
    
    xlim(lims), ylim(lims)
    
    hold on
    
    mrv = lim*mean(exp(sqrt(-1)*current_results.v_spike_phases(:, 1, 1)));
    
    h(c) = arrow([0, 0], [real(mrv), imag(mrv)], 'LineWidth', 2);
    
    % set(gca, 'Visible', 'off')
    
    colormap(cmap)
    
    set(gca, 'XAxisLocation', 'origin', 'YColor', 'w', 'FontSize', 16)
    
    xtick = get(gca, 'XTick');
    
    xtick(xtick < 0) = [];
    
    set(gca, 'XTick', xtick)
    
    viscircles([0, 0], min(xtick(xtick > 0)), 'Color', 'k', 'LineWidth', .5)
    
    children = get(axxes(c), 'Children');
    
    set(axxes(c), 'DrawMode', 'fast', 'Children', children([2 3 1]))
    
    % Saving.
    
    plot_dims = [0 0 3 3]; % [0 0 5*3 5*2];
    
    set(gcf, 'Units', 'inches', 'Position', plot_dims,...
        'PaperUnits', 'inches', 'PaperPosition', plot_dims)
    
    fig_name = sprintf('%s_fig2c_Iapp%g_stim%g_%g-%gHz_rose', name, I_app,...
        selected_FMPstim, selected_FMPlowfreq(c), selected_FMPhighfreq(c));
    
    print(gcf, '-painters', '-deps', '-r600', [fig_name, '.eps'])
    
    print(gcf, '-painters', '-dpng', '-r600', [fig_name, '.png'])
    
    saveas(gcf, [fig_name, '.fig'])
    
end
