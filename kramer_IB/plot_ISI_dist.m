function [data, results] = plot_ISI_dist(name, data, results)

if nargin < 3, results = []; end

if nargin < 2, data = []; end

if isempty(data), data = dsImport(name); end

if isempty(results), results = dsAnalyze(data, @ISI_metrics); end

figure

my_legend = cell(length(data), 1);
distances = nan(length(data), 1);
gCars = [data.deepRS_gCar];

for i = 1:length(data)
    
    plot(results(i).ISI_bins, results(i).ISI_dist, 'Color', (i - 1)/(length(data) - 1)*[0 1 1] + (length(data) - i)/(length(data) - 1)*[1 0 1], 'LineWidth', 2)
    
    hold on

    my_legend{i} = sprintf('g_{EPSP} = %g', gCars(i));
    
end

load('/projectnb/crc-nak/brpp/model-dnsim-kramer_IB/kramer_IB/CarracedoSpikes.mat')

plot(ISI_bins, ISI_dist, 'LineWidth', 2, 'Color', [0 0 0])

% xlim([min(ISI_bins) max(ISI_bins)])

box off

xlabel('Inter-Spike Interval (s)')

ylabel('Number of Occurrences')

title(sprintf('ISI Distribution, %s', name), 'Interpreter', 'none') % , Applied Current = %g', name, nanmean([data.deepRS_I_app])), 'Interpreter', 'none')

legend(my_legend)

set(gca, 'FontSize', 16)

save_as_pdf(gcf, [name, '_ISI_distributions'])

% figure
% 
% distances = [results.distance];
% 
% plot(abs(fliplr(gCars)), distances) % imagesc(abs(fliplr(I_apps)), abs(fliplr(gCars)), reshape(distance, 9, 7))
% 
% % axis xy
% 
% % xlabel('Tonic Applied Current (pA)')
% 
% xlabel('EPSP Conductance (a.u.)') % ylabel('EPSP Conductance (a.u.)')
% 
% set(gca, 'FontSize', 16)
% 
% colorbar
% 
% title(['Dot Product with Reference, Unit Norm ISI Distributions, ', name], 'Interpreter', 'none')
% 
% save_as_pdf(gcf, [name, '_ISI_distances'])