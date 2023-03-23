function [w, idx] = localTest(v, apvf, CvHat, criticalVal)
%the local test determines which measurements may contain blunders by
%inspecting the residuals 
%   The input parameters are: 
%       v - residuals 
%       apvf - a-priori variance factor 
%       CvHat - cofactor matrix
%       criticalVal - critical value of the Standard Normal distribution that
%       defines the acceptance region of a two-tailed hypothesis test
%       (anything larger than +-critical value is rejected)

Qv = (1/apvf)*CvHat; %cofactor matrix

vf = sqrt(apvf);
w = NaN(length(v),1);
fail = 0; %to indicate whether local test passed or failed
maxValue = 0; % for maximum value of local test
idx = 0;
for i = 1:1:length(v)
    w(i,1) = v(i)/(vf*sqrt(Qv(i,i))); % local test value
    
    if w(i,1) < -1*criticalVal || w(i,1) > criticalVal
        text = ['Task 2: ', num2str(w(i,1)), ' at index: ', num2str(i), ' is within the rejection region - local test failed.'];
        disp(text);
        fail = 1; %local test failed
        if abs(w(i,1)) > maxValue
            maxValue = abs(w(i,1));
            idx = i;
        end
    end
%     elseif w(i,1) >= -1*criticalVal && w(i,1) <= criticalVal
%         text = [num2str(w(i,1)), ' is within the acceptance region - local test passed.'];
%         disp(text);
%     end
end

if fail == 0
    disp('Task 2: Local test passed for all values');
    idx = NaN;
end
        
    
end

