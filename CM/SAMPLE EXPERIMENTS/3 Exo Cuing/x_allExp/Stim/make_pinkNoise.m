function [noiseIm]=make_pinkNoise(noiseIm_rad)
% ----------------------------------------------------------------------
% [noiseIm]=make_pinkNoise(noiseIm_rad)
% ----------------------------------------------------------------------
% Goal of the function :
% Make (filtered) pink noise images
% ----------------------------------------------------------------------
% Input(s) :
% noiseIm_rad  = half length & width of noise image (pix)
% ----------------------------------------------------------------------
% Output(s):
% noiseIm : pink noise image
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by David AAGTEN-MURPHY
% Last update : 09 / 02 / 2020
% Project : preSacTMS
% Version : 1.0
% ----------------------------------------------------------------------

a = rand(noiseIm_rad*2) ;
F = fftshift(fft2(a) );                 % do FFT and shift origin to centre
[x,y] = meshgrid(-(noiseIm_rad):((noiseIm_rad)-1)); % find radial frequencies
radialFreq = sqrt(x.^2 + y.^2);

radialFreq(end/2+1,end/2+1) = 1;        % make sure centre freq is set to 1.
F = F .* (1./radialFreq) ;              % multiply F with inverse of rad Freq.
noiseIm = real( ifft2(fftshift(F)) );   % shift F back and do Inverse FFT

noiseIm = noiseIm - mean(noiseIm(:)); 	% normalise amplitude range
maxVal = max(abs(noiseIm(:)));
noiseIm = noiseIm/(2*maxVal) + .5;

noiseIm = ((noiseIm-.5).*0.9)+0.5;      % slightly reduce contrast to avoid it clipping by chance 

end
