function [info] = DICOMread(foldername)

tf=true;
directory=foldername;

collection = dicomCollection(directory,"IncludeSubfolders",tf);
%% 

for i=1: size(collection)
    
    myPath = collection{i,14};

    info(i)=dicominfo(myPath);
end

end