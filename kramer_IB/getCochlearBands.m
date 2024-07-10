function cochlearBands = getCochlearBands(no_bands)

if nargin == 0, no_bands = []; end
if isempty(no_bands), no_bands = length(-30:97); end

CF = 440 * 2 .^ ((-30:97)/24 - 1);

total_channels = length(CF);

channels_averaged = floor(total_channels/no_bands);

for b = 1:no_bands
    
    cochlearBands(b, :) = CF([(b - 1)*channels_averaged + 1, b*channels_averaged]);
    
end