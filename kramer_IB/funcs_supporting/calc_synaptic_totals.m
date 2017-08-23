

function xp = calc_synaptic_totals(xp,pop_struct);

    xp_dat = xp.data;
    ax_names = xp.exportAxisNames;
    ax_vals = xp.exportAxisVals;
    
    % Find any varied statements that vary synaptic conductance
    ind = find((strcmpi_any(ax_names,'g_SYN') | ...
        strcmpi_any(ax_names,'gNMDA') | ...
        strcmpi_any(ax_names,'gGABAB') )...
         & ~strcmpi_any(ax_names,'PP_gSYN'));  % find axis names that are ending in g_SYN but not PP_gSYN
    
    % For each axis, find the presynaptic population name and multiply all
    % values by Npre
    for i = ind
        ax_curr = ax_names{i};
        vals_curr = ax_vals{i};
        temp = strfind(ax_curr,'_');
        name_pre = ax_curr( 1:temp(1)-1 );
        if isfield(pop_struct,['N' lower(name_pre)])
            Npre = pop_struct.(['N' lower(name_pre)]);
            if isnumeric(vals_curr)
                vals_curr = vals_curr * Npre;
            end
        else
            fprintf('Note: Scaling value of g_SYN in vary statement by Npre=%d failed for population %s \n',Npre,ax_curr);
        end
        ax_vals{i} = vals_curr;
    end
    
    xp = xp.importData(xp_dat,ax_vals);

end


function out = strcmpi_any(cell_arry_of_strings,exp)

out = ~cellfun(@isempty,regexpi(cell_arry_of_strings,exp));
%out = ~cellfun(@isempty,regexpi(cell_arry_of_strings,['^' exp]));       % Has to match the beginning of the string


end