

function hxp = xp_plot_AP_timing1b_RSFS_Vm (xp, op,ind_range)
    % xp must be 1xN (e.g. 1 dimensional)
    
    hxp = struct;
    
    if nargin < 2
        op = struct;
    end
    
    if nargin < 3
        ind_range = [];
    end
    
    if isempty(op); op = struct; end;
    
    op = struct_addDef(op,'xlims',[]);
    op = struct_addDef(op,'ylims',[]);
%     op = struct_addDef(op,'shift_val',[]);
    
    xlims = op.xlims;
    ylims = op.ylims;
%     shift_val0 = op.shift_val;
    
    %xp = xp.mergeDim(1:ndims(xp));
    data = ds.mdd2ds(xp);
    
    %h2 = plot_AP_timing1b_RSFS_Vm(data,ind_range)
    if ~isempty(ind_range)
        hxp.hcurr = plot_AP_timing1b_RSFS_Vm(data,ind_range);
    else
        hxp.hcurr = plot_AP_timing1b_RSFS_Vm(data);
    end
    
    
    if ~isempty(xlims); xlim(xlims); end
    if ~isempty(ylims); ylim(ylims); end
    
end


