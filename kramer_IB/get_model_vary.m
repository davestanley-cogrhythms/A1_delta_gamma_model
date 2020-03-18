function model_vary = get_model_vary(data_name)

if nargin < 1, data_name = []; end

if isempty(data_name)
    
    data_name = {'19-01-24/kramer_IB_17_6_31.38', '19-01-30/kramer_IB_11_20_58.05',...
        '19-02-07/kramer_IB_14_54_48.77', '19-02-27/kramer_IB_15_27_0.6538',...
        '19-01-30/kramer_IB_17_6_54.67'};
    
end

model_vary = cell(1, length(data_name));

parameters_removed = {'mechanism_list'; 'STPshift'; 'STPstim'; 'STPkernelType'; 'STPonset'; 'STPwidth'; 'PPstim'; 'FMPstim'; 'gCar'; 'PPfreq'; 'PPduty'; 'kernel_type'; 'PPnorm'}; 

for m = 1:length(data_name)
    
    sim_spec = load([data_name{m}, '_sim_spec.mat']);
    
    model_vary{m} = sim_spec.vary;
    
    for p = 1:length(parameters_removed)
       
        model_vary{m} = set_vary_field(model_vary{m}, parameters_removed{p}, []);
        
    end
    
end