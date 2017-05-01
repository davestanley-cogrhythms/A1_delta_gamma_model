function [data, name] = Gutfreund_KCa(I_const, tspan, save_flag, varargin)

% Set tau_fast = 7, look at I_app = 2.5, ..., 3.5 to see transition from
% subthreshold oscillations to intermittent spiking to continuous spiking.

vary_label = ''; vary_cell = cell(length(varargin)/2, 3);

if ~isempty(varargin)
    
    for a = 1:(length(varargin)/2)
        
        if isscalar(varargin{2*a})
            
            vary_label = [vary_label, sprintf('_%s_%g', varargin{2*a - 1}, varargin{2*a})];
            
        else
        
            vary_label = [vary_label, sprintf('_%s_%gto%g', varargin{2*a - 1}, varargin{2*a}(1), varargin{2*a}(end))];
        
        end
        
        vary_cell(a, :) = {'pop1', varargin{2*a - 1}, varargin{2*a}};
        
    end
    
end

name = ['gutfreund_KCa', vary_label];

if size(vary_cell, 1) > 2

    no_figures = prod(cellfun(@length, vary_cell(3:end, 3)));

else
    
    no_figures = 1;
    
end

I_app = 0;

model_eqns = ['dv/dt=(I_const+I(t)+@current)/Cm; Cm=.25; v(0)=-65;',...
    '{iNaP,iKs,iKDRG,iNaG,gleak,CaDynT,iCaT,iKCaT,iPeriodicPulsesBen,iPeriodicSpikes};',...
    sprintf('gKs=0.084; gNaP_denom=3.36; gNaP=gKs/gNaP_denom; I_const=%g;', I_const),...    %  halfKs=-60; halfNaP=-60; gKs=0.084; gNaP=0.025; gl=0.025; gCa=0.02; %%% 
    'tau_fast=5; tau_h=tau_fast; tau_m=tau_fast;',... 
    'slow_offset=0; slow_offset_correction=0; Ks_offset=slow_offset-slow_offset_correction; NaP_offset=slow_offset;',...
    'fast_offset=0; Koffset=fast_offset; Noffset=fast_offset;',...     % 'fast_denom=1; gKDR=5/fast_denom; gNa=12.5/fast_denom;',...
    'I(t)=I_app*((t/ton)*(t<=ton)+(ton<t&t<toff)+rand*.1);',... % *((1-pulse/2)+pulse*(mod(t,750)<250&t>2*ton));',...
    sprintf('ton=500; toff=%g; I_app=%g;', tspan, I_app),... %  (ton<t&t<toff) %%% 'PPstim = 0; PPfreq = 1.5; PPwidth = floor((1000/PPfreq)/4); PPshift = 0; ap_pulse_num = 0; kernel_type = 7;',... % in ms
    'monitor functions'];

if ~isempty(varargin)
    
    % if strcmp(version('-release'), '2012a')
    
        data = dsSimulate(model_eqns, 'tspan', [0 tspan], 'vary', vary_cell, 'parallel_flag', 1, 'downsample_factor', 25, 'verbose_flag', 0);
    
    % else
    % 
    %     data = dsSimulate(model_eqns, 'tspan', [0 tspan], 'vary', vary_cell, 'compile_flag', 1);
    % 
    % end
    
else
    
    % if strcmp(version('-release'), '2012a')
    
        data = dsSimulate(model_eqns, 'tspan', [0 tspan], 'parallel_flag', 1, 'downsample_factor', 25, 'verbose_flag', 0);
    
    % else
    % 
    %     data=dsSimulate(model_eqns, 'tspan', [0 tspan], 'compile_flag', 1);
    % 
    % end
     
end
    
try 
    
    PlotData(data)

    if no_figures > 1
        
        for f = 1:no_figures
            
            save_as_pdf(f, ['Figures/', name, sprintf('_%g', f)], '-v7.3')
            
        end
        
    else
    
        save_as_pdf(gcf, ['Figures/', name], '-v7.3')

    end
    
catch error
    
    display('PlotData failed:')
    
    display(error)

end

if save_flag
    
    save([name, '.mat'], 'data', '-v7.3')
    
end