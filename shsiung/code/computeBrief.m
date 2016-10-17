function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareA, compareB)
%%Compute Brief feature
% input
% im - a grayscale image with values from 0 to 1
% locsDoG - locsDoG are the keypoint locations returned by the DoG detector
% levels - Gaussian scale levels that were given in Section1
% compareA and compareB - linear indices into the patchWidth x patchWidth image patch and are each nbits x 1 vectors
%
% output
% locs - an m x 3 vector, where the first two columns are the image coordinates of keypoints and the third column is 
%		 the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. m is the number of valid descriptors in the image and will vary


% PatchWidth
pw = 9;
nbits = 256;
offset = floor(pw/2);
[iX,jX]=ind2sub([pw pw],compareA);
[iY,jY]=ind2sub([pw pw],compareB);

% Keypoint locations with valid descriptors (valid patch)
locs = locsDoG;
locs = locs(locs(:,1)>offset,:);
locs = locs(locs(:,1)<size(im,2)-offset,:);
locs = locs(locs(:,2)>offset,:);
locs = locs(locs(:,2)<size(im,1)-offset,:);
desc = zeros(size(locs,1),nbits);

% Make the keypoints center
iX = iX - offset - 1;
jX = jX - offset - 1;
iY = iY - offset - 1;
jY = jY - offset - 1;

% Loop through m (valid descriptors)
for i = 1 : size(locs,1)
    % Loop through n (BRIEF tests)
    curr_level = find(levels == locs(i,3));
    for j = 1 : nbits
        desc(i,j) = im(locs(i,2)+iX(j),locs(i,1)+jX(j)) < ...
                    im(locs(i,2)+iY(j),locs(i,1)+jY(j));
    end
end