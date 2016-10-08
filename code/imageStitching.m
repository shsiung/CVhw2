function [panoImg] = imageStitching(img1, img2, H2to1)
%
% input
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
%
% output
% Blends img1 and warped img2 and outputs the panorama image

img2_warp = warpH(img2, H2to1, [size(img1,1)*2, size(img1,2)*2]);

% Find the last row  (y-pixels) that is nonzero (for resizing the final image)
idx = cumsum(ones(size(img2_warp)),1);
idx(~img2_warp) = 0;
im_ylim = max(max(idx));
% Find the last column (x-pixels) that is nonzero (for resizing the final image)
idy = cumsum(ones(size(img2_warp)),2);
idy(~img2_warp) = 0;
im_xlim = max(max(idy));

% Resize the final image to eliminate as much black region as possible
img2_warp = img2_warp(1:im_ylim(:,:,1),1:im_xlim(:,:,1),:);

% Overlay img1 to the final image
panoImg = img2_warp;
panoImg(1:size(img1,1),1:size(img1,2),:)= img1;
%% For plotting purposes
figure(1)
imshow(img2_warp)
figure(2)
imshow(panoImg)
