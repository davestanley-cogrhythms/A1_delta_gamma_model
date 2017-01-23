

function h = plot_normalized_max(t,X,varargin)

    for j = 1:size(X,2)
        X(:,j) = X(:,j) / max(X(:,j));
    end
    
    h = plot(t,X,varargin{:});

end