function [tformed1, tformed2] = get_rectified_image(t, R, img1, img2)
%%%
% Deprecated function. 
% Use get_rectification_transform() and 2 calls to rectify_image() instead.
%
% Input
% - t        : Translation vector from frame 1's origin to frame 2's origin, in frame 1
% - R        : Orthonormal matrix s.t. for any vector v in frame 2, R*v is the corresponding representation in frame 1
% - img1     : First image to be transformed
% - img2     : Second image to be transformed
% Output
% - tformed1 : First image with the affine mapping applied
% - tformed2 : Second image with the affine mapping applied
%%%
[A1, A2] = get_rectification_transforms(t, R);
tformed1 = rectify_image(img1, A1);
tformed2 = rectify_image(img2, A2);