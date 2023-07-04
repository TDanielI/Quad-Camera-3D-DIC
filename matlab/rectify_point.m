function [pt_tformed] = rectify_point(pt, A)
%%%
% Input
% - pt         : Source point. Assumed to be either 
%                - a 1x2 matrix [x, y], or
%                - a 2x1 matrix [x; y]
% - A          : Affine Transformation Matrix
% Output
% - pt_tformed : Transformed point. Has the same size as "pt".
%%%
sz = size(pt);
x_tformed = A(1,1)*pt(1)+A(1,2)*pt(2) + A(1,3);
y_tformed = A(2,1)*pt(2)+A(2,2)*pt(2) + A(2,3);
if sz(1) == 1 && sz(2) == 2
    pt_tformed = [x_tformed, y_tformed];
elseif sz(1) == 2 && sz(2) == 1
    pt_tformed = [x_tformed; y_tformed];
else
    exception = MException('Quad-Camera-3D-DIC:InvalidInputShape', 'rectify_point() accepts only points of size 1x2 or 2x1.');
    throw(exception);
end