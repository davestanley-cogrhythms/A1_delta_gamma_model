

function h = plot_AP_timing1b_RSFS_Vm(data)

    ind = data.time > 1400 & data.time < 1600;
    %ind = data.time > 1100 & data.time < 1400;
%     ind = data.time > 1000 & data.time < 1800;
    
    hold on; h = plot(data.time(ind),data.RS_V(ind,:)/10,'b');
    hold on; plot(data.time(ind),data.FS_V(ind,:)/10*-1,'r');
    hold on; plot(data.time(ind),mean(data.RS_FS_IBaIBdbiSYNseed_s(ind,:),2)*10,'LineWidth',5)
    
    hold on; plot(data.time(ind),data.RS_iPeriodicPulses_Iext(ind,:),'k','LineWidth',5)
    %xlim([1440,1560])

end