
function s = getDeltaTrainAP(freq,shift,T,dt,onset,offset,ap_pulse_num,ap_pulse_delay)

% Comment this out because it gets confusing.
% if nargin < 5
%     onset = 0;
%     offset = Inf;
% end
% if nargin < 7
%     ap_pulse_num = 0;
%     ap_pulse_delay = 0;
% end
% if nargin < 10
%     kernel_type = 1;  % Options for kernel type are:
%                                 % 1-Gaussian
%                                 % 2-Double exponential - width is decay time; width2 is rise
% end
% if nargin < 11
%     width2_rise = 0.5; % 0.5 ms by default
% end

plot_demo_on = 0;  % Plot if desired

% Build train of delta functions, spaced with frequency "freq"
t=(0:dt:T)';                            % Generate times vector
s = zeros(size(t));
pulse_period=1000/freq;
s((1+round(shift/dt)):round(pulse_period/dt):end) = 1;    % Add deltas, allowing for shift

% Set aperiodic pulse
if ap_pulse_num > 0
    ap_ind_orig = 1+round(shift/dt)+round(pulse_period/dt)*(ap_pulse_num-1);    % Index of the aperiodic pulse in the time series.
    ap_ind_new = ap_ind_orig+round(ap_pulse_delay/dt);          % Index of where it should appear after the delay.
    if ap_ind_new > length(s) || ap_ind_orig > length(s); error('Aperiodic spike placement would be outside of simulation time.'); end
    s(ap_ind_orig) = 0;                 % Delete the original pulse
    s(ap_ind_new) = 1;                  % Create pulse at the delayed location
end

% Remove anything outside of onset to offset
s(t<onset | t>offset) = 0;

end
