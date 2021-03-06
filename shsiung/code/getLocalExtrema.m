function locs = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature,th_contrast, th_r)
%%Detecting Extrema
% inputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a DoG response magnitude above this threshold
% th_r - remove any edge-like points that have too large a principal curvature ratio
% output
% locs - N x 3 matrix where the DoG pyramid achieves a local extrema in both scale and space, and also satisfies the two thresholds.

tempDoG = ones(size(DoGPyramid,1),size(DoGPyramid,2),length(DoGLevels)+2);
tempDoG(:,:,1) = DoGPyramid(:,:,1);
tempDoG(:,:,2:end-1) = DoGPyramid;
tempDoG(:,:,end) = DoGPyramid(:,:,end);
locs = nan*ones(size(DoGPyramid,1)*size(DoGPyramid,2)*length(DoGLevels),3);
% Find local extremums of each layer
for m = 1 : length(DoGLevels)
    layer_max = imregionalmax(DoGPyramid(:,:,m),8);
    layer_min = imregionalmin(DoGPyramid(:,:,m),8);
    % Find indexes of local extremums in the layer
    [imax,jmax]=ind2sub(size(layer_max), find(layer_max==1));
    [imin,jmin]=ind2sub(size(layer_min), find(layer_min==1));
    % Discard local extremums that don't pass the threshold values and 
    % compare it in scale
    for i = 1: length(imax)
       curr_max = DoGPyramid(imax(i),jmax(i),m);
       if (abs(curr_max) > th_contrast && ...
           abs(PrincipalCurvature(imax(i),jmax(i),m)) < th_r && ...
           curr_max >= tempDoG(imax(i),jmax(i),m + 2) && ...
           curr_max >= tempDoG(imax(i),jmax(i),m))
           locs(i+(m-1)*size(DoGPyramid,1)*size(DoGPyramid,2),:) = ...
                [jmax(i) imax(i) DoGLevels(m)];
       end
    end
    for i = 1: length(imin)
       curr_min = DoGPyramid(imin(i),jmin(i),m);
       if (abs(curr_min) > th_contrast && ...
           abs(PrincipalCurvature(imin(i),jmin(i),m)) < th_r && ...
           curr_min <= tempDoG(imin(i),jmin(i),m + 2) && ...
           curr_min <= tempDoG(imin(i),jmin(i),m))
           locs(i+length(imax)+(m-1)*size(DoGPyramid,1)*size(DoGPyramid,2),:) = ...
                [jmin(i) imin(i) DoGLevels(m)];
       end
    end
end

locs = locs(~isnan(locs(:,1)),:);