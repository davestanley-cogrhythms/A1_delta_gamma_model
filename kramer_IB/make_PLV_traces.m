function make_PLV_traces(filename)

     if isempty(['Figs_Ben/', filename])
    
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
    
else
    
    names = load(['Figs_Ben/', filename]);
    
    files7Hz = names.names';
    
    files7Hz = cellfun(@(x) [filename(19:26), '/', x], files7Hz, 'unif', 0);
    
end

files = files7Hz'; % [files7Hz files4Hz files2Hz];

[files_dim1, files_dim2] = size(files);

figure

for f = 2:5 % (files_dim1*files_dim2)
    
    if ~isempty(files{f})
        
        sim_spec = load(['Figs_Ben/', files{f}, '_sim_spec.mat']);
        
        data = dsImport(['Figs_Ben/', files{f}]);
        
        PPstim = [data.deepRS_PPstim];
        PPfreq = [data.deepRS_PPfreq];
        
        selected = ((PPstim + 3.9) < 10^(-5)) & ((PPfreq - 2.5) < 10^(-5));
        
        subplot(files_dim2, files_dim1, f)
        
        plotyy(data(selected).time, data(selected).deepFS_V, data(selected).deepRS_iPeriodicPulseBensVersion_input)
        
        set(gca, 'FontSize', 12)
        
        if mod(f, files_dim2) == 0, xlabel('Freq. (Hz)'), end
        
        hold on
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 3 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 3 8])

saveas(gcf, ['PLV_traces_SOM.fig'])