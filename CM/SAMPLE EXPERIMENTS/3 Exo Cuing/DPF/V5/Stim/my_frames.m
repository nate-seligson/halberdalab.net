function my_frames(scr,posMat,rad,color,width,frametype)
% ----------------------------------------------------------------------
% my_frames(scr,xPos,yPos,rad,color,width,frametype)
% ----------------------------------------------------------------------
% Goal of the function :
% Draws frames around positions specified in framelocMat.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% posMat : Nx2 Matrix containing x,y coordinates of the N frames
% rad : Nx1 vector containing radius of the N frames (pix)
% color : Nx3 vector containing color information (RBG) of the N frames
% width : Nx1 vector containing width information of the N frames
% frametype : circles (1) or squares (2)
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Last update : 01 / 02 / 2020
% Project : -
% Version : -
% ----------------------------------------------------------------------

if numel(rad)~=size(posMat,1);rad=repmat(rad,1,size(posMat,1));end
if size(color,1)~=size(posMat,1);color=repmat(color,size(posMat,1),1);end
if numel(width)~=size(posMat,1);width=repmat(width,1,size(posMat,1));end

framelocMat = nan(4,size(posMat,1));
for i = 1:size(posMat,1)
    framelocMat(:,i) = [posMat(i,1)-rad(i),posMat(i,2)-rad(i),... % L T 
                        posMat(i,1)+rad(i),posMat(i,2)+rad(i)];   % R B
end

if frametype == 1
    Screen('FrameOval',scr.main,color,framelocMat,width);
elseif frametype == 2
    Screen('FrameRect',scr.main,color,framelocMat,width);
end

end