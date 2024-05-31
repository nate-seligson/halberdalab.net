function [nbRev,idxRev] = revCount(datVec)
% ----------------------------------------------------------------------
% my_text(scr,const,txt,xPos,yPos,txtCol)
% ----------------------------------------------------------------------
% Goal of the function :
% Determine number of reversals in data vector datVec
% ----------------------------------------------------------------------
% Input(s) :
% datVec : vector containing data points
% ----------------------------------------------------------------------
% Output(s):
% nbRev : number of reversals
% idxRev : location of reversals
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% Last update : 2020-12-13
% Project : preSacPF
% Version : -
% ----------------------------------------------------------------------

nbRev = 0;
idxRev = [];

goingUp = 0;
goingDown = 0;

for i = 1:numel(datVec)-1
    
    if datVec(i+1) > datVec(i) && ~goingUp
        goingUp = 1;
        if goingDown
            nbRev = nbRev+1;
            idxRev = [idxRev,i];
            goingDown = 0;
        end
        
    elseif datVec(i+1) < datVec(i) && ~goingDown
        
        goingDown = 1;
        if goingUp
            nbRev = nbRev+1;
            idxRev = [idxRev,i];
            goingUp = 0;
        end      
    end
end