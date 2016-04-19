

function startup

    set(0, 'DefaultFigureColor', 'White');
    
    dnsim_root = fullfile('~','src','dnsim');
    currd2 = pwd;

    % Add dnsim code
    cd(dnsim_root)
    startup

    % Add dave custom code
    cd dave
    startup_dav

    % Change back to current folder
    cd(currd2)
end