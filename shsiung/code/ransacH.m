function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% input
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
% output
% bestH - homography model with the most inliers found during RANSAC

if ~exist('nIter', 'var') || isempty(nIter)
    nIter = 5000;
end

if ~exist('tol', 'var') || isempty(tol)
    tol = 5;
end

numMatches = size(matches,1);
p1Match = locs1(matches(:,1),1:2)';
p2Match = locs2(matches(:,2),1:2)';
pp_all = [p2Match; ones(1,size(p2Match,2))];
bestH = zeros(3,3);

for i = 1:nIter
    % Randomly find 4 samples to compute H
    rand_sample = int32(random('Uniform',1,numMatches,4,1));
    p1_samp = locs1(matches(rand_sample,1),1:2);
    p2_samp = locs2(matches(rand_sample,2),1:2);

    H_samp = computeH(p1_samp',p2_samp');
    
    %Convert all matched points in P2 and compare them to P1 using H_sample calculated.
    p2_allH = H_samp*pp_all;
    p2_allH(1,:) = p2_allH(1,:)./p2_allH(3,:);
    p2_allH(2,:) = p2_allH(2,:)./p2_allH(3,:);
    
    error = (p1Match-p2_allH(1:2,:)).^2;
    errorSum = sum(error,1);
    errorNum = numel(find(errorSum>tol==1));

    if i == 1
        minError = errorNum;
        bestH = H_samp;
    elseif(errorNum < minError)
        bestH = H_samp;
        minError = errorNum;
    end


end