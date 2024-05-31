function [oriFilter]=make_oriFilter(filt_rad,aSigma,alpha0,rSigma2)
% ----------------------------------------------------------------------
% [oriFilter]=keyConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Create an orientation filter to filter pink noise images
% ----------------------------------------------------------------------
% Input(s) :
% filt_rad : half length & width of noise image (pix)
% aSigma : strength (width) of the orientation filter
% alpha0 : tilt angle of the orientation filter
% ----------------------------------------------------------------------
% Output(s):
% oriFilter : orientation filter
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Heiner DEUBEL (martin.szinte@gmail.com)
% Last update : 09 / 03 / 2020
% Project : -
% Version : 3.0
% ----------------------------------------------------------------------

% Create orientation filter
if nargin < 4
    rSigma2 =   0.2;
end

size_x = 2.^ceil(log2(filt_rad*2));
size_y = 2.^ceil(log2(filt_rad*2));

oriFilter = zeros(size_y,size_x);

if alpha0 < -180 || alpha0 > 180; error; end

for idx_x = 1:size(oriFilter,2)
    for idx_y = round(size_y/2):size(oriFilter,1)
        
        x = idx_x - size_x/2;
        y = idx_y - size_y/2;
        
        alpha = atan2d(y,x);
        
        r2 = x^2 + y^2;
        r2 = r2/(size_y*size_y);
        
        diff = abs(alpha-alpha0);
        if diff >= 180;     diff = diff - 180;
        elseif diff >= 90;  diff = 180 - diff;
        end
        expo = -(diff)^2/aSigma^2;
        
        expexp = exp(expo);
        
        expexp = expexp * exp(-r2/rSigma2);
        
        oriFilter(idx_y,idx_x) = expexp;
        oriFilter(size_y-idx_y+1,size_x-idx_x+1) = expexp;
    end
end

end