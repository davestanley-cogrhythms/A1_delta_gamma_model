function run_VPtrace_plot(name_mat, stim_selected, lf_selected)

names = load(name_mat);

names = names.names;

label = sprintf('_stim%g_lf%g', stim_selected, lf_selected);

if exist([name_mat(1:(end - 4)), label, '_data.mat']) == 2
    
    data_struct = load([name_mat(1:(end - 4)), label, '_data.mat']);
    
    selected_data = data_struct.selected_data;
    
else
    
    for m = 1:length(names)
        
        data = dsImport(names{m});
        
        VPstim = [data.deepRS_VPstim];
        
        VPlowfreq = [data.deepRS_VPlowfreq];
        
        selected = VPstim == stim_selected & VPlowfreq == lf_selected;
        
        selected_data{m} = data(selected);
        
    end
    
    save([name_mat(1:(end - 4)), label, '_data.mat'], 'names', 'selected_data')
    
end
    
figure;

ha = tight_subplot(length(names), 1);

for m = 1:length(names)
    
    axes(ha(m))
    
    [ax, h1, h2] = plotyy(selected_data{m}.time, selected_data{m}.deepRS_V,...
        selected_data{m}.time, selected_data{m}.deepRS_iVariedPulses_input);
    
    axis(ax, 'tight')
    
    set(ax, 'Visible', 'off')
    
    xlim(ax, [1.04 1.14]*10^4)
    
    set(h1, 'LineWidth', 3, 'Color', 'k')
    set(h2, 'LineWidth', 3, 'Color', .5*[1 1 1])
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 3 6], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 3 6])

saveas(gcf, [name_mat(1:(end - 4)), label, '_traces.fig'])