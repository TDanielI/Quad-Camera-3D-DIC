% This function gives back the 3D coordinates with respect to the location
% of one camera (the camera's location is origin). It takes in Fundamental
% Matrix F, the corresponding coordinates as obtained from the dense
% correspondence process (corrCoords), calibration matrices for the right and left cameras (Kr and Kl respectively). 
function [coords_3D] = get3DCoords(fund_matrix, dense_corr_coords, M_intr_bin)

den_cor_points=size(dense_corr_coords,1)/2; % This assumes that the number of corresponding points are the same for each images

load('img_file_info.mat','img_file_info');
if img_file_info(5,2)=="Left"
    updown_menu_answer=1;
elseif img_file_info(5,2)=="Right"
    updown_menu_answer=2;
else
    disp("img_file_info might be invalid, please check the file.")
end

coords_3D=zeros(den_cor_points,3,4);

for counter_1=1:4
    up_position=mod(((counter_1+((-1)^updown_menu_answer))-1),4)+1;
    % down_position=mod(((counter_1-((-1)^updown_menu_answer))-1),4)+1; % Uncomment if the comparison is between the current image and the next image

    % Relating the top points of the current image with the bottom points
    % of the previous image
    current_points=dense_corr_coords(1:den_cor_points,2:3,counter_1);
    prev_points=dense_corr_coords(1+den_cor_points:2*den_cor_points,2:3,up_position);

    % Getting previous and current M_int from the bin
    M_int_prev=M_intr_bin(:,:,up_position);
    M_int_curr=M_intr_bin(:,:,counter_1);

    % Getting Essential Matrix
    E_matrix=transpose(M_int_prev)*fund_matrix*M_int_curr;

    % Using eigen value decomposition to get the skew symmetric matrix and
    % the orthonormal matrix.

    [T_matrix,R_matrix]=essentialFactor(E_matrix);

    % Changing matrix size for P calculation

    M_int_prev_3x4=zeros(3,4);
    M_int_prev_3x4(:,1:3)=M_int_prev;

    M_ext=zeros(4,4);
    M_ext(1:3,1:3)=R_matrix;
    M_ext(1,4)=(T_matrix(3,2)-T_matrix(2,3))/2;
    M_ext(2,4)=abs(T_matrix(1,3)-T_matrix(3,1))/2;
    M_ext(3,4)=abs(T_matrix(2,1)-T_matrix(1,2))/2;
    M_ext(4,4)=1;

    P_matrix_prev=M_int_prev_3x4*M_ext;
    
    M_matrix_curr=zeros(3,4);
    M_matrix_curr(:,1:3)=M_int_curr;




    for counter_2=1:den_cor_points % Reading the number of points set by the dense correspondance
        % Solve the x y r for each points using M and P
        proc_point_1=current_points(counter_2,:);
        proc_point_2=prev_points(counter_2,:);

        x_init = [1 1 1 1 1];

        func_optimize = @(x_var_optimize)[proc_point_1-M_matrix_curr*[x_var_optimize(1)*x_var_optimize(4);x_var_optimize(2)*x_var_optimize(4);x_var_optimize(3)*x_var_optimize(4);x_var_optimize(4)];proc_point_2-P_matrix_prev*[x_var_optimize(1)*x_var_optimize(5);x_var_optimize(2)*x_var_optimize(5);x_var_optimize(3)*x_var_optimize(5);x_var_optimize(5)]];
        sol_point = lsqnonlin(func_optimize,x_init,[],[],[],[],[],[],[],optimset('MaxFunEvals',10000));
        coords_3D(counter_2,:,counter_1)=sol_point(1,1:3);
    end
end
end