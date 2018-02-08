%% Simulating.

vary = {'deepRS', 'I_app', [-9 -8.8 -8.03];... [-10.2 -9.78 -8.9];...
    'deepRS', 'Inoise', .25;... 0;...
    'deepRS', 'PPstim', 0;...
    'deepRS', 'FMPstim', 0;...
    'deepRS', 'STPstim', 0;...
    };

sim_struct = init_sim_struct('include_deepRS', 1, 'vary', vary, 'dsfact', 1);

[data, name] = kramer_IB_function_mode(sim_struct);
    
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