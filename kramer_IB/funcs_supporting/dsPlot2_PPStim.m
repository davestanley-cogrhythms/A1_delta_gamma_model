

function varargout = dsPlot2_PPStim (varargin)

    data = varargin{1};
    
    % Isolates the PPStim pulse train information
    xp = dsAll2mdd(data);
    xpp = xp.axisSubset('variables','iPeriodicPulsesiSYN_s');
    xpp = xpp.squeezeRegexp('variables');

    % Call dsPlot2 supplying this custom function handle.
    varargout = cell(1,nargout);
    [varargout{1:nargout}] = dsPlot2(data,varargin{2:end},'subplot_handle',@(xp,op) xp_subplot_grid_PPStim(xp,op,xpp));

end