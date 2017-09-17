
function setup_paths_n_run(varargin)
    % Runs setup paths and then calls the specified function handle.
    % 
    % Format: 
    % setup_paths_n_run(func,arguments)
    %     This runs setup paths and then executes func(arguments{:})
    %
    % Example:
    % 
    % setup_paths_n_run(@run_analysis, sfc_mode,stage,files,i0,j0,embed_outname_i0j0)
    % 

    currdir = pwd;
    cd ..
    startup_DynaSimDave
    cd (currdir);
    
    func = varargin{1};
    myargs = varargin(2:end);

    func(myargs{:});
    
end
