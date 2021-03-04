function plotAllVPdist(sim_name, vp_norm) % synchrony_window, vpnorm, 

thresholds = fliplr([.667, .6, .55, .5, .45, .4, .333]);

sum_windows = 25:5:75;

sim_struct = load(sim_name);

names = sim_struct.names;

suffix = sprintf('_vpnorm%d', vp_norm); 

%% Loading vpdist measure.

all_vpdist_mat = load(sprintf('%s_all_vpdist_norm_%d.mat', sim_name, vp_norm));

vpdist_fields = fieldnames(all_vpdist_mat);

numeric_fields = zeros(size(vpdist_fields));

for f = 1:length(vpdist_fields)
    
    numeric_fields(f) = isnumeric(all_vpdist_mat(1).(vpdist_fields{f}));
    
end

for f = 1:length(vpdist_fields)
    
    if numeric_fields(f)
        
        command = sprintf('%s = fill_struct_empty_field(all_vpdist_mat, ''%s'', nan);', vpdist_fields{f}, vpdist_fields{f});
        
        eval((command));
        
    end
    
end

%% Plotting vpdist.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

rows = length(sum_windows); columns = length(thresholds); % rows = length(names); % columns = 1;

for m = 1:length(model_names)
    
    figure
    
    ha = tight_subplot(rows, columns, [.025, .025], [.1, .05], [.15, .175]);
    
    gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));
    
    gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);
    
    model_vpdist = log(all_vpdist(:, :, :, :, m));
    
    vpdist_range = [all_dimensions(@min, model_vpdist(:, :, :, :)), all_dimensions(@max, model_vpdist(:, :, :, :))];
    
    for t = 1:length(thresholds)
        
        for s = 1:length(sum_windows)
            
            axes(ha((s - 1)*length(thresholds) + t))
            
            imagesc(Sfreqs, gSs, model_vpdist(:, :, s, t)) % 1./model_vpdist(:, :, m))
            
            cmap = colormap('parula');
            
            colormap(gca, flipud(cmap))
            
            axis xy
            
            caxis(sort(vpdist_range)) % sort(1./vpdist_range))
            
            thresh_label = sprintf('r_{thresh} = %.2g', thresholds(t));
            
            sumwin_label = sprintf('w_s = %d', sum_windows(s));
                
            set(gca, 'YTick', [], 'XTick', [])
            
            if t == 1
                
                ylabel(sumwin_label, 'Rotation', 45)
                
                if s == length(sum_windows)
                    
                    if numel(model_vpdist(:, :, s, t)) > 1
                        
                        x_lims = xlim;
                        
                        x_ticks = (x_lims(1):2*diff(x_lims)/length(Sfreqs):x_lims(2)) + diff(x_lims)/(2*length(Sfreqs));
                        
                        set(gca, 'Ytick', gSs(2:2:end), 'YTickLabel', gSs(2:2:end),...
                            'XTick', x_ticks, 'XTickLabel', round(Sfreqs/1000, 2))
                        
                        xtickangle(45)
                        
                        xlabel({'Input Center Freq. (kHz)'; thresh_label}, 'Rotation', 45)
                        
                        ylabel({sumwin_label; 'Input Gain'}, 'Rotation', 45)
                        
                    else
                        
                        xlabel(thresh_label, 'Rotation', 45)
                        
                        ylabel(sumwin_label, 'Rotation', 45)
                        
                    end
                    
                end
                
            elseif s == length(sum_windows)
                
                xlabel(thresh_label, 'Rotation', 45)
                
            elseif t == length(thresholds) && s == 1
                
                nochange_colorbar(gca)
                
            end    
            
        end
        
    end
    
    set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 9 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 9 8])
    
    figure_name = [sim_name, '_', model_names{m}, suffix];
    
    saveas(gcf, [figure_name, '.fig'])
    
    print(gcf, '-painters', '-depsc', '-r600', [figure_name, '.eps'])
    
end

end