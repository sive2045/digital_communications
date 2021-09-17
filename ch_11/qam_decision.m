function [b_hat] = qam_decision(b_hat_i, b_hat_q ,level,graycode,k)

 b_hat=[]; %initialization
level_mid=level(1)+1:2:level(end)-1;% threshold vector i.e. 64-QAM : [-6 -4 -2 0 2 4 6]
level_mid=level_mid./sqrt(sum(level.^2)/2^(k-1));% scaling

seq_i=ones(1,length(b_hat_i)); % if (b_hat_i < level_mid(1)) then seq_i='1'
seq_q=ones(1,length(b_hat_i)); 
for ii=1:length(b_hat_i); 
    for jj=1:length(level_mid)
        if(b_hat_i(ii) >= level_mid(jj))
            seq_i(ii)=jj+1;
        end
        if(b_hat_q(ii) >= level_mid(jj))
            seq_q(ii)=jj+1;
        end
    end
end

%-------------Decision sequence--------------------------
seq(1:2:2*length(b_hat_i))=seq_i(:);
seq(2:2:2*length(b_hat_q))=seq_q(:);

%-----Decision sequence to bit---------------------------
for ii=1:length(seq)
    b_hat=[b_hat; graycode(seq(ii),:)'];
end
b_hat=b_hat(:)'; % Make b_hat be column vector