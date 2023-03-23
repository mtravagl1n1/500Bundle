function [delta, delta_EOP, delta_OP, delta_IOP] = delta(N, u, ue, uo, ui, lab)

    % Function to compute the delta vectors

    % Full vector
    delta = -N^-1*u;

    if lab == "Lab 1"

        % For EOP and OP
        delta_EOP = delta(1:ue);
        delta_OP = delta(ue + 1:ue+uo);
        delta_IOP = NaN;
    end

    if lab == "Lab 2" 
        
        % Retrieve the eop deltas (1 to ue)
        delta_EOP = delta(1:ue);
        
        % Retrieve the IOP delta (ue + 1 to ue + ui)
        delta_IOP = delta(ue + 1:ue + ui);

        % Retrieve the OP delta (ue + ui + 1 to end)
        delta_OP = delta(ue + ui + 1:end);
    end

        if lab =="Lab 3"
        
        % Retrieve the eop deltas (1 to ue)
        delta_EOP = delta(1:ue);
        
       % Retrieve the OP delta (ue + ui + 1 to end)
        delta_OP = delta(ue  + 1:ue+uo);

        delta_IOP=NaN;


        end
end