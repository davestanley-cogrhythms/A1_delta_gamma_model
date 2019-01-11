function [outpath] = save_allfigs_Dave(sp,repo_studyname,spec_all,do_commit,mycomment,handles_arr)
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
        
    supersize_me = 1;

    
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
    
    % Save open figures
    if ~isempty(handles_arr)
        for i=handles_arr
            if supersize_me
                axp = get(i,'Position');
                set(i,'Visible','off');
                factorx = 2;
                factory = 1.33;
                set(i,'Position',[axp(1), axp(2), axp(3)*factorx, axp(4)*factory]);
            end
            set(i,'PaperPositionMode','auto');
            savenames{i} = ['fig' num2str(i)];
            %print(gcf,'-dpng','-r100',fullfile(outpath,savenames{i}));
            tic; print(i,'-dpng','-r75',fullfile(outpath,savenames{i}));toc
            %tic; screencapture(gcf,[],fullfile(basepath,sp,[savenames{ina} '.png']));toc
            %print(gcf,'-dpdf',fullfile(outpath,savenames{i}))
            %print(gcf,'-dpng',fullfile(outpath,savenames{i}))
        end
        close all
    end
    
    % Save study dir stuff
    if ~isempty(study_dir)
        % Copy study info file
        if exist(fullfile(study_dir,'studyinfo.mat'),'file')
            fprintf(['Copying ' fullfile(study_dir,'studyinfo.mat') ' to ' outpath '\n']);
            [~, message] = copyfile(fullfile(study_dir,'studyinfo.mat'),outpath);
            fprintf(['Copymessage: ' message '\n']);
        end

        % Copy raw plots if not empty
        if exist(fullfile(study_dir,'plots'),'dir')
            try       % % % % % Delete this later once know code works % % % % % 
                plots_folder = fullfile(study_dir,'plots');
                D = dir(plots_folder);
                plots_thresh = 50;
                if length(D) < plots_thresh
                    fprintf(['Copying ' fullfile(study_dir,'plots') ' to ' outpath '\n']);
                    [~, message] = copyfile(plots_folder,outpath);
                    fprintf(['Copymessage: ' message '\n']);
                else
                    fprintf(['Skipping saving plots folder due to number of files in ' plots_folder ' being ' num2str(length(D)) ', which is over threshold of ' num2str(plots_thresh) '\n']);
                end
            catch
                warning('Error, backing up plots folder failed. Carrying on.');
            end
            
        end

        % Copy saved composite plots if not empty
        if exist(fullfile(study_dir,'Figs_Composite'),'dir')
            fprintf(['Copying ' fullfile(study_dir,'Figs_Composite') ' to ' outpath '\n']);
            [~, message] = copyfile(fullfile(study_dir,'Figs_Composite'),outpath);
            fprintf(['Copymessage: ' message '\n']);
        end
    end
    
    % Play Hallelujah
    if ismac
%         load handel.mat;
%         sound(y, 1*Fs);
    end
    
    if do_commit
        %% Commit
        include_figures = do_commit == 2;       % Only save figures if do_commit is set to 2
        run_commit(foldername,mycomment,include_figures);
    end
    
    

end