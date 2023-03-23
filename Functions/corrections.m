function [ext, con, tie, int] = corrections(ext_prev, pho_prev, con_prev, tie_prev, int_prev, delta_EOP, delta_OP, delta_IOP, lab)

% This function will conduct all the corrections and update the ORIGINAL
% input files

% Restoring point and ID information (as this wont change)
ext(:, 1) = ext_prev(:, 1);
ext(:, 2) = ext_prev(:, 2);
con(:, 1) = con_prev(:, 1);
tie(:, 1) = tie_prev(:, 1);
int = int_prev;

%% Correcting IOP (int)

if lab == "Lab 2"

    int(1, 2:4) = int_prev(1, 2:4) + transpose(delta_IOP);
    % int(1, 2) = int_prev(1, 2) + delta_IOP(1, 1);
    % int(1, 3) = int_prev(1, 3) + delta_IOP(2, 1);
    % int(1, 4) = int_prev(1, 4) + delta_IOP(3, 1);
    
end
%% Correcting EOP (ext)

% Finding the number of images
num_images = size(ext_prev, 1);

% Storing correction values
% every 6th value is a coordinate and we stop at the last (thus -5, -4 etc)
ext(:, 3) = ext_prev(:, 3) + delta_EOP(1:6:num_images*6 - 5); % X
ext(:, 4) = ext_prev(:, 4) + delta_EOP(2:6:num_images*6 - 4); % Y
ext(:, 5) = ext_prev(:, 5) + delta_EOP(3:6:num_images*6 - 3); % Z
ext(:, 6) = ext_prev(:, 6) + rad2deg(delta_EOP(4:6:num_images*6 - 2)); % w (deg)
ext(:, 7) = ext_prev(:, 7) + rad2deg(delta_EOP(5:6:num_images*6 - 1)); % p (deg) 
ext(:, 8) = ext_prev(:, 8) + rad2deg(delta_EOP(6:6:num_images*6)); % k (deg)

%% Correcting OP (con % tie)

% Obtain list of points as a vector
unique_points = pho_prev(:, 1);
unique_points = unique(unique_points, 'rows');

% Finding total number of points
num_points = size(unique_points, 1);
xplace=num_points*3-2;
yplace=num_points*3-1;
zplace=num_points*3;

OP_X = delta_OP(1:3:xplace);
OP_Y = delta_OP(2:3:yplace);
OP_Z = delta_OP(3:3:zplace);
delta_OP_matrix = [OP_X, OP_Y, OP_Z];

% Loop through all our points
for i=1:num_points
    
    % Store the point number
    point = unique_points(i, 1);
    
    % Loop through tie
    
    for j=1:size(tie_prev, 1)
        
        % If the point number is in tie, adjust with i of delta
        if point == tie_prev(j, 1)
            
            tie(j, 2:4) = tie_prev(j, 2:4) + delta_OP_matrix(i, 1:3); 
            
        end
         
    end
    
    % Loop through con
    for k=1:size(con_prev, 1)
        
        % If the point number is in con, adjust with at i of delta
        if point == con_prev(k, 1)
            
           con(k, 2:4) = con_prev(k, 2:4) + delta_OP_matrix(i, 1:3);           
           
        end
        
    end
    
end

