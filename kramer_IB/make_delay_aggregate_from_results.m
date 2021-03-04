function make_delay_aggregate_from_results

folder = '20-08-21';

filenames = {'kramer_IB_2_21_1.284';
    'kramer_IB_4_25_8.054';
    'kramer_IB_16_6_6.232';
    'kramer_IB_11_29_43.2';
    'kramer_IB_18_54_12.1';
    'kramer_IB_18_15_31.99'};

for f = 1:length(filenames)
    
    subplot(length(filenames), 1, f)
    
    results = load([folder, '/', filenames{f}, '_delay.mat']);
    results = results.results;
    
    sim_spec = load([folder, '/', filenames{f}, '_sim_spec.mat']);
    vary = sim_spec.vary;
    
    STPstim = get_vary_field(vary, 'STPstim');
    STPwidth = get_vary_field(vary, 'STPwidth');
    
    periods = 4*STPwidth;
    frequencies = 1000./(4*STPwidth);
    stims = abs(STPstim);
    
    results_cell = struct2cell(results);
    delay_time_cell = squeeze(results_cell(1, 1, :));
    empty_delays = find(cellfun(@isempty, delay_time_cell));
    for e = 1:length(empty_delays)
        delay_time_cell{empty_delays(e)} = 0;
    end
    
    delay_time = reshape(cell2mat(delay_time_cell), length(STPwidth), length(STPstim));
    period_mat = diag(periods)*ones(size(delay_time));
    
    PLV_estimate = delay_time >= period_mat;
    
    pcolor(frequencies, stims, double(PLV_estimate)')
    
    hold on
    
    plot([7, 7], [min(stims), max(stims)], 'm', 'LineWidth', 2)
    
    axis xy
    
    shading interp
    
    if f == length(filenames)
        
        xlabel('Frequencies (Hz)')
        
        ylabel('Input Strength')
        
    else
        
        set(gca, 'XTick', [], 'YTick', [])
        
    end
    
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 1.5 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 1.5 8])

saveas(gcf, ['delay_aggregate.fig'])

end