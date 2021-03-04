function [dist, G] = VP_distance(q, S1, S2, norm)
% Computes distance between two sets of spike times, S1 and S2, as in
% Victor & Purpura 1997, using temporal resolution q.

if nargin < 4, norm = []; end
if isempty(norm), norm = 0; end

S1length = length(S1);

S2length = length(S2);

[G, M] = deal(zeros(S1length + 1, S2length + 1));

G(1, :) = 0:S2length;
G(:, 1) = 0:S1length;

for i = 2:(S1length + 1)
    
    for j = 2:(S2length + 1)
        
        insertS1i = G(i - 1, j) + 1;
        
        insertS2j = G(i, j - 1) + 1;
        
        moveS1itoS2j = G(i - 1, j - 1) + abs(S1(i - 1) - S2(j - 1))/q;
        
        [G(i, j), index] = min([insertS1i, insertS2j, moveS1itoS2j]);
        
        switch index
            
            case 1
                
                M(i, j) = M(i - 1, j);
                
            case 2
                
                M(i, j) = M(i, j - 1);
                
            case 3
                
                M(i, j) = M(i - 1, j - 1) + 1;
            
        end
        
    end
    
end

switch norm
    
    case 0

        dist = G(end, end);
        
    case 1
        
        dist = G(end, end)/S1length;
        
    case 2
        
        dist = G(end, end)/S2length;
        
    case 3
        
        dist = G(end, end)/max(1, M(end, end));
        
    case 4
        
        dist = G(end, end)/(S1length + S2length);
        
    case 5
        
        dist = G(end, end)/min(S1length, S2length);

end