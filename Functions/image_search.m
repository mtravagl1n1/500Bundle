function [sorted_image] = image_search(search_for, pho, sorted)

    % This function searches through "sorted" for a particular image and
    % returns the sorted values for that image

    % Obtain list of images
    image_check = pho(:, 2);
    image_check = unique(image_check, 'rows');

    % Need to find how many time a particular image will appear
    image_check(:, 2) = histc(pho(:, 2), image_check);

    % What image we are looking for
    % search_for = 13;

    % Saves the total number of rows, previous to the one we are looking for
    total_rows = 0;
    
    % This is an error boolean, it will become true if the image is found
    image_found = false;

    % Loop through images
    for i=1:size(image_check, 1)

        % If we find the image we are searching for
        if image_check(i, 1) == search_for

            % The row it begins on
            start_row = total_rows;

            % How many times it occurs
            occurance = image_check(i, 2);
            
            % Set boolean to true
            image_found = true;
            
        end

        % Increment total_rows to know how many rows are previous the one
        % we found
        total_rows = total_rows + image_check(i, 2);

    end
    
    % If we didn't find the image, present user with error
    if image_found == false
        
        disp("Error - Image_Search.m: The image specified was not found in the dataset.");
        disp(strcat("You searched for image ", num2str(search_for)));
        
    end

    % Returns the desired matrix
    sorted_image = sorted(start_row + 1:occurance + start_row, :);

end

