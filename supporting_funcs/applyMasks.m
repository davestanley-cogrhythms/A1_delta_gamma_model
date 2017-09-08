function s1 = applyMasks(s0,onset,offset,Tend,dt,do_nested_mask,s0_mask)
    % Applies both onset and offset masks. Also, if do_nested_mask is set,
    % applies a time series mask.
    
    if nargin < 7
        s0_mask = ones(size(s0));   % Everything passes.
    end
    
    if nargin < 6
        do_nested_mask = 0;
    end
    

    % Build time variable
    t=(0:dt:Tend)';                            % Generate times vector

    % Apply mask
    if do_nested_mask
        s1 = s0 .* s0_mask;
    else
        s1 = s0;
    end

    % Apply onset offset masks
    s1(t<onset | t>offset) = 0;

end