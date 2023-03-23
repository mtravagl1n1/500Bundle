function [v, ve, vi, vo] = v_residuals(ae, ao, ai, uo, ue, ui, w, wo, delta, delta_EOP, delta_IOP, delta_OP, lab)

% This function computes and stores the residuals

if lab == "Lab 1"

    % Full vector of all residuals
    v = [ae, ao; zeros(uo, ue), eye(uo, uo)]*delta + [w; wo];
    
    % Storing into vo and v vectors
    vo = v(size(ae, 1) + 1:size(ae, 1) + uo)
    ve = v(1:size(ae, 1));
    vi = NaN;
    v = ve;

end

if lab == "Lab 2"

    % Full vector of all residuals
    v = (ae*delta_EOP) + (ai*delta_IOP) + (ao*delta_OP) + w;

    % ve is from 1 to ue
    ve = v(1:ue*2);

    vi = v(ue + 1: ue + ui);

    vo = v(ue + ui + 1:end);

%     % ve is from 1 to ue
%     ve = v(1:ue);
% 
%     vi = v(ue + 1:ue + ui);
% 
%     vo = v(ue + ui + 1:ue + uo + ui);

end

end