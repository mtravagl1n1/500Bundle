function output(v,R,v_standard,RMSx,RMSy,unique_image, ppp,pho,eVF,dim_quant, STDx,STDy,vx,vy,int,ext,orig_sorted,stddev,con,tie)

%CvHat- residuals
%R- redundancy numbers
%v_standard- standardized residuals
%RMSx,y- RMS
%unique_image- name of each unique image
%ppp- points per image
%pho-pho
format longG

fid=fopen('Output.txt','w');
d=datetime("now");




fprintf(fid,'ENGO500 Capstone ');
fprintf(fid,'\n');
fprintf(fid,'Matthew Travaglini');
fprintf(fid,'\n');
fprintf(fid,'\n===================================================\n');
fprintf(fid,'University of Calgary 2022/2023');
fprintf(fid,'\n\n');
fprintf(fid,'\n===================================================\n');
fprintf(fid,'Execution Date and Time: ');
fprintf(fid,'%s',d);
fprintf(fid,'\n\n');
fprintf(fid,'\n===================================================\n');
fprintf(fid,'\n OBSERVATIONS/UNKNOWNS SUMMARY\n');
fprintf(fid,'\n===================================================\n');

cameras=length(unique(int(:,1)));


fprintf(fid,'%-40s','Number of Cameras used : ');
fprintf(fid,'%-3g',cameras);
fprintf(fid,'\n');
fprintf(fid,'%-40s','Number of EOPs : ');
fprintf(fid,'%-3g',dim_quant(1));
fprintf(fid,'\n');
fprintf(fid,'%-40s','Number of OPs : ');
fprintf(fid,'%-3g',dim_quant(2));
fprintf(fid,'\n');
fprintf(fid,'%-40s','Number of Tie Points : ');
fprintf(fid,'%-3g',dim_quant(3));
fprintf(fid,'\n');
fprintf(fid,'%-40s','Number of Control Points : ');
fprintf(fid,'%-3g',dim_quant(4));
fprintf(fid,'\n');
fprintf(fid,'\n---------------------------------------------------\n');
fprintf(fid,'%-40s','Total Number of Unknowns : ');
fprintf(fid,'%-3g',dim_quant(5));
fprintf(fid,'\n\n\n');
fprintf(fid,'%-40s','Number of Observed Image Points : ');
fprintf(fid,'%-3g',dim_quant(6));
fprintf(fid,'\n');
fprintf(fid,'\n---------------------------------------------------\n');
fprintf(fid,'%-40s','Degrees of Freedom : ');
fprintf(fid,'%-3g',dim_quant(7));
fprintf(fid,'\n\n\n\n');
fprintf(fid,'\n===================================================\n');

%% Exterior Orientation Input Data
fprintf(fid,'\n===================================================\n');
fprintf(fid,'\n EXTERIOR ORIENTATION INPUT DATA\n');
fprintf(fid,'\n===================================================\n');

for m=1:size(ext(:,1))
   
    fprintf(fid,'%-20s','Image');
    fprintf(fid,'%-3d\n',ext(m,1));
    ext(m,1);
    fprintf(fid,'%-20s','Camera');
    fprintf(fid,'%-3d\n',ext(m,2));
    ext(m,2);
    fprintf(fid,'\n======================\n');
    fprintf(fid,'%-40s','Number of Image Point Observations');
    fprintf(fid,'%3g\n',ppp(m));
    fprintf(fid,'%-20s','Xc');
    fprintf(fid,'%7.3f\n',ext(m,3));
    fprintf(fid,'%-20s','Yc');
    fprintf(fid,'%7.3f\n',ext(m,4));
    fprintf(fid,'%-20s','Zc');
    fprintf(fid,'%7.3f\n',ext(m,5));
    fprintf(fid,'%-20s','Omega');
    fprintf(fid,'%7.3f\n',ext(m,6));
    fprintf(fid,'%-20s','Phi');
    fprintf(fid,'%7.3f\n',ext(m,7));
    fprintf(fid,'%-20s','Kappa');
    fprintf(fid,'%7.3f\n\n',ext(m,8));
     fprintf(fid,'======================\n');
    
    
    
end


%% Interior Orientation Input Data
fprintf(fid,'\n===================================================\n');
fprintf(fid,'\n INTERIOR ORIENTATION INPUT DATA\n');
fprintf(fid,'\n===================================================\n');

for m=1:size(int(:,1))
   
    fprintf(fid,'%-20s','Camera');
    fprintf(fid,'%-3d\n',int(m,1));
    fprintf(fid,'\n======================\n');
    fprintf(fid,'%-20s','Xp');
    fprintf(fid,'%7.3f\n',int(m,2));
    fprintf(fid,'%-20s','Yp');
    fprintf(fid,'%7.3f\n',int(m,3));
    fprintf(fid,'%-20s','c');
    fprintf(fid,'%7.3f\n',int(m,4));
   
     fprintf(fid,'======================\n');
    
    
    
end
format short g
%% Observed photo coordinate data
fprintf(fid,'\n===================================================\n');
fprintf(fid,'\n OBSERVED PHOTO COORDINATE DATA\n');
fprintf(fid,'\n===================================================\n');

start=1;
observed_header=['pt  ','  type ','    x  ','    y  ','    sd x  ','    sd y  '];
for i=1:length(ppp)
     fprintf(fid,'\n\n');

    fprintf(fid,'%-20s','Image');
    fprintf(fid,'%-3d',ext(i,1));
    fprintf(fid,'\n===============================\n');
    fprintf(fid,'%3s\n',observed_header);

    for j=start:ppp(i)+start-1

        if orig_sorted(j,17)==1
            fprintf(fid,'%-5g ',orig_sorted(j,15));
            fprintf(fid,'%-5s ','TIE ');
            fprintf(fid,'%-4.3f  ',orig_sorted(j,13));
            fprintf(fid,'%-4.3f  ',orig_sorted(j,14));
            fprintf(fid,'%-4.3f  ',stddev);
            fprintf(fid,'%-4.3f  \n',stddev);
            %fprintf(fid,'\n\n');

        elseif orig_sorted(j,17)==2
            fprintf(fid,'%-5g ',orig_sorted(j,15));
            fprintf(fid,'%-5s ','CNT ');
            fprintf(fid,'%-4.3f  ',orig_sorted(j,13));
            fprintf(fid,'%-4.3f  ',orig_sorted(j,14));
            fprintf(fid,'%-4.3f  ',stddev);
            fprintf(fid,'%-4.3f  \n',stddev);
            %fprintf(fid,'\n\n');

            
        end



    end
    start=ppp(i)+start;
end
fprintf(fid,'\n\n\n\n');

%% Control point Input
fprintf(fid,'\n===================================================\n');
fprintf(fid,'\n CONTROL POINT INPUT DATA\n');
fprintf(fid,'\n===================================================\n');
observed_header=['pt  ','    X  ','   Y  ','  Z  ','   sd X  ','    sd Y  ',' sd Z'];
fprintf(fid,'%3s\n',observed_header);

for i=1:length(con)
    fprintf(fid,'%-3g  ',con(i,1));
   % fprintf(fid,'%-3g  ',ppp(i)); %count number of times control point shows up in images
    fprintf(fid,'%-4.3f  ',con(i,2));
    fprintf(fid,'%-4.3f  ',con(i,3));
    fprintf(fid,'%-4.3f  ',con(i,4));
    fprintf(fid,'%-4.3f  ',stddev);
    fprintf(fid,'%-4.3f  ',stddev);
    fprintf(fid,'%-4.3f  \n',stddev);


end
%% Tie point Input
fprintf(fid,'\n===================================================\n');
fprintf(fid,'\n TIE POINT INPUT DATA\n');
fprintf(fid,'\n===================================================\n');
observed_header=['pt  ','    X  ','   Y  ','  Z  '];
fprintf(fid,'%3s\n',observed_header);

for i=1:length(con)
    fprintf(fid,'%-3g  ',con(i,1));
    %fprintf(fid,'%-3g  ',ppp(i));
    fprintf(fid,'%-4.3f  ',con(i,2));
    fprintf(fid,'%-4.3f  ',con(i,3));
    fprintf(fid,'%-4.3f  ',con(i,4));
    fprintf(fid,'%-4.3f  ',stddev);
    fprintf(fid,'%-4.3f  ',stddev);
    fprintf(fid,'%-4.3f  \n',stddev);


end
fprintf(fid,'\n\n');

%% RMS
loops=length(ppp);
j=1;

    for i=1:loops
       % output(i)
       image_header='Image';
       %image_num= unique_image(i);
       col_header=[' PID ', '  vx   ', '  vy    ', '  rx    ',' ry   ','   wx   ','   wy   '];
       %spacer='--------------------------------------------';
       RMS(i,1:2)=[RMSx(i),RMSy(i)];
       RMS_name='RMS';
    end
    
    
    for i=1:length(pho)
           
            bundle_outputs(i,:)=round([pho(i,1),v(j),v(j+1), R(j,j),R(j+1,j+1), v_standard(j),v_standard(j+1)],3);
            
            j=j+2;
            
      
    end
       
start=1;
%% for loop to place image number, column header and all values in tables for each image
fprintf(fid,'Image Point Residuals, Redundancy Numbers, and Standardized Residuals');
fprintf(fid,'\n');

for j=1:loops
    pp=start+ppp(j);
    
    fprintf(fid,'\n\n%s ',image_header);
    
    fprintf(fid,'%g\r\n\n',unique_image(j));
    
    fprintf(fid,'===================================================\n');
    fprintf(fid,' %-s\n\n',col_header);
    bundle_outputs_round=round(bundle_outputs,3);
    
        for i=start:1:pp-1
 
            fprintf(fid,' % 3.3g  % 3.3f ' , bundle_outputs_round(i,:));
            fprintf(fid,'\n');

        end
        start=pp;
        
        fprintf(fid,'\n%s ',RMS_name); % add RMS at the end of each table
        RMS_round=round(RMS,3);
        fprintf(fid,'\n---------------------------------------------------\n');
        fprintf(fid,'%2.3g  ',RMS_round(j,1:2));
        fprintf(fid,'\n---------------------------------------------------\n');
        fprintf(fid,'\n');
        
end


%% estimated variance factor
EVF='Estimated Variance Factor';
fprintf(fid,'\n\n\n\n%s : ',EVF);
eVF_round=round(eVF,3);
fprintf(fid,'%.4f',eVF_round);
fprintf(fid,'\n===================================================\n');
fprintf(fid,'\n\n\n\n');

fprintf(fid,'The Estimated Parameters');
fprintf(fid,'\n');

 col_header=[' PID ', '   x   ', '   y    '];

 
start=1;
for j=1:loops
    
    pp=start+ppp(j);
    
    fprintf(fid,'\n\n%s ',image_header);
    
    fprintf(fid,'%g\r\n\n',unique_image(j));
    
    fprintf(fid,'===================================================\n');
    fprintf(fid,'%-s\n\n',col_header);
    
        for i=start:1:pp-1
 
            fprintf(fid,'%3.3f   ' , pho(i,1),pho(i,3),pho(i,4));
            fprintf(fid,'\n');

        end
        start=pp;
        
end

fprintf(fid,'\n\n');
fprintf(fid,'The Standard Deviation and variances of estimated parameters');
fprintf(fid,'\n');
 col_header=[' PID ',  'STD x  ', '  STD y  ',' var x',' var y '];
for j=1:loops


fprintf(fid,'\n\n%s ',image_header);
    
    fprintf(fid,'%g\r\n\n',unique_image(j));
    
    fprintf(fid,'===================================================\n');
    fprintf(fid,'%-s\n\n',col_header);

for i=1:ppp(j)

 %fprintf(fid,'%3.3f   ',pho(i,1),STDx(j,i), STDy(j,i),vx(j,i),vy(j,i));
 fprintf(fid,'\n');

end


end





fclose(fid);     
       

    



    end



