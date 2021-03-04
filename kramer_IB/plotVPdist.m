function plotVPdist(name, varargin) % synchrony_window, vpnorm,

%% Defaults & arguments.

boundary_defaults

suffix = '_vpdist';

%% Loading Victor-Purpura distance.

if exist([name, label, '_vpdist.mat'], 'file') ~= 2
    
    calcVPdist(name, varargin{:})
    
end

vpdist_struct = load([name, label, '_vpdist.mat']);

vpdist_struct = vpdist_struct.vpdist_struct;

vpdist_fields = fieldnames(vpdist_struct);

numeric_fields = zeros(size(vpdist_fields));

for f = 1:length(vpdist_fields)
    
    numeric_fields(f) = isnumeric(vpdist_struct(1).(vpdist_fields{f}));
    
end

for f = 1:length(vpdist_fields)
    
    if numeric_fields(f)
        
        command = sprintf('%s = fill_struct_empty_field(vpdist_struct, ''%s'', nan);', vpdist_fields{f}, vpdist_fields{f});
        
        eval((command));
        
    end
    
end

SIs = unique(SI);
SIs(isnan(SIs)) = [];

gSs = unique(gS);
gSs(isnan(gSs)) = [];

Sfreqs = unique(Sfreq);
Sfreqs(isnan(Sfreqs)) = [];

no_bins = 25;

bins = linspace(nanmin(vpdist), nanmax(vpdist), no_bins);

%% Computing histograms & means.

rows = length(Sfreqs); columns = length(gSs);

boundary_phones = cell(rows, columns);

hists = nan(no_bins, columns, rows);

for i = 1:rows
    
    this_Sfreq = Sfreqs(i);
    
    for j = 1:columns
        
        this_gS = gSs(j);
        
        this_indicator = this_Sfreq == Sfreq & this_gS == gS;
        
        counts(:, j, i) = histcounts(vpdist(this_indicator), bins);
        
        meanVPdist(j, i) = nanmean(vpdist(this_indicator));
        
        medianVPdist(j, i) = nanmedian(vpdist(this_indicator));
        
    end
    
end

save([name, label, suffix, '_stats.mat'], 'vpdist', 'counts', 'bins',...
    'meanVPdist', 'medianVPdist', 'gSs', 'Sfreqs', 'gS', 'Sfreq', 'SI', 'SIs')

% end

%% Plotting vpdist overall.

figure

imagesc(Sfreqs, gSs, meanVPdist)

colorbar

axis xy

xlabel({'Input Channel'; 'Center Freq. (kHz)'})

ylabel('Input Gain')

title('Victor-Purpura Distance (Mean)')

saveas(gcf, sprintf('%s%s%s_mean.fig', name, label, suffix))

save_as_pdf(gcf, sprintf('%s%s%s_mean', name, label, suffix))

figure

imagesc(Sfreqs, gSs, medianVPdist)

colorbar

axis xy

xlabel({'Input Channel'; 'Center Freq. (kHz)'})

ylabel('Input Gain')

title('Victor-Purpura Distance (Median)')

saveas(gcf, sprintf('%s%s%s_median.fig', name, label, suffix))

save_as_pdf(gcf, sprintf('%s%s%s_median', name, label, suffix))

%% Plotting histograms.

figure

rows = length(Sfreqs); columns = length(gSs);

ha = tight_subplot(rows, 1);

colors = cool(length(gSs));

gS_legend = mat2cell(gSs, ones(size(gSs, 1), 1), ones(size(gSs, 2), 1));

gS_legend = cellfun(@(x) sprintf('Input Gain %g', x), gS_legend, 'unif', 0);

for i = 1:rows
    
    this_Sfreq = Sfreqs(i);
    
    axes(ha(i))
    
    set(gca, 'NextPlot', 'add', 'ColorOrder', colors)
    
    bin_centers = conv(bins, .5*[1 1], 'valid');
    
    plot(bin_centers, counts(:, :, i))
    
    box off
    
    if i ~= rows
        
        set(gca, 'XTickLabel', '')
        
    else
        
        set(gca, 'XTick', bin_centers(1:9:end), 'XTickLabel', bin_centers(1:9:end))
        
    end
    
    if i == 1
        
        title('Victor-Purpura Distance by Sentence')
        
        legend(gS_legend)
        
    end
    
    ylabel({'Input Freq.'; sprintf('%.2g kHz', this_Sfreq/1000)}, 'Rotation', 0)
    
end

saveas(gcf, sprintf('%s%s%s_histograms.fig', name, label, suffix))

save_as_pdf(gcf, sprintf('%s%s%s_histograms', name, label, suffix))

end


    
%     %% Getting varied parameters.
%     
%     if isempty(data)
%         
%         if ~any(contains(fieldnames(results), 'deepRS_SentenceIndex'))
%             
%             results0 = load([name, '_boundary_analysis.mat']);
%             
%             results0 = results0.results;
%             
%         else
%             
%             results0 = results;
%             
%         end
%         
%     else
%         
%         results0 = data;
%         
%     end

% sprintf('_syncwin%d_vpnorm%d_vpdist', synchrony_window, vpnorm);

% variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
%     'refractory', 'onset_time', 'spike_field', 'input_field'};
% 
% defaults = {50, 25, 100, 2/3, 50, 1000, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

%% Loading data.

% if exist([name, label, suffix, '.mat'])
%     
%     load([name, label, suffix, '.mat'])
%     
% else
    
%     if isempty(results)
%         
%         if ~isempty(data)
%             
%             results = dsAnalyze(data, @boundary_analysis, 'function_options', varargin, 'save_results_flag', 1, 'result_file', [name, label, '_boundary_analysis.mat']);
%             
%         else
%             
%             label_no_vp_params = split(label, {'_syncwin', '_vpnorm'});
%             label_no_vp_params = label_no_vp_params{1};
%             
%             for l = 1:length(varargin)/2
%                 
%                 if strcmp(varargin{2*l - 1}, 'vp_norm') || strcmp(varargin{2*l - 1}, 'synchrony_window')
%                     
%                     vp_params((2*l - 1):(2*l)) = 1;
%                     
%                 end
%                 
%             end
%             
%             varargin_no_vp_params = varargin;
%             varargin_no_vp_params(vp_params) = [];
%             
%             if exist([name, label, '_boundary_analysis.mat'], 'file') == 2
%                 
%                 results = load([name, label, '_boundary_analysis.mat']);
%                 
%                 results = results.results;
%                 
%             elseif exist([name, label_no_vp_params, '_boundary_analysis.mat'], 'file') == 2
%                 
%                 results = load([name, label_no_vp_params, '_boundary_analysis.mat']);
%                 
%                 results = results.results;
%                 
%             elseif exist([name, '_boundary_analysis.mat'], 'file') == 2
%                 
%                 posthoc_boundary_analysis_wrapper(name, varargin_no_vp_params{:})
%                 
%                 results = load([name, label_no_vp_params, '_boundary_analysis.mat']);
%                 
%                 results = results.results;
%                 
%             else
%                 
%                 results = dsImportResults(name, @boundary_analysis);
%                 
%                 result_fields = fieldnames(results(1).options);
%                 
%                 old_varargin = varargin;
%                 
%                 for f = 1:length(result_fields)
%                     
%                     varargin{2*f - 1} = result_fields{f};
%                     
%                     varargin{2*f} = results(1).options.(result_fields{f});
%                     
%                 end
%                 
%                 boundary_defaults
%                 
%                 save([name, label, '_boundary_analysis.mat'], 'results', '-v7.3')
%                 
%                 varargin = old_varargin; boundary_defaults;
%                 
%                 calcVPdist(name, varargin{:})
%                 
%                 results = load([name, label, '_boundary_analysis.mat']);
%                 
%                 results = results.results;
%                 
%             end
%             
%         end
%         
%     end