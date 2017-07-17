


%%

% Tip: monitor all functions of a mechanism using: monitor MECHANISM.functions


%% Test 1a - GABA B: Response to single 1 mM pulse
    % Note - there is no sense in varying the amplitude, because a single
    % AP will always produce roughly the same amount of NT release- this is
    % basically Tmax, or close to 1.0 mM.
    % I could model depletion, but I think this would mess up AMPA
    % currents, then.
    
% define equations of cell model (same for E and I populations)
eqns={ 
  'dv/dt=@current';
};
stim = [1];
onset = [10];
offset = 11;

PPstim = 0;
PPfreq = 40; % in Hz

PPonset = 30;    % ms, onset time
PPoffset = 600;   % ms, offset time

% create DynaSim specification structure
s=[];
s.populations(1).name='E';
s.populations(1).size=1;
s.populations(1).equations=eqns;
s.populations(1).mechanism_list={'iGABABDesens','iGABABAustin','Vcontroller'};
s.populations(1).parameters={'stim',stim,'onset',onset,'offset',offset ...
    'PPstim',PPstim,'PPfreq',PPfreq,'PPonset',PPonset,'PPoffset',PPoffset, ...
    };
vary = {'E','PPstim',[.01 .1 1 10] };       % vary something randomly
vary = {};

data=dsSimulate(s,'vary',vary,'tspan',[0 800]);
% PlotData(data);


figure('Position',[440   143   579   655]); 
subplot(3,1,1:2);
for i = 1:length(data);
    hold on; plot_normalized_max(data(i).time,[data(i).E_iGABABAustin_gfour, data(i).E_iGABABDesens_gfour])
    %hold on; plot(data(i).time,[data(i).E_iGABABAustin_g, data(i).E_iGABABDesens_G])
end
legend('Destexhe GABAB 1996: Simple 2nd order model', 'Destexhe GABAB 1998: 3rd order model (desensitizing)')
ylabel('fract. open (normalized to 1)');
xlabel('Time (ms)');

subplot(3,1,3);
plot(data(1).time,data(1).E_v);
legend('Transmitter (mM)');
xlabel('Time (ms)');
ylabel('Neurotransmitter (mM)');


%%
% figure
% plot(data(i).time,data(i).E_v);
% 
% figure
% for i = 1:length(data);
%     sum_R_D = data(i).E_iGABABDesens_R + data(i).E_iGABABDesens_D;
%     hold on; plot(data(i).time,[data(i).E_iGABABDesens_R, data(i).E_iGABABDesens_D, data(i).E_iGABABDesens_G,sum_R_D])
% end
% legend('R','D','G','R+D')

%% Test 1b - GABA B: 1mM PPStim at 40 Hz for 500 ms

increase_NMDA_desens = 0;

eqns={ 
  'dv/dt=@current';
};
stim = [0];
onset = [10];
offset = 500;

PPstim = 0.5;
PPfreq = 40; % in Hz

PPonset = 50;    % ms, onset time
PPoffset = 560;   % ms, offset time

% create DynaSim specification structure
s=[];
s.populations(1).name='E';
s.populations(1).size=1;
s.populations(1).equations=eqns;
s.populations(1).mechanism_list={'iGABABDesens','iGABABAustin','Vcontroller'};
s.populations(1).parameters={'stim',stim,'onset',onset,'offset',offset ...
    'PPstim',PPstim,'PPfreq',PPfreq,'PPonset',PPonset,'PPoffset',PPoffset, ...
    };
vary = {'E','PPstim',[.01 .1 1 10] };       % vary something randomly
% vary = {};

data=dsSimulate(s,'vary',vary,'tspan',[0 800]);
% PlotData(data);


for i = 1:length(data);
    figure('Position',[440   143   579   655]); 
    subplot(3,1,1:2);
    hold on; plot_normalized_max(data(i).time,[data(i).E_iGABABAustin_gfour, data(i).E_iGABABDesens_gfour])
    %hold on; plot(data(i).time,[data(i).E_iGABABAustin_g, data(i).E_iGABABDesens_G])
    legend('Destexhe GABAB 1996: Simple 2nd order model', 'Destexhe GABAB 1998: 3rd order model (desensitizing)')
    ylabel('fract. open (normalized to 1)');
    xlabel('Time (ms)');
    
    subplot(3,1,3);
    plot(data(1).time,data(i).E_v);
    legend('Transmitter (mM)');
    xlabel('Time (ms)');
    ylabel('Neurotransmitter (mM)');

end



%% Test 1c - GABA B: 500 ms pulse at 0.5 mM

increase_NMDA_desens = 0;
    
% define equations of cell model (same for E and I populations)
eqns={ 
  'dv/dt=@current';
};
stim = [0.5];
onset = [10];
offset = 510;

PPstim = 0.0;
PPfreq = 40; % in Hz

PPonset = 30;    % ms, onset time
PPoffset = 600;   % ms, offset time


% create DynaSim specification structure
s=[];
s.populations(1).name='E';
s.populations(1).size=1;
s.populations(1).equations=eqns;
s.populations(1).mechanism_list={'iGABABDesens','iGABABAustin','Vcontroller'};
s.populations(1).parameters={'stim',stim,'onset',onset,'offset',offset ...
    'PPstim',PPstim,'PPfreq',PPfreq,'PPonset',PPonset,'PPoffset',PPoffset, ...
    };
vary = {'E','PPstim',[.01 .1 1 10] };       % vary something randomly
vary = {};

data=dsSimulate(s,'vary',vary,'tspan',[0 800]);
% PlotData(data);


figure('Position',[440   143   579   655]); 
subplot(3,1,1:2);
for i = 1:length(data);
    hold on; plot_normalized_max(data(i).time,[data(i).E_iGABABAustin_gfour, data(i).E_iGABABDesens_gfour])
    %hold on; plot(data(i).time,[data(i).E_iGABABAustin_g, data(i).E_iGABABDesens_G])
end
legend('Destexhe GABAB 1996: Simple 2nd order model', 'Destexhe GABAB 1998: 3rd order model (desensitizing)')
ylabel('fract. open (normalized to 1)');
xlabel('Time (ms)');

subplot(3,1,3);
plot(data(1).time,data(1).E_v);
legend('Transmitter (mM)');
xlabel('Time (ms)');
ylabel('Neurotransmitter (mM)');


% 
% 
% 
% %%
% figure; 
% for i = 1:length(data);
%     hold on; plot(data(i).time,[data(i).E_iNMDA_s])
% end
% %%
% figure; 
% for i = 1:length(data);
%     hold on; plot(data(i).time,[data(i).E_iNMDADestexhe1998Markov_o])
% end
% 
% %%
% i=3;
% temp = 1- (data(i).E_iNMDADestexhe1998Markov_c1 + data(i).E_iNMDADestexhe1998Markov_c2 +  data(i).E_iNMDADestexhe1998Markov_d + data(i).E_iNMDADestexhe1998Markov_o);
% figure; plot(data(i).time,[temp, data(i).E_iNMDADestexhe1998Markov_c1, data(i).E_iNMDADestexhe1998Markov_c2, data(i).E_iNMDADestexhe1998Markov_d, data(i).E_iNMDADestexhe1998Markov_o])
% 
% 
