function [img_tformed] = rectify_image(img, A)
%%%
% Input
% - img         : Source image
% - A           : Affine Transformation Matrix
% Output
% - img_tformed : Transformed image
%%%
tform = affinetform2d(A);
img_tformed = imwarp(img, tform);