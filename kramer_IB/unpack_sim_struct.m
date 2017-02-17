fields = fieldnames(sim_struct);

for i = 1:length(fields)
    
    eval(sprintf('%s = %s;'), fields{i}, sim_struct.(fields{i}))
    
end