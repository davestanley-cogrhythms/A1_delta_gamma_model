

function hxp = xp_phaselock_resonance (xp, op)
    % xp must be 1x1 (e.g. 0 dimensional)
    % Produces phase locking by taking the PSD and then measuring the power
    % of the combined GABA A/B conductances at the frequency corresponding
    % to the stimulus frequency.
    % This method:
    %   - does NOT z-score the data. So power units are real
    %   - DOES detrend the data (linear detrend first, before taking PSD)
    
    hxp = struct;
    
    if nargin < 2
        op = struct;
    end
    
    if isempty(op); op = struct; end;
    
%     op = struct_addDef(op,'args',{});
%     op = struct_addDef(op,'imagesc_zlims',[]);
%     op = struct_addDef(op,'lineplot_ylims',[]);
%         % These are the min and max limits associated with the lineplots
%         % (GABA A and B). If left empty, they will be auto-estimated to the
%         % min and max of the data to be plotted. This option is useful for
%         % ensuring a uniform min and max across multiple subplots
%     op = struct_addDef(op,'show_imagesc',false);             % Imagesc background showing GABA B conductance as shading
%     op = struct_addDef(op,'show_lineplot_FS_GABA',false);       % Line plot with just FS conductance
%     op = struct_addDef(op,'show_lineplot_NG_GABA',false);      % Line plot with just NG conductances
%     op = struct_addDef(op,'show_lineplot_NGFS_GABA',false);      % Line plot with both NG and FS conductances
    
    
%     xlims = op.xlims;
%     ylims = op.ylims;
%     imagesc_zlims = op.imagesc_zlims;
%     lineplot_ylims = op.lineplot_ylims;
%     show_imagesc = op.show_imagesc;
%     show_lineplot_FS_GABA = op.show_lineplot_FS_GABA;
%     show_lineplot_NG_GABA = op.show_lineplot_NG_GABA;
%     show_lineplot_NGFS_GABA = op.show_lineplot_NGFS_GABA;

    % Squeeze out any 1D placeholder axes ("Dim X"). These can be created
    % by the unpacking operation above. 
    xp = xp.squeezeRegexp('Dim');

    % Fix labels
    xp.meta.dynasim.labels{strcmp(xp.meta.dynasim.labels,'IB_V')} = 'NG_V';
    xp.meta.dynasim.labels{1} = 'IB_V';     % Cheap hack - reset first value in labels so that it gets the correct population. Otherwise, it will assume NG cells.
    
    % Convert xp to DynaSim data struct
    data = dsMdd2ds(xp);
    
    % Remove NaNs introduced due to packing
    for i = 1:length(data)
        labels = data(i).labels;
        labels_sans_time = labels(~strcmp(labels,'time'));

        for j = 1:length(labels_sans_time)
            d = data(i).(labels_sans_time{j});
            ind = all(~isnan(d),1);
            d=d(:,ind);
            data(i).(labels_sans_time{j}) = d;
        end
    end
    
    
    
    
    % For each simulation, pull out the on/off regions and calculate phase
    % locking
    Nsims = length(data);
    
    % Pull out frequency of each simulation
    if isfield(data(1),'C_RS_PPmaskfreq_FS_PPm___')
        freqs = zeros(1,Nsims);
        for i = 1:Nsims
            temp = data(i).C_RS_PPmaskfreq_FS_PPm___;
            ind = strfind(temp,'_');
            temp2 = temp(1:ind(1)-1);
            freqs(i) = str2num(temp2);

        end
    else
        freqs = repmat(2.0,1,Nsims);
    end
    
    r_all = zeros(1,Nsims);
    p_all = zeros(1,Nsims);
    rlo_all = zeros(1,Nsims);
    rup_all = zeros(1,Nsims);
    
    for i = 1:Nsims
        
        % Get basic parameters of dataset
        downsample_factor = data(i).simulator_options.downsample_factor;
        dt = data(i).simulator_options.dt * downsample_factor;
        t = data(i).time;
        Fs = 1000/dt;
        
        % Pull out spike times and pulse information
%         synaptic_potential = data(i).IB_THALL_GABA_gTH;    % Used later
%         pulsetrain = data(i).IB_iPoissonNested_S2;
        synaptic_potential{i} = data(i).IB_V(:,2);
        pulsetrain{i} = data(i).IB_V(:,1);
        
        % Means
%         synaptic_potential = mean(synaptic_potential,2);
%         pulsetrain = mean(pulsetrain,2);
        
        % z-score
%         synaptic_potential = zscore(synaptic_potential);
%         pulsetrain = zscore(pulsetrain);
%         
        % Using Matlab builtin function
%             Cxy = mscohere(X,Y,WINDOW,NOVERLAP) uses NOVERLAP samples of overlap
%             from section to section. NOVERLAP must be an integer smaller than
%             WINDOW, if WINDOW is an integer; or smaller than the length of WINDOW,
%             if WINDOW is a vector. If NOVERLAP is omitted or specified as empty,
%             it is set to obtain a 50% overlap.
% 
%             When WINDOW and NOVERLAP are not specified, mscohere divides X into
%             eight sections with 50% overlap and windows each section with a Hamming
%             window. mscohere computes and averages the periodogram of each section
%             to produce the estimate.
%         win = round(0.5 * Fs);
%         nolp = round(win * 0.5);
        %Cxy = mscohere(pulsetrain,synaptic_potential,win,nolp);
        %[Cxy,f] = mscohere(pulsetrain,synaptic_potential,win,nolp,[],Fs);
        %[Cxy, fs] = mscohere(pulsetrain,synaptic_potential);
        
        
        % Using Chronux
% Usage:
% [C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(data1,data2,params)
% Input: 
% Note units have to be consistent. See chronux.m for more information.
%       data1 (in form samples x trials) -- required
%       data2 (in form samples x trials) -- required
%       params: structure with fields tapers, pad, Fs, fpass, err, trialave
%       - optional
%           tapers : precalculated tapers from dpss or in the one of the following
%                    forms: 
%                    (1) A numeric vector [TW K] where TW is the
%                        time-bandwidth product and K is the number of
%                        tapers to be used (less than or equal to
%                        2TW-1). 
%                    (2) A numeric vector [W T p] where W is the
%                        bandwidth, T is the duration of the data and p 
%                        is an integer such that 2TW-p tapers are used. In
%                        this form there is no default i.e. to specify
%                        the bandwidth, you have to specify T and p as
%                        well. Note that the units of W and T have to be
%                        consistent: if W is in Hz, T must be in seconds
%                        and vice versa. Note that these units must also
%                        be consistent with the units of params.Fs: W can
%                        be in Hz if and only if params.Fs is in Hz.
%                        The default is to use form 1 with TW=3 and K=5
%
%	        pad		    (padding factor for the FFT) - optional (can take values -1,0,1,2...). 
%                    -1 corresponds to no padding, 0 corresponds to padding
%                    to the next highest power of 2 etc.
%			      	 e.g. For N = 500, if PAD = -1, we do not pad; if PAD = 0, we pad the FFT
%			      	 to 512 points, if pad=1, we pad to 1024 points etc.
%			      	 Defaults to 0.
%           Fs   (sampling frequency) - optional. Default 1.
%           fpass    (frequency band to be used in the calculation in the form
%                                   [fmin fmax])- optional. 
%                                   Default all frequencies between 0 and Fs/2
%           err  (error calculation [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
%                                   [0 p] or 0 - no error bars) - optional. Default 0.
%           trialave (average over trials when 1, don't average when 0) - optional. Default 0

        params.tapers = [4,Inf];
        params.tapers(2) = 2*params.tapers(1) - 1;
        params.Fs = Fs;
%         [C,phi,S12,S1,S2,f]=coherencyc(pulsetrain,synaptic_potential,params);
%         figure('Position',[  680          32         663        1063]);
%         subplot(311); plot(f,S1); xlim([0 40]); title('Power pulsetrrain');
%         subplot(312); plot(f,S2); xlim([0 40]); title('Power synaptic potential');
%         subplot(313);plot(f,C); xlim([0 40]); title('Coherence');
        
        nsamp = length(t)/1;
        NFFT=2^(nextpow2(nsamp-1)-1);%2); % <-- use higher resolution to capture STO freq variation
        NFFT = 2^(nextpow2(Fs*1));
        NFFT = [];
        synaptic_potential{i}=detrend(synaptic_potential{i}); % detrend the data
%         [tmpPxx,f] = pmtm(synaptic_potential, params.tapers(1), NFFT, Fs); % calculate power
        tmax = double(max(t));
        TW = max(round(5*tmax/11000),4);        % TW is at least 5. When tmax is 5500 use 4 tapers; when tmax is 11000 use 5. When it's 22000, use 10. 
        [Pxx{i},f{i},pxxc{i}] = pmtm(synaptic_potential{i},TW, NFFT, Fs,'unity','ConfidenceLevel',0.95); % calculate power
%         [tmpPxx, f] = pmtm(synaptic_potential,[],[],Fs);
%         figure; plot(f,tmpPxx); xlim([0 20]); ylim([0, .7]);

        % Find resonant frequency
        ind = find(f{i} >= freqs(i),1,'first');
        
        if i == 10
        end
        
        plot_spectra_on = false;
        if plot_spectra_on
            temp = vertcat(Pxx{:});
            mygcf = gcf;

            % Find resonant frequency
            ind = find(f{i} >= freqs(i),1,'first');

            figure('Position',[  680          32         663        1063]);
            subplot(211); plot(t,[synaptic_potential{i}(:) pulsetrain{i}(:)]); title(['Raw for StimFreq=' num2str(freqs(i))]);
            subplot(212); plot(f{i},Pxx{i}); hold on; plot(f{i},pxxc{i}); xlim([0 15]); ylim([0,10e-3]); hold on; plot(f{i}(ind),Pxx{i}(ind),'kx'); title('Power');
        end


        % For errorbar plotting, needs
        pxxc2 = pxxc{i} - repmat(Pxx{i},[1,2]);
        

        
%         hold on; plot(f(ind),tmpPxx(ind),'kx');
        
        % Get power at this frequency
        r_all(i) = Pxx{i}(ind);
        
%         [R,P,RLO,RUP] = corrcoef(pulsetrain,synaptic_potential);
%         r_all(i) = R(1,2);
%         p_all(i) = P(1,2);
        rlo_all(i) = pxxc2(ind,1);
        rup_all(i) = pxxc2(ind,2);
      
    end
    
    plot_spectra_on = false;
    if plot_spectra_on
        temp = vertcat(Pxx{:});
        myymax = max(temp);
        for i = 1:Nsims
            mygcf = gcf;
        
        
            
            % Find resonant frequency
            ind = find(f{i} >= freqs(i),1,'first');
            
            figure('Position',[  680          32         663        1063]);
            subplot(211); plot(t,[synaptic_potential{i}(:) pulsetrain{i}(:)]); title(['Raw for StimFreq=' num2str(freqs(i))]);
            subplot(212); plot(f{i},Pxx{i}); hold on; plot(f{i},pxxc{i}); xlim([0 15]); ylim([0,myymax*2]); hold on; plot(f{i}(ind),Pxx{i}(ind),'kx'); title('Power');
        end
    end
    
    errY = cat(3,rlo_all,rup_all);
    if plot_spectra_on; figure; end
    hxp.hcurr = barwitherr(errY,r_all,'FaceColor',[0.5,0.5,0.5]);

    
end