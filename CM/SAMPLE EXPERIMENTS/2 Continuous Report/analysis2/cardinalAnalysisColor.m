%% Import our data for 3.1.26
numBins = 12;
clearvars -except figs2keep
close all
excludeSubs = 0;
bucketSize = 45;
load('colz.mat');
load('colorsAll.mat')
% figs2keep = [12];
% 
% all_figs = findobj(0, 'type', 'figure');
% delete(setdiff(all_figs, figs2keep));

clearvars subjID;
load('subjectStructNM3_1_26.mat')
numBins = 12;
subListAll = string(fieldnames(subjectStructNM3126));
IncludedDataMatrix = [];
for ii=1: length(subListAll)
     
    subjID(ii) = (subListAll(ii))';
  
   %%COMMENT IN TO INCLUDE
%    if subjectStructNM3126.(subjID(ii)).included == 1;
   
   % subjID(ii) = ('s1_subject_id')';
    
  [colors,tickLabels] =  getColors();
  
  guessd= table2array(subjectStructNM3126.(subjID(ii)).guessTrials);
%%guessd = importdata('guessTrials.csv');
%%guessresp = guessd.data(:,2);
%guessresp = str2double(guessd(:,23)); %reported color discrete
guessresp = subjectStructNM3126.(subjID(ii)).guessTrials.reported_ori_discrete;


%transformed:
guessdTransformed = table2array(subjectStructNM3126.(subjID(ii)).guessTrialsTransformed);
%guessrespTransformed = str2double(guessdTransformed(:,36));
guessrespTransformed = subjectStructNM3126.(subjID(ii)).guessTrialsTransformed.reported_ori_discrete;

%make array of trial numbers
guessTrialNum = double(1):double(length(guessresp));
guessTrialNum = guessTrialNum';




%% Getting our data: non guess 132 ms trials.
%intd = importdata('mostTargetSizeCM.csv');
 intd132= table2array(subjectStructNM3126.(subjID(ii)).nonGuessTrials132);
 
  intd132Transformed = table2array(subjectStructNM3126.(subjID(ii)).nonGuessTrials132Transformed);

  
intAns132 = subjectStructNM3126.(subjID(ii)).nonGuessTrials132.orientation_of_target;
intResp132 = subjectStructNM3126.(subjID(ii)).nonGuessTrials132.reported_ori_discrete;


intResp132Transformed = subjectStructNM3126.(subjID(ii)).nonGuessTrials132Transformed.TransformedResponseWinner; %transformed response, 35


%% Getting our data: non guess, ALL trials.



%intd = importdata('mostTargetSizeCM.csv');
intd= table2array(subjectStructNM3126.(subjID(ii)).nonGuessTrials);
intdTransformed = table2array(subjectStructNM3126.(subjID(ii)).nonGuessTrialsTransformed);
%intAns = intd.data(:,1); 
%intAns = str2double(intd(:,30)); %CMColor, the true color

intAns = subjectStructNM3126.(subjID(ii)).nonGuessTrials.orientation_of_target;
intAnsTransformed  = subjectStructNM3126.(subjID(ii)).nonGuessTrialsTransformed.orientation_of_target;%transformed true color, 36

%intResp = intd.data(:,2);
%intResp = str2double(intd(:,23)); %Reported color discrete
intResp = subjectStructNM3126.(subjID(ii)).nonGuessTrials.reported_ori_discrete;
intRespTransformed = subjectStructNM3126.(subjID(ii)).nonGuessTrialsTransformed.TransformedResponseWinner; %transformed response, 35


  %% NOW WE NEED TO GET EACH SUB'S AVG GUESS RATE FOR CARDINAL VS INTERCARDINAL
%bucketSize = 45
arrayLower = [((-.5)*bucketSize):bucketSize:360]';
arrayUpper = [(.5*bucketSize):bucketSize:(360 + (.5*bucketSize))]';
bucketArrays = horzcat(arrayLower,arrayUpper);

for jj = 1:length(bucketArrays)
    indexBucket = (guessresp >= bucketArrays(jj,1) & guessresp < bucketArrays(jj,2))
tempBucket  = guessresp(indexBucket);
    bucketArrays(jj,3) = length(tempBucket)
    clearvars indexBucket tempBucket
end
    

bucketArrays(1,1) = bucketArrays(length(bucketArrays),1)
bucketArrays(1,3) = (bucketArrays(1,3)) + (bucketArrays(length(bucketArrays),3))

bucketArrays(length(bucketArrays),:) = [];


if (sum(bucketArrays(:,3))) ~= length(guessresp)
    disp('STOP!!')
else
    disp(['bin size = ' num2str(bucketSize)])
end
% figure(5)
% bar(bucketArrays(:,3))
% xlabel('ori')
% ylabel('counts')
% title(['freq of guess resps, bin size = ' num2str(bucketSize)])
% xticks([1:height(bucketArrays)])
% xticklabels([num2str(bucketArrays(:,1)+(.5*bucketSize))])

bucketArrays(:,4) = bucketArrays(:,1)+(.5*bucketSize)
%keyboard;
%%%STOP HERE
idxEast = bucketArrays(:,4)==360;
idxSouth = bucketArrays(:,4)==90;
idxWest = bucketArrays(:,4)==180;
idxNorth = bucketArrays(:,4)==270;

East = bucketArrays(idxEast,:);
South = bucketArrays(idxSouth,:);
West = bucketArrays(idxWest,:);
North = bucketArrays(idxNorth,:);
cardinals = vertcat(East, South, West, North)

clearvars idxEast idxSouth idxWest idxNorth

noncardinals = bucketArrays
idxEast = noncardinals(:,4)==360;
noncardinals(idxEast,:) = []

idxSouth = noncardinals(:,4)==90;
noncardinals(idxSouth,:) = []

idxWest = noncardinals(:,4)==180;
noncardinals(idxWest,:) = []

idxNorth = noncardinals(:,4)==270;
noncardinals(idxNorth,:) = []

meanNonCardinal = mean((noncardinals(:,3)))
meanCardinal = mean((cardinals(:,3)))

figure(1)
bar(bucketArrays(:,3))
xlabel('ori')
ylabel('counts')
title(['freq of guess resps, bin size = ' num2str(bucketSize)])
xticks([1:height(bucketArrays)])
xticklabels([num2str(bucketArrays(:,1)+(.5*bucketSize))])


%[h,p,ci,stats] = ttest2(noncardinals(:,3),cardinals(:,3))
%keyboard;
  
%close all

%% Get all data
cleanedData = subjectStructNM3126.(subjID(ii)).cleanedData;
if ii == 1
cardinalMeansAll = [];
noncardinalMeansAll = [];
intRespTransformedAll = [];
intRespAll = [];
intAnsAll = [];
guessrespAll = [];
intAnsTransformedAll = [];
guessTrialNumAll= [];
cleanedDataAll = [];
meanErrorAll = [];
intResp132TransformedAll = [];
intAnsAll132 = [];
meanError132All = []
guessSubjectID_All = [];
else
    
end

cardinalMeansAll = vertcat(cardinalMeansAll,meanCardinal)
noncardinalMeansAll = vertcat(noncardinalMeansAll,meanNonCardinal)
intResp132TransformedAll = vertcat(intResp132TransformedAll,intResp132Transformed);
intAnsAll132 = vertcat(intAnsAll132,intAns132);
meanErrorAll = vertcat(meanErrorAll,subjectStructNM3126.(subjID(ii)).meanNonGuessError);
guessrespAll = vertcat(guessrespAll,guessresp);
intAnsAll = vertcat(intAnsAll,intAns);
intRespAll = vertcat(intRespAll,intResp);
intRespTransformedAll = vertcat(intRespTransformedAll,intRespTransformed);
intAnsTransformedAll = vertcat(intAnsTransformedAll,intAnsTransformed);
guessTrialNumAll = vertcat(guessTrialNumAll, guessTrialNum);
cleanedDataAll = vertcat(cleanedDataAll,cleanedData);
meanError132All = vertcat(meanError132All,subjectStructNM3126.(subjID(ii)).meanError132)
  %  else
    
  %  end
  
end

%% That's preprocessing. Now let's take a look. 
  keyboard;
  
pairedTMeans = horzcat(noncardinalMeansAll,  cardinalMeansAll)
[h,p,ci,stats] = ttest(noncardinalMeansAll,cardinalMeansAll)


subNums = (1:length(noncardinalMeansAll))
pairedTMeansTable = table;
pairedTMeansTable.subNum = subNums'
pairedTMeansTable.nonCardinals = noncardinalMeansAll;
pairedTMeansTable.cardinals = cardinalMeansAll;
keyboard;

%%export

filename = 'pairedTMeans.xlsx';
writetable(pairedTMeansTable,filename,'Sheet',1,'Range','A1')

%% Now let's clear some confusing variables. 
clearvars intAns132 intAns intd intd132 intd132Transformed guessd ...
gessdTransformed gessresp guessrespTransformed intAnsTransformed ...
intRespTransformed intResp intResp132 intResp132Transformed intdTransformed ...
guessresp guessdTransformed ii

%% Now as a first pass, let's look at accuracy and error for all trials


%% K-G test for uniformity

x = guessrespAll;
pd = makedist('uniform','Lower',0,'Upper',359);
%pd = makedist('uniform');
[h,p,ci,stats] = kstest(x,'cdf',pd)

%visualize it:
xx = 0:360;
y = pdf(pd, xx);
figure
plot(xx,y)
grid
