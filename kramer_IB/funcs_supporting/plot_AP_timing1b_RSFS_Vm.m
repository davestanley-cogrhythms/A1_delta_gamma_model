function h = plot_AP_timing1b_RSFS_Vm(data,ind_range)

    if nargin < 2
        ind = data.time > 1400 & data.time < 1600;
    else
        ind = data.time > ind_range(1) & data.time < ind_range(2);
    end
    
    i=0;
    i=i+1; hold on; h{i} = plot(data.time(ind),data.RS_V(ind,:)/10,'b');
    i=i+1; hold on; h{i} = plot(data.time(ind),data.FS_V(ind,:)/10,'r');
    %i=i+1; hold on; h{i} = plot(data.time(ind),mean(data.RS_FS_IBaIBdbiSYNseed_s(ind,:),2)*10,'LineWidth',5)
    
    i=i+1; hold on; h{i} = plot(data.time(ind),data.RS_iPeriodicPulses_Iext(ind,:)-10,'k','LineWidth',5);
    %xlim([1440,1560])

end