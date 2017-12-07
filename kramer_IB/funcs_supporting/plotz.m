function varargout = plotz(t,X,varargin)
    % Plot data with immediately taking z-score
    
    X = zscore(X);
    [varargout{1:nargout}] = plot(t,X,varargin{:});

end