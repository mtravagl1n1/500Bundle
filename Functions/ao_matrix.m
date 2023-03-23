function [block] = ao_matrix(pho, sorted, n, uo)

    % This function will compute the Ao matrix
    
    % Fill empty matrix pertaining to the number of points in given image
    block = zeros(n, uo);

    % Check to see which images the point appears in
    check = check_image(pho);

    img_count = 0;

    % Searching through columns (image appearences)
    for j=2:size(check, 2)

        % Counting the column we are on (which point)
        startcol_count = 1;
        endcol_count = 3;


        % Looping though points per each image
        for i=1:size(check, 1)

            % counting the number of points
            point_count = 0;

            % to store x y data correctly, counts with the number of points
            % x stored with row_count 1 and y in row_count 2
            row_count1 = 1;
            row_count2 = 2;

            % The point and image we on, in our check file
            point_check = check(i, 1);
            image_check = check(i, j);

            % Loop through data
            for k=1:size(sorted, 1)

                % The points and image we are on, in our data file
                data_point = sorted(k, 15);
                data_image = sorted(k, 16);

                % If the point appears in this particular image, then compute
                % and store the partial derivative
                if point_check == data_point && image_check == data_image

                    % Obtaining the values needed from the image
                    [XYZc, wpk, XYZ, xpypc, xyobs] = get_variables(sorted, k);

                    % Computing the partial derivatives
                    [~, OP_partial, ~, ~] = calc_coll_pds_misc_v2(XYZc, wpk, XYZ, xpypc, xyobs, 1);

                    %disp("match");

                    block(row_count1:row_count2, startcol_count:endcol_count) = OP_partial;
                    row_count1 = row_count1 + 2;
                    row_count2 = row_count2 + 2;

                else

                    %disp("no match");
                    OP_partial = [0, 0, 0; 0, 0, 0];

                    %block(row_count1:row_count2, startcol_count:endcol_count) = OP_partial;

                end
                
                % incrementing our matrix positions
                point_count = point_count + 1;
                row_count1 = row_count1 + 2;
                row_count2 = row_count2 + 2;

            end

            %block(img_count, col_count)
            %point_count
            %row_count1
            %row_count2

            % col incrementation by 3 (xyz)
            startcol_count = startcol_count + 3;
            endcol_count = endcol_count + 3;

        end

        % Row incrementation by however many points are
        img_count = (img_count + 1);

    end
end