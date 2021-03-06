function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%%Edge Suppression
% inputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each point contains the curvature ratio R for the 
% 					   corresponding point in the DoG pyramid

PrincipalCurvature = DoGPyramid;
for i = 1 : size(DoGPyramid,3)
    [gx, gy] = gradient(double(DoGPyramid(:,:,i)));
    [gxx, gxy] = gradient(gx);
    [gyx, gyy] = gradient(gy);
    for j = 1 : size(DoGPyramid,1)
        for k = 1 : size(DoGPyramid,2)
             H = [gxx(j,k) gxy(j,k);gyx(j,k),gyy(j,k)];
             PrincipalCurvature(j,k,i) = trace(H)^2/det(H);
        end
    end
end

