

%% Save figures
% Plotting composite figures
save_path = fullfile(study_dir,'Figs_Composite');                       % For saving figures with save_figures flag turned on

if save_composite_figures && save_figures
    tv3 = tic;
    data_img = dsImportPlots(study_dir); xp_img_temp = dsAll2mdd(data_img);
    xp_img = calc_synaptic_totals(xp_img_temp,pop_struct); clear xp_img_temp
    if exist('data_old','var')
        data_img = dsMergeData(data_img,data_old);
    end


    p = gcp('nocreate');
    if ~isempty(p) && parallel_flag
        for i = 1:length(xp_img.data{1}); dsPlot2(xp_img,'saved_fignum',i,'supersize_me',true,'save_figname_path',save_path,'save_figname_prefix',['FigC ' num2str(i)],'prepend_date_time',false); end
        fprintf('Elapsed time for parallel saving composites is: %g\n',toc(tv3));
    else
        for i = 1:length(xp_img.data{1}); dsPlot2(xp_img,'saved_fignum',i,'supersize_me',true,'save_figname_path',save_path,'save_figname_prefix',['FigC ' num2str(i)],'prepend_date_time',false); end
        fprintf('Elapsed time for serial saving composites is: %g\n',toc(tv3));
    end

end

% Cheap hack so we can query elements of vary (e.g., vary{1,2}) and not
% have it produce errors. Better way to do this would be to just pull out xp
% axes and query them directly. Lines like: any(strcmp(vary(:,2),'asdfasdfadf')) in
% paricular would previously produce errors.
if isempty(vary); vary = cell(1,3); end

if save_combined_figures || save_shuffle_figures
    %Names of state variables: NMDA_s, NMDAgbar, AMPANMDA_gTH, AMPAonly_gTH, NMDAonly_gTH
    xp = dsAll2mdd(data);
    so.suppress_legend = true;
    
    savefigure_options = {'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'prepend_date_time',false,'subplot_options',so};
    NESP= 1;        % Number of embedded subplots

    % Control height of figures
    chosen_height = min(length(data),4) / 4;        % If lenght(data) >= 4, height is 1; otherwise, use fixed height.

    
    i=0;
    parallel_plot_entries = {};
    
end

if save_combined_figures

    % % % % % % % % CURRENTS Line plots % % % % % % % %
    % AMPA, GABA A, GABA B
    if include_IB && include_NG && (include_FS || include_dFS5)
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.7],'force_last','variable','LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end
    if include_IB && include_NG && ~(include_FS || include_dFS5)
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','IB','variable','/AMPANMDA_gTH|GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.6],'force_last','variable','LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % RS M current plot
    if include_RS && include_LTS
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','/RS|LTS/','variable','Mich','xlims',xlims_range,'do_mean',true,'LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % IB M current plot
    if include_IB
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','IB','variable','Mich','xlims',xlims_range,'do_mean',true,'LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % IB h-current plot
    if include_IB
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','IB','variable','AR','xlims',xlims_range,'do_mean',true,'LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    
    % % % % % % % % CONDUCTANCES Power plots % % % % % % % %
    if do_all_power_plots
        inds = 1:length(data);
    else
        inds = 1;
    end
    for k = inds
        if include_IB && include_NG && include_RS && include_FS && include_LTS && include_dFS5
            % All currents
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data(k), 'num_embedded_subplots', NESP,'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPall_gTH/','do_mean',1,'LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/2,'figwidth',1/2}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];

            % Just delta currents
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data(k), 'num_embedded_subplots', NESP,'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPdelta_gTH/','do_mean',1,'LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/2,'figwidth',1/2}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        end

        if include_RS && include_FS && include_LTS && include_dFS5
            % Just gammma oscillator
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data(k), 'num_embedded_subplots', NESP,'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPgamma_gTH/','do_mean',1,'LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/2,'figwidth',1/2}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        end
    end

    % % % % % % % % VOLTAGE Line plots % % % % % % % %
    % Waveform plots 2 IB cells
    if include_IB
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','IB','xlims',xlims_range,'plot_type','waveform','max_num_overlaid',2,'ylims',[-85 45],...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % Mean plots
    if 1
        % Waveform plots mean all cells
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'xlims',xlims_range,'plot_type','waveform','do_mean',1,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % Mean plots
    if length(data) == 1
        % Waveform plots mean all cells
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'xlims',xlims_range,'plot_type','waveform','max_num_overlaid',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/2}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    
    % % % % % % % % Imagesc plots with do_mean = true (no subplotting!) % % % % % % % %
    % IB GABA B 
    if include_IB && include_NG && length(data) > 1
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2, xp,'population','IB','variable','/GABAall_gTH/','do_mean',true,'xlims',xlims_range,'force_last','varied1','plot_type','imagesc',...
%                 'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%                 'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % % % % % % % % Rastergram plots % % % % % % % %
    if include_IB && length(data) > 1
        % Default rastergram (slow)
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','IB','xlims',xlims_range,'plot_type','rastergram',...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
%             % Imagesc fast & cheap version
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2, xp,'population','IB','variable','/V/','do_mean',false,'xlims',xlims_range,'force_last','varied1','plot_type','imagesc','zlims',[-85,-50]...
%                 'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%                 'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end
    
    if include_RS && length(data) > 1
        % Default rastergram (slow)
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','RS','xlims',xlims_range,'plot_type','rastergram',...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
%             % Imagesc fast & cheap version
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2, xp,'population','IB','variable','/V/','do_mean',false,'xlims',xlims_range,'force_last','varied1','plot_type','imagesc','zlims',[-85,-50]...
%                 'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%                 'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end
                                                                                    % These plots currently only work for max 2D sweeps. 
    if include_IB && include_NG && (include_FS || include_dFS5) && length(data) > 1 && size(vary,1) <= 2
        % Default rastergram (slow) with shaded background & line plot
        i=i+1;
        clear myplot_options
        myplot_options.lineplot_ylims = [];
        myplot_options.imagesc_zlims = [];
        myplot_options.show_imagesc = true;
        myplot_options.show_lineplot_FS_GABA = true;
        myplot_options.show_lineplot_NG_GABA = false;
        myplot_options.show_lineplot_NGFS_GABA = false;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', [], 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','xlims',xlims_range,'Ndims_per_subplot',2,'plot_options',myplot_options,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        clear myplot_options

        % Default rastergram (slow) with GABA A and B lineplots. No background shading
        i=i+1;
        % Get normalization range
        myxp = dsAll2mdd(data);
        myxp = myxp.axisSubset('variables','/THALL_GABA_gTH/');
        d = myxp.data;
        d = cellfun(@(x) (mean(x,2)),d,'UniformOutput',0);
        d = vertcat(d{:});
        maxx = max(d(:));
        minx = min(d(:));
        clear d

        clear myplot_options
        myplot_options.lineplot_ylims = [minx,maxx];
        myplot_options.imagesc_zlims = [];
        myplot_options.show_imagesc = false;
        myplot_options.show_lineplot_FS_GABA = false;
        myplot_options.show_lineplot_NG_GABA = false;
        myplot_options.show_lineplot_NGFS_GABA = true;

        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', [], 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','xlims',xlims_range,'Ndims_per_subplot',2,'plot_options',myplot_options,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        clear myplot_options
    end

    if include_IB && include_NG && length(data) > 1 && size(vary,1) <= 2
        % Default rastergram (slow) with shaded background; no line plot
        i=i+1;
        clear myplot_options
        myplot_options.lineplot_ylims = [];
        myplot_options.imagesc_zlims = [];
        myplot_options.show_imagesc = true;
        myplot_options.show_lineplot_FS_GABA = false;
        myplot_options.show_lineplot_NG_GABA = false;
        myplot_options.show_lineplot_NGFS_GABA = false;

        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', [], 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','xlims',xlims_range,'Ndims_per_subplot',2,'plot_options',myplot_options,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        clear myplot_options
    end

    if include_IB && include_NG && ~(include_FS || include_dFS5) && length(data) > 1 && size(vary,1) <= 2
        % Default rastergram (slow) with NG lineplots only.
        i=i+1;
        % Get normalization range
        myxp = dsAll2mdd(data);
        myxp = myxp.axisSubset('variables','/GABAall_gTH/');
        d = myxp.data;
        d = cellfun(@(x) (mean(x,2)),d,'UniformOutput',0);
        d = vertcat(d{:});
        maxx = max(d(:));
        minx = min(d(:));
        clear d

        clear myplot_options
        myplot_options.lineplot_ylims = [minx,maxx];
        myplot_options.imagesc_zlims = [];
        myplot_options.show_imagesc = false;
        myplot_options.show_lineplot_FS_GABA = false;
        myplot_options.show_lineplot_NG_GABA = true;
        myplot_options.show_lineplot_NGFS_GABA = false;

        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', [], 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','xlims',xlims_range,'Ndims_per_subplot',2,'plot_options',myplot_options,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        clear myplot_options
    end

    if include_RS && length(data) > 1
%         i=i+1;
%         parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','RS','xlims',xlims_range,'plot_type','rastergram',...
%             'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%             'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    if include_FS && length(data) > 1
%         i=i+1;
%         parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','FS','xlims',xlims_range,'plot_type','rastergram',...
%             'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%             'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    if include_LTS && length(data) > 1
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','LTS','xlims',xlims_range,'plot_type','rastergram',...
%                 'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%                 'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end


    % Compare different IB->IB currents (NMDA, AMPA, total)
    if include_IB
%         i=i+1;
%         parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','IB','variable','/AMPANMDA_gTH|NMDAonly_gTH|AMPAonly_gTH/','do_mean',true,'xlims',xlims_range,'force_last','variable','LineWidth',2,...
%             'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%             'figheight',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % % % % % % % % VOLTAGE Firing rate plots % % % % % % % %
    % Firing rate heatmap
    if length(data) > 1
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'xlims',xlims_range,'plot_type','heatmap_sortedFR','population','IB',...
%                 'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%                 'figwidth',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % Firing rate means
    if length(data) > 1
%             i=i+1;
%             so.autosuppress_interior_tics = true;
%             parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'xlims',xlims_range,'plot_type','meanFR','population','IB','subplot_options',so,...
%                 'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)], 'num_embedded_subplots', NSP,...
%                 'figwidth',chosen_height}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end


    % % % % % % % % PHASE locking figures % % % % % % % %
%                                                         Note: PPoffset-PPonset being too low will
%                                                         cause there to be only 1 cycle of the nested
%                                                         stims. Therefore, don't do phase locking figures
%                                                         in this case


    % Decimate data to just contain data for calculating phase locking
    % figures
    labels2keep = {'IB_V','time','IB_NG_GABAall_gTH','IB_iPoissonNested_ampaNMDA_Allmasks'};
    data_decim = dsDecimateLabels(data,labels2keep);
    
    % Saving workspace code. Should be off in most cases, except for
    % debugging
    save_abbreviated_workspace = false;
    save_workspace = false;
    if save_abbreviated_workspace
        % Save just the decimated version
        save('wrkspc_13a_abbrev.mat','data_decim','PPmaskdurations','inter_train_interval','-v7.3');
    end
    
    if save_workspace
        % Save entire workspace
        save('wrkspc_13a.mat','data','PPmaskdurations','inter_train_interval','-v7.3');
    end

    
    if length(data) > 1 && include_IB && tspan(2) > 5000 && (PPoffset-PPonset) > 800
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2, xp,'plot_type','waveform','population','IB','variable','/V|iPoissonNested_ampaNMDA_Allmasks/','plot_handle',@xp_phaselock_FRfract,'force_last','varied1','Ndims_per_subplot',3,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/3}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];

        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2, xp,'plot_type','waveform','population','IB','variable','/iPoissonNested_ampaNMDA_Allmasks|THALL_GABA_gTH/','plot_handle',@xp_phaselock_resonance,'force_last','variable','Ndims_per_subplot',3,'do_mean',true,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/3}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2, xp,'plot_type','waveform','population','IB','variable','/V|iPoissonNested_ampaNMDA_Allmasks/','plot_handle',@xp_phaselock_FRtotalspikes,'force_last','varied1','Ndims_per_subplot',3,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/3}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
        
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2, xp,'plot_type','waveform','population','IB','variable','/GABAall_gTH|iPoissonNested_ampaNMDA_Allmasks/','plot_handle',@xp_phaselock_contrast_index,'force_last','varied1','Ndims_per_subplot',3,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/3}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];

    end
    
    % Code for producing 2D sweep of phase locking values
    if contains(repo_studyname,'DeltaFig13a')                % If we're doing Fig 13...
        
        % Initialize
        data_decim2 = data_decim;
        
        % Calc FRs
        data_decim2 = dsCalcFR(data_decim2);
        
        % Add phase locking based on fraction of IB firing within pulse-on
        data_decim2 = addfield_phaselock_FRfract(data_decim2);
        
        % Add phase locking based on total spiking
        data_decim2 = addfield_phaselock_FRtotalspikes(data_decim2);
        
        % Add phase locking based on contrast index between GABA_B values
        % for start 50% and ending 50% of cycle
        data_decim2 = addfield_phaselock_contrast_index(data_decim2);
        
        
        % plot_options
        % These should be passed in s{f}.PPmaskdurations via case 13a.
        % Can't just get these from data due to rounding errors.
        myplot_options.PPmaskdurations = PPmaskdurations;       
        myplot_options.PPmaskfreqs0 = PPmaskfreqs0;
        
        % Turn off legend
        so.suppress_legend = true;
        
        % Plot phaselock_FRfract
        dsPlot2(data_decim2,'populations','IB','variable','/phaselock_FRfract_mu/','force_last','varied1','Ndims_per_subplot',3,'plot_handle',@xp_plot_imagesc_PPmaskduration_vs_PPinterval,'plot_options',myplot_options,'subplot_options',so);
        
        % Plot phaselock_FRtot_mu
        dsPlot2(data_decim2,'populations','IB','variable','/phaselock_FRtot_mu/','force_last','varied1','Ndims_per_subplot',3,'plot_handle',@xp_plot_imagesc_PPmaskduration_vs_PPinterval,'plot_options',myplot_options,'subplot_options',so);
        
        % Plot phaselock_CI_mu
        dsPlot2(data_decim2,'populations','IB','variable','/phaselock_CI_mu/','force_last','varied1','Ndims_per_subplot',3,'plot_handle',@xp_plot_imagesc_PPmaskduration_vs_PPinterval,'plot_options',myplot_options,'subplot_options',so);
        
        
    end
    
end

if save_shuffle_figures
    
    % % % % % % % % CURRENTS Line plots % % % % % % % %
    % AMPA, GABA A, GABA B
    % If we're doing a shuffle run, and varying no other parameters, plot
    % waveformErr of all conductances (NMDA + GABAb, etc)
    if include_IB && include_NG && (include_FS || include_dFS5) && any(strcmp(vary(:,2),'asdfasdfadf')) && size(vary,1) == 1            % This is the vary marker for shuffling across dims, meaning we should average
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'plot_type','waveformErr', 'num_embedded_subplots', NESP,'Ndims_per_subplot',2,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.5],'force_last','RS_asdfasdfadf','LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/3}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    if include_IB && include_NG && ~(include_FS || include_dFS5) && any(strcmp(vary(:,2),'asdfasdfadf')) && size(vary,1) == 1            % This is the vary marker for shuffling across dims, meaning we should average
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'plot_type','waveformErr', 'num_embedded_subplots', NESP,'Ndims_per_subplot',2,'population','IB','variable','/AMPANMDA_gTH|GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','RS_asdfasdfadf','LineWidth',2,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/3}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end

    % If we're doing a shuffle run and sweeping some other parameter, plot waveformErr average of just GABAb 
    if include_IB && include_NG && any(strcmp(vary(:,2),'asdfasdfadf')) && size(vary,1) > 1            % This is the vary marker for shuffling across dims, meaning we should average
        
        clear po
        ind = xp.findaxis('RS_asdfasdfadf');
        ind = 3-ind;            % If shuffle axis is 2, axis of interest is 3-2=1; if shuffle axis is 1, axis of interest is 3-1=2
        N = size(xp,ind);
        po.cmap = winter(N);
        po.cmap(1,:) = [0,0,0];
        
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'plot_type','waveformErr', 'num_embedded_subplots', NESP,'Ndims_per_subplot',2,'population','IB','variable','/GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','RS_asdfasdfadf','LineWidth',2,'plot_options',po,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',1/3}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
    end
    
    
    % % % % % % % % Aperiodic plots % % % % % % % %
    if pulse_train_preset >= 1 && include_LTS
        cent=ap_pulse_num*1000/PPfreq;
        crop_range=[cent-100,cent+100];

        clear so
        so.show_AP_vertical_lines = true;
        so.ap_pulse_num = ap_pulse_num;
        so.PPfreq = PPfreq;
        so.PPshift = PPshift;
        so.suppress_legend = true;

        maxNpopulations = 6;                % Maximum number of populations we expect to ever plot

        % Full voltage waveform plot on first dataset
        i=i+1;
        parallel_plot_entries{i} = {@dsPlot2_PPStim, data(1), 'num_embedded_subplots', NESP,'population','/RS|FS|LTS/','crop_range',crop_range,'figwidth',1/3,...
            'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
            'figheight',length(spec.populations)/maxNpopulations}; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options,'subplot_options',so];

        % Plot average across last dimension
        if length(data) > 1 && include_RS && include_LTS && size(vary,1) == 1
            % Conductance plot
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,...
                'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
                }; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options,'subplot_options',so];

            % Ionic current plot
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','RS','variable','/RS_IBaIBdbiSYNseed_ISYN|LTS_IBaIBdbiSYNseed_ISYN/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,...
                'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
                }; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options,'subplot_options',so];

        end

        % Averaged across first varied dimension, and then make
        % subplots across 2nd (e.g., for varying AP delay)
        if length(data) > 1 && include_RS && include_LTS && size(vary,1) > 1
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','do_mean',true,'dim_stacking',{'populations','varied2','variables','varied1'},'LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,...
                'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
                }; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options,'subplot_options',so];
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, xp, 'num_embedded_subplots', NESP,'population','RS','variable','/RS_IBaIBdbiSYNseed_ISYN|LTS_IBaIBdbiSYNseed_ISYN/','do_mean',true,'dim_stacking',{'populations','varied2','variables','varied1'},'LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,...
                'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
                }; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options,'subplot_options',so];
        end
    end
    
end


if save_combined_figures || save_shuffle_figures

    % Import any extra plots provided in sim_struct, specific to this
    % simulation
    if function_mode
        if isfield(sim_struct,'parallel_plot_entries_additional')
            if ~isempty(sim_struct.parallel_plot_entries_additional)
                if ~isfield(sim_struct,'plot_func')
                    sim_struct.plot_func = @dsPlot2;
                end

                N_temp = length(sim_struct.parallel_plot_entries_additional);
                default_opts = {};
                for j = 1:N_temp
                    i=i+1;
                    parallel_plot_entries{i} = {sim_struct.plot_func, data, sim_struct.parallel_plot_entries_additional{j}{:}, ...
                        'saved_fignum',i,'save_figname_prefix',['Fig ' num2str(i)],...
                        }; parallel_plot_entries{i} = [parallel_plot_entries{i} savefigure_options];
                end

            end
        end
    end

    tv2 = tic;
    p = gcp('nocreate');
    if ~isempty(p) && parallel_flag
%             try
%                 parfor i = 1:length(parallel_plot_entries)
%                     feval(parallel_plot_entries{i}{1},parallel_plot_entries{i}{2:end});
%                 end
%                 fprintf('Elapsed time for parallel saving plots is: %g\n',toc(tv2));
%             catch
%                 warning('Error, parallel pool failed. Saving figs serially');
            for i = 1:length(parallel_plot_entries); feval(parallel_plot_entries{i}{1},parallel_plot_entries{i}{2:end}); end
            fprintf('Elapsed time for serial saving plots is: %g\n',toc(tv2));
%             end
    else
        for i = 1:length(parallel_plot_entries); feval(parallel_plot_entries{i}{1},parallel_plot_entries{i}{2:end}); end
        fprintf('Elapsed time for serial saving plots is: %g\n',toc(tv2));
    end

end
    


%% Plot_on plots
if plot_on
    % % Do different plots depending on which parallel sim we are running
    switch sim_mode
        case {1}            
            %% Case 1 plotting
            
            do_visible = 'on';      % Override to show plots for case 1
            dsPlot2_PPStim(data,'do_mean',true,'visible',do_visible);
            dsPlot2_PPStim(data,'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|iNMDA_s/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','variable','LineWidth',2,'visible',do_visible)
%             dsPlot2_PPStim(xp,'max_num_overlaid',2,'visible',do_visible);
%             dsPlot2_PPStim(xp,'population','all','plot_type','raster','visible',do_visible);

        case {2,3}

            
        case {5,6}

        case {8,9,10,12,16}
            %% 2D plots
            inds = 1:length(data);
            
            do_transpose = false;           % Transposes rows and columns of subplots
            xp = dsAll2mdd(data(inds));
            
            if do_transpose
                % Optional correction - flip x/y varied; not guranteed to work in all
                % situations
                xp=xp.permute([2,1,3,4]);
            end

            NESP = 1;
            plot2_figure_options = {'visible',do_visible,'num_embedded_subplots',NESP,'xlims',xlims_range};
            %dsPlot2_PPStim(xp,'population','all','do_mean',1,'ylims',[-95,-40],plot2_figure_options{:})
            %dsPlot2_PPStim(xp,'population','all','do_mean',1,'ylims',[-95,-65],plot2_figure_options{:})
            if include_IB; dsPlot2_PPStim(xp,'plot_type','raster','population','IB',plot2_figure_options{:}); end
            %dsPlot2_PPStim(xp,'plot_type','raster','population','NG',plot2_figure_options{:});
            %dsPlot2_PPStim(xp,'population','IB','xlims',xlims_range,'plot_type','waveform','max_num_overlaid',1,plot2_figure_options{:});
    %         dsPlot2_PPStim(xp,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH|iNMDA_s/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','variable','LineWidth',2,plot2_figure_options{:})
            dsPlot2_PPStim(xp,'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|iNMDA_s/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','variable','LineWidth',2,plot2_figure_options{:})
%             dsPlot2_PPStim(xp,'population','/IB/','variable','/iGABABAustin_g/','xlims',xlims_range,'do_mean',true,'LineWidth',2,'ylims',[0 3],plot2_figure_options{:});
%             dsPlot2_PPStim(xp,'population','/IB/','variable','mAR','xlims',xlims_range,'do_mean',true,'LineWidth',2,plot2_figure_options{:})
%             dsPlot2_PPStim(xp,'population','/IB/','variable','Mich','xlims',xlims_range,'do_mean',true,'LineWidth',2,plot2_figure_options{:})
            dsPlot2_PPStim(xp,'population','/RS|LTS/','variable','Mich','xlims',xlims_range,'do_mean',true,'LineWidth',2,plot2_figure_options{:})

% 
%             % Plot varied parameters individually
%             N=length(vary{3,3});
%             N=5;
%             for i = 1:N; dsPlot2_PPStim(xp,'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|iNMDA_s/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','variable','LineWidth',2,'varied3',i,plot2_figure_options{:}); end
% 
% 
%             % IB PPStim NMDA plots 
%             dsPlot2_PPStim(xp,'population','IB','variable','/iPoissonNested_ampaNMDA_S3|iPoissonNested_ampaNMDA_S3_NMDA|tFS5_IBaIBdbiSYNseed_s/','do_mean',true,'xlims',xlims_range,'ylims',[],'force_last','variable','LineWidth',2,plot2_figure_options{:})
%             dsPlot2_PPStim(xp,'population','IB','variable','/iPoissonNested_ampaNMDA_ISYN|tFS5_IBaIBdbiSYNseed_ISYN/','do_mean',true,'xlims',xlims_range,'ylims',[],'force_last','variable','LineWidth',2,plot2_figure_options{:})


        case 14
            %% Case 14 - Shuffle sims
            
            xp = dsAll2mdd(data);

            
            % % % For plotting AP data % % %
            % Center around AP pulse
            cent=ap_pulse_num*1000/PPfreq;
            crop_range=[cent-100,cent+100];

            % Set up subplot_options
            so.show_AP_vertical_lines = true;
            so.ap_pulse_num = ap_pulse_num;
            so.PPfreq = PPfreq;
            so.PPshift = PPshift;
            so.suppress_legend = true;

            maxNpopulations = 6;                % Maximum number of populations we expect to ever plot

            % Full voltage waveform plot on first dataset
            dsPlot2_PPStim(data(1),'population','all','crop_range',crop_range,'figwidth',1/3,'subplot_options',so)

            % Current and conductance plots - moving averages
            dsPlot2_PPStim(xp,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)
            dsPlot2_PPStim(xp,'population','RS','variable','/RS_IBaIBdbiSYNseed_ISYN|LTS_IBaIBdbiSYNseed_ISYN/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)

        case 15         % Vary is 2D - 1st dimension is shuffle, 2nd is dimension of interest
            %% AP pulse simulations
            
            xp = dsAll2mdd(data);
            
            % % % For plotting AP data % % %
            % Center around AP pulse
            cent=ap_pulse_num*1000/PPfreq;
            crop_range=[cent-100,cent+100];

            % Set up subplot_options
            so.show_AP_vertical_lines = true;
            so.ap_pulse_num = ap_pulse_num;
            so.PPfreq = PPfreq;
            so.PPshift = PPshift;
            so.suppress_legend = true;

            maxNpopulations = 6;                % Maximum number of populations we expect to ever plot
            
            % Conductance and current plots
            dsPlot2_PPStim(xp,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','do_mean',true,'dim_stacking',{'populations','varied2','variables','varied1'},'LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)
            dsPlot2_PPStim(xp,'population','RS','variable','/RS_IBaIBdbiSYNseed_ISYN|LTS_IBaIBdbiSYNseed_ISYN/','do_mean',true,'dim_stacking',{'populations','varied2','variables','varied1'},'LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)

            % More exploratory plots
            dsPlot2_PPStim(xp,'population','LTS','crop_range',crop_range,'figwidth',1/3,'subplot_options',so)
            dsPlot2_PPStim(xp,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','crop_range',crop_range,'figwidth',1/3,'subplot_options',so)
            
            
        case 19
            %% Spontanous activity 4D variation
            axis1 = 'IB_PP_gSYN';
            
            % 2D subplot grid
            dsPlot2_PPStim(xp,'population','IB','variable','/GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last',axis1,'LineWidth',2,'num_embedded_subplots',2,'visible',do_visible);
            
            % Force 1D subplot grid
            dsPlot2_PPStim(xp,'population','IB','variable','/GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last',axis1,'LineWidth',2,'num_embedded_subplots',1,'visible',do_visible);

            dsPlot2_PPStim(xp(:,:,:,1,:,:),'population','IB','variable','/GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','IB_stim2','LineWidth',2,'visible',do_visible,'figwidth',1/2)
            dsPlot2_PPStim(xp(:,:,:,1,:,:),'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|iNMDA_s/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.4],'force_last','variable','LineWidth',2,'visible',do_visible)
            
        case {20,21}            % For plotting up to 4D data (4 varied parameters, 1 population, and 1 variable). Additional dimensions will be as part of new figures
            %% Excitatory / inhibitory reset 4D variation
            xp = dsAll2mdd(data);
            
            % Switches to control which plotting
            plot_everything = 0;                                        % Setting to 1 plots many different axis combinations; setting to 0 plots a much smaller subset
            plot_3D = 0;
            plot_2D = 1;
            plot_1D = 0;
            plot_transpose = 0;
            
            
            k = 0;
            switch sim_mode
                case 20
                    axnames = xp.exportAxisNames;
                    axis1 = axnames{4};             % Axis 1 is compressed into overlaid plots  *** THIS SHOULD BE THE AXIS CONTAINING THE "DEFAULT" SIM ***
                    axis2 = axnames{3};             % Axis 2 is reserved for separate figures
                    axis3 = axnames{2};             % Subplots dim1
                    axis4 = axnames{1};             % Subplots dim2
%                     axis1 = 'IB_PP_gSYN';                               % Axis 1 will generally be the default axis to overlay. Sometimes test the reverse, however
%                     axis2 = 'C_IB_PPmaskshift_RS_PP___';                % Second 2 will either be overlaid as well, or separated out to create new figures
%                     axis3 = 'IB_stim2';                                 % axis3 and 4 are tertiary axes, occasionally swapped in to view data from other angles
%                     axis4 = 'NG_IB_gGABAB';
                    
                    % GABA B
                    k = k+1;
                    chosen_var0{k} = '/GABAall_gTH/';
                    chosen_ylims0{k} = [0 0.4];
                    
                    % Subthreshold range
                    k = k+1;
                    chosen_var0{k} = '/V/';
                    chosen_ylims0{k} = [-95 -20];
%                     
%                     % NMDA conductance
%                     k = k+1;
%                     chosen_var0{k} = '/iNMDA_s/';
%                     chosen_ylims0{k} = [0 0.4];
                    
                    
                case 21
                % We flip axis1 and axis2 for case 21 (corresponds to
                % pulse_mode = 7) because we need axis1 to contain the
                % "default" (e.g., no stim) case. For pulse_mode7, C_IB_PPmaskshift_RS_PP___
                % has to contain the no stim case, because tFS5_IB_g_SYN
                % does not eliminate the L6 CT excitation to IB cells
                % associated with pulse_mode=7
                    axnames = xp.exportAxisNames;
                    axis1 = axnames{4};             % Axis 1 is compressed into overlaid plots  *** THIS SHOULD BE THE AXIS CONTAINING THE "DEFAULT" SIM ***
                    axis2 = axnames{3};             % Axis 2 is reserved for separate figures
                    axis3 = axnames{2};             % Subplots dim1
                    axis4 = axnames{1};             % Subplots dim2
                    
                    % GABA B
                    k = k+1;
                    chosen_var0{k} = '/GABAall_gTH/';
                    chosen_ylims0{k} = [0 0.4];
                    
                    % Membrane voltage
                    k = k+1;
                    chosen_var0{k} = '/V/';
                    chosen_ylims0{k} = [-95 -20];
                    
%                     % Subthreshold range
%                     k = k+1;
%                     chosen_var0{k} = '/V/';
%                     chosen_ylims0{k} = [-95 -60];
                    
%                     % h current
%                     k = k+1;
%                     chosen_var0{k} = '/mAR/';
%                     chosen_ylims0{k} = [];              % Auto-adjust axes
                    
                    
            end
            
            for k = 1:length(chosen_var0)
                chosen_var = chosen_var0{k};
                chosen_ylims = chosen_ylims0{k};

                % % % % % % % % Combined plots - all 4 dims compressed onto single plot % % % % % % % % 
                if plot_3D
                    % With overlay shiftt
                    dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'force_last',axis1, 'LineWidth',2,'Ndims_per_subplot',2,'do_overlay_shift',true,'visible',do_visible);
                    dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'force_last',axis2,'LineWidth',2,'Ndims_per_subplot',2,'do_overlay_shift',true,'visible',do_visible);

                    % Without overlay shift
                    dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis2,'LineWidth',2,'Ndims_per_subplot',2,'visible',do_visible);



                    % Without overlay shift, but with grouping colours
                    colourarr = {'k','b','g','r','y','m'};           
                        % Plot first value
                    i=1;
                    po.plotargs= {'Color',colourarr{i}};
                    h = dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,axis1,i,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis2,'LineWidth',2,'visible',do_visible,'plot_options',po);
                        % Plot remaining values with hold on
                    clear fo so
                    fo.suppress_newfig = true;
                    so.subplot_grid_handle = h.hsub{1}.hcurr;
                    ind = findaxis(xp,axis1);
                    for i = 2:size(xp,ind)
                        po.plotargs= {'Color',colourarr{i}};
                        dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,axis1,i,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis2,'LineWidth',2,'visible',do_visible,'plot_options',po,'figure_options',fo,'subplot_options',so);
                    end

                    % As above, alternate colour grouping
                    colourarr = {'k','b','g','r','y','m'};           
                        % Plot first value
                    i=1;
                    po.plotargs= {'Color',colourarr{i}};
                    h = dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,axis2,i,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'visible',do_visible,'plot_options',po);
                        % Plot remaining values with hold on
                    clear fo so
                    fo.suppress_newfig = true;
                    so.subplot_grid_handle = h.hsub{1}.hcurr;
                    ind = findaxis(xp,axis2);
                    for i = 2:size(xp,ind)
                        po.plotargs= {'Color',colourarr{i}};
                        dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,axis2,i,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'visible',do_visible,'plot_options',po,'figure_options',fo,'subplot_options',so);
                    end
                end


                % % % % % % % % 1D subplots - sweeping along one axis, creating new figs for the other axis as we go % % % % % % % % 
                if plot_1D
                    dsPlot2_PPStim(xp,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'force_last',axis1,'LineWidth',2,'Ndims_per_subplot',2,'do_overlay_shift',true,'num_embedded_subplots',1,'figwidth',1/2,'visible',do_visible);
                end


                % % % % % % % % 2D subplots, but only 1 dim overlaid in subplots % % % % % % % % 
                if plot_2D
                    % Default configuration
                    axname = axis2;
                    ind = xp.findaxis(axname);
                    Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                    for i = 1:size(xp2,1)
                        xp3 = xp2(i,:);
                        dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'visible',do_visible);
                    end

        %             % (Repeat above, but for individual plots - 1D subplots)
        %             for i = 1:size(xp2,1)
        %                 xp3 = xp2(i,:);
        %                 dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'num_embedded_subplots',1,'visible',do_visible,'figwidth',1/2); 
        %             end

                    
                    % Alternate colours
                    axname = axis1;
                    ind = xp.findaxis(axname);
                    Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                    for i = 1:size(xp2,1)
                        xp3 = xp2(i,:);
                        dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis2,'LineWidth',2,'visible',do_visible);
                    end
                    
                    % Alternate colours
                    axname = axis2;
                    ind = xp.findaxis(axname);
                    Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                    for i = 1:size(xp2,1)
                        xp3 = xp2(i,:);
                        dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis3,'LineWidth',2,'visible',do_visible);
                    end
                    
                    % Alternate colours
                    axname = axis2;
                    ind = xp.findaxis(axname);
                    Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                    for i = 1:size(xp2,1)
                        xp3 = xp2(i,:);
                        dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis4,'LineWidth',2,'visible',do_visible);
                    end
                        
                    if plot_everything
                        % Alternate config 2
                        axname = axis2;
                        ind = xp.findaxis(axname);
                        Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                        for i = 1:size(xp2,1)
                            xp3 = xp2(i,:);
                            dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'visible',do_visible);
                        end

                        % Alternate config 3
                        axname = axis3;
                        ind = xp.findaxis(axname);
                        Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                        for i = 1:size(xp2,1)
                            xp3 = xp2(i,:);
                            dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'visible',do_visible);
                        end

                        % Alternate config 4
                        axname = axis4;
                        ind = xp.findaxis(axname);
                        Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                        for i = 1:size(xp2,1)
                            xp3 = xp2(i,:);
                            dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'visible',do_visible);
                        end
                    end

                    if plot_transpose
                        % Default configuration, but transposed
                        axname = axis2;
                        ind = xp.findaxis(axname);
                        Nd = ndims(xp); xp2 = xp.permute([ind,1:ind-1,ind+1:Nd]);       % Bring chosen axis to front
                        xp2 = xp.permute([1,3,2,4:Nd]);                                  % Permute the remaining 2 axes
                        for i = 1:size(xp2,1)
                            xp3 = xp2(i,:);
                            dsPlot2_PPStim(xp3,'population','IB','variable',chosen_var,'do_mean',true,'xlims',xlims_range,'ylims',chosen_ylims,'force_last',axis1,'LineWidth',2,'visible',do_visible);
                        end
                    end
                end
            end

        otherwise
            if 0
                dsPlot2(data,'plot_type','waveform');

            end

            
    end
end

if 0        % Other plotting code that is run manually        
    %% Latest figs (circa figures folder: d181218_t005222__kr_183a_get_RS_fire_jitter)
        for i = 1:length(data); dsPlot2_PPStim(data(i),'plot_type','rastergram'); end
        dsPlot2_PPStim(data,'plot_type','raster')
        dsPlot2_PPStim(data,'plot_type','raster','population','IB');
        dsPlot2_PPStim(data,'plot_type','waveform','population','IB');
        dsPlot2_PPStim(data,'plot_type','raster','population','dFS5');
        dsPlot2_PPStim(data,'variable','_s','do_mean',1,'population','RS')
        dsPlot2_PPStim(data,'population','/RS|LTS/','variable','Mich','xlims',xlims_range,'do_mean',true,'LineWidth',2)
        dsPlot2_PPStim(data,'population','/IB/','variable','mAR','xlims',xlims_range,'do_mean',true,'LineWidth',2)
        dsPlot2_PPStim(data,'do_mean',1,'population','RS','variable','RS_IBaIBdbiSYNseed_s')                                % Plot just RS conductance
        dsPlot2_PPStim(data,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.7],'force_last','variable','LineWidth',2)
            for i = 1:length(data)/2; dsPlot2_PPStim(data(2*i-1:2*i),'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',xlims_range,'ylims',[0 0.7],'force_last','variable','LineWidth',2); end
        for i = 1:length(data); dsPlot2(data(i),'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPall_gTH/','do_mean',1,'LineWidth',2); end
        for i = 1:length(data); dsPlot2(data(i),'plot_type','power','xlims',[0 10],'population','IB','variable','/LFPdelta_gTH/','do_mean',1,'LineWidth',2); end
        
        % Plotting for case 7 - tFS5 stimulation
        dsPlot2_PPStim(data,'population','/IB|tFS5/','do_mean',1,'ylims',[-90,-40])
end

if plot_on2
    
end



