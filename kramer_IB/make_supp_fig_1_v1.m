function make_supp_fig_1_v1(data)

name = 'kramer_IB_23_14_31.87';

if isempty(data), data = dsImport(['Figs_Ben/20-01-09/', name]); end

Iapp = [data.deepRS_I_app];
Iapps = sort(abs(unique(Iapp)));
PPstim = [data.deepRS_PPstim];
PPfreq = [data.deepRS_PPfreq];
PPfreqs = unique(PPfreq);

selected = PPstim == -1 & Iapp >= -9 & PPfreq <= 12;

data = data(selected);

var1 = 'deepRS_V';

var2 = 'deepRS_iPeriodicPulsesBen_input';

sub_indices = [4 5]*10^4;

subplot_dims = [4 4];

no_sims = length(data);

t = data(1).time;
        
sub_indices(2) = min(length(t), sub_indices(2));

variable1 = [data(:).(var1)];

variable2 = [data(:).(var2)];

figure
   
% ha = tight_subplot(subplot_dims(1), subplot_dims(2));

for s = 1:no_sims
    
    subplot_index = mod(s - 1, subplot_dims(1))*subplot_dims(2) + ceil(s/subplot_dims(1));
    
    subplot(subplot_dims(1), subplot_dims(2), subplot_index) % axes(ha(subplot_index))
    
    [ax, h1, h2] = plotyy(t(sub_indices(1):sub_indices(2)), variable1(sub_indices(1):sub_indices(2), s),...
        t(sub_indices(1):sub_indices(2)), variable2(sub_indices(1):sub_indices(2), s));
    
    axis(ax, 'tight'), box off
    
    set(ax, 'YTick', [])
    set(ax(1), 'YColor', [0 0 0])
    set(ax(2), 'YColor', [1 1 1])
    
    if s == 1, legend({'Voltage', 'Input'}, 'interpreter', 'none'); end
    
    if ceil(subplot_index/subplot_dims(2)) == subplot_dims(1)
        
        xlabel('Time (ms)')
        
    end
    
    set(h1, 'LineWidth', 2, 'Color', 'k')
    
    set(h2, 'LineWidth', 1, 'Color', 'r')
    
    if subplot_index <= subplot_dims(1)
        
        title(sprintf('I_{app} = %g', Iapps(subplot_index)))
        
    end
    
    if subplot_index <= (subplot_dims(2) - 1)*subplot_dims(1)
        
        set(ax, 'XTick', [])
        
    else
        
        set(ax, 'XTick', [4 4.2 4.4 4.6 4.8 5]*10^3, 'XTickLabel', [0 0.2 0.4 0.6 0.8 1]*10^2)
        
    end
    
    if s <= subplot_dims(2)
       
        ylabel(sprintf('%g Hz Input', PPfreqs(s)))
        
    end
    
end

% sync_axes(ha, 'y')

saveas(gcf, [name, '_supp_fig_1_v1.fig'])

end