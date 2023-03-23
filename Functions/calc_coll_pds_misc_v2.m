function [ae_2x6,ao_2x3,ai_2x3,w_2x1]=calc_coll_pds_misc_v2(XYZc,wpk,XYZ,xpypc,xy_obs,lhs)
% function to compute the partial derivatives of the collinearity equations
% and the misclosure elements
% 
% Derek Lichti, The University of Calgary 2022
%
% INPUTS:
%   XYZc        3x1 vector of perspective centre coordinates
%               usually in mm or m
%   wpk         3x1 vector of rotation angles in radians
%   XYZ         3x1 vector object point (tie or control) coordinates
%               usually in mm or m (same units as XYZc)
%   xpypc       3x1 basic IOPs: principal point and principal distance
%               usually in mm, um or pixels
%               shoudl have the same units as the image point observations
%   xy_obs      2x1 vector of observations
%               usually in mm, um or pixels
%               should have the same units as the basic IOPs
%   lhs         should be 0 if the image coordinate system is right-handed,
%               nonzero if it is left-handed
% OUTPUTS:
%   ae_2x6      2x6 matrix of partial derivatives wrt the EOPs
%               column order: Xc Yc Zc w p k
%               row order: x y
%   ao_2x3      2x3 matrix of partial derivatives wrt the object point
%               coordinates
%               column order: X Y Z
%               row order: x y
%   ai_2x3      2x3 matrix of partial derivatives wrt the IOPs
%               column order: xp yp c
%               row order: x y
%   w_2x1       2x1 vector of misclosures (computed x,y - observed x,y)
%               row order: x y
%               units: mm, um or pixels

if (lhs)
    K=-1;
else
    K=1;
end

% compute M
w=wpk(1);
p=wpk(2);
k=wpk(3);

R1=[ 1 0 0 ; 0 cos(w) sin(w) ; 0 -sin(w) cos(w) ];
R2=[ cos(p) 0 -sin(p) ; 0 1 0 ; sin(p) 0 cos(p) ];
R3=[ cos(k) sin(k) 0 ; -sin(k) cos(k) 0 ; 0 0 1 ];

M=R3*R2*R1;

% compute UVW
dXYZ=XYZ-XYZc;
UVW=M*dXYZ;

% compute misclosure
xp=xpypc(1);
yp=xpypc(2);
c=xpypc(3);
x_comp=xp-c*UVW(1)/UVW(3);
y_comp=yp-c*UVW(2)/UVW(3)*K;

w_2x1=[ x_comp-xy_obs(1) ; y_comp-xy_obs(2) ];

% EOP PDs
ae_2x6(1,1)=-c/UVW(3)^2*(M(3,1)*UVW(1)-M(1,1)*UVW(3));
ae_2x6(1,2)=-c/UVW(3)^2*(M(3,2)*UVW(1)-M(1,2)*UVW(3));
ae_2x6(1,3)=-c/UVW(3)^2*(M(3,3)*UVW(1)-M(1,3)*UVW(3));

ae_2x6(1,4)=-c/UVW(3)^2*(dXYZ(2)*(UVW(1)*M(3,3)-UVW(3)*M(1,3))...
    -dXYZ(3)*(UVW(1)*M(3,2)-UVW(3)*M(1,2)));
ae_2x6(1,5)=-c/UVW(3)^2*(dXYZ(1)*(-UVW(3)*sin(p)*cos(k)-UVW(1)*cos(p))...
    +dXYZ(2)*(UVW(3)*sin(w)*cos(p)*cos(k)-UVW(1)*sin(w)*sin(p))...
    +dXYZ(3)*(-UVW(3)*cos(w)*cos(p)*cos(k)+UVW(1)*cos(w)*sin(p)));
ae_2x6(1,6)=-c*UVW(2)/UVW(3);

ae_2x6(2,1)=K*(-c/UVW(3)^2*(M(3,1)*UVW(2)-M(2,1)*UVW(3)));
ae_2x6(2,2)=K*(-c/UVW(3)^2*(M(3,2)*UVW(2)-M(2,2)*UVW(3)));
ae_2x6(2,3)=K*(-c/UVW(3)^2*(M(3,3)*UVW(2)-M(2,3)*UVW(3)));

ae_2x6(2,4)=K*(-c/UVW(3)^2*(dXYZ(2)*(UVW(2)*M(3,3)-UVW(3)*M(2,3))...
    -dXYZ(3)*(UVW(2)*M(3,2)-UVW(3)*M(2,2))));
ae_2x6(2,5)=K*(-c/UVW(3)^2*(dXYZ(1)*(UVW(3)*sin(p)*sin(k)-UVW(2)*cos(p))...
    +dXYZ(2)*(-UVW(3)*sin(w)*cos(p)*sin(k)-UVW(2)*sin(w)*sin(p))...
    +dXYZ(3)*(UVW(3)*cos(w)*cos(p)*sin(k)+UVW(2)*cos(w)*sin(p))));
ae_2x6(2,6)=K*(c*UVW(1)/UVW(3));

% object point PDs
ao_2x3=-ae_2x6(:,1:3);

% IOP PDs
ai_2x3=[ 1 0 -UVW(1)/UVW(3) ;
    0 1 -UVW(2)/UVW(3)*K ];



