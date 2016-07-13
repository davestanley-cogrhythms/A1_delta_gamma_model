
function s3 = getAperiodicPulse(freq,width,shift,T,dt,onset,offset,ap_pulse_num,ap_pulse_delay,Npop,kernel_type,width2_rise)

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

% Build kernel
if kernel_type < 1.5
        kernel_length=4*width;                      % Length of kernel time series
        t2 = -kernel_length:dt:kernel_length-dt;    % Generate time vector
        %kernel = 1/(width*sqrt(2*pi)) * exp(-t.^2/2/width^2);
        kernel = 1 * exp(-t2.^2/2/width^2);      % Build kernel. Peaks at 1.0.
elseif kernel_type < 2.5
        kernel_length=8*width;                      % Length of kernel time series
        t2 = -kernel_length:dt:kernel_length-dt;    % Generate time vector
        t2(1:floor(kernel_length/dt) + 1) = 0;
        kernel = (exp(-t2/width) - exp(-t2/width2_rise)) * (width*width2_rise)/(width-width2_rise);     % This normalization constant is wrong
        kernel = kernel / max(kernel);          % Do normalization manually for now.
else
        % For debugging; should not reach this!!
        kernel_length=4*width;                      % Length of kernel time series
        t2 = -kernel_length:dt:kernel_length-dt;    % Generate time vector
        %kernel = 1/(width*sqrt(2*pi)) * exp(-t.^2/2/width^2);
        kernel = 1 * exp(-t2.^2/2/width^2);      % Build kernel. Peaks at 1.0.
        kernel = kernel * -1;
end


% Convolve kernel with deltas
s2=conv(s,kernel(:));
N2=length(s2); N=length(s);
starting = round((N2-N)/2);
s3=s2(1+starting:N+starting);       % Each edge we're dropping should be half the difference in the length of the two vectors.
%s2=wkeep(s2,length(s),'c');        % wkeep doesn't work with compiled code


if plot_demo_on                 % Plot if desired
    figure; 
    subplot(211); plot(t,s);
    t2=[1:length(s2)]*dt;
    t3=t2(1+starting:N+starting);
    legend('Delta train');
    subplot(212); plot(t2,s2);
    hold on; plot(t3,s3);
    legend('Original convolution','Keep only center');
end


s3 = repmat(s3(:),[1,Npop]);
    
end
