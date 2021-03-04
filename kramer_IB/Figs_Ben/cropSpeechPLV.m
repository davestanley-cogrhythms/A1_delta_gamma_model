function cropSpeechPLV(crops, name_mat, suffix)

if nargin < 2, suffix = []; end
if isempty(suffix), suffix = '_PLV_data.mat'; end

names = load(name_mat);

names = names.names;

for n = 1:length(names)
    
    if exist([names{n}, suffix]) == 2
    
        PLV_data = load([names{n}, suffix]);
        
        PLV_fields = fields(PLV_data);
        
        changed = zeros(size(PLV_fields));
        
        for f = 1:length(PLV_fields)
            
            index = 1;
            
            if length(size(PLV_data.(PLV_fields{f}))) == length(crops) && all(size(PLV_data.(PLV_fields{f})) - crops >= 0)
                
                indices = '';
                
                for i = 1:length(crops)
                    
                    indices = [indices, '1:', num2str(crops(i)), ', '];
                    
                end
                
                for i = (length(crops) + 1):length(size(PLV_data.(PLV_fields{f})))
                    
                    indices = [indices, ':, '];
                    
                end
                
                indices = indices(1:(end - 2));
                
                old_shapes{index} = size(PLV_data.(PLV_fields{f}));
                
                eval([PLV_fields{f}, ' = PLV_data.', PLV_fields{f}, '(', indices, ');'])
                
                new_shapes{index} = size(PLV_data.(PLV_fields{f})); index = index + 1;
                
                changed(f) = 1;
                
            end
            
        end
        
        changed_fields = PLV_fields(logical(changed));
        
        save([names{n}, '_PLV_data_cropped.mat'], changed_fields{:}, 'old_shapes', 'new_shapes', '-v7.3')
        
    end

end