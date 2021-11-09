%% Entropy function
% input parameter :
% p ; previous prob(row verctor)
% output parameter :
% H ; previous entropy

function H = cal_entropy(p)
    if length(find(p<0))~=0
        error('prob value must be positive!');
    end
    
    if abs(sum(p)-1)>10e-10
        error('sum of prob must be 1!')
    end
    
    H = sum(-p.*log2(p));
end