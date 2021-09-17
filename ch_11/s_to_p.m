function [x_odd, x_even] = s_to_p(x, delay)
% serial to parallel conversion

x_odd = []; x_even = [];
if (nargin == 1) % No delay
    len = length(x)/2;
    for i = 1:len
        x_odd = [x_odd x(2*i-1) x(2*i-1)];
        x_even = [x_even x(2*i) x(2*i)];
    end
else
    len = length(x)/2 - 1;
    for i = 1:len
        x_odd = [x_odd x(2*i-1) x(2*i+1)];
        x_even = [x_even x(2*i) x(2*i)];
    end
end
