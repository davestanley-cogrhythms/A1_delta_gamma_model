function FI_plot(name, data, results)

if nargin < 3, results = []; end

if nargin < 2, data = []; end

if isempty(results) && isempty(data)
    
    try
        
        results = dsImportResults(name);
        
        data = results;
        
    catch error
        
    end
    
    if isempty(results)
        
        data = dsImport(name);
        
        results = dsAnalyze(data, @spike_metrics);

        save([name, '_spike_metrics.mat'], 'results', 'name')
        
    end
    
elseif isempty(data) && ~isempty(results)
    
    data = results;
    
elseif isempty(results) && ~isempty(data)
    
    results = dsAnalyze(data, @spike_metrics);
    
    save([name, '_spike_metrics.mat'], 'results', 'name')
    
end

if isfield(data(1), 'time')

    time = data(1).time;
    
    tspan = time(end);
    
else
    
    sim_struct = load([name, '_sim_spec.mat'], 'sim_struct');
    
    sim_struct = sim_struct.sim_struct;
    
    tspan = sim_struct.tspan;
    
    tspan = tspan(end);
    
end

% results = results(~cellfun(@isempty, results));

F = [results.no_spikes]/(tspan/1000 - 1);
I = [data.deepRS_I_app];

Freqs = cell(length(results), 1);

for i = 1:length(results)
   
    Freqs{i} = results(i).Freqs;
    
end

bands = [eps 1; 1 4; 4 8; 8 15; 15 30; 30 60; 60 90; 90 120];

band_names = {'slow', 'delta', 'theta', 'alpha', 'beta', 'lg', 'mg', 'hg'};

no_bands = size(bands, 1);

band_pairs = fliplr(nchoosek(1:no_bands, 2));

no_band_pairs = size(band_pairs, 1);

band_colors = distinguishable_colors(no_bands + no_band_pairs + 1);

figure

handles(1) = plot(-I, F, 'LineWidth', 1, 'Color', .5*[1 1 1]); % , 'LineStyle', '--');

mylegend = {'FI curve'};

hold on

box off

set(gca, 'FontSize', 16)

title('F-I Curve', 'FontSize', 16)

xlabel('Input Current (I)', 'FontSize', 16)

ylabel('Output Freq. (Mean, Hz)', 'FontSize', 16) 

index = 2;

for b = 1:no_bands
    
    band_proportion(:, b) = cellfun(@(x) sum(x > bands(b, 1) & x <= bands(b, 2))/length(x), Freqs);
   
    band_index = band_proportion(:, b) >= .9;
    
    if sum(band_index) > 0
        
        F_band = nan(size(F));
        
        F_band(band_index) = F(band_index);
        
        handles(index) = plot(-I, F_band, 'LineWidth', 2, 'Color', band_colors(b, :));
        
        mylegend{index} = sprintf('%s (%g-%g Hz)', band_names{b}, bands(b, :));
        
        index = index + 1;
        
    end
    
end

for p = 1:no_band_pairs
   
    pair_ratio = band_proportion(:, band_pairs(p, 1))./band_proportion(:, band_pairs(p, 2));
    
    ratio_int_distance = min(mod(pair_ratio, 1), abs(1 - mod(pair_ratio, 1)));
    
    nesting_index = ratio_int_distance < .1 & abs(pair_ratio) > .1;
    
    if sum(nesting_index) > 0
        
        F_band = nan(size(F));
        
        F_band(nesting_index) = F(nesting_index);
        
        handles(index) = plot(-I, F_band, 'LineWidth', 2.5, 'Color', band_colors(no_bands + p, :));
        
        mylegend{index} = sprintf('%s in %s', band_names{band_pairs(p, :)});
        
        index = index + 1;
        
    end
        
end

legend(handles, mylegend, 'Location', 'Northwest')

% for p = 1:no_band_pairs
%    
%     pair_ratio = band_proportion(:, band_pairs(p, 1))./band_proportion(:, band_pairs(p, 2));
%     
%     nesting_index = abs(mod(pair_ratio, 1)) < .1 & abs(pair_ratio) > .1;
%     
%     if sum(nesting_index) > 0
%     
%     nesting_ratio = zeros(size(pair_ratio));
%     
%     nesting_ratio(nesting_index) = round(pair_ratio(nesting_index));
%     
%     nesting_ratios = unique(nesting_ratio(nesting_index));
%     
%     for r = 1:length(nesting_ratios)
%         
%         nesting_ratio_index = nesting_ratio == nesting_ratios(r);
%     
%         F_band = nan(size(F));
%     
%         F_band(nesting_ratio_index) = F(nesting_ratio_index);
%     
%         plot(-I, F_band, 'LineWidth', 1 + nesting_ratios(r), 'Color', band_colors(no_bands + p + 1, :))
%     
%     end
%         
% end

save_as_pdf(gcf, [name, '_FI'])

ylim([0 10])

save_as_pdf(gcf, [name, '_FI_below10Hz'])

end
