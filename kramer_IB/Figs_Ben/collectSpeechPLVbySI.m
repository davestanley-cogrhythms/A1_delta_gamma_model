function [MRVs, Nspikes] = collectSpeechPLVbySI(name_mat)

names = load(name_mat);

names = names.names;

SIs = 0.1:0.1:1;

[MRVs, Nspikes] = deal(nan(11, 8, 10, length(names)));
    
for n = 1:length(names)
    
    for si = 1:length(SIs)
        
        suffix = sprintf('_deepRS_SentenceIndex_%g_deepRS_iSpeechInput_input_wavelet_reduce_cutoff10e-2_PLV_data.mat', SIs(si));
        
        PLV_data = load([names{n}, suffix]);
        
        this_MRVs = reshape(permute(PLV_data.v_mean_spike_mrvs, [2, 1, 3]), [12, 8]);
        
        this_Nspikes = reshape(permute(PLV_data.no_spikes, [2, 1, 3]), [12, 8]);
        
        MRVs(:, :, si, n) = this_MRVs(1:11, :);
        
        Nspikes(:, :, si, n) = this_Nspikes(1:11, :);
        
    end
    
end

save([name_mat(1:(end - 4)), '_PLV_data.mat'], 'names', 'MRVs', 'Nspikes')

end