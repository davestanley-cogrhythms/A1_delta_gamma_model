function plotDprimeAggregate(sim_name, varargin)

%% Defaults & arguments.

boundary_defaults %% See boundary_defaults.m, which is a script, not a function.

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

sim_struct = load(sim_name);

names = sim_struct.names;

%% Checking analysis files exist.

for n = 1:length(names)
    
%     if ~exist([names{n}, '_boundary_stats.mat'], 'file')
%         
%         % disp(sprintf('Results file not available for %s', name))
%         
%         data = dsImport(name);
%         
%         plotBoundaryAlternation(names{n}, data)
%         
%     end
    
    if ~exist([names{n}, label, '_boundary_dprime.mat'])
        
        if exist([names{n}, label, '_boundary_analysis.mat'], 'file')
            
            plotDprime(names{n}, [], [], varargin{:})
            
        else
            
            posthoc_boundary_analysis_wrapper(names{n}, varargin{:})
            
            plotDprime(names{n}, [], [], varargin{:})
            
        end
        
    end
    
end

%% Loading dprime measure.

load([names{1}, label, '_dprime.mat'])

all_dprime = nan([size(dPrime), length(names)]);

for n = 1:length(names)
    
    dprime_mat = load([names{n}, label, '_dprime.mat']);
    
    all_dprime(:, :, n) = dprime_mat.dPrime;
    
end

%% Plotting dprime.

model_names = {'M', 'MI', 'I', 'IS', 'MIS', 'MS'};

rows = 1; columns = length(names); % columns = 1;

figure

ha = tight_subplot(rows, columns, [.025, .025], .075, .075);

gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));

gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);

dprime_range = [all_dimensions(@min, all_dprime), all_dimensions(@max, all_dprime)];
    
for m = 1:length(names)
    
    axes(ha(m))
    
    imagesc(Sfreqs, gSs, all_dprime(:, :, m))
    
    axis xy
    
    caxis(dprime_range)
    
    x_lims = xlim; x_ticks = x_lims(1):diff(x_lims)/length(Sfreqs):x_lims(2);
        
    set(gca, 'XTick', x_ticks, 'XTickLabel', Sfreqs(1:2:end)/1000)
    
    title(model_names{m})
    
    xlabel('Input Freq. (kHz)')
    
    if m == 1 % length(names)
    
        set(gca, 'Ytick', gSs(1:2:end), 'YTickLabel', gSs(1:2:end))
        
        ylabel('Input Gain')
        
    elseif m == length(names)
        
        nochange_colorbar(gca)
        
    else
        
        set(gca, 'YTick', [])
        
    end
    
end

fig_suffix = sprintf('%s_dprime', label);

saveas(gcf, [sim_name, fig_suffix, '.fig'])

save_as_pdf(gcf, [sim_name, fig_suffix])

end