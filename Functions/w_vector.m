function [w] = w_vector(sorted)

% W data is stored as a vector, X then Y, so it's size will be two times
% sorted by 1


% Placeholder for incoming misclosures
w_i = [];

% Index counters
start_row = 1;
end_row = 2;

for i=1:size(sorted, 1)
    
    % Obtaining the values needed from the image
    [XYZc, wpk, XYZ, xpypc, xyobs] = get_variables(sorted, i);

%     XYZc=[sorted(i,1); sorted(i,2); sorted(i,3)];
%     wpk= [sorted(i,4); sorted(i,5); sorted(i,6)];
%     XYZ= [sorted(i,7); sorted(i,8); sorted(i,9)];
%     xpypc= [sorted(i,10); sorted(i,11); sorted(i,12)];
%     xyobs = [sorted(i,13); sorted(i,14)];  
    
    
    % Computing the partial derivatives
    [~, ~, ~, w_i] = calc_coll_pds_misc_v2(XYZc, wpk, XYZ, xpypc, xyobs, 1);
    
    % Store the misclosure values
    w(start_row:end_row, 1) = w_i(1:end, 1);
    
    % Increment the counters (consider using cell arrays here)
    start_row = start_row + 2;
    end_row = end_row + 2;
    

end


end
    
    