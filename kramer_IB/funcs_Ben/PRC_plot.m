function PRC_plot(data, results, name)

stim = [data.deepRS_STPstim]';
stims = unique(stim);

shift = [data.deepRS_STPshift]';
shifts = unique(shift);

% rand = [data.deepRS_randParam];
% rands = unique(rand);

following_spike_times = [results.following_spike_times]';
cycle_lengths = following_spike_times - repmat([results.triggering_spike_time]', 1, 2);
baseline_cycle_lengths = diag(nanmean(cycle_lengths(stim == 0, :)));
baseline_cycle_mat = ones(size(cycle_lengths))*baseline_cycle_lengths;
phase_advances = -(cycle_lengths - baseline_cycle_mat)./baseline_cycle_mat;

phase_shifts = repmat(shifts, 1, 2)*diag(1./diag(baseline_cycle_lengths));

phase_advances = reshape(phase_advances, length(stims), length(phase_shifts), 2);

% mean_pa = reshape(nanmean(phase_advances), length(stims), length(phase_shifts))';
% 
% std_pa = reshape(nanstd(phase_advances), length(stims), length(phase_shifts))';

figure

subplot(211)

plot(phase_shifts(:, 1), phase_advances(:, :, 1)) % boundedline(phase_shifts, mean_pa, prep_for_boundedline(std_pa)) % 

for s = 1:length(stims), stim_labels{s} = sprintf('STPstim = %g', abs(stims(s))); end
legend(fliplr(stim_labels))

axis tight
set(gca, 'FontSize', 16)
xlabel('Phase of Input Pulse (2\pi)')
ylabel('Spike Phase Change (2\pi)')
title(sprintf('Phase Response Curves, First Spike, Period = %g', baseline_cycle_lengths(1,1)))

subplot(212)

plot(phase_shifts(:, 2), phase_advances(:, :, 2)) % boundedline(phase_shifts, mean_pa, prep_for_boundedline(std_pa)) % 

for s = 1:length(stims), stim_labels{s} = sprintf('STPstim = %g', abs(stims(s))); end
legend(fliplr(stim_labels))

axis tight
set(gca, 'FontSize', 16)
xlabel('Phase of Input Pulse (2\pi)')
ylabel('Spike Phase Change (2\pi)')
title(sprintf('Phase Response Curves, Second Spike, Period = %g', baseline_cycle_lengths(2,2)))

save_as_pdf(gcf, [name, '_PRC'])
