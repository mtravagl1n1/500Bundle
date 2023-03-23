function [Agm,d] = Agmatrix(con,tie)
%Ag_partial computes the partial derivatives of the measured distance
%object points
%   Detailed explanation goes here



I=1; %identity for 1x1 P matrix
v_dist=1;
s1=con(1,:); % set S1 to be row containing first point used to measure scale distance
s2=con(2,:); % set s2 to be row containing second point used to measure scale distance

for i=1: size(con(:,1))
p(i)=con(i,1);

end
xi=s1(1);
yi=s1(2);
zi=s1(3);

xj=s2(1);
yj=s2(2);
zj=s2(3);


d=sqrt((xj-xi)^2+(yj-yi)^2+(zj-zi)^2);

%% Derivatives
dx1=(xj-xi)/d;
dy1=(yj-yi)/d;
dz1=(zj-zi)/d;
partial1=[dx1 dy1 dz1];


dx2=-dx1;
dy2=-dy1;
dz2=-dz1;
partial2=[dx2 dy2 dz2];


 


zeroblock=[0 0 0]; % set Ag to be filled with zeros and to the dimension ng x u0

row=1;
column=1;
for i=1:length(tie)+size(con,1)
    
    if i==2 
        Agblock{i}=partial1;

    elseif i==4
        Agblock{i}=partial2;
   
    else
        Agblock{i}=zeroblock;

    end

    
    


end
Agm=cell2mat(Agblock);



end