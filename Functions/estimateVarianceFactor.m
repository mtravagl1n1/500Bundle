function [eVF] = estimateVarianceFactor(v, P, n, ue, uo)

    % This function calculates the estimated variance factor 
    eVF = (transpose(v)*P*v )/(n-(ue+uo));
    
    eVF = eVF / 2;
    
    
end
