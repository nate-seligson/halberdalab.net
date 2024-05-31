function my_arc(scr,color,x,y,r,startAng,arcAng)
% ----------------------------------------------------------------------
% my_arc(scr,color,x,y,r,startAng,arcAng)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw half a filled arc in position (x,y) with specific radius (r) and
% angle (arcAng);
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% color : color of the arc in RBG or RGBA           ex : color = [0 0 0]
% x : position x of the center                      ex : x = 550
% y : position y of the center                      ex : y = 330
% r : radius for X (in pixel)                       ex : r = 25
% startAng : start angle (clockwise from vertical)
% arcAng : arc angle (clockwise from startAng)
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last edit : 07 / 05 / 2016
% Project : SacPointAtt
% Version : 3.0
% ----------------------------------------------------------------------

Screen('FillArc',scr.main,color,[(x-r) (y-r) (x+r) (y+r)],startAng,arcAng)

end