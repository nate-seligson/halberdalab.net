%% Main analysis FLSearch

close all;
clearvars -except subjectStructFlSearch;
SubjectsStructFlSearch = subjectStructFlSearch


%%

clearvars subjID;
clearvars ii;
IncludedDataMatrix = [];
subListAll = string(fieldnames(SubjectsStructFlSearch));
for ii=1: length(subListAll);
    subjID(ii) = (subListAll(ii))';
    
    %Theta0
    IncludedDataMatrix(ii,1) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetUp.SS4)';
    IncludedDataMatrix(ii,2) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetUp.SS5)';
    IncludedDataMatrix(ii,3) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetUp.SS6)';
    IncludedDataMatrix(ii,4) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetUp.SS7)';
    IncludedDataMatrix(ii,5) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetUp.SS8)';
    IncludedDataMatrix(ii,6) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetDown.SS4)';
    IncludedDataMatrix(ii,7) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetDown.SS5)';
    IncludedDataMatrix(ii,8) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetDown.SS6)';
    IncludedDataMatrix(ii,9) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetDown.SS7)';
    IncludedDataMatrix(ii,10) = (SubjectsStructFlSearch.(subjID(ii)).accuracyTPTargetDown.SS8)';
    
    
    IncludedDataMatrix(ii,11) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetUp.SS4)';
    IncludedDataMatrix(ii,12) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetUp.SS5)';
    IncludedDataMatrix(ii,13) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetUp.SS6)';
    IncludedDataMatrix(ii,14) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetUp.SS7)';
    IncludedDataMatrix(ii,15) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetUp.SS8)';
    IncludedDataMatrix(ii,16) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetDown.SS4)';
    IncludedDataMatrix(ii,17) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetDown.SS5)';
    IncludedDataMatrix(ii,18) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetDown.SS6)';
    IncludedDataMatrix(ii,19) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetDown.SS7)';
    IncludedDataMatrix(ii,20) = (SubjectsStructFlSearch.(subjID(ii)).RTCorrectTargetDown.SS8)';
    
    IncludedDataMatrix(ii,21) = (SubjectsStructFlSearch.(subjID(ii)).meanRTTargetUpPresentCorrect)';
    IncludedDataMatrix(ii,22) = (SubjectsStructFlSearch.(subjID(ii)).meanRTTargetDownPresentCorrect)';
    IncludedDataMatrix(ii,23) = (SubjectsStructFlSearch.(subjID(ii)).meanaccuracyAllTargetUp)';
    IncludedDataMatrix(ii,24) = (SubjectsStructFlSearch.(subjID(ii)).meanaccuracyAllTargetDown)';
    
    IncludedDataMatrix(ii,25) = (SubjectsStructFlSearch.(subjID(ii)).meanaccuracyALL)';
    IncludedDataMatrix(ii,26) = (SubjectsStructFlSearch.(subjID(ii)).meanRTALL)';
    IncludedDataMatrix(ii,27) = (SubjectsStructFlSearch.(subjID(ii)).OverallAcc)';
    
    IncludedDataMatrix(ii,28) = (SubjectsStructFlSearch.(subjID(ii)).trueMedianRT_Correct_TP_UP)';
    IncludedDataMatrix(ii,29) = (SubjectsStructFlSearch.(subjID(ii)).trueMedianRT_Correct_TP_DOWN)';

    
    identity(ii,1) = convertCharsToStrings(SubjectsStructFlSearch.(subjID(ii)).subjectID);
    identity(ii,2) = convertCharsToStrings((SubjectsStructFlSearch.(subjID(ii)).feedbackQ))';
    

    if SubjectsStructFlSearch.(subjID(ii)).OverallAcc >= .80
        SubjectsStructFlSearchINCLUDED.(subjID(ii)) = SubjectsStructFlSearch.(subjID(ii))
        
    else
    end
    
 if ii == 1
        rawDataAll = [];
        cleanedDataAll = [];
    else
    end
    rawDataAll = vertcat(rawDataAll, SubjectsStructFlSearch.(subjID(ii)).rawData);
    cleanedDataAll = vertcat(cleanedDataAll, SubjectsStructFlSearch.(subjID(ii)).cleanedData);

  
    
end


%% Now let's check out subjs struct included
subListAllINCLUDED = string(fieldnames(SubjectsStructFlSearchINCLUDED));
for ii=1: length(subListAllINCLUDED)
    subjIDINCLUDED(ii) = (subListAllINCLUDED(ii))';
  if ii == 1
        cleanedDataTPAllINCLUDED = [];
        cleanedDataAllIncluded = [];
        
    else
    end
    cleanedDataTPAllINCLUDED = vertcat(cleanedDataTPAllINCLUDED, SubjectsStructFlSearchINCLUDED.(subjIDINCLUDED(ii)).cleanedDataTP);
    cleanedDataAllIncluded =  vertcat(cleanedDataAllIncluded, SubjectsStructFlSearchINCLUDED.(subjIDINCLUDED(ii)).cleanedData);
end


%% and get the cleaned data


%%


ALLDataMatrix = horzcat(identity,IncludedDataMatrix);


AllDataTable = array2table(ALLDataMatrix);

AllDataTable.Properties.VariableNames = {'SubjectID',...
    'FeedbackQ',...
    'TargetUpAcc4',...
    'TargetUpAcc5',...
    'TargetUpAcc6',...
    'TargetUpAcc7',...
    'TargetUpAcc8',...
    'TargetDownAcc4',...
    'TargetDownAcc5',...
    'TargetDownAcc6',...
    'TargetDownAcc7',...
    'TargetDownAcc8',...
    'TargetUpRT4',...
    'TargetUpRT5',...
    'TargetUpRT6',...
    'TargetUpRT7',...
    'TargetUpRT8',...
    'TargetDownRT4',...
    'TargetDownRT5',...
    'TargetDownRT6',...
    'TargetDownRT7',...
    'TargetDownRT8',...
    'TargetUpMeanCorrectRT',...
    'TargetDownMeanCorrectRT',...
    'TargetUpMeanAcc',...
    'TargetDownMeanAcc',...
    'meanAccALL',...
    'meanRTALL',...
    'overallAcc',...
    'trueMedianRT_Correct_TP_UP',...
    'trueMedianRT_Correct_TP_DOWN'};

AllDataTable = convertvars(AllDataTable,{'TargetUpAcc4',...
    'TargetUpAcc5',...
    'TargetUpAcc6',...
    'TargetUpAcc7',...
    'TargetUpAcc8',...
    'TargetDownAcc4',...
    'TargetDownAcc5',...
    'TargetDownAcc6',...
    'TargetDownAcc7',...
    'TargetDownAcc8',...
    'TargetUpRT4',...
    'TargetUpRT5',...
    'TargetUpRT6',...
    'TargetUpRT7',...
    'TargetUpRT8',...
    'TargetDownRT4',...
    'TargetDownRT5',...
    'TargetDownRT6',...
    'TargetDownRT7',...
    'TargetDownRT8',...
    'TargetUpMeanCorrectRT',...
    'TargetDownMeanCorrectRT',...
    'TargetUpMeanAcc',...
    'TargetDownMeanAcc',...
    'meanAccALL',...
    'meanRTALL',...
    'overallAcc',...
    'trueMedianRT_Correct_TP_UP',...
    'trueMedianRT_Correct_TP_DOWN'},'double');


%% Now we need to remove people that were < 80% acc
AllDataTablePreExclusion = AllDataTable;
for ii = 1:height(AllDataTable)
    if AllDataTable.overallAcc(ii) < .80
        AllDataTable.TargetUpMeanAcc(ii) = NaN;
    else
    end
end

AllDataTable = rmmissing(AllDataTable,'DataVariables',{'TargetUpMeanAcc'});
%%

%% Now plot


accuracyAllTargetUp = horzcat(nanmean(AllDataTable.TargetUpAcc4),...
    nanmean(AllDataTable.TargetUpAcc5),...
    nanmean(AllDataTable.TargetUpAcc6),...
    nanmean(AllDataTable.TargetUpAcc7),...
    nanmean(AllDataTable.TargetUpAcc8));

accuracyAllTargetUp = array2table(accuracyAllTargetUp); %make table
accuracyAllTargetUp.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};


StdErr_TU_SS4 = 1.96*(nanstd(AllDataTable.TargetUpAcc4)/sqrt(length(AllDataTable.TargetUpAcc4)));
StdErr_TU_SS5 = 1.96*(nanstd(AllDataTable.TargetUpAcc4)/sqrt(length(AllDataTable.TargetUpAcc4)));
StdErr_TU_SS6 = 1.96*(nanstd(AllDataTable.TargetUpAcc4)/sqrt(length(AllDataTable.TargetUpAcc4)));
StdErr_TU_SS7 = 1.96*(nanstd(AllDataTable.TargetUpAcc4)/sqrt(length(AllDataTable.TargetUpAcc4)));
StdErr_TU_SS8 = 1.96*(nanstd(AllDataTable.TargetUpAcc4)/sqrt(length(AllDataTable.TargetUpAcc4)));

stdErrorAccAllTU = horzcat(StdErr_TU_SS4, StdErr_TU_SS5,...
    StdErr_TU_SS6, StdErr_TU_SS7, StdErr_TU_SS8);

stdErrorAccAllTU = array2table(stdErrorAccAllTU); %make table
stdErrorAccAllTU.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};

%%%%%%%%%%%%and plot

%% Target down


accuracyAllTargetDown = horzcat(nanmean(AllDataTable.TargetDownAcc4),...
    nanmean(AllDataTable.TargetDownAcc5),...
    nanmean(AllDataTable.TargetDownAcc6),...
    nanmean(AllDataTable.TargetDownAcc7),...
    nanmean(AllDataTable.TargetDownAcc8));

accuracyAllTargetDown = array2table(accuracyAllTargetDown); %make table
accuracyAllTargetDown.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};


StdErr_TD_SS4 = 1.96*(nanstd(AllDataTable.TargetDownAcc4)/sqrt(length(AllDataTable.TargetDownAcc4)));
StdErr_TD_SS5 = 1.96*(nanstd(AllDataTable.TargetDownAcc5)/sqrt(length(AllDataTable.TargetDownAcc5)));
StdErr_TD_SS6 = 1.96*(nanstd(AllDataTable.TargetDownAcc6)/sqrt(length(AllDataTable.TargetDownAcc6)));
StdErr_TD_SS7 = 1.96*(nanstd(AllDataTable.TargetDownAcc7)/sqrt(length(AllDataTable.TargetDownAcc7)));
StdErr_TD_SS8 = 1.96*(nanstd(AllDataTable.TargetDownAcc8)/sqrt(length(AllDataTable.TargetDownAcc8)));


stdErrorAccAllTD = horzcat(StdErr_TD_SS4, StdErr_TD_SS5,...
    StdErr_TD_SS6, StdErr_TD_SS7,StdErr_TD_SS8);

stdErrorAccAllTD = array2table(stdErrorAccAllTD); %make table
stdErrorAccAllTD.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};



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
ylabel(['accuracy'])
title(['accuracy all subjects'])

set(gca, 'TickLength',[0 0])
hold off
Marisize(12,1)


%% Now RT


RTCorrectTargetUp = horzcat(nanmean(AllDataTable.TargetUpRT4),...
    nanmean(AllDataTable.TargetUpRT5),...
    nanmean(AllDataTable.TargetUpRT6),...
    nanmean(AllDataTable.TargetUpRT7),...
    nanmean(AllDataTable.TargetUpRT8));

RTCorrectTargetUp = array2table(RTCorrectTargetUp); %make table
RTCorrectTargetUp.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};


RTStdErr_TU_SS4 = 1.96*(std(AllDataTable.TargetUpRT4)/sqrt(length(AllDataTable.TargetUpRT4)));
RTStdErr_TU_SS5 = 1.96*(nanstd(AllDataTable.TargetUpRT5)/sqrt(length(AllDataTable.TargetUpRT5)));
RTStdErr_TU_SS6 = 1.96*(nanstd(AllDataTable.TargetUpRT6)/sqrt(length(AllDataTable.TargetUpRT6)));
RTStdErr_TU_SS7 = 1.96*(nanstd(AllDataTable.TargetUpRT7)/sqrt(length(AllDataTable.TargetUpRT7)));
RTStdErr_TU_SS8 = 1.96*(nanstd(AllDataTable.TargetUpRT8)/sqrt(length(AllDataTable.TargetUpRT8)));

stdErrorRTCorrectTU = horzcat(RTStdErr_TU_SS4, RTStdErr_TU_SS5,...
    RTStdErr_TU_SS6, RTStdErr_TU_SS7, RTStdErr_TU_SS8);

stdErrorRTCorrectTU = array2table(stdErrorRTCorrectTU); %make table
stdErrorRTCorrectTU.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};

%%%%%%%%%%%%and plot



RTCorrectTargetDown = horzcat(nanmean(AllDataTable.TargetDownRT4),...
    nanmean(AllDataTable.TargetDownRT5),...
    nanmean(AllDataTable.TargetDownRT6),...
    nanmean(AllDataTable.TargetDownRT7),...
    nanmean(AllDataTable.TargetDownRT8));

RTCorrectTargetDown = array2table(RTCorrectTargetDown); %make table
RTCorrectTargetDown.Properties.VariableNames = {'SS4','SS5','SS6','SS7','SS8'};


RTStdErr_TD_SS4 = 1.96*(nanstd(AllDataTable.TargetDownRT4)/sqrt(length(AllDataTable.TargetDownRT4)));
RTStdErr_TD_SS5 = 1.96*(nanstd(AllDataTable.TargetDownRT5)/sqrt(length(AllDataTable.TargetDownRT5)));
RTStdErr_TD_SS6 = 1.96*(nanstd(AllDataTable.TargetDownRT6)/sqrt(length(AllDataTable.TargetDownRT6)));
RTStdErr_TD_SS7 = 1.96*(nanstd(AllDataTable.TargetDownRT7)/sqrt(length(AllDataTable.TargetDownRT7)));
RTStdErr_TD_SS8 = 1.96*(nanstd(AllDataTable.TargetDownRT8)/sqrt(length(AllDataTable.TargetDownRT8)));


stdErrorRTCorrectTD = horzcat(RTStdErr_TD_SS4, RTStdErr_TD_SS5,...
    RTStdErr_TD_SS6, RTStdErr_TD_SS7,RTStdErr_TD_SS8);

stdErrorRTCorrectTD = array2table(stdErrorRTCorrectTD); %make table
stdErrorRTCorrectTD.Properties.VariableNames = {'ss4','ss5','ss6','ss7','ss8'};


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
ylabel(['median rt'])
title(['correct trials median RT: all subjects'])

set(gca, 'TickLength',[0 0])
hold off

Marisize(12,1)

%% save

filename = 'allDataFLSearch217.xlsx';
writetable(AllDataTable,filename,'Sheet',1,'Range','A1')

filename = 'cleanedDataTPAllIncluded.xlsx';
writetable(cleanedDataTPAllINCLUDED,filename,'Sheet',1,'Range','A1')

filename = 'rawDataAll.xlsx';
writetable(rawDataAll,filename,'Sheet',1,'Range','A1')

filename = 'cleanedDataAll.xlsx';
writetable(cleanedDataAll,filename,'Sheet',1,'Range','A1')

filename = 'cleanedDataAllIncluded.xlsx';
writetable(cleanedDataAllIncluded,filename,'Sheet',1,'Range','A1')
%% Now let's employ some other checks.


