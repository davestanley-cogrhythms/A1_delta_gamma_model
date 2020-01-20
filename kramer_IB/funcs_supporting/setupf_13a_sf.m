


function [s,f] = setupf_13a_sf(f,maxNcores,namesuffix,include_tFS5_global,mytspan,mysave_combined_figures,repo_savename,inter_train_interval,PPmaskdurations);
        
    % For paper - display freqs for figure annotations
    % - Given PPmaskdurations = 100
    % - Given inter_train_interval sweep
    % (For comparison to Lakatos figure)
    disp(1000 ./ (100 + inter_train_interval))

    % For paper annotations - display freqs for figure annotations
    % - Given inter_train_interval = 300
    % - Given PPmaskdurations sweep
    % (For comparison to inverse PAC figure)
    disp(1000 ./ (PPmaskdurations + 300))

    % Make into meshgrid and then two giant Nx1 array
    [PPmaskdurations, inter_train_interval] = meshgrid(PPmaskdurations, inter_train_interval);
    PPmaskdurations = PPmaskdurations(:)';
    inter_train_interval = inter_train_interval(:)';
    PPmaskfreqs0 = 1000 ./ [PPmaskdurations + inter_train_interval];

    % Do rounding, to produce shorter strings (annoying bug in MDD - when merged varied strings get too long, they start to overlap and cause errors)
    PPmaskfreqs = round(PPmaskfreqs0,2);

    % Setup
    clear s
    s{f} = struct;
    s{f}.save_figures = 1; s{f}.save_combined_figures = mysave_combined_figures; s{f}.save_shuffle_figures = 1; s{f}.plot_on = 0; s{f}.plot_on2 = 0; s{f}.do_visible = 'off'; s{f}.save_simfiles_to_repo_presim = true; s{f}.save_everything_to_repo_postsim = true; s{f}.do_commit = 0;
    s{f}.repo_studyname = [repo_savename  num2str(f) '' namesuffix];
    s{f}.sim_mode = 1;
    s{f}.pulse_mode = 5;
    s{f}.vary = { '(RS,IB,dFS5)','(PPmaskfreq,PPmaskduration)',[PPmaskfreqs; PPmaskdurations];...
        };
    s{f}.kerneltype_Poiss_IB = 4;
    s{f}.maxNcores = maxNcores; if maxNcores > 1; s{f}.parallel_flag = 1; else; s{f}.parallel_flag = 0; end
    s{f}.tspan = mytspan;
    s{f}.PPonset = 0;
    s{f}.PPoffset = Inf;
    s{f}.random_seed = 'shuffle';
    s{f}.include_tFS5 = include_tFS5_global;

    % Downsample factor
%         s{f}.dsfact = 100;

    % Reduce number of RS cells
    s{f}.Nrs = 20;

    % Save info used to generate vary
    s{f}.PPmaskdurations = PPmaskdurations;
    s{f}.inter_train_interval = inter_train_interval;
    s{f}.PPmaskfreqs0 = PPmaskfreqs0;
    s{f}.PPmaskfreqs = PPmaskfreqs;


end