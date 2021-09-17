function [bi, bq, level] = level_transform(b,k,graycode)

% Input data to output symbol level is determined.
% First k bit data is transformed to I channel multi-level symbol
% and the next k bit data is transformed to Q channel multi-level symbol

bi=[];bq=[];  %initialization
level_max=2^k-1;  % maximum output level
level_min=-2^k+1; % minimum output level
level=level_min:2:level_max; % symbol level e.g. 64-QAM: [-7 -5 -3 -1 1 3 5 7]
scaled_level=level./sqrt(sum(level.^2)/2^(k-1)); % Level scaling

for i=1:2*k:length(b) 
    for j=1:length(graycode) 
        if(b(i:i+k-1) == graycode(j,:)) % Compare data and graycode
            bi=[bi scaled_level(j)]; % Determine symbol level
        end
        if(b(i+k:i+2*k-1)==graycode(j,:))
            bq=[bq scaled_level(j)];
        end
    end
end
