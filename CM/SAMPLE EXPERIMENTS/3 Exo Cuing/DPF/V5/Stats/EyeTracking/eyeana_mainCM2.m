function [scr,const,eyeana]=eyeana_mainCM2(sub,scr,const,eyeana)
% ----------------------------------------------------------------------
% eyeana_main(const,sub,eyeana)
% ----------------------------------------------------------------------
% Goal of the function :
% Main saccade, blink, and fixation analysis.
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
% scr : screen configuration
% const : experiment constants
% eyeana : eye analysis settings
% ----------------------------------------------------------------------
% Output(s):
% scr : screen configuration
% const : experiment constants
% eyeana : eye analysis settings
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

%% Create file strings
% directory settings
if ~isdir('../AllB/csv');mkdir('../AllB/csv');end
if ~isdir('../AllB/summary');mkdir('../AllB/summary');end
if ~isdir('../AllB/trace');mkdir('../AllB/trace');end

fprintf(1,'\nLoading %s_B%i files...',sub.ini,sub.block);

try
    %dat = load(sprintf('%s_B%i.dat',sub.ini,sub.block));                        % dat importdata
    dat = importdata(sprintf('%s_B%i.dat',sub.ini,sub.block));

catch err
    %fprintf(1,'\nThe identifier was:\n%s',err.identifier);
    beep;
    fprintf(1,'\n\n\n\t\t\t\t\t\tError message : %s\n\n',err.message);
    dat = importdata(sprintf('%s_B%i.dat',sub.ini,sub.block));
end
fcon = fopen(sprintf('summary/%s_Summary',sub.ini),'w');                        % fcon
load(sprintf('%s_B%i_tab.mat',sub.ini,sub.block),'tab');                        % tab
resMat = csvread(sprintf('expRes%s_%s_%s.csv',sub.ini,sub.expName,sub.domEye)); % resMat


fprintf(1,'\nProcessing %s_B%i eye data (Engbert analysis)...\n ',sub.ini, sub.block);

%load(sprintf('design%s_%s_%s.mat',sub.ini,sub.expName,sub.domEye));
%load(sprintf('const_file%s_%s_%s.mat',sub.ini,sub.expName,sub.domEye));
%load(sprintf('scr_file%s_%s_%s.mat',sub.ini,sub.expName,sub.domEye));


%% Loop on all trials
matCor      = [];
matIncor    = [];
coordCor    = [];
coordIncor  = [];

for t = 1:(size(tab,1))

    % Variables
    sac_cue    = resMat(t, 9);   % Rand 6  saccade target cue (2=left, 0=neutral, 1=right)
    eyeOK      = resMat(t,23);   % EyeOK:  1 = SAC/FIX COR,   -1 = eyeFIX BREAK,  0 = SAC/FIX INCOR, -2 = SAC WRONGSIDE
    
    
    % Spatial
    fixPos  = [const.fixPos(1),const.fixPos(2)];
    tarPos  = [NaN,NaN];
    fixRad  = eyeana.fixRad*eyeana.PPD;
    %tarRad  = eyeana.tarRad*eyeana.PPD;
    
%     if eyeOK == 1 && sac_cue ~= 0 % saccade trial
%         try
%             tarPos = [const.posMat(sac_cue,1),const.posMat(sac_cue,2)];
%         catch
%             const.posMat = [805.4873,574.0577;474.5127,574.0577];
%             tarPos = [const.posMat(sac_cue,1),const.posMat(sac_cue,2)];
%         end
%     else
%         tarPos = [NaN,NaN];
%     end
    fixRec = [fixPos fixPos] + [-fixRad -fixRad fixRad fixRad];
    %tarRec = [tarPos tarPos] + [-tarRad -tarRad tarRad tarRad];
        
    
    % Temporal
    tT1  	=   tab(t,11)-250;
    tT2     =   tab(t,12);      durT1       = tT2 - tT1;    % fixation duration
    tT3     =   tab(t,13);      durT2       = tT3 - tT2;    % 
    tT4   	=   tab(t,14);      durT3       = tT4 - tT3;    %
    tT5   	=   tab(t,15);      durT4       = tT5 - tT4;    %
    tT6   	=   tab(t,16);      durT5       = tT6 - tT5;    %
    tT7     =   tab(t,17);      durT6       = tT7 - tT6;    %
    tResp   =   tab(t,18);      durT7       = tResp - tT7;  %
         
    tEndFix   = tT6;    % response cue onset
    tEndCheck = tT6;    % response cue onset
    
%     tEndFix   = tT7;    % cue onset
%     tEndCheck = tT7;    % response cue onset
    
    
    %% Exclusion criteria
    onlineError  	=  0;   % #1	Online eye error
    tsMiss          =  0;   % #2    Missing times stamp(s)
    blinkError  	=  0;   % #3    Blink(s)
    fixError        =  0;   % #4    Fixation break
    noSacError   	=  0;   % #5    No saccade
    inaccSacError 	=  0;   % #5    Innaccurate saccade   
    
    firstTimeOut  	=  0;
    timeOut      	=  NaN;

    goodTrial     	=  0;	%       All criteria good
    badTrial      	=  0;	%       1+ criterion bad 
    
    
    sacOnset        =  NaN;
    sacOffset       =  NaN;
    sacDur          =  NaN;
    sacVPeak        =  NaN;
    sacDist         =  NaN;
    sacAmp          =  NaN;
    sacxOnset       =  NaN;
    sacyOnset       =  NaN;
    sacxOffset      =  NaN;
    sacyOffset      =  NaN;
    sacLatency      =  NaN;

    
    % #1 Online error trials (EyeOK and FingerOK)
    if eyeOK ~= 1
        onlineError = 1;
        valRes = [  NaN,	NaN,	NaN,	NaN,	NaN, ...      
                    NaN,    NaN, 	NaN,   	NaN,   	NaN, ...   
                    NaN,    NaN, 	NaN,	NaN, 	NaN, ...      
                    NaN,    NaN,  	NaN,	NaN,  	NaN];
    end
    
    idx  = find(dat(:,1) >= tT1 & dat(:,1) <= tEndCheck);
    
    % #2 Missing time stamps trial (check between saccade cue and end of trial)
    matTrial = dat(idx,1:3);
    time = dat(idx,1);
    if sum(diff(time)>(1000/eyeana.SAMPRATE)) || isempty(time)
        tsMiss  = 1;
    end
    
    
    % #3 Blinks during trial
    idxmbdi = find(dat(idx,eyeana.crit_cols)==-1, 1);
    if ~isempty(idxmbdi) && ~onlineError
        blinkError = 1;
    end 
    
    
    % #4 Offline fixation check
    if ~onlineError && ~tsMiss && ~blinkError
        
        idx  = find(dat(:,1) >= tT1 & dat(:,1) < tEndCheck);
        
        resp = [];
        for k = 1:size(idx,1)
            xVAL = dat(idx(k),2);
            yVAL = dat(idx(k),3);
            if sqrt((xVAL-fixPos(1))^2+(yVAL-fixPos(2))^2) > fixRad
                resp(k) = 1;
                while ~firstTimeOut
                    firstTimeOut = 1;
                    timeOut = time(k,1);
                end
            else
                resp(k) = 0;
            end
        end
        if sum(resp) ~= 0
            fixError = 1;
        end
    end
    
    % #5 Saccade detection & accuracy
    if ~onlineError && ~blinkError && ~tsMiss
        if ~isnan(tarPos(1)) % saccade trial
            idx  = find(dat(:,1) >= tEndFix & dat(:,1) < tEndCheck);
            time = dat(idx,1);
            
            x = eyeana.DPP*([dat(idx,2), (dat(idx,3))]);

            v  = vecvel(x, eyeana.SAMPRATE, eyeana.VELTYPE);
            ms = microsaccMerge(x,v,eyeana.velSD,eyeana.minDur,eyeana.mergeInt);
            ms = saccpar(ms);
            
            % (ms,1) = saccade onset
            % (ms,2) = saccade offset
            % (ms,3) = saccade duration
            % (ms,4) = peak velocity
            % (ms,5) = saccade distance
            % (ms,6) = distance angle
            % (ms,7) = saccade amplitude
            % (ms,8) = amplitude angle
            
            if size(ms,1)>0 % there is any saccade ...
                amp  = ms(:,7);
                ms   = ms(amp>eyeana.maxMSAmp,:); % ... bigger than threshold for micro saccade
            end
            
            if size(ms,1) > 0 && ~isempty(ms)
                
                nSac   = size(ms,1);
                sAcc = [];

                % evaluate saccade(s)
                for s = 1:nSac
                    xBeg  = eyeana.PPD*x(ms(s,1),1);  % sac x-onset
                    yBeg  = eyeana.PPD*x(ms(s,1),2);  % sac y-onset
                    xEnd  = eyeana.PPD*x(ms(s,2),1);  % sac x-offset
                    yEnd  = eyeana.PPD*x(ms(s,2),2);  % sac y-offset
                    
                    fixedFix = isincircle(xBeg,yBeg,fixRec);
                    fixedTar = isincircle(xEnd,yEnd,tarRec);
                    
                    if fixedFix
                        sAcc = s;
                    end
                end
                
                
                % first saccade metrics
                if ~isempty(sAcc)
                    if ~fixedTar;inaccSacError=1;end
                    sacOnset       = time(ms(sAcc,1));
                    sacOffset      = time(ms(sAcc,2));
                    sacDur         = ms(sAcc,3);
                    sacVPeak       = ms(sAcc,4);
                    sacDist        = ms(sAcc,5);
                    sacAmp         = ms(sAcc,7);
                    sacxOnset      = eyeana.PPD*x(ms(sAcc,1),1);
                    sacyOnset      = eyeana.PPD*x(ms(sAcc,1),2);
                    sacxOffset     = eyeana.PPD*x(ms(sAcc,2),1);
                    sacyOffset     = eyeana.PPD*x(ms(sAcc,2),2);
                    sacLatency     = sacOnset - tEndFix;
                else
                    inaccSacError  = 1;
                end
            else
                noSacError = 1;
            end
        end
    end

    
    valRes = [  timeOut,        sacOnset,       sacOffset,      sacDur,         sacVPeak, ...
                sacDist,        sacAmp,         sacxOnset,      sacyOnset,      sacxOffset, ...
                sacyOffset,     sacLatency,     NaN,            NaN,            NaN, ...
                NaN,            NaN,            NaN,            NaN,            NaN, ...
                durT1,          durT2,          durT3,          durT4           durT5, ...
                durT6,          durT7,          NaN,            NaN,            NaN];
    
            
    %% Trial evaluation
    
    if ~onlineError && ~tsMiss && ~blinkError && ~fixError && ~noSacError && ~inaccSacError
        goodTrial = 1;
    else
        badTrial = 1;
    end

    
    typeT = [goodTrial,     badTrial,   onlineError,    tsMiss, ...
             blinkError,    fixError,   noSacError, 	inaccSacError,...
             NaN,           NaN];
    matTypeTrial(t,:) = [resMat(t,:),tab(t,:),valRes,typeT];
    
    if goodTrial
        matCor = [matCor;matTypeTrial(t,:)];
        coordCor{t} = {matTypeTrial(t,:);matTrial};
    end
    
    if badTrial
        matIncor = [matIncor;matTypeTrial(t,:)];
        coordIncor{t} = {matTypeTrial(t,:);matTrial};
    end
end

goodTrial_Sum  	=   sum(matTypeTrial(:,end-9));
badTrial_Sum   	=   sum(matTypeTrial(:,end-8));
onlineError_Sum	=   sum(matTypeTrial(:,end-7));
tsMiss_Sum    	=   sum(matTypeTrial(:,end-6));
blink_Sum     	=   sum(matTypeTrial(:,end-5));
fixError_Sum  	=   sum(matTypeTrial(:,end-4));
noSac_Sum    	=   sum(matTypeTrial(:,end-3));
inaccSac_Sum   	=   sum(matTypeTrial(:,end-2));
sacBefTest_Sum  =	sum(matTypeTrial(:,end));

if badTrial_Sum == 0
    matIncor = zeros(1,size(matCor,2));
end

dlmwrite(sprintf('../AllB/csv/%s_B%i_corMat.csv',sub.ini,sub.block),matCor,'precision','%10.5f');
dlmwrite(sprintf('../AllB/csv/%s_B%i_incorMat.csv',sub.ini,sub.block),matIncor,'precision','%10.5f');

if sum(matCor(:,3)-(matCor(:,55))) ~= 0 || sum(matCor(:,51)-(matCor(:,53))) ~= 0 
    fprintf('\n!!!!!!!! ERROR!! No End-timestamp in trial in block %i! \n',matCor(1,1));
end

%save(sprintf('coord/%s_B%i_coordIncor.mat',sub.ini,sub.block),'coordIncor');
%save(sprintf('coord/%s_B%i_coordCor.mat'  ,sub.ini,sub.block),'coordCor');


%% Summary

for tFile = 1
    if tFile==1;fidF=1;else fidF=fcon;end
    
    fprintf(fidF,'\n\tTrials :                  \t%i\n\n',t);
    
    fprintf(fidF,'\tGood Trials :               \t%i\n',goodTrial_Sum);
    fprintf(fidF,'\tBad Trials :                \t%i\n\n',badTrial_Sum);    
    
    fprintf(fidF,'\tOnline eye error trials :   \t%i\n',onlineError_Sum);

    fprintf(fidF,'\tMissing time stamps :       \t%i\n',tsMiss_Sum);
    fprintf(fidF,'\tBlink during trial :        \t%i\n',blink_Sum);
    fprintf(fidF,'\tOffFixErr :                 \t%i\n',fixError_Sum);
    fprintf(fidF,'\tNo sac. detected :          \t%i\n',noSac_Sum);
    fprintf(fidF,'\tInaccurate sac. :           \t%i\n',inaccSac_Sum);
    fprintf(fidF,'\tSac before test offset :    \t%i\n\n',sacBefTest_Sum);
    
    fprintf(fidF,'\tMean sac. latency :         \t%3.1f ms\n',nanmean(matTypeTrial(:,92)));
    fprintf(fidF,'\tMean sac. amplitude :       \t%2.2f dVa\n\n',nanmean(matTypeTrial(:,87)));
    
    if tFile == 2;fclose(fidF);end
    
end
end