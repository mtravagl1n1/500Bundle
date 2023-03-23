function [e_ellipse] = err_ellipse(CvHat,pho)

k=1;

            for m=1:2:length(pho)


                    
                    a_squared=(CvHat(m,m)+CvHat(m+1,m+1) + sqrt((CvHat(m,m) - CvHat(m+1,m+1))^2 +4*(CvHat(m,m+1))^2))/2; % radius of major axis
                    b_squared=(CvHat(m,m)+CvHat(m+1,m+1) - sqrt((CvHat(m,m) - CvHat(m+1,m+1))^2 +4*(CvHat(m,m+1))^2))/2; % radius of minor axis

                    if CvHat(m,m+1)==0 && CvHat(m,m)>=CvHat(m+1,m+1)

                        beta=0;  % angle from positive x axis to ellipses maior axis in CCW in radians

                    elseif CvHat(m,m+1)==0 && CvHat(m,m)< CvHat(m+1,m+1)

                        beta=(pi/2);

                    else

                        beta=atan2(a_squared-CvHat(m,m),CvHat(m,m+1));

                    end

                    e_ellipse_a=sqrt(abs(a_squared));
                    e_ellipse_b=sqrt(abs(b_squared));
                    e_ellipse_beta=beta;
                    pho_x=pho(k,1);
                    pho_y=pho(k,2);


                

                 e_e(k)=ellipse(e_ellipse_a,e_ellipse_b,e_ellipse_beta, pho_x,pho_y,'b',300);
               
              k=k+1;
                
            end

                e_ellipse=e_e;

                
              
            

         

    
end

