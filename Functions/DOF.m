function [deg_of_free] = DOF(con,pho,u)
    
    num_of_obs=length(con)*3+length(pho)*2;
    num_of_unk=length(u);
    deg_of_free=num_of_obs-num_of_unk;

end

