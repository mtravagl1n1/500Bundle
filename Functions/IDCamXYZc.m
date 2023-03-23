function [XYZc] = IDCamXYZc(angles,int)
%XYZc computes the coordinates from the rotation angles and the radius of
%the C arm rotation
%angles input as w p k 
% need w and phi for transformation\
r=int(4);
phi=angles(:,1);
theta=angles(:,3);
    for i=1:size(angles)
        Xc=r*sind(phi(i))*cosd(theta(i));
        Yc=r*sind(phi(i))*sind(theta(i));
        Zc=r*sind(theta(i));

        XYZc(i,:)=[i,55,Xc,Yc,Zc];
    end 
end