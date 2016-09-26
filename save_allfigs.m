

function save_allfigs(currfname,currfigname)
    %% save_allfigs
    % % For loop for saving figs
%     if ~exist('currfname'); currfname = 'kramer_IB'; end
%     if ~exist('currfigname'); currfigname = '3_single_comp_only_Mcurr'; end
    %clear all       % Clear memory for large data sets before saving figs.
    currfname = 'kr'; 
    currfigname = '75b_increased_RS_Eleak_STD';
    savenames={'fig1','fig2','fig3','fig4','fig5','fig6','fig7','fig8','fig9','fig10','fig11','fig12','fig13','fig14','fig15','fig16','fig17','fig18','fig19','fig20','fig21','fig22','fig23','fig24'};
    mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/','');
    c=clock;
    sp = ['d' mydate '_t' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];
    sp = [sp '__' currfname '_' currfigname];
    basepath = '.';
    % basepath = '~/figs_tosave';
    
    mkdir(fullfile(basepath,sp));
    multiplot_on = 0;
    for i=[11:17]
        figure(i); %ylim([0 0.175])
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
        set(gcf,'PaperPositionMode','auto');
        print(gcf,'-dpng','-r100',fullfile(basepath,sp,savenames{i}))
        %print(gcf,'-dpdf',fullfile(basepath,sp,savenames{i}))
%         print(gcf,'-dpng',fullfile(basepath,sp,savenames{i}))
    end
    
    mycomment = ['RS and FS cells. RS Eleak STD now 20. Sweep through iApp.'];

    % Write to a text file
    fileID = fopen(fullfile(basepath,sp,'readme.txt'),'w');
    fprintf(fileID,[currfigname ' ' mycomment]);
    fclose(fileID);
    
    % Commit
    currd = pwd;
    cd ..
    system('git add *');
    system(['git commit -am "' currfigname ' ' mycomment '"']);
    cd(currd);


end