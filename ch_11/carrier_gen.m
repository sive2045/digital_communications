function [carrier] = carrier_gen(fc, fs, N, phase)

%===========================================================================
% CARRIER_GEN(fc,phase) generates a sinusoidal waveform:
%           cos(2*pi*fc*t + phase);
%
% fc: carrier frequency [Hz]
% fs: sampling frequency [Hz]
% N: number of samples to be generated
% phase: carrier phase [degree] (Default value is 0)
%===========================================================================

theta = 0;
if(nargin == 4) theta = (phase/360)*2*pi; end

t = [0:N-1]/fs;
t_angle = 2*pi*t*fc + theta;
carrier = cos(t_angle);

