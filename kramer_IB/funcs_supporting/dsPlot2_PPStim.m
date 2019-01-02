

function varargout = dsPlot2_PPStim (data,varargin)

    % get rid of any "all" inputs
    v2 = varargin;
    inds = find(strcmp(v2,'all'));
    for i = inds
        v2{i} = ':';
    end
    
    

    options=dsCheckOptions(v2,{...
      'population',[],[],...          % [beg,end] (units must be consistent with dt and equations)  
      'variable',[],[],...          % [beg,end] (units must be consistent with dt and equations)  
      },false);

    
    % Isolates the PPStim pulse train information
    xp = dsAll2mdd(data);
    
    ind = xp.findaxis('variables');
    varvals = xp.exportAxisVals;
    varvals = varvals{ind};
    if any(strcmp(varvals,'iPeriodicPulsesiSYNNested_s')) && any(strcmp(varvals,'iPoissonNested_ampaNMDA_S2'))    % If both periodic pulses are present...
        % ...then
        xpp1 = xp.axisSubset('variables','iPoissonNested_ampaNMDA_S2');
        xpp2 = xp.axisSubset('variables','iPeriodicPulsesiSYNNested_s');
        
        dat1=xpp1.exportData;
        dat2=xpp2.exportData;
        
        for i = 1:numel(dat1)
            if ~isempty(dat2{i})        % If data2 isn't empty, import into dat1, overwriting if necessary.
                dat1{i} = dat2{i};
            end
        end
        xpp1.data = dat1;
        xpp = xpp1;
        clear xpp1 xpp2
    elseif  any(strcmp(varvals,'iPeriodicPulsesiSYNNested_s')) && ~any(strcmp(varvals,'iPoissonNested_ampaNMDA_S2')) 
        xpp = xp.axisSubset('variables','iPeriodicPulsesiSYNNested_s');
    elseif  ~any(strcmp(varvals,'iPeriodicPulsesiSYNNested_s')) && any(strcmp(varvals,'iPoissonNested_ampaNMDA_S2')) 
        xpp = xp.axisSubset('variables','iPoissonNested_ampaNMDA_S2');
    else
        error('Periodic pulse variable not found');
    end
    
    xpp = xpp.squeezeRegexp('variables');
    
    % Overwrite other XPP entries for non-IB cells with those from IB
    % cells. The reason we want to do this is because IB cells reflect the
    % thalamus matrix input, and don't go through the "gamma transformer"
    % in L4.  
    % (The net result is that this will produce solid red bars instead of
    % dotted lines for the "pure tone" inputs)
    % 
    % If IB cells aren't present, we'll just leave each population alone,
    % unless it doesn't have a PPStim mechanism. In this case, we'll look
    % copy over from other cells that do have a PPStim mechanism
    %
    % This copying over is also necessary due to some mechanisms missing
    % the PPstim mechanism.
    % For details, see commmit: ce0323995ac0941163ecb27dafe5cbe1b8697308
    % Or tag: <Major_Change1.3>
    
    % Get names of all populations
    popaxis = xpp.findaxis('population');
    mypops = xpp.axis(popaxis).values;
    Npops = length(mypops);
    
    % Bring population axis temporarily to front
    Nd = ndims(xpp);
    inds = [popaxis, 1:popaxis-1, popaxis+1:Nd];
    xpt = xpp.permute(inds);        % Temporary xpp matrix
    
    % Find IB cells and copy data over.
    if any(strcmp(mypops,'IB'))     % If IB cells exist
        dat = xpt.data;
        xpt_IB = xpt.axisSubset('population','/^IB$/');     % Take population exactly matching IB
        dat_IB = xpt_IB.data;                               % Get data from this population
        for i = 1:Npops                                     % Copy this over to all populations
            dat(i,:) = dat_IB(1,:);
        end
        xpt.data = dat;                                     % Re-assign it to xpt
    else                            % If IB cells don't exist, there still might be some blank
                                    % entries. Need to fill these in with data from other cells we know
                                    % contains the mechs.
        if any(strcmp(mypops,'dFS5'))           % If no IB's, use dFS5 cells
            xpt_source = xpt.axisSubset('population','dFS5');
        elseif any(strcmp(mypops,'RS'))         % If can't find dFS5, use RS cells 
            xpt_source = xpt.axisSubset('population','RS');
        else
            xpt_source = [];                    % If couldn't find a source, don't bother doing the replacement.. we just won't plot any red bars for this cell type, then
        end
        
        if ~isempty (xpt_source)        
            dat = xpt.data;
        	dat_source = xpt_source.data;
            for i = 1:Npops                                     % Copy this over to all populations
                % Copy over only to blank entries. Use this form of
                % indexing since we cdat could be high dimensional
                cdat = dat(i,:);
                for j = 1:numel(cdat)
                    if isempty(cdat{j})
                        cdat{j} = dat_source{j};
                    end
                end
                dat(i,:) = cdat;
            end
            xpt.data = dat;
        end
        
    end
    
    xpp = xpt.ipermute(inds);
    
    
    
    
    for i = 1:numel(xpp.data)
        xpp_temp = xpp(i);
        
    end
    
    
    if ~isempty(options.population)
        xpp = xpp.axisSubset('population',options.population);
    end

    % Call dsPlot2 supplying this custom function handle.
    varargout = cell(1,nargout);
    [varargout{1:nargout}] = dsPlot2(data,varargin{:},'subplot_handle',@(xp,op) xp_subplot_grid_PPStim(xp,op,xpp));

end