function permDistr = permutation(mat2perm,numPerm)
% ----------------------------------------------------------------------
% [permDistr] = permutation(mat2perm,numPerm)
% ----------------------------------------------------------------------
% Goal of the function :
% Randomly permuting each matched pair separately.
% ----------------------------------------------------------------------
% Input(s) :
% mat2perm = matrix of subjects results
% numPerm = number of permutations
% ----------------------------------------------------------------------
% Output(s):
% permDistr = Distribution of means of permutations 
%             (estimation of distribution with zero effect)
% ----------------------------------------------------------------------
% Data saved :
% -
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last update : 01 / 05 / 2016
% Project : SacPointAtt
% Version : 1.0
% ----------------------------------------------------------------------

if nargin<2
    numPerm = 100;
end

permDistr = nan(numPerm,1);

for i = 1:numPerm
    permSample = mat2perm;
    % select random lines to flip (switch conditions)
    flip_idx = find((randi(2,1,size(permSample,1))-1) == 1); 
    permSample(flip_idx,:) = fliplr(permSample(flip_idx,:));
    
    mean_Sample = mean(permSample);
    permDistr(i,1) = mean_Sample(1) - mean_Sample(2);
end