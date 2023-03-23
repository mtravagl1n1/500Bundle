function [ai] = ai_matrix(sorted, n)

% This function computes the ai_matrix
% size is n x 3

ai = zeros(n, 3);

% Counters to store xy row information
% 1 0 C
% 0 1 C
% 1 0 C
% 0 1 C ... etc
row_count1 = 1;
row_count2 = 2;

% Looping through our sorted points to calculate each partial derivative
% and store them
for i=1:size(sorted, 1)
    
    % Obtaining the values needed from the image
    [XYZc, wpk, XYZ, xpypc, xyobs] = get_variables(sorted, i);
    
    % Computing the partial derivatives
    [~, ~, AOP_partial, ~] = calc_coll_pds_misc_v2(XYZc, wpk, XYZ, xpypc, xyobs, 1);
    
    % Store the partial derivatives into the matrix
    ai(row_count1:row_count2, 1:3) = AOP_partial;
    
    % Increment the index counters
    row_count1 = row_count1 + 2;
    row_count2 = row_count2 + 2;
    
end
    
end