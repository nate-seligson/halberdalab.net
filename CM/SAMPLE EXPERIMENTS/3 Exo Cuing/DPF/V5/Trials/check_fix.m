function [cor,vid]=check_fix(scr,const,my_key,vid)
% ----------------------------------------------------------------------
% [cor,vid]=ckeckFix(scr,const,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Show fixation target and wait for sufficient fixation.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% const : struct containing varions constant.
% my_key : keyborad keys names
% vid : stucture for the demo video mode
% ----------------------------------------------------------------------
% Output(s):
% cor : flag or signal of a right fixation of FP.
% vid : stucture for the demo video mode
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

%% Compute and simplify var names :
timeout = const.timeOut;     % maximum fixation check time
tCorMin = const.tCorMin;     % minimum correct fixation time

%% Eye movement config
radBef = const.FTrad_pix;

%% Eye data coordinates
if const.eyeMvt
    Eyelink('message', 'EVENT_FixationCheck');
end

if const.eyeMvt
    tstart = GetSecs;
    cor = 0;
    corStart=0;
    tCor = 0;
    t=tstart;

    while KbCheck; end

    while ((t-tstart)<timeout && tCor<= tCorMin)
        
        Screen('FillRect',scr.main,const.colBG)
        
        [x,y]=getCoord(scr,const); % get eye x &y
        
        % fixation cross
        my_crosses(scr,const.fixPos,const.fixRad,const.fixW,const.colFix,const.crossAng)
        
        % placeholders
        for idxP = 1:size(const.locMat,1)
            my_placeHolds(scr,const.locMat(idxP,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
        end
        Screen('Flip',scr.main);
        
        
        if sqrt((x-const.fixPos(1))^2+(y-const.fixPos(2))^2) < radBef
            cor = 1;
        else
            cor = 0;
        end
        
        if const.mkVideo
            vid.j = vid.j + 1;
            if vid.j <= vid.sparseFile*1
                vid.j1 = vid.j1 + 1;
                vid.imageArray1(:,:,:,vid.j1)=Screen('GetImage', scr.main);
            elseif vid.j > vid.sparseFile*1 && vid.j <= vid.sparseFile*2
                vid.j2 = vid.j2 + 1;
                vid.imageArray2(:,:,:,vid.j2)=Screen('GetImage', scr.main);
            elseif vid.j > vid.sparseFile*2 && vid.j <= vid.sparseFile*3
                vid.j3 = vid.j3 + 1;
                vid.imageArray3(:,:,:,vid.j3)=Screen('GetImage', scr.main);
            elseif vid.j > vid.sparseFile*3 && vid.j <= vid.sparseFile*4
                vid.j4 = vid.j4 + 1;
                vid.imageArray4(:,:,:,vid.j4)=Screen('GetImage', scr.main);
            elseif vid.j > vid.sparseFile*4 && vid.j <= vid.sparseFile*5
                vid.j5 = vid.j5 + 1;
                vid.imageArray5(:,:,:,vid.j5)=Screen('GetImage', scr.main);
            end
        end
        
        if cor == 1 && corStart == 0
            tCorStart = GetSecs;
            corStart = 1;
        elseif cor == 1 && corStart == 1
            tCor = GetSecs-tCorStart;
        else
            corStart = 0;
        end
        t = GetSecs;

        [keyIsDown, ~, keyCode] = KbCheck(-1);
        if keyIsDown
            if keyCode(my_key.escape)  && ~const.expStart
                sca
            end
        end
    end
else 
    cor=1;
end
end