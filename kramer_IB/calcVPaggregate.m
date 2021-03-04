function calcVPaggregate(sim_name, varargin) % synchrony_window, vpnorm, 

%% Defaults & arguments.

suffix = '_vpdist';

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

sim_struct = load(sim_name);

names = sim_struct.names;

%% Checking analysis files exist.

for n = 1:length(names)
    
    if exist([names{n}, '_boundary_analysis.mat'], 'file') ~= 2
        
        % disp(sprintf('Results file not available for %s', name))
        
        results = dsImportResults(names{n}, @boundary_analysis);
        
        save([names{n}, '_boundary_analysis.mat'], 'results')
        
        result_fields = fieldnames(results(1).options);
        
        old_varargin = varargin;
        
        for f = 1:length(result_fields)
            
            varargin{2*f - 1} = result_fields{f};
            
            varargin{2*f} = results(1).options.(result_fields{f});
            
        end
        
        boundary_defaults
        
        save([names{n}, label, '_boundary_analysis.mat'], 'results')
        
        varargin = old_varargin;
        
        boundary_defaults
        
    end
    
%     if exist([names{n}, label, suffix, '.mat'], 'file') ~= 2
        
        calcVPdist(names{n}, varargin{:})
        
%     end
    
end

end