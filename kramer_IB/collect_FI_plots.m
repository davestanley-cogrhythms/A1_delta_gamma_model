linenames = {'FI curve', 'delta (1-4 Hz)', 'theta (4-8 Hz)', 'theta in delta'};
linecolors = [0 0 0; 0 1 0; .75 0 .75; 1 .9 0];

curvenames = {'IBT', 'IBT_gKCa', 'CBT'};
curvestyles = {':k', '--k', 'k'};

fifigure = figure;

specfigure = figure;

h = cell(2, 1);
[h{1}, h{2}] = deal(nan(3, 1));

for c = 1:length(curvenames)
    
    curvefigure = open([curvenames{c}, '_FI_plot.fig']);
    
    figObjs = get(curvefigure, 'Children');
    mylegend = figObjs(1).String;
    lineObjs = get(figObjs(2), 'Children');
    
    for l = 1:length(linenames)
        
        line_index = find(strcmp(linenames{l}, mylegend));
        
        x = lineObjs(end - line_index + 1).XData;
        y = lineObjs(end - line_index + 1).YData;
        
        inset = x >= 6 & x <= 12;
        
        if l == 1
            
            figure(fifigure)
            
            h{1}(c) = plot(x, y, curvestyles{c}, 'Color', linecolors(l, :), 'LineWidth', 3);
            
            hold on
            
            figure(specfigure)
            
            plot(x(inset), y(inset), curvestyles{c}, 'Color', linecolors(l, :), 'LineWidth', 3)
            
            hold on
        
        else
            
            figure(specfigure)
            
            plot(x(inset), y(inset), 'w', 'LineWidth', 3)
            
            if c == 3
            
                h{2}(l - 1) = plot(x(inset), y(inset), curvestyles{c}, 'Color', linecolors(l, :), 'LineWidth', 3);
            
            else
               
                plot(x(inset), y(inset), curvestyles{c}, 'Color', linecolors(l, :), 'LineWidth', 3)
                
            end
            
        end
        
    end
    
end

figures = [fifigure, specfigure];

mylegends = {{'NT', 'NT w/ K_{Ca}', 'ST'}, {'\delta', '\theta', '\delta-nested \theta'}};

locations = {'North', 'Northwest'};

positions = [0 0 10 10; 0 0 5 3];

titles = {'collected_FI_curves', 'collected_FI_curves_inset'};

for f = 1:2
    
    figure(figures(f))
    
    box off
    
    axis tight
    
    set(gca, 'YAxisLocation', 'right', 'FontSize', 16)
    
    if f == 1
        
        xlabel('Applied Current', 'FontSize', 16)
        
        ylabel('Frequency (Hz)', 'FontSize', 16)
        
    end
    
    legend(h{f}, mylegends{f}{:}, 'FontSize', 16, 'Location', locations{f})
    
    set(gcf, 'Units', 'inches', 'PaperUnits', 'inches',...
        'Position', positions(f, :), 'PaperPosition', positions(f, :))
    
    saveas(gcf, [titles{f}, '.fig'])
    
    print(gcf, '-dpdf', '-r600', [titles{f}, '.pdf'])
    
    print(gcf, '-deps', '-r600', [titles{f}, '.eps'])
    
end