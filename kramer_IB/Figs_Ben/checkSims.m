function checkSims(folder, names)

thresholds = [0.333 0.4 0.45 0.5 0.55 0.6 0.667];

sum_windows = [25:5:45, 55:5:75];

for t = 1:length(thresholds)
    
    for n = 1:length(names)
        
        for s = 1:length(sum_windows)
            
            check = dir(sprintf('Figs_Ben/%s/%s_thresh_%.2g_sumwin_%d_vpnorm_3_vpdist.mat', folder, names{n}, thresholds(t), sum_windows(s)));
            
            if isempty(check)
                
                command = sprintf('qsub run_calcVPdist %s %s_sim_spec.mat %g %d', folder, names{n}, thresholds(t), sum_windows(s));
                
                fprintf([command, '\n'])
                
                system(command)
                
            end
            
        end
        
        check = dir(sprintf('Figs_Ben/%s/%s_thresh_%.2g_vpnorm_3_vpdist.mat', folder, names{n}, thresholds(t)));
        
        if isempty(check)
            
            command = sprintf('qsub run_calcVPdist %s %s_sim_spec.mat %g %d', folder, names{n}, thresholds(t), 50);
            
            fprintf([command, '\n'])
            
            system(command)
            
        end
        
    end
    
end