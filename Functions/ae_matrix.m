function [ae] = ae_matrix(pho, sorted, n, ue)

% This function compiles the blocks of the ae matrix into its final form

% Obtain list of images as a vector
unique_images = pho(:, 2);
unique_images = unique(unique_images, 'rows');

ae = zeros(n, ue);

for j=1:size(unique_images, 1)
    
    % Stores the ID of image at i
    image_id = unique_images(j, 1);
    
	% Find points per image
    points = image_search(image_id, pho, sorted);
    
    % Build the Ae block and store in a cell array
    block{j} = Ae_block(points);
    
    % Create the block diagonals using the cell arrays
    ae = blkdiag(block{:});
    
end


