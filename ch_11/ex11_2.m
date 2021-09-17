% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   Bandpass Simulation  - QPSK -
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; close all;
Rb = 1000;  Tb = 1/Rb;      % Bit rate
fs = 20*Rb; ts = 1/fs;      % Sampling frequency
B = fs/2;                   % System bandwidth 
Ns = fs/Rb;                 % Number of samples per bit duration
nSymbol = 10^6;             % Total number of symbols 
fc = 5000;                  % Carrier frequency
% ---------------------------------------------------------------
b = random_seq(nSymbol*2);
b_i = b(1:2:length(b));   b_q = b(2:2:length(b));
[x_i, t, pulse_shape_i] = linecode_gen(b_i, 'polar_nrz', Rb, fs);
[x_q, t, pulse_shape_q] = linecode_gen(b_q, 'polar_nrz', Rb, fs);
x_i=x_i(:)'; x_q=x_q(:)';
N = length(x_i);                  
carrier_cos = carrier_gen(fc, fs, N);       % I-ch carrier
carrier_sin = carrier_gen(fc, fs, N, -90);  % Q-ch carrier
carrier_cos = carrier_cos(:)';   carrier_sin = carrier_sin(:)';
xm_i = carrier_cos.*x_i;   xm_q = carrier_sin.*x_q;
xm = xm_i + xm_q;
% Determine signal amplitude assuming Eb = 1
A = sqrt(2*Rb); % for PSK
xm = A*xm;    xm = xm(:)'; 
% Decision Threshold
threshold = 0;

EbNodB = 0:2:12;
b_hat_i=[];  b_hat_q=[];
for n = 1:length(EbNodB)
   n 
   EbNo = 10^(EbNodB(n)/10);
   Pe_theory(n) = Q_funct(sqrt(2*EbNo)); % Theoretical BER
   noise_var = B/EbNo; 
   noise = gaussian_noise(0, noise_var, length(xm));
   r = xm + noise;  r = r(:)';  % Received signal
   yi = carrier_cos.*r;   yq = carrier_sin.*r;
   z_ich = matched_filter(pulse_shape_i, yi, fs);
   z_qch = matched_filter(pulse_shape_q, yq, fs);
   % Bit decision 
   b_hat_i = z_ich(Ns*(1:nSymbol)); % Sample the matched filter output
   b_hat_q = z_qch(Ns*(1:nSymbol)); 
   b_hat_i(b_hat_i > threshold) = 1;
   b_hat_i(b_hat_i < threshold) = 0;
   b_hat_q(b_hat_q > threshold) = 1;
   b_hat_q(b_hat_q < threshold) = 0;
   % Count errors
   b_hat = zeros(1,length(b_hat_i)*2);
   b_hat(1:2:length(b_hat))=b_hat_i(1:length(b_hat_i));
   b_hat(2:2:length(b_hat))=b_hat_q(1:length(b_hat_q));
   num_error = sum(abs(b-b_hat));  
   Pe(n) = num_error/(nSymbol*2);
end
semilogy(EbNodB, Pe_theory, 'k'), hold on;
semilogy(EbNodB, Pe, 'b-square'), hold off;
axis([-inf inf 10^(-5)  1]), grid;
xlabel('Eb/No [dB]'); ylabel('Probability of bit error');
legend('Theoretical', 'Simulation');
title('BER performance of QPSK')
