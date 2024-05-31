function my_dot(scr,color,x,y,r)
% ----------------------------------------------------------------------
% my_dot(scr,color,x,y,r)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a dot at position (x,y) with radius (r) in color (color)
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% color = color of the dot (RGB)
% x = x-center
% y = y-center
% r = radius (pix)
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 30 / 01 / 2020
% Project : -
% Version : -
% ----------------------------------------------------------------------

if r>30
    Screen('FillOval',scr.main,color,[(x-r) (y-r) (x+r) (y+r)]);
else
    Screen('DrawDots',scr.main,[x,y],r*2,color,[],2);
end
end