


% Load figures from save if necessary
if save_figures
    % mysaves
    
    save_path = fullfile(study_dir,'Figs_Composite');                       % For saving figures with save_figures flag turned on
    
    % Plotting composite figures
    if save_composite_figures
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
   
    if save_combined_figures
        %Names of state variables: NMDA_s, NMDAgbar, AMPANMDA_gTH, AMPAonly_gTH, NMDAonly_gTH

        % Control height of figures
        chosen_height = min(length(data),4) / 4;        % If lenght(data) >= 4, height is 1; otherwise, use fixed height.

        % % Plot summary statistics
        % Delta statistics - NMDA and GABA B

        i=0;
        parallel_plot_entries = {};

        % % % % % % % % CURRENTS Line plots % % % % % % % %
        % AMPA, GABA A, GABA B
        if include_IB && include_NG && (include_FS || include_dFS5)
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.7],'force_last','variable','LineWidth',2,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
        end
        if include_IB && include_NG && ~(include_FS || include_dFS5)
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','variable','/AMPANMDA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.5],'force_last','variable','LineWidth',2,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
        end

        % RS M current plot
        if include_RS && include_LTS
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','/RS|LTS/','variable','Mich','xlims',ind_range,'do_mean',true,'LineWidth',2,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
        end

        % IB M current plot
        if include_IB
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','variable','Mich','xlims',ind_range,'do_mean',true,'LineWidth',2,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
        end

        % IB h-current plot
        if include_IB
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','variable','AR','xlims',ind_range,'do_mean',true,'LineWidth',2,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
        end
        
        
        % % % % % % % % CONDUCTANCES Power plots % % % % % % % %
        if include_IB && include_NG && include_RS && include_FS && include_LTS && include_dFS5
            % All currents
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data(1),'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPall_gTH/','do_mean',1,'LineWidth',2,...
            'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
            'figheight',1/2,'figwidth',1/2};
        
            % Just delta currents
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data(1),'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPdelta_gTH/','do_mean',1,'LineWidth',2,...
            'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
            'figheight',1/2,'figwidth',1/2};
        end
       
        if include_RS && include_FS && include_LTS && include_dFS5
            % Just gammma oscillator
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data(1),'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPgamma_gTH/','do_mean',1,'LineWidth',2,...
            'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
            'figheight',1/2,'figwidth',1/2};
        end
            
        % % % % % % % % VOLTAGE Line plots % % % % % % % %
        % Waveform plots 2 IB cells
        if include_IB
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','xlims',ind_range,'plot_type','waveform','max_num_overlaid',2,'ylims',[-85 45],...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
        end
        
        % Mean plots
        if 1
            % Waveform plots mean all cells
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'xlims',ind_range,'plot_type','waveform','do_mean',1,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
        end
        
        % Mean plots
        if length(data) == 1
            % Waveform plots mean all cells
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'xlims',ind_range,'plot_type','waveform','max_num_overlaid',2,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',1/2};
        end
        
        % % % % % % % % AP plots % % % % % % % %
        if pulse_train_preset >= 1
            cent=ap_pulse_num*1000/PPfreq;
            crop_range=[cent-100,cent+100];
            
            so.show_AP_vertical_lines = true;
            so.ap_pulse_num = ap_pulse_num;
            so.PPfreq = PPfreq;
            so.PPshift = PPshift;
            so.suppress_legend = true;
            
            maxNpopulations = 6;                % Maximum number of populations we expect to ever plot
            
            % Full voltage waveform plot on first dataset
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data(1),'population','all','crop_range',crop_range,'figwidth',1/3,'subplot_options',so,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',length(spec.populations)/maxNpopulations};

            if length(data) > 1 && include_RS && include_LTS
                i=i+1;
                parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',3,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so,...
                    'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                    };
                
                i=i+1;
                parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','RS','variable','/RS_IBaIBdbiSYNseed_ISYN|LTS_IBaIBdbiSYNseed_ISYN/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so,...
                    'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                    };
                
            end
        end
        
        
        % % % % % % % % Imagesc plots with do_mean = true (no subplotting!) % % % % % % % %
        % IB GABA B 
        if include_IB && include_NG && length(data) > 1
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2, data,'population','IB','variable','/GABAall_gTH/','do_mean',true,'xlims',ind_range,'force_last','varied1','plot_type','imagesc',...
%                 'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
%                 'figheight',chosen_height};
        end

        % % % % % % % % Rastergram plots % % % % % % % %
        if include_IB && length(data) > 1
            % Default rastergram (slow)
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','xlims',ind_range,'plot_type','rastergram',...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
%             % Imagesc fast & cheap version
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2, data,'population','IB','variable','/V/','do_mean',false,'xlims',ind_range,'force_last','varied1','plot_type','imagesc','zlims',[-85,-50]...
%                 'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
%                 'figheight',chosen_height};
        end
        
        if include_IB && include_NG && (include_FS || include_dFS5) && length(data) > 1
            % Default rastergram (slow) with shaded background & line plot
            i=i+1;
            clear myplot_options
            myplot_options.lineplot_ylims = [];
            myplot_options.imagesc_zlims = [];
            myplot_options.show_imagesc = true;
            myplot_options.show_lineplot_FS_GABA = true;
            myplot_options.show_lineplot_NG_GABA = false;
            myplot_options.show_lineplot_NGFS_GABA = false;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data, 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','Ndims_per_subplot',2,'plot_options',myplot_options,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
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
            
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data, 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','Ndims_per_subplot',2,'plot_options',myplot_options,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
            clear myplot_options
        end
        
        if include_IB && include_NG && length(data) > 1
            % Default rastergram (slow) with shaded background; no line plot
            i=i+1;
            clear myplot_options
            myplot_options.lineplot_ylims = [];
            myplot_options.imagesc_zlims = [];
            myplot_options.show_imagesc = true;
            myplot_options.show_lineplot_FS_GABA = false;
            myplot_options.show_lineplot_NG_GABA = false;
            myplot_options.show_lineplot_NGFS_GABA = false;

            parallel_plot_entries{i} = {@dsPlot2_PPStim, data, 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','Ndims_per_subplot',2,'plot_options',myplot_options,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
            clear myplot_options
        end
        
        if include_IB && include_NG && ~(include_FS || include_dFS5) && length(data) > 1
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
            
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data, 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','Ndims_per_subplot',2,'plot_options',myplot_options,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',chosen_height};
            clear myplot_options
        end

        if include_RS && length(data) > 1
    %         i=i+1;
    %         parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','RS','xlims',ind_range,'plot_type','rastergram',...
    %             'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
    %             'figheight',chosen_height};
        end

        if include_FS && length(data) > 1
    %         i=i+1;
    %         parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','FS','xlims',ind_range,'plot_type','rastergram',...
    %             'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
    %             'figheight',chosen_height};
        end

        if include_LTS && length(data) > 1
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','LTS','xlims',ind_range,'plot_type','rastergram',...
%                 'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
%                 'figheight',chosen_height};
        end


        % Compare different IB->IB currents (NMDA, AMPA, total)
        if include_IB
    %         i=i+1;
    %         parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','variable','/AMPANMDA_gTH|NMDAonly_gTH|AMPAonly_gTH/','do_mean',true,'xlims',ind_range,'force_last','variable','LineWidth',2,...
    %             'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
    %             'figheight',chosen_height};
        end

        % % % % % % % % VOLTAGE Firing rate plots % % % % % % % %
        % Firing rate heatmap
        if length(data) > 1
%             i=i+1;
%             parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'xlims',ind_range,'plot_type','heatmap_sortedFR','population','IB',...
%                 'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
%                 'figwidth',chosen_height};
        end
        
        % Firing rate means
        if length(data) > 1
%             i=i+1;
%             so.autosuppress_interior_tics = true;
%             parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'xlims',ind_range,'plot_type','meanFR','population','IB','subplot_options',so,...
%                 'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
%                 'figwidth',chosen_height};
        end
        
        
        % % % % % % % % PHASE locking figures % % % % % % % %
%                                                         Note: PPoffset-PPonset being too low will
%                                                         cause there to be only 1 cycle of the nested
%                                                         stims. Therefore, don't do phase locking figures
%                                                         in this case
        if length(data) > 1 && include_IB && tspan(2) > 5000 && (PPoffset-PPonset) > 800
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data,'plot_type','waveform','population','IB','variable','/V|iPoissonNested_S2/','plot_handle',@xp_IBphaselock_errbar,'force_last','varied1','Ndims_per_subplot',3,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',1/3};
            
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2, data,'plot_type','waveform','population','IB','variable','/iPoissonNested_S2|THALL_GABA_gTH/','plot_handle',@xp_IBphaselock_resonance_errbar,'force_last','variable','Ndims_per_subplot',3,'do_mean',true,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',1/3};

        end
        
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
                            'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                            };                        
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
    

    
end


if plot_on
    % % Do different plots depending on which parallel sim we are running
    switch sim_mode
        case {1,11}            


        case {2,3}

            
        case {5,6}

        case {8,9,10,12}

            
            %%
            % #myfigs9

                inds = 1:length(data);
                


                h = dsPlot2_PPStim(data(inds),'plot_type','rastergram','crop_range',ind_range,'xlim',ind_range,'plot_handle',@xp_PlotData_with_AP);
                
                
                plot_func = @(xp, op) xp_plot_AP_timing1b_RSFS_Vm(xp,op,ind_range);
                dsPlot2_PPStim(data(inds),'plot_handle',plot_func,'Ndims_per_subplot',3,'force_last',{'populations','variables'},'population','all','variable','all','supersize_me',false,'ylims',[-.3 .5],'lock_axes',false);

            
            
            
        case 14
            %% Case 14 - Shuffle sims

            
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
            dsPlot2_PPStim(data,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',3,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)
            dsPlot2_PPStim(data,'population','RS','variable','/RS_IBaIBdbiSYNseed_ISYN|LTS_IBaIBdbiSYNseed_ISYN/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)

        case 15         % Vary is 2D - 1st dimension is shuffle, 2nd is dimension of interest
            
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
            dsPlot2_PPStim(data,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','do_mean',true,'dim_stacking',{'populations','varied2','variables','varied1'},'LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)
            dsPlot2_PPStim(data,'population','RS','variable','/RS_IBaIBdbiSYNseed_ISYN|LTS_IBaIBdbiSYNseed_ISYN/','do_mean',true,'dim_stacking',{'populations','varied2','variables','varied1'},'LineWidth',2,'plot_type','waveformErr','lock_axes',true,'Ndims_per_subplot',2,'crop_range',crop_range,'figwidth',1/3,'figheight',1/2,'subplot_options',so)

            % More exploratory plots
            dsPlot2_PPStim(data,'population','LTS','crop_range',crop_range,'figwidth',1/3,'subplot_options',so)
            dsPlot2_PPStim(data,'population','RS','variable','/LFPrs_gTH|LFPlts_gTH/','crop_range',crop_range,'figwidth',1/3,'subplot_options',so)

            
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
        dsPlot2(data,'variable','_s','do_mean',1,'population','RS')
        dsPlot2_PPStim(data,'population','/RS|LTS/','variable','Mich','xlims',ind_range,'do_mean',true,'LineWidth',2)
        dsPlot2_PPStim(data,'population','/IB/','variable','mAR','xlims',ind_range,'do_mean',true,'LineWidth',2)
        dsPlot2_PPStim(data,'do_mean',1,'population','RS','variable','RS_IBaIBdbiSYNseed_s')                                % Plot just RS conductance
        dsPlot2_PPStim(data,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.7],'force_last','variable','LineWidth',2)
            for i = 1:length(data)/2; dsPlot2_PPStim(data(2*i-1:2*i),'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.7],'force_last','variable','LineWidth',2); end
        for i = 1:length(data); dsPlot2(data(i),'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPall_gTH/','do_mean',1,'LineWidth',2); end
        for i = 1:length(data); dsPlot2(data(i),'plot_type','power','xlims',[0 10],'population','IB','variable','/LFPdelta_gTH/','do_mean',1,'LineWidth',2); end
end

    
spec_all.spec = spec;
spec_all.pop_struct = pop_struct;
%% ##6.0 Move composite figures and individual figs to Figs repo.
outpath = [];
if save_figures_move_to_Figs_repo && save_figures
    outpath = save_allfigs_Dave(study_dir,spec_all,[],false,repo_studyname);
end

fprintf('Elapsed time for full sim is: %g\n',toc(tv1));

%%
