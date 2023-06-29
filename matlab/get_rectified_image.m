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
% 

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
% Thus Rinv = [x3 y3 z3] transforms frame 3 vectors to world frame's vectors
% Conversely, Ri = Rinv' = [x3'; y3'; z3'] transforms world frame's vectors to
% frame 3 vectors
% === 
% The following explicitly states R, but we skip the computation and head
% directly to the affine map A
% Ri = zeros(3, 3);
% Ri(1, :) = x3';
% Ri(2, :) = y3';
% Ri(3, :) = z3'; 

% Now we use
% - x = 0 midway between frame 1 and frame 2's origin. i.e. at +t/2 in the
% world coordinate
% - y = 0 at the epipolar line
% - z = 0 far enough to ensure all the images 

% Using an orthography projection from 3D to 2D, our final map is affine
% A = [Ri(1, 1), Ri(1, 2), Ri(1, 3) + vecnorm(t)/2; Ri(2, :); 0, 0, 1]
A = zeros(3, 3)
A(1, :) = x3' + [0, 0, (vecnorm(t)/2)]
A(2, :) = y3'
A(3, :) = [0, 0, 1] % Standard for affines
tform = affinetform2d(A)

% Use the affine mapping to obtain the projected images
tformed1 = imwarp(img1, tform)
tformed2 = imwarp(img2, tform)