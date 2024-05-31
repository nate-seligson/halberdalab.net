%% Init
%Caroline Myers
%% Hello
close all 
clear all

%% Import
source_dir = '/Users/carolinemyers/Desktop/CM_Experiments/IN_PROGRESS/NumberModel3/Color/Color2_1_6_PILOT/data';
source_files = dir(fullfile(source_dir, '*.csv'));

%% set up opts
opts = delimitedTextImportOptions("NumVariables", 34);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "trial_index", "time_elapsed", "internal_node_id", "subject_id", "study_id", "session_id", "rt", "stimulus", "response", "position_of_items", "colors_of_items", "color_of_target", "wheel_spin", "response_angle", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "which_test", "set_size", "wheel_num_options", "actual_mask_duration", "actual_stim_duration", "CMDispTime", "maskArray", "maskRotation", "item_positions", "task", "randomSpinAmount"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "double", "string", "string", "string", "string", "double", "string", "string", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "string", "string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "stimulus", "response", "position_of_items", "colors_of_items", "maskArray", "maskRotation", "item_positions", "task"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "stimulus", "response", "position_of_items", "colors_of_items", "maskArray", "maskRotation", "item_positions", "task"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["rt", "physical_response_angle", "reported_color_angle", "reported_color_discrete"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["rt", "physical_response_angle", "reported_color_angle", "reported_color_discrete"], "ThousandsSeparator", ",");


%% First, save the raw data for all subjects as a .csv file.
for kk = 1:length(source_files)


    if length(source_files(kk).name) > 5

        rawDataAllThisSub = readtable(fullfile(source_dir,source_files(kk).name),opts);
        subNoThisSub = kk;

        rawDataAllThisSub.subNo = repmat(subNoThisSub,[height(rawDataAllThisSub),1]);

freeRespThisSub = rawDataAllThisSub((height(rawDataAllThisSub)-6):height(rawDataAllThisSub),:);


        if kk == 1
            
            rawDataAll = rawDataAllThisSub;
            freeRespAll = freeRespThisSub;
        else
            rawDataAll = [rawDataAll;rawDataAllThisSub];
            freeRespAll = [freeRespAll;freeRespThisSub];
        end
    end
end

writetable(rawDataAll,'rawDataAll.csv','Delimiter',',','QuoteStrings',true);
type 'rawDataAll.csv';

writetable(freeRespAll,'freeRespAll.csv','Delimiter',',','QuoteStrings',true);
type 'freeRespAll.csv';


%% Now that we have our raw data file, let's go through and clean it up a bit. 

%remove extra irrelevant columns we don't need:
cleanedDataAll = removevars(rawDataAll,{'success','timeout','failed_video','failed_audio','failed_images','trial_type','internal_node_id','study_id','session_id','stimulus'});

% remove instruction rows since there's nothing happening here 
%BUT BE CAREFUL! right now due to a coding blip some of our free responses
%are coded as '' for the task, so this eliminates some of them. We can get
%them back in the real version of the exp tho. 

    indexInstruction =  cleanedDataAll.task ~= ''; 
    cleanedDataAll = cleanedDataAll(indexInstruction,:);
    clearvars indexInstruction

% remove 'fixation' rows since there's nothing happening here 
    indexFix =  cleanedDataAll.task ~= 'fixation';
    cleanedDataAll = cleanedDataAll(indexFix,:);
        clearvars indexFix

        % get only color trials
    indexColor =  cleanedDataAll.task == 'color';
    cleanedDataAll = cleanedDataAll(indexColor,:);
        clearvars indexColor

%remove rows where no response was given for whatever reason
% CAUTION: THIS INCLUDES OUR FREE RESPONSE Qs!
R = rmmissing(cleanedDataAll ,'DataVariables',{'reported_color_discrete'});




%% Next, let's add a column where we put in the coordinates for each location

for ii = 1:height(cleanedDataAll)
    %pull out target location
    thisTrialLoc = char(cleanedDataAll.item_positions(ii));

    cleanedDataAll.targetLocation(ii) = str2double(thisTrialLoc(2));
clearvars thisTrialLoc
end

for ii = 1:height(cleanedDataAll)
    if cleanedDataAll.targetLocation(ii) == 0
        cleanedDataAll.targetLocationDeg(ii) = 90;

    elseif cleanedDataAll.targetLocation(ii) == 1
        cleanedDataAll.targetLocationDeg(ii) = 45;

      elseif cleanedDataAll.targetLocation(ii) == 2
        cleanedDataAll.targetLocationDeg(ii) = 0;   

    elseif cleanedDataAll.targetLocation(ii) == 3
        cleanedDataAll.targetLocationDeg(ii) = 315;

            elseif cleanedDataAll.targetLocation(ii) == 4
        cleanedDataAll.targetLocationDeg(ii) = 270;

            elseif cleanedDataAll.targetLocation(ii) == 5
        cleanedDataAll.targetLocationDeg(ii) = 225;

            elseif cleanedDataAll.targetLocation(ii) == 6
        cleanedDataAll.targetLocationDeg(ii) = 180;

            elseif cleanedDataAll.targetLocation(ii) == 7
        cleanedDataAll.targetLocationDeg(ii) = 135;

            elseif cleanedDataAll.targetLocation(ii) == 8
        cleanedDataAll.targetLocationDeg(ii) = 90;

    else
    end
end

writetable(cleanedDataAll,'cleanedDataAll.csv','Delimiter',',','QuoteStrings',true)
type 'cleanedDataAll.csv'

%% Now let's actually calculate the difference

for ii = 1:height(cleanedDataAll)
    if cleanedDataAll.targetLocationDeg(ii) > 180 && cleanedDataAll.physical_response_angle(ii) <180
     cleanedDataAll.colorUnCorrected(ii) = cleanedDataAll.physical_response_angle(ii);
        cleanedDataAll.colorCorrected(ii) = cleanedDataAll.physical_response_angle(ii) + 360;
    

    elseif cleanedDataAll.targetLocationDeg(ii) < 180 && cleanedDataAll.physical_response_angle(ii) >180
cleanedDataAll.colorCorrected(ii) = cleanedDataAll.physical_response_angle(ii) - 360;
cleanedDataAll.colorUnCorrected(ii) = cleanedDataAll.physical_response_angle(ii);    
    else
        cleanedDataAll.colorCorrected(ii) = cleanedDataAll.physical_response_angle(ii);
    cleanedDataAll.colorUnCorrected(ii) = cleanedDataAll.physical_response_angle(ii);
    end
    
end

for ii = 1:height(cleanedDataAll)
    distance1 = abs(cleanedDataAll.colorCorrected(ii) - cleanedDataAll.targetLocationDeg(ii));
    distance2 = abs(cleanedDataAll.targetLocationDeg(ii) - cleanedDataAll.colorUnCorrected(ii));
    
    cleanedDataAll.distance1(ii) = distance1;
    cleanedDataAll.distance2(ii) = distance2;

    distance = min(vertcat(distance1,distance2));
cleanedDataAll.distance(ii) = distance;
clearvars distance1 distance2 distance;
end
%% Now we can get just the guess trials
for ii = 1:height(cleanedDataAll)

    indexGuessTrials =  cleanedDataAll.CMDispTime == 0;
    cleanedData_GuessTrials = cleanedDataAll(indexGuessTrials,:);
end

writetable(cleanedData_GuessTrials,'cleanedData_GuessTrials.csv','Delimiter',',','QuoteStrings',true)
type 'cleanedData_GuessTrials.csv'

%% Now we can get just the NONguess trials
for ii = 1:height(cleanedDataAll)

    indexNonGuessTrials =  cleanedDataAll.CMDispTime ~= 0;
    cleanedData_NonGuessTrials = cleanedDataAll(indexNonGuessTrials,:);
end

writetable(cleanedData_NonGuessTrials,'cleanedData_NonGuessTrials.csv','Delimiter',',','QuoteStrings',true)
type 'cleanedData_NonGuessTrials.csv'

%% So now we have the physical distance from the cued location to the target. 


%% Now plot histogram and overlay kde 
figure(1)
lastSub = 5;
for ii = 1:lastSub
       indexThisSub =  cleanedData_GuessTrials.subNo == ii;
    GuessTrials_ThisSub = cleanedData_GuessTrials(indexThisSub,:);

close all
nbins = 18;
figure(1)
subplot(2,3,ii)
histogram(GuessTrials_ThisSub.reported_color_discrete,nbins)
hold on 
xlim([0 360]);
%[f,xi] = ksdensity(GuessTrials_ThisSub.reported_color_discrete); 
hold on
%plot(xi,f)

kde(GuessTrials_ThisSub.reported_color_discrete)
[Y0bw, Y0dens, Y0mesh, Y0cdf] = kde(GuessTrials_ThisSub.reported_color_discrete);
end 

figure(2)
for ii = 1:5
       indexThisSub =  cleanedData_GuessTrials.subNo == ii;
    GuessTrials_ThisSub = cleanedData_GuessTrials(indexThisSub,:);

[pdf, sigma] = circ_ksdensity(GuessTrials_ThisSub.reported_color_discrete, 0:360, 'msni');

gcf

plot(pdf);
title('KDE fits for individual subjects, all subs in black')
hold on
xlim([0 360]);
hold on

if ii == lastSub
    [pdf, sigma] = circ_ksdensity(cleanedData_GuessTrials.reported_color_discrete, 0:360, 'msni');
plot(pdf, Color='k', LineWidth=5);
hold on
xlim([0 360]);

figure(3)
histogram(cleanedData_GuessTrials.reported_color_discrete,nbins)
xlim([0 360]);
title('all subjects histogram')

else
end


end



%         guessTrials = cleanedData(indexGuessTrials,:);
%       
%         
% 
%         subjectID = data.subject_id(1);
%         subjectID = strcat('s',num2str(kk),'_',subjectID);
%         subjectStructNM3126.(subjectID).subjectID = subjectID;
%         
% 
%         
%         
%         subjectStructNM3126.(subjectID).rawData = rawDataAll;
%         
% 
% 
% 
%         
%         cleanedDataIndex = strcmp(data.task,'color');
%         cleanedData = data(cleanedDataIndex,:);
%        % cleanedData.absError = abs(cleanedData.error);
%         clearvars cleanedDataIndex
%         
%         %cleanedData = rmmissing(data,'DataVariables',{'error'});
%         
%         subjectStructNM3126.(subjectID).cleanedData = cleanedData;
%         
% 
%         
%         %%
%         
%         
%         indexGuessTrials =  cleanedData.CMDispTime == 0;
%         guessTrials = cleanedData(indexGuessTrials,:);
%         clearvars indexGuessTrials
%         subjectStructNM3126.(subjectID).guessTrials = guessTrials;
%         
%         indexNonGuessTrials =  cleanedData.CMDispTime ~= 0;
%         nonGuessTrials = cleanedData(indexNonGuessTrials,:);
%         %nonGuessTrials.CMDispTime
% 
%         clearvars indexNonGuessTrials
%         subjectStructNM3126.(subjectID).nonGuessTrials = nonGuessTrials;
%         subjectStructNM3126.(subjectID).nonGuessDurations = nonGuessTrials.CMDispTime;
%         
%          indexNonGuessTrials132 =  cleanedData.CMDispTime == 132;
%         nonGuessTrials132 = cleanedData(indexNonGuessTrials132,:);
%         clearvars indexNonGuessTrials132
%         subjectStructNM3126.(subjectID).nonGuessTrials132 = nonGuessTrials132;
%         
%    
%         indexNonGuessTrials66 =  cleanedData.CMDispTime == 66;
%         nonGuessTrials66 = cleanedData(indexNonGuessTrials66,:);
%         clearvars indexNonGuessTrials66
%         subjectStructNM3126.(subjectID).nonGuessTrials66 = nonGuessTrials66;
%         
%         %% Clean the data
%         
%  
%         
%         %% Transform the data.
%         for ii = 1:height(cleanedData)
%             if cleanedData.color_of_target(ii) > 180 
%                 tempTP = cleanedData.color_of_target(ii);%true color
%                 tempResp = cleanedData.reported_color_discrete(ii); %color they respond
%                 diff = ((360 - tempTP) + tempResp);
%                 cleanedData.TransformedResponse(ii) = tempResp + 360;
%                 %cleanedData.TransformedResponse(ii) = 360 + (360 - tempTP) + tempResp; %get transformed response
%               %   cleanedData.TransformedResponse(ii) = -1*((360 - tempTP) + tempResp);
%                 clearvars tempTP tempResp diff
%             elseif cleanedData.color_of_target(ii) < 180
%                 tempTP = cleanedData.color_of_target(ii);
%                 tempResp = cleanedData.reported_color_discrete(ii);
%                % cleanedData.TransformedResponse(ii) = tempResp - (360 + tempTP) + tempTP;     
%                % cleanedData.TransformedResponse(ii) = (360 - tempTP) + tempResp; 
%                %diff = (360 + tempTP) + tempTP - 360;
%               % cleanedData.TransformedResponse(ii) = tempTP - diff;
%               cleanedData.TransformedResponse(ii) = tempResp - 360;
%               %cleanedData.TransformedResponse(ii) = (360 + tempTP) + tempTP - 360;
%               clearvars tempTP tempResp diff
%             else
%             end
%         end
%         
% 
%     
%         subjectStructNM3126.(subjectID).cleanedData = cleanedData;
% 
%             if kk == 1
%         cleanedrawDataAll = cleanedData;
%             else 
%                 cleanedrawDataAll = [cleanedrawDataAll;cleanedData];
%                 clearvars cleanedData
%             end
% 
% %% Now let's make two separate full datasets, one with zero ms trials and one with nonzero
% %First finding our guess trials        
%         indexGuessTrials =  cleanedrawDataAll.CMDispTime == 0;
%         guessTrials = cleanedrawDataAll(indexGuessTrials,:);
%         clearvars indexGuessTrials
% 
% %First finding our nonguess trials        
%         indexNonGuessTrials =  cleanedrawDataAll.CMDispTime ~= 0;
%         nonGuessTrials = cleanedrawDataAll(indexNonGuessTrials,:);
%         clearvars indexNonGuessTrials
% 
%         
% 
% 
%         %% Now save
%         
%         %cd /Users/carolinemyers/Desktop/CM_Experiments/fire/FLSearch_v1.1.20/analysis
%         cd
%         
%         save('subjectStructNM3_1_26.mat','subjectStructNM3126');
%         clearvars data
%         
%     else
%     end
% 
% 
% end
