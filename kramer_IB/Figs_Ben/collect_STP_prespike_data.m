function collect_STP_prespike_data

filenames = {'20-08-21/kramer_IB_2_21_1.284', '20-08-22/kramer_IB_18_57_4.182';...
    '20-08-21/kramer_IB_4_25_8.054', '20-08-22/kramer_IB_18_58_7.763';...
    '20-08-21/kramer_IB_16_6_6.232', '20-08-22/kramer_IB_22_55_44.02';...
    '20-08-21/kramer_IB_11_29_43.2', '20-08-22/kramer_IB_19_9_52.27';...
    '20-08-21/kramer_IB_18_54_12.1', '20-08-23/kramer_IB_0_6_20.16';...
    '20-08-21/kramer_IB_18_15_31.99', '20-08-23/kramer_IB_11_1_7.673'};
    
PLV_est_cell = deal(cell([size(filenames), 2]));

activation_fields = {'deepRS_iKs_n', 'deepRS_deepFS_IBaIBdbiSYNseed_s', 'deepRS_iKCaT_q', 'deepRS_iNaP_m'};

[width, freq_cell, stims] = deal(cell(2, 1));

pre_spike_indicator = cell([size(filenames), 2]);

activation = cell([size(filenames), length(activation_fields) + 2]);

for r = 1:size(filenames, 1)
    
    for c = 1:size(filenames, 2)
        
        data = dsImport(filenames{r,c});
        data_fields = fields(data);
        
        if r == 1
            
            freq_cell{c} = 1./(4*[data.deepRS_STPwidth]);
            
            stims{c} = [data.deepRS_STPstim];
            
        end
        
        time = [data.time]/1000;
            
        width = [data.deepRS_STPwidth]/1000;
        
        STP = [data.deepRS_iSpikeTriggeredPulse_input];
        
        [pulse_index_i, pulse_index_j] = find(diff(STP > 0) == 1);
        pulse_time = time(sub2ind(size(time), pulse_index_i, pulse_index_j));
        pulse_end_time = pulse_time + width;
        % time = time - ones(size(time))*diag(pulse_time);
        
        % STP(:, [data.deepRS_STPstim] == 0) = 0;
        
        spikes = [data.deepRS_V_spikes];
        
        spike_indicator = logical(spikes) & (STP <= 0) & (time > 1); % + ones(size(time))*diag(pulse_time) 
        
        first_spike_indicator = false(size(spike_indicator));
        
        for col = 2:size(spikes, 2)
            
            spike_times{col} = time(spike_indicator(:, col));
            
            first_spike_time = spike_times{col}(find(spike_times{col} > pulse_time(col), 1));
            
            if ~isempty(first_spike_time)
                
                first_spike_indicator(:, col) = time(:, col) == first_spike_time;
                
            end
            
            spike_indicator(:, col) = spike_indicator(:, col) & ~first_spike_indicator(:, col);
            
        end
    
        pre_spike_indicator{r, c, 1} = circshift(spike_indicator, -1);
        
        pre_spike_indicator{r, c, 2} = circshift(first_spike_indicator, -1);
        
        indices = {1, 2:size(spikes, 2)};
    
        for field = 1:length(activation_fields)
            
            if any(strcmp(data_fields, activation_fields{field}))
            
                activation{r, c, field} = [data.(activation_fields{field})];
                
            end
            
        end
        
        activation{r, c, length(activation_fields) + 1} = diff([activation{r, c, 1}; activation{r, c, 1}(end, :)]);
        
        activation{r, c, length(activation_fields) + 2} = diff([activation{r, c, 1}; activation{r, c, 1}(end, :)], 2);
        
    end
    
%     figure
%     
%     for i = 1:10
%         
%         subplot(10, 1, i)
%         
%         [ax, h1, h2] = plotyy(time, pre_spike_indicator{r, 1, 1}(:, (i-1)*10+8), time, activation{r, 1, 1}(:, (i-1)*10+8));
%         
%         axis(ax, 'tight'), set(h1, 'Color', 'r'), set(h2, 'Color', 'k')
%         
%     end
%     
%     saveas(gcf, sprintf('test_before_%d.fig', r))
    
end

pre_spike_indicator = cellfun(@(x, y) combine_by_columns(freq_cell{1}, x, freq_cell{2}, y), squeeze(pre_spike_indicator(:, 1, :)), squeeze(pre_spike_indicator(:, 2, :)), 'unif', 0);

activation = cellfun(@(x, y) combine_by_columns(freq_cell{1}, x, freq_cell{2}, y), squeeze(activation(:, 1, :)), squeeze(activation(:, 2, :)), 'unif', 0);

stims = combine_by_columns(freq_cell{1}, stims{1}, freq_cell{2}, stims{2});

freqs = combine_by_columns(freq_cell{1}, freq_cell{1}, freq_cell{2}, freq_cell{2});

save('all_STP_data.mat', 'pre_spike_indicator', 'activation', 'freqs', 'stims', 'time', '-v7.3') 

% for r = 1:6
%     
%     figure
%     
%     for i = 1:10
%         
%         subplot(10, 1, i)
%         
%         [ax, h1, h2] = plotyy(time, pre_spike_indicator{r, 1}(:, (i-1)*10+8), time, activation{r, 1}(:, (i-1)*10+8));
%         
%         axis(ax, 'tight'), set(h1, 'Color', 'r'), set(h2, 'Color', 'k')
%         
%         
%         box off
%     end
%     
%     saveas(gcf, sprintf('test_after_%d.fig', r))
%     
% end

end

function combined_mat = combine_by_columns(x1, mat1, x2, mat2)

    [~, i] = sort([x1(:); x2(:)]);
    
    combined_mat = [mat1, mat2];
    
    if ~isempty(combined_mat)
        
        combined_mat = combined_mat(:, i);
        
    end
    
end