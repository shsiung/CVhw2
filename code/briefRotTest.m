function briefRotTest()
% A test script performing BRIEF match using the given functions
im1 = imread('../data/model_chickenbroth.jpg');

perf = zeros(37,1);
x = 0:10:360;
for i = 1 : 36
   imr = imrotate(im1,x(i));
   [~, desc1] = briefLite(im1);
   [~, desc2] = briefLite(imr);
   [matches] = briefMatch(desc1, desc2, 0.8);
   perf(i) = size(matches,1);
end

bar(x,perf);

end