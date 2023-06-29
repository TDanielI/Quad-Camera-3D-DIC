function [t, R] = essentialFactor(E)

[U, S, V] = svd(E);
t = U(:, 3)*S(1,1);
T = [0 -t(3) t(2); t(3) 0 -t(1); -t(2) t(1) 0];

C = T*E;
[UC, SC, VC] = svd(C);
R = -UC*VC';