

function hxp = xp_subplot_grid_PPStim (xp, op, xpp)


    % % Example code
    % dsPlot2(data,'population','IB','variable','iPeriodicPulsesiSYN_s','plot_type','imagesc','ColorMap',flipud(gray),'subplot_handle',@(x,y) xp_subplot_grid_PPStim(x,y,xpp))
    % 
    % xpp = xp.axisSubset('variables','iPeriodicPulsesiSYN_s');
    % xpp = xpp.squeezeRegexp('variables');
    % xpp.printAxisInfo
    % 
    % dsPlot2(data,'population','IB','plot_type','imagesc','subplot_handle',@(x,y) xp_subplot_grid_PPStim(x,y,xpp))



	% This handles 1D or 2D xp data. For 3D data see xp_subplot_grid3D.
    % xpp stores information about the periodic pulse train
    hxp = struct; 
    
    if nargin < 2
        op = struct;
    end
    
    if isempty(op); op = struct; end;
    
    op = struct_addDef(op,'transpose_on',0);
    op = struct_addDef(op,'display_mode',0);
    op = struct_addDef(op,'subplotzoom_enabled',1);
    op = struct_addDef(op,'legend1',[]);
    op = struct_addDef(op,'do_colorbar',false);
    op = struct_addDef(op,'max_legend',20);
    op = struct_addDef(op,'force_rowvect',false);
    op = struct_addDef(op,'zlims',[]);
    op = struct_addDef(op,'autosuppress_interior_tics',false);
    op = struct_addDef(op,'subplot_grid_handle',[]);        % Plot ontop of existing subplot handle (using hold on) instead of creating new one
    op = struct_addDef(op,'suppress_subplot',false);        % Turns off creating new subplot
    op = struct_addDef(op,'suppress_legend',false);         % Turns off showing legend
    op = struct_addDef(op,'show_PP_ticks',true);
    op = struct_addDef(op,'suppress_PP_ticks_columns',false);
            % Display_mode: 0-Just plot directly
                          % 1-Plot as an image (cdata)
                          % 2-Save to a figure file 
                          
    transpose_on = op.transpose_on;
    display_mode = op.display_mode;
    subplotzoom_enabled = op.subplotzoom_enabled;
    legend1 = op.legend1;
    do_colorbar = op.do_colorbar;
    zlims = op.zlims;               % This might be used for setting the colorbar limits (clims), but cannot get it working with subplot_grid
    autosuppress_interior_tics = op.autosuppress_interior_tics;
    subplot_grid_handle = op.subplot_grid_handle;
    suppress_subplot = op.suppress_subplot;
    suppress_legend = op.suppress_legend;
    show_PP_ticks = op.show_PP_ticks;
    suppress_PP_ticks_columns = op.suppress_PP_ticks_columns;
    
    
    if verLessThan('matlab','8.4') && display_mode == 1; warning('Display_mode==1 might not work with earlier versions of MATLAB.'); end
    if transpose_on && ismatrix(xp)
        xp = xp.transpose;
    elseif transpose_on && ~ismatrix(xp.data)
        error('xp must be a matrix (e.g. ndims < 3) in order to use transpose');
    end
    
    if isrow(xp.data) && op.force_rowvect
        xp = xp.transpose;
    end
    
    % Remove underscores from legend1
    if iscellstr(legend1)
        legend1b = cellfunu(@(s) strrep(s,'_',' '),legend1);
    else
        legend1b = legend1;
    end
    
    % Parameters
    %subplot_grid_options = {'no_zoom'};
    subplot_grid_options = {};
    
    sz = size(xp);
    
    
    % % % Arrange axes so that the MDD object containing our ticks
    % information (xpp) aligns with the object we're actually plotting.
    xp_temp = unifyAxes(xp,xpp);        % Add extra axes from xpp onto xp. This will define the final ordering that we want.
    xpp = unifyAxes(xpp,xp_temp);       % Add any axes xpp is missing
    xpp = alignAxes(xpp,xp_temp);       % Perform the alignment. This makes xpp ordering follow xp_temp.
    clear xp_temp
    
    if ndims(xp.data) <= 2
        N1 = sz(1);
        N2 = sz(2);
        
        
            if display_mode == 1 
                h0 = gcf; ha0 = gca;
                h1 = figure('visible','off');
            else
                %figure;
            end

            if isempty(subplot_grid_handle) && ~suppress_subplot
                if subplotzoom_enabled
                    hxp.hcurr = subplot_grid(N1,N2,subplot_grid_options{:});
                else
                    hxp.hcurr = subplot_grid(N1,N2,'no_zoom',subplot_grid_options{:});
                end
            else
                hxp.hcurr = subplot_grid_handle;
            end
            
            c=0;
            
            blocks_j = cell(1,N2);
            for i = 1:N1
                
                for j = 1:N2
                    
                    % Plots the actual graph
                    c=c+1;
                    if ~suppress_subplot; hxp.hcurr.set_gca(c); end
                    if ~isempty(subplot_grid_handle); hold on; end
                    hxp.hsub{i,j} = xp.data{i,j}();
                    
                    % % Now add the ticks. 
                    % First, pull out the PPStim state variable data. This
                    % will be generally zero where there are no pulses, and
                    % 1 where there are pulses.
                    time= xpp.meta.datainfo(1).values;
                    blocks = xpp.data{i,j,1,1,1,1,1,1};      % These are the ticks that correspond to our current subplot. Add a bunch of extra 1's just incase it's very high dimensional. This type of indexing bad form but is OK
                    blocks = mean(blocks,2);
                    
                    % Now we will set all values to NaN where we're below
                    % threshold, and values above threshold to be at the
                    % top of our plot. We use NaNs because they are ignored
                    % when plotting. I call them blocks because the ticks
                    % could in principle be longer than a few milliseconds
                    % if we give them a  long decay time
                    thresh = 0.1;
                    ind = blocks < thresh;
                    blocks(ind) = NaN;
                    yl = ylim;
                    blocks(~ind) = yl(2) - (yl(2) - yl(1))*0.01;    % Shift down 1% from top of plot
                    
                    % This clause just looks at the subplot on the grid directly above
                    % the above the current one and sees if the ticks are
                    % the same. If they are, it skips plotting. 
                    plot_ppstim = true;
                    if ~isempty(blocks_j{j})
                        if isequal(~isnan(blocks_j{j}),~isnan(blocks)) && suppress_PP_ticks_columns
                            plot_ppstim = false;
                        end
                    end
                        
                    % Finally, plot the ticks.
                    if plot_ppstim && show_PP_ticks
                        %hold on; plot(time, blocks,'r--.','LineWidth',20);
                        hold on; plot(time, blocks,'r.','MarkerSize',5);
                    end
                    
                    % Stores the current ticks for comparison in the next
                    % round. 
                    blocks_j{j} = blocks;
                    
                    if i == 1 && j == 1 && ~isempty(legend1b) && ~suppress_legend
                        % Place a legend in the 1st subplot
                        legend(legend1b{1:min(end,op.max_legend)});
                    end
                    if i == 1 && j == 1 && do_colorbar
                        colorbar;
                        %hsg.colorbar;
                        %hsg.colorbar([],zlims);
                    end
                    if j ~= 1 && autosuppress_interior_tics
                        set(gca,'YTickLabel','');
                        ylabel('');
                    end
                    if i ~= N1 && autosuppress_interior_tics
                        set(gca,'XTickLabel','');
                        xlabel('');
                    end
                end
            end
            
            % Set up axis labels
            if ~suppress_subplot
                % Do labels for rows
                if ~strcmp(xp.axis(1).name(1:3),'Dim')          % Only display if its not an empty axis
                    rowstr = setup_axis_labels(xp.axis(1));
                    hxp.hcurr.rowtitles(rowstr);
                end

                % Do labels for columns
                if ~strcmp(xp.axis(2).name(1:3),'Dim')          % Only display if its not an empty axis
                    colstr = setup_axis_labels(xp.axis(2));
                    hxp.hcurr.coltitles(colstr);
                end
            end
            
            
            if display_mode == 1
                
                cdata = print(h1,'-RGBImage');
                close(h1);

                % Restore original axes and display image
                figure(h0); axes(ha0);
                imshow(cdata);
                
            end
        
        
    elseif ndims(xp.data) == 3
        error('For 3D xp data, use instead xp_subplot_grid3D');
        
    end
    
    
    
    
end

function outstr = setup_axis_labels(xpa)
    vals = xpa.getvalues_cellstr;
    vals = strrep(vals,'_',' ');
    outstr = cell(size(vals));
    for j = 1:length(outstr)
        outstr{j} = {'',vals{j}};
    end
    outstr{round(end/2)}{1} = strrep(xpa.name,'_',' ');
end
