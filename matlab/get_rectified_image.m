function [tformed1, tformed2] = get_rectified_image(t, R, img1, img2)
%%%
% Input
% - t        : Translation vector from frame 1's origin to frame 2's origin, in frame 1
% - R        : Orthonormal matrix s.t. for any vector v in frame 2, R*v is the corresponding representation in frame 1
% - img1     : First image to be transformed
% - img2     : Second image to be transformed
% Output
% - tformed1 : First image with the affine mapping applied
% - tformed2 : Second image with the affine mapping applied
%%%

% The normal vector of the joint plane is
% z3 = t x (z1 x z2)
% NOTE: or its minus. Double-check this.
z3 = unitize(cross(t, cross([0;0;1], R(:, 3)))); % R(:, 3) = R*[0;0;1]
% x axis; Antiparallel to epipolar line.
x3 = -unitize(t);
% y axis; y3 = z3 x x3
y3 = unitize(cross(z3, x3)); % unitize actually optional since by definition x3 and z3 are orthogonal

% ===
% The above x3, y3, z3 are in the world coordinates
% In frame 3's coordinates, they are [1; 0; 0], [0; 1; 0], and [0; 0; 1]
% respectively.
% Thus Rinv = [x3 y3 z3] transforms frame 3 vectors to frame 1's vectors
% Conversely, Ri = Rinv' = [x3'; y3'; z3'] transforms frame 1's vectors to
% frame 3 vectors
% === 
Ri = zeros(3, 3);
Ri(1, :) = x3';
Ri(2, :) = y3';
Ri(3, :) = z3'; 
% Define Rj = Ri*R which transforms frame 2's vectors to frame 3 vectors
Rj = Ri*R

% Now we use
% - x = 0 midway between frame 1 and frame 2's origin. i.e. at +t/2 in the
% world coordinate
% - y = 0 at the epipolar line
% - z = 0 at the epipolar line

% Using an orthography projection from 3D to 2D, our final map is affine
% A1 = [Ri(1, 1), Ri(1, 2), Ri(1, 3) + vecnorm(t)/2; Ri(2, :); 0, 0, 1]
A1 = zeros(3, 3)
A1(1, :) = Ri(1, :) + [0, 0, (vecnorm(t)/2)]
A1(2, :) = Ri(2, :)
A1(3, :) = [0, 0, 1] % Standard for affines

% A2 is similar, but
% - Uses Rj instead of Ri
% - Uses -vecnorm(t)/2 instead of +vecnorm(t)/2
A2 = zeros(3, 3)
A2(1, :) = Rj(1, :) - [0, 0, (vecnorm(t)/2)]
A2(2, :) = Rj(2, :)
A2(3, :) = [0, 0, 1]

% Use the affine mapping to obtain the projected images
tform1 = affinetform2d(A1)
tform2 = affinetform2d(A2)
tformed1 = imwarp(img1, tform1)
tformed2 = imwarp(img2, tform2)