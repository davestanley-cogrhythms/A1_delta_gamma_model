function plot_2_vars(data, name, var_names, mode, sub_indices, subplot_dims, subplot_direction, titles)

if nargin < 4, mode = []; end
if isempty(mode), mode = 'plotyy'; end

if nargin < 5, sub_indices = []; end
if isempty(sub_indices), sub_indices = [1 inf]; end

if nargin < 6, subplot_dims = []; end

if nargin < 7, subplot_direction = []; end
if isempty(subplot_direction), subplot_direction = 'row'; end

if nargin < 8, titles = []; end

no_sims = length(data);

t = data(1).time;
        
sub_indices(2) = min(length(t), sub_indices(2));

num_vars = length(var_names);
variables = cell(num_vars, 1);

for n = 1:num_vars
    variables{n} = {data(:).(var_names{n})};
    if ~strcmp(mode, 'raster')
        if size(data(1).(var_names{n}), 2) == 1
            variables{n} = cell2mat(variables{n});
        elseif no_sims ~= 1
            variables{n} = cell2mat(cellfun(@(x) nanmean(x, 2), variables{n}, 'unif', 0));
        end
    end
end

if no_sims == 1, no_sims = max(size(variables{1}, 2), size(variables{2}, 2)); end

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
    
    switch mode
        
        %% Mode 'plotyy'.
        
        case 'plotyy'
            
            [ax, h1, h2] = plotyy(t(sub_indices(1):sub_indices(2)), variables{1}(sub_indices(1):sub_indices(2), subplot_index),...
                t(sub_indices(1):sub_indices(2)), variables{2}(sub_indices(1):sub_indices(2), subplot_index));
            
            axis(ax, 'tight'), box off
            
            colors = get(gca, 'ColorOrder');
            
            legend_handles(1) = h1; legend_handles(2) = h2;
            
            for v = 3:num_vars
                
                new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
                set(new_ax, 'FontSize', 12);
                
                h3 = plot(t(sub_indices(1):sub_indices(2)), variables{v}(sub_indices(1):sub_indices(2), subplot_index));
                
                axis(new_ax, 'tight')
                
                set(h3, 'Color', colors(v, :))
                
                set(new_ax, 'Visible', 'off')
                
                legend_handles(end + 1) = h3;
                
            end
            
            if s == 1, legend(legend_handles, var_names, 'interpreter', 'none'); end
            
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
            
            %         if ~isempty(titles)
            %
            %             if length(titles) == subplot_dims(1)
            %
            %                 if strcmp(suplot_direction, 'rows')
            %
            %                     if s <= subplot_dims(1)
            %
            %                         ylabel(titles{ceil(s/subplot_dims(1))}, 'rotation', 0) % title(titles{s})
            %
            %                     end
            %
            %                 elseif strcmp(subplot_direction, 'column')
            %
            %                     if mod(s, subplot_dims(1)) == 1
            %
            %                         ylabel(titles{s}, 'rotation', 0) % title(titles{s})
            %
            %                     end
            %
            %                 end
            %
            %             elseif length(titles) == subplot_dims(2)
            %
            %                 if strcmp(subplot_direction, 'rows')
            %
            %                     if mod(s, subplot_dims(1)) == 1
            %
            %                         title(titles{ceil(s/subplot_dims(1))})
            %
            %                     end
            %
            %                 elseif strcmp(subplot_direction, 'column')
            %
            %                     if s <= subplot_dims(2)
            %
            %                         title(titles{s})
            %
            %                     end
            %
            %                 end
            %
            %             else
            %
            %                 title(titles{s})
            %
            %             end
            %
            %         end
            
            %% Mode 'raster'.
            
        case 'raster'
            
            h = imagesc(t(sub_indices(1):sub_indices(2)), size(variables{2}{subplot_index}, 2),...
                variables{2}{subplot_index}(sub_indices(1):sub_indices(2), :)');
            
            colors = get(gca, 'ColorOrder');
            
            colormap(gca, color_gradient(64, [1 1 1], colors(2, :)))
            
            set(h, 'AlphaData', 0.5)
            
            %legend_handles(1) = h;
            
            for v = 3:num_vars
                
                new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
                set(new_ax, 'FontSize', 12);
            
                h = imagesc(t(sub_indices(1):sub_indices(2)), size(variables{v}{subplot_index}, 2),...
                    variables{v}{subplot_index}(sub_indices(1):sub_indices(2), :)');
                
                axis(new_ax, 'tight', 'xy')
                
                colormap(gca, color_gradient(64, [1 1 1], colors(v, :)))
                
                set(h, 'AlphaData', 0.5)
                
                set(new_ax, 'Visible', 'off')
                
            end
            
            new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
            set(new_ax, 'FontSize', 12);
            
            plot_raster(new_ax, t(sub_indices(1):sub_indices(2)), variables{1}{subplot_index}(sub_indices(1):sub_indices(2), :));
            
            %axis(new_ax, 'tight', 'xy')
            
            box off
                
            set(new_ax, 'Visible', 'off')
            
            if ceil(subplot_index/subplot_dims(2)) == subplot_dims(1)
                
                xlabel('Time (ms)')
                
            end
            
            %% Mode 'against'.
            
        case 'against'
            
            % plot(variables{1}(sub_indices(1):sub_indices(2), s), variables{2}(sub_indices(1):sub_indices(2), s));
            
            x = variables{1}(sub_indices(1):sub_indices(2), s)';
            
            y = variables{2}(sub_indices(1):sub_indices(2), s)';
            
            z = (1:length(x));
            
            surface([x;x],[y;y],[z;z],'facecol','no','edgecol','interp','linew',2);
            
            colormap(gca, 'cool')
            
            axis tight, box off
            
            if mod(subplot_index, subplot_dims(2)) == 1
                
                ylabel(var2, 'interpreter', 'none', 'rotation', 0)
                
            end
            
            if ceil(subplot_index/subplot_dims(2)) == subplot_dims(1), xlabel(var1, 'interpreter', 'none'), end
            
            if ~isempty(titles)
                
                if length(titles) == subplot_dims(1)
                    
                    if s <= subplot_dims(1)
                        
                        ylabel(titles{s}, 'rotation', 0) % title(titles{s})
                        
                    end
                    
                elseif length(titles) == subplot_dims(2)
                    
                    if mod(s, subplot_dims(2)) == 1
                        
                        title(titles{s})
                        
                    end
                    
                else
                    
                    title(titles{s})
                    
                end
                
            end
            
    end
    
end

% sync_axes(ha, 'x')

sync_axes(ha, 'y')

end

