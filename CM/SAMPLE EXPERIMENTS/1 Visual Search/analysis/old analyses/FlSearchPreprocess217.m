%Caroline MYERS (Johns Hopkins)


%% Import

close all 

clearvars -except subjectStructFlSearch ;
%subjectStructFlSearch = struct;

source_dir = '/Users/carolinemyers/Desktop/CM_Experiments/IN_PROGRESS/fire/FlSearchV2/FLSearch_v2.1.7_PREREG/data';
dest_dir = '/Users/carolinemyers/Desktop/CM_Experiments/IN_PROGRESS/fire/FlSearchV2/FLSearch_v2.1.7_PREREG/analysis';
source_files = dir(fullfile(source_dir, '*.csv'));


opts = delimitedTextImportOptions("NumVariables", 24);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "trial_index", "time_elapsed", "internal_node_id", "subject_id", "study_id", "session_id", "rt", "stimulus", "response", "correct", "locations", "target_present", "set_size", "task", "correct_response", "target", "foilCM", "searchCondition"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "double", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "stimulus", "response", "correct", "locations", "target_present", "task", "correct_response", "target", "foilCM", "searchCondition"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "stimulus", "response", "correct", "locations", "target_present", "task", "correct_response", "target", "foilCM", "searchCondition"], "EmptyFieldRule", "auto");

%% Open subject loop
for ss = 1:length(source_files)
    if length(source_files(ss).name) > 5
    
        
        
      rawData = readtable(fullfile(source_dir,source_files(ss).name),opts);
rawData.subNum = repmat(ss,height(rawData));
      

%% Get basic subject info
subjectID = rawData.subject_id(1);
subjectID = strcat('s',num2str(ss),'_',subjectID);
subjectStructFlSearch.(subjectID).subjectID = subjectID;

subjectStructFlSearch.(subjectID).rawData = rawData;

feedbackQ = rawData.response(335);
subjectStructFlSearch.(subjectID).feedbackQ = feedbackQ;
%% Code correct trials


for jj = 1:height(rawData)
if strcmp(rawData.correct(jj),'true') == 1
    rawData.correctNumeric(jj) = 1;
elseif strcmp(rawData.correct(jj),'false') == 1
    rawData.correctNumeric(jj) = 0;
else
end
end

%% Clean our data a bit
for ll = 1:height(rawData)
if strcmp(rawData.task(ll),'training') == 1
    rawData.set_size(ll) = NaN;
else
end
end


data = rmmissing(rawData,'DataVariables',{'set_size'});


for jj = 1:height(data)
if strcmp(data.correct(jj),'true') == 1
    data.correctNumeric(jj) = 1;
elseif strcmp(data.correct(jj),'false') == 1
    data.correctNumeric(jj) = 0;
else
end
end

OverallAcc = sum(data.correctNumeric)/height(data);
subjectStructFlSearch.(subjectID).OverallAcc = OverallAcc;

indexTargetPresent =  strcmp(data.target_present,'true') == 1;
dataTP = data(indexTargetPresent,:);
clearvars indexTargetPresent;



data = dataTP;



for jj = 1:height(data)
if strcmp(data.correct(jj),'true') == 1
    data.correctNumeric(jj) = 1;
elseif strcmp(data.correct(jj),'false') == 1
    data.correctNumeric(jj) = 0;
else
end
end


%% 


cleanedData = rmmissing(data,'DataVariables',{'set_size'});

%highRTIndex = cleanedData.rt < 100000
%cleanedData = cleanedData(highRTIndex,:);


subjectStructFlSearch.(subjectID).cleanedData = cleanedData;



indexTargetUp =  strcmp(cleanedData.target,'img/Fire_Up_Target.gif') == 1;
targetUpData = cleanedData(indexTargetUp,:);
clearvars indexTargetUp
subjectStructFlSearch.(subjectID).targetUpData = targetUpData;



indexTargetDown =  strcmp(cleanedData.target,'img/Fire_Down_Target.gif') == 1;
targetDownData = cleanedData(indexTargetDown,:);
clearvars indexTargetDown
subjectStructFlSearch.(subjectID).targetDownData = targetDownData;

%% Now plot target up

indexSetSize4 = targetUpData.set_size == 4;
targetUpData4 = targetUpData(indexSetSize4,:);
clearvars indexSetSize4
subjectStructFlSearch.(subjectID).targetUpData4 = targetUpData4;


indexSetSize5 = targetUpData.set_size == 5;
targetUpData5 = targetUpData(indexSetSize5,:);
clearvars indexSetSize5
subjectStructFlSearch.(subjectID).targetUpData5 = targetUpData5;

indexSetSize6 = targetUpData.set_size == 6;
targetUpData6 = targetUpData(indexSetSize6,:);
clearvars indexSetSize6
subjectStructFlSearch.(subjectID).targetUpData6 = targetUpData6;

indexSetSize7 = targetUpData.set_size == 7;
targetUpData7 = targetUpData(indexSetSize7,:);
clearvars indexSetSize7
subjectStructFlSearch.(subjectID).targetUpData7 = targetUpData7;

indexSetSize8 = targetUpData.set_size == 8;
targetUpData8 = targetUpData(indexSetSize8,:);
clearvars indexSetSize8
subjectStructFlSearch.(subjectID).targetUpData8 = targetUpData8;

%% Now down

indexSetSize4 = targetDownData.set_size == 4;
targetDownData4 = targetDownData(indexSetSize4,:);
clearvars indexSetSize4
subjectStructFlSearch.(subjectID).targetDownData4 = targetDownData4;

indexSetSize4 = targetDownData.set_size == 4;
targetDownData4 = targetDownData(indexSetSize4,:);
clearvars indexSetSize4
subjectStructFlSearch.(subjectID).targetDownData4 = targetDownData4;

indexSetSize5 = targetDownData.set_size == 5;
targetDownData5 = targetDownData(indexSetSize5,:);
clearvars indexSetSize5
subjectStructFlSearch.(subjectID).targetDownData5 = targetDownData5;

indexSetSize6 = targetDownData.set_size == 6;
targetDownData6 = targetDownData(indexSetSize6,:);
clearvars indexSetSize6
subjectStructFlSearch.(subjectID).targetDownData6 = targetDownData6;

indexSetSize7 = targetDownData.set_size == 7;
targetDownData7 = targetDownData(indexSetSize7,:);
clearvars indexSetSize7
subjectStructFlSearch.(subjectID).targetDownData7 = targetDownData7;

indexSetSize8 = targetDownData.set_size == 8;
targetDownData8 = targetDownData(indexSetSize8,:);
clearvars indexSetSize8
subjectStructFlSearch.(subjectID).targetDownData8 = targetDownData8;

%% Now get ready to plot accuracy


accuracyAllTargetUp = horzcat(nanmean(targetUpData4.correctNumeric),...
    nanmean(targetUpData5.correctNumeric),...
    nanmean(targetUpData6.correctNumeric),...
    nanmean(targetUpData7.correctNumeric),...
    nanmean(targetUpData8.correctNumeric));
    
accuracyAllTargetUp = array2table(accuracyAllTargetUp); %make table
accuracyAllTargetUp.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).accuracyAllTargetUp = accuracyAllTargetUp;

StdErr_TU_SS4 = 1.96*(nanstd(targetUpData4.correctNumeric)/sqrt(length(targetUpData4.correctNumeric)));
StdErr_TU_SS5 = 1.96*(nanstd(targetUpData5.correctNumeric)/sqrt(length(targetUpData5.correctNumeric)));
StdErr_TU_SS6 = 1.96*(nanstd(targetUpData6.correctNumeric)/sqrt(length(targetUpData6.correctNumeric)));
StdErr_TU_SS7 = 1.96*(nanstd(targetUpData7.correctNumeric)/sqrt(length(targetUpData7.correctNumeric)));
StdErr_TU_SS8 = 1.96*(nanstd(targetUpData8.correctNumeric)/sqrt(length(targetUpData8.correctNumeric)));

stdErrorAccAllTU = horzcat(StdErr_TU_SS4, StdErr_TU_SS5,...
    StdErr_TU_SS6, StdErr_TU_SS7, StdErr_TU_SS8);

stdErrorAccAllTU = array2table(stdErrorAccAllTU); %make table
stdErrorAccAllTU.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorAccAllTU = stdErrorAccAllTU;
%%%%%%%%%%%%and plot

%% Target down


accuracyAllTargetDown = horzcat(nanmean(targetDownData4.correctNumeric),...
    nanmean(targetDownData5.correctNumeric),...
    nanmean(targetDownData6.correctNumeric),...
    nanmean(targetDownData7.correctNumeric),...
    nanmean(targetDownData8.correctNumeric));
    
accuracyAllTargetDown = array2table(accuracyAllTargetDown); %make table
accuracyAllTargetDown.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).accuracyAllTargetDown = accuracyAllTargetDown;


StdErr_TD_SS4 = 1.96*(nanstd(targetDownData4.correctNumeric)/sqrt(length(targetDownData4.correctNumeric)));
StdErr_TD_SS5 = 1.96*(nanstd(targetDownData5.correctNumeric)/sqrt(length(targetDownData5.correctNumeric)));
StdErr_TD_SS6 = 1.96*(nanstd(targetDownData6.correctNumeric)/sqrt(length(targetDownData6.correctNumeric)));
StdErr_TD_SS7 = 1.96*(nanstd(targetDownData7.correctNumeric)/sqrt(length(targetDownData7.correctNumeric)));
StdErr_TD_SS8 = 1.96*(nanstd(targetDownData8.correctNumeric)/sqrt(length(targetDownData8.correctNumeric)));


stdErrorAccAllTD = horzcat(StdErr_TD_SS4, StdErr_TD_SS5,...
    StdErr_TD_SS6, StdErr_TD_SS7,StdErr_TD_SS8);

stdErrorAccAllTD = array2table(stdErrorAccAllTD); %make table
stdErrorAccAllTD.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorAccAllTD = stdErrorAccAllTD;


%% and plot
figure

ax = axes; % Creating axes and the bar graph
[cuteRTPlotfig] = errorbar(ax,table2array(accuracyAllTargetUp),table2array(stdErrorAccAllTU),'o','LineWidth',2);
hold on
errorbar(ax,table2array(accuracyAllTargetDown),table2array(stdErrorAccAllTD),'o','LineWidth',2)
legend('target: normal fire', 'target: reversed fire')

ax.YGrid = 'off';
xticks(ax,[1 2 3 4 5]);
xlim([.5 5.5])


% Naming each of the bar groups
xticklabels(ax,{'4','5','6','7','8'});
% X and Y labels
hold on 

hold on
xlabel ('set size');
ylabel('accuracy')
title(['acc:',subjectID])

set(gca, 'TickLength',[0 0])
hold off
Marisize(12,1)

%% %%%%%%% SO IMPORTANT NOW RT, ALL. SERIOUSLY

%quickly index out incorrectNumeric
indexTargetUp =  targetUpData4.correctNumeric == 1;
targetUpData4 = targetUpData4(indexTargetUp,:);
clearvars indexTargetUp

indexTargetUp =  targetUpData5.correctNumeric == 1;
targetUpData5 = targetUpData5(indexTargetUp,:);
clearvars indexTargetUp

indexTargetUp =  targetUpData6.correctNumeric == 1;
targetUpData6 = targetUpData6(indexTargetUp,:);
clearvars indexTargetUp

indexTargetUp =  targetUpData7.correctNumeric == 1;
targetUpData7 = targetUpData7(indexTargetUp,:);
clearvars indexTargetUp

indexTargetUp =  targetUpData8.correctNumeric == 1;
targetUpData8 = targetUpData8(indexTargetUp,:);
clearvars indexTargetUp

%now index down
indexTargetDown = targetDownData4.correctNumeric == 1;
targetDownData4 = targetDownData4(indexTargetDown,:);
clearvars indexTargetDown

indexTargetDown =  targetDownData5.correctNumeric == 1;
targetDownData5 = targetDownData5(indexTargetDown,:);
clearvars indexTargetDown

indexTargetDown =  targetDownData6.correctNumeric == 1;
targetDownData6 = targetDownData6(indexTargetDown,:);
clearvars indexTargetDown

indexTargetDown =  targetDownData7.correctNumeric == 1;
targeDownpData7 = targetDownData7(indexTargetDown,:);
clearvars indexTargetDown

indexTargetDown =  targetDownData8.correctNumeric == 1;
targetDownData8 = targetDownData8(indexTargetDown,:);
clearvars indexTargetDown

%% 

 

RTCorrectTargetUp = horzcat(nanmedian(targetUpData4.rt),...
    nanmedian(targetUpData5.rt),...
    nanmedian(targetUpData6.rt),...
    nanmedian(targetUpData7.rt),...
    nanmedian(targetUpData8.rt));
    
RTCorrectTargetUp = array2table(RTCorrectTargetUp); %make table
RTCorrectTargetUp.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).RTCorrectTargetUp = RTCorrectTargetUp;

RTStdErr_TU_SS4 = 1.96*(std(targetUpData4.rt)/sqrt(length(targetUpData4.rt)));
RTStdErr_TU_SS5 = 1.96*(nanstd(targetUpData5.rt)/sqrt(length(targetUpData5.rt)));
RTStdErr_TU_SS6 = 1.96*(nanstd(targetUpData6.rt)/sqrt(length(targetUpData6.rt)));
RTStdErr_TU_SS7 = 1.96*(nanstd(targetUpData7.rt)/sqrt(length(targetUpData7.rt)));
RTStdErr_TU_SS8 = 1.96*(nanstd(targetUpData8.rt)/sqrt(length(targetUpData8.rt)));

stdErrorRTCorrectTU = horzcat(RTStdErr_TU_SS4, RTStdErr_TU_SS5,...
    RTStdErr_TU_SS6, RTStdErr_TU_SS7, RTStdErr_TU_SS8);

stdErrorRTCorrectTU = array2table(stdErrorRTCorrectTU); %make table
stdErrorRTCorrectTU.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorRTCorrectTU = stdErrorRTCorrectTU;
%%%%%%%%%%%%and plot



RTCorrectTargetDown = horzcat(median(targetDownData4.rt),...
    median(targetDownData5.rt),...
    median(targetDownData6.rt),...
    median(targetDownData7.rt),...
    median(targetDownData8.rt));
    
RTCorrectTargetDown = array2table(RTCorrectTargetDown); %make table
RTCorrectTargetDown.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).RTCorrectTargetDown = RTCorrectTargetDown;

RTStdErr_TD_SS4 = 1.96*(nanstd(targetDownData4.rt)/sqrt(length(targetDownData4.rt)));
RTStdErr_TD_SS5 = 1.96*(nanstd(targetDownData5.rt)/sqrt(length(targetDownData5.rt)));
RTStdErr_TD_SS6 = 1.96*(nanstd(targetDownData6.rt)/sqrt(length(targetDownData6.rt)));
RTStdErr_TD_SS7 = 1.96*(nanstd(targetDownData7.rt)/sqrt(length(targetDownData7.rt)));
RTStdErr_TD_SS8 = 1.96*(nanstd(targetDownData8.rt)/sqrt(length(targetDownData8.rt)));


stdErrorRTCorrectTD = horzcat(RTStdErr_TD_SS4, RTStdErr_TD_SS5,...
    RTStdErr_TD_SS6, RTStdErr_TD_SS7,RTStdErr_TD_SS8);

stdErrorRTCorrectTD = array2table(stdErrorRTCorrectTD); %make table
stdErrorRTCorrectTD.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorRTCorrectTD = stdErrorRTCorrectTD;

%Plot RT
figure

ax = axes; % Creating axes and the bar graph
[cuteRTPlotfig2] = errorbar(ax,table2array(RTCorrectTargetUp),table2array(stdErrorRTCorrectTU),'o','LineWidth',2);
hold on
errorbar(ax,table2array(RTCorrectTargetDown),table2array(stdErrorRTCorrectTD),'o','LineWidth',2)
legend('target: normal fire', 'target: reversed fire')

ax.YGrid = 'off';
xticks(ax,[1 2 3 4 5]);
xlim([.5 5.5])


% Naming each of the bar groups
xticklabels(ax,{'4','5','6','7','8'});
% X and Y labels
hold on 

hold on
xlabel ('set size');
ylabel('median rt')
title(['correct trials median RT',subjectID])

set(gca, 'TickLength',[0 0])
hold off

Marisize(12,1)

meanRTTargetUpPresentCorrect = nanmean(table2array(RTCorrectTargetUp));
meanRTTargetDownPresentCorrect = nanmean(table2array(RTCorrectTargetDown));

subjectStructFlSearch.(subjectID).meanRTTargetUpPresentCorrect = meanRTTargetUpPresentCorrect;
subjectStructFlSearch.(subjectID).meanRTTargetDownPresentCorrect = meanRTTargetDownPresentCorrect;


meanaccuracyAllTargetUp = nanmean(table2array(accuracyAllTargetUp));
meanaccuracyAllTargetDown = nanmean(table2array(accuracyAllTargetDown));

subjectStructFlSearch.(subjectID).meanaccuracyAllTargetUp = meanaccuracyAllTargetUp;
subjectStructFlSearch.(subjectID).meanaccuracyAllTargetDown = meanaccuracyAllTargetDown;


meanAccuracyALL = nanmean(horzcat(table2array(accuracyAllTargetUp),table2array(accuracyAllTargetDown)));
subjectStructFlSearch.(subjectID).meanaccuracyALL = meanAccuracyALL;


meanRTALL = nanmean(horzcat(table2array(RTCorrectTargetUp),table2array(RTCorrectTargetDown)));
subjectStructFlSearch.(subjectID).meanRTALL = meanRTALL;



%% Now save

%cd /Users/carolinemyers/Desktop/CM_Experiments/fire/FLSearch_v1.1.20/analysis
cd 
%SubjectsStruct2 = SubjectsStruct;
save('subjectStructFlSearch.mat','subjectStructFlSearch');
    else
    end
end
