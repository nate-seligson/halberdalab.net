function [vid]=run_block(scr,aud,const,expDes,el,my_key,vid)
% ----------------------------------------------------------------------
% [vid]=run_block(scr,aud,const,expDes,el,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Main experimental function. Show instructions, prepare EyeLink, 
% check fixation, loop through trials, and save the experimental data.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% aud : sound configuration
% const : experiment constants
% expDes : variable design configuration
% el : EyeLink configuration
% my_key : keyborad configuration
% vid : video structure
% ----------------------------------------------------------------------
% Output(s):
% vid : video structure
% t : trial count
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-11
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------
 
%% Beginning
% info eyelink
if const.eyeMvt
    eyeLinkClearScreen(el.bgCol);
    if const.task == 1     % training
        eyeLinkDrawText(scr.x_mid,scr.y_mid*1.5,el.txtCol,'Instruction TRAINING');
    elseif const.task == 2 % thre
        eyeLinkDrawText(scr.x_mid,scr.y_mid*1.5,el.txtCol,'Instruction THRE');
    elseif const.task == 3 % main
        eyeLinkDrawText(scr.x_mid,scr.y_mid*1.5,el.txtCol,'Instruction MAIN');
    end
end

% instruction
if const.task == 1         % training
    instructionsFB(scr,const,my_key,'Instruction_training'); %%%CM
elseif const.task == 2     % thre
    instructionsFB(scr,const,my_key,'Instruction_thre'); %%%CM
elseif const.task == 3     % main
    instructionsFB(scr,const,my_key,'Instruction_main'); %%%CM
end

% first mouse config
if const.eyeMvt;HideCursor;end


% first calibration
if const.eyeMvt
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'1st Calibration instruction');
    instructionsFB(scr,const,my_key,'Calibration');
    calibresult = EyelinkDoTrackerSetup(el);
    if calibresult==el.TERMINATE_KEY
        return
    end
end


%% Main Loop
%calichecked = 1; % calibration check

expResMat = [];
expDone = 0;
newJ = 0;
%iniClockCalib = GetSecs;
startJ = 1;
endJ = size(expDes.expMat,1);
expDes.iniEndJ = endJ;
if const.mkVideo
    endJ = 1;
end

%calibReq = 0;
calibBreak = 0;
expDes.corTrial = 0;
expDes.incorTrial = 0;

if const.task == 2
    const.stairON = 1;
else
    const.stairON = 0;   
end


while ~expDone
    for t = startJ:endJ
        
        trialDone = 0;
        while ~trialDone

%             % Calib problems
%             nowClockCalib = GetSecs;
%             if (nowClockCalib - iniClockCalib)> expDes.timeCalib
%                 calibReq = 1;
%             end
%             
%             if calibReq==1
%                 if const.eyeMvt
%                     eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Pause');
%                     textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
%                     eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
%                     instructionsFB(scr,const,my_key,'Pause');
%                     eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Calibration Pause');
%                     textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
%                     eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
%                     instructionsFB(scr,const,my_key,'Calibration');
%                     EyelinkDoTrackerSetup(el);
%                     iniClockCalib = GetSecs;
%                     calibBreak = 1;
%                 end
%                 calibReq=0;
%             end
            
            if const.eyeMvt
                Eyelink('command', 'record_status_message ''TRIAL %d''', t);
                Eyelink('message', 'TRIALID %d', t);
            end
            
            ncheck = 0;
            fix    = 0;
            record = 0;
            while fix ~= 1 || ~record
                if const.eyeMvt
                    if ~record
                        
                        Eyelink('startrecording');
                        key=1;
                        while key ~=  0
                            key = EyelinkGetKey(el);		% dump any pending local keys
                        end
                        error=Eyelink('checkrecording'); 	% check recording status
                        
                        if error==0
                            record = 1;
                            Eyelink('message', 'RECORD_START');
                        else
                            record = 0;
                            Eyelink('message', 'RECORD_FAILURE');
                        end
                    end
                else
                    record = 1;
                end
                
                
%                 % check calibration
%                 if const.eyeMvt && ~calichecked
%                     
%                     corC = 0;
%                     while ~corC
%                         error=Eyelink('checkrecording');	% check recording status
%                         if error~=0
%                             record = 0;
%                             Eyelink('message', 'RECORD_FAILURE');
%                             
%                             Eyelink('startrecording');
%                             error=Eyelink('checkrecording');
%                             
%                             if error==0
%                                 Eyelink('message', 'RECORD_START');
%                             else
%                                 Eyelink('message', 'RECORD_FAILURE II');
%                                 error('Eyelink crazy. Please restart program.')
%                             end
%                         end
%                         
%                         [corC]=check_cali(scr,aud,const,my_key);                    %% check_cali
%                         
%                         % repeat calibration if necessary
%                         if ~corC
%                             eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Repeat Calibration instruction');
%                             instructionsFB(scr,const,my_key,'Calibration');
%                             calibresult = EyelinkDoTrackerSetup(el);
%                             if calibresult==el.TERMINATE_KEY
%                                 return
%                             end
%                         end
%                     end
%                     calichecked = 1;
%                 end

                if fix~=1 && record
                    if const.eyeMvt
                        drawTrialInfoEL(scr,const,expDes,t);
                    end
                    if t ==1 || calibBreak == 1
                        calibBreak = 0;
                        wait_key(scr,const,my_key,t);                               %% wait_key
                    end
                    [fix,vid]=check_fix(scr,const,my_key,vid);                      %% check_fix
                    ncheck = ncheck + 1;
                end
                if fix~=1 && record
                    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Error calibration instruction');
                    textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                    eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                    instructionsFB(scr,const,my_key,'Calibration');
                    EyelinkDoTrackerSetup(el);
                    calibBreak = 1;
                    record = 0;
                end
            end
            
            % Trial beginning
            if const.eyeMvt
                Eyelink('message', 'TRIAL_START %d', t);
                Eyelink('message', 'SYNCTIME');
            end
            
            [const,resMat,eyeMat,nanMat,vid,expDes] = run_trial(scr,aud,const,expDes,my_key,t,vid);     %% run_trial
            trialDone = 1;
            
            if const.eyeMvt && resMat(3) ~= -1
                Eyelink('message', 'TRIAL_END %d',  t);
                Eyelink('stoprecording');
            end
            

            % Trial meter
            if resMat(3) == 1 && ~isnan(resMat(2))
                expDes.corTrial = expDes.corTrial +1;
            else
                expDes.incorTrial = expDes.incorTrial +1;
            end
            
            expResMat(t,:)= [expDes.expMat(t,:),resMat,eyeMat,nanMat];
            csvwrite(const.expRes_fileCsv,expResMat);

            
            % If problematic trial...
            if resMat(3) == -1 % broken fixation -> stop trial immediately and save configuration for replay
                fb_fixError(scr,aud,const);
                if ~const.mkVideo
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                end
            elseif isnan(resMat(2))
                if ~const.mkVideo
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                end
%             elseif resMat(3) == 0 || resMat(3) == -2 % incorrect saccade  (none / too fast / too slow / wrong side) -> repeat any of the trials   
%                 if ~const.mkVideo
%                     newJ = newJ+1;
%                     expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
%                 end
            end
        end
    end
    
    if ~newJ
        expDone = 1;
    else
        startJ = endJ+1;
        endJ = endJ+newJ;
        expDes.expMat=[expDes.expMat;expDes.expMatAdd];
        expDes.expMatAdd = [];
        newJ = 0;
    end
end


%% End of block
% my_sound(1,aud);


% Close all textures made once per block
% -


const.my_clock_end = clock;
const_file = fopen(const.const_fileDat,'a+');
fprintf(const_file,'Ending time :\t%ih%i',const.my_clock_end(4),const.my_clock_end(5));
fclose('all');

if const.eyeMvt
    Eyelink('command','clear_screen');
    Eyelink('command', 'record_status_message ''END''');
    WaitSecs(1);
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'The end');
end


%% Show feedback
if ~const.mkVideo
    fprintf(1,'\n\n\tTrials correct   	= %3.0f (%1.2f%%)',expDes.corTrial,expDes.corTrial/(expDes.corTrial+expDes.incorTrial)*100);
    fprintf(1,  '\n\tTrials incorrect  	= %3.0f (%1.2f%%)',expDes.incorTrial,expDes.incorTrial/(expDes.corTrial+expDes.incorTrial)*100);
    
    matIncor = expResMat(expResMat(:,(size(expDes.expMat,2)+3))~=1,:);
    
    incorFix = sum(expResMat(:,(size(expDes.expMat,2)+3))==-1);
    wrongSide = sum(expResMat(:,(size(expDes.expMat,2)+3))==-2);
    sacBefTst = sum(expResMat(:,(size(expDes.expMat,2)+3))==-3);
    tooFast = sum((matIncor(:,end-2)==0));
    tooSlow = sum((matIncor(:,end-1)==0));
    sacStay = sum((matIncor(:,end-3)==0));
    
    fprintf(1,'\n\n\tBroken fixation  \t= %3.0f (%1.2f)',incorFix,incorFix/expDes.incorTrial);
    fprintf(1,'\n\tWrong sac target   \t= %3.0f (%1.2f)',wrongSide,wrongSide/expDes.incorTrial);
    fprintf(1,'\n\tSac too early      \t= %3.0f (%1.2f)',tooFast,tooFast/expDes.incorTrial);
    fprintf(1,'\n\tSac too late       \t= %3.0f (%1.2f)',tooSlow,tooSlow/expDes.incorTrial);
    fprintf(1,'\n\tEye no stay        \t= %3.0f (%1.2f)',sacStay,sacStay/expDes.incorTrial);
    fprintf(1,'\n\tSac before Tst     \t= %3.0f (%1.2f)',sacBefTst,sacBefTst/expDes.incorTrial);
    
    fprintf(1,'\n\n\t\tPerf. correct \t= %3.0f %%',nanmean(expResMat(expResMat(:,22)~=898,22))*100);
    
    % Collect feedback values
    fb.perc_correct = nanmean(expResMat(expResMat(:,22)~=898,22))*100;
    fb.fix_break = incorFix/expDes.incorTrial; if isnan(fb.fix_break); fb.fix_break = 0; end
%     if const.task == 2
%         fb.percSac_correct = expDes.corTrial/(expDes.corTrial+expDes.incorTrial)*100;
%     end
    
    % Show feedback
    if const.task == 1      % training
        instructionsFB(scr,const,my_key,'End_training',5,fb);
    elseif const.task == 2  % threshold
        if const.fromBlock == const.numBlockTot
            instructionsFB(scr,const,my_key,'End_threshold',5,fb);
        else
            instructionsFB(scr,const,my_key,'End_block',5,fb);
        end
    elseif const.task == 3  % main %%CM CHANGE, DIFFERENT SCREEN FOR EACH BLOCK
        if const.fromBlock == const.numBlockTot
            instructionsFB(scr,const,my_key,'End',5,fb);
        else
            instructionsFB(scr,const,my_key,'End_block',5,fb);
        end
    end
    %const.repeatTraining = []
    %CM ADDED FOR REPEATING
    if const.task == 1 & fb.perc_correct < 80
        const.repeatTraining = 1
    else
        const.repeatTraining = 0
    end
%     elseif const.task == 1 & fb.perc_correct > .8
%         const.repeatTraining = 0
%     end
    
    %% Save and plot pretest staircase
    %stairPlotWorks = 0; %%CM
    if const.task == 1
        %save(sprintf('repeatTrain_%s_%s_%s_B%i',const.sjct,const.expName,const.sjct_DomEye,const.fromBlock),'repeatTraining');
        repeatTraining = const.repeatTraining;          save(sprintf('./repeatTraining.mat'),'repeatTraining');
  %end CM
    
    elseif const.task == 2 %&& stairPlotWorks
 
        stairc_val = const.stairc_val;          save(sprintf('./%s_stairc_val.mat',const.sjct_code),'stairc_val');
        stairc_resp = const.stairc_resp;        save(sprintf('./%s_stairc_resp.mat',const.sjct_code),'stairc_resp');
        stairc_count = const.stairc_count;      save(sprintf('./%s_stairc_count.mat',const.sjct_code),'stairc_count');
        
        fprintf(1,'\n\tStair Contrast 1 (right) \t= %3.2f deg',const.stairc_val{1}(1,end));
        fprintf(1,'\n\tStair Contrast 2 (up)    \t= %3.2f deg',const.stairc_val{2}(1,end));
        fprintf(1,'\n\tStair Contrast 3 (left)  \t= %3.2f deg',const.stairc_val{3}(1,end));
        fprintf(1,'\n\tStair Contrast 4 (down)  \t= %3.2f deg',const.stairc_val{4}(1,end));
        
        meanContr = mean([const.stairc_val{1}(1,end),...
                          const.stairc_val{2}(1,end),...
                          const.stairc_val{3}(1,end),...
                          const.stairc_val{4}(1,end)]);
        
        fprintf(1,'\n\n\tStair Contrast ALL \t= %3.2f deg',meanContr);

        % Staircase figure
        try
            sFig = figure('name',sprintf('%s Block %i',const.sjct,const.fromBlock));
            set(sFig,'PaperOrientation', 'landscape','PaperUnits','normalized','PaperPosition', [0 0 1 1],'Color',[1 1 1]);
            set(sFig,'Position',[0,0,1000,1000]);

            hold on;

            % bg lines
            for il = [0:0.1:1]
                plot([0.5,length(const.stairc_val{1})+0.5],[il,il],'Color',[0.8 0.8 0.8]);
            end
            
            % colors for each line
%             myColors = [0.2510    0.8784    0.8157;... % RIGHT  %% old
%                         0.2510    0.8784    0.8157;... % UP
%                         0.2510    0.8784    0.8157;... % LEFT
%                         0.2510    0.8784    0.8157];   % DOWN
                    
              myColors = [1         0         1;... % RIGHT- purple  %% CM Changed
                          0         1         1;... % UP- cyan
                          0         1         0;... % LEFT- green
                          1         0         0];   % DOWN- red
                    
                    
            % staircase line        
            for i = 1:4
                plot(1:length(stairc_val{i}),stairc_val{i},'LineWidth',2,'Color',myColors(i,:));        
            end
            legend('RIGHT- purple', 'UP- cyan', 'LEFT- green', 'DOWN- red');%CM added
            title(sprintf('Average contrast: %1.2f',meanContr));
            
            set(gca,'XLim',[0.5 length(stairc_val{1})+0.5],'YLim',[0,1],...
                    'XTick',0:5:length(stairc_val{1}),'XTickLabel',0:5:length(stairc_val{i}),...
                    'YTick',[0:0.2:1],'YTickLabel',[0:0.2:1]);

            plot_file = sprintf('%s_StairsB%i',const.sjct,const.fromBlock);
            
            
            
            try
                if ~isdir('../Figures/');mkdir('../Figures/');end
                saveas(sFig,['../Figures/',plot_file,'.pdf']);
                close all;
            catch err2
                fprintf(1,'The identifier was:\n%s',err2.identifier);
                fprintf(1,'There was an error! The message was:\n%s',err2.message);
            end
            
        catch err
            fprintf(1,'The identifier was:\n%s',err.identifier);
            fprintf(1,'There was an error! The message was:\n%s',err.message);
        end
     
    elseif const.task == 3
        
        % save contrast and average performance (to load & adjust in next block)
        avPerf = fb.perc_correct;
        avContr = const.gabor_contr; 
        save(sprintf('avContr_%s_%s_%s_B%i',const.sjct,const.expName,const.sjct_DomEye,const.fromBlock),'avContr');
        save(sprintf('avPerf_%s_%s_%s_B%i',const.sjct,const.expName,const.sjct_DomEye,const.fromBlock),'avPerf');
    end

end
end