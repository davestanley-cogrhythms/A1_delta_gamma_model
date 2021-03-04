function plot_STP_prespike_data(input_struct)

if nargin == 0, input_struct = struct(); end

sims = [4 6 6]; % 6];

act_indices = [2 3; 1 3; 1 5]; %; 5 6];

field_labels = {'I_{m} Activation', 'I_{inh} Activation', 'I_{K_{SS}} Activation', 'I_{Na_P} Activation', '\Delta (I_{m} Activation)', '\Delta^2 (I_{m} Activation)'};

trace_plot = [0 0 1];

regression_plot = [1 0 0];

plot_legend = [1 0 0]; legend_loc = 'SouthEast';

page_dims = [0 0 10 3];

label = '';

input_fields = fields(input_struct);

for f = 1:length(input_fields)
    
    eval([input_fields{f}, ' = input_struct.', input_fields{f}, ';']);
    
end

data = load('all_STP_data.mat');

activation = data.activation;
pre_spike_indicator = data.pre_spike_indicator;
time = data.time;
freqs = data.freqs;
stims = data.stims;

figure
    
for s = 1:length(sims)
    
    subplot(1, length(sims), s)
    
    for i = 1:2
        
        this_act{i} = activation{sims(s), act_indices(s, i)};
        
    end
    
    if size(this_act{1}, 1) ~= size(this_act{2}, 1)
        
        act_length = min(size(this_act{1}, 1), size(this_act{2}, 1));
        
        for i = 1:2, this_act{i} = this_act{i}(1:act_length, :); end
        
    else
        
        act_length = size(this_act{1}, 1);
        
    end
        
    if trace_plot(s)
        
        plot(this_act{1}(time(1:act_length, 1) > 1, stims ~= 0), this_act{2}(time(1:act_length, 1) > 1, stims ~= 0), 'Color', .75*[1 1 1], 'LineWidth', 0.1);
        
        hold on
        
        plot(this_act{1}(time(1:act_length, 1) > 1, stims == 0), this_act{2}(time(1:act_length, 1) > 1, stims == 0), 'Color', .5*[1 1 1], 'LineWidth', 0.25);
        
        hold on
        
    end
    
    for i = 1:2, no_input_act{i} = this_act{i}(:, stims == 0); end
    
    for i = 1:2, input_act{i} = this_act{i}(:, stims ~= 0); end
    
    h(1) = plot(no_input_act{1}(pre_spike_indicator{sims(s), 1}(1:act_length, stims == 0)),...
        no_input_act{2}(pre_spike_indicator{sims(s), 1}(1:act_length, stims == 0)), 'kx', 'MarkerSize', 10);
    
    hold on
    
    h(2) = plot(this_act{1}(pre_spike_indicator{sims(s), 1}(1:act_length, :)),...
        this_act{2}(pre_spike_indicator{sims(s), 1}(1:act_length, :)), 'ko', 'MarkerSize', 2.5);
    
    hold on
    
    h(3) = plot(this_act{1}(pre_spike_indicator{sims(s), 2}(1:act_length, :)),...
        this_act{2}(pre_spike_indicator{sims(s), 2}(1:act_length, :)), 'rp'); % , 'MarkerSize', 10);
    
    axis tight, box off
    
    xlabel(field_labels{act_indices(s, 1)}), ylabel(field_labels{act_indices(s, 2)})
    
    set(gca, 'FontSize', 12)
    
    if regression_plot(s)
    
        all_pre_spike_indicator = pre_spike_indicator{sims(s), 1}(1:act_length, :) | pre_spike_indicator{sims(s), 2}(1:act_length, :);
        
        if sims(s) == 4
            
            fps_indicator = sum(pre_spike_indicator{sims(s), 2}) >= 1;
            
            outliers = this_act{1}(pre_spike_indicator{sims(s), 2}(1:act_length, :)) > .1;
            
            outlier_indicator = false(size(fps_indicator));
            
            outlier_indicator(fps_indicator) = outliers;
            
            new_fig = figure;
            
            outlier_indices = find(outlier_indicator);
            
            ha = tight_subplot(length(outlier_indices), 1);
            
            for i = 1:length(outlier_indices)
                
                axes(ha(i))
                
                [~, h1, h2] = plotyy(time(:, 1), this_act{1}(:, outlier_indices(i)),...
                    time(:, 1), pre_spike_indicator{sims(s), 2}(:, outlier_indices(i)));
                
                set(h1, 'Color', 'k'), set(h2, 'Color', 'r'), box off, axis tight
                
            end
            
            saveas(new_fig, sprintf('outliers_model%d.fig', sims(s)))
            
            close(new_fig)
        
        else
            
            outlier_indicator = false(size(this_act{1}, 2), 1);
            
        end
        
        for i = 1:2, regression_act{i} = this_act{i}(:, ~outlier_indicator); end
        
        [coeff, m, b] = regression(regression_act{1}(all_pre_spike_indicator(:, ~outlier_indicator))',...
            regression_act{2}(all_pre_spike_indicator(:, ~outlier_indicator))');
        
        x_lims = xlim; y_lims = ylim; x_vals = linspace(x_lims(1), x_lims(2), 100);
        
        rline = m*x_vals + b;
        
        h(end + 1) = plot(x_vals, rline, '--', 'LineWidth', 1.5);
        
        xlim(x_lims), ylim(y_lims)
        
        new_ax = axes('Position', get(gca, 'Position'), 'Visible', 'off');
        
        if plot_legend(s)
            
            legend(h, {'No Input Pulse'; 'Input Pulse'; 'First Post-Input Spike'; sprintf('r = %.3g, m = %.3g', coeff, m)}, 'Location', legend_loc)
            
        end
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + page_dims, 'PaperUnits', 'inches', 'PaperPosition', 1 + page_dims)
    
saveas(gcf, sprintf('all_STP_analysis%s.fig', label))

end