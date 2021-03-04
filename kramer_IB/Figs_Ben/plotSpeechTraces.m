function plotSpeechTraces(name_mat)

names = load(name_mat);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_bands = length(bands);

for b = 1:no_bands

    x_labels{b} = sprintf('%.2g kHz', bands(b, 1)/1000);
    
end

gS = get_vary_field(vary, 'gSpeech');

SI = get_vary_field(vary, 'SentenceIndex');

tspan = sim_spec.sim_struct.tspan;

time = tspan(1):.1:tspan(2);
selected_time = time >= 1000 & time <= 3250;

data = load([name_mat(1:(end - 4)), '_traces.mat']);

all_data = data.all_data;

subplot_dims = [length(names), length(gS)];

for sindex = 1:length(SI)
    
    figure
    
    ha = tight_subplot(length(gS), length(names));
    
    for n = 1:length(names)
        
        for gspeech = 1:length(gS)
            
            subplot_index = (gspeech - 1)*length(names) + n;
            
            axes(ha(subplot_index))
            
            h = imagesc(time(selected_time), length(bands), flipud(all_data(selected_time, :, gspeech, n, sindex, 2)'));
            
            colors = get(gca, 'ColorOrder');
            
            colormap(gca, color_gradient(64, [1 1 1], .5*[1 1 1])) %colors(2, :)))
            
            set(h, 'AlphaData', 0.75)
            
            %xlim([1 4]*10^4)
            
            if gS(gspeech) > 0
                
                new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
                set(new_ax, 'FontSize', 12);
                
                plot_raster(new_ax, time(selected_time), all_data(selected_time, :, gspeech, n, sindex, 1), 'k');
                
                set(new_ax, 'Visible', 'off')
                
            end
            
            %xlim([1 4]*10^4)
            
            %     if s ~= no_sims
            %
            %         colorbar('off')
            %
            %     end
            
        end
        
    end
    
    set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 16 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 16 8])
    
    saveas(gcf, [name_mat(1:(end - 4)), sprintf('_SI_%g_traces.fig', SI(sindex))])
    
end

