function [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)
%% This function takes in an image and Gaussian filters parameters
%  and returns the points of local extremum in DoG pyramid and a Gaussian Pyramid of the 
%  input image
%
% inputs
% im - a grayscale image with range 0 to 1
% sigma0 - the standard deviation of the blur at level 0
% k - the multiplicative factor of sigma at each level, where sigma=sigma_0 k^l
% levels - the levels of the pyramid where the blur at each level is
% th_contrast - remove any point that is a local extremum but does not have a DoG response magnitude above this threshold
% th_r - remove any edge-like points that have too large a principal curvature ratio
%
% outputs
% GaussianPyramid - A matrix of grayscale images of size (size(im),numel(levels))
% locs - N x 3 matrix where the DoG pyramid achieves a local extrema in both scale and space, and also satisfies the two thresholds.

GaussianPyramid = createGaussianPyramid(im,sigma0,k,levels);
[dogp, dogl] = createDoGPyramid(GaussianPyramid,levels);
PC = computePrincipalCurvature(dogp);
locsDoG = getLocalExtrema(dogp,dogl,PC,th_contrast,th_r);

