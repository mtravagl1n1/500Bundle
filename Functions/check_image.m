function [check] = check_image(pho)
    
% This function sorts through pho and figures out which points show up in
% which image. If a point isn't present, it will save a zero

% The format is
% row   col   col
% pt#   img#  img
% pt#   img#  img
    
    % Look through pho to get point numbers
    point_check = pho(:,1);
    % Keep unique point numbers
    point_check = unique(point_check, 'rows');
    
    % Look through pho to get image numbers
    image_check = pho(:, 2);
    % Keep unique image numbers
    image_check = unique(image_check, 'rows');
    
    % Fill with zeros
    check = zeros(length(point_check), 5);

    % Look through pho
    for i=1:length(pho)
        
        % Look through our points
        for j=1:length(point_check)

            % Look through our images
            for k=1:length(image_check)

                % If the point is in pho and the image is in pho
                if pho(i, 1) == point_check(j, 1) && pho(i, 2) == image_check(k, 1)
                  
                    % Save the point number in the row and the image number
                    % in column
                    check(j, 1) = point_check(j, 1);
                    check(j, k + 1) = image_check(k, 1);

                end
            end
        end
    end
    
    % Any image that is not found will leave a zero

end