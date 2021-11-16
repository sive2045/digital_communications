%% sys_cyclic_code 
% input parameters:
% g = generator row vector
% Lk = # of info bit
% output parameters:
% Gsys = generator matrix
% u = enalbe all info bits
% v = enalbe all codes
% dmin

function [Gsys,u,v,dmin] = sys_cyclic_code(g, Lk)
    Lr = length(g)-1;
    Ln = Lk+Lr;
    %% generator matrix
    G = zeros(Lk,Ln);
    for i = 1:Lk
        G(i, i:i+Lr) = g;
    end
    %% sys of generator matrix
    while any(any(G(:, 1:Lk)~=eye(Lk)))
        [[1:Lk]' G(:, 1:Lk)]
        arrange=input('arrange=');
        G(arrange(3), :) = xor(G(arrange(1), :), G(arrange(2), :));
    end
    Gsys = G
    disp('발생기 행렬의 조직화 종결!')
    %% generate enable all info bit
    M = 2^Lk;
    xb = QADC([0:M-1]', Lk);
    u = [];
    for i = 1:M
        u = [u; xb((i-1)*Lk+1:i*Lk)'];
    end
    %% generate enable all code
    v = rem(u*G,2);
    dmin = min(sum(v(2:M, :)'));
end