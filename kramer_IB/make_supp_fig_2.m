function make_supp_fig_2

files7Hz = {'20-01-07/kramer_IB_16_44_45.2';...
    '19-12-12/kramer_IB_12_57_3.102';...
    '20-01-07/kramer_IB_16_46_58.22';... % '18-12-18/kramer_IB_16_3_5.302';...
    '20-01-07/kramer_IB_16_49_7.892';... % '18-10-30/kramer_IB_21_32_17.93';... % '18-12-14/kramer_IB_15_23_16.83';...
    '19-07-30/kramer_IB_13_37_2.42';... '19-07-19/kramer_IB_16_50_25.92';... % 
    '20-01-07/kramer_IB_16_51_17.81';...
    % '19-01-04/kramer_IB_16_24_21.91';...
    };

files = files7Hz'; % [files7Hz files4Hz files2Hz];

multipliers = {'\frac13', '\frac12', '\frac23', '\frac34', '1', '\frac54'}; % [0.333 0.5 0.667 0.75 1 1.25];

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
        
        subplot(files_dim1, files_dim2, f)
        
        pcolor(frequencies, fliplr(abs(inputs)), PLV(1:length(frequencies), :)')
        
        shading interp
        
        axis xy
        
        set(gca, 'FontSize', 12)
        
        if mod(f, files_dim1) == 0, xlabel('Freq. (Hz)'), end
        
        if mod(f, files_dim2) == 1
            ylabel({'Input Strength (pA)'})
        elseif f == files_dim2
            nochange_colorbar(gca)
        end
        
        %my_title = {sprintf('$g_m=%sg_m^0$,', multipliers{f}); sprintf('$g_{inh}=%sg_{inh}^0$', multipliers{f})};
        my_title = {'$g_m$, $g_{inh}$'; sprintf('scaled by $%s$', multipliers{f})};
        
        title(my_title, 'Interpreter', 'latex')
        
        hold on
        
%         nochange_colorbar(gca)
        
        plot((all_dimensions(@nanmean, no_spikes(:, :, end))/29)*[1; 1], [0; max(abs(inputs))], 'Color', [1 0 1], 'LineWidth', 3)
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 9 3], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 9 3])

saveas(gcf, ['supp_fig_2.fig'])