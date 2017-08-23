
% % % % % % % % % % ##4.1 Run simulation % % % % % % % % % %
tv2 = tic;
if cluster_flag
    data=dsSimulate(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',1,'cluster_flag',1,'overwrite_flag',1,...
        'save_data_flag',1,'study_dir','kramer_IB_sim_mode_2');
    
    return

else
    mexpath = fullfile(pwd,'mexes');
    [data,studyinfo]=dsSimulate(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',1,'parallel_flag',parallel_flag,'cluster_flag',cluster_flag,'study_dir',study_dir,...
        'compile_flag',compile_flag,'save_data_flag',save_data_flag,'save_results_flag',save_results_flag,'mex_dir',mexpath,...
        plot_args{:});
end

% % % % % % % % % % ##4.2 Post process simulation data % % % % % % % % % %
% % Crop data within a time range
% t = data(1).time; data = CropData(data, t > 300 & t <= t(end));


% % When varying synaptic connectivity, convert connectivity measure from
% synaptic conductance / cell to total synaptic conductange 
% (e.g. g_RSFS*N)
pop_struct.Nib = Nib;
pop_struct.Nrs = Nrs;
pop_struct.Nfs = Nfs;
pop_struct.Nlts = Nlts;
pop_struct.Nng = Nng;
pop_struct.NdFS5 = Nfs;
xp = ds2mdd(data,true,true);           % Turned off merging by default
xp = calc_synaptic_totals(xp,pop_struct);
data = dsMdd2ds(xp);

% Re-add synaptic currents to data
recalc_synaptic_currents = 0;                   % Set this to true only if we need to recalc synaptic currents due to monitor functions being off
if recalc_synaptic_currents
    if include_IB && include_NG                     % NG GABA A / B
        % GABA B
        additional_constants = struct;
        mechanism_prefix = 'IB_NG_iGABABAustin';
        additional_constants.EGABAB = EGABA;
        additional_constants.gGABAB = gGABAb_ngib;
        additional_constants.netcon = ones(Nng,Nib);
        current_string = 'gGABAB.*((g.^4./(g.^4 + 100))*netcon).*(IB_V-EGABAB)';    % Taken from mechanism file, iGABABAustin.txt
        additional_fields = {'IB_V'};
        data = dsCalcCurrentPosthoc(data,mechanism_prefix, current_string, additional_fields, additional_constants, 'IGABAB');

        % GABA A
        additional_constants = struct;
        mechanism_prefix = 'IB_NG_IBaIBdbiSYNseed';
        additional_constants.E_SYN = EGABA;
        additional_constants.gsyn = gGABAa_ngib;
        additional_constants.mask = true(Nng,Nib);
        current_string = 'gsyn.*(s*mask).*(IB_V-E_SYN)';    % Taken from mechanism file, iGABABAustin.txt
        additional_fields = {'IB_V'};
        data = dsCalcCurrentPosthoc(data,mechanism_prefix, current_string, additional_fields, additional_constants, 'ISYN');
    end

    if include_IB && include_FS
        % GABA A
        additional_constants = struct;
        mechanism_prefix = 'IB_FS_IBaIBdbiSYNseed';
        additional_constants.E_SYN = EGABA;
        additional_constants.gsyn = gGABAa_fsib;
        additional_constants.mask = ones(Nfs,Nib);
        current_string = 'gsyn.*(s*mask).*(IB_V-E_SYN)';    % Taken from mechanism file, iGABABAustin.txt
        additional_fields = {'IB_V'};
        data = dsCalcCurrentPosthoc(data,mechanism_prefix, current_string, additional_fields, additional_constants, 'ISYN');
    end

    if include_FS
        % GABA A
        additional_constants = struct;
        mechanism_prefix = 'FS_FS_IBaIBdbiSYNseed';
        additional_constants.E_SYN = EGABA;
        additional_constants.gsyn = gGABAa_fsfs;
        additional_constants.mask = ones(Nfs,Nfs);
        current_string = 'gsyn.*(s*mask).*(FS_V-E_SYN)';    % Taken from mechanism file, iGABABAustin.txt
        additional_fields = {'FS_V'};
        data = dsCalcCurrentPosthoc(data,mechanism_prefix, current_string, additional_fields, additional_constants, 'ISYN');
    end
end

% % Add Thevenin equivalents of GABA B conductances to data structure
if include_IB && include_NG && include_FS && include_dFS5; data = dsThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB','IB_dFS5_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'IB_THALL_GABA'); end
if include_IB && include_NG && include_FS && ~include_dFS5; data = dsThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB','IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'IB_THALL_GABA'); end
if include_IB && include_FS && include_dFS5; data = dsThevEquiv(data,{'IB_dFS5_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95],'IB_FS_GABAA'); end  % GABA A only
if include_IB && include_FS && ~include_dFS5; data = dsThevEquiv(data,{'IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95],'IB_FS_GABAA'); end  % GABA A only
if include_IB && include_NG; data = dsThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB'},'IB_V',[-95,-95],'IB_NG_GABAall'); end
if include_IB; data = dsThevEquiv(data,{'IB_IB_IBaIBdbiSYNseed_ISYN','IB_IB_iNMDA_ISYN'},'IB_V',[0,0],'IB_IB_AMPANMDA'); end

% % Calculate averages across cells (e.g. mean field)
data2 = dsCalcAverages(data);

toc(tv2);

% Play Hallelujah
load handel.mat;
sound(y, 1*Fs);
    