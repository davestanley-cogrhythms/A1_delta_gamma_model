

function plot_AP_timing2_IB(data)

    ind = data.time > 1400 & data.time < 1600;
    plot(data.time(ind),data.IB_iPeriodicPulses_Iext(ind,:),'r')
    hold on; plot(data.time(ind),data.RS_FS_IBaIBdbiSYNseed_s(ind,:)*10)
    hold on; plot(data.time(ind),data.IB_V(ind,:)/10)
    %xlim([1440,1560])

end