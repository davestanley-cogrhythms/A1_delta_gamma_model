function psps = rhythmic_spike(tau_d,tau_r,freq,shift,Tend,dt,onset,offset,Npop,inputs_per_cell,jitter)

%% Calculating indicators of spike times.
% Build train of delta functions, spaced with frequency "freq"
t=(0:dt:Tend);                            % Generate times vector.
pulse_period = 1000/freq;
spike_centers = (1+shift):pulse_period:Tend;
spike_centers(spike_centers < onset) = [];
spike_centers(spike_centers > offset) = [];

no_inputs = inputs_per_cell*Npop;

no_spikes = length(spike_centers);
jitters = randn([no_inputs, no_spikes])*jitter;
spike_times = repmat(spike_centers, no_inputs, 1) + jitters;

min_time = nanmin(nanmin(nanmin(spike_times)), 0); max_time = nanmax(nanmax(nanmax(spike_times)), Tend);

all_time = min_time:dt:max_time;

real_time_indicator = all_time >= 0 & all_time <= Tend;

spike_indicator = zeros(no_inputs, length(all_time));

for input = 1:no_inputs
    
    spike_indicator(input, max(round((spike_times(input, :) - min_time)/dt), 1)) = 1;
    
end

%% Calculating EPSP experienced by each cell.

% EPSP for spikes at time t = 0.
psp = (exp(-t/tau_d) - exp(-t/tau_r))/(tau_d - tau_r);
psp = psp(psp > eps)/max(psp);    % Shortening & normalizing psp.
psp = [zeros(1,length(psp)) psp]; % Symmetrizing psp for convolution.

C = repmat(eye(Npop), 1, no_inputs/Npop);

spike_indicator = C*spike_indicator;
    
psps = nan(Npop, length(all_time));

for c = 1:Npop
    
    psps(c, :) = conv(spike_indicator(c, :), psp, 'same');

end

psps = psps(:, real_time_indicator);
psps = psps';                           % Correct dimensions so that time is rows and cells are columns. ##Dave
