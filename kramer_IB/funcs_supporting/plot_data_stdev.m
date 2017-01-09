function h2 = plot_data_stdev(data,fieldname,ind_range,linespec)

    if nargin < 2
        if isempty(fieldname)
            fieldname = 'RS_V';
        end
    end

    if nargin < 3
        ind_range = [];
    end
    
    if nargin < 4
        linespec = {};
    end
    
    if ~isempty(ind_range)
        ind = data.time > ind_range(1) & data.time < ind_range(2);
    else
        ind = true(size(data.time));
    end
    
    
    i=0;
%     i=i+1; hold on; h{i} = plot(data.time(ind),data.RS_V(ind,:)+0,'b');
%     i=i+1; hold on; h{i} = plot(data.time(ind),data.FS_V(ind,:)+0,'r');

    mystd = data(1).([fieldname '_std']);
    b = cat(3,mystd,mystd);
    b = permute(b,[1,3,2]);

    i=i+1; hold on; h{i} = boundedline(data.time(ind),data.(fieldname)(ind,:),1*b(ind,:,:),linespec{:});
    %i=i+1; hold on; h{i} = plot(data.time(ind),data.RS_iPeriodicPulsesFacilitate_Iext(ind,1)*10-160,'k','LineWidth',5);
    %xlim([1440,1560])
    
    % Keep only 1st entry in h. Useful for passing to legend command.
    for i = 1:length(h)
        h2(i) = h{i}(1);
    end
    
    
    hold on; myh = plot([250,250],[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([275,275],[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([286,286],[min(ylim),max(ylim)],'r:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([300,300],[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([325,325],[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');

end