
% % % % % % % % % % ##4.1 Run simulation % % % % % % % % % %


% Set up parallel pool if needed
if length(vary) >= 3 && ~cluster_flag
    Nvary = length(vary{3});
    if Nvary > 1 && parallel_flag
        try
            % Try opening new parallel pool if not already opened.
            p = gcp('nocreate');
            if isempty(p);
                foo = min(maxNcores,Nvary);
                fprintf('Starting parallel pool with %d cores.\n',foo);
                pool = parpool(foo,'IdleTimeout', 240);
            end
        catch
            warning('Could not start parpool');
        end
    end
end
% 

tv2 = tic;

if cluster_flag
    parallel_flag = 0;
    save_data_flag = 1;
end

    mexpath = fullfile(pwd,'mexes');
    [data,studyinfo]=dsSimulate(spec,'tspan',tspan,'dt',dt,'downsample_factor',dsfact,'solver',solver,'coder',0,...
        'random_seed',random_seed,'vary',vary,'verbose_flag',1,'parallel_flag',parallel_flag,'cluster_flag',cluster_flag,'study_dir',study_dir,...
        'mex_flag',compile_flag,'save_data_flag',save_data_flag,'save_results_flag',save_results_flag,'mex_dir',mexpath,...
        plot_args{:});
    
if cluster_flag
    
    clear data*
    save(fullfile('.',study_dir,'sim_vars.mat'));
    
    return
end

% % % % % % % % % % ##4.2 Post process simulation data % % % % % % % % % %
% % Crop data within a time range
% t = data(1).time; data = CropData(data, t > 300 & t <= t(end));


% % When varying synaptic connectivity, convert connectivity measure from
% synaptic conductance / cell to total synaptic conductange 
% (e.g. g_RSFS*N)
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
    % All inhibitory currents going to IB cells
if include_IB && include_NG && include_dFS5 && include_tFS5;                    data = dsThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB','IB_dFS5_IBaIBdbiSYNseed_ISYN','IB_tFS5_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95,-95],'IB_THALL_GABA'); end
if include_IB && include_NG && include_dFS5 && ~include_tFS5;                   data = dsThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB','IB_dFS5_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'IB_THALL_GABA'); end
if include_IB && include_NG && include_FS && ~include_dFS5 && ~include_tFS5;    data = dsThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB','IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95,-95],'IB_THALL_GABA'); end


    % Only GABA A inhibition
if include_IB && include_dFS5 && include_tFS5;                  data = dsThevEquiv(data,{'IB_dFS5_IBaIBdbiSYNseed_ISYN','IB_tFS5_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95,-95],'IB_FS_GABAA'); end                % FS GABA A only (deep+translaminar)
if include_IB && include_dFS5 && ~include_tFS5;                 data = dsThevEquiv(data,{'IB_dFS5_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95],'IB_FS_GABAA'); end                % FS GABA A only (deep)
if include_IB && include_FS && ~include_dFS5 && ~include_tFS5;  data = dsThevEquiv(data,{'IB_FS_IBaIBdbiSYNseed_ISYN'},'IB_V',[-95],'IB_FS_GABAA'); end   % FS GABA A only (supra, only if deep is missing)

    % Only GABA B
if include_IB && include_NG; data = dsThevEquiv(data,{'IB_NG_IBaIBdbiSYNseed_ISYN','IB_NG_iGABABAustin_IGABAB'},'IB_V',[-95,-95],'IB_NG_GABAall'); end   % NG GABA A & B

if two_columns_mode 
    if include_IB && include_NG; data = dsThevEquiv(data,{'c2IB_c2NG_IBaIBdbiSYNseed_ISYN','c2IB_c2NG_iGABABAustin_IGABAB'},'c2IB_V',[-95,-95],'c2IB_NG_GABAall'); end   % NG GABA A & B
end

    % Other stuff
if include_IB; data = dsThevEquiv(data,{'IB_IB_IBaIBdbiSYNseed_ISYN','IB_IB_iNMDA_INMDA'},'IB_V',[0,0],'IB_IB_AMPANMDA'); end
if include_IB; data = dsThevEquiv(data,{'IB_IB_iNMDA_INMDA'},'IB_V',[0],'IB_IB_NMDAonly'); end
if include_IB; data = dsThevEquiv(data,{'IB_IB_IBaIBdbiSYNseed_ISYN'},'IB_V',[0],'IB_IB_AMPAonly'); end

% RS LFP
if include_IB && include_NG && include_RS && include_FS && include_LTS
    % RS conductance - contributions from all cells
    if include_tFS5
        data = dsThevEquiv(data,{'RS_RS_IBaIBdbiSYNseed_ISYN',...
                             'RS_FS_IBaIBdbiSYNseed_ISYN',...
                             'RS_LTS_IBaIBdbiSYNseed_ISYN',...
                             'RS_tFS5_IBaIBdbiSYNseed_ISYN',...
                             'RS_IB_IBaIBdbiSYNseed_ISYN',...
                             'RS_IB_iNMDA_INMDA',...
                             'RS_NG_IBaIBdbiSYNseed_ISYN',...
                             'RS_NG_iGABABAustin_IGABAB',...
        },'RS_V',[EAMPA,EGABA,EGABA,EGABA,EAMPA,EAMPA,EGABA,EGABA],'RS_LFPall');
    else
        data = dsThevEquiv(data,{'RS_RS_IBaIBdbiSYNseed_ISYN',...
                             'RS_FS_IBaIBdbiSYNseed_ISYN',...
                             'RS_LTS_IBaIBdbiSYNseed_ISYN',...
                             'RS_IB_IBaIBdbiSYNseed_ISYN',...
                             'RS_IB_iNMDA_INMDA',...
                             'RS_NG_IBaIBdbiSYNseed_ISYN',...
                             'RS_NG_iGABABAustin_IGABAB',...
        },'RS_V',[EAMPA,EGABA,EGABA,EAMPA,EAMPA,EGABA,EGABA],'RS_LFPall');
    end
    
end
   
if include_IB && include_NG && include_RS
    % RS conductance - contributions from delta oscillator
    data = dsThevEquiv(data,{'RS_IB_IBaIBdbiSYNseed_ISYN',...
                             'RS_IB_iNMDA_INMDA',...
                             'RS_NG_IBaIBdbiSYNseed_ISYN',...
                             'RS_NG_iGABABAustin_IGABAB',...
        },'RS_V',[EAMPA,EAMPA,EGABA,EGABA],'RS_LFPdelta');
end

% IB LFP
if include_IB && include_NG
    % IB conductance - contributions from delta oscillator
    data = dsThevEquiv(data,{'IB_IB_IBaIBdbiSYNseed_ISYN',...
                             'IB_IB_iNMDA_INMDA',...
                             'IB_NG_IBaIBdbiSYNseed_ISYN',...
                             'IB_NG_iGABABAustin_IGABAB',...
        },'IB_V',[EAMPA,EAMPA,EGABA,EGABA],'IB_LFPdelta');
end

% RS LFP
if include_RS && include_FS && include_LTS
    % RS conductance - contibutions from gamma oscillator
    data = dsThevEquiv(data,{'RS_RS_IBaIBdbiSYNseed_ISYN',...
                             'RS_FS_IBaIBdbiSYNseed_ISYN',...
                             'RS_LTS_IBaIBdbiSYNseed_ISYN',...
        },'RS_V',[EAMPA,EGABA,EGABA],'RS_LFPgamma');
end

if include_RS
    % RS conductance - contibutions from RS cells only oscillator
    data = dsThevEquiv(data,{'RS_RS_IBaIBdbiSYNseed_ISYN',...
        },'RS_V',[EAMPA],'RS_LFPrs');
end

if include_RS && include_LTS
    % RS conductance - contibutions from gamma oscillator
    data = dsThevEquiv(data,{'RS_LTS_IBaIBdbiSYNseed_ISYN',...
        },'RS_V',[EGABA],'RS_LFPlts');
end

% % Calculate averages across cells (e.g. mean field)
data2 = dsCalcAverages(data);

fprintf('Elapsed time for running simulations is %g\n', toc(tv2));

    