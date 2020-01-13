function hxp = xp_plot_imagesc_PPmaskduration_vs_PPinterval(xp,op)

    hxp = struct;
    
    if nargin < 2
        op = struct;
    end
    
    if isempty(op); op = struct; end
    
    PPmaskdurations = op.PPmaskdurations;
    PPmaskfreqs0 = op.PPmaskfreqs0;

%     % Manually convert xp to data structure without all the baggage of dsMdd2ds
%     data_decim = struct;
%     varied_axis_num = 5;            % Axis #5 in xp should correspond to the varied axis - C_C_RS_PPmaskfreq_IB_P___
%     varied_axis = xp.axis(varied_axis_num);
%     
%     for i = 1:length(varied_axis.values)
%         data_decim(i).(varied_axis.name) = varied_axis.values{i};
%         data_decim(i).labels = xp.meta.dynasim.labels;
%         data_decim(i).varied = xp.meta.dynasim.varied;
%         data_decim(i).simulator_options = xp.meta.dynasim.simulator_options;
%         data_decim(i).time = xp.meta.dynasim.time;
%         data_decim(i).model = xp.meta.dynasim.model;    
%     end
%     data_decim2 = data_decim;

    data_decim2 = dsMdd2ds(xp);
    
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
%     Z_err = zeros(size(X));
    sz = size(X);

    % Convert to 1D
    X=X(:);
    Y=Y(:);
    Z=Z(:);
%     Z_err=Z_err(:);

    % Populate Z
    for i = 1:length(data_decim3)
        idx1 = X == data_decim3(i).PPmaskduration;
        idx2 = Y == data_decim3(i).PPinterstim_interval;
        idx = find(idx1 & idx2);
        if length(idx) > 1
            % Error checking
            error('Should only be 1 entry in meshgrid');
        end
        Z(idx) = data_decim3(i).IB_phaselock_CI_mu;
%         Z_err(idx) = data_decim3(i).IB_phaselock_CI_ste;
    end

    % Convert back to 2D
    X = reshape(X,sz);
    Y = reshape(Y,sz);
    Z = reshape(Z,sz);
%     Z_err = reshape(Z_err,sz);

    imagesc([min(X(:)),max(X(:))],[min(Y(:)),max(Y(:))],Z);
end