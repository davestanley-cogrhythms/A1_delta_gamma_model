function [data, name] = kramer_IB_function_mode(sim_struct)

if nargin < 1; sim_struct = []; end
if isempty(sim_struct); sim_struct = struct; end

% Today = datestr(datenum(date),'yy-mm-dd');
% savepath = fullfile('Figs_Ben',Today);
% mkdir(savepath);

function_mode = 1;

kramer_IB

%unpack_sim_struct
vars_pull(sim_struct);

% % % % % % % % % % % % %  ##3.0 Build populations and synapses % % % % % % % % % % % % %
% % % % % % % % % % ##3.1 Populations % % % % % % % % %
include_kramer_IB_populations;

% % % % % % % % % % ##3.2 Connections % % % % % % % % %
include_kramer_IB_synapses;

% % % % % % % % % % % % %  ##4.0 Run simulation & post process % % % % % % % % % % % % %
include_kramer_IB_simulate;


% dsPlot2(data,'plot_type','imagesc')

end