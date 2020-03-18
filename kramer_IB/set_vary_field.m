function vary_out = set_vary_field(vary, field, value)
% Either returns or sets the field in a vary cell array from DynaSim.
% If field is a string, picks based on parameter name.
% If field is a cell array of strings, picks based on mechanism name and
% parameter name.

if ischar(field)
    
    param_index = strcmp(vary(:,2), field);
    
elseif iscell(field)
    
    param_index = strcmp(vary(:,1), field{1}) & strcmp(vary(:,2), field{2});
    
end

vary_out = vary;

if isempty(value)
    
    vary_out(param_index, :) = [];
    
else
    
    if sum(param_index) == 0
        
        if iscell(field)
            
            disp('Parameter not found, set anyway.')
            
            vary_out(end + 1, :) = {field{1}, field{2}, value};
            
        else
            
            disp('Parameter not found; population or connection name required to set.')
            
        end
        
    else
        
        vary_out{param_index, 3} = value;
        
    end
    
end
    
end