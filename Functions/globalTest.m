function [T, isThereBlunder] = globalTest(v, P, apvf, criticalVal)
%globalTest uses the residuals from a least squares adjustment to determine
%if there are any blunders
%   The input parameters are:
%       v - the residuals 
%       P - the weight matrix
%       apvf - the a-priori variance factor 
%       criticalVal - the critical value in the Chi-square distribution for
%       a given degree of freedom (r) and significance level (alpha)

T = (v'*P*v)/apvf;

if T > criticalVal
    disp('Task 2: T > critical value. Global test failed - blunders exist');
    isThereBlunder = 1; % logical value of true

elseif T < criticalVal
    disp('Task 2: T < critical value. Global test passed - presence of blunders is unlikely');
    isThereBlunder = 0; % logical value of false
end
    
end

