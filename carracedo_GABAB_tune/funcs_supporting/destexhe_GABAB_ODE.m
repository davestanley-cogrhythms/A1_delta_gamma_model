

% Refs
% Destexhe: Methods in Neuronal Modeling, Chapter 1)
% Destexhe, A., Bal, T., McCormick, D. A., & Sejnowski, T. J. (1996). Ionic mechanisms underlying synchronized oscillations and propagating waves in a model of ferret thalamic slices. Journal of Neurophysiology, 76(3), 2049?2070.
function dy = destexhe_GABAB_ODE(t,y)

    global K1 K2 K3 K4
    
    
    % Calculate neurotransmitter ammount
    % Assume a single AP causes a 0.5 mM box 0.3 ms long 
    if t <= 0.3; NT_curr = 0.5;
    else NT_curr = 0;
    end
    
    % Set up variables
    r=y(1);
    s=y(2);
    
    % Update dy
    dy = zeros(2,1);    % a column vector
    dy(1) = K1*NT_curr*(1-r) - K2*r;        % r'
    dy(2) = K3*r-K4*s;                      % s'

end