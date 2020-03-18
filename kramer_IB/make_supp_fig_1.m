function make_supp_fig_1(stim_limits, freq)

if nargin < 1, stim_limits = []; end

if nargin < 2, freq = []; end

if isempty(stim_limits), stim_limits = [-1 -3]; end

if isempty(freq), freq = 4; end

files = {%'kramer_IB_12_33_15.65';...
    'kramer_IB_14_30_41.72';...
    'kramer_IB_14_31_46.18';...
    'kramer_IB_14_32_53.56';...
    'kramer_IB_14_33_57.08';...
    'kramer_IB_14_35_2.191';...
    'kramer_IB_14_36_6.899';...
    'kramer_IB_14_37_11.64';...
    'kramer_IB_14_38_16.35';...
    'kramer_IB_14_39_21.36';...
    };

files = cellfun(@(x) ['20-01-08/',x],files,'unif',0);

files = files'; % [files7Hz files4Hz files2Hz];

multipliers = {'\frac13', '\frac12', '\frac23', '\frac34', '1', '\frac54'}; % [0.333 0.5 0.667 0.75 1 1.25];

no_files = length(files);

figure

for f = 1:no_files
    
    data = dsImport(['Figs_Ben/', files{f}]);
    load(['Figs_Ben/', files{f}, '_sim_spec.mat'])
    
    PPstim = [data.deepRS_PPstim];
    PPfreq = [data.deepRS_PPfreq];
    
    PPfreqs = unique(PPfreq);
    
    no_freqs = length(PPfreqs);
    
    for fr = 1:no_freqs
    
        selected = PPstim == -3.6 & PPfreq == PPfreqs(fr);
        
        subplot(no_files, no_freqs, (f - 1)*no_freqs + fr)
        
        [ax, h1, h2] = plotyy(data(selected).time, data(selected).deepRS_V,...
            data(selected).time, data(selected).deepRS_iPeriodicPulsesBen_input);
        
        set(ax, 'xlim', [4 6]*10^3)
        
        set(gca, 'FontSize', 12)
        
    end
    
end

set(gcf, 'Units', 'inches', 'Position', 1 + [0 0 8 8], 'PaperUnits', 'inches', 'PaperPosition', 1 + [0 0 8 8])

saveas(gcf, ['supp_fig_1.fig'])