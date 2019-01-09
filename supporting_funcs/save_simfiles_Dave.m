
function [outpath] = save_simfiles_Dave(sp,repo_studyname,spec_all,do_commit,mycomment)
    %% Testing code
    if 0
        %% Only run this if running in cell mode
        repo_studyname = '198q_reduced_simMode20';
        handles_arr = 1:9;
        do_commit = 1;
        mycomment = [''];
    end
    %% Set up
    
    % Make sure in appropriate working directory
    [a,b] = fileparts(pwd); if ~strcmp(b,'kramer_IB'); error('Must be in kramer_IB working directory to run.'); end
    
    
    study_dir = get_studydir(sp,repo_studyname);
        
    supersize_me = 0;
    
    % Outpath in model-dnsim-kramer_IB_Figs2 folder for saving data
    [outpath,foldername] = get_outpath(sp,repo_studyname);
    
    if ~exist(outpath,'dir')
        % If basepath doesn't exist.... create it and copy over simulation
        % files
        mkdir(outpath);
        
        % Save specs
        if exist('spec_all','var')
            save_specs(spec_all,outpath);
        end
        
        % Save m files
        save_mfiles(outpath);
        
        % Write commit message to a text file
        fileID = fopen(fullfile(outpath,'readme.txt'),'w');
        fprintf(fileID,[repo_studyname ' ' mycomment]);
        fclose(fileID);
    else
        mycomment = ['Update SM - Saving figures for ' foldername];
    end
    
    if do_commit
        %% Commit
        include_figures = false; 
        run_commit(foldername,mycomment,include_figures);
    end
    
    
    

end