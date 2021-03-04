function collect_delay_data

filenames = {'20-08-21/kramer_IB_2_21_1.284', '20-08-22/kramer_IB_18_57_4.182';...
    '20-08-21/kramer_IB_4_25_8.054', '20-08-22/kramer_IB_18_58_7.763';...
    '20-08-21/kramer_IB_16_6_6.232', '20-08-22/kramer_IB_22_55_44.02';...
    '20-08-21/kramer_IB_11_29_43.2', '20-08-22/kramer_IB_19_9_52.27';...
    '20-08-21/kramer_IB_18_54_12.1', '20-08-23/kramer_IB_0_6_20.16';...
    '20-08-21/kramer_IB_18_15_31.99', '20-08-23/kramer_IB_11_1_7.673'};
    
PLV_est_cell = deal(cell([size(filenames), 2]));

for r = 1:size(filenames, 1)
    
    for c = 1:size(filenames, 2)
        
        PLV_est_struct = load([filenames{r, c}, '_PLV_estimate.mat']);
        
        PLV_est_cell{r, c, 1} = PLV_est_struct.delay_time;
        
        PLV_est_cell{r, c, 2} = PLV_est_struct.PLV_estimate;
        
        if r == 1
            
            freq_cell{c} = PLV_est_struct.frequencies;
            
            if c == 1, stims = PLV_est_struct.stims; end
            
        end
        
    end
    
end

for f = 1:2

    PLV_estimate{f} = cellfun(@(x, y) combine_by_rows(freq_cell{1}, x, freq_cell{2}, y), PLV_est_cell(:, 1, f), PLV_est_cell(:, 2, f), 'unif', 0);
    
end

frequencies = sort([freq_cell{1}(:); freq_cell{2}(:)]);

save('PLV_estimate.mat', 'PLV_estimate', 'frequencies', 'stims')

end

function combined_mat = combine_by_rows(x1, mat1, x2, mat2)

    [~, i] = sort([x1(:); x2(:)]);
    
    combined_mat = [mat1; mat2];

    combined_mat = combined_mat(i, :);
    
end