function pulses = getVariedPulses(freq_range,width_range,shift_range,T,dt,onset,offset,Npop,kernel_range,width2_rise,center_flag,norm,jitter)

% Defining periods of random length, uniformly chosen within frequency
% range.

% period_range = 1000./freq_range;
    
mean_cycles = round(T*mean(freq_range)/1000);

pswk = ones(1, 4); % Array to hold periods, widths, shifts, kernels.

pswk_range = [freq_range; width_range; shift_range; kernel_range];

while max(cumsum(pswk(:, 1))) < min(T, offset)
    
    these_specs = nan(mean_cycles, 4);
    
    for i = 1:4
        
        these_specs(:, i) = rand(mean_cycles, 1)*range(pswk_range(i, :), 2) + min(pswk_range(i, :));
        
        if i == 4
            
            these_specs(:, i) = round(these_specs(:, i));
            
        end
        
    end
        
    pswk = [pswk; these_specs];
    
end

pswk = pswk(2:end, :);

pswk(:, 1) = 1000./pswk(:, 1);

% pswk(:, 3) = min(pswk(:, 3), 1 - pswk(:, 2));

pswk(:, 2) = prod(pswk(:, 1:2), 2);

pswk(:, 3) = prod([pswk(:, 1) - pswk(:, 2), pswk(:, 3)], 2); % [1 3]), 2);

period_start = cumsum([1; pswk(:, 1)]);

period_end = cumsum(pswk(:, 1));

periods_in_bound = period_end < min(T, offset);

first_out_of_bound = find(~periods_in_bound, 1, 'first');

periods_in_bound(first_out_of_bound) = true;

pswk = pswk(periods_in_bound, :);

no_periods = size(pswk, 1);

pulses = zeros(onset/dt, 1);

t = 0:dt:T;

for p = 1:no_periods
    
    if period_start(p) >= onset
        
        thisPulse = getPeriodicPulseFastBensVersion(1000./pswk(p, 1),pswk(p, 2),pswk(p, 3),pswk(p,1),dt,0,inf,Npop,pswk(p,4),width2_rise,center_flag,norm,jitter,0);
        
        pulses = [pulses; thisPulse];
        
    end
    
end

if length(pulses) < length(t)
   
    pulses(end:(end + length(t) - length(pulses) + 1)) = 0;
    
end

pulses = sum(t>=onset & t<=offset)*dt*pulses/sum(pulses*dt);

end
