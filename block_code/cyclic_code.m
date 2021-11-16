%% Cyclic_code 
% input paprameters:
% g = generator
% Lk = # of info bits(row vector)
% output parameters:
% u = enalbe all info bits
% v = enalbe all code
% dmin

function [u, v, dmin] = cyclic_code(g,Lk)
    Lr = length(g)-1;
    Ln = Lk+Lr;
    %% generated all enalbe info bits
    M = 2^Lk;
    xb = QADC([0:M-1]',Lk);
    u=[];
    for i = 1:M
        u = [u; xb((i-1)*Lk+1:i*Lk)'];
    end
    %% generated all enable codes
    for i = 1:M
        v(i,:) = rem(conv(u(i,:),g),2);
    end
    %% dmin
    dmin = min(sum(v(2:M,:)'));
end