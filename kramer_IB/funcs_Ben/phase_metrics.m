function results = phase_metrics(data, varargin)

v_pop = 'pop1';

i_pop = 'pop1';

figure_flag = 0;

no_periods = 1;

if ~isempty(varargin)
    
    for v = 1:(length(varargin)/2)
        
        if strcmp(varargin{2*v - 1}, 'i_pop')
            
            i_pop = varargin{2*v};
        
        elseif strcmp(varargin{2*v - 1}, 'v_pop')
            
            v_pop = varargin{2*v};
            
        elseif strcmp(varargin{2*v - 1}, 'figure_flag')
            
            figure_flag = varargin{2*v};
            
        elseif strcmp(varargin{2*v - 1}, 'no_periods')
            
            no_periods = varargin{2*v};
            
        end
        
    end
    
end

voltage = [v_pop, '_v'];

input = [i_pop, '_iPeriodicPulses_input'];

freq = [i_pop, '_PPfreq'];

t = data.time;

v = getfield(data, voltage);

i = getfield(data, input);

sampling_freq = round(1000*length(t)/t(end));

v = v(t >= 1000); i = i(t >= 1000); t = t(t >= 1000);

%% Getting peak frequency.

[v_hat, f] = pmtm(detrend(v), 2, [], sampling_freq, 'eigen');

gauss_kernel = normpdf(-2:.2:2, 0, .5);

gauss_kernel = gauss_kernel/sum(gauss_kernel);

v_hat_smoothed = conv(v_hat, gauss_kernel, 'same');

peak_freq = f(v_hat_smoothed == max(v_hat_smoothed));

freqs = [getfield(data, freq) 4.5 peak_freq]'; no_cycles = [7 7 7]'; no_freqs = length(freqs);

%% Getting wavelet components.

v_bandpassed(:, 1) = wavelet_spectrogram(-i, sampling_freq, freqs(1), no_cycles(1), 0, '');

v_bandpassed(:, 2:3) = wavelet_spectrogram(v, sampling_freq, freqs(2:3), no_cycles(2:3), 0, '');

v_phase = angle(v_bandpassed);

if figure_flag

    figure, subplot(4, 1, 1)
    
    t_cutoff = 6000;
    
    [v_hat_fig, f_fig] = pmtm(detrend(v(t <= 6000)), 2, [], sampling_freq, 'eigen');
    
    plot(f_fig(f_fig <= 15), v_hat_fig(f_fig <= 15))
    
    t_end = t(t <= 6000)/1000; % 3000;
    
    for frequency = 1:3
        
        subplot(4, 2, 2 + 2*(frequency - 1) + 1)
        
        ax = plotyy(t_end, real(v_bandpassed(t <= 6000, frequency)), t_end, v(t <= 6000));
        
        ylabel([num2str(freqs(frequency), '%.2g'), ' Oscillation'], 'FontSize', 12)
        
        for a = 1:2, set(ax(a), 'XLim', [t_end(1) t_end(end)]), end
    
        subplot(4, 2, 2 + 2*(frequency - 1) + 2)
        
        ax = plotyy(t_end, angle(v_bandpassed(t <= 6000, frequency)), t_end, v(t <= 6000));
        
        ylabel([num2str(freqs(frequency), '%.2g'), ' Phase'], 'FontSize', 12)
        
        for a = 1:2, set(ax(a), 'XLim', [t_end(1) t_end(end)]), end
        
    end
    
end

%% Getting spike times and computing spike phases.

v_spikes = [diff(v > 0) == 1; zeros(1, size(v, 2))];

pd_length = (t(end) - t(1))/no_periods; t_pd = nan(length(t), no_periods);

no_spikes = nan(no_periods, 1);

for p = 1:no_periods
   
   t_pd(:, p) = t > (p - 1)*pd_length & t <= p*pd_length;
   
   no_spikes(p) = sum(v_spikes & t_pd(:, p));
    
end

v_spike_phases = nan(max(no_spikes), no_periods, no_freqs);

% colors = {[1 1 0]; [1 0 1]; [0 1 1]};

% if figure_flag
%    
%     figure
%     
%     subplot(no_periods + 1, 1, 1)
%     
%     plotyy(t, v, t, v_spikes)
    
for f = 1:no_freqs
    
    for p = 1:no_periods
        
        % subplot(no_periods + 1, no_freqs, p*no_freqs + f)
        
        v_spike_phases(1:no_spikes(p), p, f) = v_phase(logical(v_spikes & t_pd(:, p)), f);
        
        % h = rose(gca, v_spike_phases(:, p, f));
        %
        % set(h, 'LineWidth', 2, 'Color', colors{p})
        %
        % % x = get(h, 'XData'); y = get(h, 'YData');
        % %
        % % patch(x, y, colors{p})
        %
        % hold on
        
    end
    
end
    
% end

% %% Computing phase-phase relationships.
% 
% no_bins = 18;
% 
% bin_centers = 1:no_bins;
% 
% bin_centers = (bin_centers - 1)*2*pi/no_bins - pi*(no_bins - 1)/no_bins;
% 
% bin_left_endpoints = bin_centers - pi/no_bins;
% 
% bin_right_endpoints = bin_centers + pi/no_bins;
% 
% f_pairs = nchoosek(1:no_freqs, 2); no_f_pairs = size(f_pairs, 1);
% 
% [v_phase_coh, v_phase_angle] = deal(nan(no_bins, no_freqs, no_freqs));
% 
% v_phase_phase = nan(no_bins, no_bins, no_f_pairs);
% 
% for fp = 1:no_f_pairs
%     
%     for b1 = 1:no_bins
%         
%         b1_indicator = v_phase(:, f_pairs(fp, 1)) >= bin_left_endpoints(b1) & v_phase(:, f_pairs(fp, 1)) < bin_right_endpoints(b1);
%         
%         v_phase_coh(b1, f_pairs(fp, 2), f_pairs(fp, 1)) = circ_r(v_phase(b1_indicator, f_pairs(fp, 2)));
%         
%         v_phase_angle(b1, f_pairs(fp, 2), f_pairs(fp, 1)) = circ_mean(v_phase(b1_indicator, f_pairs(fp, 2)));
%         
%         for b2 = 1:no_bins
%    
%             b2_indicator = v_phase(:, f_pairs(fp, 2)) >= bin_left_endpoints(b2) & v_phase(:, f_pairs(fp, 2)) < bin_right_endpoints(b2);
%         
%             v_phase_coh(b2, f_pairs(fp, 1), f_pairs(fp, 2)) = circ_r(v_phase(b2_indicator, f_pairs(fp, 1)));
%         
%             v_phase_angle(b2, f_pairs(fp, 1), f_pairs(fp, 2)) = circ_mean(v_phase(b2_indicator, f_pairs(fp, 1)));
%             
%             v_phase_phase(b2, b1, fp) = sum(b1_indicator & b2_indicator);
%     
%         end
%         
%     end
%     
% end

results = struct('v_spike_phases', v_spike_phases, 'peak_freq', peak_freq); % , 'v_phase_coh', v_phase_coh, 'v_phase_angle', v_phase_angle, 'v_phase_phase', v_phase_phase);