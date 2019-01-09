


function [s,f] = setupf_9a_sf(maxNcores,namesuffix,casenum,short_mode,blk_h_current,blk_m_current,PPmaskduration)
        f=1;
        s{f} = struct;
        
        s{f}.PPmaskduration = PPmaskduration;
        namesuffix1 = namesuffix;
        
        namesuffix1 = [namesuffix1 '_pulse_' num2str(s{f}.PPmaskduration) 'ms'];
        
        if blk_h_current
            namesuffix1 = [namesuffix1 '_blkgAR'];
            s{f}.gAR_d = 0;
        end
        
        if blk_m_current
            namesuffix1 = [namesuffix1 '_blkgM'];
            s{f}.gM_d = 0.5;        % Don't fully block, just reduce it substantially
        end
        
        s{f}.save_figures_move_to_Figs_repo = true; s{f}.save_figures = 1; s{f}.move_simfiles_to_repo_presim = true; s{f}.do_commit = 1;
        s{f}.repo_studyname = ['DeltaFig' casenum '_polley'  num2str(f) '' namesuffix1];
        s{f}.sim_mode = 1;
        s{f}.pulse_mode = 7;
        
        % PPStim stuff
        s{f}.pulse_train_preset = 0;
        
        s{f}.PPmaskfreq = 1;    % Do a pulse every 1 second
        s{f}.PPonset = 3950;    % Just let the pulse at 4000 through
        s{f}.PPoffset = 4500;
        s{f}.PPmaskshift = 300;     % Make sure mask shift is at 300!
        
%         % Shuffle through a bunch of values        
%         s{f}.vary = { ...
%             'RS','myshuffle',1:16;...
%             };
        % Stagger time of turnign on IB cells to get phase misalignment
        s{f}.vary = { ...
            'IB','offset',[0:15]*50+500;...
        };

        % Reduce Ncells
        s{f}.Nrs = 20;

        s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
        s{f}.pulse_mode = 7;
        s{f}.tspan=[0 5500];
        
        % Shorten some sim parameters for short mode
        if short_mode
          s{f}.tspan=[0 2500];
          s{f}.PPonset = 950;
          s{f}.PPoffset = 1500;
          s{f}.vary = {'RS','myshuffle',1:8};
        end
        
        % Modifications to each sim have random IC's and independent noise
        s{f}.Jng1=1;   % NG cells
        %s{f}.IC_noise = 0.5;
        s{f}.syn_ngib_IC_noise = 0.5;
        s{f}.random_seed = 'shuffle';
        
        % Add a plot
        plot_options.linecolor = 'k';
        chosen_height = 1/3;
        s{f}.plot_func = @dsPlot2;
        % Full range
        s{f}.parallel_plot_entries_additional{1} = {'population','IB','variable','/V/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,'plot_options',plot_options,...
            'figheight',chosen_height};
        s{f}.parallel_plot_entries_additional{2} = {'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|AMPANMDA_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,...
            'figheight',chosen_height};
        
        % 1000 ms
        s{f}.parallel_plot_entries_additional{3} = {'population','IB','variable','/V/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,'plot_options',plot_options,...
            'xlims',[4000,5000],'figheight',chosen_height};
        s{f}.parallel_plot_entries_additional{4} = {'population','IB','variable','/THALL_GABA_gTH|GABAall_gTH|AMPANMDA_gTH/','do_mean',true,'force_last','varied1','LineWidth',2,'plot_type','waveformErr','lock_axes',false,'Ndims_per_subplot',3,...
            'xlims',[4000,5000],'figheight',chosen_height};
        
        % Adjust AR
        % s{f}.gAR_d=0.5;

end