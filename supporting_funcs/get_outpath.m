function [outpath,foldername] = get_outpath(sp,folder_suffix)

basepath = fullfile('..','model-dnsim-kramer_IB_Figs2');
foldername = [sp '_' folder_suffix];
outpath = fullfile(basepath,foldername);

end
