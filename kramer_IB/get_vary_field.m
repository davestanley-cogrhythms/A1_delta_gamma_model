function argout = get_vary_field(vary, field)
% Returns the values for a field in a vary cell array from DynaSim.
% If field is a string, picks based on parameter name.
% If field is a cell array of strings, picks based on mechanism name and
% parameter name.

if ischar(field)
    
    param_index = contains(vary(:,2), field);
    
elseif iscell(field)
    
    param_index = contains(vary(:,1), field{1}) & contains(vary(:,2), field{2});
    
end
    
argout = vary{param_index, 3};

end