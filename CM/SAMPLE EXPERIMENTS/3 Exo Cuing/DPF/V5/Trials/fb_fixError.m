function fb_fixError(scr,aud,const)
% ----------------------------------------------------------------------
% fb_fixError(scr,aud,const,expDes)
% ----------------------------------------------------------------------
% Goal of the function :
% When broken fixation, turn fixation red and play error sound
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% aud : sound configurations
% const : struct containing all the constant configurations
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

% BG
Screen('FillRect',scr.main,const.colBG);

% fixation cross
my_crosses(scr,const.fixPos,const.fixRad,const.fixW,const.colFix,const.crossAng)

% placeholders
for idxP = 1:size(const.locMat,1)
    my_placeHolds(scr,const.locMat(idxP,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
end

eyeFBtxt = 'Please fixate :)';
xPos = const.fixPos(1);
yPos = const.fixPos(2)*0.95;

my_text(scr,const,eyeFBtxt,xPos,yPos,const.colText);

Screen('Flip',scr.main);
%my_sound(13,aud);

WaitSecs(1.0);

end