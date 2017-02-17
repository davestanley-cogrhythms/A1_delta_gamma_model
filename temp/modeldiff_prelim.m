

%% Model compare

temp1=spec1.populations(2).parameters
temp2=spec2.populations(2).parameters
temp3 = cat(2,temp1',temp2')
temp3
clc
temp4 = temp3(2:2:end,:)
temp5 = cell2mat(temp4)
temp6 = diff(temp5,[],2)
whos temp
whos temp*
temp3
temp6
temp7 = num2cell(temp6)
temp3
temp8 = temp3
temp8 (2:2:end,3) = temp7

