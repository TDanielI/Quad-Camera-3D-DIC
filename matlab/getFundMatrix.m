% This function estimates the fundamental matrix

% Inputs: 
% - img_file_info: NESW data of the images
% - corrPoints: corresponding points as chosen by the user
%
% Outputs: 
% - F: 3D tensor containing estimated fundamental matrix for:
%   NE = F(:,:,1)
%   ES = F(:,:,2)
%   SW = F(:,:,3) 
%   WN = F(:,:,4)

function F = getFundMatrix(img_file_info, corrPoints)
    
    % Initialise F as a 3 by 3 by 4 3D tensor
    F = zeros(3,3,4);
    halfCorrPoints=size(corrPoints,1)/2; % This assumes that the number of corresponding points are the same for each images

    % Determine which direction is upwards
    if img_file_info(5,2)=="Left"
        rPointsIndex = 1+halfCorrPoints:2*halfCorrPoints;
        lPointsIndex = 1:halfCorrPoints;
    elseif img_file_info(5,2)=="Right"
        rPointsIndex = 1:halfCorrPoints;
        lPointsIndex = 1+halfCorrPoints:2*halfCorrPoints;
    else
        disp("img_file_info might be invalid, please check the file.")
    end

    for counter_1 = 1:4
        rPoints = corrPoints(rPointsIndex,2:3,counter_1);
        lPoints = corrPoints(lPointsIndex,2:3,mod(counter_1 - 1,4)+1);

        F(:,:,counter_1) = estimateFundamentalMatrix(lPoints, rPoints, 'Method', 'Norm8Point');
    end
end