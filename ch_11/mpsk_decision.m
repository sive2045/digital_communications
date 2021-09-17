function [b_hat] = mpsk_decision(b_hat_i, b_hat_q, graycode, M)

k=log2(M);
tan_val=(b_hat_q./b_hat_i);% tan(th)=sin(th)/cos(th)
phase=(M/2-1)*pi/M:-2*pi/M:pi/M;% threshold phase vector
thr=tan(phase); % threshold tan value
thr_=[inf thr]; % modify threshold
for ii=1:length(b_hat_q)
    if(b_hat_q(ii) >= 0 & b_hat_i(ii) >= 0)%I(t) > 0 and Q(t) > 0
        for n=1:M/4+1
            if(tan_val(ii) <= thr_(n))
                seq(ii)=2^(k-2)-n+2;
            end
        end
    else if(b_hat_q(ii) >= 0 & b_hat_i(ii) <= 0)%I(t) < 0 and Q(t) > 0
        for n=1:M/4+1
            if(abs(tan_val(ii)) <= thr_(n))
                seq(ii)=2^(k-2)+n;
            end
        end
        else if(b_hat_q(ii) <= 0 & b_hat_i(ii) <= 0)%I(t) < 0 and Q(t) < 0
            for n=1:M/4+1
                if(abs(tan_val(ii)) <= thr_(n))
                    seq(ii)=2^(k-2)-n+M/2+2;
                end
            end
            else if(b_hat_q(ii) <= 0 & b_hat_i(ii) >= 0)%I(t) > 0 and Q(t) < 0
                     for n=1:M/4+1
                        if(abs(tan_val(ii)) <= thr_(n))
                            seq(ii)=2^(k-2)*3+n;
                        end
                    end
                end
            end
        end
    end
end
b_hat=zeros(1,length(seq)*k);
for ii=1:length(seq)% end sector's graycode == first sector's graycode
    if(seq(ii)==M+1)
        seq(ii)=1; %first sector
    end
    b_hat(1,(ii-1)*k+1:ii*k)=graycode(seq(ii),:); % Mapping sector's sequence to graycode's bitstream
end


