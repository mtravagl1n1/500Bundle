function [block] = Ae_block(points)

% Compute 1 Ae block for image

% Fill empty matrix pertaining to the number of points in given image
block = zeros(size(points, 1) * 2, 6);

% Counters to correctly fill x and y data spots
pos1 = 1;
pos2 = 2;

% Order of sorted
% 1    2   3   4   5   6   7  8  9  10  11  12  13     14     15  16    17
% Xc   Yc  Zc  w   p   k   X  Y  Z  xp  yp  c   x_obs  y_obs  Pt  img t or c
% ext ext ext ext ext ext ct ct ct int int int  pho    pho              1/2

for i=1:size(points, 1)
    
    % Obtaining the values needed from the image    
    [XYZc, wpk, XYZ, xpypc, xyobs] = get_variables(points, i);

    % Computing the partial derivatives
    [EOP_partial, ~, ~, ~] = calc_coll_pds_misc_v2(XYZc, wpk, XYZ, xpypc, xyobs, 1);
        
    % Populate the Ae block matrix with partial derivative
    block(pos1, :) = EOP_partial(1, :);
    block(pos2, :) = EOP_partial(2, :);
    
    % Increment the counters so that the data skips two spots for next time
    pos1 = pos1 + 2;
    pos2 = pos2 + 2;
    
end

end