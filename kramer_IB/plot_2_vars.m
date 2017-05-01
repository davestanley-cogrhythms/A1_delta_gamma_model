function plot_2_vars(data, var1, var2, subplot_dims)

if nargin < 4, subplot_dims = []; end

no_sims = length(data);

t = data(1).time;

variable1 = [data(:).(var1)];

variable2 = [data(:).(var2)];

if isempty(subplot_dims), subplot_dims = [no_sims, 1]; end

figure
   
ha = tight_subplot(subplot_dims(1), subplot_dims(2));

for s = 1:no_sims
    
    axes(ha(s))
    
    [ax, h1, h2] = plotyy(t, variable1(:, s), t, variable2(:, s));
    
    axis(ax, 'tight'), box off
    
    if mod(s, subplot_dims(2)) == 1
    
        ax(1).YLabel.String = var1;
    
    elseif mod(s, subplot_dims(2)) == 0
        
        ax(2).YLabel.String = var2;
        
    end
    
    if floor(s/subplot_dims(2)) == subplot_dims(1) - 1
        
        xlabel('Time (ms)')
        
    end
    
    set(h1, 'LineWidth', 1)
    
    % set(h2, 'LineWidth', 1)
    
end

