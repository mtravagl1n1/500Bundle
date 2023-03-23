function [RMSx,RMSy,STDx,STDy,vx1,vy1] = RMS(v,pho)

% This function computes the RMS, STD and seperated residuals

% This fuction has been re-coded in way to retain the format of its
% original outputs

% Output format
% RMSx img 1x img 2x img 3x...
% RMSy img 1y img 2y img 3y...

% Returns the number of points per each image
image_points = pointcounter(pho);

% Total number of images
images = size(image_points,2);

% Retrieve all x residuals
vx1 = v(1:2:end, 1);

% Retrieve all y residuals
vy1 = v(2:2:end, 1);

% Compute the square residuals
vx_s = vx1.^2;
vy_s = vy1.^2;
v_s = v.^2;

% To maintain backwards compatibility with original programming
% Creates 0 matrix row wise per image and col wise by max number of
% possible points
% vx = zeros(images, max(image_points));
% vy = zeros(images, max(image_points));

% Store index using the image point (for example 10th point for first image
% is index 20 in vy (for lab 1)
startpoint = 1;
endpoint = image_points(1, 1);

% Calculate the standard deviations of all residuals
for i=1:1:size(v, 1)

    STD(i, 1) = sqrt(abs(v(i)));

end

% For each image

for j=1:1:images

    for i=startpoint:1:endpoint

        sum_vx(1, j) = sum(vx_s(startpoint:endpoint, 1)); % Store vx^2 for each image as col vector
        sum_vy(1, j) = sum(vy_s(startpoint:endpoint, 1)); % Store vy^2 for each image as col vector

        RMSx(1, j) = sqrt(sum_vx(1, j)/image_points(1, j));
        RMSy(1, j) = sqrt(sum_vy(1, j)/image_points(1, j));

%         for k=1:1:size(vx, 2)
% 
%             vx(j, k) = vx1(startpoint+i, 1);
%             vy(j, k) = vy1(startpoint+i, 1);
% 
%         end

    end

    % Updating the index counters
    startpoint = endpoint + 1; % The new startpoint is one index after last endpoint
    
    % We already stored the first sum of images so we want to add the next
    % one to it
    if j < images
        endpoint = endpoint + image_points(1, j + 1); % 
    
    % Once j = images, we can just sum the total (otherwise we go over
    % index)
    else
        endpoint = sum(image_points); % The new endpoint is the last ep + the total number of points next
    end

end

% To maintain original programming compatiblity

% Retrieve all x std
STDx = STD(1:2:end, 1);

% Retrieve all y std
STDy = STD(2:2:end, 1);


% start=1;
% 
% 
% ppp=pointcounter(pho);
% stdx=[];
%  stdy=[];
%     for j=1:length(ppp)
%          pp=start+ppp(j)*2;
%          counter=1;
%          
%         for i=start:2:pp-1
% 
%             v_x(counter) = v(i); % sort variance into two vectors, one for x and one for y
%             v_y(counter)= v(i+1);
%             counter=counter+1;
%             
%             
%         end
% 
%             
%         for i=1:length(v_x)
% 
%             vx(j,i)=v_x(i);
%             vy(j,i)=v_y(i);
%             STDx(j,i)=sqrt(abs(v_x(i)));
%             STDy(j,i)=sqrt(abs(v_y(i)));
% 
%         end
% 
%         for i=1:length(v_x)
%             
%            v_x_s(i)=v_x(i)^2 ;
%            v_y_s(i)=v_y(i)^2; 
%             
%         end
%         v_x_s;
%         v_y_s;
%         start=pp;
%         sumvx=sum(v_x_s);
%         sumvy=sum(v_y_s);
%         RMSx(j)=sqrt(sumvx/length(v_x));
%         RMSy(j)=sqrt(sumvy/length(v_y));
%       
%         v_x=[];
%         v_y=[];
% %            
%     end




end
