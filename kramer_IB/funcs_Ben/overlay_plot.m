iKs_n = [data(:).deepRS_iKs_n];
iNaP_m = [data(:).deepRS_iNaP_m];
save_as_pdf(1, [name, '_iNaP_m_input_STPshift_leq_100'])
shifts
size(iKs_n(shift == 10))
size(iKs_n(:, shift == 10))
size(iKs_n(90000:130000, shift == 10))
for s = 1:11, iKs_mat(:, :, s) = iKs_n(90000:130000, shift == shifts(s)); end
for s = 1:11, iNaP_mat(:, :, s) = iNaP_m(90000:130000, shift == shifts(s)); end
for s = 1:11, iKs_mat(:, 2:7, s) = iKs_n(90000:130000, shift == shifts(s)); end
for s = 1:11, iNaP_mat(:, 2:7, s) = iNaP_m(90000:130000, shift == shifts(s)); end
input = [data(:).deepRS_iSpikeTriggeredPulse_Input];
input = [data(:).deepRS_iSpikeTriggeredPulse_input];
input = input(:, stim == 0);
for s = 1:11, iKs_mat(:, 1, s) = input(90000:130000, s); end
for s = 1:11, iNaP_mat(:, 1, s) = input(90000:130000, s); end
figure, for s = 1:11, subplot(3,4,s), plot((90000:130000)/100, iKs_mat(:, :, s)), end
figure, for s = 1:11, subplot(3,4,s), plot((90000:130000)/100, iKs_mat(:, :, s)), axis tight, box off, end
figure, for s = 1:11, subplot(3,4,s), plotyy((90000:130000)/100, iKs_mat(:, 1, s), (90000:130000)/100, iKs_mat(:, 2:end, s)), end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 1, s), (90000:130000)/100, iKs_mat(:, 2:end, s)), axis(ax, 'tight'), box off, end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 1, s), (90000:130000)/100, iKs_mat(:, 2:end, s)), axis(ax, 'tight'), box off, if s == 1, legend{num2str(shifts(1:11))}, end
my_legend = cellfun(@num2str, mat2cell(shifts(1:11), 1, ones(1, 11)), 'UniformOutput', false)
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 1, s), (90000:130000)/100, iKs_mat(:, 2:end, s)), axis(ax, 'tight'), box off, if s == 1, legend(my_legend), end, end
my_legend = cellfun(@num2str, mat2cell(stims, 1, ones(1, length(stims))), 'UniformOutput', false)
my_legend = cellfun(@num2str, mat2cell(fliplr(abs(stims)), 1, ones(1, length(stims))), 'UniformOutput', false)
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 1, s), (90000:130000)/100, iKs_mat(:, 2:end, s)), axis(ax, 'tight'), box off, if s == 1, legend(my_legend), end, end
stims
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 1, s), (90000:130000)/100, iKs_mat(:, 2:end, s)); axis(ax, 'tight'), box off, if s == 1, legend(ax(2), my_legend), end, end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, if s == 1, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iKs_n', 'interpreter', 'none'), title(sprintf('Shift = %g', shifts(s)/100))if s == 2, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iKs_n', 'interpreter', 'none'), title(sprintf('Shift = %g', shifts(s)/100)), if s == 2, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iKs_n', 'interpreter', 'none'), title(sprintf('Shift = %g ms', shifts(s))), if s == 2, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
close('all')
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iKs_n', 'interpreter', 'none'), title(sprintf('Shift = %g ms', shifts(s))), xlabel('Time (ms)'), if s == 2, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
close('all')
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iKs_n', 'interpreter', 'none'), title(sprintf('Shift = %g ms', shifts(s))), xlabel('Time (ms)'), if s == 9, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iKs_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iKs_n', 'interpreter', 'none'), title(sprintf('Shift = %g ms', shifts(s))), xlabel('Time (ms)'), if s == 2, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
save_as_pdf(gcf, [name, '_input_iKs_n_overlaid_STPshift_leq_100'])
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, iNaP_mat(:, 2:end, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iNaP_m', 'interpreter', 'none'), title(sprintf('Shift = %g ms', shifts(s))), xlabel('Time (ms)'), if s == 2, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
save_as_pdf(gcf, [name, '_input_iNaP_m_overlaid_STPshift_leq_100'])
V = [data(:).deepRS_V];
for s = 1:11, V_mat(:, :, s) = V(90000:130000, shift == shifts(s)); end
figure, for s = 1:11, subplot(3,4,s), [ax, h1, h2] = plotyy((90000:130000)/100, V_mat(:, :, s), (90000:130000)/100, iKs_mat(:, 1, s)); axis(ax, 'tight'), box off, ylabel(ax(1), 'iNaP_m', 'interpreter', 'none'), title(sprintf('Shift = %g ms', shifts(s))), xlabel('Time (ms)'), if s == 2, hl = legend(ax(1), my_legend); hlt = get(hl, 'Title'); set(hlt, 'String', 'STPstim'); end, end
save_as_pdf(gcf, [name, '_input_V_overlaid_STPshift_leq_100'])

time = (90000:140000)'/100;

c_order = colormap('cool');
c_order = c_order(1:3:63, :);
c_order = [c_order; 0 0 0];

%%
figure

for s = 1:11
    
    subplot(3,4,s)
    
    set(gca, 'NextPlot', 'add', 'ColorOrder', c_order)
    
    plot(time, iKs_mat(:, :, s))
    
    hold on
    
    plot(time, 4*input(:,s) + .155, 'k') % 2000*input(:, s) - 60, 'k')
    
    % [ax, h1, h2] = plotyy(time, V_mat(:, :, s), time, input(:, s));
    
    axis tight, box off
    
    ylabel(gca, 'iKs_n', 'interpreter', 'none')
    
    title(sprintf('Shift = %g ms', shifts(s))), xlabel('Time (ms)')
    
%     if s == 2
%         
%         hl = legend(ax(1), my_legend); 
%         hlt = get(hl, 'Title'); 
%         set(hlt, 'String', 'STPstim'); 
%     
%     end
    
end