%% Import
%% Import

close all

clearvars -except subjectStructNM ;
%subjectStructNM = struct;

%%
source_dir = '/Users/carolinemyers/Desktop/CM_Experiments/IN_PROGRESS/NumberModel/Color/NumberModelv3.1.23/data';
%dest_dir = '/Users/carolinemyers/Desktop/CM_Experiments/fire/FlSearchv3-circle2/FLSearch_v2.1.7/dataana'
source_files = dir(fullfile(source_dir, '*.csv'));

%% set up opts
opts = delimitedTextImportOptions("NumVariables", 34);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "trial_index", "time_elapsed", "internal_node_id", "subject_id", "study_id", "session_id", "condition", "rt", "stimulus", "response", "position_of_items", "colors_of_items", "wheel_spin", "response_angle", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "error", "which_test", "set_size", "wheel_num_options", "actual_mask_duration", "actual_stim_duration", "CMColor", "CMDispTime", "randomSpinAmount", "mask", "task"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "condition", "rt", "stimulus", "response", "position_of_items", "mask", "task"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "condition", "rt", "stimulus", "response", "position_of_items", "mask", "task"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["colors_of_items", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "error", "CMColor"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["colors_of_items", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "error", "CMColor"], "ThousandsSeparator", ",");

%%
for ii = 1:length(source_files)
    if length(source_files(ii).name) > 5
        data = readtable(fullfile(source_dir,source_files(ii).name),opts);
        %csvwrite(fullfile(dest_dir,source_files(ii).name));
        
        %%
        
        % indexTargetPresent =  strcmp(data.target_present,'true') == 1;
        % dataTP = data(indexTargetPresent,:);
        % clearvars indexTargetPresent;
        % data = dataTP;
        
        
        
        subjectID = data.subject_id(1);
        subjectID = strcat('s',num2str(ii),'_',subjectID);
        subjectStructNM.(subjectID).subjectID = subjectID;
        
        data([1:16],:) = [];
        
        
        subjectStructNM.(subjectID).rawData = data;
        
        
        cleanedData = rmmissing(data,'DataVariables',{'error'});
        
        subjectStructNM.(subjectID).cleanedData = cleanedData;
        
        
        %%
        
        
        indexGuessTrials =  cleanedData.CMDispTime == 0;
        guessTrials = cleanedData(indexGuessTrials,:);
        clearvars indexGuessTrials
        subjectStructNM.(subjectID).guessTrials = guessTrials;
        
        indexNonGuessTrials =  cleanedData.CMDispTime ~= 0;
        nonGuessTrials = cleanedData(indexNonGuessTrials,:);
        clearvars indexNonGuessTrials
        subjectStructNM.(subjectID).nonGuessTrials = nonGuessTrials;
        
        
        indexNonGuessTrials66 =  cleanedData.CMDispTime == 66;
        nonGuessTrials66 = cleanedData(indexNonGuessTrials66,:);
        clearvars indexNonGuessTrials66
        subjectStructNM.(subjectID).nonGuessTrials66 = nonGuessTrials66;
        
        %% Transform the data.
        for ii = 1:height(cleanedData)
            if cleanedData.CMColor(ii) > 180 
                tempTP = cleanedData.CMColor(ii);%true color
                tempResp = cleanedData.reported_color_discrete(ii); %color they respond
                diff = ((360 - tempTP) + tempResp);
                cleanedData.TransformedResponse(ii) = tempResp + 360;
                %cleanedData.TransformedResponse(ii) = 360 + (360 - tempTP) + tempResp; %get transformed response
              %   cleanedData.TransformedResponse(ii) = -1*((360 - tempTP) + tempResp);
                clearvars tempTP tempResp diff
            elseif cleanedData.CMColor(ii) < 180
                tempTP = cleanedData.CMColor(ii);
                tempResp = cleanedData.reported_color_discrete(ii);
               % cleanedData.TransformedResponse(ii) = tempResp - (360 + tempTP) + tempTP;     
               % cleanedData.TransformedResponse(ii) = (360 - tempTP) + tempResp; 
               %diff = (360 + tempTP) + tempTP - 360;
              % cleanedData.TransformedResponse(ii) = tempTP - diff;
              cleanedData.TransformedResponse(ii) = tempResp - 360;
              %cleanedData.TransformedResponse(ii) = (360 + tempTP) + tempTP - 360;
              clearvars tempTP tempResp diff
            else
            end
        end
        

        %% Now get diff and take min.
        for ii = 1:height(cleanedData)
            tempTP = cleanedData.CMColor(ii);
            tempResp = cleanedData.reported_color_discrete(ii);
            tempTransformedResp = cleanedData.TransformedResponse(ii);
            
            if abs(tempTP - tempResp) > abs(tempTransformedResp - tempTP)
                cleanedData.TransformedResponseWinner(ii) = tempTransformedResp;
                
            elseif abs(tempTP - tempResp) < abs(tempTransformedResp - tempTP)
                cleanedData.TransformedResponseWinner(ii) = tempResp;
            end
        end
        
        
        
        %% and save
        
        indexGuessTrialsTransformed =  cleanedData.CMDispTime == 0;
        guessTrialsTransformed = cleanedData(indexGuessTrialsTransformed,:);
        clearvars indexGuessTrialsTransformed
        subjectStructNM.(subjectID).guessTrialsTransformed = guessTrialsTransformed;
        
        indexNonGuessTrialsTransformed =  cleanedData.CMDispTime ~= 0;
        NonGuessTrialsTransformed = cleanedData(indexNonGuessTrialsTransformed,:);
        clearvars indexNonGuessTrialsTransformed
        subjectStructNM.(subjectID).nonGuessTrialsTransformed = NonGuessTrialsTransformed;
        
        
        indexNonGuessTrials66Transformed =  cleanedData.CMDispTime == 66;
        nonGuessTrials66Transformed = cleanedData(indexNonGuessTrials66Transformed,:);
        clearvars indexNonGuessTrials66Transformed
        subjectStructNM.(subjectID).nonGuessTrials66Transformed = nonGuessTrials66Transformed;
        
        
        %% check trial level difference
        
        for jj = 2:height(cleanedData)
            prevTrialAngle = cleanedData.physical_response_angle(jj-1);
            currTrialAngle = cleanedData.physical_response_angle(jj);
            cleanedData.diffScore(jj) = max(prevTrialAngle,currTrialAngle) - min(prevTrialAngle,currTrialAngle);
            
        end
        subjectStructNM.(subjectID).cleanedData = cleanedData;
        %% Now save
        
        %cd /Users/carolinemyers/Desktop/CM_Experiments/fire/FLSearch_v1.1.20/analysis
        cd
        
        save('subjectStructNM3_1_23.mat','subjectStructNM');
        clearvars data
        
    else
    end
end
