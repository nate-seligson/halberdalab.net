function [noiseIm_filt]=filter_pinkNoise(noiseIm,oriFilter)
% ----------------------------------------------------------------------
% [noiseIm_filt]=filter_pinkNoise(noiseIm,oriFilter)
% ----------------------------------------------------------------------
% Goal of the function :
% Make (filtered) pink noise images
% ----------------------------------------------------------------------
% Input(s) :
% noiseIm : to be filtered pink noise image
% oriFilter : orientation filter
% ----------------------------------------------------------------------
% Output(s):
% noiseIm
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 09 / 02 / 2020
% Project : preSacTMS
% Version : 1.0
% ----------------------------------------------------------------------

FFT_pts = 2 .^ ceil(log2(size(noiseIm))); % number of points for FFT (power of 2)

meanIm = mean(noiseIm(:));

% Perform FFT2
noiseIm_fft = fft2(noiseIm-meanIm,FFT_pts(1),FFT_pts(2));
noiseIm_fft = fftshift(noiseIm_fft);

noiseIm_fft_filt = oriFilter.*noiseIm_fft;

% Shift back to real
noiseIm_filt = real(ifft2(ifftshift(noiseIm_fft_filt)));
noiseIm_filt = noiseIm_filt(1:length(noiseIm(:,1)), 1:length(noiseIm(1,:)));
noiseIm_filt = noiseIm_filt+meanIm;
noiseIm_filt = noiseIm_filt-min(noiseIm_filt(:));
noiseIm_filt = noiseIm_filt./max(noiseIm_filt(:));

end