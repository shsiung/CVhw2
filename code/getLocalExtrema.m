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

% Find local extremums
maximums = imregionalmax(DoGPyramid,6);
minimums = imregionalmin(DoGPyramid,6);

% Find indexes of local extremums
[imax,jmax,kmax]=ind2sub(size(maximums), find(maximums==1));
[imin,jmin,kmin]=ind2sub(size(minimums), find(minimums==1));

% Discard local extremums that don't pass the threshold values
temp = zeros(length(imax)+length(imin),3);
for i = 1: length(imax)
   if (DoGPyramid(imax(i),jmax(i),kmax(i))>th_contrast && ...
       PrincipalCurvature(imax(i),jmax(i),kmax(i)) < th_r)
       temp(i,:) = [jmax(i) imax(i) DoGLevels(kmax(i))];
   else
       temp(i,:) = [nan nan nan];
   end
end

for i = 1: length(imin)
   if (DoGPyramid(imin(i),jmin(i),kmin(i))>th_contrast && ...
       PrincipalCurvature(imin(i),jmin(i),kmin(i)) < th_r)
       temp(i+length(imax),:) = [jmin(i) imin(i) DoGLevels(kmin(i))];
   else
       temp(i+length(imax),:) = [nan nan nan];
   end
end

locs = temp(~isnan(temp(:,1)),:);