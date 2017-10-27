function plot_2_vars(data, var1, var2, mode, sub_indices, subplot_dims, subplot_direction, titles)

if nargin < 4, mode = []; end
if isempty(mode), mode = 'plotyy'; end

if nargin < 5, sub_indices = []; end
if isempty(sub_indices), sub_indices = [1 inf]; end

if nargin < 6, subplot_dims = []; end

if nargin < 7, subplot_direction = 'row'; end

if nargin < 8, titles = []; end

no_sims = length(data);

t = data(1).time;
        
sub_indices(2) = min(length(t), sub_indices(2));

variable1 = [data(:).(var1)];

variable2 = [data(:).(var2)];

if isempty(subplot_dims), subplot_dims = [no_sims, 1]; end

figure
   
ha = tight_subplot(subplot_dims(1), subplot_dims(2));

for s = 1:no_sims
    
    if strcmp(subplot_direction, 'row')
        
        subplot_index = mod(s - 1, subplot_dims(1))*subplot_dims(2) + ceil(s/subplot_dims(1));
        
    elseif strcmp(subplot_direction, 'column')
        
        subplot_index = s;
        
    end
    
    axes(ha(subplot_index))
    
    if strcmp(mode, 'plotyy')
        
        [ax, h1, h2] = plotyy(t(sub_indices(1):sub_indices(2)), variable1(sub_indices(1):sub_indices(2), s),...
            t(sub_indices(1):sub_indices(2)), variable2(sub_indices(1):sub_indices(2), s));
        
        axis(ax, 'tight'), box off
        
        if s == 1, legend({var1, var2}, 'interpreter', 'none'); end
        
        % if mod(subplot_index - 1, subplot_dims(1)) + 1 == 1
        % 
        %     ylabel(ax(1), var1, 'interpreter', 'none', 'rotation', 0) % ax(1).YLabel.String = var1;
        % 
        % elseif mod(subplot_index - 1, subplot_dims(1)) + 1 == subplot_dims(1)
        % 
        %     ylabel(ax(2), var2, 'interpreter', 'none', 'rotation', 0) % ax(2).YLabel.String = var2;
        % 
        % end
        
        if ceil(subplot_index/subplot_dims(2)) == subplot_dims(1)
            
            xlabel('Time (ms)')
            
        end
        
        set(h1, 'LineWidth', 1)
    
        set(h2, 'LineWidth', 1)
    
    elseif strcmp(mode, 'against')
        
        % plot(variable1(sub_indices(1):sub_indices(2), s), variable2(sub_indices(1):sub_indices(2), s));
        
        x = variable1(sub_indices(1):sub_indices(2), s)';
        
        y = variable2(sub_indices(1):sub_indices(2), s)';
        
        z = (1:length(x));
        
        surface([x;x],[y;y],[z;z],'facecol','no','edgecol','interp','linew',2);
        
        colormap(gca, 'cool')
        
        axis tight, box off
        
        if mod(subplot_index, subplot_dims(2)) == 1
            
            ylabel(var2, 'interpreter', 'none', 'rotation', 0)
        
        end
        
        if ceil(subplot_index/subplot_dims(2)) == subplot_dims(1), xlabel(var1, 'interpreter', 'none'), end
        
        if ~isempty(titles)
            
            title(titles{s})
            
        end
        
    end
    
end

sync_axes(ha, 'x'), sync_axes(ha, 'y')

end

