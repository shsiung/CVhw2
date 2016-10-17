function [panoImg] = imageStitching_noClip(img1, img2, H2to1)
% input
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
%
% output
% Blends img1 and warped img2 and outputs the panorama image
%
% To prevent clipping at the edges, we instead need to warp both image 1 and image 2 into a common third reference frame 
% in which we can display both images without any clipping.

% Using transformed corners to figure out how much to translate
img2_corners = [1,1,size(img2,2),size(img2,2);1,size(img2,1),1,size(img2,1);ones(1,4)];
img2_corners_warp = H2to1*img2_corners;
img2_corners_warp(1,:) = img2_corners_warp(1,:)./img2_corners_warp(3,:);
img2_corners_warp(2,:) = img2_corners_warp(2,:)./img2_corners_warp(3,:);

% Set up translation matrix
M = eye(3);
M(2,3) = -floor(min(img2_corners_warp(2,:)));

% Warping both img1 and img2 to eliminate image clipping
img1_warp = warpH(img1, M, [size(img1,1)*2, size(img1,2)*2]);
img2_warp = warpH(img2, M*H2to1, [size(img1,1)*2, size(img1,2)*2]);

% Find the last row  (y-pixels) that is nonzero (for resizing the final image)
idx = cumsum(ones(size(img2_warp)),1);
idx(~img2_warp) = 0;
im_ylim = max(max(idx));
% Find the last column (x-pixels) that is nonzero (for resizing the final image)
idy = cumsum(ones(size(img2_warp)),2);
idy(~img2_warp) = 0;
im_xlim = max(max(idy));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

% Image blending
mask1 = zeros(size(img1,1), size(img1,2));
mask1(1,:) = 1; mask1(end,:) = 1; mask1(:,1) = 1; mask1(:,end) = 1;
mask1 = bwdist(mask1, 'city');
mask1 = mask1/max(mask1(:));

mask2 = zeros(size(img2,1), size(img2,2));
mask2(1,:) = 1; mask2(end,:) = 1; mask2(:,1) = 1; mask2(:,end) = 1;
mask2 = bwdist(mask2, 'city');
mask2 = mask2/max(mask2(:));

mask1_warp = warpH(mask1, M, [size(img1,1)*2, size(img1,2)*2]);
mask2_warp = warpH(mask2, M*H2to1, [size(img1,1)*2, size(img1,2)*2]);

img1_warp = double(img1_warp);
img2_warp = double(img2_warp);
panoImg = img1_warp.*repmat(mask1_warp,[1,1,3]) + img2_warp.*repmat(mask2_warp,[1,1,3]);
panoImg = uint8(panoImg./repmat((mask1_warp+mask2_warp),[1,1,3]));

% Resize the final image to eliminate as much black region as possible
panoImg = panoImg(1:im_ylim(:,:,1),1:im_xlim(:,:,1),:);

%% For plotting purposes
% figure(2)
% imshow(panoImg)
% imwrite(panoImg,'5_2_pan.jpg');
