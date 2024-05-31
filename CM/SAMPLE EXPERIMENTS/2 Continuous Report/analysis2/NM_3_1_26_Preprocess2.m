%% Init
%Caroline Myers
%% Import

close all

clearvars -except subjectStructNM3126 ;
%subjectStructNM3126 = struct;
errorCutoff = 60;
%%
source_dir = '/Users/carolinemyers/Desktop/CM_Experiments/IN_PROGRESS/NumberModel/Color/Color1_1_8/data';
%dest_dir = '/Users/carolinemyers/Desktop/CM_Experiments/fire/FlSearchv3-circle2/FLSearch_v2.1.7/dataana'
source_files = dir(fullfile(source_dir, '*.csv'));

%% set up opts
opts = delimitedTextImportOptions("NumVariables", 34);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "trial_index", "time_elapsed", "internal_node_id", "subject_id", "study_id", "session_id", "condition", "rt", "stimulus", "response", "position_of_items", "colors_of_items", "color_of_target", "wheel_spin", "response_angle", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "error", "which_test", "set_size", "wheel_num_options", "actual_mask_duration", "actual_stim_duration", "CMDispTime", "randomSpinAmount", "task", "mask"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "double", "string", "string", "string", "string", "string", "double", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "condition", "stimulus", "response", "task", "mask"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "condition", "stimulus", "response", "task", "mask"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["rt", "position_of_items", "colors_of_items", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "error"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["rt", "position_of_items", "colors_of_items", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "error"], "ThousandsSeparator", ",");

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
        
        
        %subjectID = 'cat';
        subjectID = data.subject_id(1);
        subjectID = strcat('s',num2str(ii),'_',subjectID);
        subjectStructNM3126.(subjectID).subjectID = subjectID;
        
        %data([1:16],:) = [];
        
        
        subjectStructNM3126.(subjectID).rawData = data;
        
        
        cleanedDataIndex = strcmp(data.task,'color');
        cleanedData = data(cleanedDataIndex,:);
        cleanedData.absError = abs(cleanedData.error);
        clearvars cleanedDataIndex
        
        %cleanedData = rmmissing(data,'DataVariables',{'error'});
        
        subjectStructNM3126.(subjectID).cleanedData = cleanedData;
        
        
        %%
        
        
        indexGuessTrials =  cleanedData.CMDispTime == 0;
        guessTrials = cleanedData(indexGuessTrials,:);
        clearvars indexGuessTrials
        subjectStructNM3126.(subjectID).guessTrials = guessTrials;
        
        indexNonGuessTrials =  cleanedData.CMDispTime ~= 0;
        nonGuessTrials = cleanedData(indexNonGuessTrials,:);
        %nonGuessTrials.CMDispTime

        clearvars indexNonGuessTrials
        subjectStructNM3126.(subjectID).nonGuessTrials = nonGuessTrials;
        subjectStructNM3126.(subjectID).nonGuessDurations = nonGuessTrials.CMDispTime;
        
         indexNonGuessTrials132 =  cleanedData.CMDispTime == 132;
        nonGuessTrials132 = cleanedData(indexNonGuessTrials132,:);
        clearvars indexNonGuessTrials132
        subjectStructNM3126.(subjectID).nonGuessTrials132 = nonGuessTrials132;
        
   
        indexNonGuessTrials66 =  cleanedData.CMDispTime == 66;
        nonGuessTrials66 = cleanedData(indexNonGuessTrials66,:);
        clearvars indexNonGuessTrials66
        subjectStructNM3126.(subjectID).nonGuessTrials66 = nonGuessTrials66;
        
        %% Clean the data
        
         
            for ii = 1:height(subjectStructNM3126.(subjectID).nonGuessTrials)
               subjectStructNM3126.(subjectID).meanNonGuessError = nanmean(subjectStructNM3126.(subjectID).nonGuessTrials.absError);
            
               if nanmean(subjectStructNM3126.(subjectID).nonGuessTrials.absError) < errorCutoff
                subjectStructNM3126.(subjectID).included = 1;
            elseif nanmean(subjectStructNM3126.(subjectID).nonGuessTrials.absError) >= errorCutoff
                subjectStructNM3126.(subjectID).included = 0;
            else
            end
            end
            
        
        %% Transform the data.
        for ii = 1:height(cleanedData)
            if cleanedData.color_of_target(ii) > 180 
                tempTP = cleanedData.color_of_target(ii);%true color
                tempResp = cleanedData.reported_color_discrete(ii); %color they respond
                diff = ((360 - tempTP) + tempResp);
                cleanedData.TransformedResponse(ii) = tempResp + 360;
                %cleanedData.TransformedResponse(ii) = 360 + (360 - tempTP) + tempResp; %get transformed response
              %   cleanedData.TransformedResponse(ii) = -1*((360 - tempTP) + tempResp);
                clearvars tempTP tempResp diff
            elseif cleanedData.color_of_target(ii) < 180
                tempTP = cleanedData.color_of_target(ii);
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
            tempTP = cleanedData.color_of_target(ii);
            tempResp = cleanedData.reported_color_discrete(ii);
            tempTransformedResp = cleanedData.TransformedResponse(ii);
            
            if abs(tempTP - tempResp) > abs(tempTransformedResp - tempTP)
                cleanedData.TransformedResponseWinner(ii) = tempTransformedResp;
                
            elseif abs(tempTP - tempResp) < abs(tempTransformedResp - tempTP)
                cleanedData.TransformedResponseWinner(ii) = tempResp;
           
            
            elseif abs(tempTP - tempResp) == abs(tempTransformedResp - tempTP)
                cleanedData.TransformedResponseWinner(ii) = tempResp;
            end
        end
        
        
        
        %% and save
        
        indexGuessTrialsTransformed =  cleanedData.CMDispTime == 0;
        guessTrialsTransformed = cleanedData(indexGuessTrialsTransformed,:);
        clearvars indexGuessTrialsTransformed
        subjectStructNM3126.(subjectID).guessTrialsTransformed = guessTrialsTransformed;
        
        indexNonGuessTrialsTransformed =  cleanedData.CMDispTime ~= 0;
        NonGuessTrialsTransformed = cleanedData(indexNonGuessTrialsTransformed,:);
        clearvars indexNonGuessTrialsTransformed
        subjectStructNM3126.(subjectID).nonGuessTrialsTransformed = NonGuessTrialsTransformed;
%        subjectStructNM3126.(subjectID).nonGuessTrialNUMSTransformed = nonGuessTrialNUMSTransformed;

        
        indexNonGuessTrials66Transformed =  cleanedData.CMDispTime == 66;
        nonGuessTrials66Transformed = cleanedData(indexNonGuessTrials66Transformed,:);
        clearvars indexNonGuessTrials66Transformed
        subjectStructNM3126.(subjectID).nonGuessTrials66Transformed = nonGuessTrials66Transformed;
        
                indexNonGuessTrials132Transformed =  cleanedData.CMDispTime == 132;
        nonGuessTrials132Transformed = cleanedData(indexNonGuessTrials132Transformed,:);
        clearvars indexNonGuessTrials132Transformed
        subjectStructNM3126.(subjectID).nonGuessTrials132Transformed = nonGuessTrials132Transformed;
        
        
        subjectStructNM3126.(subjectID).meanError132 = nanmean(subjectStructNM3126.(subjectID).nonGuessTrials132Transformed.absError)
        %% check trial level difference
        
        for jj = 2:height(cleanedData)
            prevTrialAngle = cleanedData.physical_response_angle(jj-1);
            currTrialAngle = cleanedData.physical_response_angle(jj);
            cleanedData.diffScore(jj) = max(prevTrialAngle,currTrialAngle) - min(prevTrialAngle,currTrialAngle);
            
        end
        subjectStructNM3126.(subjectID).cleanedData = cleanedData;
        %% Now save
        
        %cd /Users/carolinemyers/Desktop/CM_Experiments/fire/FLSearch_v1.1.20/analysis
        cd
        
        save('subjectStructNM3_1_26.mat','subjectStructNM3126');
        clearvars data
        
    else
    end
end
