function h2 = plot_AP_timing1b_RSFS_Vm(data,ind_range)

    if nargin < 2
        ind = data.time > 1400 & data.time < 1600;
    else
        ind = data.time > ind_range(1) & data.time < ind_range(2);
    end
    
    i=0;
%     i=i+1; hold on; h{i} = plot(data.time(ind),data.RS_V(ind,:)+0,'b');
%     i=i+1; hold on; h{i} = plot(data.time(ind),data.FS_V(ind,:)+0,'r');
    i=i+1; hold on; h{i} = plot(data.time(ind),data.IB_V(ind,:),'g');
    i=i+1; hold on; h{i} = plot(data.time(ind),mean(data.RS_FS_IBaIBdbiSYNseed_s(ind,:),2)*100-150,'LineWidth',5);
    %i=i+1; hold on; h{i} = plot(data.time(ind),data.NG_GABA_gTH(ind,:)*20-6,'b','LineWidth',2);
    
    i=i+1; hold on; h{i} = plot(data.time(ind),data.RS_iPeriodicPulsesFacilitate_Iext(ind,1)*10-160,'k','LineWidth',5);
    %xlim([1440,1560])
    
    % Keep only 1st entry in h. Useful for passing to legend command.
    for i = 1:length(h)
        h2(i) = h{i}(1);
    end

end