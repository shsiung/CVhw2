
function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% input
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
% output
% bestH - homography model with the most inliers found during RANSAC

numMatches = size(matches,1);
%minError =  4.2950e+09;
bestH = eye(3);
p1_all = locs1(matches(:,1),1:2)';
p2_all = locs2(matches(:,2),1:2)';
pp_all = [p2_all; ones(1,size(p2_all,2))];
    
for i = 1:nIter
    sample = int32(random('Uniform',1,numMatches,4,1));
    p1 = locs1(matches(sample,1),1:2);
    p2 = locs2(matches(sample,2),1:2);

    p1 = p1';
    p2 = p2';

    H = computeH(p1,p2);
    
    p2_allH = H*pp_all;
    p2_allH(1,:) = p2_allH(1,:)./p2_allH(3,:);
    p2_allH(2,:) = p2_allH(2,:)./p2_allH(3,:);
    
    error = (p1_all-p2_allH(1:2,:)).^2;
    errorSum = sum(error,1);
    
    errorNum = numel(find(errorSum>tol==1));

    if i == 1
        minError = errorNum;
        bestH = H;
    elseif(errorNum < minError)
        bestH = H;
        minError = errorNum;
    end

end