function collect_STP_prespike_data

filenames = {'20-08-21/kramer_IB_2_21_1.284', '20-08-22/kramer_IB_18_57_4.182';...
    '20-08-21/kramer_IB_4_25_8.054', '20-08-22/kramer_IB_18_58_7.763';...
    '20-08-21/kramer_IB_16_6_6.232', '20-08-22/kramer_IB_22_55_44.02';...
    '20-08-21/kramer_IB_11_29_43.2', '20-08-22/kramer_IB_19_9_52.27';...
    '20-08-21/kramer_IB_18_54_12.1', '20-08-23/kramer_IB_0_6_20.16';...
    '20-08-21/kramer_IB_18_15_31.99', '20-08-23/kramer_IB_11_1_7.673'};
    
PLV_est_cell = deal(cell([size(filenames), 2]));

data_field = {'deepRS_iKs_n', 'deepRS_deepFS_IBaIBdbiSYNseed_s', 'deepRS_iKCaT_q', 'deepRS_iNaP_m'};

[activation, pre_spike_activation, pre_first_spike_activation] = deal(cell([size(filenames), 6]));

for r = 1:size(filenames, 1)
    
    for c = 1:size(filenames, 2)
        
        data = dsImport(filenames{r,c});
        data_fields = fields(data);
        
        time = [data.time]/1000;
        
        STP = [data.deepRS_iSpikeTriggeredPulse_input];
        
        [pulse_index_i, pulse_index_j] = find(diff(STP > 0) == 1);
        pulse_time = time(sub2ind(size(time), pulse_index_i, pulse_index_j));
        time = time - ones(size(time))*diag(pulse_time);
        
        STP(:, [data.deepRS_STPstim] == 0) = 0;
        
        spikes = [data.deepRS_V_spikes];
        
        spike_indicator = logical(spikes) & STP <= 0 & (time + ones(size(time))*diag(pulse_time)) > 1;
        
        first_spike_indicator = false(size(spike_indicator));
        
        for col = 2:size(spikes, 2)
            
            spike_times{col} = time(spike_indicator(:, col));
            
            first_spike_time = spike_times{col}(find(spike_times{col} > .1, 1));
            
            if ~isempty(first_spike_time)
                
                first_spike_indicator(:, col) = time(:, col) == first_spike_time;
                
            end
            
            spike_indicator(:, col) = spike_indicator(:, col) & ~first_spike_indicator(:, col);
            
        end
    
        pre_spike_indicator = circshift(spike_indicator, -1);
        
        pre_first_spike_indicator = circshift(first_spike_indicator, -1);
        
        indices = {1, 2:size(spikes, 2)};
    
        for field = 1:length(data_fields)
            
            this_activation = [data.(data_fields{field})];
            
            if field ~= 2 && field ~= 3 && r ~= 3 && r ~= 4
                
                activation{r, c, field} = this_activation;
                
            end
            
            pre_spike_activation{r, c, field} = this_activation(pre_spike_indicator);
            
            pre_first_spike_activation{r, c, field} = this_activation(pre_first_spike_indicator);
            
        end
        
        Dactivation1 = diff([activation{r, c, 1}; activation{r, c, 1}(end, :)]);
        
        pre_spike_activation{r, c, end + 1} = Dactivation1(pre_spike_indicator);
        
        pre_spike_activation{r, c, end + 1} = Dactivation1(pre_first_spike_indicator);
        
        D2activation1 = diff([activation{r, c, 1}; activation{r, c, 1}(end, :)], 2);
        
        pre_spike_activation{r, c, end + 1} = D2activation1(pre_spike_indicator(1:(end - 1), :));
        
        pre_first_spike_activation{r, c, end + 1} = D2activation1(pre_first_spike_indicator(1:(end - 1), :));
        
    end
    
end

save('STP_prespike_activation_new.mat', 'pre_spike_indicator', 'pre_first_spike_indicator', 'activation', '-v7.3')

end