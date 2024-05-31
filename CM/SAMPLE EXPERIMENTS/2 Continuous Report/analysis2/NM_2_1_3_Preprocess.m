%% Init
%Caroline Myers
%% Import

close all

clearvars -except subjectStructNM3126 ;
%subjectStructNM3126 = struct;
errorCutoff = 60;
%%
source_dir = '/Users/carolinemyers/Desktop/CM_Experiments/IN_PROGRESS/NumberModel3/Color/Color2_1_3/data';
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
for kk = 1:length(source_files)

    if length(source_files(kk).name) > 5

        data = readtable(fullfile(source_dir,source_files(kk).name),opts);
        %csvwrite(fullfile(dest_dir,source_files(ii).name));
        
        %%
        
        % indexTargetPresent =  strcmp(data.target_present,'true') == 1;
        % dataTP = data(indexTargetPresent,:);
        % clearvars indexTargetPresent;
        % data = dataTP;
        
        
        %subjectID = 'cat';
        subjectID = data.subject_id(1);
        subjectID = strcat('s',num2str(kk),'_',subjectID);
        subjectStructNM3126.(subjectID).subjectID = subjectID;
        
        %data([1:16],:) = [];
        
        
        subjectStructNM3126.(subjectID).rawData = data;
        
        
        cleanedDataIndex = strcmp(data.task,'color');
        cleanedData = data(cleanedDataIndex,:);
       % cleanedData.absError = abs(cleanedData.error);
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
        

    
        subjectStructNM3126.(subjectID).cleanedData = cleanedData;

            if kk == 1
        cleanedDataAll = cleanedData;
            else 
                cleanedDataAll = [cleanedDataAll;cleanedData];
                clearvars cleanedData
            end

%% Now let's make two separate full datasets, one with zero ms trials and one with nonzero
%First finding our guess trials        
        indexGuessTrials =  cleanedDataAll.CMDispTime == 0;
        guessTrials = cleanedDataAll(indexGuessTrials,:);
        clearvars indexGuessTrials

%First finding our nonguess trials        
        indexNonGuessTrials =  cleanedDataAll.CMDispTime ~= 0;
        nonGuessTrials = cleanedDataAll(indexNonGuessTrials,:);
        clearvars indexNonGuessTrials

        


        %% Now save
        
        %cd /Users/carolinemyers/Desktop/CM_Experiments/fire/FLSearch_v1.1.20/analysis
        cd
        
        save('subjectStructNM3_1_26.mat','subjectStructNM3126');
        clearvars data
        
    else
    end
end
