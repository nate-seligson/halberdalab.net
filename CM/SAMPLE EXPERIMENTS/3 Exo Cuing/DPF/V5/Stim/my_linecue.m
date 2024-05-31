function my_linecue(scr,color,x,y,cue_loc_x,cue_loc_y,w)
% ----------------------------------------------------------------------
% my_linecue2(scr,color,x,y,cue_loc_x,cue_loc_y,w)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a line to cue a certain location.
% ----------------------------------------------------------------------
% Input(s) :
% scr = Window Pointer                              ex : w
% color = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% x = position x of the center                      ex : x = 550
% y = position y of the center                      ex : y = 330
% cue_loc_x = position x of location to be cued
% cue_loc_y = position y of location to be cued
% w = width                                         ex : w = 2
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Last update : 10 / 07 / 2015
% Project : EndexPointsac
% Version : -
% ----------------------------------------------------------------------

Screen('DrawLine', scr.main, color, x, y, cue_loc_x, cue_loc_y, w);

end