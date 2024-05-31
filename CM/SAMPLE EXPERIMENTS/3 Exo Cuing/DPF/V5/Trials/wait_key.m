function wait_key(scr,const,my_key,t)
% ----------------------------------------------------------------------
% waitSpace(scr,const,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Show start sceen and wait for space press.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% const : struct containing all the constant configurations.
% my_key : keyboard keys names.
% t : trial count
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

while KbCheck(-1); end

% Button flag
key_press.space         = 0;
key_press.escape        = 0;
key_press.push_button   = 0;


% Keyboard checking :
if const.eyeMvt
    Eyelink('message','EVENT_PRESS_SPACE');
end

Screen('FillRect',scr.main,const.colBG);

% fixation cross
my_crosses(scr,const.fixPos,const.fixRad,const.fixW,const.colFix,const.crossAng)

% placeholders
for idxP = 1:size(const.locMat,1)
	my_placeHolds(scr,const.locMat(idxP,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
end

% Block info
if t == 1
    blockTxt = sprintf('Fixate at the center of the middle placeholder and press [SPACE] to start.'); %%% CM
else
    blockTxt = sprintf('Fixate at the center of the middle placeholder and press [SPACE] to continue.');
end
my_text(scr,const,blockTxt,const.fixPos(1),const.fixPos(2)*0.40,const.colText);


Screen('Flip',scr.main);

while ~key_press.push_button
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                sca
            elseif (keyCode(my_key.space))
                key_press.space = 1;
                key_press.push_button = 1;
            end
        end
    end
end


end