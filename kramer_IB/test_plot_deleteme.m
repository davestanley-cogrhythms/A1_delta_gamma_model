
%%

% % Plot 
% h2 = dsPlot2(data,'plot_type','raster','population','IB');
% fig_options.suppress_newfig = true;
% subplot_options.subplot_grid_handle = h2.hsub{1}.hcurr;
% 

Ncells = 20;

% Set up for imagesc
myxp = dsAll2mdd(data);
myxp = myxp.axisSubset('populations','IB');
myxp = myxp.axisSubset('variables','GABAall_gTH');
mean_data = @(x) (mean(x,2));
repmat_data = @(x) repmat(x,[1,Ncells]);
myxp.data = cellfun(mean_data,myxp.data,'UniformOutput',0);
myxp.data = cellfun(repmat_data,myxp.data,'UniformOutput',0);

% Plot Imagesc stuff
mygrey = gray;
% mygrey = mygrey(round(end/2):end,:);
% mygrey = mygrey(1:round(end/2),:);
mygrey = flipud(mygrey);
h2 = dsPlot2(myxp,'plot_type','imagesc','variable','GABAall_gTH','population','IB','ColorMap',mygrey);

mylims = ylim;

% % Plot Imagesc stuff
% mygrey = gray;
% % mygrey = mygrey(round(end/2):end,:);
% % mygrey = mygrey(1:round(end/2),:);
% mygrey = flipud(mygrey);
% h2 = dsPlot2(data,'plot_type','imagesc','variable','GABAall_gTH','population','IB','ColorMap',mygrey);


fig_options.suppress_newfig = true;
subplot_options.subplot_grid_handle = h2.hsub{1}.hcurr;



% Plot GABA A
myxp = dsAll2mdd(data);
myxp = myxp.axisSubset('populations','IB');
myxp = myxp.axisSubset('variables','GABAA_gTH');
mean_data = @(x) (mean(x,2));
% norm_data = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));
norm_data = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:))) * Ncells/1 + mylims(1);
myxp.data = cellfun(mean_data,myxp.data,'UniformOutput',0);
myxp.data = cellfun(norm_data,myxp.data,'UniformOutput',0);
dsPlot2(myxp,'plot_type','waveform','LineWidth',2,'ylim',mylims,...
    'figure_options',fig_options,...
    'subplot_options',subplot_options...
    );




% Plot raster
dsPlot2(data,'plot_type','raster','population','IB','ylim',mylims,...
    'figure_options',fig_options,...
    'subplot_options',subplot_options...
    );


%% Do it using single xp file
clear myplot_options subplot_options
% dsPlot2(data,'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','Ndims_per_subplot',2,'plot_options',plot_options);

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

dsPlot2_PPStim(data, 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','Ndims_per_subplot',2,'plot_options',myplot_options)



%% Test xp_IBphaselock_errbar code (or xp_IBphaselock)

% dsPlot2(data,'plot_type','waveform','population','IB','variable','/V|iPoissonNested_S2/','plot_handle',@xp_IBphaselock,'force_last','varied1','Ndims_per_subplot',3);

dsPlot2(data,'plot_type','waveform','population','IB','variable','/V|iPoissonNested_S2/','plot_handle',@xp_IBphaselock_errbar,'force_last','varied1','Ndims_per_subplot',3);

% 
% parallel_plot_entries{i} = {@dsPlot2_PPStim, data, 'plot_type','raster','population','IB','plot_handle',@xp_raster1_GABAB,'variable','/V|THALL_GABA_gTH|GABAall_gTH|GABAA_gTH/','force_last','variables','Ndims_per_subplot',2,'plot_options',myplot_options,...
%     'saved_fignum',i,'supersize_me',false,'visible','off','save_figures',true,'save_figname_path',save_path,'save_figname_prefix',['Fig ' num2str(i)],'prepend_date_time',false, ...
%     'figheight',chosen_height};
% 


%% Test xp_IBphaselock_corrcoef_errbar code

dsPlot2(data,'plot_type','waveform','population','IB','variable','/iPoissonNested_S2|THALL_GABA_gTH/','plot_handle',@xp_IBphaselock_corrcoef_errbar,'force_last','varied1','Ndims_per_subplot',3);



%% Test xp_IBphaselock_coherence_errbar code

% dsPlot2(data,'plot_type','waveform','population','IB','variable','/iPoissonNested_S2|THALL_GABA_gTH/','plot_handle',@xp_IBphaselock_coherence_errbar,'force_last','varied1','Ndims_per_subplot',3);

dsPlot2(data,'plot_type','waveform','population','IB','variable','/iPoissonNested_S2|THALL_GABA_gTH/','plot_handle',@xp_IBphaselock_coherence_errbar,'force_last','variable','Ndims_per_subplot',3,'do_mean',true);



%% Test xp_IBphaselock_resonance_errbar code

% dsPlot2(data,'plot_type','waveform','population','IB','variable','/iPoissonNested_S2|THALL_GABA_gTH/','plot_handle',@xp_IBphaselock_coherence_errbar,'force_last','varied1','Ndims_per_subplot',3);

dsPlot2(data,'plot_type','waveform','population','IB','variable','/iPoissonNested_S2|THALL_GABA_gTH/','plot_handle',@xp_IBphaselock_resonance_errbar,'force_last','variable','Ndims_per_subplot',3,'do_mean',true);



