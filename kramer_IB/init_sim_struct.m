function sim_struct = init_sim_struct(varargin)

keys = {'tspan', 'sim_mode', 'pulse_mode', 'save_data_flag', 'parallel_flag'};

values = {[0 1000], 1, 1, 0, 1};

sim_struct = init_struct(keys, values, varargin{:});