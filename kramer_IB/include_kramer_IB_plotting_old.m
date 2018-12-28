

if plot_on
    % % Do different plots depending on which parallel sim we are running
    switch sim_mode
        case {1,11}            
            %%
            dsPlot2_PPStim(data,'variable','/RS_IBaIBdbiSYNseed_s|LTS_IBaIBdbiSYNseed_s/','do_mean',true)
            %%
            % #myfigs1
            % dsPlot(data,'plot_type','waveform');

            plot_func = @(xp, op) xp_plot_AP_timing1b_RSFS_Vm(xp,op,ind_range);
            dsPlot2_PPStim(data,'plot_handle',plot_func,'Ndims_per_subplot',3,'force_last',{'populations','variables'},'population','all','variable','all','ylims',[-.3 1.2],'lock_axes',false);
            

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
            data_var = dsRearrangeStudies2Neurons(data);      % Combine all studies together as cells
            dsPlot(data_var,'plot_type','waveform')
            dsPlot(data_var,'variable',{'RS_V','RS_LTS_IBaIBdbiSYNseed_s','RS_RS_IBaIBdbiSYNseed_s'});
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

    