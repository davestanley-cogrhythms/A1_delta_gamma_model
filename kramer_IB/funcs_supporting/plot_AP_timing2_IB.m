

function h = plot_AP_timing2_IB(data)

    ind = data.time > 1400 & data.time < 1600;
    %ind = data.time > 1100 & data.time < 1400;
    %ind = data.time > 1000 & data.time < 1800;
    
    hold on; h = plot(data.time(ind),data.RS_FS_IBaIBdbiSYNseed_s(ind,:)*10);
    hold on; plot(data.time(ind),data.IB_V(ind,:)/10)
    plot(data.time(ind),data.IB_iPeriodicPulses_Iext(ind,:),'k','LineWidth',2)
    %xlim([1440,1560])

end