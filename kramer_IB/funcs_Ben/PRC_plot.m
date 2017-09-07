function PRC_plot(data, results, name)

stim = [data.deepRS_STPstim];
stims = unique(stim);

shift = [data.deepRS_STPshift];
shifts = unique(shift);

first_spike_times = [results.first_spike_time];
cycle_lengths = first_spike_times - [results.triggering_spike_time];
baseline_cycle_length = nanmean(cycle_lengths(stim == 0));
phase_advances = -(cycle_lengths - baseline_cycle_length)./baseline_cycle_length;

phase_shifts = shifts/nanmean(cycle_lengths);

phase_advances = reshape(phase_advances, length(phase_shifts), length(stims));

figure, plot(phase_shifts, phase_advances)

for s = 1:length(stims), stim_labels{s} = sprintf('STPstim = %g', abs(stims(s))); end
legend(fliplr(stim_labels))

set(gca, 'FontSize', 16)
xlabel('Phase of Input Pulse (2\pi)')
ylabel('Spike Phase Change (2\pi)')
title('Phase Response Curves')

save_as_pdf(gcf, [name, '_PRC'])
