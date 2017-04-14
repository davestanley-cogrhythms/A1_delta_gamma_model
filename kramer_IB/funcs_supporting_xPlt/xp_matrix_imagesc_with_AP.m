
function hxp = xp_matrix_imagesc_with_AP (xp, op)



    hxp = xp_matrix_imagesc (xp, op);
    hold on; 
    
    
    % ADd vertical lines fr AP pulse
    axis_counter=0;
    shift = 25*0;          % Shift of 0 corresponds to pulse_num = 12. shift of 25*-8 is pulse_num=4. Etc.
    hold on; myh = plot([250,250]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2);
    hold on; myh = plot([275,275]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2);
    hold on; myh = plot([286,286]+shift,[min(ylim),max(ylim)],'r:','LineWidth',2);
    hold on; myh = plot([300,300]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2);
    hold on; myh = plot([325,325]+shift,[min(ylim),max(ylim)],'b:','LineWidth',2);
    
     

    

end