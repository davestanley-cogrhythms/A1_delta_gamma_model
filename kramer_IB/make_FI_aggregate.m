function make_FI_aggregate

working_dir = '/projectnb/crc-nak/brpp/model-dnsim-kramer_IB/';

files = {'18-12-20/kramer_IB_17_43_1.251';...
    '18-12-17/kramer_IB_21_52_46.15';...
    '18-12-13/kramer_IB_15_5_59.38';...
    '19-01-07/kramer_IB_14_0_18.91';...
    '19-01-04/kramer_IB_13_19_53.94';...
    };

line_colors = [0 .78 0; .78 0 .78; 1 .65 0]; % distinguishable_colors(length(files) + 3);

files_size = size(files);

figures(1) = figure;
figures(2) = figure;

xlimits = {repmat([0 20], prod(files_size), 1), [6 8; 6 8; 6 11; 6 10.5; 2 6]};

suffixes = {'', '_inset'};

for f = 1:prod(files_size)
    
    if exist(['Figs_Ben/', files{f}, '_spike_metrics.mat'], 'file') == 2
        
        load(['Figs_Ben/', files{f}, '_spike_metrics.mat'])
        
    else
        
        try
            
            results = dsImportResults(['Figs_Ben/', files{f}]); % (10:end));
            
        catch error
            
        end
        
        if isempty(results)
            
            % cd (['Figs_Ben/', files{f}(1:8)])
            
            data = dsImport(['Figs_Ben/', files{f}]); % (10:end));
            
            results = dsAnalyze(data, @spike_metrics);
            
            save([name, '_spike_metrics.mat'], 'results', 'name')
            
            % cd (working_dir)
            
        end
        
    end
    
    load(['Figs_Ben/', files{f}, '_sim_spec.mat'])
    
    results(1).t_end = sim_struct.tspan(end);
    
    %     t_end_cell = num2cell(repmat(sim_struct.tspan(end), size(results)));
    %
    %     [results.t_end] = t_end_cell{:};
    
    for fig = 1:2
        
        figure(figures(fig))
        
        subplot(prod(files_size), 1, f)
        
        plot_FI(results, xlimits{fig}(f, :)) % , line_colors(f + 3, :))
        
        if f == 1
            
            title('F-I Curve', 'FontSize', 16)
            
        elseif f == prod(files_size)
            
            xlabel('Input Current (I)', 'FontSize', 16)
            
        end
        
        ylabel({'Output Freq.'; '(Mean, Hz)'}, 'FontSize', 16)
        
    end
    
end

for fig = 1:2
    
    set(figures(fig), 'Units', 'inches', 'Position', 1 + [0 0 2 6], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 2 6])
    
    saveas(figures(fig), ['FI_aggregate', suffixes{fig}, '.fig'])
    
end

end

function plot_FI(results, xlimits)

F = [results.no_spikes]/(results(1).t_end/1000 - 1);
I = 0:-.1:-20; % [results.deepRS_I_app];

Freqs = cell(length(results), 1);

for i = 1:length(results)
    
    Freqs{i} = results(i).Freqs;
    
end

bands =  [1 4; 4 8]; %[eps 1; 8 15; 15 30; 30 60; 60 90; 90 120];

band_names = {'delta', 'theta'}; % {'slow', 'alpha', 'beta', 'lg', 'mg', 'hg'};

no_bands = size(bands, 1);

band_pairs = fliplr(nchoosek(1:no_bands, 2));

no_band_pairs = size(band_pairs, 1);

band_colors = [0 .78 0; .78 0 .78; 1 .65 0]; % distinguishable_colors(no_bands + no_band_pairs + 1);

% figure

handles(1) = plot(-I, F, 'LineWidth', 2, 'Color', [0 0 0]); % .5*[1 1 1]); % , 'LineStyle', '--');

mylegend = {'FI curve'};

hold on

axis tight

box off

set(gca, 'FontSize', 12)

index = 2;

for b = 1:no_bands
    
    band_proportion(:, b) = cellfun(@(x) sum(x > bands(b, 1) & x <= bands(b, 2))/length(x), Freqs);
   
    band_index = band_proportion(:, b) >= .75;
    
    if sum(band_index) > 0
        
        F_band = nan(size(F));
        
        F_band(band_index) = F(band_index);
        
        handles(index) = plot(-I, F_band, 'LineWidth', 2.5, 'Color', band_colors(b, :));
        
        set(gca, 'YAxisLocation', 'right')
        
        mylegend{index} = sprintf('%s (%g-%g Hz)', band_names{b}, bands(b, :));
        
        index = index + 1;
        
    end
    
end

for p = 1:no_band_pairs
   
    pair_ratio = band_proportion(:, band_pairs(p, 1))./band_proportion(:, band_pairs(p, 2));
    
    ratio_int_distance = min(mod(pair_ratio, 1), abs(1 - mod(pair_ratio, 1)));
    
    tol = .25; %.1
    
    nesting_index = ratio_int_distance < tol & abs(pair_ratio) > tol;
    
    if sum(nesting_index) > 0
        
        F_band = nan(size(F));
        
        F_band(nesting_index) = F(nesting_index);
        
        handles(index) = plot(-I, F_band, 'LineWidth', 2.5, 'Color', band_colors(no_bands + p, :));
        
        mylegend{index} = sprintf('%s in %s', band_names{band_pairs(p, :)});
        
        index = index + 1;
        
    end
        
end

xlim(xlimits)

% legend(handles, mylegend, 'Location', 'Northwest')

end

% function plot_FI(results, line_color)
% 
% F = [results.no_spikes]/(results(1).t_end/1000 - 1);
% I = [results.deepRS_I_app];
% 
% if length(unique(I)) == 1, I = 0:.1:20; end
% 
% Freqs = cell(length(results), 1);
% 
% for i = 1:length(results)
%    
%     Freqs{i} = results(i).Freqs;
%     
% end
% 
% line_styles = {':', '--', '-.'};
% 
% bands = [1 4; 4 8]; % [eps 1; 1 4; 4 8; 8 15; 15 30; 30 60; 60 90; 90 120];
% 
% band_names = {'delta', 'theta'}; % {'slow', 'delta', 'theta', 'alpha', 'beta', 'lg', 'mg', 'hg'};
% 
% no_bands = size(bands, 1);
% 
% band_pairs = fliplr(nchoosek(1:no_bands, 2));
% 
% no_band_pairs = size(band_pairs, 1);
% 
% % band_colors = distinguishable_colors(no_bands + no_band_pairs + 1);
% 
% handles(1) = plot(abs(I), F, 'LineWidth', 2, 'Color', line_color); % , 'LineStyle', line_style); % , 'LineStyle', '--');
% 
% mylegend = {'FI curve'};
% 
% hold on
% 
% box off
% 
% set(gca, 'FontSize', 16)
% 
% title('F-I Curve', 'FontSize', 16)
% 
% xlabel('Input Current (I)', 'FontSize', 16)
% 
% ylabel('Output Freq. (Mean, Hz)', 'FontSize', 16) 
% 
% index = 2;
% 
% for b = 1:no_bands
%     
%     band_proportion(:, b) = cellfun(@(x) sum(x > bands(b, 1) & x <= bands(b, 2))/length(x), Freqs);
%    
%     band_index = band_proportion(:, b) >= .9;
%     
%     if sum(band_index) > 0
%         
%         F_band = nan(size(F));
%         
%         F_band(band_index) = F(band_index);
%         
%         plot(abs(I), F_band, 'LineWidth', 2, 'Color', 'w')
%         
%         handles(index) = plot(abs(I), F_band, 'LineWidth', 2, 'Color', line_color, 'LineStyle', line_styles{b});
%         
%         mylegend{index} = sprintf('%s (%g-%g Hz)', band_names{b}, bands(b, :));
%         
%         index = index + 1;
%         
%     end
%     
% end
% 
% for p = 1:no_band_pairs
%    
%     pair_ratio = band_proportion(:, band_pairs(p, 1))./band_proportion(:, band_pairs(p, 2));
%     
%     ratio_int_distance = min(mod(pair_ratio, 1), abs(1 - mod(pair_ratio, 1)));
%     
%     nesting_index = ratio_int_distance < .1 & abs(pair_ratio) > .1;
%     
%     if sum(nesting_index) > 0
%         
%         F_band = nan(size(F));
%         
%         F_band(nesting_index) = F(nesting_index);
%         
%         plot(-I, F_band, 'LineWidth', 2.5, 'Color', 'w')
%         
%         handles(index) = plot(-I, F_band, 'LineWidth', 2.5, 'Color', line_color, 'LineStyle', line_styles{no_bands + p});
%         
%         mylegend{index} = sprintf('%s in %s', band_names{band_pairs(p, :)});
%         
%         index = index + 1;
%         
%     end
%         
% end
% 
% legend(handles, mylegend, 'Location', 'Northwest')
%     
% end