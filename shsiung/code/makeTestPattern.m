function [compareA, compareB] = makeTestPattern(patchWidth, nbits)  
% input
% patchWidth - the width of the image patch (usually 9)
% nbits - the number of tests n in the BRIEF descriptor
% output
% compareA and compareB - linear indices into the patchWidth x patchWidth image patch and are each nbits x 1 vectors. 
%
% Run this routine for the given parameters patchWidth = 9 and n = 256 and save the results in testPattern.mat.

compareA = randi(patchWidth^2,nbits,1);
compareB = randi(patchWidth^2,nbits,1);

%% Only ran once to save the pattern file
%save('testPattern.mat','compareA', 'compareB');