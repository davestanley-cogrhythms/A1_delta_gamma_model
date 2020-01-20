
function save_13a_part(s,f,data)


    % Save info used to generate vary
    PPmaskdurations = s{f}.PPmaskdurations;
    inter_train_interval = s{f}.inter_train_interval;
    PPmaskfreqs0 = s{f}.PPmaskfreqs0;

    % Decimate data to just contain data for calculating phase locking
    % figures
    labels2keep = {'IB_V','time','IB_NG_GABAall_gTH','IB_iPoissonNested_ampaNMDA_Allmasks'};
    data_decim = dsDecimateLabels(data,labels2keep);

    % Saving workspace code. Should be off in most cases, except for
    % debugging
    save(['wrkspc_' repo_savename '.mat'],'data_decim','PPmaskdurations','inter_train_interval','PPmaskfreqs0','-v7.3');

end