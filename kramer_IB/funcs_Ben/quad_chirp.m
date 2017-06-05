function [rhythm, freqs, time] = quad_chirp(dt, T, sampling_freq, freq_lims, pow, plot_opt)

if nargin < 6, plot_opt = 0; end

time = (0:dt:T)/sampling_freq;

freqs_a = 4*range(freq_lims)/time(end)^2;
freqs_b = min(freq_lims);
freqs = -freqs_a*time.*(time - time(end)) + freqs_b;

rhythm = -cos(2*pi*cumsum(freqs*dt/sampling_freq))';

rhythm = sign(rhythm).*abs(rhythm).^pow;

rhythm = (rhythm + 1)/2;

if plot_opt
   
    subplot(2, 1, 1)
    
    plot(time', freqs'), box off, axis('tight')
    
    ylim(freq_lims + [-.25 .25]*range(freq_lims))
    
    subplot(2, 1, 2)
    
    plot(time, rhythm), box off, axis('tight')
    
end


