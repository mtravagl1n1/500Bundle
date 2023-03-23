function [data] = store_sort(ext, con, pho, int, tie)
% This function goes through the given dataset and stores the values
% accordingly into one matrix

lenpho = length(pho);
data = zeros(lenpho, 17); % create matrix of NaN to be filled with all input data

for i=1:lenpho %for loop to fill data matrix

%% Pho Data Input xy_obs
    
    % image point coordinates (pixels)
    data(:, 13) = pho(:, 3);
    data(:, 14) = pho(:, 4);   
    % point and image number
    data(:, 15) = pho(:, 1);
    data(:, 16) = pho(:, 2);
    
    
%% Int Data Input xpypc    

    % Interior Orientation Parameter Input (pixels)
    data(:,10) = int(1,2);
    data(:,11) = int(1,3);
    data(:,12) = int(1,4);
    
%% Tie Point Input    XYZ

    % (mm)
    for j=1:size(tie, 1)
        
        if pho(i, 1) == tie(j, 1)
            
            data(i, 7) = tie(j, 2);
            data(i, 8) = tie(j, 3);
            data(i, 9) = tie(j, 4);
            
            % If its a tie, then save 1 in col 17
            data(i, 17) = 1;
            
        end
        
    end
%% Control Point Input    XYZ

    % (mm)
    for j=1:size(con, 1)
        
        if pho(i, 1) == con(j, 1)
            
            data(i, 7) = con(j, 2);
            data(i, 8) = con(j, 3);
            data(i, 9) = con(j, 4);
            
            % If its a control, then save 2 in col 17
            data(i, 17) = 2;
            
        end
        
    end
 %% Exterior Orientation Parameters   XYZc wkp
 lenext=size(ext,1);
 
for j=1:lenext
    if pho(i,2) == ext(j,1)
        %XYZc (mm)
        data(i,1) = ext(j,3);
        data(i,2) = ext(j,4);
        data(i,3) = ext(j,5);
        %wpk (degrees to radians)
        data(i,4) = deg2rad(ext(j,6));
        data(i,5) = deg2rad(ext(j,7));
        data(i,6) = deg2rad(ext(j,8));

    end
end

end

% Order of sorted
% 1    2   3   4   5   6   7  8  9  10  11  12  13     14     15  16   17
% Xc   Yc  Zc  w   p   k   X  Y  Z  xp  yp  c   x_obs  y_obs  Pt  img torc
% ext ext ext ext ext ext ct ct ct int int int  pho    pho             1/2

% if 17 = 2 point is control
% if 17 = 1 point is tie
