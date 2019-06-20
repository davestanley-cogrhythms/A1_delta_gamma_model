function data_subtracted = subtract_peaks(data, peak_indicator, peak_form, plot_opt)

data = detrend(data);
data_subtracted = data;

peak_indices = find(peak_indicator);

no_peaks = size(peak_indices, 1);

peak_size = size(peak_form);
if peak_size(2) > 1, peak_form = peak_form'; end
peak_size = max(peak_size);

peak_form = peak_form - nanmean(peak_form);
peak_form = peak_form/norm(peak_form, 2);

[peak_forms, standard_windows, envelopes] = deal(cell(2, 1));
peak_forms{1} = peak_form;
% peak_forms{2} = ones(11,1)/norm(ones(11,1), 2); 

standard_windows{1} = (1:peak_size) - ceil(peak_size/2) - 1;
standard_windows{2} = (1:21) - 10;

for w = 1:2

    x_envelope = standard_windows{w}/max(standard_windows{w});

    envelope = exp(-1./(1 - x_envelope.^2))';
    envelope(isinf(envelope)) = 0;
    envelope = envelope/max(envelope);
    
    envelopes{w} = envelope;
    
end

if no_peaks > 1
    
    for p = 1:no_peaks
        
        % Get location of current peak.
        loc = peak_indices(p);
        
        for w = 1:2
            
            % Get beginning and end of window that surrounds the peak.
            window_indices = loc + standard_windows{w};
            window_indicator = window_indices >= 0 & window_indices <= length(data_subtracted);
            window_indices = window_indices(window_indicator);
            
            peak_data = data_subtracted(window_indices);
            
            if w == 2
                
                peak_data_normalized = peak_data - nanmean(peak_data);
                peak_data_normalized = peak_data/norm(peak_data, 2);
                peak_forms{w} = peak_data_normalized;
                
            end
            
            peak_proj = (peak_data'*peak_forms{w}(window_indicator))*peak_forms{w}(window_indicator);
            
            peak_subtracted = peak_data - envelopes{w}(window_indicator).*peak_proj;
            
            data_subtracted(window_indices) = peak_subtracted;
            
            if plot_opt > 0
                
                figure
                
                % subplot(211) % (311)
                
                plot(window_indices, [peak_data, peak_forms{w}(window_indicator),...
                    peak_subtracted, peak_proj, envelopes{w}(window_indicator).*peak_proj])
                
                axis tight
                
                legend({'Data', 'Centroid', 'Subtracted', 'Projection', 'Windowed Proj.'})
                
                title(sprintf('Peak %d, Stage %d', p, w))
                
                save_as_pdf(gcf, sprintf('peak%d_stage%d', p, w))
                
                %             if plot_opt == 1
                %
                %                 w = waitforbuttonpress;
                %
                %                 if w, close('all'), end
                %
                %             end
                
            end
            
        end
        
    end
    
end