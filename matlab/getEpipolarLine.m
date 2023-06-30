% Input: image coordinates (imgCoords) (ur and vr) as an M by 2 matrix and fundamental matrix (F) for
% the two cameras as a 3 by 3 matrix
%
% Output: m and c which gives epipolar line vl = m*ul + c 
%
% Note: Derived from the equation that [ul vl 1] F [ur; vr; 1] = 0

function [m, c] = getEpipolarLine(imgCoords, F)

    m = -(F(1,1)*imgCoords(1) + F(2,1)*imgCoords(2) + F(3,1))/(F(1,2)*imgCoords(1) + F(2,2)*imgCoords(2) + F(3,2));
    c = -(F(1,3)*imgCoords(1) + F(2,3)*imgCoords(2) + F(3,3))/(F(1,2)*imgCoords(1) + F(2,2)*imgCoords(2) + F(3,2));

end