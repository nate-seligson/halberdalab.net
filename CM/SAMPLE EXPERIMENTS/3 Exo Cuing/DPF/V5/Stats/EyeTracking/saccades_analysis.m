function saccades_analysis(sub,const)
% ----------------------------------------------------------------------
% saccades_analysis(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Analysis of saccade distribution in function of different caracteristic
% of saccades in that particular task such as saccade lenght,
% saccade duration, saccade latency, saccade velocity.
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configurations
% const : struct containing all the constant configurations
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Data saved :
% PDF files containing each histogram files
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 16 / 03 / 2019
% Project : AttShift
% Version : 10.0
% ----------------------------------------------------------------------

close all
%% General configuration
black =         [0,0,0];
orange =        [1 150/255 0];
fontsize = 8;
fontname = 'Courrier';

figSize_Yi = 150; %200
figSize_X = 1000;
start_X = 0;
start_Y = 0;

%% Comparison data from method of ajustment

fileRes    = dlmread(sprintf('%s_AllB_corTrialTab_tr%1.3f.csv',sub.ini,sub.NEWtarR));

%% Values
% Data spliters
num_var1 = 10;  % Cue / ST location
mod_var1 = 8;  % 8 modalities
val_var1 = const.st_pos_vec;
txt_var1 = {'All trials','0','45','90','135','180','225','270','315'};
        
        
txt_split = {txt_var1};
num_split = [num_var1,mod_var1];
val_var = {val_var1};

%% DATA
txtRes1 = 'Saccade latency (msec)';     rawRes1 = 63;               %!
txtRes2 = 'Saccade amplitude (deg)';    rawRes2 = 58;               %!

txt_criterions = {txtRes1,txtRes2};                   
num_crit  = [rawRes1;rawRes2];                          

nBins_res1 = 0:15:405;
nBins_res2 = 6:0.25:12;                
nBins_res = {nBins_res1;nBins_res2};  

maxAll      = 1500;
maxSpit     =  150;
allTick     =  250;
splitTick   =   25;

%% Criterion indices
for tSplit = 1:size(num_split,1)
    for tMod = 1:num_split(tSplit,2)
        indexSplit{tMod,tSplit} = fileRes(:,num_split(tSplit,1)) == val_var{tSplit}(tMod);
    end
end

%% Results
% All
for tSplit = 1:size(num_split,1)
    for tMod = 1:num_split(tSplit,2) % number of modalities (here 2: latency & amplitude)
        for tCrit = 1:size(num_crit,1)
            resCrit{tMod,tSplit,tCrit} = fileRes(indexSplit{tMod,tSplit},num_crit(tCrit,1));
        end
    end
end

for tSplit = 1:size(num_split,1)
    colorUsed = lines(num_split(tSplit,2));
    numSub = (num_split(tSplit,2)+1)*size(num_crit,1);
    tRow    = 1;    add     = 0;    addCol  = 0;
    numRawPlot = (num_split(tSplit,2)+1); % how may rows (== conditions + one for "all")
    
    for subP = 1:numSub % number of graphs
        if subP == 1
            f=figure(tSplit);
            figSize_Y = figSize_Yi*numRawPlot;
            name = (sprintf('%s_SacDistibution_split%i',sub.ini,tSplit));
            set(f, 'Name', name,'PaperOrientation', 'landscape','PaperUnits','normalized','PaperPosition', [-0.05,0,1.1,1]);
            set(f,'Position',[start_X,start_Y,figSize_X+start_X,figSize_Y+start_Y]);
            hold on;
        end
        
        if subP < size(num_crit,1) + 1 % all results
            for tCol = 1:size(num_crit,1)
                if ~mod(subP-tCol,tCol)
                    [n] = histc(fileRes(:,num_crit(tCol)),nBins_res{tCol});
                    xout = nBins_res{tCol};
                    plot_mean = nanmean(fileRes(:,num_crit(tCol)));
                    plot_median = nanmedian(fileRes(:,num_crit(tCol)));
                end
            end
        else
            if rem(subP-addCol,num_split(tSplit,2))
                [n] = histc(resCrit{tRow-1,tSplit,addCol+1},nBins_res{addCol+1});
                xout = nBins_res{addCol+1};
                plot_mean = nanmean(resCrit{tRow-1,tSplit,addCol+1});
                plot_median = nanmedian(resCrit{tRow-1,tSplit,addCol+1});
                addCol = addCol +1;
                if addCol == size(num_crit,1)
                    addCol = 0;
                end
                
            end
        end
        
        % Axes
        xlim = [xout(1) xout(end)];
        
        if subP == 1 || subP == 2 %% || subP == 3 || subP == 4
            ylim = [0 maxAll]; ytick = ylim(1):allTick:ylim(2);color = orange;
        else
            ylim = [0 maxSpit]; ytick = ylim(1):splitTick:ylim(2);color = colorUsed(tRow-1,:);
        end
        
        if ~mod(subP,size(num_crit,1))
            tRow = tRow +1;
        end
        
        subplot(numRawPlot,size(num_crit,1),subP)
        
        x_mean_med = 0.6;
        
        y_plot = ylim(1):1:ylim(2);
        p_mean = plot(0*y_plot+plot_mean,y_plot);
        set(p_mean,'LineWidth',1.2,'Color',color,'LineStyle','-')
        hold on
        p_median = plot(0*y_plot+plot_median,y_plot);
        set(p_median,'LineWidth',1.2,'Color',color,'LineStyle','--')
        hold on
        text(x_mean_med,0.8 ,sprintf('mean = %3.2f',plot_mean),'Units','normalized','FontSize',fontsize,'FontName',fontname,'HorizontalAlignment','left','Color',color);
        text(x_mean_med,0.7,sprintf('median = %3.2f',plot_median),'Units','normalized','FontSize',fontsize,'FontName',fontname,'HorizontalAlignment','left','Color',color);
        
        bplot = bar(xout,n);
        set(bplot,'EdgeColor',black,'FaceColor',color,'BarWidth',1);
        set(gca,'XLim',xlim,'YLim',ylim,'YTick',ytick,'Box','on','FontSize',fontsize,'FontName',fontname);
        
        numLeg1 = 1:size(num_crit,1):numSub;
        
        if sum(numLeg1 == subP)
            add = add +1;
            text(-0.2,0.5,txt_split{tSplit}(add),'Units','normalized','FontSize',fontsize+2,'HorizontalAlignment','center','Color',black,'Rotation',90);
        end
        
        ydist = -0.3;
        
        for tColT = 1:size(num_crit,1)
            if subP == numLeg1(end) + (tColT -1);
                text(0.5,ydist,txt_criterions{tColT},'Units','normalized','FontSize',fontsize+2,'HorizontalAlignment','center','Color',black);
            end
        end
    end
    plot_file = sprintf('summary/%s_tr%1.3f.pdf',name,sub.NEWtarR);
    print('-dpdf',plot_file)
end
end