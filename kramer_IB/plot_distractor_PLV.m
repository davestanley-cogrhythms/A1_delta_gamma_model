function plot_distractor_PLV(data_info_file)

if nargin < 1, data_info_file = []; end

if isempty(data_info_file)
    
    data_name =  {'11_21_50.83', '11_22_57.69', '11_24_11.94', '11_25_25.72', '11_26_38.93'}; % {'16_29_54.39', '16_31_7.798', '16_32_32.04', '16_33_54.12', '16_35_17.57'}; % {'12_16_42.79', '12_17_39.73', '12_19_0.9733', '12_20_23.21', '12_21_38.37'};
    % {'17_30_27.67', '17_31_31.24', '17_32_30.89', '17_33_33.04', '17_34_35.89'}; % {'15_31_23.47', '15_31_55.62', '15_32_38.32', '15_33_19.94', '15_34_1.601'};
    
    data_hour = data_name{1}(1:2);
    
    data_name = cellfun(@(x) ['kramer_IB_', x], data_name, 'unif', 0);
    
    data_date = '19-07-10'; % '19-07-08'; % '19-06-27'; % '19-06-21';
    
    plot_name = [data_date, '/distractor_', data_date, '_', data_hour];
    
else
    
    data_info = load(data_info_file);
    
    data_name = data_info.names;
    
    data_date = data_info.sim_name; data_date = data_date(12:19);
    
    plot_name = [data_date, '/', data_info_file(1:(end - 4))];
    
end

model_labels = {'M', 'I', 'IC', 'MC', 'MIC'};

PLV_type = {'iPeriodicPulsesBen_input_deepRS_PPfreq', 'iPeriodicDistractors_input_deepRS_PDfreq'};

for t = 1:(length(PLV_type) + 1), figure_handles{t} = figure; end

for d = 1:length(data_name)
    
    for t = 1:length(PLV_type)
        
        PLV_data = load([data_date, '/', data_name{d}, '_deepRS_', PLV_type{t}, '_interp_square_PLV_data.mat']);
        
        adjustedPLV = ((abs(PLV_data.v_mean_spike_mrvs).^2).*PLV_data.no_spikes - 1)./(PLV_data.no_spikes - 1);
        
        sizePLV = size(adjustedPLV);
        
        adjustedPLV = reshape(permute(adjustedPLV, [2 1 3]), prod(sizePLV(1:2)), sizePLV(3));
        
        adjustedPLVcell{t} = adjustedPLV(:, 1:(end - 1)) - repmat(adjustedPLV(:, end), 1, sizePLV(3) - 1);
        
    end
    
    adjustedPLVcell{length(PLV_type) + 1} = (adjustedPLVcell{1} - adjustedPLVcell{2}); % ./(adjustedPLVcell{1} + adjustedPLVcell{2});
    
    sim_struct = load([data_date, '/', data_name{d}, '_sim_spec.mat']);
    
    band_limits = get_vary_field(sim_struct.vary, 'PDfreq'); % '(DPlowfreq, DPhighfreq)');
    band_center = band_limits;
    % band_center = mean(band_limits);
    
    stim = get_vary_field(sim_struct.vary, 'PPstim'); % '(PPstim, PDstim)'); % 'DPstim');
    
    colors = flipud(cool(length(stim)));

    for t = 1:(length(PLV_type) + 1)
        
        figure(figure_handles{t})
        
        subplot(length(data_name), 1, d)
        
        set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
        
        plot(band_center, adjustedPLVcell{t}(1:length(band_center), :), 'LineWidth', 1)
        
        pos = get(gca, 'Position');
        
        myLegend = cellfun(@(x) ['Stim. = ', num2str(x)], mat2cell(stim, 1, ones(1, length(stim))), 'unif', 0);
        
        if d == length(data_name)
            
            xlabel('Distractor Freq. (Hz)')
            legend(myLegend(2:end))
            
        end
        
        %    if d == 1, colorbar, end
        %
        %    set(gca, 'Position', pos)
        
        axis tight, box off
        
        ylabel(model_labels{d})
        
    end
    
end

figure_labels = {'pulse', 'distractor', 'difference'};

for t = 1:length(figure_labels)

    saveas(figure_handles{t}, [plot_name, '_', figure_labels{t}, '.fig'])

    save_as_pdf(gcf, [plot_name, '_', figure_labels{t}])

end