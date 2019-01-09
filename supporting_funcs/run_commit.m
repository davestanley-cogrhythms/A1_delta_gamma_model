function run_commit(foldername,mycomment,include_figures)

    if nargin < 3
        include_figures = false;
    end
    
    % Files to commit to repo
    if include_figures
        % Commit all files in repo dir
        files = {'*'};
    else
        % Commit files in repo dir produced prior to running dsSimulate
        % only
        files = {'kramer_IB.zip','readme.txt','*.mat'};
    end

    % Commit figures repo
    !rm ../save_allfigs_Dave.m~
    currd = pwd;
    cd ../model-dnsim-kramer_IB_Figs2
    %system('git add *');
    for f = files
        addmsg = ['git add ' fullfile(foldername,f{1})];
        %fprintf([addmsg '\n']);
        system(addmsg);
    end
    system(['git commit -m "' foldername ' ' mycomment '"']);
    
    % Commit main repo
    cd ..
    system('git add *');
    system(['git commit -m "' foldername ' ' mycomment '"']);
    cd(currd);
    

    % Push stuff
    cd ../model-dnsim-kramer_IB_Figs2
    %system('git push');
    cd ..
    %system('git push');
    cd(currd);
end