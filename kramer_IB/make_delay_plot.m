function make_delay_plot(name)

result_name = [name, '_delay.mat'];

if exist(result_name, 'file') == 2
    
    result_struct = load(result_name);
    
    results = result_struct.results;
    
else

    data = dsImport(name);
    
    results = dsAnalyze(data, @delay);
    
    save(result_name, 'results', 'name')
    
end

sim_spec = load([name, '_sim_spec.mat']);
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

save([name, '_PLV_estimate.mat'], 'PLV_estimate', 'delay_time', 'name', 'frequencies', 'stims')

pcolor(frequencies, stims, double(PLV_estimate)')

axis xy

shading interp

xlabel('Frequencies (Hz)')

ylabel('Input Strength')

saveas(gcf, [name, '_delay.fig']) 