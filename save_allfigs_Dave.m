

function save_allfigs_Dave(handles_arr)
    %% save_allfigs
    % % For loop for saving figs
%     if ~exist('currfname'); currfname = 'kramer_IB'; end
%     if ~exist('currfigname'); currfigname = '3_single_comp_only_Mcurr'; end
    %clear all       % Clear memory for large data sets before saving figs.
    
%     if nargin < 1; handles_arr = [];
%     end


    [a,b] = fileparts(pwd); if ~strcmp(b,'kramer_IB'); error('Must be in kramer_IB working directory to run.'); end
    
    do_commit = 1;
    supersize_me = 0;
    handles_arr = [1:11];
    if isempty(handles_arr); handles_arr = 1:2; end
    currfname = 'kr'; 
    currfigname = '157a_A2Pc';
    savenames={'fig1','fig2','fig3','fig4','fig5','fig6','fig7','fig8','fig9','fig10','fig11','fig12','fig13','fig14','fig15','fig16','fig17','fig18','fig19','fig20','fig21','fig22','fig23','fig24','fig25','fig26','fig27','fig28','fig29','fig30'};
    mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/','');
    c=clock;
    sp = ['d' mydate '_t' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];
    sp = [sp '__' currfname '_' currfigname];
    basepath = fullfile('..','model-dnsim-kramer_IB_Figs');
    % basepath = '~/figs_tosave';
    
    mkdir(fullfile(basepath,sp));
    multiplot_on = 0;
    
    % Save plots
    for i=handles_arr
        %figure(i); %ylim([0 0.175])
        %title('');
        %ylabel('');
        %xlim([-1.5 2.2]);
        %ylabel('Avg z-score |\Delta FFC|')
%         set(gcf,'Position',[0.1076    0.4544    0.7243    0.3811]);
        
%         print(gcf,'-dpng','-r200',fullfile(basepath,sp,savenames{i}))
        

%         print(gcf,'-dpdf',fullfile(basepath,sp,savenames{i}))
        %close
        if ~multiplot_on
%             set(gcf,'Position',[0.1076    0.4544    0.7243    0.3811]);
%             set(gcf,'Position',[0.1071    0.2381    0.7250    0.5981]);         % Size for when 3 rows of subplots
%             set(gcf,'Position',[0.8257    0.1256    0.1743    0.7689]);         % Size to compare Carracedo
                                                                                % To get only 1 cell trace, run: data(1).model.specification.populations(1).size=1;
        end
        if supersize_me
            axp = get(i,'Position');
            set(i,'Visible','off');
            factor = 3;
            set(i,'Position',[axp(1), axp(2), axp(3)*factor, axp(4)*factor]);
        end
        set(i,'PaperPositionMode','auto');
        %print(gcf,'-dpng','-r100',fullfile(basepath,sp,savenames{i}));
        tic; print(i,'-dpng','-r75','-opengl',fullfile(basepath,sp,savenames{i}));toc
        %tic; screencapture(gcf,[],fullfile(basepath,sp,[savenames{ina} '.png']));toc
        %print(gcf,'-dpdf',fullfile(basepath,sp,savenames{i}))
%         print(gcf,'-dpng',fullfile(basepath,sp,savenames{i}))
    end
    
    % Save spec file
    save(fullfile(basepath,sp,'spec.mat'),'spec','pop_struct');
    
    % Save .m file
    zip(fullfile(basepath,sp,'kramer_IB.zip'),{'kramer_IB.m','include_kramer_IB_populations.m','include_kramer_IB_synapses.m'});
    
    % Copy study info file
    if exist(fullfile(study_dir,'studyinfo.mat'),'file')
        copyfile(fullfile(study_dir,'studyinfo.mat'),fullfile(basepath,sp));
    end
    
    % Copy raw plots if not empty
    if exist(fullfile(study_dir,'plots'),'dir')
        copyfile(fullfile(study_dir,'plots'),fullfile(basepath,sp,'plots'));
    end
    
    % Copy saved plots if not empty
    if exist('save_path','var')
        if exist(save_path,'dir')
            movefile(save_path,fullfile(basepath,sp));
        end
    end
    %
    mycomment = ['Ran amplitude to phase coupling. Figs 1-5 with no IC hyperpolarization. Figs 6-11 with IC hyperpolarization'];
    
    % Write to a text file
    fileID = fopen(fullfile(basepath,sp,'readme.txt'),'w');
    fprintf(fileID,[currfigname ' ' mycomment]);
    fclose(fileID);
    
    % Play Hallelujah
    load handel.mat;
    sound(y, 1*Fs);
    
    if do_commit
        %% Commit
        !rm ../save_allfigs_Dave.m~
        currd = pwd;
        cd ../model-dnsim-kramer_IB_Figs
        system('git add *');
        system(['git commit -m "' currfigname ' ' mycomment '"']);
        %system('git push');
        cd ..
        system('git add *');
        system(['git commit -m "' currfigname ' ' mycomment '"']);
        cd(currd);
        
%         %% Push
        cd ../model-dnsim-kramer_IB_Figs
        system('git push');
        cd(currd);
        system('git push');
    end
    
    

end