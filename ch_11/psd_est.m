function [Sx, f] = psd_est(x,fs, type, M)
%----------------------------------------------------------------------
% PSD estimation using Welch method
% Input x of N points is divided into K sections of N_F points each.  
% Each section is windowed and FFT computed, then accumulated.  
% Estimated PSD is plotted over the frequency range [0,fs/2]. 
% Input Parameters
%    fs = sampling frequency
%    type = 'linear' or 'decibel' 
%    M = FFT data points => N_F
% Output Parameter
%    Sx = PSD in decibel value
%    f = frequency vector in Hz
%----------------------------------------------------------------------
x = x(:);         
N = length(x);    
freq_range = [0  fs/2];  % frequency range for plotting
%------------------------------------------------------
% Numbet of FFT points
%------------------------------------------------------
if (nargin == 3) 
   M = 1024;    % default value
end
M1 = log2(M);
M2 = ceil(M1);
N_F = 2^M2;       % FFT point
%------------------------------------------------------
% Number of sections, window type, normalizing factor 
%------------------------------------------------------
K = fix(N/N_F);              % number of sections
index = 1:N_F;
win = ones(N_F,1);           % rectangular window 
scale = N_F*norm(win)^2/2;   % scale factor
Px = zeros(N_F,1); 
%--------------------------------------------------------
% Compute the psd estimate
%--------------------------------------------------------
for i=1:K  
     x_w = win.*[detrend(x(index)); zeros(N_F-M,1)];
     index = index + N_F;
     temp = abs(fft(x_w,N_F)).^2;
     Px = Px + temp;                % Accumulate FFT spectra
end
Px = Px/K;    % Averaging
%P = Px([1:(N_FFT/2)])/scale; 
P = Px([2:(N_F/2+1)])/scale;        % Eliminate DC value

N1 = N_F/2;
df = (fs/2 )/N1;                      % Frequency resolution
f1 = max(1,round(freq_range(1)/df )); 
f2 = min(N1,round(freq_range(2)/df)); 
frequency = (f1:f2)*df;          % Frequency vector [Hz]
frequency_kHz = frequency/1000;          % Frequency vector [KHz]
P = P(f1:f2);
    
if( nargout == 0)                         % Plot PSD function
    if strcmp(type, 'linear')
        plot(frequency_kHz, P);
        axis([0 5 0 max(P)*1.2]);
        ylabel('PSD');
    elseif strcmp(type, 'decibel')
        P_dB = 10*log10(P);
        plot(frequency_kHz,P_dB);
        ylabel('PSD [dB]');
    elseif strcmp(type, 'semilog')
        semilogy(frequency_kHz,P);
        ylabel('PSD');
    end
    xlabel('Frequency [KHz]');
    title(strcat('Power Spectral Density (', type, ' scale)'));
    grid on;
end
if( nargout == 2)
    Sx = 10*log10(P);   % Return decibel value
    f = frequency;
end
