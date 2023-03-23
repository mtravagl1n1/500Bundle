function [ao] = ao_matrix_new(pho, sorted, n, uo)


checking = check_image(pho);
point_count = pointcounter(pho);

% Obtain list of points as a vector
unique_points = pho(:, 1);
unique_points = unique(unique_points, 'rows');

 % Obtain list of points as a vector
unique_images = pho(:, 2);
unique_images = unique(unique_images, 'rows');
num_images = size(unique_images, 1);

% Stores the columnm of current image
image_col_count = 1;

% Counters for xyz coordinates
startrow = 1;
endrow = 2;

startcol = 1;
endcol = 3;

pointsfound = 0;

% Going through the images
for i=1:size(point_count, 2)

    % Store the number of points of current image
    num_points = point_count(1, i);

    %i
    
    % Searching through our list of points and the images they appear in
    for j=1:size(checking, 1)

        % If a point appears in an image
        if unique_images(i, 1) == checking(j, i + 1)

            %disp("Point found in image");
            pointsfound = pointsfound + 1;
           


            % Search sorted for this point and image
            for l=1:size(sorted, 1)
                
                % If we find this point and image in sorted
                if sorted(l, 16) == unique_images(i, 1) && sorted(l, 15) == checking(j, 1)

                    % Obtaining the values needed from the image
                    [XYZc, wpk, XYZ, xpypc, xyobs] = get_variables(sorted, l);

                    % Computing the partial derivatives
                    [~, OP_partial, ~, ~] = calc_coll_pds_misc_v2(XYZc, wpk, XYZ, xpypc, xyobs, 1);

                    ao(startrow:endrow, startcol:endcol) = OP_partial;
                    
                    % Increment the counters
                    startrow = startrow + 2;
                    endrow = endrow + 2;
                    startcol = startcol + 3;
                    endcol = endcol + 3;

                    

                end

            end

        else

            %disp("Point not found in image");
            
            % If the point isn't found, then place a 2x3 of zeros instead
            OP_partial = [0,0,0; 0,0,0];
            ao(startrow:endrow, startcol:endcol) = OP_partial;

            % Increment only the column counters to maintain diagonal
            startcol = startcol + 3;
            endcol = endcol + 3;

            
        end

    end

    %startcol
    %endcol

   

    % Reset column counters
    startcol = 1;
    endcol = 3;
    
    %pointsfound
    %indexadd = pointsfound*2 + 1
    %pointsfound = 0;

    %disp("--------------reset image----------------")

    

end
end