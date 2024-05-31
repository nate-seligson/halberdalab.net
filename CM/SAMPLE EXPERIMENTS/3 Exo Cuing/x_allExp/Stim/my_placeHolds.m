function my_placeHolds(scr,centerMat,pRad,dotRad,dotCol,nDot,nRot)
% ----------------------------------------------------------------------
% my_placeHolds(scr,centerMat,pRad,dotCol,dotRad,nDot,nRot)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw circular arrangement of N dots serving as placeholders
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% centerMat : Nx2 Matrix containing x, y centers for N placeholders
% pRad : radius of the placeholder (pix)
% dotRad : radius of individual dots (pix)
% dotCol : color (RGB)
% nDot : number of dots forming placeholder
% nRot : rotation of placeholder (0 = first dot right horizontal)
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 30 / 01 / 2020
% Project : -
% Version : -
% ----------------------------------------------------------------------

if nargin < 7; nRot = 45; end
if nargin < 6; nDot =  4; end

dotAng =  360/nDot;
angVec = [0:dotAng:360-dotAng]+nRot;

locMat = [];

for i = 1:size(centerMat,1)
    ph_x = centerMat(i,1);
    ph_y = centerMat(i,2);
    
    for j = 1:nDot
        curr_x = pRad *  cosd(angVec(j)) + ph_x;
        curr_y = pRad * -sind(angVec(j)) + ph_y;
        locMat = [locMat,[curr_x;curr_y]];
    end
end

Screen('DrawDots',scr.main,locMat,dotRad*2,dotCol,[],2);

end