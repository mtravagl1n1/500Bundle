function [BBcoordinates] = BBID(dicomdata,numberofBBs)
%BBID will return the location of the center of the BB pellets in the CT
%scan data.  These will be used as control points for the bundle adjustment

    for i=1:size(dicomdata)
        width=extractfield(dicomdata(i),'Width');
        height=extractfield(dicomdata(i),'Height');
        pic=extractfield(dicomdata(i),'Filename');
      
        %need to separate the filename and the file location
        l=1;

        for j=1:width 
            for k=1:height %loop through every row and every column to search for white BB pixels
                intensity_value=pic(j,k)
                if intensity_value==255 && pic(j,k+6)==255 % check to see if 6 pixels down is also white.  If it is, that is the largets BB size and that is what we want to use
                    %will need to figure out how many pixels a BB can cover
                    BBcoordinates(l,:)=[j+3,k+3];
                    l=l+1;
               
                end
                if l>=numberofBBs
                    break % if all 7 BBs have been found, break out of for loop
                end
                
                   
            end

        end

    end
    
end