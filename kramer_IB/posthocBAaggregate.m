function posthocBAaggregate(sim_name, varargin)

names = load(sim_name);

names = names.names;

for n = 1:length(names)
    
    name = names{n};
    
    posthoc_boundary_analysis_wrapper(name, varargin{:});
    
end