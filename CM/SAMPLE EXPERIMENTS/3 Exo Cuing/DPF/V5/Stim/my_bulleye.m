function my_bulleye(scr,colOut,colIn,x,y,r)
% ----------------------------------------------------------------------
% my_bulleye(scr,colOut,colIn,x,y,r)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a circle or oval in position (x,y) with radius (r).
% ----------------------------------------------------------------------
% Input(s) :
% scr : updated screen (color) configurations
% colOut : color central dot (sourround, RGB)
% colIn : color central dot (middle, RGB)
% x : x-coordinate of the center
% y : x-coordinate of the center
% r : radius (pix)
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 29 / 01 / 2020
% Project : preSacTMS
% Version : 1.0
% ----------------------------------------------------------------------

my_dot(scr,colOut,x,y,r);        % radius
my_dot(scr,colIn,x,y,r*3/4);   	% 3/4 radius
my_dot(scr,colOut,x,y,r*3/8);	% 3/8 radius

end
