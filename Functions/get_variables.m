function [XYZc, wpk, XYZ, xpypc, xyobs, point, image] = get_variables(sorted, index)

    % This function goes through the sorted dataset and returns individual
    % coordinate and ID informaton at given index
    
    % Order of sorted
    % 1    2   3   4   5   6   7  8  9  10  11  12  13     14     15  16
    % Xc   Yc  Zc  w   p   k   X  Y  Z  xp  yp  c   x_obs  y_obs  Pt  img
    % ext ext ext ext ext ext ct ct ct int tie tie  pho    pho

    % Obtaining the values needed from the image
    XYZc = [sorted(index, 1); sorted(index, 2); sorted(index, 3)];
    wpk = [sorted(index, 4); sorted(index, 5); sorted(index, 6)];
    XYZ = [sorted(index, 7); sorted(index, 8); sorted(index, 9)];
    xpypc = [sorted(index, 10); sorted(index, 11); sorted(index, 12)];
    xyobs = [sorted(index, 13); sorted(index, 14)];
    
    % Place points and IDs
    point = sorted(index, 15);
    image = sorted(index, 16);
        
end
