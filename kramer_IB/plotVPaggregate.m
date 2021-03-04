function plotVPaggregate(sim_name, varargin) % synchrony_window, vpnorm, 

%% Defaults & arguments.

suffix = '_vpdist';

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

sim_struct = load(sim_name);

names = sim_struct.names;

%% Checking analysis files exist.

for n = 1:length(names)
    
    if exist([names{n}, label, suffix, '.mat'], 'file') ~= 2
        
        plotVPdist(names{n}, varargin{:})
        
    end
    
end

%% Loading vpdist measure.

load([names{1}, label, suffix, '_stats.mat'])

all_vpdist = nan([size(meanVPdist), length(names), 2]);

for n = 1:length(names)
    
    vpdist_mat = load([names{n}, label, suffix, '.mat']);
    
    this_vpdist = vpdist_mat.meanVPdist;
    
    this_vpdist = this_vpdist - ones(size(this_vpdist))*diag(this_vpdist(1, :)); 
    
    all_vpdist(:, :, n, 1) = this_vpdist;
    
    this_vpdist = vpdist_mat.medianVPdist;
    
    this_vpdist = this_vpdist - ones(size(this_vpdist))*diag(this_vpdist(1, :)); 
    
    all_vpdist(:, :, n, 2) = this_vpdist;
    
end

%% Plotting vpdist.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

rows = 1; columns = length(names); % columns = 1;

measure_names = {'_mean', '_median'};

for measure = 1:2
    
    figure
    
    ha = tight_subplot(rows, columns, [.025, .025], .075, .075);
    
    gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));
    
    gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);
    
    vpdist_range = [all_dimensions(@min, -all_vpdist(2:end, :, :, measure)), all_dimensions(@max, -all_vpdist(2:end, :, :, measure))];
    
    for m = 1:length(names)
        
        axes(ha(m))
        
        imagesc(Sfreqs, gSs, -all_vpdist(2:end, :, m, measure)) % 1./all_vpdist(:, :, m))
        
        axis xy
        
        caxis(sort(max(0, vpdist_range))) % sort(1./vpdist_range))
        
        x_lims = xlim; x_ticks = x_lims(1):diff(x_lims)/length(Sfreqs):x_lims(2);
        
        set(gca, 'XTick', x_ticks, 'XTickLabel', round(Sfreqs/1000, 2))
        
        xtickangle(-45)
        
        title(model_names{m})
        
        xlabel('Input Freq. (kHz)')
        
        if m == 1 % length(names)
            
            set(gca, 'Ytick', gSs(1:2:end), 'YTickLabel', gSs(1:2:end))
            
            ylabel('Input Gain')
            
        elseif m == length(names)
            
            nochange_colorbar(gca)
            
            set(gca, 'YTick', [])
            
        else
            
            set(gca, 'YTick', [])
            
        end
        
    end
    
    saveas(gcf, [sim_name, label, suffix, measure_names{measure}, '.fig'])
    
    save_as_pdf(gcf, [sim_name, label, suffix, measure_names{measure}])
    
end

end


    
%     if exist([names{n}, '_boundary_analysis.mat'], 'file') ~= 2
%         
%         % disp(sprintf('Results file not available for %s', name))
%         
%         results = dsImportResults(names{n}, @boundary_analysis);
%         
%         save([names{n}, '_boundary_analysis.mat'], 'results')
%         
%         result_fields = fieldnames(results(1).options);
%         
%         old_varargin = varargin;
%         
%         for f = 1:length(result_fields)
%             
%             varargin{2*f - 1} = result_fields{f};
%             
%             varargin{2*f} = results(1).options.(result_fields{f});
%             
%         end
%         
%         boundary_defaults
%         
%         save([names{n}, label, '_boundary_analysis.mat'], 'results')
%         
%         varargin = old_varargin;
%         
%         boundary_defaults
%         
%     end