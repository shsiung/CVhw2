function [im3] = generatePanorama(im1, im2)
% input
% img1 and img2 - two images to stitch
% output
% im3 a panorama view of img1 and img2

% img1 = imread('../data/incline_L.png');
% img2 = imread('../data/incline_R.png');

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);
[matches] = briefMatch(desc1, desc2, 0.8);
H2to1 = ransacH(matches, locs1, locs2);
im3 = imageStitching_noClip(im1, im2, H2to1);



