function [wpk] = angle_extract(data)
%anlge_extract retreives orientation angles of the C arm from the DICOM
%data
    
        
        k=extractfield(data,'PositionerPrimaryAngle');
        p=zeros([1,length(data)]);
        w=extractfield(data,'PositionerSecondaryAngle');
    
    wpk=[w;p;k];

end