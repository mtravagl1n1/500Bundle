function [pointsperpic] = pointcounter(pho)


imagepoints=unique(pho(:,2));


for i=1:length(imagepoints)
    
    pointsperpic(i) =sum(pho(:,2)==imagepoints(i));  %count number of points in each image

end
