function make_delay_aggregate

load('PLV_estimate.mat')

no_models = length(PLV_estimate{1});

labels = {'delay', 'PLV_estimate'};

for measures = 1:2
    
    figure
    
    for m = 1:no_models
        
        subplot(no_models, 1, m)
        
        if measures == 1
            
            loglog(1000./frequencies, double(PLV_estimate{measures}{m})')
            
            axis tight
            
        else
        
        pcolor(frequencies, stims*.98/1000, double(PLV_estimate{measures}{m})')
        
        if measures == 1, caxis([0 750]), end
        
        hold on
        
        plot([7, 7], [min(stims), max(stims)], 'm', 'LineWidth', 2)
        
        axis xy
        
        shading interp
        
        if m == no_models
            
            xlabel('Frequencies (Hz)')
            
            ylabel('Input/Pulse (nA)')
            
            set(gca, 'YAxisLocation', 'right', 'FontSize', 12)
        
            cbar = nochange_colorbar(gca);
            
            cbar.Location = 'west';
            
        else
            
            set(gca, 'XTick', [], 'YTick', [])
            
        end
        
        end
        
    end
    
    set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 1.5 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 1.5 8])
    
    saveas(gcf, [labels{measures}, '_aggregate.fig'])
    
    print(gcf, '-painters', '-depsc', '-r600', [labels{measures}, '_aggregate.eps'])
    
end

end