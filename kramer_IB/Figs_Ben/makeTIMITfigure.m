function makeTIMITfigure

%% Loading PLV.

plv_filename = '20-07-01/timit_20-07-01_18+6.mat';

names = load(plv_filename);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

plv_data = load([plv_filename(1:(end - 4)), '_PLV_data.mat']);

MRVs = squeeze(nansum(plv_data.MRVs.*plv_data.Nspikes, 3));

Nspikes = squeeze(nansum(plv_data.Nspikes, 3));

MRVs = MRVs./Nspikes;

PLV = ((abs(MRVs).^2).*Nspikes - 1)./(Nspikes - 1);

no_sims = size(PLV, 3);

plv_bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_plv_bands = length(plv_bands);

for b = 1:no_plv_bands

    plv_x_labels{b} = sprintf('%.2g', plv_bands(b, 1)/1000);
    
end

plv_y_labels = get_vary_field(vary, 'gSpeech');

%% Loading traces.

trace_filename = '20-07-29/timit_20-07-29_14+52.mat';

names = load(trace_filename);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

trace_bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_trace_bands = length(trace_bands);

for b = 1:no_trace_bands

    trace_y_labels{b} = sprintf('%.2g', trace_bands(b, 1)/1000);
    
end

gS = get_vary_field(vary, 'gSpeech');

SI = get_vary_field(vary, 'SentenceIndex');

tspan = sim_spec.sim_struct.tspan;

time = tspan(1):.1:tspan(2);
selected_time = time >= 1000 & time <= 3250;

data = load([trace_filename(1:(end - 4)), '_traces.mat']);

all_data = data.all_data;

PLVfig = figure;

ha1 = tight_subplot(no_sims + 1, 1, [.025 .075], .06, .075);

traceFig = figure;

ha2 = tight_subplot(no_sims + 1, 1, [.025 .075], .06, .25);

%% Plotting speech data.

figure(traceFig)
    
axes(ha1(1))

h = imagesc(time(selected_time), 1:length(trace_bands), all_data(selected_time, :, 2, 1, 2, 2)');

axis xy

colors = get(gca, 'ColorOrder');

colormap(gca, color_gradient(64, [1 1 1], .5*[1 1 1])) %colors(2, :)))
        
set(gca, 'XTick', [], 'YTick', []) % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end))

for s = 1:no_sims
    
    %% Plotting rasters.
    
    figure(traceFig)
    
    axes(ha1(s + 1))
    
    h = imagesc(time(selected_time), 1:length(trace_bands), all_data(selected_time, :, 2, s, 2, 2)');
    
    axis xy
    
    colors = get(gca, 'ColorOrder');
    
    colormap(gca, color_gradient(64, [1 1 1], .5*[1 1 1])) %colors(2, :)))
    
    set(h, 'AlphaData', 0.75)
    
    if s == no_sims
        
        set(gca, 'FontSize', 12, 'YAxisLocation', 'right', 'XTick', 1000:500:3250, 'XTickLabel', 1:.5:3.25,...
            'YTick', 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end))
        
        %xtickangle(-45)
        
        ylabel('Channel (kHz)')
        
        xlabel('Time (s)')
        
    else
        
        set(gca, 'XTick', [], 'YTick', []) % 1:2:length(trace_y_labels), 'YTickLabel', trace_y_labels(1:2:end)) % 'YTick', [])
        
        % ylabel('Channel (kHz)')
        
    end
    
    new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
    set(new_ax, 'FontSize', 12);
    
    plot_raster(new_ax, time(selected_time), all_data(selected_time, :, 2, s, 2, 1), 'k');
    
    set(new_ax, 'Visible', 'off')
    
    %% Plotting PLV.
    
    figure(PLVfig)
    
    axes(ha2(s + 1))
    
    imagesc(PLV(:, :, s))
    
    axis xy
    
    caxis([0 .35])
    
    if s == no_sims
        
        set(gca, 'FontSize', 12, 'XTick', 1:no_plv_bands, 'XTickLabel', plv_x_labels, 'YTick', 1:2:length(plv_y_labels), 'YTickLabel', plv_y_labels(1:2:end))
        
        xtickangle(-90)
        
        xlabel('Channel (kHz)')
    
        ylabel({'Input'; 'Strength'})
        
    else
        
        set(gca, 'XTick', [], 'YTick', []) % 1:2:length(plv_y_labels), 'YTickLabel', plv_y_labels(1:2:end)) % 'YTick', [])
        
    end
        
    nochange_colorbar(gca);
        
%     if s ~= no_sims
%     
%         colorbar('off')
%         
%     end
    
end

set(PLVfig, 'Units', 'inches', 'Position', 1 + [0 0 4 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 4 8])

saveas(PLVfig, 'TIMIT_traces.fig')

set(traceFig, 'Units', 'inches', 'Position', 1 + [0 0 2.5 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 2.5 8])

saveas(traceFig, 'TIMIT_PLV.fig')

end