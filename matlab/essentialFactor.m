function [T_matrix, R_matrix] = essentialFactor(E_matrix)

[U_matrix, S_matrix, V_matrix] = svd(E_matrix);
temp_t = U_matrix(:, 3)*S_matrix(1,1);
T_matrix_temp = [0 -temp_t(3) temp_t(2); temp_t(3) 0 -temp_t(1); -temp_t(2) temp_t(1) 0]*(-1);

% Finding R
E_matrix_mod = (-1)*T_matrix_temp * E_matrix;
[U_mod,S_mod,V_mod]=svd(E_matrix_mod);
R_matrix_temp=U_mod*transpose(V_mod);

if T_matrix_temp(2,1)<0 % This assumes that all the camera are translated on the positive z direction (there are no stacked cameras)
    T_matrix=(-1)*T_matrix_temp;
    R_matrix=(-1)*R_matrix_temp;
else
    T_matrix=T_matrix_temp;
    R_matrix=R_matrix_temp;
end

end
