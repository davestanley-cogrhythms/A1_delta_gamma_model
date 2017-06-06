function [rhythm, freqs, time] = linear_chirp(dt, T, sampling_freq, freq_lims, pow, plot_opt)

if nargin < 6, plot_opt = 0; end

time = (0:dt:T)/sampling_freq;
halftime = time(end)/2;

freqs1 = range(freq_lims)*time(time < halftime)/halftime + min(freq_lims);
freqs2 = -range(freq_lims)*time(time >= halftime)/halftime + 2*range(freq_lims) + min(freq_lims);
freqs = [freqs1 freqs2];

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


