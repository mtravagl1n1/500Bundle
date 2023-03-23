function [IOP] = int_maker(data)
%int_maker retrieves source image detector distance from DICOM file and
%creates an int file
%   Detailed explanation goes here
% input format camera, Xp,Yp,C
C=extractfield(data,'DistanceSourceToDetector');
IOP=[1,0,0,C(1)];

end