function data = plot_selected(name, data, limits)

if isempty(data), data = dsImport(name); end

I = [data.deepRS_I_app];

selected = abs(I) >= min(abs(limits)) & abs(I) <= max(abs(limits));

if sum(selected) > 21
    
    skip_num = floor(sum(selected)/10);
    
    skip_index = 1:skip_num:length(I);
    skip_indicator = false(1, length(I));
    skip_indicator(skip_index) = true;
    
    selected = selected & skip_indicator;
    
end

dsPlot(data(selected))

save_as_pdf(gcf, [name, make_label('I_app', limits)])