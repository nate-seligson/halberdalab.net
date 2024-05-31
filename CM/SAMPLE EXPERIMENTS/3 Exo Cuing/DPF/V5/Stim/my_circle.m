function my_circle(scr,color,x,y,r,pw)
% ----------------------------------------------------------------------
% my_circle(scr,color,x,y,r)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a circle or oval in position (x,y) with radius (r).
% ----------------------------------------------------------------------
% Input(s) :
% scr = Window Pointer                              ex : w
% color = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% x = position x of the center                      ex : x = 550
% y = position y of the center                      ex : y = 330
% r = radius for X (in pixel)                       ex : r = 25
% pw = pen width
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmai.com)
% Last update : 2020-12-13
% Project : -
% Version : -
% ----------------------------------------------------------------------

Screen('FrameOval',scr.main,color,[(x-r) (y-r) (x+r) (y+r)],pw);

end