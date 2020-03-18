function [data, name, sim_spec, result] = kramer_IB_function_mode(sim_struct) % , simulation) %, varargin)

if nargin < 1; sim_struct = []; end
if isempty(sim_struct); sim_struct = struct; end

% if nargin < 2; simulation = []; end

% simulation = [];
% 
% for i = 1:(length(varargin)/2)
%     
%     if strcmp(varargin{2*i - 1}, 'simulation')
%         
%         simulation = varargin{2*i};
%         
%     end
%     
% end

Today = datestr(datenum(date),'yy-mm-dd');
% mkdir(Today);

start_dir = pwd;
kramer_IB_dir
% if exist('project_folder', 'var')
%     cd (project_folder)
% elseif exist('research_folder', 'var')
%     cd (research_folder)
% end

savepath = fullfile(pwd, 'Figs_Ben', Today);
mkdir(savepath);

Now = clock;
name = sprintf('kramer_IB_%g_%g_%.4g', Now(4), Now(5), Now(6));

function_mode = 1;

kramer_IB

unpack_sim_struct
% vars_pull(sim_struct);

if exist('simulation', 'var')
    
    vary = add_sim_vary(vary, simulation);
   
    sim_struct.vary = vary;
    
    tspan = sim_tspan(simulation);
    
end

include_kramer_IB_populations;

include_kramer_IB_synapses;

solver

if ~exist('vary', 'var')
    
    save(fullfile(savepath, [name, '_sim_spec.mat']), 'sim_spec', 'sim_struct', 'name');
    
    if cluster_flag
        
        data = dsSimulate(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
            'random_seed',random_seed,'verbose_flag',verbose_flag,'cluster_flag',cluster_flag,...
            'debug_flag',debug_flag,'compile_flag',compile_flag,...
            'analysis_functions',analysis_functions,'analysis_options',analysis_options,...
            'overwrite_flag',1,'one_solve_file_flag',1,'qsub_mode',qsub_mode,...
            'save_data_flag',save_data_flag,'study_dir',fullfile(savepath, name));
        
        cd (start_dir)
        
        return
        
    else
        
        tic;
        
        data = dsSimulate(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,... % [data, ~, result]
            'random_seed',random_seed,'verbose_flag',verbose_flag,'parallel_flag',parallel_flag,'num_cores',num_cores,...
            'debug_flag',debug_flag,'compile_flag',compile_flag,...
            'analysis_functions',analysis_functions,'analysis_options',analysis_options,...
            'save_data_flag',save_data_flag,'study_dir',fullfile(savepath, name));
        
        toc;
        
    end
    
else
    
    save(fullfile(savepath, [name, '_sim_spec.mat']), 'sim_spec', 'sim_struct', 'vary', 'name');

    if cluster_flag
        
        data = dsSimulate(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
            'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'cluster_flag',cluster_flag,...
            'debug_flag',debug_flag,'compile_flag',compile_flag,...
            'analysis_functions',analysis_functions,'analysis_options',analysis_options,...
            'overwrite_flag',1,'one_solve_file_flag',1,'qsub_mode',qsub_mode,...
            'save_data_flag',save_data_flag,'study_dir',fullfile(savepath, name));
        
        cd (start_dir)
        
        return
        
    else
        
        tic;
        
        data = dsSimulate(sim_spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,... % [data, ~, result]
            'random_seed',random_seed,'vary',vary,'verbose_flag',verbose_flag,'parallel_flag',parallel_flag,'num_cores',num_cores,...
            'debug_flag',debug_flag,'compile_flag',compile_flag,...
            'analysis_functions',analysis_functions,'analysis_options',analysis_options,...
            'save_data_flag',save_data_flag,'study_dir',fullfile(savepath, name));
        
        toc;
        
    end
    
end

close('all')

dsPlot(data)

figHandles = findobj('Type', 'Figure');

for f = 1:length(figHandles)

    save_as_pdf(figHandles(f), fullfile(savepath, [name, '_', num2str(f)]))
    
end

cd (start_dir)

end

function vary = add_sim_vary(vary, simulation)

sim_vary = get_sim_vary(simulation);

mechanisms = sim_vary(:, 2);

mechanisms = [mechanisms{:}; {'Inoise'; 'PPstim'; 'FMPstim'; 'STPstim'; 'PPfreq'; 'PPduty'; 'PPnorm'; 'kernel_type'}];

for m = 1:length(mechanisms)
    
    vary = set_vary_field(vary, mechanisms{m}, []);
    
end

vary = [vary; sim_vary];

end

function sim_vary = get_sim_vary(simulation)

if strcmp(simulation, 'FI')
    
    sim_vary = {'deepRS', 'I_app', 0:-.1:-20;... -7:-1:-11;... -7:-.2:-11;...
        'deepRS', 'Inoise', 0.25;... .25;... 0:.05:.25;...
        'deepRS', 'PPstim', 0;...
        'deepRS', 'FMPstim', 0;...
        'deepRS', 'STPstim', 0;...
        };
    
elseif strcmp(simulation, 'PLV')
    
    sim_vary = {'deepRS', 'PPfreq', [.25 .5:.5:23];... [.25 .5:.5:23];... [.25 .5 1 1.5 2:23];... 1:10;...
        'deepRS', 'PPstim', 0:-.2:-4;... 0:-.2:-1;... 0:-.5:-2;... 0:-2:-10;... % -Cm_factor*(0:.05:.15);... % Cm_Ben*(-.025:-.025:-.1)/.25;...
        'deepRS', 'PPduty', .25;...
        'deepRS', 'kernel_type', 25;... % 7;... %
        'deepRS', 'PPnorm', 0;... % 1;...
        'deepRS', 'FMPstim', 0;...
        'deepRS', 'STPstim', 0;...
        'deepRS', 'Inoise', .25;...
        };
    
elseif strcmp(simulation, 'PLV_saved')
    
    sim_vary = {'deepRS', 'PPfreq', [.25 .5 1 1.5 2:23];... [.25 .5:.5:23];... [.25 .5 1 1.5 2:23];... 1:10;...
        'deepRS', 'PPstim', 0:-.5:-4;... 0:-.2:-1;... 0:-.5:-2;... 0:-2:-10;... % -Cm_factor*(0:.05:.15);... % Cm_Ben*(-.025:-.025:-.1)/.25;...
        'deepRS', 'PPduty', .25;...
        'deepRS', 'kernel_type', 25;... % 7;... %
        'deepRS', 'PPnorm', 0;... % 1;...
        'deepRS', 'FMPstim', 0;...
        'deepRS', 'STPstim', 0;...
        'deepRS', 'Inoise', .25;...
        };
    
elseif strcmp(simulation, 'FMP')
    
    sim_vary = {'deepRS', 'I_app', -9:-.5:-11;... % [-9.1 -10 -10.2];... % -10;... %
        'deepRS', 'FMPstim', 0:-.2:-1;... % 0;... % -1;... %
        'deepRS', '(FMPhighfreq, FMPlowfreq)', [9 10 15 20; 1 .5 .25 .1];...
        'deepRS', 'PPstim', 0;...
        'deepRS', 'STPstim', 0;...
        'deepRS', 'Inoise', .25;...
        };
    
elseif strcmp(simulation, 'ISI')
    
    sim_vary = {'deepRS', 'mechanism_list', '+iCarracedoEPSPs';...
        'deepRS', 'gCar', 0:500:5000;...
        'deepRS', 'PPstim', 0;...
        'deepRS', 'FMPstim', 0;...
        'deepRS', 'STPstim', 0;...
        % 'deepRS', 'Inoise', .25;...
        };
    
elseif strcmp(simulation, 'STP')
    
    sim_vary = {'deepRS', 'mechanism_list', '+iSpikeTriggeredPulse';...
        'deepRS', 'STPstim', 0:-100:-1000;...
        'deepRS', 'STPshift', 0;...
        'deepRS', 'STPkernelType', 25;...
        'deepRS', 'STPonset', 2000;...
        'deepRS', 'STPwidth', 50;...
        'deepRS', 'PPstim', 0;...
        'deepRS', 'FMPstim', 0;...
        % 'deepRS', 'Inoise', .25;...
        };
    
end           
    
end

function tspan = sim_tspan(simulation)

if strcmp(simulation, 'FI')
    
    tspan = [0 6000];
    
elseif strcmp(simulation, 'PLV')
    
    tspan = [0 30000];
    
elseif strcmp(simulation, 'PLV_saved')
    
    tspan = [0 30000];
    
elseif strcmp(simulation, 'FMP')
    
    tspan = [0 30000];
    
elseif strcmp(simulation, 'ISI')
    
    tspan = [0 120000];
    
elseif strcmp(simulation, 'STP')
    
    tspan = [0 3000];
    
end    

end

function analysis_options_out = add_default_analysis_options(analysis_functions, analysis_options_in)

default_options = {'save_results_flag', 1, 'varied_filename_flag', 1, 'save_prefix', name};

if ~isempty(analysis_functions)
    
    if isempty(analysis_options_in)
    
        if length(analysis_functions) == 1
            
            analysis_options = default_options;
            
        else
            
            for f = 1:length(analysis_functions)
                
                analysis_options{f} = default_options;
                
            end
            
        end
        
    else
    
        if length(analysis_functions) == 1
            
            analysis_options = default_options;
            
        end
        
        for f = 1:length(analysis_functions)
            
            if length(analysis_options) < f
                
                analysis_options{f} = {'save_results_flag', 1, 'varied_filename_flag', 1, 'save_prefix', name};
    
            elseif ~iscell(analysis_options{f})
                
                display('analysis_options must be a cell array of (key-value pair option) cell arrays.')
                
                return
                
            else
                
                analysis_options{f} = {analysis_options{f}{:}, 'save_results_flag', 1, 'varied_filename_flag', 1, 'save_prefix', name};
                
            end
        
        end
        
    end
    
end

end