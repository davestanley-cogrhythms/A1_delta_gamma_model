%% Simulating.

if ~exist('I_app', 'var'), I_app = -7.5; end

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

sim_struct = init_sim_struct('include_deepRS', 1, 'vary', vary, 'tspan', [0 30000]);

[data, name] = kramer_IB_function_mode(sim_struct);

%% Calculating PLV.

results = spike_locking_to_input_plot(data, name);
    
%% Plotting.

figure

start_times = [1600 2050 2025];

colors = {'r', 'k', 'b'};

for i = 1:3
    
    time = data(i).time;
    V = data(i).deepRS_V;
    
    t_indicator = time >= start_times(i) & time <= start_times(i) + 1900;
    
    subplot(3, 1, i)
    plot(time(t_indicator), V(t_indicator), 'LineWidth', 2, 'Color', colors{i})
    
    hold on
    
    rmp = nanmean(V(time >= 1000));
    
    plot(time(t_indicator), rmp.*ones(size(time(t_indicator))), 'b:', 'LineWidth', 2)
    
    axis tight
    
    box off
    
    set(gca, 'XTick', [], 'XTickLabel', [], 'YTick', rmp, 'YTickLabel', sprintf('-%.3g mV', rmp), 'YAxisLocation', 'right', 'FontSize', 12)
    
end
    
set(gcf, 'Units', 'inches', 'Position', [0 0 3 6], 'PaperUnits', 'inches', 'PaperPosition', [0 0 3 6])

print(gcf, '-painters', '-dpdf', '-r600', 'fig1a.pdf')

saveas(gcf, 'fig1a')