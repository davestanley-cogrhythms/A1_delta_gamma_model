%%
dsPlot2_PPStim(data,'do_mean',1)
dsPlot2_PPStim(data,'max_num_overlaid',1)


dsPlot2_PPStim(data,'do_mean',1,'variable','/Mich|AR/','population','IB','force_last','variable')

dsPlot2_PPStim(data,'population','IB','plot_type','imagesc')

dsPlot2_PPStim(data,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.5],'force_last','variable','LineWidth',2)

%%
dsPlot2_PPStim(data,'plot_type','raster')


%%
i=4;


dsPlot2_PPStim(data(i),'do_mean',1)
% dsPlot2_PPStim(data(i),'max_num_overlaid',1)
dsPlot2_PPStim(data(i),'plot_type','raster')

dsPlot2_PPStim(data(i),'population','IB','plot_type','imagesc','xlims',[500 1000])
dsPlot2_PPStim(data(i),'population','NG','plot_type','imagesc','xlims',[500 1000])


%% Query values


gNMDA_ibib*Nib
gNMDA_ibng*Nib

gGABAa_ngng*Nng
gGABAb_ngng*Nng

gGABAa_ngib*Nng
gGABAb_ngib*Nng


%% Plot LFPs
dsPlot2_PPStim(data,'population','IB','variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','do_mean',true,'xlims',ind_range,'ylims',[0 0.5],'force_last','variable','LineWidth',2)

dsPlot2(data,'plot_type','power','xlims',[0 80],'population','RS','variable','IB_IBaIBdbiSYNseed_ISYN','do_mean',1)

dsPlot2(data,'plot_type','power','xlims',[0 80],'population','RS','variable','/LFPall_gTH|LFPdelta_gTH|LFPgamma_gTH/','do_mean',1,'LineWidth',2);

dsPlot2(data,'plot_type','waveform','population','RS','variable','/LFPall_gTH|LFPdelta_gTH|LFPgamma_gTH/','do_mean',1,'LineWidth',2);



