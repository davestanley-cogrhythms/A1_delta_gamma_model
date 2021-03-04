function plotSpeechPLV(name_mat, suffix)

if nargin < 2, suffix = []; end
if isempty(suffix), suffix = '_PLV_data.mat'; end

names = load(name_mat);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

if exist([name_mat(1:(end - 4)), suffix]) == 2

    PLV_data = load([name_mat(1:(end - 4)), suffix]);
    
    MRVs = PLV_data.MRVs; Nspikes = PLV_data.Nspikes; dim_order = PLV_data.dim_order;
    
else
    
    [MRVs, Nspikes, dim_order] = collectSpeechPLV(name_mat);
    
end

% permutation = [find(contains(dim_order, 'SpeechLowFreq')), find(contains(dim_order, 'gSpeech')), find(contains(dim_order, 'SentenceIndex')), 4];
% 
% MRVs = permute(MRVs, permutation); Nspikes = permute(Nspikes, permutation);

SI_dim = find(strcmp(dim_order, 'SentenceIndex'));

MRVs = squeeze(nansum(MRVs, SI_dim)); % MRVs = squeeze(nanmean(MRVs, SI_dim));

MRVs = MRVs./squeeze(nansum(Nspikes, SI_dim));

Nspikes = squeeze(nanmean(Nspikes, SI_dim));

PLV = abs(MRVs); % ((abs(MRVs).^2).*Nspikes - 1)./(Nspikes - 1);

no_sims = size(PLV, 3);

bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_bands = length(bands);

for b = 1:no_bands

    x_labels{b} = sprintf('%.2g', bands(b, 1)/1000);
    
end

y_labels = get_vary_field(vary, 'gSpeech');

figure

ha = tight_subplot(no_sims + 1, 1, [.025 .075], .06, .25);

for s = 1:no_sims
    
    axes(ha(s + 1))
    
    imagesc(PLV(:, :, s))
    
    axis xy
    
    %caxis([0 .35])
    
    if s == no_sims
        
        set(gca, 'FontSize', 12, 'XTick', 2:2:no_bands, 'XTickLabel', x_labels(2:2:no_bands),...
            'YTick', 1:4:length(y_labels), 'YTickLabel', y_labels(1:4:end))
        
        xtickangle(-90)
        
        xlabel('Channel (kHz)')
        
    else
        
        set(gca, 'XTick', [], 'YTick', []) %1:2:length(y_labels), 'YTickLabel', y_labels(1:2:end)) % 'YTick', [])
        
    end
    
    ylabel({'Input'; 'Gain'})
        
    nochange_colorbar(gca)
        
%     if s ~= no_sims
%     
%         colorbar('off')
%         
%     end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 2.5 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 2.5 8])

saveas(gcf, [name_mat(1:(end - 4)), suffix(1:(end - 4)), '.fig'])

