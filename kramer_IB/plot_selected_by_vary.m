function [data, selected, save_name] = plot_selected_by_vary(name, data, limits)
% limits: a structure with fieldnames specifying parameter names and
%   fields specifiying max. and min. values for simulations to plot.

if isempty(data), data = dsImport(name); end

param_names = fieldnames(limits);

sim_params = nan(length(data), length(param_names));
param_values = cell(size(param_names));
save_name = name;
selected = true(size(data'));

for p = 1:length(param_names)
    
    sim_params(:, p) = [data.(param_names{p})];
    
    param_values{p} = unique(sim_params(:, p));
    
    save_name = [save_name, make_label(param_names{p}, limits.(param_names{p}))];
    
    param_selected = sim_params(:, p) >= min(limits.(param_names{p})) &...
        sim_params(:, p) <= max(limits.(param_names{p}));

%     if sum(param_selected) > 21
% 
%         skip_num = floor(sum(param_selected)/10);
% 
%         skip_index = 1:skip_num:length(data);
%         skip_indicator = false(length(data), 1);
%         skip_indicator(skip_index) = true;
% 
%         param_selected = param_selected & skip_indicator;
% 
%     end
    
    selected = selected & param_selected;
    
end

dsPlot(data(selected), 'suppress_textstring', 1)

save_as_pdf(gcf, save_name)