function plots_by_variable(variable, plot_function, data, name, varargin)

if nargin < 2, plot_function = []; end

if isempty(plot_function), plot_function = @dsPlot; end

variable_vec = [data.(variable)];
variable_values = unique(variable_vec);

for i = 1:length(variable_values)
    
    figure_name = sprintf('%s_%s_%0.2g', name, variable, variable_values(i));
    
    feval(plot_function, data(variable_vec == variable_values(i)), figure_name, varargin{:})
    
    saveas(gcf, [figure_name, '.fig'])

    save_as_pdf(gcf, figure_name)
    
end