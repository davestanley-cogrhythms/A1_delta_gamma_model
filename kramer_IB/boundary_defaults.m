%% boundary_defaults script.

variables = {'sum_window', 'smooth_window', 'boundary_window', 'threshold',...
    'refractory', 'onset_time', 'synchrony_window', 'vp_norm', 'plot_opt', 'spike_field', 'input_field'};

short_vars = {'sumwin', 'smoothwin', 'boundwin', 'thresh', 'refrac', 'onset', 'syncwin', 'vpnorm', '', ''};

defaults = {50, 25, 100, 2/3, 50, 1000, 50, 1, 0, 'deepRS_V_spikes', 'deepRS_iSpeechInput_input'};

options_struct = struct;

for v = 1:length(variables)
    
    options_struct.(variables{v}) = defaults{v};
    
end

label = '';

if ~isempty(varargin)

    for v = 1:(length(varargin)/2)
        
        if sum(strcmp(varargin{2*v - 1}, variables)) == 1
            
            this_var_index = find(strcmp(varargin{2*v - 1}, variables));

            options_struct.(variables{this_var_index}) = varargin{2*v};
            
            if ischar(varargin{2*v})
                
                if ~contains(varargin{2*v}, {'spikes', 'input'})
            
                    label = [label, make_label(short_vars{this_var_index}, varargin{2*v}, defaults{this_var_index})];
                    
                end
                
            else
            
                label = [label, make_label(short_vars{this_var_index}, varargin{2*v}, defaults{this_var_index})];
                
                
            end
            
        end

    end

end

fields = fieldnames(options_struct);

for f = 1:length(fields)
    
    eval(sprintf('%s = options_struct.%s;', fields{f}, fields{f}))
    
end