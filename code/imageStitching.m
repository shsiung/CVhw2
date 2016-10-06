function [panoImg] = imageStitching(img1, img2, H2to1)
%
% input
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
%
% output
% Blends img1 and warped img2 and outputs the panorama image
ratio = 0.5;
[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);
[matches] = briefMatch(desc1, desc2, ratio);

p1 = zeros(length(matches),3);
p2 = zeros(length(matches),3);

for i = 1:length(matches)
    p1(i,:) = locs1(matches(i,1),:);
    p2(i,:) = locs2(matches(i,2),:); 
end
H2to1 = computeH(p1',p2');
img2_warp = warpH(img2, H2to1, [size(img1,1) size(img1,2)]);

imshow(img2_warp)
panoimg = 1;