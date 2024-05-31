close all
clear all

clearvars subjID;
load('subjectStructNM3_1_23.mat')

subListAll = string(fieldnames(subjectStructNM));
IncludedDataMatrix = [];
for ii=1: 18%length(subListAll)
    subjID(ii) = (subListAll(ii))';
   
   % subjID(ii) = ('s1_subject_id')';
    
  [colors,tickLabels] =  getColors();

  
  %% Getting our data: guess trials.
guessd= table2array(subjectStructNM.(subjID(ii)).guessTrials);
%%guessd = importdata('guessTrials.csv');
%%guessresp = guessd.data(:,2);
guessresp = str2double(guessd(:,23)); %reported color discrete



%transformed:
guessdTransformed = table2array(subjectStructNM.(subjID(ii)).guessTrialsTransformed);
guessrespTransformed = str2double(guessdTransformed(:,36));


%make array of trial numbers
guessTrialNum = double(1):double(length(guessresp));
guessTrialNum = guessTrialNum';



cleanedDatur = subjectStructNM.(subjID(ii)).cleanedData;
%% Getting our data: non guess 66 ms trials.
%intd = importdata('mostTargetSizeCM.csv');
 intd66= table2array(subjectStructNM.(subjID(ii)).nonGuessTrials66);
 
  intd66Transformed = table2array(subjectStructNM.(subjID(ii)).nonGuessTrials66Transformed);

%intAns = intd.data(:,1); 
intAns66 = str2double(intd66(:,30)); %CMColor, the true color

%intResp = intd.data(:,2);
intResp66 = str2double(intd66(:,23)); %Reported color discrete



intResp66Transformed = str2double(intd66Transformed(:,36));


%% Getting our data: non guess, ALL trials.

 intd= table2array(subjectStructNM.(subjID(ii)).nonGuessTrials);
intdTransformed = table2array(subjectStructNM.(subjID(ii)).nonGuessTrialsTransformed);
%intAns = intd.data(:,1); 
intAns = str2double(intd(:,30)); %CMColor, the true color


%intResp = intd.data(:,2);
intResp = str2double(intd(:,23)); %Reported color discrete

intAnsTransformed  = str2double(intdTransformed(:,30));%transformed true color, 36
intRespTransformed = str2double(intdTransformed(:,36)); %transformed response, 35


if ii == 1

intRespTransformedAll = [];
intRespAll = [];
intAnsAll = [];
guessrespAll = [];
intAnsTransformedAll = [];
guessTrialNumAll= [];
cleanedDaturAll = [];
else
    
end


guessrespAll = vertcat(guessrespAll,guessresp);
intAnsAll = vertcat(intAnsAll,intAns);
intRespAll = vertcat(intRespAll,intResp);
intRespTransformedAll = vertcat(intRespTransformedAll,intRespTransformed);
intAnsTransformedAll = vertcat(intAnsTransformedAll,intAnsTransformed);
guessTrialNumAll = vertcat(guessTrialNumAll, guessTrialNum);
cleanedDaturAll = vertcat(cleanedDaturAll, cleanedDatur);

end


% %% Now plot
% [Y0bw, Y0dens, Y0mesh, Y0cdf] = kde(guessrespAll);
% figure
% subplot(2,1,1)
% histogram(guessrespAll)
% subplot(2,1,2)
% plot(Y0mesh',Y0dens)
% title('xmesh,density')

% guessrespAll = vertcat(guessrespAll,guessresp);
% intAnsAll = vertcat(intAnsAll,intAns);
% intRespAll = vertcat(intRespAll,intResp);
% intRespTransformedAll = vertcat(intRespTransformedAll,intRespTransformed);


%% Now their figure


figure(4);
% subplot(2,2,1);
% hist(guessresp);
% hold on;
% title('histogram of guess responses');
% ylabel('Frequency', 'FontSize', 18); 

subplot(2,2,1);

 plot(guessTrialNumAll, guessrespAll, 'ko');
 xlim([1,max(guessTrialNumAll)]);
 ylim([-180,540]);
 
 yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));

yticklabels(tickLabels)

 
 
% yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
%     240, 260, 280, 300, 320, 340,360]));
% ylim([0,365])
xlabel('Trial number')
ylabel('Behavioral response')
title('Behavioral responses on zero-ms trials')
yticklabels(tickLabels)
set(gca,'ticklength',[0.00 0.0]);
Marisize(12,1)



subplot(2,2,2);
plot(intAnsAll, intRespTransformedAll, 'ko');
set(gca,'ticklength',[0.00 0.0]);

xlim([-180,540]);
ylim([-180,540]);

xticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));
yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));

yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));

% xlim([0,365]);
% ylim([0,365]);
% xticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
%     240, 260, 280, 300, 320, 340,360]));
% yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
%     240, 260, 280, 300, 320, 340,360]));
 %360
 yticklabels(tickLabels)
  xticklabels(tickLabels)
Marisize(12,1)



hold on;


[Y0bw, Y0dens, Y0mesh, Y0cdf] = kdeCM(guessrespAll);


sig0N = std(guessrespAll, 1);
S = std(guessrespAll,1,'all');
mean0N = mean(guessrespAll);
title('Non-zero ms trials'); 
xlabel('Feature value', 'FontSize', 18); 
ylabel('Behavioral response', 'FontSize', 18); 

smoothwindowsize = 0.2; % .05 try to vary this: this variable is used for smoothing (especially when the numbers of trials for guessing condition and for actual test trials are not balanced)

% out = MLE_ModelFunc_V25_noncirc(intAns,intResp,1000,Y0dens,Y0mesh,smoothwindowsize);

%out = MLE_ModelFunc_V25_power (intAns,intRespTransformed,1000,Y0dens,Y0mesh,sig0N,mean0N, smoothwindowsize);
out = MLE_ModelFunc_V25_powerCM (intAnsTransformedAll,intRespTransformedAll,1000,Y0dens,Y0mesh,sig0N,mean0N, smoothwindowsize);


% result
subplot(2,2,3); 
hist(out.latent); 
xlim([0 1]); 
set(gca,'ticklength',[0.00 0.0]);
xlabel('Probability (Pint)', 'FontSize', 18); 
title('histogram of latent (Pint)'); 
Marisize(12,1)



subplot(2,2,4);
nn_tmp = length(out.X);
Zmat = out.latent; 
colorcode = zeros(nn_tmp,3);
colorcode(:,1)=Zmat;
colorcode(:,2)=1-Zmat;
sizecode = (abs(Zmat-0.5)+0.4)*24;
scatter(out.X,out.Y,sizecode,colorcode, 'linewidth',1.4);
xlim([-180,540]);
ylim([-180,540]);

xticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));
yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));
55555;
out;
title('model results'); 
xlabel('Feature value', 'FontSize', 18); 
ylabel('Behavioral response', 'FontSize', 18); 
set(gca,'ticklength',[0.00 0.0]);
yticklabels(tickLabels)
xticklabels(tickLabels)
% xlim([0,365]);
% ylim([0,365]);
% xticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
%     240, 260, 280, 300, 320, 340,360]));
% yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
%     240, 260, 280, 300, 320, 340,360]));
% xticklabels(tickLabels)  %360
% yticklabels(tickLabels)
sgtitle(['subject S',num2str(ii)]) 
Marisize(12,1)


averagePint = out.Pm;

%% Last figure


%%%%NOW HISTOGRAM ALL GUESS TRIALS
%subplot(3,2,2);
figure(9)
[counts,bins] = hist(guessrespAll,20); %# get counts and bin locations
barh(bins,(counts))


hold on;
%xlim([0,10])
title('Histogram of responses- guess trials');
%ylim([-180,540]);
%yticks(([0,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
  %  240, 260, 280, 300, 320, 340,360]));
ylabel('behavioral response')

%%
figure(10) 
plot(Y0cdf)
title('Y0cdf')

%%%
% figure(5)
% plot(Y0cdf);
% title(Y0cdf)

figure, plot(Y0mesh',Y0dens)
title('xmesh,density')

%% Now plot
[Y0bw, Y0dens, Y0mesh, Y0cdf] = kde(guessrespAll);
figure(11)

subplot(2,1,1)

histogram(guessrespAll)
xlim([0,360]);
xticks(([0,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));
 xticklabels(tickLabels)  %360
subplot(2,1,2)
plot(Y0mesh',Y0dens)
title('xmesh,density')

%% figure 12
figure(12)
[pdf,sig] = circ_ksdensity(guessrespAll, 1:360, 'niqr');
plot(pdf)
title('circular kde') 

%% 13- model fit

sig0N = std(guessrespAll, 1);
S = std(guessrespAll,1,'all');
mean0N = mean(guessrespAll);
smoothwindowsize = 0.05; % .05 try to vary this: this variable is used for smoothing (especially when the numbers of trials for guessing condition and for actual test trials are not balanced)

out = MLE_ModelFunc_V25_powerCM (intAnsAll,intRespTransformedAll,1000,Y0dens,Y0mesh,sig0N,mean0N, smoothwindowsize);


figure(13)
nn_tmp = length(out.X);
Zmat = out.latent; 
colorcode = zeros(nn_tmp,3);
colorcode(:,1)=Zmat;
colorcode(:,2)=1-Zmat;
sizecode = (abs(Zmat-0.5)+0.4)*24;
scatter(out.X,out.Y,sizecode,colorcode, 'linewidth',1.4);
xlim([-180,540]);
ylim([-180,540]);

xticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));
yticks(([3,20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, ...
    240, 260, 280, 300, 320, 340,360]));
55555;
out;
title('model results'); 
xlabel('Feature value', 'FontSize', 18); 
ylabel('Behavioral response', 'FontSize', 18); 
set(gca,'ticklength',[0.00 0.0]);
yticklabels(tickLabels)
xticklabels(tickLabels)

%% 14- check trial level differences
figure(15)

        index0cleanedData =  cleanedDaturAll.CMDispTime == 0;
        cleanedDataAll0 = cleanedDaturAll(index0cleanedData,:);
        clearvars indexZerocleanedData
        
        index66cleanedData =  cleanedDaturAll.CMDispTime == 66;
        cleanedDataAll66 = cleanedDaturAll(index66cleanedData,:);
        clearvars index66cleanedData
      
        index132cleanedData =  cleanedDaturAll.CMDispTime == 132;
        cleanedDataAll132 = cleanedDaturAll(index132cleanedData,:);
        clearvars index132cleanedData
        
plot(cleanedDataAll0.diffScore,'ko')      
hold on
plot(cleanedDataAll66.diffScore,'bo')   
hold on
plot(cleanedDataAll132.diffScore,'ro')  
hold on

DiffMean0 = mean(cleanedDataAll0.diffScore(:))
DiffMean66 = mean(cleanedDataAll66.diffScore(:))
DiffMean132 = mean(cleanedDataAll132.diffScore(:))





% 
% 
% for jj = 1:height(cleanedDaturAll) 
%     if cleanedDaturAll.CMDispTime(jj) == 0
%         plot(cleanedDaturAll.diffScore(jj),'ko');
%         hold on
%     elseif cleanedDaturAll.CMDispTime(jj) == 132
%         plot(cleanedDaturAll.diffScore(jj),'bo') 
%     else
%     end
% end