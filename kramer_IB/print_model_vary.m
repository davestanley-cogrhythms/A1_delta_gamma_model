function print_model_vary

model_vary = get_model_vary;

fid = fopen('model_vary.txt', 'w');

for m = 1:length(model_vary)
    
    fprintf(fid, sprintf('model_vary{%d} = {', m))
    
    [rows, columns] = size(model_vary{m});
    
    for i = 1:rows
        
        for j = 1:columns
            
            if mod(j, columns) == 0
                
                if i == rows
                    
                    suffix = '};\n\n';
                    
                else
                
                    suffix = ';...\n';
                    
                end
                
            else
                
                suffix = ', ';
                
            end
            
            if ischar(model_vary{m}{i,j})
                
                fprintf(fid, ['''', model_vary{m}{i,j}, '''', suffix])
                
            elseif isnumeric(model_vary{m}{i,j})
                
                if isscalar(model_vary{m}{i,j})
                    
                    fprintf(fid, sprintf('%f%s', model_vary{m}{i,j}, suffix))
                    
                end
                
            end
            
        end
        
    end
    
end

fclose(fid)

end