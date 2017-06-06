function results = spike_metrics(data, varargin)

v_pop = 'pop1';

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

voltage = [v_pop, '_V'];

t = data.time;

v = data.(voltage);

v = v(t >= 1000); t = t(t >= 1000);

%% Getting spike times and computing ISIs.

v_spikes = [diff(v > 0) == 1; zeros(1, size(v, 2))];

pd_length = (t(end) - t(1))/no_periods; t_pd = nan(length(t), no_periods);

no_spikes = nan(no_periods, 1);

[ISIs, Freqs] = deal(cell(no_periods, 1));

for p = 1:no_periods
   
   t_pd(:, p) = t > (p - 1)*pd_length & t <= p*pd_length;
   
   no_spikes(p) = sum(v_spikes & t_pd(:, p));

   ISIs{p} = diff(t(v_spikes & t_pd(:, p))); % In milliseconds.
    
   Freqs{p} = 1000./ISIs{p}; % Transform to frequencies.
   
end

results = struct('ISIs', ISIs, 'Freqs', Freqs);