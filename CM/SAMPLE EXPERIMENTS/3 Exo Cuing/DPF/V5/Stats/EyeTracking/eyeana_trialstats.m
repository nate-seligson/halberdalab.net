function eyeana_trialstats(sub,const)
% ----------------------------------------------------------------------
% eyeana_trialstats(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Count different trial and percentage of different exclusion criteria 
% of eye-tracker trials and create a summary in .txt and graphs
% ----------------------------------------------------------------------
% Input(s) :
% sub.ini : subject initial                 ex : 'MS'
% const : struct containing all the constant configurations
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 16 / 03 / 2019
% Project : AttShift
% Version : 10.0
% ----------------------------------------------------------------------

fileTypeTrialIncor = csvread(sprintf('%s_AllB_incorTrialTab_tr%1.3f.csv',sub.ini,sub.NEWtarR));
fileTypeTrialCor = csvread(sprintf('%s_AllB_corTrialTab_tr%1.3f.csv',sub.ini,sub.NEWtarR));
fileTypeTrial = [fileTypeTrialCor;fileTypeTrialIncor];

if ~isdir('summary');mkdir('summary');end

% Crierions
txt_criterions = {  '       Correct Trials        ',...
                    '       Incorrect Trials      ',...
                    '   Online eye error Trials   ',...
                    '     Missing Time Stamps     ',...
                    '     Blinks during trial     ',...
                    '       Off. fix. error       ',...
                    '     No saccade detected     ',...
                    '       Inaccurate sac.       '};

num_goodTrial               = 72;
num_badTrial                = num_goodTrial+1;
num_onlineEyeErrorTrial     = num_goodTrial+2;
num_missTimeStamps          = num_goodTrial+3;
num_missDurTrial            = num_goodTrial+4;
num_offlineFixErr           = num_goodTrial+5;
num_noSacDetected           = num_goodTrial+6;
num_innaccurateSac          = num_goodTrial+7;

num_crit  = [num_goodTrial;...
             num_badTrial;...
             num_onlineEyeErrorTrial;...
             num_missTimeStamps;...
             num_missDurTrial;...
             num_offlineFixErr;...
             num_noSacDetected;...
             num_innaccurateSac];...

% Data spliters
num_var1 = 10;  % Cue eccentricity
mod_var1 = 2;   % 2 modalities 
val_var1 = const.cue_pos;

txt_var1 = {'6deg','12deg'};

txt_split = {txt_var1};
num_split = [num_var1,mod_var1];
            %num_var2,mod_var2];

% Criterion Index 
for tCrit = 1:size(num_crit,1)
    indexCrit(:,tCrit) = fileTypeTrial(:,num_crit(tCrit,1))==1;
end

% Data spliters index (RWD/LWD)
for tCrit = 1:size(num_crit,1)
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            indexSplit(:,tMod,tCrit,tSplit) = fileTypeTrial(:,num_crit(tCrit,1))==1 & fileTypeTrial(:,num_split(tSplit,1)) == val_var1(tMod);
        end
    end
end

% Number Criterions
for tCrit = 1:size(num_crit,1)
    numbCrit(:,tCrit) = sum(indexCrit(:,tCrit));
end

% Number Split data
for tCrit = 1:size(num_crit,1)
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            numbSplit(:,tMod,tCrit,tSplit) =  sum(indexSplit(:,tMod,tCrit,tSplit));
        end
    end
end

% Percent Criterions
for tCrit = 1:size(num_crit,1)
    percentCrit(:,tCrit) = numbCrit(:,tCrit)/size(fileTypeTrial,1);
end

% Percent Split
for tCrit = 1:size(num_crit,1)
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            percentSplit(:,tMod,tCrit,tSplit) = (numbSplit(:,tMod,tCrit,tSplit)/numbCrit(:,tCrit));
        end
    end
end

% Saving data in text file
confile = sprintf('summary/%s_Summary_tr%1.3f.txt',sub.ini,sub.NEWtarR);
fcon = fopen(confile,'w');

for tCrit = 1:size(num_crit,1)
    fprintf(fcon,'\t%s:\t\t\t%4.0f\t(%0.3f)\n', txt_criterions{tCrit}, numbCrit(:,tCrit),percentCrit(:,tCrit));
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            fprintf(fcon,'\t%s:\t\t\t%4.0f\t(%0.3f)\n',txt_split{tSplit}{tMod}, numbSplit(:,tMod,tCrit,tSplit), percentSplit(:,tMod,tCrit,tSplit));
        end
    end
    fprintf(fcon,'\n');
end

fclose(fcon);

save(sprintf('summary/%s_numbCrit.mat',sub.ini),'numbCrit');
save(sprintf('summary/%s_numbSplit.mat',sub.ini),'numbCrit');
save(sprintf('summary/%s_percentCrit.mat',sub.ini),'percentCrit');
save(sprintf('summary/%s_percentSplit.mat',sub.ini),'percentSplit');

%% Figure

black           =   [0,0,0];
gray            =   [0.7,0.7,0.7];
blue            =   [0,0,0.8];
red             =   [0.8,0,0];
light_red       =   [1,0.5,0.5];
light_blue      =   [0.5,0.5,1];

fontsize = 7;
fontname = 'Monospaced';

xticklabel = txt_criterions;
xlim = [0 size(txt_criterions,2)+1];
maxNum = max(numbCrit)*2;
ylim = [0,maxNum];
xtick = 1:1:xlim(2)-1;
ytick = 0:25:max(numbCrit);

for tSplit = 1:size(num_split,1)
    colorUsed = lines(num_split(tSplit,2));
    f=figure();
    name = sprintf('%s General summary Split(%i)',sub.ini,tSplit);
    set(f, 'Name', name,'PaperOrientation', 'portrait','PaperUnits','normalized','PaperPosition', [-0.05,0.5,1.1,0.5]);
    figSize_X = 700;
    figSize_Y = 500;
    
    res = figSize_X/figSize_Y;
    start_X = 0;start_Y = 0;
    set(f,'Position',[start_X,start_Y,figSize_X+start_X,figSize_Y+start_Y]);

    matStackedAll = [];
    for tCrit = 1:size(num_crit,1)
        matStacked = numbSplit(:,:,tCrit,tSplit);
        matStackedAll = [matStackedAll;matStacked];
    end
    b = bar(matStackedAll,'stacked');
    for tMod = 1:num_split(tSplit,2)
        set(b(tMod),'FaceColor',colorUsed(tMod,:));
        legMat(tMod) = b(tMod); 
    end

    legD = legend(legMat,txt_split{tSplit});
    set(legD,'Position',[0.4 0.6 0.24 0.08], 'FontWeight','bold','FontSize', fontsize ,'FontName', fontname,'Box','off')
    set(gca, 'FontSize', fontsize ,'FontName', fontname, 'XLim', xlim ,'XTick', xtick,'YLim',ylim,'YTick',ytick,'XTickLabel','');
    
    
    % Axes            
    text(xlim(2)/2,ylim(2)+100,'Trials distribution','FontSize', fontsize+4 ,'FontName', fontname, 'FontWeight','bold','Color',black,'HorizontalAlignment','center')
    text(-0.1,0.4,'Trials','Units','normalized','FontSize', fontsize ,'FontName',fontname,'HorizontalAlignment','center','FontWeight','bold','Color',black,'Rotation',90);
    
    
    for tCrit = 1:size(txt_criterions,2)
        
        % Xlabel
        if mod(tCrit,2)
            text(tCrit/(size(txt_criterions,2)+1),-0.03,txt_criterions{tCrit},'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        else
            text(tCrit/(size(txt_criterions,2)+1),-0.06,txt_criterions{tCrit},'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        end
        
        % All trials
        text(tCrit/(size(txt_criterions,2)+1),0.98,sprintf('%i',numbCrit(tCrit)),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        text(tCrit/(size(txt_criterions,2)+1),0.94,sprintf('( %5.2f %%)',percentCrit(tCrit)*100),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        
        % Trials splited
        for tMod = 1:num_split(tSplit,2)
            
            text(tCrit/(size(txt_criterions,2)+1),0.90 -(0.08*(tMod-1)),sprintf('%i',numbSplit(1,tMod,tCrit,tSplit)),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center','Color',colorUsed(tMod,:));
            text(tCrit/(size(txt_criterions,2)+1),0.86 -(0.08*(tMod-1)),sprintf('( %5.2f %%)',percentSplit(1,tMod,tCrit,tSplit)*100),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center','Color',colorUsed(tMod,:));
            
        end
    end
    
    print('-dpdf',sprintf('summary/%s_typeTrialsSplit%i_tr%1.3f.pdf',sub.ini,tSplit,sub.NEWtarR)); 
    
end
end