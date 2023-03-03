function closestIndices = findClosest(inputVec, findThese)
% function closestIndices = findClosest(inputVec, findThese)
%
% This function takes an input vector and looks for the value that's
% closest to each element in findThese.
%
% Luke Sjulson, 2014-09-16

% % for testing
% inputVec = rand(10,1);
% findThese = [0.3 0.5 0.1];

closestIndices = zeros(size(findThese));

for idx = 1:length(findThese)
    tmp = abs(inputVec - findThese(idx));
    [~, closestIndices(idx)] = min(tmp);
    
end