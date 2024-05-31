function my_inside_armCue(scr,xPos,yPos,cRad,colOut,colIn,armW,armCol,xTar,yTar)
% ----------------------------------------------------------------------
% my_inside_armCue(scr,xPos,yPos,cRad,colOut,colIn,armL,armW,armCol,xTar,yTar)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw endogenous line-cue indicating specific (target) locations
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% xPos : x-center (1 value)
% yPos : y-center (1 value)
% cRad : radius of the central dot (1 value, pix)
% colOut : color central dot (sourround, RGB)
% colIn : color central dot (middle, RGB)
% armW : vector specifying Width of each arm
% armCol : 3xN color Matrix specifying RBG color of each arm
% xTar : vector specifying x-center(s) of to be indicated target
% yTar : vector specifying y-center(s) of to be indicated target
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 2020-10-27
% Project : -
% Version : -
% ----------------------------------------------------------------------

armL = repmat(cRad*2,numel(xTar),1); % arm length equals dot radius

if numel(xTar) == numel(yTar) 
    if numel(armW) ~= numel(xTar);armW = repmat(armW,numel(xTar),1);end    
else
    error('Input to my_armCue.m inconsistend.')
end

if numel(armCol) > 3
    if size(armCol,1) ~= 3
        error('Color input to my_armCue.m inconsistend.');
    end    
    armCol = kron(armCol,ones(1,2));
end

armCoords = nan(2,numel(xTar)*2);
for i = 1:numel(xTar)
    
    currAng = -atan2(yTar(i)-yPos, xTar(i)-xPos).*180/pi; % angle = atan2(y2 - y1, x2 - x1) * 180 / pi
    
    xPos2 = xPos + armL(i) * cosd(currAng);
    yPos2 = yPos + armL(i) * -sind(currAng);
    
    armCoords(:,(i-1)*2+1) = [xPos;yPos];
    armCoords(:,(i-1)*2+2) = [xPos2;yPos2];
end


%my_dot(scr,colOut,xPos,yPos,cRad);    	% radius
%my_dot(scr,colIn,xPos,yPos,cRad*3/4);  	% 3/4 radius

Screen('DrawLines',scr.main,armCoords,armW(1),armCol,[],0);

my_dot(scr,colOut,xPos,yPos,cRad*3/8);	% 3/8 radius


end