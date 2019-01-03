
function [outpath] = save_allfigs_Dave(study_dir,spec_all,handles_arr,do_commit,currfigname)
    %% save_allfigs
    % % For loop for saving figs
%     if ~exist('currfname'); currfname = 'kramer_IB'; end
%     if ~exist('currfigname'); currfigname = '3_single_comp_only_Mcurr'; end
    %clear all       % Clear memory for large data sets before saving figs.
    
    %% Control inputs
    if nargin < 1; error('study_dir must be specified'); end
    if nargin < 2; spec_all = []; end
    if nargin < 3; handles_arr = []; end
    if nargin < 4; do_commit = false; end
    if nargin < 5; currfigname = 'unnamed'; end


    %% Set up

    [a,b] = fileparts(pwd); if ~strcmp(b,'kramer_IB'); error('Must be in kramer_IB working directory to run.'); end
        
    supersize_me = 0;
    
    if strcmp(calledby(0), 'root')      % Commands inside here will only execute when running this code in cell mode (e.g. not as a function)
        handles_arr = 1:6;
        do_commit = 1;
        currfigname = '195f_redoprev_randseed8';
        if ~exist('study_dir','var'); study_dir = []; end
    end
    
    currfname = 'kr'; 
    
    savenames={'fig1','fig2','fig3','fig4','fig5','fig6','fig7','fig8','fig9','fig10','fig11','fig12','fig13','fig14','fig15','fig16','fig17','fig18','fig19','fig20','fig21','fig22','fig23','fig24','fig25','fig26','fig27','fig28','fig29','fig30'};
    mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/','');
    c=clock;
    sp = ['d' mydate '_t' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];
    sp = [sp '__' currfname '_' currfigname];
    basepath = fullfile('..','model-dnsim-kramer_IB_Figs2');
    % basepath = '~/figs_tosave';
    
    mkdir(fullfile(basepath,sp));
    
    % Save plots
    if ~isempty(handles_arr)
        for i=handles_arr
            if supersize_me
                axp = get(i,'Position');
                set(i,'Visible','off');
                factor = 3;
                set(i,'Position',[axp(1), axp(2), axp(3)*factor, axp(4)*factor]);
            end
            set(i,'PaperPositionMode','auto');
            %print(gcf,'-dpng','-r100',fullfile(basepath,sp,savenames{i}));
            tic; print(i,'-dpng','-r75',fullfile(basepath,sp,savenames{i}));toc
            %tic; screencapture(gcf,[],fullfile(basepath,sp,[savenames{ina} '.png']));toc
            %print(gcf,'-dpdf',fullfile(basepath,sp,savenames{i}))
    %         print(gcf,'-dpng',fullfile(basepath,sp,savenames{i}))
        end
    end
    
    % Save spec file
    if exist('spec_all','var')
        if ~isempty(spec_all)
            save(fullfile(basepath,sp,'spec_all.mat'),'spec_all');
        end
    end
    
    % Save .m file
    zip(fullfile(basepath,sp,'kramer_IB.zip'),{'kramer_IB.m','include_kramer_IB_populations.m','include_kramer_IB_synapses.m','include_kramer_IB_simulate.m','include_kramer_IB_plotting.m', ...
        'kramer_IB_deltapaper_scripts2.m','kramer_IB_deltapaper_scripts1.m','kramer_IB_deltapaper_tune1.m','kramer_IB_clustersub.m'});
    
    if ~isempty(study_dir)
        % Copy study info file
        if exist(fullfile(study_dir,'studyinfo.mat'),'file')
            fprintf(['Copying ' fullfile(study_dir,'studyinfo.mat') ' to ' fullfile(basepath,sp) '\n']);
            [~, message] = copyfile(fullfile(study_dir,'studyinfo.mat'),fullfile(basepath,sp));
            fprintf(['Copymessage: ' message '\n']);
        end

        % Copy raw plots if not empty
        if exist(fullfile(study_dir,'plots'),'dir')
            try       % % % % % Delete this later once know code works % % % % % 
                plots_folder = fullfile(study_dir,'plots');
                D = dir(plots_folder);
                plots_thresh = 50;
                if length(D) < plots_thresh
                    fprintf(['Copying ' fullfile(study_dir,'plots') ' to ' fullfile(basepath,sp) '\n']);
                    [~, message] = copyfile(plots_folder,fullfile(basepath,sp));
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
            fprintf(['Copying ' fullfile(study_dir,'Figs_Composite') ' to ' fullfile(basepath,sp) '\n']);
            [~, message] = copyfile(fullfile(study_dir,'Figs_Composite'),fullfile(basepath,sp));
            fprintf(['Copymessage: ' message '\n']);
        end
    end
    
%     % Copy saved plots if not empty
%     if exist('save_path','var')
%         if exist(save_path,'dir')
%             movefile(save_path,fullfile(basepath,sp));
%         end
%     end
%     %
    mycomment = ['Re-do previous sim with known random seed (8), so can use it in future sims.'];
    
    % Write to a text file
    fileID = fopen(fullfile(basepath,sp,'readme.txt'),'w');
    fprintf(fileID,[currfigname ' ' mycomment]);
    fclose(fileID);
    
    outpath = fullfile(basepath,sp);
    
    % Play Hallelujah
    if ismac
%         load handel.mat;
%         sound(y, 1*Fs);
    end
    
    if do_commit
        %% Commit
        !rm ../save_allfigs_Dave.m~
        currd = pwd;
        cd ../model-dnsim-kramer_IB_Figs2
        system('git add *');
        system(['git commit -m "' currfigname ' ' mycomment '"']);
        %system('git push');
        cd ..
        system('git add *');
        system(['git commit -m "' currfigname ' ' mycomment '"']);
        cd(currd);
        
%         %% Push
        cd ../model-dnsim-kramer_IB_Figs2
        cd(currd);
    end
    
    

end