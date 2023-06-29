function unit_v = unitize(v)
%%% 
% Extract unit vector from vector 
% Assumes vector is nonzero
% 
% Input
% - v : vector
%
% Output
% - unit_v : vector of unit length with same direction as v
%%%
unit_v = v/vecnorm(v);