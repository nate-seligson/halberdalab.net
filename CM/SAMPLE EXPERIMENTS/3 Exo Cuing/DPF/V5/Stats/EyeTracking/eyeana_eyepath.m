function eyeana_eyepath(sub)
% ----------------------------------------------------------------------
% eyeana_eyepath(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw eye path (xy coordinates) for a certain amount of good and bad 
% trials.
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 05 / 02 / 2020
% Project : preSacTMS
% Version : 1.0
% ----------------------------------------------------------------------

load(sprintf('%s_const.mat',sub.ini));
load(sprintf('%s_anaEye.mat',sub.ini));
load(sprintf('%s_scr.mat',sub.ini));

%% General Settings
close all
maxDur = 8000;
xlim = [-100 maxDur];
percentCorSave = .01;
percentIncorSave = .05;

% Column
eyeOKcol    = 21;
tT1Col      = 37; % cue start
tT2Col  	= 39; % test start
tTGACol     = 47;
tAnswerCol  = 48;

col_goodTrial            = 71;
col_badTrial             = col_goodTrial + 1;
col_goodSacTrial         = col_goodTrial + 2;
col_badSacTrial          = col_goodTrial + 3;
col_goodFixTrial         = col_goodTrial + 4;
col_badFixTrial          = col_goodTrial + 5;
col_onlineEyeErrTrial    = col_goodTrial + 6;
col_missTimeStamps       = col_goodTrial + 7;
col_missDurTrial         = col_goodTrial + 8;
col_offlineFixErrorFix   = col_goodTrial + 9;
col_offlineFixErrorSac   = col_goodTrial + 10;
col_noSacDetect          = col_goodTrial + 11;
col_innaccurateSac       = col_goodTrial + 12;

boundLimBfr = anaEye.fixRad;

tSacOnset = 50;
tSacOffset = 51;
tarPosCol = [66,67]; % saccade target position x & y

ylim = [-10 10];

xLine = 0:1:maxDur;
minValY_bfr = - boundLimBfr;
maxValY_bfr = + boundLimBfr;

oneDeg_in_pixX = anaEye.PPD;

black =         [0,0,0];
blue =          [0,0,0.8];
light_blue =    [0.3,0.3,0.8];
red  =          [0.8,0,0];
light_gray =    [0.6 0.6 0.6];
light_orange =  [1, 200/255 150/255];
fontsize =      6;
fontname =      'Courrier';
linewdth =      0.5;

xtick = 0:1000:xlim(2);
ytick = ylim(1):2:ylim(2);
xtickName = 0:1000:maxDur;
ytickName = ytick;

figSize_Y = 320;
figSize_X = 1200;
start_X = 0;
start_Y = 0;

yLines = ylim(1):1:ylim(2);

%% Data
all_coordCor   = [];
all_coordIncor = [];

for rep = sub.startBlock:sub.endBlock
    load(sprintf('../Block%i/coord/%s_B%i_coordCor.mat',rep,sub.ini,rep));
    load(sprintf('../Block%i/coord/%s_B%i_coordIncor.mat',rep,sub.ini,rep));
    all_coordCor    = [all_coordCor   , coordCor];
    all_coordIncor  = [all_coordIncor , coordIncor];
    
end

% Correct trial selection
numDrawCor = [];timeDrawCor = 0;
for tsize = 1:size(all_coordCor,2)
    if ~isempty(all_coordCor{tsize})
        timeDrawCor = timeDrawCor + 1;
        numDrawCor = [numDrawCor;tsize];
    end
end
saveNumCor = randperm(timeDrawCor);
saveNumCor = numDrawCor(saveNumCor(1:round(timeDrawCor*percentCorSave)));

% Incorrect trial selection
numDrawIncor = [];timeDrawIncor = 0;

for tsize = 1:size(all_coordIncor,2)
    %if ~isempty(all_coordIncor{tsize})
    if ~isempty(all_coordIncor{tsize}) && all_coordIncor{tsize}{1}(eyeOKcol) ~= -1 % no online fixation error
        timeDrawIncor = timeDrawIncor + 1;
        numDrawIncor = [numDrawIncor;tsize];
    end
end
saveNumIncor = randperm(timeDrawIncor);
saveNumIncor = numDrawIncor(saveNumIncor(1:round(timeDrawIncor*percentIncorSave)));


%% Correct saccade graphs
for timeRepCor = 1:size(saveNumCor,1)
    
    
    f=figure(timeRepCor);
    name = (sprintf('%s Correct fix. No%i',sub.ini,timeRepCor));
    set(f, 'Name', name,'PaperOrientation', 'landscape','PaperUnits','normalized','PaperPosition', [0,0.5,1,0.4]);
    set(f,'Position',[start_X,start_Y,figSize_X+start_X,figSize_Y+start_Y]);
    
    numPlay             =   saveNumCor(timeRepCor);
    
    tT1         =   all_coordCor{numPlay}{1}(tT1Col);
    tT2         =   all_coordCor{numPlay}{1}(tT2Col);
    tTGetAnswer =   all_coordCor{numPlay}{1}(tTGACol);
    tAsw        =   all_coordCor{numPlay}{1}(tAnswerCol);
    
    dat         = all_coordCor{numPlay}{2};    
    
    idx  = find(dat(:,1) >= tT1 & dat(:,1) <= tAsw);
    xlim = [-10,idx(end)+200];
    time = dat(idx,1);
    timeAxis = 1:size(time,1);
    xTrace = dat(idx,2);
    yTrace = dat(idx,3);
    xPlot = (xTrace - scr.x_mid)/oneDeg_in_pixX;
    yPlot = (yTrace - scr.y_mid)/oneDeg_in_pixX;
    
    t1         = find(time==tT1);
    t2         = find(time==tT2);
    tGetAnswer = find(time==tTGetAnswer);
    tAnswer    = find(time==tAsw);
    if isempty(tAnswer)
        tAnswer  = time(end);
    end
    
    filtX = filterSacTrace(xPlot,75,0.01);
    filtY = filterSacTrace(yPlot,75,0.01);
    
    % X Trace
    subplot(1,3,1);
    title(sprintf('Correct trials (%2.1f percent): X traces',percentCorSave*100));
    xlabel('Time (msec)')
    ylabel('X coordinates (deg)')
    
    % saconset/offset
    hold on
    
    %% time line
    % t1 line
    plot(0*yLines+t1,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t1+t2)/2,ylim(2)-4,'t1','Rotation',90,'Color',light_blue);
    % t2 line
    plot(0*yLines+t2,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t2+tGetAnswer)/2,ylim(2)-4,'t2','Rotation',90,'Color',light_blue);
    
    % tGetAnswer line
    plot(0*yLines+tGetAnswer,yLines,'--','Color',light_blue,'LineWidth',1);
    text((tGetAnswer+tAnswer)/2,ylim(2)-4,'tGAsw','Rotation',90,'Color',light_blue);
    % tAnswer
    plot(0*yLines+tAnswer,yLines,'--','Color',light_blue,'LineWidth',1);
    
	% fixation boundary
    plot(xLine,0*xLine+minValY_bfr,'LineWidth',1.5,'Color',light_orange);
    plot(xLine,0*xLine+maxValY_bfr,'LineWidth',1.5,'Color',light_orange);
    
    if all_coordCor{numPlay}{1}(tSacOnset)~=-8;
        % Saccade boundary
        tarPosX = all_coordCor{numPlay}{1}(tarPosCol(1));
        minValXdeg = (tarPosX - scr.x_mid)/oneDeg_in_pixX - boundLimBfr;
        maxValXdeg = (tarPosX - scr.x_mid)/oneDeg_in_pixX + boundLimBfr;
        
        xLineSac = t2:1:tGetAnswer;
        plot(xLineSac,0*xLineSac+minValXdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        plot(xLineSac,0*xLineSac+maxValXdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        
        % Sac Onset / Sac Offset
        ySacOnset = ylim(1):1:ylim(2);
        sacOnset  = find(time==all_coordCor{numPlay}{1}(tSacOnset));
        sacOffset = find(time==all_coordCor{numPlay}{1}(tSacOffset));
        plot(0*ySacOnset+sacOnset,ySacOnset,'Color',blue,'LineWidth',linewdth*1.1);
        plot(0*ySacOnset+sacOffset,ySacOnset,'Color',red,'LineWidth',linewdth*1.1);
             
    end
    
    % X trace
    pxTrace = plot(timeAxis,filtX);set(pxTrace,'Color',black,'LineWidth',2); 
    
    % Details of figure
    set(gca,'Xlim',xlim,'XTick',xtick,'XTickLabel',xtickName,'Ylim',ylim,'YTick',ytick,'YTickLabel',ytickName,'XTickLabel',xtickName,'Box','off','FontSize',fontsize +4,'FontName',fontname)
    
	% Y Trace
	subplot(1,3,2);hold on
    title(sprintf('Correct trials (%2.1f percent): Y traces',percentCorSave*100));
    xlabel('Time (msec)')
    ylabel('Y coordinates (deg)')
    
    % t1 line
    plot(0*yLines+t1,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t1+t2)/2,ylim(2)-4,'t1','Rotation',90,'Color',light_blue);
    % t2 line
    plot(0*yLines+t2,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t2+tGetAnswer)/2,ylim(2)-4,'t2','Rotation',90,'Color',light_blue);
    % tGetAnswer line
    plot(0*yLines+tGetAnswer,yLines,'--','Color',light_blue,'LineWidth',1);
    text((tGetAnswer+tAnswer)/2,ylim(2)-4,'tGAsw','Rotation',90,'Color',light_blue);
    % tAnswer
    plot(0*yLines+tAnswer,yLines,'--','Color',light_blue,'LineWidth',1);
    
	% fixation boundary
    plot(xLine,0*xLine+minValY_bfr,'LineWidth',1.5,'Color',light_orange);
    plot(xLine,0*xLine+maxValY_bfr,'LineWidth',1.5,'Color',light_orange);
    
    
    if all_coordCor{numPlay}{1}(tSacOnset)~=-8;
        % Saccade boundary
        tarPosY = all_coordCor{numPlay}{1}(tarPosCol(2));
        minValYdeg = (tarPosY - scr.y_mid)/oneDeg_in_pixX - boundLimBfr;
        maxValYdeg = (tarPosY - scr.y_mid)/oneDeg_in_pixX + boundLimBfr;
        xLineSac = t2:1:tGetAnswer;
        plot(xLineSac,0*xLineSac+minValYdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        plot(xLineSac,0*xLineSac+maxValYdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        
        % Sac Onset / Sac Offset
        ySacOnset = ylim(1):1:ylim(2);
        sacOnset  = find(time==all_coordCor{numPlay}{1}(tSacOnset));
        sacOffset = find(time==all_coordCor{numPlay}{1}(tSacOffset));
        plot(0*ySacOnset+sacOnset,ySacOnset,'Color',blue,'LineWidth',linewdth*1.1);
        plot(0*ySacOnset+sacOffset,ySacOnset,'Color',red,'LineWidth',linewdth*1.1);
        
    end
    
    % X trace
    pyTrace = plot(timeAxis,filtY);set(pyTrace,'Color',black,'LineWidth',2);
    
    set(gca,'Xlim',xlim,'XTick',xtick,'XTickLabel',xtickName,'Ylim',ylim,'YTick',ytick,'YTickLabel',ytickName,'XTickLabel',xtickName,'Box','off','FontSize',fontsize +4,'FontName',fontname)
 
    if ~isdir('summary/COR/')
        mkdir('summary/COR/')
    end
     
    saveas(f,sprintf('summary/COR/%s_eyetraces%i.pdf',sub.ini,timeRepCor));
    pause(0.2)
    close all
    
end


%% Incorrect saccade graphs
for timeRepIncor = 1:size(saveNumIncor,1)
    
    f=figure(timeRepIncor+timeRepCor);
    
    name = (sprintf('%s Incorrect sac. No%i',sub.ini,timeRepIncor));
    set(f, 'Name', name,'PaperOrientation', 'landscape','PaperUnits','normalized','PaperPosition', [0,0.5,1,0.4]);
    set(f,'Position',[start_X,start_Y,figSize_X+start_X,figSize_Y+start_Y]);
    
    numPlay = saveNumIncor(timeRepIncor);
    
    tT1         =   all_coordIncor{numPlay}{1}(tT1Col);
    tT2         =   all_coordIncor{numPlay}{1}(tT2Col);
    tTGetAnswer =   all_coordIncor{numPlay}{1}(tTGACol);
    tAsw        =   all_coordIncor{numPlay}{1}(tAnswerCol);
    
    dat         = all_coordIncor{numPlay}{2};
    
    idx  = find(dat(:,1) >= tT1 & dat(:,1) <= tAsw);
    xlim = [-10,idx(end)+200];
    time = dat(idx,1);
    timeAxis = 1:size(time,1);
    xTrace = dat(idx,2);
    yTrace = dat(idx,3);
    xPlot = (xTrace - scr.x_mid)/oneDeg_in_pixX;
    yPlot = (yTrace - scr.y_mid)/oneDeg_in_pixX;
    
    t1         = find(time==tT1);
    t2         = find(time==tT2);
    tGetAnswer = find(time==tTGetAnswer);
    tAnswer    = find(time==tAsw);
    if isempty(tAnswer)
        tAnswer  = time(end);
    end
    
    filtX = filterSacTrace(xPlot,75,0.01);
    filtY = filterSacTrace(yPlot,75,0.01);
    
% X Trace
    subplot(1,3,1);
    title(sprintf('Incorrect trials (%2.1f percent): X traces',percentIncorSave*100));
    xlabel('Time (msec)')
    ylabel('X coordinates (deg)')
    
    % saconset/offset
    hold on
    
    % t1 line
    plot(0*yLines+t1,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t1+t2)/2,ylim(2)-4,'t1','Rotation',90,'Color',light_blue);
    % t2 line
    plot(0*yLines+t2,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t2+tGetAnswer)/2,ylim(2)-4,'t2','Rotation',90,'Color',light_blue);   
    % tGetAnswer line
    plot(0*yLines+tGetAnswer,yLines,'--','Color',light_blue,'LineWidth',1); 
    text((tGetAnswer+tAnswer)/2,ylim(2)-4,'tGAsw','Rotation',90,'Color',light_blue);
    % tAnswer
    plot(0*yLines+tAnswer,yLines,'--','Color',light_blue,'LineWidth',1);
    
	% fixation boundary
    plot(xLine,0*xLine+minValY_bfr,'LineWidth',1.5,'Color',light_orange);
    plot(xLine,0*xLine+maxValY_bfr,'LineWidth',1.5,'Color',light_orange);
    
    if all_coordIncor{numPlay}{1}(tSacOnset)~=-8;
        % Saccade boundary
        tarPosX = all_coordIncor{numPlay}{1}(tarPosCol(1));
        minValXdeg = (tarPosX - scr.x_mid)/oneDeg_in_pixX - boundLimBfr;
        maxValXdeg = (tarPosX - scr.x_mid)/oneDeg_in_pixX + boundLimBfr;
        xLineSac = t2:1:tGetAnswer;
        plot(xLineSac,0*xLineSac+minValXdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        plot(xLineSac,0*xLineSac+maxValXdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        
        % Sac Onset / Sac Offset
        ySacOnset = ylim(1):1:ylim(2);
        sacOnset  = find(time==all_coordIncor{numPlay}{1}(tSacOnset));
        sacOffset = find(time==all_coordIncor{numPlay}{1}(tSacOffset));
        if ~isempty(sacOnset);  plot(0*ySacOnset+sacOnset,ySacOnset,'Color',blue,'LineWidth',linewdth*1.1);end
        if ~isempty(sacOffset); plot(0*ySacOnset+sacOffset,ySacOnset,'Color',red,'LineWidth',linewdth*1.1);end
        
    end
    
    % X trace
    pxTrace = plot(timeAxis,filtX);set(pxTrace,'Color',black,'LineWidth',2); 
    
    % Details of figure
    set(gca,'Xlim',xlim,'XTick',xtick,'XTickLabel',xtickName,'Ylim',ylim,'YTick',ytick,'YTickLabel',ytickName,'XTickLabel',xtickName,'Box','off','FontSize',fontsize +4,'FontName',fontname)
    
% Y Trace
    subplot(1,3,2);hold on
    title(sprintf('Incorrect trials (%2.1f percent): Y traces',percentIncorSave*100));
    xlabel('Time (msec)')
    ylabel('Y coordinates (deg)')
    
    % t1 line
    plot(0*yLines+t1,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t1+t2)/2,ylim(2)-4,'t1','Rotation',90,'Color',light_blue);
    % t2 line
    plot(0*yLines+t2,yLines,'--','Color',light_blue,'LineWidth',1);
    text((t2+tGetAnswer)/2,ylim(2)-4,'t2','Rotation',90,'Color',light_blue);
    % tGetAnswer line
    plot(0*yLines+tGetAnswer,yLines,'--','Color',light_blue,'LineWidth',1);
    text((tGetAnswer+tAnswer)/2,ylim(2)-4,'tGAsw','Rotation',90,'Color',light_blue);
    % tAnswer
    plot(0*yLines+tAnswer,yLines,'--','Color',light_blue,'LineWidth',1);
    
    % fixation boundary
    plot(xLine,0*xLine+minValY_bfr,'LineWidth',1.5,'Color',light_orange);
    plot(xLine,0*xLine+maxValY_bfr,'LineWidth',1.5,'Color',light_orange);
    
    if all_coordIncor{numPlay}{1}(tSacOnset)~=-8;
        % Saccade boundary
        tarPosY = all_coordIncor{numPlay}{1}(tarPosCol(2));
        minValYdeg = (tarPosY - scr.y_mid)/oneDeg_in_pixX - boundLimBfr;
        maxValYdeg = (tarPosY - scr.y_mid)/oneDeg_in_pixX + boundLimBfr;
        xLineSac = t2:1:tGetAnswer;
        plot(xLineSac,0*xLineSac+minValYdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        plot(xLineSac,0*xLineSac+maxValYdeg,'LineWidth',1.5,'Color',light_orange,'LineStyle','--');
        
        % Sac Onset / Sac Offset
        ySacOnset = ylim(1):1:ylim(2);
        sacOnset  = find(time==all_coordIncor{numPlay}{1}(tSacOnset));
        sacOffset = find(time==all_coordIncor{numPlay}{1}(tSacOffset));
        if ~isempty(sacOnset);  plot(0*ySacOnset+sacOnset,ySacOnset,'Color',blue,'LineWidth',linewdth*1.1);end
        if ~isempty(sacOffset); plot(0*ySacOnset+sacOffset,ySacOnset,'Color',red,'LineWidth',linewdth*1.1);end
        
    end
    
    % Y trace
    pyTrace = plot(timeAxis,filtY);set(pyTrace,'Color',black,'LineWidth',2);
    
    set(gca,'Xlim',xlim,'XTick',xtick,'XTickLabel',xtickName,'Ylim',ylim,'YTick',ytick,'YTickLabel',ytickName,'XTickLabel',xtickName,'Box','off','FontSize',fontsize +4,'FontName',fontname)
    
    
        
    % Type of error
    subplot(1,3,3);hold on
    if all_coordIncor{numPlay}{1}(col_badTrial) == 1
        if all_coordIncor{numPlay}{1}(col_badSacTrial) == 1; tbadSacTrial = 'yes';
        else tbadSacTrial = '-';
        end
        if all_coordIncor{numPlay}{1}(col_badFixTrial) == 1; tbadFixTrial = 'yes';
        else tbadFixTrial = '-';
        end
        if all_coordIncor{numPlay}{1}(col_missDurTrial) == 1; tmissDurTrial = 'yes';
        else tmissDurTrial = '-';
        end
        if all_coordIncor{numPlay}{1}(col_offlineFixErrorFix) == 1; tofflineFixErrorFix = 'yes';
        else tofflineFixErrorFix = '-';
        end
        if all_coordIncor{numPlay}{1}(col_offlineFixErrorSac) == 1; tofflineFixErrorSac = 'yes';
        else tofflineFixErrorSac = '-';
        end
        if all_coordIncor{numPlay}{1}(col_noSacDetect) == 1; tnoSacDetect = 'yes';
        else tnoSacDetect = '-';
        end
        if all_coordIncor{numPlay}{1}(col_innaccurateSac) == 1; tinnaccurateSac1 = 'yes';
        else tinnaccurateSac1 = '-';
        end
    end
    title({sprintf('badSacTrial: %s',tbadSacTrial);...
        sprintf('badFixTrial: %s',tbadFixTrial);...
        sprintf('missDurTrial: %s',tmissDurTrial);...
        sprintf('offlineFixErrorFix: %s',tofflineFixErrorFix);...
        sprintf('offlineFixErrorSac: %s',tofflineFixErrorSac);...
        sprintf('noSacDetected: %s',tnoSacDetect);...
        sprintf('innaccurateSac: %s',tinnaccurateSac1)});
        
    
    if ~isdir('summary/INCOR/')
        mkdir('summary/INCOR/')
    end
    saveas(f,sprintf('summary/INCOR/%s_eyetraces%i.pdf',sub.ini,timeRepIncor));
    pause(0.2);
    close all
    
end
