function eyeana_tabCM(sub)
% ----------------------------------------------------------------------
% eyeana_tab(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Read out EyeLink messages and create tab-file containing each trial's 
% critical temporal information.
%
% tab-Files have the following columns
% -> see mainMat_cols
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-11
% Project : DPF
% Version : 3.0
% ----------------------------------------------------------------------

resMat = csvread(sprintf('expRes%s_%s_%s.csv',sub.ini,sub.expName,sub.domEye));

msgstr = sprintf('%s_B%i.msg',sub.ini,sub.block);
msgfid = fopen(msgstr,'r');

fprintf(1,'\nPre-processing %s_B%i.msg file... ',sub.ini,sub.block);

msgNumCol = 30;
tab = nan(size(resMat,1),msgNumCol);
t = 0;

stillTheSameData = 1;
while stillTheSameData
    stillTheSameTrial = 1;
    while stillTheSameTrial
        line = fgetl(msgfid);
        if ~ischar(line)                            % end of file
            stillTheSameData = 0;
            break;
        end
        if ~isempty(line)                           % skip empty lines
            la = strread(line,'%s');                % matrix of strings in line 
            if length(la) >= 3
                
                
                switch char(la(3))
                    
                    %%% runTrials [1-10]
                    
                    case 'TRIALID';                     t = t+1;
                        tab(t,1)  = str2double(char(la(4)));
                    case 'TRIAL_START'                
                        tab(t,2)  = str2double(char(la(2)));
                    case 'TRIAL_END'
                        tab(t,3)  = str2double(char(la(2))); %time
                        tab(t,4)  = resMat(t,1); % resmat block
                        tab(t,5)  = resMat(t,3); % resmat trial
                        tab(t,6)  = resMat(t,4); % trial num from dat
                        
                        stillTheSameTrial = 0;
                        
                    case 'EVENT_FixationCheck'       
                        tab(t,10)  = str2double(char(la(2)));


                    %%% runSingleTrial & getAnswer [11-20]
                    
                    case 'EVENT_TRIAL_START'         
                        tab(t,11)  = str2double(char(la(2)));
                        
                    case 'T2'                        
                        tab(t,12)  = str2double(char(la(2)));
                    case 'T3'
                        tab(t,13)  = str2double(char(la(2)));
                    case 'T4'
                        tab(t,14) = str2double(char(la(2)));
                    case 'T5'
                        tab(t,15) = str2double(char(la(2)));
                    case 'T6'
                        tab(t,16) = str2double(char(la(2)));
                    case 'T7'
                        tab(t,17) = str2double(char(la(2)));    
                        
                    case 'EVENT_ANSWER'                
                        tab(t,18) = str2double(char(la(2)));
                    case 'EVENT_TIMEOUT'                
                        tab(t,19) = str2double(char(la(2)));
                        
                        
                    %%% Online eye check
                    
                    case 'EVENT_FIXBREAK'
                        tab(t,20) = str2double(char(la(2)));
%                     case 'EVENT_SACON'
%                         tab(t,22) = str2double(char(la(2)));
%                     case 'EVENT_SACOFF'
%                         tab(t,23) = str2double(char(la(2)));       
                end
            end
        end
    end
end

save(sprintf('%s_B%i_tab.mat',sub.ini,sub.block),'tab');
fclose(msgfid);

end