% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   Bandpass Simulation - MPSK -
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; close all;
Rb = 1000;  Tb = 1/Rb;      % Bit rate
fs = 20*Rb; ts = 1/fs;      % Sampling frequency
B = fs/2;                   % System bandwidth 
Ns = fs/Rb;                 % Number of samples per bit duration
nSymbol = 10^5;             % Total number of symbols => nBits = nSymbol * k
fc = 5000;                  % Carrier frequency
% ---------------------------------------------------------------

M_set = [4 8 16 32 64];
max_EbN0 = [12 16 20 24 30];

for M_len = 1:length(M_set)
    M = M_set(M_len);                % M = 2^k
    k = log2(M);                     % Number of bits per symbol
    B = fs/(2*k);                    % System bandwidth 
    % -------------------------------------------
    % MPSK Modulation
    % -------------------------------------------
    graycode = graycode_gen(k);       % Generate Gray code
    b = random_seq(nSymbol * k);
    [b_i b_q phase] = symbol2phase(k,b,graycode); % Symbol to phase mapping

    x_i = zeros(1,Ns*length(b_i));  x_q = zeros(1,Ns*length(b_q));
    for ii=1:length(b_i)
        for jj=1:Ns
            x_i((ii-1)*Ns+jj)=b_i(ii);
            x_q((ii-1)*Ns+jj)=b_q(ii);
        end
    end
    x_i=x_i(:)'; x_q=x_q(:)';
    N = length(x_i);      
    carrier_cos = carrier_gen(fc, fs, N);       % I-ch carrier
    carrier_sin = carrier_gen(fc, fs, N, -90);  % Q-ch carrier
    carrier_cos = carrier_cos(:)';  carrier_sin = carrier_sin(:)';

    xm_i = carrier_cos.*x_i;    xm_q = carrier_sin.*x_q;
    xm = xm_i + xm_q;
    % Determine signal amplitude assuming Eb = 1
    A = sqrt(2*Rb); % for MPSK
    xm = A*xm;      xm=xm(:)'; 
    
    EbNodB = 0:2:max_EbN0(M_len);
    b_hat_i=[];    b_hat_q=[];
    for n = 1:length(EbNodB)
       n 
       EbNo = 10^(EbNodB(n)/10);
       % Theoretical BER
       Pe_theory(M_len,n) = (2/k)*Q_funct(sqrt(2*k*EbNo)*sin(pi/M));
       noise_var = B/EbNo; 
       noise = gaussian_noise(0,noise_var,length(xm)); noise = noise(:)'; 
       r = xm + noise;  r = r(:)';  % Received signal
       % -------------------------------------------
       % M-PSK Demodulation with correlator
       % -------------------------------------------
       y_i = carrier_cos.*r;
       y_q = carrier_sin.*r;
       for index = 1:nSymbol
           b_hat_i_int(1,index)=sum(y_i(Ns*(index-1)+1:Ns*index));
           b_hat_q_int(1,index)=sum(y_q(Ns*(index-1)+1:Ns*index));
       end
       % Bit decision
       b_hat = mpsk_decision(b_hat_i_int, b_hat_q_int, graycode,M);
       % Count errors
       num_error = sum(abs(b-b_hat));  
       Pe(M_len,n) = num_error/(nSymbol*k);
    end
end
theory_shape=['k:';'c:';'r:';'b:';'g:'];
simul_shape=['k-x';'c-o';'r-*';'b-d';'g-s'];
for iii=1:length(M_set)
    semilogy(EbNodB, Pe_theory(iii,:), theory_shape(iii,:)), hold on;
    semilogy(EbNodB, Pe(iii,:), simul_shape(iii,:))
end
xlabel('Eb/No [dB]'); ylabel('Probability of bit error');
axis([-inf inf 10^(-5)  1]); grid on; 
legend('4-Theory', '4-Simulation','8-Theory', '8-Simulation','16-Theory',...
    '16-Simulation','32-Theory', '32-Simulation','64-Theory', '64-Simulation');
title('BER performance of MPSK')