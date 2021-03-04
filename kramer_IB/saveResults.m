function saveResults(name)

results = dsImportResults(name, @boundary_analysis);

result_fields = fieldnames(results(1).options);

for f = 1:length(result_fields)
    
    varargin{2*f - 1} = result_fields{f};
    
    varargin{2*f} = results(1).options.(result_fields{f});
    
end

boundary_defaults

save([name, label, '_boundary_analysis.mat'], 'results', '-v7.3')

end