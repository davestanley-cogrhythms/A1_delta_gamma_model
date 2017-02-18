


%%

% Tip: monitor all functions of a mechanism using: monitor MECHANISM.functions


%% Test 1a - NMDA: Response to single 1 mM pulse
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
%s.populations(1).mechanism_list={'iGABABAustin','iNMDA','iNMDADestexhe1998Markov','Vcontroller'};
s.populations(1).mechanism_list={'iNMDA','iNMDADestexhe1998Markov','Vcontroller'};
s.populations(1).parameters={'stim',stim,'onset',onset,'offset',offset ...
    'PPstim',PPstim,'PPfreq',PPfreq,'PPonset',PPonset,'PPoffset',PPoffset, ...
    };
vary = {'E','PPstim',[.01 .1 1 10] };       % vary something randomly
vary = {};

data=SimulateModel(s,'vary',vary,'tspan',[0 800]);
% PlotData(data);


figure('Position',[440   143   579   655]); 
subplot(3,1,1:2);
for i = 1:length(data);
    hold on; plot_normalized_max(data(i).time,[data(i).E_iNMDA_s, data(i).E_iNMDADestexhe1998Markov_o])
end
legend('Destexhe: Simple 2-state model', 'Destexhe: 4-state Markov model')
ylabel('fract. open (normalized to 1)');
xlabel('Time (ms)');

subplot(3,1,3);
plot(data(1).time,data(1).E_v);
legend('Transmitter (mM)');
xlabel('Time (ms)');
ylabel('Neurotransmitter (mM)');

%% Test 1b - NMDA: 1mM PPStim at 40 Hz for 500 ms

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

if increase_NMDA_desens
    Rd_delta = 2*8.4*10^-3;
else
    Rd_delta = 0;
end
Rd = 8.4*10^-3 - Rd_delta;
Rr = 6.8*10^-3 + Rd_delta;

% create DynaSim specification structure
s=[];
s.populations(1).name='E';
s.populations(1).size=1;
s.populations(1).equations=eqns;
%s.populations(1).mechanism_list={'iGABABAustin','iNMDA','iNMDADestexhe1998Markov','Vcontroller'};
s.populations(1).mechanism_list={'iNMDA','iNMDADestexhe1998Markov','Vcontroller'};
s.populations(1).parameters={'stim',stim,'onset',onset,'offset',offset ...
    'PPstim',PPstim,'PPfreq',PPfreq,'PPonset',PPonset,'PPoffset',PPoffset, ...
    'Rd ', Rd, 'Rr', Rr, ...
    };
vary = {'E','PPstim',[.01 .1 1 10] };       % vary something randomly
vary = {};

data=SimulateModel(s,'vary',vary,'tspan',[0 800]);
% PlotData(data);

figure('Position',[440   143   579   655]); 
subplot(3,1,1:2);
for i = 1:length(data);
    hold on; plot_normalized_max(data(i).time,[data(i).E_iNMDA_s, data(i).E_iNMDADestexhe1998Markov_o])
end
legend('Destexhe: Simple 2-state model', 'Destexhe: 4-state Markov model')
ylabel('fract. open (normalized to 1)');
xlabel('Time (ms)');

subplot(3,1,3);
plot(data(1).time,data(1).E_v);
legend('Transmitter (mM)');
xlabel('Time (ms)');
ylabel('Neurotransmitter (mM)');




%% Test 1c - NMDA: 500 ms pulse at 1 mM

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


if increase_NMDA_desens
    Rd_delta = 2*8.4*10^-3;
else
    Rd_delta = 0;
end
Rd = 8.4*10^-3 - Rd_delta;
Rr = 6.8*10^-3 + Rd_delta;

% create DynaSim specification structure
s=[];
s.populations(1).name='E';
s.populations(1).size=1;
s.populations(1).equations=eqns;
%s.populations(1).mechanism_list={'iGABABAustin','iNMDA','iNMDADestexhe1998Markov','Vcontroller'};
s.populations(1).mechanism_list={'iNMDA','iNMDADestexhe1998Markov','Vcontroller'};
s.populations(1).parameters={'stim',stim,'onset',onset,'offset',offset ...
    'PPstim',PPstim,'PPfreq',PPfreq,'PPonset',PPonset,'PPoffset',PPoffset, ...
    'Rd ', Rd, 'Rr', Rr, ...
    };
vary = {'E','PPstim',[.01 .1 1 10] };       % vary something randomly
vary = {};

data=SimulateModel(s,'vary',vary,'tspan',[0 800]);
% PlotData(data);

figure('Position',[440   143   579   655]); 
subplot(3,1,1:2);
for i = 1:length(data);
    hold on; plot_normalized_max(data(i).time,[data(i).E_iNMDA_s, data(i).E_iNMDADestexhe1998Markov_o])
end
legend('Destexhe: Simple 2-state model', 'Destexhe: 4-state Markov model')
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
