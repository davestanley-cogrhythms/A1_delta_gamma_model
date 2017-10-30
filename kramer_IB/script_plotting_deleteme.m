%%
dsPlot2_PPStim(data,'do_mean',1)
dsPlot2_PPStim(data,'max_num_overlaid',1)


dsPlot2_PPStim(data,'do_mean',1,'variable','/Mich|AR/','population','IB','force_last','variable')

dsPlot2_PPStim(data,'population','IB','plot_type','imagesc')

dsPlot2_PPStim(data,'do_mean',1,'variable','/AMPANMDA_gTH|THALL_GABA_gTH|GABAall_gTH/','population','IB','force_last','variable')

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