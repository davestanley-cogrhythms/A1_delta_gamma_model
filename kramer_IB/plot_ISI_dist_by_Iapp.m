function [data, results] = plot_ISI_dist_by_Iapp(name, data, results)

if nargin < 3, results = []; end

if nargin < 2, data = []; end

if isempty(data)
    
    if ~isempty(results)
        
        data = results;
        
    else
        
        data = dsImport(name);
    
    end
    
end

if isempty(results)
    
    results = dsAnalyze(data, @ISI_metrics);

    save([name, '_ISI_metrics.mat'], 'results', 'name')
    
end

I = [data.deepRS_I_app];

Is = unique(I);

gCars = unique([data.deepRS_gCar]);

for i = 1:length(Is)
    
    selection = I == Is(i);
    
%     dsPlot(data(selection))
%     
%     saveas(gcf, [name, sprintf('_Iapp%g', Is(i))], 'fig')
    
    [~,~] = plot_ISI_dist([name, sprintf('_Iapp%g', Is(i))], data(selection), results(selection));
    
end

angles = [results.angle];

KSstats = [results.distance];

dims = [length(gCars), length(Is)];

for i = 1:2

    dims = fliplr(dims);
    
    figure
    
    imagesc(abs(Is), abs(gCars), reshape(angles, dims))
    
    axis xy
    
    xlabel('Tonic Applied Current (pA)')
    
    ylabel('EPSP Conductance (a.u.)')
    
    set(gca, 'FontSize', 16)
    
    colorbar
    
    title(['Angle with Reference, Unit Norm ISI Distributions, ', name], 'Interpreter', 'none')
    
    save_as_pdf(gcf, [name, '_ISI_angles', num2str(i)])
    
    figure
    
    imagesc(abs(Is), abs(gCars), reshape(KSstats, dims))
    
    axis xy
    
    xlabel('Tonic Applied Current (pA)')
    
    ylabel('EPSP Conductance (a.u.)')
    
    set(gca, 'FontSize', 16)
    
    colorbar
    
    title(['Kolmogorov-Smirnov Statistic, ISI Distributions, ', name], 'Interpreter', 'none')
    
    save_as_pdf(gcf, [name, '_ISI_KSstats', num2str(i)])
    
end

