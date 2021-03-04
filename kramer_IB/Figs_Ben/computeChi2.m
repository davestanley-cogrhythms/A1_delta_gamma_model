function computeChi2(sim_name, varargin)

%% Defaults & arguments.

if strcmp(varargin{1}, 'suffix')
    
    label = varargin{2};
    
else

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

end

%% Loading histograms.

hists_mat = load('midsylBPhistograms.mat');

hists = hists_mat.hists;

midsyl_observed = hists(:, 1);

midsyl_proportions = hists(:, 1)./sum(hists(:, 1));

all_hists_mat = load([sim_name, label, '_BPhistograms.mat']);

all_hists = all_hists_mat.all_hists;

gSs = all_hists_mat.gSs;

Sfreqs = all_hists_mat.Sfreqs;

names = all_hists_mat.names;

for n = 1:length(names)
    
    for g = 1:length(gSs)
        
        for s = 1:length(Sfreqs)
            
            observed = all_hists(:, g, s, n, 1);
            
            observed_proportions = all_hists(:, g, s, n, 2);
            
            mse(g, s, n) = sqrt(sum((observed - midsyl_observed).^2))/sqrt(sum(midsyl_observed.^2));
            
            mseProportion(g, s, n) = sqrt(sum((observed_proportions - midsyl_proportions).^2))/sqrt(sum(midsyl_proportions.^2));
            
            expected = sum(observed)*midsyl_proportions;
            
            chi2stat(g, s, n) = sum(((observed - expected).^2)./expected);
            
            df = length(expected) - 1;
            
            Pval(g, s, n) = 1 - chi2cdf(chi2stat(g, s, n), df);
            
        end
        
    end
    
end

Pval = Pval*11*8*6;

save([sim_name, label, '_BPchi2.mat'], 'chi2stat', 'Pval', 'gSs', 'Sfreqs', 'names')

plotChi2(chi2stat, names, gSs, Sfreqs)

saveas(gcf, [sim_name, label, '_BPchi2.fig'])

plotChi2(Pval, names, gSs, Sfreqs)

saveas(gcf, [sim_name, label, '_BPchi2_Pval.fig'])

plotChi2(mse, names, gSs, Sfreqs)

saveas(gcf, [sim_name, label, '_BPchi2_mse.fig'])

plotChi2(mseProportion, names, gSs, Sfreqs)

saveas(gcf, [sim_name, label, '_BPchi2_mseProp.fig'])

end

function plotChi2(input, names, gSs, Sfreqs)

figure

cmap = colormap('hot');

crange = [all_dimensions(@min, input), all_dimensions(@max, input)];

for n = 1:length(names)
    
    subplot(length(names), 1, n)
    
    imagesc(input(:, :, n))
    
    axis xy
    
    caxis(crange)

    colormap(flipud(cmap))
    
    if n == length(names)
        
        x_lims = xlim(gca);
        
        x_interval = range(x_lims)/size(input, 2);
        
        x_ticks = (min(x_lims):x_interval:max(x_lims)) + x_interval/2;
        
        set(gca, 'FontSize', 12, 'XTick', x_ticks, 'XTickLabel', Sfreqs)
        
        xtickangle(-45)
        
        ylabel('Input Gain')
        
        y_lims = ylim(gca);
        
        y_interval = range(y_lims)/size(input, 1);
        
        y_ticks = (min(y_lims):(2*y_interval):max(y_lims)) + y_interval/2;
        
        set(gca, 'YTick', y_ticks, 'YTickLabel', gSs(1:2:end))
        
        nochange_colorbar(gca)
        
    else
        
        set(gca, 'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', [])
        
    end
    
end

end






