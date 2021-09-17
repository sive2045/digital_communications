% *************************************************************
% 실험 1 변조신호의 파형과 스펙트럼
% *************************************************************
clear; close all;
Rb = 2000;  Tb = 1/Rb;           % Bit rate
fs = 20*Rb;                      % Sampling frequency
ts = 1/fs;                       % Sampling interval
fc = 1.5*Rb;                     % Carrier frequency
% ========================================================
% QPSK
b = [1 1 0 0 1 1 1 0 0 1 1 1];
data = [b  random_seq(20000)];
[data_o data_e] = s_to_p(data); % Serail to parallel conversion without delay
[x_o, time, pulse_shape] = linecode_gen(data_o, 'polar_nrz', Rb, fs);
[x_e, time, pulse_shape] = linecode_gen(data_e, 'polar_nrz', Rb, fs);

N = length(x_o); N1 = length(b)*fs/Rb; 
carrier_cos = carrier_gen(fc, fs, N, 0);    % I-ch carrier
carrier_sin = carrier_gen(fc, fs, N, -90);   % Q-ch carrier
x_o = x_o(:)';  x_e = x_e(:)'; 
carrier_cos = carrier_cos(:)'; carrier_sin = carrier_sin(:)';
I_xm = carrier_cos.*x_o;  
Q_xm = carrier_sin.*x_e;
xm = I_xm + Q_xm;
subplot(311), waveform(x_o(1:N1), fs); ylabel('x_{odd}(t)');
title('baseband and QPSK waveforms'); 
%time_range = [1:N1]*ts;    
subplot(312), waveform(x_e(1:N1), fs); ylabel('x_{even}(t)');
subplot(313), cw_waveform(xm(1:N1), fs); ylabel('x_{QPSK}(t)');
xlabel('Time [sec]'); ylabel('Signal waveform');
disp('Press any key to continue'); pause
% QPSK spectrum
clf;
M = 2^12; AXIS_freq = [0 10 -80 0];
subplot(211), psd_est(x_o, fs, 'decibel', M); axis(AXIS_freq);
title('Spectra of baseband signal and QPSK signal');
subplot(212), psd_est(xm, fs, 'decibel', M); axis(AXIS_freq);
disp('Press any key to continue'); pause
% ========================================================
% OQPSK
[data_o data_e] = s_to_p(data, 1); % Serail to parallel conversion with delay
[x_o, time, pulse_shape] = linecode_gen(data_o, 'polar_nrz', Rb, fs);
[x_e, time, pulse_shape] = linecode_gen(data_e, 'polar_nrz', Rb, fs);
N = length(x_o); N1 = length(b)*fs/Rb; 
carrier_cos = carrier_gen(fc, fs, N, 0);    % I-ch carrier
carrier_sin = carrier_gen(fc, fs, N, -90);   % Q-ch carrier
x_o = x_o(:)';  x_e = x_e(:)'; 
carrier_cos = carrier_cos(:)'; carrier_sin = carrier_sin(:)';
I_xm = carrier_cos.*x_o;  
Q_xm = carrier_sin.*x_e;
xm = I_xm + Q_xm;
subplot(311), waveform(x_o(1:N1), fs); ylabel('x_{odd}(t)');
title('baseband and OQPSK waveforms');
subplot(312), waveform(x_e(1:N1), fs); ylabel('x_{even}(t)');
subplot(313), cw_waveform(xm(1:N1), fs);  ylabel('x_{OQPSK}(t)');
disp('Press any key to continue'); pause
% OQPSK spectrum
clf;
subplot(211), psd_est(x_o, fs, 'decibel', M); axis(AXIS_freq);
title('Spectra of baseband signal and OQPSK signal');
subplot(212), psd_est(xm, fs, 'decibel', M); axis(AXIS_freq);
disp('Press any key to continue'); pause
% ========================================================
% MSK
[data_o data_e] = s_to_p(data, 1); % Serail to parallel conversion with delay
[x_o, time, pulse_shape] = linecode_gen(data_o, 'polar_nrz', Rb, fs);
[x_e, time, pulse_shape] = linecode_gen(data_e, 'polar_nrz', Rb, fs);
N = length(x_o); N1 = length(b)*fs/Rb; 
for k =1:N
    x_o(k) = x_o(k)*cos(0.5*pi*Rb*k*ts);
    x_e(k) = x_e(k)*sin(0.5*pi*Rb*k*ts);
end
carrier_cos = carrier_gen(fc, fs, N, 0);     % I-ch carrier 
carrier_sin = carrier_gen(fc, fs, N, -90);    % Q-ch carrier
x_o = x_o(:)';  x_e = x_e(:)'; 
carrier_cos = carrier_cos(:)'; carrier_sin = carrier_sin(:)';
I_xm = carrier_cos.*x_o;  
Q_xm = carrier_sin.*x_e;
xm = I_xm + Q_xm;
subplot(311), waveform(x_o(1:N1), fs); ylabel('x_{odd}(t)');
title('baseband and MSK waveforms');
subplot(312), waveform(x_e(1:N1), fs); ylabel('x_{even}(t)');
subplot(313), cw_waveform(xm(1:N1), fs);  ylabel('x_{MSK}(t)');
disp('Press any key to continue'); pause
% MSK spectrum
clf;
subplot(211), psd_est(x_o, fs, 'decibel', M); axis(AXIS_freq);
title('Spectra of baseband signal and MSK signal');
subplot(212), psd_est(xm, fs, 'decibel', M); axis(AXIS_freq);
