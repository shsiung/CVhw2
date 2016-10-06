function testMatch()
% A test script performing BRIEF match using the given functions

im1 = imread('../data/model_chickenbroth.jpg');
im2 = imread('../data/chickenbroth_01.jpg');

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

[matches] = briefMatch(desc1, desc2,0.5);
plotMatches(im1, im2, matches, locs1, locs2);
end