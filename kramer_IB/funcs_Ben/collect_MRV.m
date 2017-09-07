function collect_MRV

Is = 5.5:.5:9.5;

for I = 1:length(Is)
    file = dir(sprintf('*%g_MRV.fig', Is(I)));
    filename = file.name;
    open(filename)
    h = gcf;
    axesObjs = get(h, 'Children');
    dataObjs = get(axesObjs, 'Children');
    MRV(:, :, I) = cell2mat(get(dataObjs{3}, 'YData'));
    if I == 1
        freqs = get(dataObjs{3}, 'XData');
        freqs = freqs{1};
    end
    mean_MRV(I, :) = nanmean(MRV(4:end, :, I)); % ydata(3, :); % 
    nSpikes(:, :, I) = cell2mat(get(dataObjs{2}, 'YData'));
    mean_nSpikes(I, :) = zscore(nSpikes(end, :, I));
end

save('MRV_collected.mat', 'freqs', 'MRV', 'mean_MRV', 'nSpikes', 'mean_nSpikes')

figure
mean_MRV(isnan(mean_MRV)) = 0;
pcolor(freqs, Is, mean_MRV) % imagesc(mean_MRV)
colormap(gcf, 'hot')
shading(gca, 'interp')
set(gca, 'FontSize', 16)
axis xy
% set(gca, 'YTickLabel', Is, 'XTick', 'XTickLabel', freqs)
ylabel('Applied Current')
xlabel('Frequency (Hz)')
save_as_pdf(gcf, 'MRV_colorplot')

figure
mean_nSpikes(isnan(mean_nSpikes)) = 0;
pcolor(freqs, Is, mean_nSpikes)
colormap(gcf, 'hot')
shading(gca, 'interp')
set(gca, 'FontSize', 16)
axis xy
% set(gca, 'YTickLabel', Is, 'XTickLabel', freqs)
ylabel('Applied Current')
xlabel('Frequency (Hz)')
save_as_pdf(gcf, 'nSpikes_colorplot')