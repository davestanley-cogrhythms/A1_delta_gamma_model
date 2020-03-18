function make_PLV_pcolor_by_PPstim(name)

if ~exist([name, '_PLV_data.mat'], 'file')
    
    results = dsImportResults(name, 'phase_metrics');
    
    [~] = spike_locking_to_input_plot(results, results, name);
    
end

load([name, '_PLV_data.mat'])
load([name, '_sim_spec.mat'])

msmrv_size = size(v_mean_spike_mrvs);
MRV = reshape(permute(v_mean_spike_mrvs, [2 1 3]), prod(msmrv_size([1 2])), msmrv_size(3));

nspikes = reshape(permute(no_spikes, [2 1 3]), prod(msmrv_size([1 2])), msmrv_size(3));

PLV = ((abs(MRV).^2).*nspikes - 1)./nspikes;

frequencies = pick_vary_field(vary, 'PPfreq');

inputs = pick_vary_field(vary, 'PPstim');

figure, pcolor(frequencies, fliplr(abs(inputs)), PLV(1:length(frequencies), :)')

shading interp

axis xy

set(gca, 'FontSize', 16)

xlabel('Freq. (Hz)')

ylabel('Input Strength (pA)')

title(['Phase-Locking for ', name], 'Interpreter', 'none')

hold on

plot((all_dimensions(@nanmean, 1000*no_spikes(:, :, end))/(sim_struct.tspan(end)-1000))*[1; 1], [0; max(abs(inputs))], 'Color', [1 0 1], 'LineWidth', 3)

saveas(gcf, [name, '_PLV_pcolor.fig'])