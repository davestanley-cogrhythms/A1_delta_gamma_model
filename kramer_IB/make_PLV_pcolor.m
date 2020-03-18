function make_PLV_pcolor(name)

sim_spec = load([name, '_sim_spec.mat']);

vary = sim_spec.vary;

PLV_data = load([name, '_PLV_data.mat']);

v_mean_spike_mrvs = PLV_data.v_mean_spike_mrvs;

no_spikes = PLV_data.no_spikes;

frequencies = vary{strcmp(vary(:, 2), 'PPfreq'), 3};

periods = 1./frequencies;

stim_strengths = vary{strcmp(vary(:, 2), 'PPstim'), 3};

mrv_dims = size(v_mean_spike_mrvs);

if length(frequencies) >= length(stim_strengths)
    
    v_mean_spike_mrvs = permute(v_mean_spike_mrvs, [2 1 3]);
    
end
    
mrv_for_plot = reshape(v_mean_spike_mrvs, prod(mrv_dims(1:2)), mrv_dims(3));

figure

pcolor(periods, abs(fliplr(stim_strengths)), abs(mrv_for_plot(1:length(periods), :))')

shading interp

colorbar

ylabel('Input Strength (pA)')

xlabel('Input Period (s)')

set(gca, 'FontSize', 16)

hold on

plot(1./(no_spikes(end, 1, end)/29)*[1; 1], [0; max(abs(stim_strengths))], 'Color', [1 0 1], 'LineWidth', 3)

title({'Phase-Locking as a Function of Input Strength'; sprintf('I_{app} = 8.5 pA', abs(vary{strcmp(vary(:,2), 'I_app'), 3}))})

saveas(gcf, [name, '_MRV_pcolor.fig'])

save_as_pdf(gcf, [name, '_MRV_pcolor'])