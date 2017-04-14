function h2 = plot_AP_timing1b_RSFS_Vm(data,ind_range)

    if nargin < 2
        ind = data.time > 150 & data.time < 250;
        %ind = 1:length(data.time);
    else
        ind = data.time > ind_range(1) & data.time < ind_range(2);
    end
    
    i=0;
%     i=i+1; hold on; h{i} = plot(data.time(ind),data.RS_V(ind,:)+0,'b');
%     i=i+1; hold on; h{i} = plot(data.time(ind),data.FS_V(ind,:)+0,'r');
    if isfield(data(1),'LTS_V')
        i=i+1; hold on; h{i} = plot(data.time(ind),data.LTS_V(ind,:),'g');
    end
    i=i+1; hold on; h{i} = plot(data.time(ind),mean(data.FS_FS_IBaIBdbiSYNseed_s(ind,:),2)*100-150,'LineWidth',2);
    i=i+1; hold on; h{i} = plot(data.time(ind),mean(data.FS_RS_IBaIBdbiSYNseed_s(ind,:),2)*100-150,'LineWidth',2);
    %i=i+1; hold on; h{i} = plot(data.time(ind),data.NG_GABA_gTH(ind,:)*20-6,'b','LineWidth',2);
    
    i=i+1; hold on; h{i} = plot(data.time(ind),-1*data.RS_iPeriodicPulsesiSYN_s(ind,1)*30-160,'k','LineWidth',2);
    %xlim([1440,1560])
    
    % Keep only 1st entry in h. Useful for passing to legend command.
    for i = 1:length(h)
        h2(i) = h{i}(1);
    end
    
    hold on; add_AP_vertical_lines

end