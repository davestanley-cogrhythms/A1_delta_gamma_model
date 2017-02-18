104a_2D_vary_mCurrent_and_seed Tried various connectivity values.

Fig1 - Default sweep
Fig2 - Sweep with M current blocked (set gM=0 and set Jlts to 1; previously was 0.5);
Fig3 - M current gM=2
Fig4 - M current gM=1

Folders contain different randomseed values

     case 13         % LTS Cells
        vary = { 'RS->LTS','g_SYN',[.15:.05:.35]/Nrs;...
                 'FS->LTS','g_SYN',[.3:.1:1]/Nfs;...





>> [.15:.05:.35]
ans =
    0.1500    0.2000    0.2500    0.3000    0.3500


>> [.3:.1:1]
ans =
    0.3000    0.4000    0.5000    0.6000    0.7000    0.8000    0.9000    1.0000


