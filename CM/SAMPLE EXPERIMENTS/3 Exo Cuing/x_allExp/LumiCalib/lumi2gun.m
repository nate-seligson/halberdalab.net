function [rgb]=lumi2gun(cal,color,cand)
% ----------------------------------------------------------------------
% [rgb]=cand2gun(wPtr,const,candelaVal,colorAsk)
% ----------------------------------------------------------------------
% Goal of the function :
% Determin triplet RGB / gray gun values for desired luminance
% ----------------------------------------------------------------------
% Input(s) :
% cal : luminance calibration results
% color : color ('red','green','blue','all')
% cand : desired candela/m2
% ----------------------------------------------------------------------
% Output(s):
% [rgb] = triplet gun values (r,g,b) (0->255)
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last update : 24 / 04 / 2020
% Project : -
% Version : -
% ----------------------------------------------------------------------

switch color
    
    case 'red'
        if cand > max(cal.L(1,:))
          warning('RED luminance not in possible range!'); 
        end
        [~,gunVal] = min(abs(cal.L(1,:)-cand));
        rgb = [1 0 0] * gunVal;
    case 'green'
        if cand > max(cal.L(2,:))
          warning('GREEN luminance not in possible range!'); 
        end
        [~,gunVal] = min(abs(cal.L(2,:)-cand));
        rgb = [0 1 0] * gunVal;
    case 'blue'
        if cand > max(cal.L(3,:))
          warning('BLUE luminance not in possible range!'); 
        end
        [~,gunVal] = min(abs(cal.L(3,:)-cand));
        rgb = [0 0 1] * gunVal;
    case 'gray'
        if cand > max(cal.L(4,:))
          warning('GRY luminance not in possible range!'); 
        end
        [~,gunVal] = min(abs(cal.L(4,:)-cand));
        rgb = [1 1 1] * gunVal;
end
   
end