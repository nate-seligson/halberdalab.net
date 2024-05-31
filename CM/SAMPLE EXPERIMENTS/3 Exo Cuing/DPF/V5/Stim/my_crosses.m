function my_crosses(scr,xy,armL,armW,armCol,crossAng)
% -------------------------------------------------------------------------
% my_crosses(scr,xy,armL,armW,armCol,crossAng)
% -------------------------------------------------------------------------
% Goal of the function :
% Draws a cross of radius r and withd w on each position specified in xy.
% -------------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% xy : nx2 matrix containing x/y coordinates for n cross centers
% armL : vector specifying length of each arm (pix)
% armW : width of cross arms (in pix)
% armCol : 3xn color Matrix specifying RBG color of each arm
% crossAng : cross orientation angle ([]/0 = cardinals)
% -------------------------------------------------------------------------
% Output(s):
% -------------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 07 / 05 / 2020
% Project : -
% Version : -
% -------------------------------------------------------------------------

if nargin <5;armCol=[0,0,0];end
if nargin <6;crossAng=0;end 
    
if numel(armL) ~= size(xy,1)
    armL = repmat(armL,size(xy,1),1);
end
if numel(armW) ~= size(xy,1)
    armW = repmat(armW,size(xy,1),1);
end

if numel(armCol) > 3
    if size(armCol,1) ~= 3
        error('Color input to my_crosses.m inconsistend.');
    end    
    armCol = kron(armCol,ones(1,2));
end

if numel(crossAng) == 1                 % same angle for all
    crossAng = repmat(crossAng,1,size(xy,1));
elseif numel(crossAng) ~= size(xy,1)    % one angle for each cross
    error('Angle input to my_crosses.m inconsistend.');
end

angVec = [0,90,180,270];


armCoords = nan(2,size(xy,1)*2);
for i = 1:size(xy,1) * 4 % loop through n crosses * 4 arms
    
    idx_c = ceil(i/4);      % cross nb
    idx_a = rem(i-1,4)+1;   % arm nb
    
    curr_angVec = angVec+crossAng(idx_c);
    currAng = curr_angVec(idx_a);
    xPos = xy(idx_c,1);
    yPos = xy(idx_c,2);
    
    xPos2 = xPos + armL(idx_c) * cosd(currAng);
    yPos2 = yPos + armL(idx_c) * -sind(currAng);
    
    armCoords(:,(i-1)*2+1) = [xPos;yPos];
    armCoords(:,(i-1)*2+2) = [xPos2;yPos2];

end

Screen('DrawLines',scr.main,armCoords,armW(1),armCol,[],0);

end