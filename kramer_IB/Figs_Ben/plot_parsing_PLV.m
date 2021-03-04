function plot_parsing_PLV(data_info_file)

if nargin < 1, data_info_file = []; end

if isempty(data_info_file)
  
    data_names = {'17_17_34.11', '15_45_25.97', '17_18_47.97', '17_20_30.25', '17_22_12.66', '17_23_52.18'};
%     data_names = {'11_12_38.06', '', '11_13_44.43', '11_15_9.333', '11_16_25.31', '11_17_38.36'}; % {'17_30_29.7', '17_31_2.912', '17_31_48.55', '17_32_43.9', '17_33_34.26'};
    
    data_hour = data_names{1}(1:2);
    
    data_names = cellfun(@(x) ['kramer_IB_', x], data_names, 'unif', 0);
    
    data_date = '19-08-08'; % '19-07-10'; % '19-06-21';
    
    data_dates = cell(size(data_names));
    
    [data_dates{:}] = deal(data_date);
    
    data_dates{2} = '19-12-03'; % data_names{2} = 'kramer_IB_15_45_25.97';
    
%     data_dates{3} = '19-07-19'; data_names{2} = 'kramer_IB_16_14_3.699'; % '19-07-17'; data_names{2} = 'kramer_IB_16_31_25.8';
%     
%     data_dates{4} = '19-07-17'; data_names{3} = 'kramer_IB_16_35_22.07';
%     
%     data_dates{5} = '19-07-19'; data_names{4} = 'kramer_IB_16_53_14.53';
    
    data_date = datestr(datenum(date),'yy-mm-dd');
    
    plot_name = [data_date, '/parsing_', data_date, '_', data_hour];
    
else
    
    data_info = load(data_info_file);
    
    data_names = data_info.names;
    
    if ~isfield(data_info, 'data_dates')
    
        data_date = data_info.sim_name; data_date = data_date(9:16);
   
        data_dates = cell(size(data_names));

        [data_dates{:}] = deal(data_date);
        
    else
        
        data_dates = data_info.data_dates;
        
        data_date = datestr(datenum(date),'yy-mm-dd');
        
    end
    
    plot_name = [data_date, '/', data_info_file(1:(end - 4))];
    
end

model_labels = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

figure

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 8 2], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 8 2])

for d = 1:length(data_names)
    
   PLV_data = load([data_dates{d}, '/', data_names{d}, '_deepRS_iVariedPulses_input_deepRS_VPlowfreq_interp_square_PLV_data.mat']);
   
   adjustedPLV = ((abs(PLV_data.v_mean_spike_mrvs).^2).*PLV_data.no_spikes - 1)./(PLV_data.no_spikes - 1);
   
   sizePLV = size(adjustedPLV);
   
   if length(sizePLV) > 2
       
       adjustedPLV = reshape(permute(adjustedPLV, [2 1 3]), prod(sizePLV(1:2)), sizePLV(3));
       
   end
   
   sim_struct = load([data_dates{d}, '/', data_names{d}, '_sim_spec.mat']);
   
   band_limits = get_vary_field(sim_struct.vary, '(VPlowfreq, VPhighfreq'); % '(FMPlowfreq, FMPhighfreq)');
   band_width = diff(band_limits(1:2, :));
   
   stim = get_vary_field(sim_struct.vary, 'VPstim');
   
   colors = cool(length(stim) - 1);
   
   subplot(1, length(data_names), d)
   
   set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
   
   plot(band_width, flipud(adjustedPLV(:, 1:(end - 1))'), 'LineWidth', 2) % (1:length(band_width), :), 'LineWidth', 1)
   
%    pos = get(gca, 'Position');
   
%    myLegend = cellfun(@(x) ['Stim. = ', num2str(x)], mat2cell(stim, 1, ones(1, length(stim))), 'unif', 0); 
       
   xlabel({'Input';'Bandwidth (Hz)'})
   
   axis tight, box off, ylim([0 1])
   
   if d == length(data_names) % d == 1
       
       set(gca, 'YTick', [])
       
       cbar = nochange_colorbar(gca);
       
       climits = get(cbar, 'Limits');
       
       cticks = climits(1):(range(climits)/(length(stim))):climits(2);
       
       set(cbar, 'ColorMap', colors, 'Ticks', cticks(2:(end - 1)), 'TickLabels', stim(2:end))
       
       ylabel(cbar, 'Stim. Strength')
       
   elseif d == 1
       
       ylabel('PLV')
       
   else
       
       set(gca, 'YTick', [])
       
   end % elseif d == length(data_names)
       %legend(fliplr(myLegend))
   
   % end
   
%    if d == 1, colorbar, end
%    
%    set(gca, 'Position', pos)
   
   % ylabel(model_labels{d})
   
   allPLV{d} = adjustedPLV;
    
end

% set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 8 2], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 8 2])

saveas(gcf, [plot_name, '.fig'])

save_as_pdf(gcf, plot_name)