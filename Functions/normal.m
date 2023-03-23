function [N, U] = normal(ae, ao, ai, ag, P, Po, Pg, w, wo, wg, lab)

    % Create the N Matrix elements
    Nee = transpose(ae)*P*ae;
    Nei = transpose(ae)*P*ai;
    Neo = transpose(ae)*P*ao;

    Nii = transpose(ai)*P*ai; 
    Nio = transpose(ai)*P*ao;
    Noo = (transpose(ao)*P*ao) + Po;
    
    
    Nei_T = transpose(Nei);
    Neo_T = transpose(Neo);
    Nio_T = transpose(Nio);


    % Create elements of u vector
    u_top = transpose(ae)*P*w;
    u_middle = transpose(ai)*P*w;
    u_bottom = transpose(ao)*P*w + Po*wo;
    

    % Check the lab number
    if lab == "Lab 1"
        

        % Build N Matrix
        N = [Nee, Neo; Neo_T, Noo];
        
        % Build U Matrix
        U = [u_top; u_bottom];

    end

    if lab == "Lab 2"

        N = [Nee, Nei, Neo; Nei_T, Nii, Nio; Neo_T, Nio_T, Noo];
        U = [u_top; u_middle; u_bottom];

%         N = [ae.'*P*ae, ae.'*P*ai, ae.'*P*ao; (ae.'*P*ai).', ai.'*P*ai, ai.'*P*ao; (ae.'*P*ao).', (ai.'*P*ao).', ao.'*P*ao+Po];
%         U = [ae.'*P*w; ai.'*P*w; ao.'*P*w+Po*wo];

    end

    if lab =="Lab 3"
        u_bottom_g=transpose(ao)*P*w + transpose(ag)*wg;
        Noo_g=(transpose(ao)*P*ao)+transpose(ag)*ag;


        N=[Nee, Neo;Neo_T Noo_g];
        U=[u_top; u_bottom_g];



    end





end