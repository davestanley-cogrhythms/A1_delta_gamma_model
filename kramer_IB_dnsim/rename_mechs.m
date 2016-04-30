

%% Rename all mechanisms to remove underscores

temp = dir('*.txt');
allmechs = {temp.name};

for i = 1:length(allmechs)
    currname = allmechs{i};
    outname = strrep(currname,'_','');
    
    mycommand = ['git mv ' currname ' ' outname];
    
    fprintf([ mycommand ' \n']);
    system(mycommand);
end
