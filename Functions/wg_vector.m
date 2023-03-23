function [wg] = wg_vector(dist, con)
%wg_vector computes the misclosure vector for the distance (geodetic)
%observations
%   Input: 
%       dist: distance observations in mm?
%       tie: tie point file with coordinates of points (Pt#, X,Y,Z)
%   Output: 
%       wg: nx1 misclosure vector 

% wg = NaN(length(con),1);


    
        %w = d_meas - sqrt((Xj - Xi)^2 + (Yj - Yi)^2 + (Zj - Zi)^2)
        wg = dist - sqrt((con(1,2) - con(2,2))^2 + (con(1, 3) - con(2,3))^2 + (con(1,4) - con(2,4))^2);
      


end