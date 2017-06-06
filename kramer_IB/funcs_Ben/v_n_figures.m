function v_n_figures(data, pop_name, no_rows, no_cols)

% no_rows = 11;
% 
% no_cols = 3;

figure,

for s = 1:no_rows*no_cols

    subplot(no_rows, no_cols, s) 
    
    plot(data(s).([pop_name, '_V']), data(s).([pop_name, '_iKs_n']))
    
    box off, axis tight
    
    % ylim([0 .7])
    % xlim([-85 0])

    if mod(s, no_cols) == 1 || no_cols == 1
        
        ylabel({['I_{app} = ', num2str(data(s).([pop_name, '_I_app']), '%.3g')];'iKs Gating Var.'},'FontSize',14) 
    
    end
    
    if ceil(s/no_cols) == no_rows || no_rows == 1
    
        xlabel('Voltage','FontSize',14), 
    
    end, 
    
    % if ceil(s/no_cols) == 1
    % 
    %     title(['\tau_{K_s} = ', num2str(data(s).([pop_name, '_tauKs']), '%.3g')],'FontSize',16)
    % 
    % end
    
end