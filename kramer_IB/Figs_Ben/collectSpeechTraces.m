function collectSpeechTraces(name_mat)

names = load(name_mat);

names = names.names;

sim_spec = load([names{1}, '_sim_spec.mat']);

vary = sim_spec.vary;

bands = squeeze(get_vary_field(vary, '(SpeechLowFreq, SpeechHighFreq)'))'; no_bands = length(bands);

gSs = get_vary_field(vary, 'gSpeech');

SIs = get_vary_field(vary, 'SentenceIndex');

tspan = sim_spec.sim_struct.tspan;

time = tspan(1):.1:tspan(2);

all_data = nan(length(time), length(bands), length(gSs), length(names), length(SIs), 2);

for n = 1:length(names)
    
    data = dsImport(names{n});
    
    fields(:, :, 1) = [data.deepRS_V_spikes];
    
    fields(:, :, 2) = [data.deepRS_iSpeechInput_input];
    
    gS = [data.deepRS_gSpeech];
    
    SI = [data.deepRS_SentenceIndex];
    
    for sindex = 1:length(SIs)
       
        for gspeech = 1:length(gSs)
            
            for f = 1:2
            
                all_data(:, :, gspeech, n, sindex, f) = fields(:, gS == gSs(gspeech) & SI == SIs(sindex), f);
                
            end
            
        end
        
    end
    
end

save([name_mat(1:(end - 4)), '_traces.mat'], 'all_data', 'names', 'bands', 'gS', 'gSs', 'SI', 'SIs')

