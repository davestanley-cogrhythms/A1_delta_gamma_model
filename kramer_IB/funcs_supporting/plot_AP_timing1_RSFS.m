

function h = plot_AP_timing1_RSFS(data,ind_range)

    if nargin < 2
        ind = data.time > 400 & data.time < 600;
    else
        ind = data.time > ind_range(1) & data.time < ind_range(2);
    end
    
    hold on; h = plot(data.time(ind),mean(data.RS_FS_IBaIBdbiSYNseed_s(ind,:),2) ./ max(abs(data.RS_FS_IBaIBdbiSYNseed_s(:)))*1,'LineWidth',5);
    
    hold on; plot(data.time(ind),data.RS_iPeriodicPulses_Iext(ind,:) ./ max(abs((data.RS_iPeriodicPulses_Iext(:))))*1,'k','LineWidth',5)
    %xlim([1440,1560])

end