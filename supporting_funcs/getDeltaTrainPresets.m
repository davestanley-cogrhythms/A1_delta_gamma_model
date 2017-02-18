
function s = getDeltaTrainPresets(freq,shift,T,dt,onset,offset,pulse_num,ap_pulse_delay,preset_number)

% Preset numbers:
% 0 - pure pulse train
% 1 - AP pulse
% 2 - AP + reset
% 3 - Dropped pulse
% 4 - Extra pulse
% 5 - Extra pulse + reset

plot_demo_on = 0;  % Plot if desired. Turn this on to see
                   % how the different presets behave

% Build train of delta functions, spaced with frequency "freq"
t=(0:dt:T)';                            % Generate times vector
s = zeros(size(t));
pulse_period=1000/freq;
s((1+round(shift/dt)):round(pulse_period/dt):end) = 1;    % Add deltas, allowing for shift

% Manipulate the pulse given by "pulse_num" in one of the following ways.
if pulse_num > 0
    switch preset_number
        case 0                  % Pure pulse train
            % (do nothing)
        case 1                  % Aperiodic pulse
            s = add_pulse (s,pulse_period,shift,dt,pulse_num,ap_pulse_delay);
            s = delete_pulse (s,pulse_period,shift,dt,pulse_num);
        case 2                  % AP pulse + reset
            s = add_pulse (s,pulse_period,shift,dt,pulse_num,ap_pulse_delay);
            s = delete_pulse (s,pulse_period,shift,dt,pulse_num);
            shift_amount = ap_pulse_delay;
            s = delay_pulsetrain(s,pulse_period,shift,dt,pulse_num+.9,shift_amount);
                % Note: Shifting 0.9 pulses AFTER the AP pulse, so that the
                % new zeros are added AFTER where the new AP pulse is
                % inserted. This delays all downstream pulses by that
                % amount (e.g. 11ms), essentially resettting the gamma
                % train.
        case 3              % Delete pulse
            s = delete_pulse (s,pulse_period,shift,dt,pulse_num);
        case 4
            s = add_pulse (s,pulse_period,shift,dt,pulse_num,ap_pulse_delay);
        case 5
            s = add_pulse (s,pulse_period,shift,dt,pulse_num,ap_pulse_delay);
            shift_amount = ap_pulse_delay;
            s = delay_pulsetrain(s,pulse_period,shift,dt,pulse_num+.9,shift_amount);
            
            
    end
end

% Remove anything outside of onset to offset
s(t<onset | t>offset) = 0;


if plot_demo_on                 % Plot if desired
    figure; 
    plot(t,s);
end


end

function s = add_pulse (s,pulse_period,shift,dt,pulse_num,new_pulse_pos_relative)

        ap_ind_orig = 1+round(shift/dt)+round(pulse_period/dt)*(pulse_num-1);    % Index of the aperiodic pulse in the time series.
        ap_ind_new = ap_ind_orig+round(new_pulse_pos_relative/dt);          % Index of where it should appear after the delay.

        if ap_ind_new > length(s) || ap_ind_orig > length(s)
            %fprintf('Spike placement would be outside of simulation time.\n');
        else
            s(ap_ind_new) = 1;                  % Create pulse at the delayed location
        end

end

function s = delete_pulse (s,pulse_period,shift,dt,pulse_num)
        ap_ind_orig = 1+round(shift/dt)+round(pulse_period/dt)*(pulse_num-1);    % Index of the aperiodic pulse in the time series.
        s(ap_ind_orig) = 0;                 % Delete the original pulse
end

function s = delay_pulsetrain(s,pulse_period,shift,dt,pulse_num,shift_amount)
    % Delays all pulses in the pulse train after pulse_num
    ap_ind_orig = 1+round(shift/dt)+round(round(pulse_period/dt)*(pulse_num-1));    % Index of the aperiodic pulse in the time series.
    % Add zeros after original index
    %s = cat(1,s(1:ap_ind_orig+1),zeros(round(shift_amount/dt),1),s(ap_ind_orig+2:end-round(shift_amount/dt)));
    s(ap_ind_orig+1+round(shift_amount/dt):end) = s(ap_ind_orig+1:end-round(shift_amount/dt));
    s(ap_ind_orig+1:ap_ind_orig+1+round(shift_amount/dt)-1) = 0;
        % Sets a total of round(shift_amount/dt) data points to zero.
        % This makes sense if you draw it out on paper. (E.g. assume
        % round(shift_amount/dt)-1 is 2).
end

