
% This code plots the traub synapse, and then compares it to the Destexhe
% GABA_B ode form. I'll try to fit the waveform of the one synapse to the
% other.

%% Setup everything
addpath(genpath('funcs_supporting'));


%% Traub GABAB Synapse
t = 0:2000;
y = calc_carracedo2013(t);
figure; plot(t,y)
xlabel('Time (ms)')
ylabel('y (unitless scaling factor for iGABAB equation)')
title('Carracedo 2013 synapse');


%% Destexhe GABAB synapse
% This is based on the following paper:
% Destexhe, A., Bal, T., McCormick, D. A., & Sejnowski, T. J. (1996). Ionic mechanisms underlying synchronized oscillations and propagating waves in a model of ferret thalamic slices. Journal of Neurophysiology, 76(3), 2049?2070.
% These are also roughly the same equations used by Austin's iGABAB.txt
% synapse. It assumes a single AP causes a neurotranmitter release shaped
% as square pulse 0.5 mM high and 0.3 ms long.

% Note: There is also a GABAB synapse in Destexhe: Methods in Neuronal
% Modeling, Chapter 1). It is exactly the same except for the K1 constant.
% Also, the units are confusing there. I've reproduced them below. However,
% I'll stick with the Destexhe 1996 implementation, following Austin
% unitsconv=1e-3;      % Converts s-1 to ms-1
% unitsconv2=1e-3*1e-3;      % Converts M-1*s-1 to mM-1*ms-1
% K1=9e4 * unitsconv2;  % 9e4 M-1*s-1
% K2=1.2 * unitsconv;  % 1.2s-1
% K3=180 * unitsconv;  % 180s-1
% K4=34 * unitsconv;   % 34s-1

% From (Destxhe 1996),
K1 = 0.5;      % mM^{-1} ms^{-1}
K2 = 0.0012;   % ms^{-1}
K3 = 0.18;     % ms^{-1}
K4 = 0.034;    % ms^{-1}
ttemp = 0:0.1:2000; % ms

[y2,r,s,t2] = calc_destexhe_GABAB(ttemp,K1,K2,K3,K4);
clear ttemp

        figure; subplot(211); plot(t2,[r,s]); legend('state var r','state var s'); title('Destexhe 1996');
        subplot(212); plot(t2,y2); legend('y (unitless scaling factor)'); title('Destexhe 1996');
        ylabel('time (ms)');
        


% Plot comparison
figure; plotyy(t,y/max(y),t2,y2/max(y2));
legend('y: Carracedo 2013 (normalized)','y: Destexhe 1996 (normalized)');
ylabel('time (ms)');
title('Carracedo vs Traub');

%% Fit Destexhe GABAB to Carracedo GABAB
% This fitting produces very different values and might not be appropriate
% for more than one action potential. Also, the improvement in the fit is
% not substantial.

    % Test fitting function
    K0=[K1,K2,K3,K4];
    plot_on=1;
    [err,diff,t,y,t2,y2 ] = diff_destexhe_vs_carracedo(K0);
    figure; subplot(211);
    plotyy(t,y,t2,y2); title('Pre fit');
    legend('y: Carracedo 2013 (normalized)','y: Destexhe 1996 (normalized)');
    ylabel('time (ms)');
    subplot(212); plot(t,diff); title(['Total root mean squared error = ' num2str(err)]); ylabel('difference');
    
    % Perform the fit
    Kfit = fminsearch(@diff_destexhe_vs_carracedo,K0);

    % Test the fit
    plot_on=1;
    [err,diff,t,y,t2,y2 ] = diff_destexhe_vs_carracedo(Kfit);
    figure; subplot(211);
    plotyy(t,y,t2,y2);  title('Pre fit');
    legend('y: Carracedo 2013 (normalized)','y: Destexhe 1996 (normalized)');
    ylabel('time (ms)');
    subplot(212); plot(t,diff); title(['Total root mean squared error = ' num2str(err)]); ylabel('difference');


