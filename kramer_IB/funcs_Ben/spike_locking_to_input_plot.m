function results = spike_locking_to_input_plot(data, results, name, varargin)

v_field = 'deepRS_V'; i_field = 'deepRS_iPeriodicPulsesBen_input'; f_field = 'deepRS_PPfreq';
i_transform = 'wavelet'; label = '';

if ~isempty(varargin)
    
    for v = 1:(length(varargin)/2)
        
        if strcmp(varargin{2*v - 1}, 'i_field')
            
            i_field = varargin{2*v};
            
            label = [label, '_', i_field];
        
        elseif strcmp(varargin{2*v - 1}, 'v_field')
            
            v_field = varargin{2*v};
            
            label = [label, '_', v_field];
        
        elseif strcmp(varargin{2*v - 1}, 'f_field')
            
            f_field = varargin{2*v};
            
            label = [label, '_', f_field];
        
        elseif strcmp(varargin{2*v - 1}, 'i_transform')
            
            i_transform = varargin{2*v};
            
            label = [label, '_', i_transform];
            
        end
        
    end
    
end

close('all')

if isempty(results)
    
    results = dsAnalyze(data, @phase_metrics, varargin{:});
    
end

no_studies = length(results);

% no_freqs = size(results(1).v_spike_phases, 3);
% 
% no_periods = size(results(1).v_spike_phases, 2);

% vsp_index = 0;

% t = data(1).time;

% no_input_freqs = length(unique([data(:).pop1_PPfreq]));

varied = data(1).varied;

no_varied = length(varied);

[vary_labels, vary_params] = deal(cell(no_varied, 1));

vary_vectors = nan(length(data), no_varied);

for variable = 1:no_varied
    
    vary_labels{variable} = varied{variable};
    
    vary_vectors(:, variable) = [data.(varied{variable})];
    
    vary_params{variable} = unique(vary_vectors(:, variable));
    
    vary_lengths(variable) = length(vary_params{variable});
    
end

effective_vary_indices = dsCheckCovary(vary_lengths, vary_vectors);

if prod(vary_lengths(effective_vary_indices)) == length(data)
    
    vary_labels = vary_labels(effective_vary_indices);
    vary_params = vary_params(effective_vary_indices);
    vary_lengths = vary_lengths(effective_vary_indices);
    
else
    
    warning('unable to determine which parameters are covaried. Data will be plotted as a lattice.')
    
end

[vary_lengths, vary_permute] = sort(vary_lengths, 'descend');

vary_labels = vary_labels(vary_permute);

vary_params = vary_params(vary_permute);

vary_labels(vary_lengths <= 1) = ''; 

vary_params(vary_lengths <= 1) = [];

vary_lengths(vary_lengths <= 1) = [];

if length(vary_lengths) > 1

    if vary_lengths(1) <= 10 && vary_lengths(2) <= 10
        
        no_cols = vary_lengths(1); no_rows = vary_lengths(2);
        
    else
        
        [no_rows, no_cols] = subplot_size(vary_lengths(1));
        
        vary_labels(3:(end + 1)) = vary_labels(2:end);
        
        vary_labels(1:2) = vary_labels(1);
        
        vary_params(3:(end + 1)) = vary_params(2:end);
        
        vary_params(1:2) = vary_params(1);
        
        vary_lengths(3:(end + 1)) = vary_lengths(2:end);
        
        vary_lengths(1:2) = vary_lengths(1);
        
    end
    
    no_varied = length(vary_lengths) - 2;
    
    no_figures = prod(vary_lengths(3:end));
    
elseif length(vary_lengths) == 1

    if vary_lengths(1) <= 10
        
        no_cols = vary_lengths(1); no_rows = 1;
        
    else
        
        [no_rows, no_cols] = subplot_size(vary_lengths(1));
        
    end
    
    vary_labels(1:2) = vary_labels(1);
    
    vary_params(1:2) = vary_params(1);
    
    vary_lengths(1:2) = vary_lengths(1);
    
    no_varied = 0;
    
    no_figures = 1;
    
else
    
    no_cols = 1; no_rows = 1;
    
    no_varied = -1;
    
    no_figures = 1;
    
end

[peak_freqs, v_mean_spike_mrvs, no_spikes, mean_spikes_per_cycle] = deal(nan(no_rows, no_cols, no_figures));

if no_figures > 1
    
    vary_lengths_cp = cumprod(vary_lengths(3:end));
    
    figure_params = nan(no_figures, no_varied);
    
    for f = 1:no_figures
        
        figure_params(f, 1) = vary_params{3}(mod(f - 1, vary_lengths(3)) + 1);
        
        for v = 2:no_varied
            
            figure_params(f, v) = vary_params{v + 2}(ceil(f/vary_lengths_cp(v - 1)));
            
        end
        
    end
    
else
    
    no_figures = 1;
    
end

% no_other_conditions = no_studies/no_input_freqs;
% 
% if no_other_conditions == 1
% 
%     [r, c] = subplot_size(no_studies);
%     
% else
%    
%     r = no_input_freqs;
%     
%     c = no_other_conditions;
%     
% end

figure_labels = cell(no_figures, 1);

nonempty_plots = zeros(no_rows, no_cols, no_figures);

for f = 1:no_figures
    
    figure(f)
    
    figure_index = ones(1, length(data));
    
    figure_labels{f} = 'Spike Locking to Input';
    
    for v = 1:no_varied
        
        figure_index = figure_index & ([data.(vary_labels{v + 2})] == figure_params(f, v));
        
        if v == 1
            
            figure_labels{f} = [vary_labels{v + 2}, ' = ', num2str(figure_params(f, v), '%.3g')];
            
        else
            
            figure_labels{f} = [figure_labels{f}, '; ', vary_labels{v + 2}, ' = ', num2str(figure_params(f, v), '%.3g')];
            
        end
        
    end
    
    for r = 1:no_rows
        
        for c = 1:no_cols
                
            s = (r - 1)*no_cols + c;
            
            study_index = figure_index;
            
            study_label = '';
            
            if strcmp(vary_labels{1}, vary_labels{2})
                
                if s <= vary_lengths(1)
                    
                    study_index = figure_index & ([data.(vary_labels{1})] == vary_params{1}(s));
                    
                    study_label = [vary_labels{1}, ' = ', num2str(vary_params{1}(s), '%.3g')];
                    
                else
                    
                    study_index = []; % zeros(size(figure_index));
                    
                    study_label = '';
                    
                end
                
            else
                
                row_index = figure_index & ([data.(vary_labels{2})] == vary_params{2}(r));
                
                study_index = row_index & ([data.(vary_labels{1})] == vary_params{1}(c));
                
                study_label = [vary_labels{1}, ' = ', num2str(vary_params{1}(c), '%.3g'),...
                    ', ', vary_labels{2}, ' = ', num2str(vary_params{2}(r), '%.3g')];
                
            end
            
            if ~isempty(study_index)
                
                if sum(study_index == 1)
                    
                    nonempty_plots(r, c, f) = 1;
                    
                    peak_freqs(r, c, f) = results(study_index).peak_freq;
                    
                    % no_spikes = size(results(study_index).v_spike_phases, 1);
                    
                    % v_spike_phases(vsp_index + (1:no_spikes), :, :) = results(s).v_spike_phases;
                    
                    mean_spike_mrvs = nanmean(exp(sqrt(-1)*results(study_index).v_spike_phases));
                    
                    no_spikes(r, c, f) = size(results(study_index).v_spike_phases, 1);
                    
                    mean_spikes_per_cycle(r, c, f) = nanmean(results(study_index).spikes_per_cycle{1});
                    
                    v_mean_spike_mrvs(r, c, f) = mean_spike_mrvs(1); % circ_r(results(s).v_spike_phases); %
                    
                    % f_index = mod(s - 1, no_input_freqs) + 1;
                    %
                    % o_index = ceil(s/no_input_freqs);
                    
                    % subplot_index = (r - 1)*no_cols + c; % no_other_conditions*(f_index - 1) + o_index;
                    
                    ax(r, c, f) = subplot(no_rows, no_cols, s); % no_input_freqs, no_other_conditions, (f_index - 1)*no_other_conditions + o_index)
                    
                    rose(gca, results(study_index).v_spike_phases(:, 1, 1)) % , 60)
                    
                    hold on
                    
                    title(study_label, 'interpreter', 'none')
                    
                    % if ~strcmp(vary_labels{1}, vary_labels{2})
                    %
                    %     ylabel([num2str(data(study_index).(vary_labels{2}), '%.3g'), ' ', vary_labels{2}])
                    %
                    % end
                    
                    % v_mean_spike_phases(s, :, :) = circ_mean(results(s).v_spike_phases);
                    
                    % vsp_index = vsp_index + no_spikes;
                    
                end
                
            end
            
        end
    
    end
    
end

save([name, label, '_PLV_data.mat'], 'results', 'peak_freqs', 'v_mean_spike_mrvs', 'no_spikes', 'mean_spikes_per_cycle')

% linkaxes(reshape(ax(:, :, f), no_rows*no_cols, 1))

for f = 1:no_figures
    
    figure(f)
    
    for r = 1:no_rows
        
        for c = 1:no_cols
            
            s = (r - 1)*no_cols + c;
            
            if nonempty_plots(r, c, f)
                
                subplot(no_rows, no_cols, s)
                
                multiplier = max(max(xlim), max(ylim));
                
                compass(multiplier*real(v_mean_spike_mrvs(r, c, f)), multiplier*imag(v_mean_spike_mrvs(r, c, f)), 'k')
                
            end
            
        end
        
    end
    
    mtit(gcf, figure_labels{f}, 'FontSize', 16)

    if no_figures > 1
    
        save_as_pdf(gcf, [name, label, '_rose_', num2str(f)])
    
    else
        
        save_as_pdf(gcf, [name, label, '_rose'])
        
    end
    
end

% if strcmp(vary_labels{1}, vary_labels{2})
%     
%     v_mean_spike_mrvs = reshape(v_mean_spike_mrvs, no_rows*no_cols, no_figures);
%     
% end

if no_varied >= 0
    
    if strcmp(vary_labels{1}, vary_labels{2})
        
        mrv_for_plot = reshape(permute(v_mean_spike_mrvs, [2 1 3:length(size(v_mean_spike_mrvs))]), no_rows*no_cols, no_figures);
        
        mrv_for_plot = mrv_for_plot(1:vary_lengths(1), :);
        
        nspikes_for_plot = reshape(permute(no_spikes, [2 1 3:length(size(no_spikes))]), no_rows*no_cols, no_figures);
        
        nspikes_for_plot = nspikes_for_plot(1:vary_lengths(1), :);
        
        spc_for_plot = reshape(permute(mean_spikes_per_cycle, [2 1 3:length(size(mean_spikes_per_cycle))]), no_rows*no_cols, no_figures);
        
        spc_for_plot = spc_for_plot(1:vary_lengths(1), :);
        
    else
        
        mrv_for_plot = v_mean_spike_mrvs;
        
        nspikes_for_plot = no_spikes;
        
        spc_for_plot = mean_spikes_per_cycle;
        
    end
    
    no_figures = size(mrv_for_plot, 3);
    
    for f = 1:no_figures
        
        figure
        
        subplot(4, 1, 1)
        
        plot(vary_params{1}, abs(mrv_for_plot(:, :, f)))
        
        axis tight
        
        box off
        
        ylim([0 1])
        
        title(['Spike PLV to Input by ', vary_labels{1}], 'FontSize', 16, 'interpreter', 'none')
        
        xlabel(vary_labels{1}, 'FontSize', 14, 'interpreter', 'none')
        
        ylabel('Spike PLV', 'FontSize', 14)
        
        legend(figure_labels)
        
        subplot(4, 1, 2)
        
        adjusted_plv = ((abs(mrv_for_plot(:, :, f)).^2).*nspikes_for_plot(:, :, f) - 1)./(nspikes_for_plot(:, :, f) - 1);
        
        plot(vary_params{1}, adjusted_plv') % (unique([data(:).(vary_labels{1})])', adjusted_plv')
        
        axis tight
        
        box off
        
        ylim([0 1])
        
        title(['Adjusted Spike PLV to Input by ', vary_labels{1}], 'FontSize', 16, 'interpreter', 'none')
        
        xlabel(vary_labels{1}, 'FontSize', 14, 'interpreter', 'none')
        
        ylabel('Spike PLV', 'FontSize', 14)
        
        subplot(4, 1, 3)
        
        plot(vary_params{1}, nspikes_for_plot(:, :, f))
        
        axis tight
        
        box off
        
        title(['Number of Spikes by ', vary_labels{1}], 'FontSize', 16, 'interpreter', 'none')
        
        xlabel(vary_labels{1}, 'FontSize', 14, 'interpreter', 'none')
        
        ylabel('Number of Spikes', 'FontSize', 14)
        
        subplot(4, 1, 4)
        
        plot(vary_params{1}, zeros(size(spc_for_plot)), 'k:')
        
        hold on, plot(vary_params{1}, spc_for_plot(:, :, f) - 1)
        
        axis tight
        
        box off
        
        set(gca, 'YScale', 'log')
        
        title(['Mean Number of Spikes/Cycle - 1 by ', vary_labels{1}], 'FontSize', 16, 'interpreter', 'none')
        
        xlabel(vary_labels{1}, 'FontSize', 14, 'interpreter', 'none')
        
        ylabel('Number of Spikes', 'FontSize', 14)
        
        if no_figures > 1
            
            save_as_pdf(gcf, [name, label, '_MRV_', num2str(f)])
            
        else
            
            save_as_pdf(gcf, [name, label, '_MRV'])
            
        end
        
    end
    
end


