

function h = plot_AP_timing1_RSFS(data)

    ind = data.time > 400 & data.time < 600;
    %ind = data.time > 1100 & data.time < 1400;
%     ind = data.time > 1000 & data.time < 1800;
    
    hold on; h = plot(data.time(ind),mean(data.RS_FS_IBaIBdbiSYNseed_s(ind,:),2) ./ max(abs(data.RS_FS_IBaIBdbiSYNseed_s(:)))*1,'LineWidth',5);
    
    hold on; plot(data.time(ind),data.RS_iPeriodicPulses_Iext(ind,:) ./ max(abs((data.RS_iPeriodicPulses_Iext(:))))*1,'k','LineWidth',5)
    %xlim([1440,1560])

end