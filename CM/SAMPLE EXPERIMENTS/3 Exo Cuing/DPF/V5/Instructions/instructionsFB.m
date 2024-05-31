function instructionsFB(scr,const,my_key,imName,tEnd,fb)
% ----------------------------------------------------------------------
% instructionsFB(scr,const,my_key,imName,tEnd,fb)
% ----------------------------------------------------------------------
% Goal of the function :
% Display .tif file instructions and provide feedback "on top"
% ----------------------------------------------------------------------
% Input(s) :
% scr : main window pointer.
% const : struct containing all the constant configurations.
% imName : name of the file image to display
% tEnd : feedback / instruction duration (in s)
% fb : structure containing feedback info
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline 
% Last update : 2021-06-08
% Project : ppSacApp
% Version : 1.0
% ----------------------------------------------------------------------
while KbCheck(-1); end

KbName('UnifyKeyNames');

dirImageFile = '../../../../Instructions/Image/';
dirImage = [dirImageFile,imName,'.tif'];

if exist(dirImage) % Display image
    imageToDraw =  imread(dirImage);
    t_handle = Screen('MakeTexture',scr.main,imageToDraw);

    Screen('FillRect',scr.main,scr.white);
    Screen('DrawTexture',scr.main,t_handle);
    
else
    Screen('FillRect',scr.main,const.colBG);
    my_text(scr,const,sprintf('Block #%i   >>  %s',const.fromBlock,imName),const.fixPos(1),const.fixPos(2)*0.6,const.white);
end

% Display feedback (on top of image)
if strcmp(imName,'End_training') || strcmp(imName,'End_block') || strcmp(imName,'End_threshold') || strcmp(imName,'End_fix') || strcmp(imName,'End_pretest')
    
    % Block number
    my_text(scr,const,sprintf('Block #%i',const.fromBlock),const.fixPos(1),const.fixPos(2)*0.7,const.colText);

    % Percentage correct
    my_text(scr,const,sprintf('%2.0f %% correct responses',fb.perc_correct),const.fixPos(1),const.fixPos(2)*0.85,const.colText);
    
%     % Saccade error rate
%     if const.eyeMvt
%         my_text(scr,const,sprintf('%2.0f %% fixation errors',fb.fix_break),const.fixPos(1),const.fixPos(2)*1.1,const.colText);
%         if const.condition == 2
%             my_text(scr,const,sprintf('%2.0f %% eye movement errors',100-fb.percSac_correct),const.fixPos(1),const.fixPos(2)*1.3,const.colText);
%         end
%     end
end

Screen('Flip',scr.main);

push_button = 0;
t0 = GetSecs;
while ~push_button
    
    FlushEvents;
    
    if nargin > 5
        if GetSecs - t0 > tEnd
            push_button=1;
        end
    end
    
    [keyIsDown, ~, keyCode] = KbCheck(-1); 
    if keyIsDown
        if keyCode(my_key.space)
            push_button=1;
        elseif keyCode(my_key.escape) && ~const.expStart
            sca
        end
    end
end