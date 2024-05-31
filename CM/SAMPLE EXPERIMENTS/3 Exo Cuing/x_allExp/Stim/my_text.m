function my_text(scr,const,txt,xPos,yPos,txtCol)
% ----------------------------------------------------------------------
% my_text(scr,const,txt,xPos,yPos,txtCol)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw text centered on xy
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% const : experiment constants
% txt : text to draw
% xPos : std of the Gaussian modulator
% yPos : frequency (cycle per degree)
% txtCol : text color
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 01 / 02 / 2020
% Project : preSacTMS
% Version : 1.0
% ----------------------------------------------------------------------

Screen('TextSize', scr.main, const.text_size);
Screen('TextFont', scr.main, const.text_font);

bounds  = Screen(scr.main,'TextBounds',txt);
xTxt	= xPos-bounds(3)/2;
yTxt    = yPos-bounds(4)/2;

Screen(scr.main,'Drawtext',txt,xTxt,yTxt,txtCol);

end