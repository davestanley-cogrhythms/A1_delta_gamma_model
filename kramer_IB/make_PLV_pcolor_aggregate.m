function make_PLV_pcolor_aggregate

files7Hz = {'18-12-21/kramer_IB_13_46_54.96';...
    '19-12-02/kramer_IB_18_5_29.44';...
    '19-07-19/kramer_IB_1_41_36.13';... % '18-12-18/kramer_IB_16_3_5.302';...
    '19-07-29/kramer_IB_15_5_45.59';... % '18-10-30/kramer_IB_21_32_17.93';... % '18-12-14/kramer_IB_15_23_16.83';...
    '19-07-30/kramer_IB_13_37_2.42';... '19-07-19/kramer_IB_16_50_25.92';... % 
    '19-01-07/kramer_IB_21_18_58.89';...
    % '19-01-04/kramer_IB_16_24_21.91';...
    };

files4Hz = {''; '19-01-02/kramer_IB_21_56_36.38';...
    '19-01-03/kramer_IB_15_34_6.468';...
    '19-01-07/kramer_IB_21_31_37.26';...
    '19-01-04/kramer_IB_16_6_58.46';...
    };

files2Hz = {''; '19-01-02/kramer_IB_22_0_8.619';...
    '19-01-03/kramer_IB_14_46_37.38';...
    '19-01-07/kramer_IB_21_36_7.769';...
    '19-01-04/kramer_IB_16_12_49.96';...
    };

files = files7Hz'; % [files7Hz files4Hz files2Hz];

[files_dim1, files_dim2] = size(files);

figure

for f = 1:(files_dim1*files_dim2)
    
    if ~isempty(files{f})
        
        load(['Figs_Ben/', files{f}, '_PLV_data.mat'])
        load(['Figs_Ben/', files{f}, '_sim_spec.mat'])
        
        msmrv_size = size(v_mean_spike_mrvs);
        MRV = reshape(permute(v_mean_spike_mrvs, [2 1 3]), prod(msmrv_size([1 2])), msmrv_size(3));
        
        nspikes = reshape(permute(no_spikes, [2 1 3]), prod(msmrv_size([1 2])), msmrv_size(3));
        
        PLV = ((abs(MRV).^2).*nspikes - 1)./nspikes;
        
        frequencies = pick_vary_field(vary, 'PPfreq');
        
        inputs = pick_vary_field(vary, 'PPstim');
        
        subplot(files_dim2, files_dim1, f)
        
        pcolor(frequencies, fliplr(abs(inputs)), PLV(1:length(frequencies), :)')
        
        shading interp
        
        axis xy
        
        set(gca, 'FontSize', 12)
        
        if mod(f, files_dim2) == 0, xlabel('Freq. (Hz)'), end
        
        % if mod(f, files_dim1) == 1
            ylabel({'Input Strength (pA)'})
        % end
        
        % title(files{f}(20:end), 'Interpreter', 'none')
        
        hold on
        
        nochange_colorbar(gca)
        
        plot((all_dimensions(@nanmean, no_spikes(:, :, end))/29)*[1; 1], [0; max(abs(inputs))], 'Color', [1 0 1], 'LineWidth', 3)
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 4 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 4 8])

saveas(gcf, ['PLV_pcolor_aggregate_w_MI.fig'])