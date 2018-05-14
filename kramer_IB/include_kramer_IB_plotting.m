


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
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.5],'force_last','variable','LineWidth',2,...
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
        if length(data) > 1 && include_IB && tspan(2) > 5000
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'plot_type','waveform','population','IB','variable','/V|iPoissonNested_S2/','plot_handle',@xp_IBphaselock_errbar,'force_last','varied1','Ndims_per_subplot',3,...
                'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
                'figheight',1/3};
            
            i=i+1;
            parallel_plot_entries{i} = {@dsPlot2_PPStim, data,'plot_type','waveform','population','IB','variable','/iPoissonNested_S2|THALL_GABA_gTH/','plot_handle',@xp_IBphaselock_resonance_errbar,'force_last','variable','Ndims_per_subplot',3,'do_mean',true,...
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
            %%
            dsPlot2_PPStim(data,'variable','/RS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','do_mean',true)
            %%
            % #myfigs1
            % dsPlot(data,'plot_type','waveform');
            inds = 1:1:length(data);
            h = dsPlot2_PPStim(data(inds),'population','all','force_last',{'populations'},'supersize_me',false,'do_overlay_shift',true,'overlay_shift_val',40,'plot_handle',@xp1D_matrix_plot_with_AP,'crop_range',ind_range);
            
            %dsPlot_with_AP_line(data,'plot_type','rastergram');
            dsPlot2_PPStim(data(inds),'plot_type','imagesc','crop_range',ind_range,'population','LTS','zlims',[-100 -20],'plot_handle',@xp_matrix_imagesc_with_AP);
            
            plot_func = @(xp, op) xp_plot_AP_timing1b_RSFS_Vm(xp,op,ind_range);
            dsPlot2_PPStim(data,'plot_handle',plot_func,'Ndims_per_subplot',3,'force_last',{'populations','variables'},'population','all','variable','all','ylims',[-.3 1.2],'lock_axes',false);
            
            if include_IB && include_NG && include_FS; dsPlot(data,'plot_type','waveform','variable',{'IB_NG_GABA_gTH','IB_THALL_GABA_gTH','IB_FS_GABA_gTH'});
%             elseif include_IB && include_NG; dsPlot(data2,'plot_type','waveform','variable',{'IB_NG_GABA_gTH'});
            elseif include_IB && include_FS; dsPlot(data2,'plot_type','waveform','variable',{'IB_FS_GABA_gTH'});
            elseif include_FS;
                %dsPlot(data2,'plot_type','waveform','variable',{'FS_GABA2_gTH'});
            end
            
            %             dsPlot(data,'plot_type','power');
            
            %elseif include_FS; dsPlot(data2,'plot_type','waveform','variable',{'FS_GABA2_gTH'}); end
            %PlotFR(data);
        case {2,3}
            dsPlot(data,'plot_type','waveform');
            % dsPlot(data,'variable','IBaIBdbiSYNseed_s','plot_type','waveform');
            % dsPlot(data,'variable','iNMDA_s','plot_type','waveform');
            
            save_as_pdf(gcf, sprintf('kramer_IB_sim_%d', sim_mode))
            
        case {5,6}
            dsPlot(data,'plot_type','waveform','variable','IB_V');
        case {8,9,10,12}

            
            %%
            % #myfigs9

                inds = 1:length(data);
                h = dsPlot2_PPStim(data(inds),'population','all','force_last',{'populations'},'supersize_me',false,'do_overlay_shift',true,'overlay_shift_val',40,'plot_handle',@xp1D_matrix_plot_with_AP,'crop_range',ind_range);

                dsPlot2_PPStim(data(inds),'plot_type','imagesc','crop_range',ind_range,'population','RS','zlims',[-100 -20],'plot_handle',@xp_matrix_imagesc_with_AP);

                h = dsPlot2_PPStim(data(inds),'plot_type','rastergram','crop_range',ind_range,'xlim',ind_range,'plot_handle',@xp_PlotData_with_AP);
                h = dsPlot2_PPStim(data(inds),'plot_type','rastergram','crop_range',ind_range,'xlim',ind_range,'supersize_me',true)
                %dsPlot2_PPStim(data,'do_mean',1,'plot_type','power','crop_range',[ind_range(1), tspan(end)],'xlims',[0 120]);

                plot_func = @(xp, op) xp_plot_AP_timing1b_RSFS_Vm(xp,op,ind_range);
                dsPlot2_PPStim(data(inds),'plot_handle',plot_func,'Ndims_per_subplot',3,'force_last',{'populations','variables'},'population','all','variable','all','supersize_me',false,'ylims',[-.3 .5],'lock_axes',false);

            
            
            
%             for i = 1:4:8;  dsPlot2_PPStim(data,'plot_type','imagesc','varied1',i:i+3,'population','RS','varied2',[1:2:6],'do_zoom',0,'crop_range',[200 300]);end
%             
%             for i = 1:4:8; dsPlot2_PPStim(data,'plot_type','heatmap_sortedFR','varied1',i:i+3,'population','RS','varied2',[1:6],'do_zoom',0); end
% 
%             for i = 1:4:8;dsPlot2_PPStim(data,'plot_type','power','varied1',i:i+3,'population','RS','varied2',[1:2:6],'do_zoom',0,'do_mean',1,'xlims',[0 80]); end
% 
%             for i = 1:4:8;  dsPlot2_PPStim(data,'plot_type','waveform','varied1',i:i+3,'population','LTS','varied2',[1:1:6],'do_zoom',0,'crop_range',[0 300],'do_mean',1);end



            
            %dsPlot(data,'plot_type','waveform');
            %dsPlot(data,'plot_type','power');
            
            %dsPlot(data2,'plot_type','waveform','variable','FS_FS_IBaIBdbiSYNseed_s');
            %dsPlot(data,'variable','RS_V'); dsPlot(data,'variable','FS_V');
%             
%             tfs = 10;
%             dsPlot_with_AP_line(data,'textfontsize',tfs,'plot_type','waveform','max_num_overlaid',10);
%             
%             t = data(1).time; data3 = CropData(data, t > 350 & t <= t(end));
%             dsPlot_with_AP_line(data3,'textfontsize',tfs,'max_num_overlaid',10,'variable','FS_V','plot_type','waveform')
%             
%             dsPlot_with_AP_line(data3,'textfontsize',tfs,'max_num_overlaid',10,'variable','FS_V','plot_type','rastergram')

            
            %PlotFR2(data,'plot_type','meanFR')
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','RS_V','plot_type','power'); end
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','RS_V'); end
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','FS_V'); end
            %             for i = 1:9:54; dsPlot(data(i:i+8),'variable','RS_FS_IBaIBdbiSYNseed_s'); end
            %             PlotStudy(data,@plot_AP_decay1_RSFS)
            %             PlotStudy(data,@plot_AP_timing1_RSFS)
            %         dsPlot(data,'plot_type','rastergram','variable','RS_V'); dsPlot(data,'plot_type','rastergram','variable','FS_V')
            %         dsPlot(data2,'plot_type','waveform','variable','RS_V');
            %         dsPlot(data2,'plot_type','waveform','variable','FS_V');
            
            %         dsPlot(data,'plot_type','rastergram','variable','RS_V');
            %         dsPlot(data,'plot_type','rastergram','variable','FS_V');
            %         PlotFR2(data,'variable','RS_V');
            %         PlotFR2(data,'variable','FS_V');
            %         PlotFR2(data,'variable','RS_V','plot_type','meanFR');
            %         PlotFR2(data,'variable','FS_V','plot_type','meanFR');
            
%             save_as_pdf(gcf, 'kramer_IB')
            
            
        case 14
            %% Case 14
            data_var = dsCalcAverages(data);                  % Average all cells together
            data_var = RearrangeStudies2Neurons(data);      % Combine all studies together as cells
            dsPlot_with_AP_line(data_var,'plot_type','waveform')
            dsPlot_with_AP_line(data_var,'variable',{'RS_V','RS_LTS_IBaIBdbiSYNseed_s','RS_RS_IBaIBdbiSYNseed_s'});
            opts.save_std = 1;
            data_var2 = dsCalcAverages(data_var,opts);         % Average across cells/studies & store standard deviation
            figl;
            subplot(211);plot_data_stdev(data_var2,'RS_LTS_IBaIBdbiSYNseed_s',[]); ylabel('LTS->RS synapse');
            subplot(212); plot_data_stdev(data_var2,'RS_V',[]); ylabel('RS Vm');
            xlabel('Time (ms)');
            %plot_data_stdev(data_var2,'RS_RS_IBaIBdbiSYNseed_s',[]);
            
            %dsPlot_with_AP_line(data,'variable','RS_V','plot_type','rastergram')
            dsPlot_with_AP_line(data(5),'plot_type','waveform')
            dsPlot_with_AP_line(data(5),'plot_type','rastergram')
            
            
        otherwise
            if 0
                dsPlot(data,'plot_type','waveform');
                %dsPlot_with_AP_line(data,'plot_type','waveform','variable','LTS_V','max_num_overlaid',50);
                %dsPlot_with_AP_line(data,'plot_type','rastergram','variable','LTS_V');
                %dsPlot_with_AP_line(data2,'plot_type','waveform','variable','RS_LTS_IBaIBdbiSYNseed_s');
                %dsPlot_with_AP_line(data2,'plot_type','waveform','variable','LTS_IBiMMich_mM');
            end
            
            if 0
                %% Plot overlaid Vm data
                data_cat = cat(3,data.RS_V,data.FS_V,data.LTS_V);
                figure; plott_matrix3D(data_cat);
            end
            
    end
end
    if 0        % Other plotting code that is run manually
        %% myfigs
        
        ind = 1:4;
        dsPlot_with_AP_line(data(ind))
        dsPlot(data(ind),'plot_type','raster')
        dsPlot_with_AP_line(data(ind),'variable','RS_V')
        dsPlot_with_AP_line(data(ind),'variable','LTS_V')
        
        %%
        ind = 5:8;
        dsPlot_with_AP_line(data(ind))
        dsPlot(data(ind),'plot_type','raster')
        dsPlot_with_AP_line(data(ind),'variable','RS_V')
        dsPlot_with_AP_line(data(ind),'variable','LTS_V')
        
        %%
        
        dsPlot2_PPStim(data,'do_mean',true,'force_last','varied1','plot_type','waveform','Ndims_per_subplot',2,'variable','/RS_IBaIBdbiSYNseed_s|FS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        dsPlot2_PPStim(data,'do_mean',true,'force_last','varied1','plot_type','waveform','Ndims_per_subplot',2,'variable','/IB_IBaIBdbiSYNseed_s|NG_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        
        %dsPlot2_PPStim(data,'do_mean',false,'force_last','varied1','plot_type','waveformErr','Ndims_per_subplot',2,'variable','/RS_IBaIBdbiSYNseed_s|FS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        %dsPlot2_PPStim(data,'do_mean',false,'force_last','varied1','plot_type','waveformErr','Ndims_per_subplot',2,'variable','/IB_IBaIBdbiSYNseed_s|NG_IBaIBdbiSYNseed_s/','population','RS','force_last','variable');
        
        
        %%
        dsPlot2_PPStim(data,'force_last','populations','plot_type','imagesc')
        dsPlot2_PPStim(data,'force_last','populations','plot_type','raster')
        dsPlot2_PPStim(data,'plot_type','raster','population','RS')
        dsPlot2_PPStim(data,'plot_type','waveform','population','NG')
        %dsPlot2_PPStim(data,'population','IB','variable','/IBaIBdbiSYNseed_s/','do_mean',true,'force_last','variable')
        dsPlot2_PPStim(data,'population','RS','variable','/RS_IBaIBdbiSYNseed_s|FS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','do_mean',true,'force_last','variable')
        dsPlot2_PPStim(data,'population','RS','variable','/NMDA_s|LTS_IBaIBdbiSYNseed_s/','do_mean',true,'force_last','variable')
        dsPlot2_PPStim(data,'population','IB','variable','NG_iGABABAustin_g','do_mean',true)
        dsPlot2_PPStim(data,'population','IB','variable','/NMDA_s|NG_GABA_gTH|Mich/','do_mean',true,'force_last','variable')
        
        
        
        dsPlot2_PPStim(data,'plot_type','raster','xlims',[400 1500]);
        dsPlot2_PPStim(data,'population','IB','variable','/NMDA_s|NG_GABA_gTH/','xlims',[400 1500],'do_mean',true,'force_last','variable')
        dsPlot2_PPStim(data,'population','/RS|LTS/','variable','Mich','xlims',[tspan(1) tspan(2)],'do_mean',true)
        
        dsPlot2_PPStim(data,'plot_type','raster','xlims',[1150 1325],'plot_handle',@xp_PlotData_with_AP)
        
        % Play Hallelujah
        if ismac && ~function_mode
            load handel.mat;
            sound(y, 1*Fs);
        end
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
