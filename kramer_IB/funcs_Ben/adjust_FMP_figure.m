lowfreqs = fliplr([1 .5 .25 .1]); % .05]);
highfreqs = fliplr([9 10 15 20]); % 12.5 15 20]);

axesObjs = get(gcf, 'Children');

dataObjs = get(axesObjs, 'Children');

dataObjs = dataObjs(~cellfun(@isempty, dataObjs));

subplot_index = 0; % length(freqs) - 2;

figure

hts = tight_subplot(length(highfreqs), 1);

for i = fliplr(1:length(highfreqs))
    
    subplot_index = subplot_index + 1; % - 1;
    
    axes(hts(subplot_index)); % subplot(length(freqs) - 3, 1, subplot_index)
    
    t1 = get(dataObjs{2*i - 1}, 'XData')/1000;
    I = get(dataObjs{2*i - 1}, 'YData');
    t2 = get(dataObjs{2*i}, 'XData')/1000;
    V = get(dataObjs{2*i}, 'YData');
    
    sampling_freq = round(1000*length(t1)/t1(end));
    I_h = hilbert(I - mean(I)); % wavelet_spectrogram(I - mean(I), sampling_freq, 6, 2, 0, ''); % 
    I_phase = angle(I_h);
    
    yyaxis right
    
    line2 = plot(t1, I, 'k', 'LineWidth', 1);
    
    axis tight, box off
    
    ylim([0 2])
    
    % xlim([2 10])
    
    hold on
    
    set(gca, 'XTickLabel', '', 'FontSize', 16, 'YColor', 'k', 'YTick', [])
    
    yyaxis left
    
    % plot(t2, I_wav') % I_phase') % 
    x = t2; y = V; z = I_phase;
    line1 = surface([x;x],[y;y],[z;z],'facecol','no','edgecol','interp','linew',2.5);
    
    axis tight, box off
    
    % xlim([2 10])
    
    ylabel({sprintf('%g - %g', lowfreqs(i), highfreqs(i)); 'Hz Input'}) % , 'Rotation', 45)
    
    set(gca, 'XTickLabel', '', 'FontSize', 16, 'YColor', 'k', 'YTick', [])
    
end

% colormap('hsv')

cmap = colormap('cool');

% cmap = [flipud(cmap); cmap];
cmap = [cmap; flipud(cmap)];

colormap(cmap);