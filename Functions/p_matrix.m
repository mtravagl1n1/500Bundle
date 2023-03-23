function [P] = p_matrix(pho, condition, uo, ~, n, sorted, eVF)

    % Our standard deviations are 1mm (I think)
    
    % If condition is true, it will return the uo x uo (in this case 36x36) Po matrix
    % If it is false, then it will return the nxn P matrix

    % Check to see which images the point appears in
    check = check_image(pho);

    % This nest works similar to the ae_block where each block is stored in
    % a cell array and combined later as blkdiag

    % Finds the data for just the unique point numbers
    [~, rows] = unique(sorted(:, 15));
    sorted_points = sorted(rows, :);
    %disp(size(sorted_points, 1))

    % Counts the number of gcps
    count = 0;
    
    % If we want to have a uo x uo matrix (Po matrix used in lab 1)
    if condition == 1

        % Computing the P (weight) matrix
        P = zeros(uo, uo);
        % P_block = eye(3, 3);
        
        % Loop through all points
        for j=1:size(sorted_points, 1)
            
            % If we have a control point
            if sorted_points(j, 17) == 2
                
                % The identity is multiplied by the inverse of the stddev
                % This is stored in cell array
                P_block{j} = eye(3, 3) * eVF^(-1);
                %disp('Control')
                %j
                
            else
                
                % If it's not a control point, then P at that block is 0
                P_block{j} = zeros(3, 3);
                
                
            end
            
            % Create block diagonal using cell array
            P = blkdiag(P_block{:});
            
        end

    elseif condition == 2 % condition for if we have minimally constrained system

    
        % Computing the P (weight) matrix
        P = zeros(uo, uo);
        % P_block = eye(3, 3);
        
        % Loop through all points
        for j=1:size(sorted_points, 1)
            
            % If we have a control point
            if sorted_points(j, 17) == 2

                count = count + 1;

                if count <= 2
                
                    % The identity is multiplied by the inverse of the stddev
                    % This is stored in cell array
                    P_block{j} = eye(3, 3) * eVF^(-1);
                    %disp('Control')
                    %j

                elseif count == 3
                    
                    % We fix only one coordinate (x in this case)
                    P_block{j} = [0, 0, 0; 0, 0, 0; 0, 0, 1] * eVF^(-1);
                    %disp('Control fixed')
                    %j
                    %count

                end
                
            else
                
                % If it's not a control point, then P at that block is 0
                P_block{j} = zeros(3, 3);
                
            end
            
            % Create block diagonal using cell array
            P = blkdiag(P_block{:});

        end
        
        
    else
        
        P = eVF^(-1)*eye(n, n);

    end