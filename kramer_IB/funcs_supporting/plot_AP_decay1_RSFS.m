

function h = plot_AP_decay1_RSFS(data)

    ind = data.time > 550 & data.time < 700;
    %ind = data.time > 1100 & data.time < 1400;
%     ind = data.time > 1000 & data.time < 1800;
    
    hold on; h = plot(data.time(ind),mean(data.RS_FS_IBaIBdbiSYNseed_s(ind,:),2),'LineWidth',5);
    
    hold on; plot(data.time(ind),data.RS_iPeriodicPulses_Iext(ind,:) ./ max(abs((data.RS_iPeriodicPulses_Iext(:))))*.1,'k','LineWidth',5)
    ylim([-.1 .1])

end