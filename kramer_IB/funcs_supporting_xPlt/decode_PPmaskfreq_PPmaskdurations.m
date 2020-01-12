

function data = decode_PPmaskfreq_PPmaskdurations (data0,varied_new)
% Converts a 1D DynaSim structure that is actually varied across 2
% dimensions back into its original dimensions. This undoes the linear
% indepence operations of dsMDDds

% data0 - DynaSim structure
% varied_new - Cell array of strings carrying names of new data.varied

% Example
% Converts '5_5_5_50_50_50' to indiviudal varied dimensions (e.g.,
% dimension1=5, dimension2=50

%% Run the conversion

data = data0;
for i = 1:length(data)
    % Pull out values of varied parameter
    varied = data(i).varied;
    vals = data(i).(varied{1});

    % Add some underscores to start and end; will be used below
    vals = ['_' vals '_'];

    % Find all underscores, and use them to denote separations between
    % values
    inds = strfind(vals,'_');

    % Extract each numeric that is bracketed by underscores
    N=length(inds)-1;
    vals_decode = zeros(1,N);
    for j = 1:N
        vals_decode(j) = str2double(vals(inds(j)+1:inds(j+1)-1));
    end
    
    % Remove the last entry from vals_decode because this one might be
    % truncated
    vals_decode = vals_decode(1:end-1);

    % This will result in a pair, 5 an d50
    vals_unique = unique(vals_decode,'stable');

    % Add new varied labels to data structure
    data(i).varied = varied_new;
    for j = 1:length(vals_unique)
        data(i).(varied_new{j}) = vals_unique(j);
        data(i).(varied_new{j}) = vals_unique(j);
    end
end

%% Remove original varied field
data = rmfield(data,varied);
end
