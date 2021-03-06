%% Block code
% input parameter :
% P ; parity matrix
% output parameter :
% u ; possible word
% v ; possible codeword
% dmin ; minimum distance between codes


function [u, v, dmin]=block_code(P)

    [Lk, Lr] = size(P);
    G=[eye(Lk) P];

    M=2^Lk;
    xb = QADC([0:M-1]', Lk);
    u=[];
    for i=1:M
        u=[u;xb((i-1)*Lk+1:i*Lk)'];
    end

    v = rem(u*G, 2);

    dmin=min(sum(v(2:M,:)'));
end