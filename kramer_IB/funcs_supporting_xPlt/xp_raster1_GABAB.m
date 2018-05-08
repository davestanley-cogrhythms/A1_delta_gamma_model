

function hxp = xp_raster1_GABAB (xp, op)
    % xp must be 1x1 (e.g. 0 dimensional)
    
    hxp = struct;
    
    if nargin < 2
        op = struct;
    end
    
    if isempty(op); op = struct; end;
    
    op = struct_addDef(op,'args',{});
    op = struct_addDef(op,'imagesc_zlims',[]);
    op = struct_addDef(op,'lineplot_ylims',[]);
        % These are the min and max limits associated with the lineplots
        % (GABA A and B). If left empty, they will be auto-estimated to the
        % min and max of the data to be plotted. This option is useful for
        % ensuring a uniform min and max across multiple subplots
    op = struct_addDef(op,'show_imagesc',false);             % Imagesc background showing GABA B conductance as shading
    op = struct_addDef(op,'show_lineplot_FS_GABA',false);       % Line plot with just FS conductance
    op = struct_addDef(op,'show_lineplot_NG_GABA',false);      % Line plot with just NG conductances
    op = struct_addDef(op,'show_lineplot_NGFS_GABA',false);      % Line plot with both NG and FS conductances
    
    
    xlims = op.xlims;
    ylims = op.ylims;
    imagesc_zlims = op.imagesc_zlims;
    lineplot_ylims = op.lineplot_ylims;
    show_imagesc = op.show_imagesc;
    show_lineplot_FS_GABA = op.show_lineplot_FS_GABA;
    show_lineplot_NG_GABA = op.show_lineplot_NG_GABA;
    show_lineplot_NGFS_GABA = op.show_lineplot_NGFS_GABA;

    % Squeeze out any 1D placeholder axes ("Dim X"). These can be created
    % by the unpacking operation above. 
    xp = xp.squeezeRegexp('Dim');
    
    % Fix labels
    xp.meta.dynasim.labels{strcmp(xp.meta.dynasim.labels,'IB_V')} = 'NG_V';
    xp.meta.dynasim.labels{1} = 'IB_V';     % Cheap hack - reset first value in labels so that it gets the correct population. Otherwise, it will assume NG cells.
    
    % Convert xp to DynaSim data struct
    data = dsMdd2ds(xp);
    
    % Remove NaNs introduced due to packing
    for i = 1:length(data)
        labels = data(i).labels;
        labels_sans_time = labels(~strcmp(labels,'time'));

        for j = 1:length(labels_sans_time)
            d = data(i).(labels_sans_time{j});
            ind = all(~isnan(d),1);
            d=d(:,ind);
            data(i).(labels_sans_time{j}) = d;
        end
    end
    
    % Feed into original PlotData command, making sure it doesn't generate
    % new figures (rather, should produce it in the current subplot)
    
    % Hack to get working with dsPlot bug being unable to accept strings
    % right now. This issue results around line 200 (seems to have to
    % dowith the new code for detecting co-varied params in dsPlot).
    if isfield(data(1),'varied')
        varied = data(1).varied;
        for i = 1:length(data);
            for j = 1:length(varied)
                if ischar(data(i).(varied{j}))
                    temp = data(i).(varied{j});
                    ind = strfind(temp,'_');
                    temp = str2num(temp(1:ind-1));
                    if isempty(temp); temp = 0; end
                    data(i).(varied{j}) = temp;
                end
            end
        end
    end
    
    %% Plot background colour
    
    Ncells = size(data(1).IB_V,2);

    % Plot Imagesc stuff
    mygrey = gray;
%     mygrey = mygrey(round(end/2):end,:);
    mygrey = flipud(mygrey);
    
    % Mean and repmat background color data.
    d = data.IB_NG_GABAall_gTH;
    if max(d(:)) - min(d(:)) > 0 && show_imagesc   % Only do color plot if the data is not all zeros
        d = mean(d,2);
        d = repmat(d,[1,Ncells]);
        data.IB_NG_GABAall_gTH = d;
        dsPlot2(data,'plot_type','imagesc','variable','GABAall_gTH','population','IB','ColorMap',mygrey,'lock_gca',true,'zlims',imagesc_zlims);
        caxis_scaling_factor = 1.2;     % Make the axis limits go a bit above max value of data, to avoid coloring things pure black
        mycaxis = caxis;
        mycaxis(2) = mycaxis(2)*caxis_scaling_factor;
        caxis(mycaxis);
        
    end
    
    
    hold on;
    hxp.hcurr = dsPlot(data,'plot_type','raster','lock_gca',true,'suppress_textstring',1);
    
    mylims = ylim;

    
    % Plot GABA A    
    % Mean and scale GABA A trace data
    if show_lineplot_FS_GABA
        x = data.IB_FS_GABAA_gTH;

        x = mean(x,2);
        if isempty(lineplot_ylims)
            maxx = max(x(:));
            minx = min(x(:));
        else
            minx = lineplot_ylims(1);
            maxx = lineplot_ylims(2);
        end
        if (maxx - minx) > 0
            max_y_axis_range = 1/2;             % Max fractional range of axis to which the data is scaled
            x = (x - minx) ./ (maxx - minx);
            x = x * Ncells * max_y_axis_range + mylims(1);
            data.IB_FS_GABAA_gTH = x;

            subplot_options.suppress_legend = true;
            dsPlot2(data,'plot_type','waveform','variable','GABAA_gTH','population','IB','LineWidth',2,'ylims',mylims,'lock_gca',true,'subplot_options',subplot_options);
        end
    end
    
    
    % Plot NG GABA only
    if show_lineplot_NG_GABA
        x_NG_GABA = data.IB_NG_GABAall_gTH;

        x_NG_GABA = mean(x_NG_GABA,2);
        if isempty(lineplot_ylims)
            maxx = max(x_NG_GABA(:));
            minx = min(x_NG_GABA(:));
        else
            minx = lineplot_ylims(1);
            maxx = lineplot_ylims(2);
        end
        if (maxx - minx) > 0
            % Scale x_NG_GABA
            max_y_axis_range = 1.0;             % Max fractional range of axis to which the data is scaled
            x_NG_GABA = (x_NG_GABA - minx) ./ (maxx - minx);
            x_NG_GABA = x_NG_GABA * Ncells * max_y_axis_range + mylims(1);
            data.IB_NG_GABAall_gTH = x_NG_GABA;

            subplot_options.suppress_legend = true;
            dsPlot2(data,'plot_type','waveform','variable','/GABAall_gTH/','population','IB','LineWidth',2,'ylims',mylims,'lock_gca',true,'subplot_options',subplot_options);
        end
    end
    
    
    % Plot GABA A, GABA B, and sum
    % /AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/
    if show_lineplot_NGFS_GABA
        x_total = data.IB_THALL_GABA_gTH;
        x_NG_GABA = data.IB_NG_GABAall_gTH;

        x_total = mean(x_total,2);
        x_NG_GABA = mean(x_NG_GABA,2);
        if isempty(lineplot_ylims)
            maxx = max(x_total(:));
            minx = min(x_total(:));
        else
            minx = lineplot_ylims(1);
            maxx = lineplot_ylims(2);
        end
        if (maxx - minx) > 0
            
            % Scale x_total
            max_y_axis_range = 1.0;             % Max fractional range of axis to which the data is scaled
            x_total = (x_total - minx) ./ (maxx - minx);
            x_total = x_total * Ncells * max_y_axis_range + mylims(1);
            data.IB_THALL_GABA_gTH = x_total;
            
            % Scale x_NG_GABA
            x_NG_GABA = (x_NG_GABA - minx) ./ (maxx - minx);
            x_NG_GABA = x_NG_GABA * Ncells * max_y_axis_range + mylims(1);
            data.IB_NG_GABAall_gTH = x_NG_GABA;

            subplot_options.suppress_legend = true;
            dsPlot2(data,'plot_type','waveform','variable','/THALL_GABA_gTH|GABAall_gTH/','population','IB','LineWidth',2,'ylims',mylims,'lock_gca',true,'subplot_options',subplot_options);
        end
    end
    
    if ~isempty(xlims); xlim(xlims); end
    if ~isempty(ylims); ylim(ylims); end

end


