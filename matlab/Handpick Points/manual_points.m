%% Clearing the variables
clearvars
%% Loading images in

% Manually put the 4 images captured from the different angles at t=0 in
% the same folder as this manual_points.m file

% Change the filenames below to the name of the image files (make sure that
% they are in "___")
file_1="chan0_frame000000.tif";
file_2="chan1_frame000000.tif";
file_3="chan2_frame000000.tif";
file_4="chan3_frame000000.tif";

im_1=imread(file_1);
im_2=imread(file_2);
im_3=imread(file_3);
im_4=imread(file_4);

% Assigning camera positions to the images
cd(".\image_assets");
fig_1=imread("North.jpg");
fig_2=imread("East.jpg");
fig_3=imread("South.jpg");
fig_4=imread("West.jpg");

menu_message = "Please choose the image associated with the camera highlighted";
menu_options = ["file_1" "file_2" "file_3" "file_4"];

cam_menu_answer_bin = zeros(4,1);

% Selection Menu
for counter_1=1:4
    fig_name=eval("fig_"+num2str(counter_1));
    imshow(fig_name);
    cam_menu_answer=menu(menu_message,menu_options);
    cam_menu_answer_bin(counter_1,1)=cam_menu_answer;
end

im_north=eval("im_"+num2str(cam_menu_answer_bin(1,1)));
im_east=eval("im_"+num2str(cam_menu_answer_bin(2,1)));
im_south=eval("im_"+num2str(cam_menu_answer_bin(3,1)));
im_west=eval("im_"+num2str(cam_menu_answer_bin(4,1)));

cd("..\")

%% Defining the edges and finding the middle point

directions_bin=["north" "east" "south" "west"];
mid_point_bin=zeros(2,2,4);
for counter_2=1:4
    current_direction=directions_bin(1,counter_2);
    current_fig=eval("im_"+current_direction);
    imshow(current_fig);
    title("Please identify the edges of the sample on the image (2 on each side). Please make sure that it's roughly rectangular with the long axis following the sample axis.")
    edge_coords=zeros(4,2);
    hold on
    % Getting input
    for counter_3=1:4
        [edge_coords(counter_3,1),edge_coords(counter_3,2)]=ginput(1);
        plot(edge_coords(counter_3,1),edge_coords(counter_3,2),'+r');
    end
    % Finding the edge line
    temp_dist_calc=zeros(3,1);
    for counter_4=1:3
        temp_dist_calc(counter_4,1)=sqrt((edge_coords(1+counter_4,1)-edge_coords(1,1))^2+(edge_coords(1+counter_4,2)-edge_coords(1,2))^2);
    end
    [max_val_temp,max_idx_temp]=max(temp_dist_calc(:,1));
    [min_val_temp,min_idx_temp]=min(temp_dist_calc(:,1));
    edge_pair_1=zeros(2,2);
    edge_pair_2=zeros(2,2);

    % Putting points into pairs
    edge_pair_1(1,1)=edge_coords(1,1);
    edge_pair_1(1,2)=edge_coords(1,2);
    
    edge_pair_2(1,1)=edge_coords(1+min_idx_temp,1);
    edge_pair_2(1,2)=edge_coords(1+min_idx_temp,2);

    edge_pair_2(2,1)=edge_coords(1+max_idx_temp,1);
    edge_pair_2(2,2)=edge_coords(1+max_idx_temp,2);

    all_index=[1 2 3 4];
    used_idx=[1 1+min_idx_temp 1+max_idx_temp];
    unused_idx=setxor(all_index,used_idx);

    edge_pair_1(2,1)=edge_coords(unused_idx,1);
    edge_pair_1(2,2)=edge_coords(unused_idx,2);

    % Finding the middle line
    x_calc_temp_1=[edge_pair_1(1,1) edge_pair_1(2,1)];
    y_calc_temp_1=[edge_pair_1(1,2) edge_pair_1(2,2)];
    edge_line_1_temp=[[1; 1]  x_calc_temp_1(:)]\y_calc_temp_1(:);
    edge_line_1=flip(edge_line_1_temp);

    x_calc_temp_2=[edge_pair_2(1,1) edge_pair_2(2,1)];
    y_calc_temp_2=[edge_pair_2(1,2) edge_pair_2(2,2)];
    edge_line_2_temp=[[1; 1]  x_calc_temp_2(:)]\y_calc_temp_2(:);
    edge_line_2=flip(edge_line_2_temp);

    mid_ref=zeros(2,2);
    mid_ref(1,1)=edge_pair_1(1,1);
    mid_ref(1,2)=mean([edge_line_1(1)*edge_pair_1(1,1)+edge_line_1(2),edge_line_2(1)*edge_pair_1(1,1)+edge_line_2(2)]);
    mid_ref(2,1)=edge_pair_1(2,1);
    mid_ref(2,2)=mean([edge_line_1(1)*edge_pair_1(2,1)+edge_line_1(2),edge_line_2(1)*edge_pair_1(2,1)+edge_line_2(2)]);

    x_calc_temp_mid=[mid_ref(1,1) mid_ref(2,1)];
    y_calc_temp_mid=[mid_ref(1,2) mid_ref(2,2)];
    mid_line_temp=[[1; 1]  x_calc_temp_mid(:)]\y_calc_temp_mid(:);
    mid_line=flip(mid_line_temp);
    hold on
    plot(mid_ref(:,1),mid_ref(:,2),'color','b')
    hold off
    mid_point_bin(1,1,counter_2)=mid_ref(1,1);
    mid_point_bin(1,2,counter_2)=mid_ref(1,2);
    mid_point_bin(2,1,counter_2)=mid_ref(2,1);
    mid_point_bin(2,2,counter_2)=mid_ref(2,2);
    pause(5)
end

%% Handpicking Correspondance

% Which direction is pointing up?

menu_message = "Which direction is pointing up in the images?";
menu_options = ["Left" "Right"];
updown_menu_answer=menu(menu_message,menu_options);

% Things are made to reflect right = up, there will be a factor of (-1) if
% left=up (this is caused by (-1)^updown_menu_answer which will be 1 or 2)

img_file_info=strings(5,2);

% Saving N E S W to the filename
img_file_info(1,1)="N";
img_file_info(2,1)="E";
img_file_info(3,1)="S";
img_file_info(4,1)="W";

img_file_info(1,2)=eval("file_"+num2str(cam_menu_answer_bin(1,1)));
img_file_info(2,2)=eval("file_"+num2str(cam_menu_answer_bin(2,1)));
img_file_info(3,2)=eval("file_"+num2str(cam_menu_answer_bin(3,1)));
img_file_info(4,2)=eval("file_"+num2str(cam_menu_answer_bin(4,1)));

img_file_info(5,1)="Up Direction";
img_file_info(5,2)=menu_options(1,updown_menu_answer);

save("img_file_info.mat","img_file_info");

% Saving coordinates
feature_number=10; % Change this if you want the initial correspondance to be more/less accurate.
data_export_bin=zeros(2*feature_number,3,4);

for counter_5=1:4

    % Getting the images
    current_direction=directions_bin(1,counter_5);
    current_fig=eval("im_"+current_direction);
    up_position=mod(((counter_5+((-1)^updown_menu_answer))-1),4)+1;
    down_position=mod(((counter_5-((-1)^updown_menu_answer))-1),4)+1;
    up_direction=directions_bin(1,up_position);
    down_direction=directions_bin(1,down_position);
    up_fig=eval("im_"+up_direction);
    down_fig=eval("im_"+down_direction);
    
    % The lines below aren't used because having 3 images at the same time
    % makes the image too small.
    %
    % % Plotting the images
    % tiledlayout(3,1);
    % 
    % % Top tile
    % nexttile(1);
    % imshow(up_fig);
    % top_mid_coords=zeros(2,2);
    % top_mid_coords(:,:)=mid_point_bin(:,:,up_position);
    % hold on
    % plot(top_mid_coords(:,1),top_mid_coords(:,2));
    % if unique(data_export_bin(:,:,up_position))~=0
    %     scatter(data_export_bin(:,2,up_position),data_export_bin(:,3,up_position),'+b')
    %     top_has_label=1;
    % else
    %     top_has_label=0;
    % end
    % hold off
    % title(up_direction);
    % 
    % % Middle tile
    % nexttile(2);
    % imshow(current_fig);
    % mid_mid_coords=zeros(2,2);
    % mid_mid_coords(:,:)=mid_point_bin(:,:,counter_5);
    % hold on
    % plot(mid_mid_coords(:,1),mid_mid_coords(:,2));
    % hold off
    % title(current_direction)
    % 
    % % Bottom tile
    % nexttile(3);
    % imshow(down_fig)
    % bottom_mid_coords=zeros(2,2);
    % bottom_mid_coords(:,:)=mid_point_bin(:,:,down_position);
    % hold on
    % plot(bottom_mid_coords(:,1),bottom_mid_coords(:,2));
    % if unique(data_export_bin(:,:,down_position))~=0
    %     scatter(data_export_bin(:,2,down_position),data_export_bin(:,3,down_position),'+b')
    %     bottom_has_label=1;
    % else
    %     bottom_has_label=0;
    % end
    % hold off
    % title(down_direction)
    % 
    % % Getting corresponding coordinates
    % nexttile(2)

    % Corresponding features

    % For this section, the top feature will be labelled by "1" on the first
    % column while the bottom feature will be labelled by "-1"
    
    % Top Half
    
    tiledlayout(2,1);

    % Displaying images

    % Top tile
    nexttile(1);
    imshow(up_fig);
    top_mid_coords=zeros(2,2);
    top_mid_coords(:,:)=mid_point_bin(:,:,up_position);
    hold on
    plot(top_mid_coords(:,1),top_mid_coords(:,2));
    if unique(data_export_bin(:,:,up_position))~=0
        scatter(data_export_bin(:,2,up_position),data_export_bin(:,3,up_position),'+b')
        top_has_label=1;
    else
        top_has_label=0;
    end
    hold off
    title(up_direction);

    % Middle tile
    nexttile(2);
    imshow(current_fig);
    mid_mid_coords=zeros(2,2);
    mid_mid_coords(:,:)=mid_point_bin(:,:,counter_5);
    hold on
    plot(mid_mid_coords(:,1),mid_mid_coords(:,2));
    hold off
    title(current_direction)

    % Picking points
    nexttile(2)
    top_pick_msg="Please pick "+num2str(feature_number)+" special points on the top half of the image above.";
    title(current_direction)
    xlabel(top_pick_msg+" (Note that you will have to identify these features again in the next images).")
    for counter_6=1:feature_number
        data_export_bin(counter_6,1,counter_5)=1;

        if top_has_label==1
            nexttile(1)
            hold on
            scatter(data_export_bin(counter_6+feature_number,2,up_position),data_export_bin(counter_6+feature_number,3,up_position),'+r');
            hold off
            nexttile(2)
        else
            nexttile(2)
        end

        [data_export_bin(counter_6,2,counter_5),data_export_bin(counter_6,3,counter_5)]=ginput(1);
        hold on
        plot(data_export_bin(counter_6,2,counter_5),data_export_bin(counter_6,3,counter_5),'+r');
        hold off

        if top_has_label==1
            nexttile(1)
            hold on
            scatter(data_export_bin(counter_6+feature_number,2,up_position),data_export_bin(counter_6+feature_number,3,up_position),'+b');
            hold off
            nexttile(2)
        else
            nexttile(2)
        end
    end

    pause(5)

    % Bottom Half

    tiledlayout(2,1)

    % Displaying images

    % Middle tile
    nexttile(1);
    imshow(current_fig);
    mid_mid_coords=zeros(2,2);
    mid_mid_coords(:,:)=mid_point_bin(:,:,counter_5);
    hold on
    plot(mid_mid_coords(:,1),mid_mid_coords(:,2));
    hold off
    title(current_direction)

    % Bottom tile
    nexttile(2);
    imshow(down_fig)
    bottom_mid_coords=zeros(2,2);
    bottom_mid_coords(:,:)=mid_point_bin(:,:,down_position);
    hold on
    plot(bottom_mid_coords(:,1),bottom_mid_coords(:,2));
    if unique(data_export_bin(:,:,down_position))~=0
        scatter(data_export_bin(:,2,down_position),data_export_bin(:,3,down_position),'+b')
        bottom_has_label=1;
    else
        bottom_has_label=0;
    end
    hold off
    title(down_direction)



    % Picking points
    nexttile(1)
    bottom_pick_msg="Please pick "+num2str(feature_number)+" special points on the bottom half of the image above.";
    title(current_direction)
    xlabel(bottom_pick_msg+" (Note that you will have to identify these features again in the next images).")
    for counter_7=1:feature_number
        data_export_bin(counter_7+feature_number,1,counter_5)=-1;

        if bottom_has_label==1
            nexttile(2)
            hold on
            scatter(data_export_bin(counter_7,2,down_position),data_export_bin(counter_7,3,down_position),'+r');
            hold off
            nexttile(1)
        else
            nexttile(1)
        end

        [data_export_bin(counter_7+feature_number,2,counter_5),data_export_bin(counter_7+feature_number,3,counter_5)]=ginput(1);
        hold on
        plot(data_export_bin(counter_7+feature_number,2,counter_5),data_export_bin(counter_7+feature_number,3,counter_5),'+r');
        hold off

        if bottom_has_label==1
            nexttile(2)
            hold on
            scatter(data_export_bin(counter_7,2,down_position),data_export_bin(counter_7,3,down_position),'+b');
            hold off
            nexttile(1)
        else
            nexttile(1)
        end
    end
    pause(5);
end

save("feature_data_export.mat","data_export_bin");

    % Do codes, ginput on top, ginput on the bottom