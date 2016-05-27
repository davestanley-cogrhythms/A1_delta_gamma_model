


function [err,diff,t,y,t2,y2 ]= diff_destexhe_vs_carracedo(K)

    plot_on = 0;

    t = 0:2000;
    K1=K(1);
    K2=K(2);
    K3=K(3);
    K4=K(4);
    
    

    y = calc_carracedo2013(t);
    [y2,r,s,t2] = calc_destexhe_GABAB(t,K1,K2,K3,K4);
    y=y/max(y);
    y2=y2/max(y2);
    
    y2interp = interp1(t2,y2,t);
    
    if plot_on
    figure; plotyy(t,y,t2,y2);
    legend('y: Carracedo 2013 (normalized)','y: Destexhe 1996 (normalized)');
    ylabel('time (ms)');
    end
    
    diff = y2interp - y;
    err = sqrt(sum(diff.^2));    % rms out

end