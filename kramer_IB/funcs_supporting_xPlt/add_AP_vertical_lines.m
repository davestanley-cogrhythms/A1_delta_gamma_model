
function myh = add_AP_vertical_lines


    % ADd vertical lines fr AP pulse
    axis_counter=0;
    shift = 25*8;          % Shift of 0 corresponds to pulse_num = 12. shift of 25*-8 is pulse_num=4. Etc.
    hold on; myh = plot([250,250]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([275,275]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([286,286]+shift,[min(ylim),max(ylim)],'r:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([300,300]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');
    hold on; myh = plot([325,325]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2); uistack(myh,'bottom');
    
     

end