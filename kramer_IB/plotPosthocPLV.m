function plotPosthocPLV(sim_name)

%% Loading PLV.

PLV_struct = load([sim_name, '_PLV_variables.mat']);

plv = PLV_struct.plv;

plv_size = size(plv);

plv = reshape(plv, [prod(plv_size(1:2)), plv_size(3)]);

model = PLV_struct.models;
models = unique(model(:));
model = reshape(model, [prod(plv_size(1:2)), plv_size(3)]);

predictors = PLV_struct.predictors;

gS = predictors(:, 1);
gSs = unique(gS);
gS = reshape(gS, [prod(plv_size(1:2)), plv_size(3)]);

channel = predictors(:, 2);
channels = unique(channel);
channel = reshape(channel, [prod(plv_size(1:2)), plv_size(3)]);

%% Averaging PLV.

meanPLV = nan(length(gSs), length(channels), length(models));

for m = 1:length(models)
    
    for c = 1:length(channels)
        
        for g = 1:length(gSs)
            
            this_indicator =  channel(:, m) == channels(c) & gS(:, m) == gSs(g);
            
            meanPLV(g, c, m) = nanmean(plv(this_indicator, m));
            
        end
        
    end
    
end

%% Plotting PLV.

figure

ha = tight_subplot(no_sims + 1, 1, [.025 .075], .06, .25);

for m = 1:length(models)
    
    axes(ha(m + 1))
    
    imagesc(meanPLV(:, :, m))
    
    axis xy
    
    caxis([0 .35])
    
    if s == no_sims
        
        set(gca, 'FontSize', 12, 'XTick', 1:16:length(channels), 'XTickLabel', channels(1:16:end), 'YTick', 1:2:length(gSs), 'YTickLabel', gSs(1:16:end))
        
        xtickangle(-90)
        
        xlabel('Channel (kHz)')
    
        ylabel({'Input'; 'Strength'})
        
    else
        
        set(gca, 'XTick', [], 'YTick', []) % 1:2:length(plv_y_labels), 'YTickLabel', plv_y_labels(1:2:end)) % 'YTick', [])
        
    end
        
    nochange_colorbar(gca);

end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 2.5 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 2.5 8])

saveas(gcf, [sim_name, '_posthocPLV.fig'])
    
print(gcf, '-painters', '-depsc', '-r600', [sim_name, '_posthocPLV.eps'])

end



