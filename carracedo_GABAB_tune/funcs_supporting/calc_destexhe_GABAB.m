

% Refs
% Destexhe: Methods in Neuronal Modeling, Chapter 1)
% Destexhe, A., Bal, T., McCormick, D. A., & Sejnowski, T. J. (1996). Ionic mechanisms underlying synchronized oscillations and propagating waves in a model of ferret thalamic slices. Journal of Neurophysiology, 76(3), 2049?2070.
function [y,r,s,t2] = calc_destexhe_GABAB(t,K1t,K2t,K3t,K4t)

    global K1 K2 K3 K4
    K1=K1t;
    K2=K2t;
    K3=K3t;
    K4=K4t;

    Kd=100; 		% 100µM^4

    % Solve ODE
    [t2,all]=ode15s(@destexhe_GABAB_ODE,[min(t) max(t)],[0 0]);  
    
    r=all(:,1);
    s=all(:,2);      % in micromolar
    y = s.^4 ./ (s.^4 + Kd);    % Unitless; goes into iGABA_B equation
end