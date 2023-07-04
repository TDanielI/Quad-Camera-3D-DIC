function [Cx_tformed, Cy_tformed, C0_tformed] = rectify_line(Cx, Cy, C0, A)
%%%
% Input
% - Cx, Cy, C0    : Defines the line Cx*x + Cy*y + C0 = 0
% - A             : Affine Transformation Matrix
% Output
% - Cx', Cy', C0' : Defines the line Cx'*x + Cy'*y + C0' = 0
%%%
Cx_tformed = A(2,2)*Cx - A(2,1)*Cy;
Cy_tformed = -A(1,2)*Cx + A(1,1)*Cy;
C0_tformed = (A(1,2)*A(2,3)-A(1,3)*A(2,2))*Cx + (A(1,3)*A(2,1)-A(1,1)*A(2,3))*Cy + (A(1,1)*A(2,2)-A(1,2)*A(2,1))*C0;