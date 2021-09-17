% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Bandpass Simulation - QAM -
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; close all;
Rb = 1000;  Tb = 1/Rb;    % Bit rate
oversample=10;            % Over sampling factor
fs = 2*Rb*oversample;     % Sampling frequency
B = fs/2;                 % System bandwidth 
Ns = fs/Rb;               % Number of samples per bit duration
fc = 5000;                % Carrier frequency
% ---------------------------------------------------------------
M_set = [4 16 64 256 1024 4096];  % M-ary symbol  
max_EbN0 = [12 16 20 26 28 34];       % Maximum Eb/No
nSymbol = 10^5;          % Total number of samples : nBits=nSymbol*2*k

for M_len=1:length(M_set)
    M = M_set(M_len);               % M = 2^(2k)
    k = log2(M)/2;                  % one symbol = 2*k bits
    B = fs/(4*k);                   % System bandwidth 
    % ---------------------------------------------------------------------
    % QAM Modulation
    % ---------------------------------------------------------------------
    graycode = graycode_gen(k);      % Generate Gray code
    b = random_seq(nSymbol * 2*k);
    [b_i b_q level] = level_transform(b,k,graycode);
    % Pulse shaping
    x_i = zeros(1,Ns*length(b_i));   x_q = zeros(1,Ns*length(b_i));
    data = ones(1,Ns);   % Rectangular pulse
    for ii = 1:length(b_i)
        x_i(1,(ii-1)*Ns+1:ii*Ns) = data(1,:).*b_i(ii);
        x_q(1,(ii-1)*Ns+1:ii*Ns) = data(1,:).*b_q(ii);
    end
    x_i=x_i(:)'; x_q=x_q(:)'; N = length(x_i);         
    carrier_cos = carrier_gen(fc, fs, N);       % I-ch carrier
    carrier_sin = carrier_gen(fc, fs, N, -90);  % Q-ch carrier
    carrier_cos = carrier_cos(:)';   carrier_sin = carrier_sin(:)';   
    xm_i = carrier_cos.*x_i;    xm_q = carrier_sin.*x_q;
    xm = xm_i + xm_q;
    % Determine signal amplitude assuming Eb = 1
    A = sqrt(2*Rb); % for QAM
    xm = A*xm;    xm = xm(:)'; 

    EbNodB = 0:2:max_EbN0(M_len);
    for n = 1:length(EbNodB)
       EbNo = 10^(EbNodB(n)/10);
       Pe_theory(M_len,n)=2*(1-2^(-k))/k*Q_funct(sqrt(3*k/(2^(2*k)-1)*2*EbNo));
       noise_var = B/EbNo;          % Noise variance
       noise = gaussian_noise(0,noise_var,length(x_i)); noise = noise(:)'; 
       r = xm + noise;    r = r(:)';   % Received signal
       % ------------------------------------------------------------------
       % QAM Demodulation with correlator
       % ------------------------------------------------------------------
       yi = carrier_cos.*r;   yq = carrier_sin.*r;
       for index = 1:nSymbol;
           b_hat_i(1,index)=sum(yi(Ns*(index-1)+1:Ns*index))/(A*oversample);
           b_hat_q(1,index)=sum(yq(Ns*(index-1)+1:Ns*index))/(A*oversample);
       end
       b_hat = qam_decision(b_hat_i, b_hat_q,level,graycode,k); % Bit decision
       num_error = sum(abs(b-b_hat));  % Count errors
       Pe(M_len,n) = num_error/(nSymbol*k*2);
    end
end
theory_shape=['k:';'c:';'r:';'b:';'g:';'k:'];
simul_shape=['k-x';'c-o';'r-*';'b-d';'g-s';'k-+'];
for iii=1:length(M_set)
    semilogy(EbNodB, Pe_theory(iii,:), theory_shape(iii,:)),hold on;
    semilogy(EbNodB, Pe(iii,:), simul_shape(iii,:))
end
axis([-inf inf 10^(-5)  1]);
xlabel('Eb/No [dB]'); ylabel('Probability of bit error');
legend('4-Theo', '4-Simu','16-Theo', '16-Simu','64-Theo', '64-Simu',...
'256-Theo', '256-Simu','1024-Theo', '1024-Simu','4092-Theo', '4092-Simu');
title('BER performance of QAM'),grid on;