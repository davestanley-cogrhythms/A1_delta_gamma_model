
function save_mfiles(outpath)
% Save .m files
zip(fullfile(outpath,'kramer_IB.zip'),{'kramer_IB.m','include_kramer_IB_populations.m','include_kramer_IB_synapses.m','include_kramer_IB_simulate.m','include_kramer_IB_plotting.m', ...
    'kramer_IB_deltapaper_scripts2.m','kramer_IB_deltapaper_scripts1.m','kramer_IB_deltapaper_tune1.m','kramer_IB_clustersub.m'});

end