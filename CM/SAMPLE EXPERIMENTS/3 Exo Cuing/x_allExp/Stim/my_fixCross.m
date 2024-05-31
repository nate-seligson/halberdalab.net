function my_fixCross(scr,xPos,yPos,cRad,cCol,cWidth)
% ----------------------------------------------------------------------
% my_fixCross(scr,xPos,yPos,cRad,cCol,cWidth)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw fixation cross
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations                               ex : w
% xPos : x-center
% yPos : y-center
% cRad : radius of the cross (pix)
% cCol : Nx3 color Matrix specifying RBG color of right, top, left, 
% 	and bottom cross arm in
% cWidth : Nx1 vector specifying width of right, top, left, and 
%   bottomcross arms
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 30 / 01 / 2020
% Project : -
% Version : -
% ----------------------------------------------------------------------

% fill values if not all arms are specified
if numel(cWidth) ~=4;   cWidth = repmat(cWidth,4,1); end   
if numel(cRad) ~=4;     cRad = repmat(cRad,4,1); end  

% arm coordinates
armCoords =    [xPos,xPos+cRad(1),  xPos,xPos,          xPos-cRad(3),   xPos,xPos,xPos; ...
                yPos,yPos,          yPos,yPos-cRad(2),  yPos,yPos,      yPos,yPos+cRad(4)];

Screen('DrawLines',scr.main,armCoords,cWidth, cCol,[],0);

end