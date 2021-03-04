function reshapeSpeechPLV(new_shape, name_mat, suffix)

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
            
            if numel(PLV_data.(PLV_fields{f})) == prod(new_shape)
                
                old_shapes{index} = size(PLV_data.(PLV_fields{f})); index = index + 1;
                
                eval([PLV_fields{f}, ' = reshape(PLV_data.', PLV_fields{f}, ', new_shape);'])
                
                changed(f) = 1;
                
            end
            
        end
        
        changed_fields = PLV_fields(logical(changed));
        
        save([names{n}, '_PLV_data_reshaped.mat'], changed_fields{:}, 'old_shapes', 'new_shape', '-v7.3')
        
    end

end