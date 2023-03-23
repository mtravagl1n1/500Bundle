function [wo] = wo_vector(orig_sorted, adj_sorted, uo, lab)

% W data is stored as a vector, X then Y, so it's size will be two times
% sorted by 1

% Order of sorted
% 1    2   3   4   5   6   7  8  9  10  11  12  13     14     15  16   17
% Xc   Yc  Zc  w   p   k   X  Y  Z  xp  yp  c   x_obs  y_obs  Pt  img torc
% ext ext ext ext ext ext ct ct ct int int int  pho    pho             1/2

% if 17 = 2 point is control
% if 17 = 1 point is tie

% Placeholder for incoming misclosures
wo_i = zeros(uo, 1);
wo = zeros(uo, 1);

% Finds the data for just the unique point numbers
[~, rows] = unique(orig_sorted(:, 15));
org_sorted_points = orig_sorted(rows, :);

[~, rows] = unique(adj_sorted(:, 15));
adj_sorted_points = adj_sorted(rows, :);


num_points = size(wo, 1);

% Counts the number of control points
control = 0;


for j=1:size(org_sorted_points, 1)
    
    % Check if point is tie or control
    
    % If it is a control point then calculate the misclosure
    if (org_sorted_points(j, 17) == 2)
               
        % wo in the X position is the adjCON at X - origCON at X
        wo_i(j, 1:3) = adj_sorted_points(j, 7:9) - org_sorted_points(j, 7:9);
        
        wo_i(j, 4) = org_sorted_points(j, 15);

        control = control + 1;
        
        % If we are running lab 2
        if lab == "Lab 2"
            
            % If we encounter the 3rd control point
            if control == 3
                
                % Replace the x and y misclosures with 0
                wo_i(j, 1:2) = [0, 0];
                wo_i(j, 4) = org_sorted_points(j, 15);
    
            end

        end
        
    end

end

count = 1;

% This loop stores the XYZ in the correct spots for the wo
for k=1:size(wo_i, 1)
    
    % Incrementing by 3 bc XYZ
    wo(count:3:num_points - 1) =  wo_i(k, 1); % Copy X
    wo(count+1:3:num_points - 1) =  wo_i(k, 2); % Copy Y
    wo(count+2:3:num_points - 1) =  wo_i(k, 3); % Copy Z
    
    % Debug
    %wo(count + 2:3:num_points - 1) = wo_i(k, 4);
    
    count = count + 3;

end


end
    
    
    
    