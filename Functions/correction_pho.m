function [pho] = correction_pho(pho_prev, v)

% This function will do the correction to the original pho file

% Restoring point and ID information (as this wont change)
pho(:, 1:2) = pho_prev(:, 1:2);
    
%% Correcting Observations (pho)

% Finding number of observations
num_obs = size(pho_prev, 1);

% Storing correction values
% every 2nd value is a coordinate and we stop at the last (thus - 1)

pho(:,3) = pho_prev(:, 3) + v(1:2:num_obs*2 - 1); %vx
pho(:,4) = pho_prev(:, 4) + v(2:2:num_obs*2); %vy
