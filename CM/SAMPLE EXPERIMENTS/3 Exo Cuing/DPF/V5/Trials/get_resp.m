function [key_press,key_t,vid]=get_resp(scr,aud,const,expDes,t,my_key,eyecrit,vid)
% ----------------------------------------------------------------------
% [key_press,key_t,vid]=get_resp(scr,aud,const,expDes,t,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Check keyboard press, and return flags.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% aud : sound configuration
% const : experiment constants
% expDes : variable design configuration
% t : trial count
% my_key : keyborad configuration
% vid : video structure
% ----------------------------------------------------------------------
% Output(s):
% key_press : struct containing key response
% key_t : response time(s)
% vid : video structure
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

% Initialize buttons
key_press.resp = NaN;
key_press.escape = 0;
t_resp = NaN;


%% Variables
tarPos  = expDes.expMat(t, 9);   % rand5: target position (1-4)


% fixation cross
my_crosses(scr,const.fixPos,const.fixRad,const.fixW,const.colFix,const.crossAng)

% placeholders
for idxP = 1:size(const.locMat,1)
    my_placeHolds(scr,const.locMat(idxP,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
end

% response cue
Screen('DrawLine', scr.main, const.colRespCue,const.rcueMat(tarPos,1),const.rcueMat(tarPos,2),const.rcueMat(tarPos,3),const.rcueMat(tarPos,4),const.respW);

Screen('Flip',scr.main);

% response time SOUND
my_sound(2,aud);

if const.eyeMvt
    Eyelink('message','T7');
end

t_getResp = GetSecs;

% if eyecrit.eyeOK ~= 1
%     % no saccade detected at target
%     if ~eyecrit.sacEnd || cueDir ~= eyecrit.sacTarNb
%         my_frames(scr,const.locMat(cueDir,:),const.STrad_pix,const.colErrFix,const.eyeErr_W,1)
%     else
%         % timing issue?
%         eyeFBtxt = [];
%         if eyecrit.latTooShort
%             eyeFBtxt = 'Wait for the cue!';
%             xPos = const.fixPos(1);
%             yPos = const.fixPos(2)*0.85;
%         elseif eyecrit.latTooLong
%             eyeFBtxt = 'Too late!';
%             xPos = const.locMat(cueDir,1);
%             yPos = const.locMat(cueDir,2)*0.85;
%         end
%         if ~isempty(eyeFBtxt)
%             my_text(scr,const,eyeFBtxt,xPos,yPos,const.colText);
%         end
%     end
% end


% keyboard response
tstart = GetSecs; timeout = 0;
while isnan(key_press.resp) && ~timeout
    
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if (keyCode(my_key.escape)) && ~const.expStart
            key_press.resp = 1;
            key_press.escape = 1;
        end
        
        if (keyCode(my_key.left))
            key_press.resp = 1;
            t_resp = GetSecs;
        elseif (keyCode(my_key.right))
            key_press.resp = 2;
            t_resp = GetSecs;
        end
    end
    
    currT = GetSecs;
    if currT-tstart > const.durT7
        timeout = 1;
    end
    
%     if const.mkVideo
%         vid.j = vid.j + 1;
%         if vid.j <= vid.sparseFile*1
%             vid.j1 = vid.j1 + 1;
%             vid.imageArray1(:,:,:,vid.j1)=Screen('GetImage', scr.main);
%         elseif vid.j > vid.sparseFile*1 && vid.j <= vid.sparseFile*2
%             vid.j2 = vid.j2 + 1;
%             vid.imageArray2(:,:,:,vid.j2)=Screen('GetImage', scr.main);
%         elseif vid.j > vid.sparseFile*2 && vid.j <= vid.sparseFile*3
%             vid.j3 = vid.j3 + 1;
%             vid.imageArray3(:,:,:,vid.j3)=Screen('GetImage', scr.main);
%         elseif vid.j > vid.sparseFile*3 && vid.j <= vid.sparseFile*4
%             vid.j4 = vid.j4 + 1;
%             vid.imageArray4(:,:,:,vid.j4)=Screen('GetImage', scr.main);
%         elseif vid.j > vid.sparseFile*4 && vid.j <= vid.sparseFile*5
%             vid.j5 = vid.j5 + 1;
%             vid.imageArray5(:,:,:,vid.j5)=Screen('GetImage', scr.main);
%         end
%         timeRep = timeRep +1;
%         if timeRep == expDes.timeRTvid
%             key_press.resp = 1;
%             t_resp = GetSecs;
%         end
%     end
end

key_t = t_resp - t_getResp;

if const.eyeMvt
    if ~timeout
        Eyelink('message','EVENT_ANSWER');
    else
        Eyelink('message','EVENT_TIMEOUT');
    end
end

if key_press.escape == 1; overDone(aud,const,vid);end

end