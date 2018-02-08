freqs = fliplr([.25 .5 1 1.5 2:23]);

axesObjs = get(gcf, 'Children');

dataObjs = get(axesObjs, 'Children');

figure

subplot_index = 0; % length(freqs) - 2;

hts = tight_subplot(length(freqs) - 3 - (9 - 1), 1);

for i = fliplr([9:22 24])
    
    subplot_index = subplot_index + 1; % - 1;
    
    axes(hts(subplot_index)); % subplot(length(freqs) - 3, 1, subplot_index)
    
    t1 = get(dataObjs{2*i - 1}, 'XData');
    I = get(dataObjs{2*i - 1}, 'YData');
    t2 = get(dataObjs{2*i}, 'XData');
    V = get(dataObjs{2*i}, 'YData');
    
    sampling_freq = round(1000*length(t1)/t1(end));
    I_wav = wavelet_spectrogram(I - mean(I), sampling_freq, freqs(i)/3, 7, 0, '');
    I_phase = angle(I_wav);
    
    yyaxis right
    
    line2 = plot(t1, I, 'k', 'LineWidth', 1);
    
    axis tight, box off
    
    ylim([0 8])
    
    hold on
    
    % set(gca, 'XTickLabel', '', 'FontSize', 16, 'YColor', 'k', 'YTick', [])
    
    set(gca, 'Visible', 'off')
    
    yyaxis left
    
    % plot(t2, I_wav') % I_phase') % 
    x = t2; y = V; z = I_phase';
    line1 = surface([x;x],[y;y],[z;z],'facecol','no','edgecol','interp','linew',2.5);
    
    axis tight, box off
    
    ylabel(sprintf('%g Hz', freqs(i)), 'Rotation', 0)
    
    % set(gca, 'XTickLabel', '', 'FontSize', 16, 'YColor', 'k', 'YTick', [])
    
    set(gca, 'Visible', 'off')
    
end

colormap('hsv')

set(gcf, 'PaperOrientation', 'landscape', 'Units', 'inches', 'Position', [0 0 5 2.5], 'PaperUnits', 'normalized', 'PaperPosition', [0 0 5 2.5])

figure

surface([x;x],[y;y],[z;z],'facecol','no','edgecol','interp','linew',2.5)

colormap('hsv')

colorbar

% cmap = colormap('winter');
% 
% cmap = [cmap; flipud(cmap)];
% 
% colormap(cmap);