function data = dsImportDataOrResults(name)
    
dataList = dir(fullfile(fullfile(name, 'data'), '*.mat'));

if ~isempty(dataList)
    
    data = dsImport(name);
    
else
    
    resultList = dir(fullfile(fullfile(name, 'results'), '*.mat'));
    
    if ~isempty(resultList)
        
        data = dsImportResults(name);
        
    else
        
        data = struct();
        
    end
    
end
    
end