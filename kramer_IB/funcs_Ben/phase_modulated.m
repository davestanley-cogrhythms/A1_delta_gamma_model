function rhythm = phase_modulated(dt, T, sampling_freq, freq_lims, window_length, pow, plot_opt)

if nargin < 7, plot_opt = 0; end

time = (0:dt:T)/sampling_freq;

no_windows = T/window_length;

no_transitions = round(T/window_length);

transitions = sort(max(round(rand(1, no_transitions)*length(time)),1)); % Take no_transitions random numbers between 1 and T, sort 'em. 
    
transitions = [transitions length(time)];

if transitions(1) > 1, transitions = [1 transitions]; end

no_frequencies = length(transitions) - 1;

frequencies = zeros(no_frequencies, 1);

frequencies = rand(size(frequencies)).*(max(freq_lims) - min(freq_lims)) + min(freq_lims);

freq_vector = zeros(size(time));

for f = 1:no_frequencies
    
    freq_vector(transitions(f):transitions(f + 1)) = frequencies(f);
    
end

flip_length = min(sampling_freq/dt, length(time));

fv_flipped = [fliplr(freq_vector(1:flip_length)), freq_vector, fliplr(freq_vector((end - flip_length + 1):end))];

kernel = zeros(1, round(window_length/(2*dt)));

kernel = gauss(round(window_length/(2*dt)), 2.5);

kernel = kernel/sum(kernel');

fv_conv = zeros(size(fv_flipped));

fv_conv = conv(fv_flipped, kernel, 'same');

fv_conv = fv_conv((flip_length + 1):(end - flip_length));

rhythm = -cos(2*pi*cumsum(fv_conv*dt/1000))';

rhythm = sign(rhythm).*abs(rhythm).^pow;

% rhythm = (rhythm + 1)/2;

if plot_opt
   
    subplot(2, 1, 1)
    
    plot(time', [freq_vector; fv_conv]'), box off, axis('tight')
    
    ylim(freq_lims + [-.25 .25]*range(freq_lims))
    
    subplot(2, 1, 2)
    
    plot(time, rhythm), box off, axis('tight')
    
end


