fields = fieldnames(sim_struct);

for f = 1:length(fields)
    
    eval(sprintf('%s = sim_struct.%s;', fields{f}, fields{f}))
    
end