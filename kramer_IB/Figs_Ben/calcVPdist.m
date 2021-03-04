function vpdist = calcVPdist(name, varargin) % , gSpeech, Speechfreq)

boundary_defaults

sum_window = options_struct.sum_window;
threshold = options_struct.threshold;
synchrony_window = options_struct.synchrony_window;
vp_norm = options_struct.vp_norm;

results_struct = load([name, '_boundary_analysis.mat']);
results = results_struct.results;
    
SI = fill_struct_empty_field(results, 'deepRS_SentenceIndex', nan);

gS = fill_struct_empty_field(results, 'deepRS_gSpeech', nan);

Shigh = fill_struct_empty_field(results, 'deepRS_SpeechHighFreq', nan);
Slow = fill_struct_empty_field(results, 'deepRS_SpeechLowFreq', nan);
Sfreq = (Shigh + Slow)/2;

%% Computing Victor-Purpura distance.

vpdist = nan(size(results));
[mod_boundaries, syl_boundaries, mid_syl_boundaries] = deal(cell(size(results)));

parfor i = 1:length(results)
    
    [vpdist(i), mod_boundaries{i}, syl_boundaries{i}, mid_syl_boundaries{i}] =...
        calcVPdist_guts(results(i), threshold, sum_window, synchrony_window, vp_norm);
    
end

%% Computing histograms & means.

SIs = unique(SI);
SIs(isnan(SIs)) = [];

gSs = unique(gS);
gSs(isnan(gSs)) = [];

Sfreqs = unique(Sfreq);
Sfreqs(isnan(Sfreqs)) = [];

no_bins = 25;

bins = linspace(nanmin(vpdist), nanmax(vpdist), no_bins);

rows = length(Sfreqs); columns = length(gSs);

for i = 1:rows
    
    this_Sfreq = Sfreqs(i);
    
    for j = 1:columns
        
        this_gS = gSs(j);
        
        this_indicator = this_Sfreq == Sfreq & this_gS == gS;
        
        counts(:, j, i) = histcounts(vpdist(this_indicator), bins);
        
        meanVPdist(j, i) = nanmean(vpdist(this_indicator));
        
        meanlogVPdist(j, i) = nanmean(log(vpdist(this_indicator)));
        
        medianVPdist(j, i) = nanmedian(vpdist(this_indicator));
        
        medianlogVPdist(j, i) = nanmedian(log(vpdist(this_indicator)));
        
    end
    
end

save([name, label, '_vpdist.mat'], 'mod_boundaries', 'mid_syl_boundaries', 'syl_boundaries',...
    'vpdist', 'counts', 'bins', 'meanVPdist', 'meanlogVPdist', 'medianVPdist', 'medianlogVPdist',...
    'gS', 'gSs', 'Sfreq',  'Sfreqs', 'SI', 'SIs')

end


function [vpdist, mod_boundaries, syl_boundaries, mid_syl_boundaries] = calcVPdist_guts(results, threshold, sum_window, synchrony_window, vp_norm)

vpdist = nan; mod_boundaries = []; syl_boundaries = []; mid_syl_boundaries = [];

[~, mod_boundaries, ~] = spikes_to_boundaries(results.spikes, results.time, 'sum_window', sum_window, 'threshold', threshold);

if any(~isint(results.syl_boundaries))
    
    syl_boundaries = results.syl_boundaries;
    
else
    
    syl_boundaries = results.time(results.syl_boundaries);
    
end

if ~(isempty(syl_boundaries) || isempty(mod_boundaries))
    
    sentence_start = min(syl_boundaries) - 100;
    sentence_end = max(syl_boundaries) + 100;
    
    mod_boundaries = mod_boundaries(mod_boundaries >= sentence_start & mod_boundaries <= sentence_end);
    
    mid_syl_boundaries = conv(syl_boundaries, [1 1]*.5, 'valid');
    
    vpdist = VP_distance(synchrony_window, mid_syl_boundaries, mod_boundaries, vp_norm);
    
end

end



% %% Loading fields.
% 
% vpdist_fields = fieldnames(vpdist_struct);
% 
% numeric_fields = zeros(size(vpdist_fields));
% 
% for f = 1:length(vpdist_fields)
%     
%     numeric_fields(f) = isnumeric(vpdist_struct(1).(vpdist_fields{f}));
%     
% end
% 
% for f = 1:length(vpdist_fields)
%     
%     if numeric_fields(f)
%         
%         command = sprintf('%s = fill_struct_empty_field(vpdist_struct, ''%s'', nan);', vpdist_fields{f}, vpdist_fields{f});
%         
%         eval((command));
%         
%     end
%     
% end