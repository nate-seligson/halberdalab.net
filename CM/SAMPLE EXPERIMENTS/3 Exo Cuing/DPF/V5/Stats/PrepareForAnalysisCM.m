%% Hello
% Written by Caroline MYERS
% Uses functions created by Caroline MYERS, some adapted from 
% Nina HANNING and Martin Sintze

%This script is a first pass at a basic analysis of behavioral data for DPF
%V3. 

% This is the main script, and the SubjectsStruct structure must be loaded
% first. 
%% Load subjects info here
clearvars  -except SubjectsStruct SubjectsStructBackup

%% PLUG IN SUBJECT-SPECIFIC INFO HERE: 
subIni = 'AW';%% change me
domEye = 'R';%% change me
expName = 'DPF';
taskType = 'Main';
nbBlocks = [1:5];%% change me
eyeAnalysis = 1;
Gender = 'F'; %% change me
%Age = 10;
DOB = [2004, 02, 10] %year month day



SubNoString = '379'; %% change me
Session = 1; %% change me
Source = 'CMv3';


dataAvailability = 'eyebeh';
numLocations = 4;
Included = 1;
Notes = ''; %% change me
ChildAdultCategory = 'adolescent'; %% change me
ChildAdultNumeric = 3; %% change me
sf = 4; %% change me
ecc = 6.4;
tilt = 20;
Heightin = 63; %% change me
attentionCond = 'exo';

%%
[allDataTable,const,scr] = all_analysisCM(subIni,domEye,expName,taskType,nbBlocks,eyeAnalysis);

Observer = convertCharsToStrings(subIni);
SubNo = str2double(SubNoString);
birth = datetime(DOB(1),DOB(2),DOB(3));
testDate = datetime(const.my_clock_ini(1:3))


Age = years(testDate-birth)
%% Now let's get rid of bad trials
allDataTableCopy = allDataTable;

indexGood = ~isnan(allDataTableCopy.RT) == 1;
SubjDataOriginalRaw = allDataTableCopy(indexGood,:);

numFixBreak = sum(height(allDataTableCopy)) - sum(indexGood);

%% Now let's put this in a way our simple minds can understand
SubjDataOriginal = table;
SubjDataOriginal.Observer = repmat(Observer,height(SubjDataOriginalRaw),1);
SubjDataOriginal.Run = SubjDataOriginalRaw.Block;
SubjDataOriginal.Block = SubjDataOriginalRaw.Block;
SubjDataOriginal.Trial = SubjDataOriginalRaw.TrialNum;
SubjDataOriginal.Location = SubjDataOriginalRaw.TargetLoc;
SubjDataOriginal.CueCond = SubjDataOriginalRaw.CueCond;
SubjDataOriginal.Contrast = SubjDataOriginalRaw.Contrast;
SubjDataOriginal.RightResponse = NaN(height(SubjDataOriginal),1);
SubjDataOriginal.Response = SubjDataOriginalRaw.KeyPressed;
SubjDataOriginal.rightwrong  = SubjDataOriginalRaw.Correct;
SubjDataOriginal.RT  = SubjDataOriginalRaw.RT;
SubjDataOriginal.Heightin = repmat(Heightin,height(SubjDataOriginal),1);
SubjDataOriginal.Age = repmat(Age,height(SubjDataOriginal),1);
SubjDataOriginal.SubNo = repmat(str2double(SubNoString),height(SubjDataOriginal),1);

%% Here ends the new stuff. Now, let's go into the rest of our old analysis.

%% 11 Now put everything else together
everythingElse = struct;
BlockNums = unique(SubjDataOriginal.Run)';
Contrast = unique(SubjDataOriginal.Contrast)';
ContrastMean = mean(SubjDataOriginal.Contrast);
everythingElse.Heightin = SubjDataOriginal.Heightin(1,1);
everythingElse.ContrastMean = ContrastMean;
everythingElse.Age = Age;
everythingElse.BlockNums = BlockNums;
everythingElse.numFixBreak = numFixBreak;
everythingElse.Contrast = Contrast;
everythingElse.Heightin = Heightin;
everythingElse.Observer = Observer;
everythingElse.SubNo = SubNo;
everythingElse.const = const;
%% 12 Now save data
%SubNoStr = num2str(SubNo);
if Session == 1
    subjectID = strcat('s',SubNoString,Observer,'_S1');
    
elseif Session == 2
    subjectID = strcat('s',SubNoString,Observer,'_S2');
elseif Session == 3
    subjectID = strcat('s',SubNoString,Observer,'_S3');
else
end

%subjectID = strcat('s',SubNoStr,Observer);
%SubjectsStruct = struct;

%% remove nans


SubjectDataOriginal = rmmissing(SubjDataOriginal,'DataVariables',{'RT'});

idx_negO = find(SubjectDataOriginal.RT < 0); % creates an index of negative times
SubjectDataOriginal.RT(idx_negO) = 0; % transforms all negative RTs to zeros
SubjectDataOriginal = rmmissing(SubjectDataOriginal,'DataVariables','RT');

clearvars idx_negO
SubjectsStruct.(subjectID).SubjectDataOriginal = SubjectDataOriginal;
SubjectsStruct.(subjectID).everythingElse = everythingElse;
%SubjectsStruct.(subjectID).SubjectData = SubjDataOriginal;

%% Then, make 2 tables, one for valid, one for neutral
%For DPFv3, cuecond = 1 is attention, cuecond = 2 is neutral

%%neutral
indexNeutral = SubjectsStruct.(subjectID).SubjectDataOriginal.CueCond == 2; %neutral
SubjectDataNeutral = SubjectsStruct.(subjectID).SubjectDataOriginal(indexNeutral,:);

%Valid
indexValid = SubjectsStruct.(subjectID).SubjectDataOriginal.CueCond == 1; %valid
SubjectDataValid = SubjectsStruct.(subjectID).SubjectDataOriginal(indexValid,:);
%% now do this for each
%%note to CM- now you need to document each variable name you care about so
%%you can easily read them in your analysis script. Go to that and copy the
%%names tomorrow.

%% Remember that the locations here are different. 1 = E, 2 = N, 3 = W, 4 = S
PropCorrectNeutral = zeros;
NumTrialsPerLocNeutral = zeros;
WeightsNeutral = zeros;
for ii = 1:numLocations
    index = SubjectDataNeutral.Location(:) == ii;
    PropCorrectNeutral(ii)=sum(SubjectDataNeutral.rightwrong(index))/sum(index);
    NumTrialsPerLocNeutral(ii) = sum(index);
    WeightsNeutral(ii) = sum(index)/height(SubjectDataNeutral);
    %PropCorrect.Location(ii)=sum(SubjDataOriginal.TargetLoc(index))/sum(index);
    clear index
end
WeightsNeutral = horzcat(WeightsNeutral(2),NaN, WeightsNeutral(1), NaN, WeightsNeutral(4), NaN,WeightsNeutral(3),NaN);
NumTrialsPerLocNeutral = horzcat(NumTrialsPerLocNeutral(2),NaN, NumTrialsPerLocNeutral(1), NaN, NumTrialsPerLocNeutral(4), NaN,NumTrialsPerLocNeutral(3),NaN);

clear index
totalNumTrialsNeutral = nansum(NumTrialsPerLocNeutral(:));

%Overall accuracy
PropCorrectOverallNeutral = sum(SubjectDataNeutral.rightwrong)/length(SubjectDataNeutral.rightwrong);

PropCorrectNeutral = horzcat(PropCorrectNeutral(2),NaN, PropCorrectNeutral(1), NaN, PropCorrectNeutral(4), NaN,PropCorrectNeutral(3),NaN);

PropCorrectNeutral = array2table(PropCorrectNeutral); %make table
PropCorrectNeutral.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};

%% Now do this for valid
PropCorrectValid = zeros;
WeightsValid = zeros;
NumTrialsPerLocValid = zeros;
for ii = 1:numLocations
    index = SubjectDataValid.Location(:) == ii;
    PropCorrectValid(ii)=sum(SubjectDataValid.rightwrong(index))/sum(index);
    NumTrialsPerLocValid(ii) = sum(index);
    WeightsValid(ii) = sum(index)/height(SubjectDataValid);
    %PropCorrect.Location(ii)=sum(SubjDataOriginal.TargetLoc(index))/sum(index);
    clear index
end
NumTrialsPerLocValid = horzcat(NumTrialsPerLocValid(2),NaN, NumTrialsPerLocValid(1), NaN, NumTrialsPerLocValid(4), NaN,NumTrialsPerLocValid(3),NaN);

WeightsValid = horzcat(WeightsValid(2),NaN, WeightsValid(1), NaN, WeightsValid(4), NaN,WeightsValid(3),NaN);

totalNumTrialsValid = nansum(NumTrialsPerLocValid(:));

%Overall accuracy
PropCorrectOverallValid = sum(SubjectDataValid.rightwrong)/length(SubjectDataValid.rightwrong);

PropCorrectValid = horzcat(PropCorrectValid(2),NaN, PropCorrectValid(1), NaN, PropCorrectValid(4), NaN,PropCorrectValid(3),NaN);

PropCorrectValid = array2table(PropCorrectValid); %make table
PropCorrectValid.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};

%% Now first get uncorrected weights- valid
AccuracyValid = table2array(PropCorrectValid);
weightedValidUncorrected = zeros;
for ii = 1:width(AccuracyValid)
    if ~isnan(AccuracyValid(ii))
        weightedValidUncorrected(ii) = AccuracyValid(ii)*WeightsValid(ii);
    else
        weightedValidUncorrected(ii) = nan;
    end
end

AccuracyOverallValidWeightedUncorrected = (nansum(weightedValidUncorrected(:)))/(nansum(WeightsValid(:)));

weightedNeutralUncorrected = zeros;

% and again for neutral
AccuracyNeutral = table2array(PropCorrectNeutral);
for ii = 1:width(AccuracyNeutral)
    if ~isnan(AccuracyNeutral(ii))
        weightedNeutralUncorrected(ii) = AccuracyNeutral(ii)*WeightsNeutral(ii);
    else
        weightedNeutralUncorrected(ii) = nan;
    end
end

AccuracyOverallNeutralWeightedUncorrected = (nansum(weightedNeutralUncorrected(:)))/(nansum(WeightsNeutral(:)));

%% Now get corrected weights- valid
AccuracyValidCorrected = zeros;
weightedValidCorrected = zeros;
for ii = 1:width(AccuracyValid)
    if AccuracyValid(ii) <.50
        AccuracyValidCorrected(ii) = .50;
    else
        AccuracyValidCorrected(ii) = AccuracyValid(ii);
    end
    if ~isnan(AccuracyValidCorrected(ii))
        weightedValidCorrected(ii) = AccuracyValidCorrected(ii)*WeightsValid(ii);
    else
        weightedValidCorrected(ii) = nan;
    end
end

AccuracyOverallValidCorrectedWeighted = (nansum(weightedValidCorrected(:)))/(nansum(WeightsValid(:)));
%PropCorrectNeutralCorrected(ii)*
%AccuracyOverallValidCorrectedWeighted = nanmean(AccuracyValidCorrected);


%% Now correct and weight neutral

clearvars ii
AccuracyNeutralCorrected = zeros;
weightedNeutralCorrected = zeros;
for ii = 1:width(AccuracyNeutral)
    if AccuracyNeutral(ii) <.50
        AccuracyNeutralCorrected(ii) = .50;
    else
        AccuracyNeutralCorrected(ii) = AccuracyNeutral(ii);
    end
    if ~isnan(AccuracyNeutralCorrected(ii))
        weightedNeutralCorrected(ii) = AccuracyNeutralCorrected(ii)*WeightsNeutral(ii);
    else
        weightedNeutralCorrected(ii) = nan;
    end
end

AccuracyOverallNeutralCorrectedWeighted = (nansum(weightedNeutralCorrected(:)))/(nansum(WeightsNeutral(:)));

%% Now RT
medianRTNeutral = zeros;
for ii = 1:numLocations
    index = SubjectDataNeutral.Location(:) == ii & SubjectDataNeutral.rightwrong(:) == 1;
    medianRTNeutral(ii) = median(SubjectDataNeutral.RT(index));
    %PropCorrect.Location(ii)=sum(SubjDataOriginal.TargetLoc(index))/sum(index);
    clear index
end
medianRTNeutral = horzcat(medianRTNeutral(2),NaN, medianRTNeutral(1), NaN, medianRTNeutral(4), NaN,medianRTNeutral(3),NaN);

medianRTValid = zeros;
for ii = 1:numLocations
    index = SubjectDataValid.Location(:) == ii & SubjectDataValid.rightwrong(:) == 1;
    medianRTValid(ii) = median(SubjectDataValid.RT(index));
    %PropCorrect.Location(ii)=sum(SubjDataOriginal.TargetLoc(index))/sum(index);
    clear index
end
medianRTValid = horzcat(medianRTValid(2),NaN, medianRTValid(1), NaN, medianRTValid(4), NaN,medianRTValid(3),NaN);



%% Now that we have everything, let's get it saved how we want for the struct.
%accuracy neutral
SubjectsStruct.(subjectID).AccuracyNeutral = array2table(AccuracyNeutral);
SubjectsStruct.(subjectID).AccuracyNeutral.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};

%accuracy valid
SubjectsStruct.(subjectID).AccuracyValid = array2table(AccuracyValid);
SubjectsStruct.(subjectID).AccuracyValid.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};

%accuracy neutral corrected
SubjectsStruct.(subjectID).AccuracyNeutralCorrected = array2table(AccuracyNeutralCorrected);
SubjectsStruct.(subjectID).AccuracyNeutralCorrected.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};

%accuracy valid corrected
SubjectsStruct.(subjectID).AccuracyValidCorrected = array2table(AccuracyValidCorrected);
SubjectsStruct.(subjectID).AccuracyValidCorrected.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};

%Neutral Uncorrected overall
SubjectsStruct.(subjectID).AccuracyOverallNeutralWeightedUncorrected = AccuracyOverallNeutralWeightedUncorrected;
SubjectsStruct.(subjectID).AccuracyOverallNeutralWeighted = AccuracyOverallNeutralWeightedUncorrected;

%Valid Uncorrected overall
SubjectsStruct.(subjectID).AccuracyOverallValidWeightedUncorrected = AccuracyOverallValidWeightedUncorrected;
SubjectsStruct.(subjectID).AccuracyOverallValidWeighted = AccuracyOverallValidWeightedUncorrected;

%Neutral corrected overall
SubjectsStruct.(subjectID).AccuracyOverallNeutralCorrectedWeighted = AccuracyOverallNeutralCorrectedWeighted;
%Valid corrected overall
SubjectsStruct.(subjectID).AccuracyOverallValidCorrectedWeighted = AccuracyOverallValidCorrectedWeighted;

%Num trials per loc neutral
SubjectsStruct.(subjectID).NumTrialsNeutral = array2table(NumTrialsPerLocNeutral);
SubjectsStruct.(subjectID).NumTrialsNeutral.Properties.VariableNames = {'N','NE','E','SE','S','SW','W','NW'};

%Num trials per loc valid
SubjectsStruct.(subjectID).NumTrialsValid = array2table(NumTrialsPerLocValid);
SubjectsStruct.(subjectID).NumTrialsValid.Properties.VariableNames = {'N','NE','E','SE','S','SW','W','NW'};


%MedianRTNeutral
SubjectsStruct.(subjectID).medianRTNeutral = array2table(medianRTNeutral);
SubjectsStruct.(subjectID).medianRTNeutral.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};


SubjectsStruct.(subjectID).medianRTValid = array2table(medianRTValid);
SubjectsStruct.(subjectID).medianRTValid.Properties.VariableNames = {'North','Northeast','East','Southeast','South','Southwest','West','Northwest'};

%stim parameters

SubjectsStruct.(subjectID).tilt = tilt;
SubjectsStruct.(subjectID).sf = sf;
SubjectsStruct.(subjectID).ecc = ecc;
SubjectsStruct.(subjectID).ChildAdultCategory = ChildAdultCategory;
SubjectsStruct.(subjectID).ChildAdultNumeric = ChildAdultNumeric;
SubjectsStruct.(subjectID).Notes = Notes;
SubjectsStruct.(subjectID).Source = Source;
SubjectsStruct.(subjectID).Session = Session;
SubjectsStruct.(subjectID).everythingElse.BlockNums = BlockNums;
SubjectsStruct.(subjectID).everythingElse.Contrast = Contrast;
SubjectsStruct.(subjectID).everythingElse.ContrastMean = mean(Contrast);
SubjectsStruct.(subjectID).everythingElse.SubNo = SubNo;
SubjectsStruct.(subjectID).everythingElse.Heightin = Heightin;
SubjectsStruct.(subjectID).everythingElse.Observer = subjectID;
SubjectsStruct.(subjectID).dataAvailability = dataAvailability;
SubjectsStruct.(subjectID).attentionCond = attentionCond;
SubjectsStruct.(subjectID).Included = Included;
SubjectsStruct.(subjectID).everythingElse.Age = Age;
SubjectsStruct.(subjectID).numLocsTested = numLocations;
SubjectsStruct.(subjectID).everythingElse.scr = scr;


%% Now save
SubjectsStruct.(subjectID) = orderfields(SubjectsStruct.(subjectID));
SubjectsStruct = orderfields(SubjectsStruct);

cd /Volumes/purplab/EXPERIMENTS/1_Current_Experiments/Caroline/Caroline2/DPF_V2_(all)/DPFv2Scripts/
%SubjectsStruct2 = SubjectsStruct;
save('SubjectsStruct.mat','SubjectsStruct');


%cd /Volumes/purplab/EXPERIMENTS/1_Current_Experiments/Caroline/Caroline2/DPF_V2_(all)/ExtractData/Adults/CMv3/data

%% Now plot

[rawPlot] = v2polarPlotIndividualSubjs3(SubjectsStruct,subjectID,'plotThisSubj');
%[rawPlot2] = v2polarPlotIndividualSubjs3(SubjectsStruct,'s328HF_S2','plotThisSubj2');