function data = dsImportDataOrResults(name)
    
dataList = dir(fullfile(fullfile(name, 'data'), '*.mat'));

if ~isempty(dataList)
    
    try
        
        data = dsImport(name);
        
    catch
        
        data = dsImportResults(name);
        
    end
    
else
    
    resultList = dir(fullfile(fullfile(name, 'results'), '*.mat'));
    
    if ~isempty(resultList)
        
        data = dsImportResults(name);
        
    else
        
        data = struct();
        
    end
    
end
    
end