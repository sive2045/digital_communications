function [ich, qch, phase] = symbol2phase(k, data, graycode)
% M-ary symbol to phase mapping (M = 2^k)
% Gray code is used for symbol mapping

for index = 1:length(data)/k    % Number of symbols in data
    symbol = data(k*(index-1)+1:k*index);
    for ii = 1:length(graycode)
        if(graycode(ii, :) == symbol)
            val(index,:) = ii-1;
        end
    end
end
phase = (2*pi/2^k)*val;
ich = cos(phase);
qch = sin(phase);