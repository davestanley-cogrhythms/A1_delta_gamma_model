104b_newrange Repeated 2D parameter new ranges.

Fig1 - Range1
Fig2 - Range2

Range 2:
 case 13         % LTS Cells
        vary = { 'RS->LTS','g_SYN',[.1:.025:.2]/Nrs;...
                 'FS->LTS','g_SYN',[.1:.1:.6]/Nfs;...
                 %'LTS','stim',[-.5:.1:.5]; ...
                 
                 }; 

>> [.1:.025:.2]
ans =
    0.1000    0.1250    0.1500    0.1750    0.2000
>> [.1:.1:.6]
ans =
    0.1000    0.2000    0.3000    0.4000    0.5000    0.6000
>> 
