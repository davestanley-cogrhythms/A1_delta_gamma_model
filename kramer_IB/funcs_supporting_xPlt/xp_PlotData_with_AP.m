
function hxp = xp_PlotData_with_AP (xp, op)

    hxp = xp_PlotData (xp, op);

    hold on; 
    add_AP_vertical_lines;

end