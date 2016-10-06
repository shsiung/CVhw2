function H2to1 = computeH(p1,p2)
% inputs:
% p1 and p2 should be 2 x N matrices of corresponding (x, y)' coordinates between two images
%
% outputs:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation

N = size(p1,2);
A = zeros(N*2,9);
for i = 1 : N
   A((i-1)*2+1,:) = [-p1(1,i) -p1(2,i) -1 ...
                     0 0 0 ...
                     p1(1,i)*p2(1,i) p1(2,i)*p2(1,i) p2(1,i)];
   A(i*2,:) = [0 0 0 ...
                     -p1(1,i) -p1(2,i) -1 ...
                     p1(1,i)*p2(2,i) p1(2,i)*p2(2,i) p2(2,i)];
end
[~, ~, V] = svd(A,'econ');
H2to1 = reshape(V(:,end),3,3)';