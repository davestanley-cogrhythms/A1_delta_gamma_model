function plot_imagesc_PPmaskduration_vs_PPinterval(data_decim,PPmaskdurations,PPmaskfreqs0)


    % Calculate phase locking and add field
    data_decim2 = addfield_IBphaselock_corrcoef_errbar(data_decim);

    % For 2D sweeps, convert back into unmerged varieds
    varied_new = data_decim2(1).simulator_options.modifications(:,2);            % This is the original list of parameters that were varied
    varied_new = unique(varied_new,'stable');                                   % Keep only unique entries in same order
    data_decim2 = convert_ds_colinear_to_2D(data_decim2,varied_new);

    % Actually, we'll just use the original values to populate this, because
    % the other values have rounding errors
    data_decim2b = data_decim2;
    for i = 1:length(data_decim2b)
        data_decim2b(i).PPmaskfreq = PPmaskfreqs0(i);
        data_decim2b(i).PPmaskduration = PPmaskdurations(i);
    end

    % Error checking make sure there's not a big difference between the
    % estimated values and the originals. These should never be
    % triggered
    diffs1 = [data_decim2.PPmaskfreq] - [data_decim2b.PPmaskfreq];
    diffs2 = [data_decim2.PPmaskduration] - [data_decim2b.PPmaskduration];
    if any(abs(diffs1) > 0.1 )
        error('Possible mismatch reconstructing varied values');
    end
    if any(abs(diffs2) > 0.1 )
        error('Possible mismatch reconstructing varied values');
    end
    clear data_decim2

    % Map data_decim PPmaskfreq and PPmaskduration onto the original 2
    % variables - PPmaskrudation and interstimulus interval. This is
    % because we want the two variables to be a square
    data_decim3 = data_decim2b;
    for i = 1:length(data_decim3)
        isi = (1000 / data_decim3(i).PPmaskfreq) - data_decim3(i).PPmaskduration;
        data_decim3(i).PPinterstim_interval = isi;
        data_decim3(i).varied = {'PPmaskduration','PPinterstim_interval'};
    end

    % Produce 2D plot
    durations = unique([data_decim3.PPmaskduration]);
    intervals = unique([data_decim3.PPinterstim_interval]);

    % Build meshgrid
    [X, Y] = meshgrid(durations,intervals);
    Z = zeros(size(X));
    Z_err = zeros(size(X));
    sz = size(X);

    % Convert to 1D
    X=X(:);
    Y=Y(:);
    Z=Z(:);
    Z_err=Z_err(:);

    % Populate Z
    for i = 1:length(data_decim3)
        idx1 = X == data_decim3(i).PPmaskduration;
        idx2 = Y == data_decim3(i).PPinterstim_interval;
        idx = find(idx1 & idx2);
        if length(idx) > 1
            % Error checking
            error('Should only be 1 entry in meshgrid');
        end
        Z(idx) = data_decim3(i).phase_lock_mu;
        Z_err(idx) = data_decim3(i).phase_lock_ste;
    end

    % Convert back to 2D
    X = reshape(X,sz);
    Y = reshape(Y,sz);
    Z = reshape(Z,sz);
    Z_err = reshape(Z_err,sz);

    figure('visible','off');
    imagesc([min(X(:)),max(X(:))],[min(Y(:)),max(Y(:))],Z);
end