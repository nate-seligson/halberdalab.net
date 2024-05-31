function [const,resMat,eyeMat,nanMat,vid,expDes]=run_trial(scr,aud,const,expDes,my_key,t,vid)
% ----------------------------------------------------------------------
% [resMat,vid,expDes]=run_trial(scr,aud,const,expDes,my_key,t,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Main trial function. Prepare for trial, then loop through trial
% (drawing stimuli and checking eye position), output collected results
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% aud : sound configuration
% const : experiment constants
% expDes : variable design configuration
% my_key : keyborad configuration
% t : trial count
% vid : video structure
% ----------------------------------------------------------------------
% Output(s):
% const : experiment constants
% resMat : experimental results
%   resMat(1) = k pressed:   (1:4, see below)
%                             898 = FIXERR
%   resMat(2) = correctness:    1 = COR (orientation discrimination)
%                               0 = INCOR / NO SACCADE
%                               2 = WRONG SACCADE
%                             898 = FIXERR
%   resMat(3) = eyeOKcol:       1 = SAC/FIX COR 
%                             898 = FIXERR
%   resMat(4) = key_t: response time (in seconds)
%   resMat(5) = 
%   resMat(6) = gabC (Gabor contrast)
%   resMat(7) = 
%   resMat(8:9) = [t_cueON,t_testON]
%   resMat(10) =
% eyeMat (1:10) = NaN
% nanMat (1:10) = NaN
% vid : video structure        
% expDes : variable design configuration
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------
% Edit history:

%06/21/21: CM changes lines 94 to 112 so naming is more consistent
%(cardinal locations) 

%06/21/21: CM comments out the removal of the ITI for participant NH,
%since NH will eventually participate and the task parameters should be
%the same for everyone. Sorry Nina! 
% ----------------------------------------------------------------------

while KbCheck; end
FlushEvents('KeyDown');


%% Variables

tDir1  	= expDes.expMat(t, 5);   % rand1: tilt direction RIGHT (-20 left, +20 right)
tDir2  	= expDes.expMat(t, 6);   % rand2: 
tDir3 	= expDes.expMat(t, 7);   % rand3: 
tDir4   = expDes.expMat(t, 8);   % rand4: 
tarPos  = expDes.expMat(t, 9);   % rand5: target position (1-4)
cueCond = expDes.expMat(t,10);   % rand6: cue condition

tDir_vec = [tDir1,tDir2,tDir3,tDir4];



%% Gabor preparation

% Gabor contrast
switch const.task
    case 1; gabC = const.gabor_contr;
    case 2; gabC = const.stairc_val{tarPos}(end);
    case 3; gabC = const.gabor_contr;
end

% test Gabor
grating = GenerateGrating(const.test_rad_pix*2,const.test_rad_pix*2,const.gabor_ori,const.gabor1_ppp,const.gabor_phase,gabC);
grating = grating + const.bgluminance;
grating(grating>1) = 1;
grating(grating<0) = 0;
grating = grating.*255;

gabor_im(:,:,1) = grating;
gabor_im(:,:,2) = grating;
gabor_im(:,:,3) = grating;
gabor_im(:,:,4) = const.gaborApt;
gaborT_texture = Screen('MakeTexture',scr.main,gabor_im);



%% Display trial information in command window
if const.checkTrial
    fprintf(1,'\n\n\t========================  TRIAL %3.0f ========================\n',t);
    % Task
    txtVal = {'TRAIN','THRE','MAIN'};fprintf(1,'\n\tTask : \t\t\t%s',txtVal{const.task});
    % Cue position
    txtVal = {'VALID','NEUTRAL',};
    fprintf(1,'\n\tCue direction : \t%s',txtVal{cueCond});
    % Test position
    txtVal = {'East','North','West','South'};
    %txtVal = {'Right','Up','Left','Down'}; old
    fprintf(1,'\n\tTest position : \t%s',txtVal{tarPos});
    % Test tilt angle  (1-7)
    fprintf(1,'\n\tAngles : \t\East:%i  North:%i  West:%i  South:%i',tDir1,tDir2,tDir3,tDir4);

    %old
    %fprintf(1,'\n\tAngles : \t\tRight:%i  Up:%i  Left:%i  Down:%i',tDir1,tDir2,tDir3,tDir4);
    fprintf(1,'\n\tGabor contrast : \t%1.3f%% \n',gabC*100); 
end


%% Time

% T1: Fixation
nbf_T1_start = 1;                   nbf_T1_end = nbf_T1_start + const.numT1 - 1;

% T2: Cue
% nbf_T2_start = 1;                   nbf_T2_end = nbf_T2_start + const.numT2 - 1;
nbf_T2_start = nbf_T1_end + 1;       nbf_T2_end = nbf_T2_start + const.numT2 - 1;

% T3: ISI1
nbf_T3_start = nbf_T2_end + 1;    	nbf_T3_end = nbf_T3_start + const.numT3 - 1;

% T4: Stimuli
nbf_T4_start = nbf_T3_end + 1;    	nbf_T4_end = nbf_T4_start + const.numT4 - 1;

% T5: ISI2
nbf_T5_start = nbf_T4_end + 1;    	nbf_T5_end = nbf_T5_start + const.numT5 - 1;

% T6: RESPONSE CUE
nbf_T6_start = nbf_T5_end + 1;    	nbf_T6_end = nbf_T6_start + const.numT6 - 1;

nbf_max = nbf_T6_end;


if const.checkTimeFrm
    fprintf(1,'\n\tCue:     \t%i to %i (~%3.0f to %3.0f ms)',nbf_T2_start,nbf_T2_end,(nbf_T2_start-1)*scr.fd*1000,nbf_T2_end*scr.fd*1000);
    fprintf(1,'\n\tISI1:    \t%i to %i (~%3.0f to %3.0f ms)',nbf_T3_start,nbf_T3_end,(nbf_T3_start-1)*scr.fd*1000,nbf_T3_end*scr.fd*1000);
	fprintf(1,'\n\tStimuli:	%i to %i (~%3.0f to %3.0f ms)',nbf_T4_start,nbf_T4_end,(nbf_T4_start-1)*scr.fd*1000,nbf_T4_end*scr.fd*1000);
    fprintf(1,'\n\tISI2:    \t%i to %i (~%3.0f to %3.0f ms)',nbf_T5_start,nbf_T5_end,(nbf_T5_start-1)*scr.fd*1000,nbf_T5_end*scr.fd*1000);
    fprintf(1,'\n\tRespCue:	%i to %i (~%3.0f to %3.0f ms)',nbf_T6_start,nbf_T6_end,(nbf_T6_start-1)*scr.fd*1000,nbf_T6_end*scr.fd*1000);
end


%% Main loop
resMat  = nan(1,10);
eyeMat	= nan(1,10);
nanMat  = nan(1,10);

eyecrit.eyeOK       = 0;
eyecrit.sacStart    = 0;
eyecrit.sacEnd      = 0;
eyecrit.sacLat      = 0;
eyecrit.latTooLong  = 0;
eyecrit.latTooShort = 0;
eyecrit.sacTarNb    = 0;
eyecrit.sacERRcount = 0;

%eyeMessage1         = 0;
%eyeMessage2         = 0;

% reset time
t_cueON    = NaN;
t_testON   = NaN;
%t_sacON    = NaN;

if const.eyeMvt;Eyelink('message','EVENT_TRIAL_START');end
GetSecs;


for nbf = 1:nbf_max  
    
    % Background color
    Screen('FillRect',scr.main,const.colBG)
    
    
    %% Online fixation check
    
    if const.eyeMvt
        [xEye,yEye] = getCoord(scr,const); % eye coordinates
        
%         % no saccade condition: fixation required throughout trial
%         if const.condition ~= 2 
            
            if nbf >= 1 && nbf <= nbf_max % time window to check
                if sqrt((xEye-const.fixPos(1))^2+(yEye-const.fixPos(2))^2) > const.FTrad_pix
                    Eyelink('message','EVENT_FIXBREAK_START');
                    resMat(1:3) = [898,898,-1];
                    return; % stop trial here and return to run_block
                end
            end

%         % saccade condition: saccades allowed after cue    
%         elseif const.condition == 2
%             
%             % before cue onset (eye not allowed to leave ft)
%             if nbf >= 1 && nbf < nbf_T4_start
%                 if sqrt((xEye-const.fixPos(1))^2+(yEye-const.fixPos(2))^2)>const.FTrad_pix
%                     if ~const.TEST
%                         Eyelink('message','EVENT_FIXBREAK');
%                     end
%                     resMat(1:3) = [898,898,-1];
%                     return
%                 end
%             % after cue onset (eye allowed to leave ft)
%             elseif nbf >= nbf_T4_start && nbf <= nbf_max
%                 if sqrt((xEye-const.fixPos(1))^2+(yEye-const.fixPos(2))^2)>const.FTrad_pix
%                     eyecrit.sacStart = 1;
%                     if ~eyeMessage1
%                         if ~const.TEST
%                             Eyelink('message','EVENT_SACON');
%                         end
%                         eyeMessage1 = 1;
%                         t_sacON = GetSecs;
%                     end
%                 end
%                 
%                 % check if eye arrives at peripheral location
%                 for eyeLoc_idx = [1,3]
%                     if sqrt((xEye-const.locMat(eyeLoc_idx,1))^2+(yEye-const.locMat(eyeLoc_idx,2))^2)<const.STrad_pix
%                         eyecrit.sacEnd = 1;
%                         eyecrit.sacTarNb = eyeLoc_idx;
%                         if ~eyeMessage2
%                             if ~const.TEST
%                                 Eyelink('message','EVENT_SACOFF');
%                             end
%                             eyeMessage2 =1;
%                         end
%                     end
%                 end
%             end
%         end
    end

    
    %% Stuff that's always there
    
    % fixation cross
    my_crosses(scr,const.fixPos,const.fixRad,const.fixW,const.colFix,const.crossAng)
    
    % placeholders
    for idxP = 1:size(const.locMat,1)
        my_placeHolds(scr,const.locMat(idxP,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
    end
    
    
    %% Stuff that's time dependent
    
    % T1: Fixation
    % -
    
    % T2: Cue
    if nbf >= nbf_T2_start && nbf <= nbf_T2_end
        if cueCond == 1
            my_placeHolds(scr,const.locMat(tarPos,:),const.ph_rad,const.dotCue_rad,const.colCue,4,const.phAng);
        elseif cueCond == 2
            my_placeHolds(scr,const.locMat(:,:),const.ph_rad,const.dotCue_rad,const.colCue,4,const.phAng);
        end
    end
    
    % T4: Stimuli
    if nbf >= nbf_T4_start && nbf < nbf_T4_end
        for idxP = 1:size(const.locMat,1)
            Screen('DrawTexture',scr.main,gaborT_texture,[],const.rectMat(idxP,:),tDir_vec(idxP));
        end
    end

    % T6: Response Cue
    if nbf >= nbf_T5_start && nbf <= nbf_T6_end
        Screen('DrawLine', scr.main, const.colRespCue,const.rcueMat(tarPos,1),const.rcueMat(tarPos,2),const.rcueMat(tarPos,3),const.rcueMat(tarPos,4),const.respW);
    end


    %% BIG Flip
    Screen('Flip',scr.main);

    if nbf == nbf_T4_start;   t_cueON = GetSecs; end
    if nbf == nbf_T5_start;   t_testON = GetSecs; end
    
    
    %% Eyelink messages
    if const.eyeMvt
        if nbf == nbf_T1_start; Eyelink('message','T1'); end
        if nbf == nbf_T2_start; Eyelink('message','T2'); end
        if nbf == nbf_T3_start; Eyelink('message','T3'); end
        if nbf == nbf_T4_start; Eyelink('message','T4'); end
        if nbf == nbf_T5_start; Eyelink('message','T5'); end
        if nbf == nbf_T6_start; Eyelink('message','T6'); end
    end
    
    if const.pausetrial
        if nbf == nbf_T2_start || nbf == nbf_T4_start || nbf == nbf_T6_start
            fprintf('\n\tnbf = %i ',nbf);
            KbWait(-1);
            while KbCheck(-1); end
        end
    end
    
    
    %% Video
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
    else
        vid = [];
    end
    
end

%% Close textures made once per trial
Screen('Close',gaborT_texture);



%% Evaluate eye movement / fixation

% eyecrit.sacLat = t_sacON-t_cueON;
% if const.checkEyeLat
%     if ~isnan(eyecrit.sacLat)
%         if eyecrit.sacLat > const.dur_sacLat_max
%             eyecrit.latTooLong = 1;
%         elseif eyecrit.sacLat < const.dur_sacLat_min
%             eyecrit.latTooShort = 1;
%         end
%     end
% end

% if const.eyeMvt
%     % eyecrit.eyeOK#
%     %  1 : all good
%     %  0 : no on-/offset or too fast/slow
%     % -2 : wrong target
%     
%     if const.condition ~= 2 % no saccade to be made
%         eyecrit.eyeOK = 1;
%     else
%         if eyecrit.sacStart && eyecrit.sacEnd && ~eyecrit.latTooShort && ~eyecrit.latTooLong
%             
%             if cueDir == eyecrit.sacTarNb
%                 eyecrit.eyeOK = 1; 
%             else
%                 eyecrit.eyeOK = -2;
%             end
%         else
%             eyecrit.eyeOK = 0;
%         end
%     end
% else
%     eyecrit.eyeOK = 1;
% end


eyecrit.eyeOK = 1;



%% Get response and evaluate / fill matrix
[key_press,key_t,vid] = get_resp(scr,aud,const,expDes,t,my_key,eyecrit,vid);

% Fill resMat (max 10 columns)
% col#1 : key pressed (1:4)
%           1 = left
%           2 = right
% col#2 : resp correct (1) or wrong (0)
% col#3 : eye okay? (1 yes, 0 fixation error)
% col#4 : reaction time
% col#5 : NaN
% col#6 : NaN
% col#7 : NaN
% col#8 : t_cueON
% col#9 : t_testON
% col#10: NaN

% col#1
resMat(1) = key_press.resp;

% col#2
if isnan(key_press.resp)
    resMat(2) = NaN;
elseif tDir_vec(tarPos) <= 0 && key_press.resp == 1
    resMat(2) = 1;
elseif tDir_vec(tarPos) >= 0 && key_press.resp == 2
    resMat(2) = 1; %correct
else
    resMat(2) = 0; %incorrect
end


% col#3
resMat(3) = eyecrit.eyeOK;

% col#4
resMat(4) = key_t;

% col#6
resMat(6) = gabC;                 %column 6 of response matrix is contrast of Gabors

% col#8:10
resMat(8:9) = [t_cueON,t_testON]; %columns 8 and 9 of the response matrix are the time of cue onset and 
                                  %time of stim onset, respectively
% Fill eyeMat
% eyeMat(1:6) = [ eyecrit.sacStart,...
%                 eyecrit.sacEnd,...
%                 eyecrit.sacLat,...
%                 eyecrit.latTooShort,...
%                 eyecrit.latTooLong,...
%                 eyecrit.sacTarNb];


% Give feedback
if resMat(2) == 0% if response was incorrect
    my_sound(12,aud); %% Play low tone
elseif resMat(2) == 1 %but if it was correct
     my_sound(5,aud); %% play high tone
end
if const.checkTrial
    if isnan(resMat(2)) %if resMat column 2 (response correct) is NaN
        fprintf(1,'\n\tNO Response.'); %They did not respond
    else
        txtVal = {'L','R'}; txtVal2 = {'incor','cor'};
        fprintf(1,'\n\n\tResponse = \t\t%s - %s',txtVal{resMat(1)},txtVal2{resMat(2)+1});
    end
end


% Update staircase level
if const.task == 2 && const.stairON && ~isnan(resMat(2))
    
    const.stairc_resp{tarPos} = [const.stairc_resp{tarPos},resMat(2)]; % store current response
    const.stairc_count{tarPos} = [const.stairc_count{tarPos},resMat(2)];
    
    
    % >> correct response
    if resMat(2) == 1
        % go harder (decrease) ... ?
        if numel(const.stairc_count{tarPos}) >= const.downCount && sum(const.stairc_count{tarPos}(end-const.downCount+1:end)) == const.downCount
            
            [nbRev,~] = revCount(const.stairc_val{tarPos});
            
            if nbRev < const.stepChange(1);                                     currStepsize = const.gabor_contr_vec(1);
            elseif nbRev >= const.stepChange(1) && nbRev < const.stepChange(2); currStepsize = const.gabor_contr_vec(2);
            elseif nbRev >= const.stepChange(2) && nbRev < const.stepChange(3); currStepsize = const.gabor_contr_vec(3);
            elseif nbRev >= const.stepChange(3) && nbRev < const.stepChange(4); currStepsize = const.gabor_contr_vec(4);
            elseif nbRev >= const.stepChange(4);                                currStepsize = const.gabor_contr_vec(5);
            end
            
            newVal = const.stairc_val{tarPos}(1,end) - currStepsize;
            if newVal < const.minC; newVal = const.minC; end
            
            const.stairc_val{tarPos} = [const.stairc_val{tarPos},newVal];
            const.stairc_count{tarPos} = []; % reset
            
        % ...or stay at current value
        else
            const.stairc_val{tarPos} = [const.stairc_val{tarPos},const.stairc_val{tarPos}(1,end)];
        end
        
    % >> wrong response    
    elseif resMat(2) == 0
        % go easier (increase) ... ?
        if numel(const.stairc_count{tarPos}) >= const.upCount && sum(const.stairc_count{ tarPos}(end-const.upCount+1:end)) == 0
            
            [nbRev,~] = revCount(const.stairc_val{tarPos});
            
            if nbRev < const.stepChange(1);                                     currStepsize = const.gabor_contr_vec(1);
            elseif nbRev >= const.stepChange(1) && nbRev < const.stepChange(2); currStepsize = const.gabor_contr_vec(2);
            elseif nbRev >= const.stepChange(2) && nbRev < const.stepChange(3); currStepsize = const.gabor_contr_vec(3);
            elseif nbRev >= const.stepChange(3) && nbRev < const.stepChange(4); currStepsize = const.gabor_contr_vec(4);
            elseif nbRev >= const.stepChange(4);                                currStepsize = const.gabor_contr_vec(5);
            end
            
            newVal = const.stairc_val{tarPos}(1,end) + currStepsize;
            if newVal > const.maxC; newVal = const.maxC; end
            
            const.stairc_val{tarPos} = [const.stairc_val{tarPos},newVal];
            const.stairc_count{tarPos} = []; % reset

            % ... or stay at current value
        else
            const.stairc_val{tarPos} = [const.stairc_val{ tarPos},const.stairc_val{ tarPos}(1,end)];
        end
    end
end


% ITI for Nina
% CM made the executive decision to commment this out because Nina will be
% a participant in the experiment and we want the same task parameters for
% everyone.. 
%if ~strcmp(const.sjct,'NH')
    WaitSecs(const.durITI);
%end



end