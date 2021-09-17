function [out] = matched_filter(g, in, fs)

% MATCHED_FILTER
% This function implements matched filter receiver.
% Input arguments:
%      g: basic pulse shape of the line code
%      in: received signal which input to the matched filter
%      fs: sampling rate
%

dt = 1/fs;

%----------------------------------------------------------------------------
% Generate the filter impulse response 
%----------------------------------------------------------------------------

h   = g(length(g):-1:1);% impulse response of the matched filter

%----------------------------------------------------------------------------
% Genarate the output signal
%----------------------------------------------------------------------------
out = conv(h,in)*dt;
out = [out(:)' 0];
