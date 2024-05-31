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

rawData.subNum = (repmat(ss,1,height(rawData)))';

subNumTemp = table(rawData.subNum);
subNumTemp.Properties.VariableNames = {'subNum'};


rawData.subNum = [];
rawData = horzcat(subNumTemp,rawData);
%% Get basic subject info
subjectID = rawData.subject_id(1);
subjectID = strcat('s',num2str(ss),'_',subjectID);
subjectStructFlSearch.(subjectID).subjectID = subjectID;
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
subjectStructFlSearch.(subjectID).rawData = rawData;
%% Clean our data a bit
%initialize table for training data
trainingData = array2table(NaN(size((array2table(rawData)))));
trainingData.Properties.VariableNames = rawData.Properties.VariableNames;

%remove training trials from our matrix
cleanedData = rawData;
for ll = 1:height(rawData)
if strcmp(rawData.task(ll),'training') == 1
     trainingData{ll,:} = rawData{ll,:};
    cleanedData.set_size(ll) = NaN;
    
else
end
end
cleanedData = rmmissing(cleanedData,'DataVariables',{'set_size'});

%Calculate overall accuracy
OverallAcc = sum(cleanedData.correctNumeric)/height(cleanedData);
subjectStructFlSearch.(subjectID).OverallAcc = OverallAcc;
subjectStructFlSearch.(subjectID).cleanedData = cleanedData;

%% Now let's separate out only target present trials. 

indexTP =  strcmp(cleanedData.target_present,'true') == 1;
cleanedDataTP = cleanedData(indexTP,:);
clearvars indexTP;
subjectStructFlSearch.(subjectID).cleanedDataTP = cleanedDataTP;

%% Now let's separate our target present trials into the target burning up or down.


indexTargetUpTP =  strcmp(cleanedDataTP.target,'img/Fire_Up_Target.gif') == 1;
targetUpTPData = cleanedDataTP(indexTargetUpTP,:);
clearvars indexTargetUpTP
subjectStructFlSearch.(subjectID).targetUpTPData = targetUpTPData;



indexTargetDownTP =  strcmp(cleanedDataTP.target,'img/Fire_Down_Target.gif') == 1;
targetDownTPData = cleanedDataTP(indexTargetDownTP,:);
clearvars indexTargetDownTP
subjectStructFlSearch.(subjectID).targetDownTPData = targetDownTPData;

%% Now plot target up

indexSetSize4 = targetUpTPData.set_size == 4;
targetUpTPData4 = targetUpTPData(indexSetSize4,:);
clearvars indexSetSize4
subjectStructFlSearch.(subjectID).targetUpTPData4 = targetUpTPData4;


indexSetSize5 = targetUpTPData.set_size == 5;
targetUpTPData5 = targetUpTPData(indexSetSize5,:);
clearvars indexSetSize5
subjectStructFlSearch.(subjectID).targetUpTPData5 = targetUpTPData5;

indexSetSize6 = targetUpTPData.set_size == 6;
targetUpTPData6 = targetUpTPData(indexSetSize6,:);
clearvars indexSetSize6
subjectStructFlSearch.(subjectID).targetUpTPData6 = targetUpTPData6;

indexSetSize7 = targetUpTPData.set_size == 7;
targetUpTPData7 = targetUpTPData(indexSetSize7,:);
clearvars indexSetSize7
subjectStructFlSearch.(subjectID).targetUpTPData7 = targetUpTPData7;

indexSetSize8 = targetUpTPData.set_size == 8;
targetUpTPData8 = targetUpTPData(indexSetSize8,:);
clearvars indexSetSize8
subjectStructFlSearch.(subjectID).targetUpTPData8 = targetUpTPData8;

%% Now down


indexSetSize4 = targetDownTPData.set_size == 4;
targetDownTPData4 = targetDownTPData(indexSetSize4,:);
clearvars indexSetSize4
subjectStructFlSearch.(subjectID).targetDownTPData4 = targetDownTPData4;

indexSetSize5 = targetDownTPData.set_size == 5;
targetDownTPData5 = targetDownTPData(indexSetSize5,:);
clearvars indexSetSize5
subjectStructFlSearch.(subjectID).targetDownTPData5 = targetDownTPData5;

indexSetSize6 = targetDownTPData.set_size == 6;
targetDownTPData6 = targetDownTPData(indexSetSize6,:);
clearvars indexSetSize6
subjectStructFlSearch.(subjectID).targetDownTPData6 = targetDownTPData6;

indexSetSize7 = targetDownTPData.set_size == 7;
targetDownTPData7 = targetDownTPData(indexSetSize7,:);
clearvars indexSetSize7
subjectStructFlSearch.(subjectID).targetDownTPData7 = targetDownTPData7;

indexSetSize8 = targetDownTPData.set_size == 8;
targetDownTPData8 = targetDownTPData(indexSetSize8,:);
clearvars indexSetSize8
subjectStructFlSearch.(subjectID).targetDownTPData8 = targetDownTPData8;

%% Now get ready to plot accuracy


accuracyTPTargetUp = horzcat(nanmean(targetUpTPData4.correctNumeric),...
    nanmean(targetUpTPData5.correctNumeric),...
    nanmean(targetUpTPData6.correctNumeric),...
    nanmean(targetUpTPData7.correctNumeric),...
    nanmean(targetUpTPData8.correctNumeric));
    
accuracyTPTargetUp = array2table(accuracyTPTargetUp); %make table
accuracyTPTargetUp.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).accuracyTPTargetUp = accuracyTPTargetUp;

StdErr_TU_SS4TP = 1.96*(nanstd(targetUpTPData4.correctNumeric)/sqrt(length(targetUpTPData4.correctNumeric)));
StdErr_TU_SS5TP = 1.96*(nanstd(targetUpTPData5.correctNumeric)/sqrt(length(targetUpTPData5.correctNumeric)));
StdErr_TU_SS6TP = 1.96*(nanstd(targetUpTPData6.correctNumeric)/sqrt(length(targetUpTPData6.correctNumeric)));
StdErr_TU_SS7TP = 1.96*(nanstd(targetUpTPData7.correctNumeric)/sqrt(length(targetUpTPData7.correctNumeric)));
StdErr_TU_SS8TP = 1.96*(nanstd(targetUpTPData8.correctNumeric)/sqrt(length(targetUpTPData8.correctNumeric)));

stdErrorAcc_TP_TU = horzcat(StdErr_TU_SS4TP, StdErr_TU_SS5TP,...
    StdErr_TU_SS6TP, StdErr_TU_SS7TP, StdErr_TU_SS8TP);

stdErrorAcc_TP_TU = array2table(stdErrorAcc_TP_TU); %make table
stdErrorAcc_TP_TU.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorAccAllTU = stdErrorAcc_TP_TU;
%%%%%%%%%%%%and plot

%% Target down
%why nanmean...

accuracyTPTargetDown = horzcat(nanmean(targetDownTPData4.correctNumeric),...
    nanmean(targetDownTPData5.correctNumeric),...
    nanmean(targetDownTPData6.correctNumeric),...
    nanmean(targetDownTPData7.correctNumeric),...
    nanmean(targetDownTPData8.correctNumeric));
    
accuracyTPTargetDown = array2table(accuracyTPTargetDown); %make table
accuracyTPTargetDown.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).accuracyTPTargetDown = accuracyTPTargetDown;


StdErr_TD_SS4TP = 1.96*(nanstd(targetDownTPData4.correctNumeric)/sqrt(length(targetDownTPData4.correctNumeric)));
StdErr_TD_SS5TP = 1.96*(nanstd(targetDownTPData5.correctNumeric)/sqrt(length(targetDownTPData5.correctNumeric)));
StdErr_TD_SS6TP = 1.96*(nanstd(targetDownTPData6.correctNumeric)/sqrt(length(targetDownTPData6.correctNumeric)));
StdErr_TD_SS7TP = 1.96*(nanstd(targetDownTPData7.correctNumeric)/sqrt(length(targetDownTPData7.correctNumeric)));
StdErr_TD_SS8TP = 1.96*(nanstd(targetDownTPData8.correctNumeric)/sqrt(length(targetDownTPData8.correctNumeric)));


stdErrorAcc_TP_TD = horzcat(StdErr_TD_SS4TP, StdErr_TD_SS5TP,...
    StdErr_TD_SS6TP, StdErr_TD_SS7TP,StdErr_TD_SS8TP);

stdErrorAcc_TP_TD = array2table(stdErrorAcc_TP_TD); %make table
stdErrorAcc_TP_TD.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorAccAll_TP_TD = stdErrorAcc_TP_TD;


%% and plot
figure

ax = axes; % Creating axes and the bar graph
[cuteRTPlotfig] = errorbar(ax,table2array(accuracyTPTargetUp),table2array(stdErrorAcc_TP_TU),'o','LineWidth',2);
hold on
errorbar(ax,table2array(accuracyTPTargetDown),table2array(stdErrorAcc_TP_TD),'o','LineWidth',2)
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

%% %%%%%%% SO IMPORTANT NOW RT, ALL. SERIOUSLY. overall

index_Down_TP_Correct = targetDownTPData.correctNumeric == 1;
cleanedData_Down_TP_Correct = targetDownTPData(index_Down_TP_Correct,:);
clearvars index_Down_TP_Correct;

index_Up_TP_Correct = targetUpTPData.correctNumeric == 1;
cleanedData_Up_TP_Correct = targetUpTPData(index_Up_TP_Correct,:);
clearvars index_Up_TP_Correct;

trueMedianRT_Correct_TP_UP = median(cleanedData_Up_TP_Correct.rt);
trueMedianRT_Correct_TP_DOWN = median(cleanedData_Down_TP_Correct.rt);

subjectStructFlSearch.(subjectID).trueMedianRT_Correct_TP_UP = trueMedianRT_Correct_TP_UP;
subjectStructFlSearch.(subjectID).trueMedianRT_Correct_TP_DOWN = trueMedianRT_Correct_TP_DOWN;


%%
%quickly index out incorrectNumeric
indexTargetUpTP =  targetUpTPData4.correctNumeric == 1;
targetUpTPData4_Correct = targetUpTPData4(indexTargetUpTP,:);
clearvars indexTargetUpTP

indexTargetUpTP =  targetUpTPData5.correctNumeric == 1;
targetUpTPData5_Correct = targetUpTPData5(indexTargetUpTP,:);
clearvars indexTargetUpTP

indexTargetUpTP =  targetUpTPData6.correctNumeric == 1;
targetUpTPData6_Correct = targetUpTPData6(indexTargetUpTP,:);
clearvars indexTargetUpTP

indexTargetUpTP =  targetUpTPData7.correctNumeric == 1;
targetUpTPData7_Correct = targetUpTPData7(indexTargetUpTP,:);
clearvars indexTargetUpTP

indexTargetUpTP =  targetUpTPData8.correctNumeric == 1;
targetUpTPData8_Correct = targetUpTPData8(indexTargetUpTP,:);
clearvars indexTargetUpTP

%% now index down
indexTargetDownTP =  targetDownTPData4.correctNumeric == 1;
targetDownTPData4_Correct = targetDownTPData4(indexTargetDownTP,:);
clearvars indexTargetDownTP

indexTargetDownTP =  targetDownTPData5.correctNumeric == 1;
targetDownTPData5_Correct = targetDownTPData5(indexTargetDownTP,:);
clearvars indexTargetDownTP

indexTargetDownTP =  targetDownTPData6.correctNumeric == 1;
targetDownTPData6_Correct = targetDownTPData6(indexTargetDownTP,:);
clearvars indexTargetDownTP

indexTargetDownTP =  targetDownTPData7.correctNumeric == 1;
targetDownTPData7_Correct = targetDownTPData7(indexTargetDownTP,:);
clearvars indexTargetDownTP

indexTargetDownTP =  targetDownTPData8.correctNumeric == 1;
targetDownTPData8_Correct = targetDownTPData8(indexTargetDownTP,:);
clearvars indexTargetDownTP

%% 

 

RTCorrectTargetUpTP = horzcat(median(targetUpTPData4_Correct.rt),...
    median(targetUpTPData5_Correct.rt),...
    median(targetUpTPData6_Correct.rt),...
    median(targetUpTPData7_Correct.rt),...
    median(targetUpTPData8_Correct.rt));
    
RTCorrectTargetUpTP = array2table(RTCorrectTargetUpTP); %make table
RTCorrectTargetUpTP.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).RTCorrectTargetUp = RTCorrectTargetUpTP;

RTStdErr_TU_SS4 = 1.96*(nanstd(targetUpTPData4_Correct.rt)/sqrt(length(targetUpTPData4_Correct.rt)));
RTStdErr_TU_SS5 = 1.96*(nanstd(targetUpTPData5_Correct.rt)/sqrt(length(targetUpTPData5_Correct.rt)));
RTStdErr_TU_SS6 = 1.96*(nanstd(targetUpTPData6_Correct.rt)/sqrt(length(targetUpTPData6_Correct.rt)));
RTStdErr_TU_SS7 = 1.96*(nanstd(targetUpTPData7_Correct.rt)/sqrt(length(targetUpTPData7_Correct.rt)));
RTStdErr_TU_SS8 = 1.96*(nanstd(targetUpTPData8_Correct.rt)/sqrt(length(targetUpTPData8_Correct.rt)));

stdErrorRTCorrectTU = horzcat(RTStdErr_TU_SS4, RTStdErr_TU_SS5,...
    RTStdErr_TU_SS6, RTStdErr_TU_SS7, RTStdErr_TU_SS8);

stdErrorRTCorrectTU = array2table(stdErrorRTCorrectTU); %make table
stdErrorRTCorrectTU.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorRTCorrectTU = stdErrorRTCorrectTU;
%%%%%%%%%%%%and plot



RTCorrectTargetDownTP = horzcat(median(targetDownTPData4_Correct.rt),...
    median(targetDownTPData5_Correct.rt),...
    median(targetDownTPData6_Correct.rt),...
    median(targetDownTPData7_Correct.rt),...
    median(targetDownTPData8_Correct.rt));
    
RTCorrectTargetDownTP = array2table(RTCorrectTargetDownTP); %make table
RTCorrectTargetDownTP.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};
subjectStructFlSearch.(subjectID).RTCorrectTargetDown = RTCorrectTargetDownTP;

RTStdErr_TD_SS4 = 1.96*(nanstd(targetDownTPData4_Correct.rt)/sqrt(length(targetDownTPData4_Correct.rt)));
RTStdErr_TD_SS5 = 1.96*(nanstd(targetDownTPData5_Correct.rt)/sqrt(length(targetDownTPData5_Correct.rt)));
RTStdErr_TD_SS6 = 1.96*(nanstd(targetDownTPData6_Correct.rt)/sqrt(length(targetDownTPData6_Correct.rt)));
RTStdErr_TD_SS7 = 1.96*(nanstd(targetDownTPData7_Correct.rt)/sqrt(length(targetDownTPData7_Correct.rt)));
RTStdErr_TD_SS8 = 1.96*(nanstd(targetDownTPData8_Correct.rt)/sqrt(length(targetDownTPData8_Correct.rt)));


stdErrorRTCorrectTD = horzcat(RTStdErr_TD_SS4, RTStdErr_TD_SS5,...
    RTStdErr_TD_SS6, RTStdErr_TD_SS7,RTStdErr_TD_SS8);

stdErrorRTCorrectTD = array2table(stdErrorRTCorrectTD); %make table
stdErrorRTCorrectTD.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};
subjectStructFlSearch.(subjectID).stdErrorRTCorrectTD = stdErrorRTCorrectTD;

%% Plot RT
figure

ax = axes; % Creating axes and the bar graph
[cuteRTPlotfig2] = errorbar(ax,table2array(RTCorrectTargetUpTP),table2array(stdErrorRTCorrectTU),'o','LineWidth',2);
hold on
errorbar(ax,table2array(RTCorrectTargetDownTP),table2array(stdErrorRTCorrectTD),'o','LineWidth',2)
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

meanRTTargetUpPresentCorrect = nanmean(table2array(RTCorrectTargetUpTP));
meanRTTargetDownPresentCorrect = nanmean(table2array(RTCorrectTargetDownTP));

subjectStructFlSearch.(subjectID).meanRTTargetUpPresentCorrect = meanRTTargetUpPresentCorrect;
subjectStructFlSearch.(subjectID).meanRTTargetDownPresentCorrect = meanRTTargetDownPresentCorrect;


meanaccuracyAllTargetUp = nanmean(table2array(accuracyTPTargetUp));
meanaccuracyAllTargetDown = nanmean(table2array(accuracyTPTargetDown));

subjectStructFlSearch.(subjectID).meanaccuracyAllTargetUp = meanaccuracyAllTargetUp;
subjectStructFlSearch.(subjectID).meanaccuracyAllTargetDown = meanaccuracyAllTargetDown;


meanAccuracyALL = nanmean(horzcat(table2array(accuracyTPTargetUp),table2array(accuracyTPTargetDown)));
subjectStructFlSearch.(subjectID).meanaccuracyALL = meanAccuracyALL;


meanRTALL = nanmean(horzcat(table2array(RTCorrectTargetUpTP),table2array(RTCorrectTargetDownTP)));
subjectStructFlSearch.(subjectID).meanRTALL = meanRTALL;




%% Now save

%cd /Users/carolinemyers/Desktop/CM_Experiments/fire/FLSearch_v1.1.20/analysis
cd 
%SubjectsStruct2 = SubjectsStruct;
save('subjectStructFlSearch.mat','subjectStructFlSearch');
    else
    end
end
