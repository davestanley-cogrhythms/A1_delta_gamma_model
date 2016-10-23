

function h = plot_AP_decay1_RSFS(data,ind_range)

    if nargin < 2
        ind = data.time > 550 & data.time < 700;
    else
        ind = data.time > ind_range(1) & data.time < ind_range(2);
    end
    
    hold on; h = plot(data.time(ind),mean(data.RS_FS_IBaIBdbiSYNseed_s(ind,:),2),'LineWidth',5);
    
    hold on; plot(data.time(ind),data.RS_iPeriodicPulses_Iext(ind,:) ./ max(abs((data.RS_iPeriodicPulses_Iext(:))))*.7,'k','LineWidth',5)
    %ylim([-.1 .1])

end