function extractor(sub)
% ----------------------------------------------------------------------
% extractor(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Extract results, mean, number of the different combination of variable 
% used in this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
% const : experiment constants
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-11
% Project : DPF
% Version : 3.0
% ----------------------------------------------------------------------

if ~isdir('../Extract/');mkdir('../Extract/');end

fileRes = csvread(sprintf('csv/%s_AllB_corMat.csv',sub.ini));
col = size(fileRes,2);

% =========================================================================
block_col   =  1;       % block #
cond_col    =  2;       % condition (0 = fixation, 1 = saccade, 100 = no TMS)
contr_col   =  5;       % contrast lefel (1 weak : 6 strong) 
tilt1_col   =  6;
tilt2_col   =  7; 
tmsTime_col =  8;       % TMS pulse time (1=0, 2=50, 3=100, 4=150, 5=200, NaN=noTMS)
sacSide_col =  9;       % saccade direction (0 = no saccade, 1 = rightwards, 2 = leftwards)
tarSide_col = 10;       % target side (1 = right, 2 = left)
tmsSide_col = 12;       % phosphene side (1 = right, 2 = left)

col77       = 20;
res_col     = 22;       % correctness of response (1 = COR, 0 = INCOR)

sacON_col    = 72;
tms1_col     = 75;
tms2_col     = 76;
sacLat_col   = 92;
sacAmp_col   = 87;
sacErr_col   = 93;
rt_col       = 105;

sacMatch_col = col+1;
tmsMatch_col = col+2;
incl_col     = col+3;
phosnum_col  = col+4;
tmssacMatch_col = col+5;

tmsTime2Sac_col = col+6;
tmsTime2SacBIN_col = col+7;

% =========================================================================

thresteps = 1;      % one value per condition (1) or threshold (e.g. contrast) steps (2)

% Re-label NaN -> 6 for no TMS
fileRes_ALL(isnan(fileRes_ALL(:,tms1_col)),tmsTime_col) = NaN; % put trials with no TMS puls in no TMS condition
fileRes_ALL(isnan(fileRes_ALL(:,tms2_col)),tmsTime_col) = NaN; % put trials with no TMS pule in no TMS condition
fileRes_ALL(isnan(fileRes_ALL(:,tmsTime_col)),tmsTime_col) = 6;


% Check which blocks to include
if ~strcmp(sub.ini,'SUPER')
    for i = 1:size(fileRes_ALL,1)
        if ismember(fileRes_ALL(i,block_col),sub.nbBlocks)
            fileRes_ALL(i,incl_col) = 1;
        else
            fileRes_ALL(i,incl_col) = 0;
        end
    end
    fileRes_ALL = fileRes_ALL(fileRes_ALL(:,incl_col)==1,:);
    
    
    % determine phosphene side
    fileRes_ALL(:,tmsSide_col) = NaN; % <- that's a lie
    phosnum_vec = [];
    for idx_b = sub.nbBlocks
        
        % check which phosphene location for each block
        load(sprintf('../Block%i/const_file%s_%s_%s.mat',idx_b,sub.ini,sub.expName,sub.domEye),'const')
        fileRes_ALL(fileRes_ALL(:,block_col)==idx_b,phosnum_col) = const.phphNum;
        phosnum_vec = [phosnum_vec,const.phphNum];
        
        % load phosphene session and check phosphene side
        load(sprintf('../../Phos_data/Session_%i/%s_PhosVals%i.mat',const.phphNum,sub.ini,const.phphNum),'phos')
        if phos.stimCenterX > const.fixPos(1)
            fileRes_ALL(fileRes_ALL(:,block_col)==idx_b,tmsSide_col) = 1;
        else
            fileRes_ALL(fileRes_ALL(:,block_col)==idx_b,tmsSide_col) = 2;
        end
    end
    phosnum_vec = unique(phosnum_vec);
    
end

%% Calculate col+ values
% =========================================================================

fileRes = fileRes_ALL;
fileRes(:,col77) = 77;


% recompute re: test location
for i = 1:size(fileRes,1)
    
    % sacMatch_col
    if fileRes(i,sacSide_col) == 0
        fileRes(i,sacMatch_col) = 0;
        fileRes(i,tmssacMatch_col) = 0;
    elseif fileRes(i,sacSide_col) == 1 || fileRes(i,sacSide_col) == 2
        if fileRes(i,sacSide_col) == fileRes(i,tarSide_col)
            fileRes(i,sacMatch_col) = 1;
        else
            fileRes(i,sacMatch_col) = 2;
        end
        
        if fileRes(i,sacSide_col) == fileRes(i,tmsSide_col)
            fileRes(i,tmssacMatch_col) = 1;
        else
            fileRes(i,tmssacMatch_col) = 2;
        end        
    end
      
    % tmsMatch_col
    if fileRes(i,tmsSide_col) == fileRes(i,tarSide_col)
        fileRes(i,tmsMatch_col) = 1;
    else
        fileRes(i,tmsMatch_col) = 2;
    end
    
end


% compute tms2sac time & bin
binSize = 100;
binVec =    [   0 : -50 : -200;...
         -binSize : -50 : -200-binSize ];
binVec = fliplr(binVec);
%    1     2     3     4     5    >> make sure it's 5 (for now)
% ------------------------------
%  -200  -150  -100   -50     0
%  -300  -250  -200  -150  -100

fileRes(:,tmsTime2Sac_col) = NaN;
fileRes(:,tmsTime2SacBIN_col+1:tmsTime2SacBIN_col+(size(binVec,2)+1)) = NaN;
for i = 1:size(fileRes,1)
    
    fileRes(i,tmsTime2Sac_col) = fileRes(i,tms1_col)- fileRes(i,sacON_col);
    
    if isnan(fileRes(i,tmsTime2Sac_col))
        fileRes(i,tmsTime2SacBIN_col+(size(binVec,2)+1)) = size(binVec,2)+1;
    else
        % make BINS
        for ii = 1:size(binVec,2)
            if fileRes(i,tmsTime2Sac_col) > binVec(2,ii) && fileRes(i,tmsTime2Sac_col) <= binVec(1,ii)
                fileRes(i,tmsTime2SacBIN_col+ii) = ii;
            end
        end
    end
end


% =========================================================================
% ============================== EXTRACTIONS ==============================
% =========================================================================

ex1 = 1;
ex2 = 1;
ex3 = 1;
ex4 = 1;
ex5 = 1;
ex6 = 1;
ex7 = 1;

dlmwrite(sprintf('../Extract/%s_fileRes.csv',sub.ini),fileRes,'precision','%10.5f');


%% E1 : All trials
    % E1a : all
    % E1b : split contr
    
%% E2 : Split SAC-Match
    % E2a : all
    % E2b : split contr

%% E3 : Split TMS-Match
    % E3a : all
    % E3b : contr

%% E4 : Split TMS-Match & TMS time
    % E4a : all
    % E4b : contr
    
%% E5 : Split SAC-Match & TMS time
    % E5a : all
    % E5b : contr
    
%% E6 : Split SAC-Match & TMS-Match & TMS time
    % E6a : all
    % E6b : contr
    
    
%%% new
%% E7 : Split tmssac-Match & TMS time
    % E3a : all
    % E3b : contr

    
% =========================================================================

%% E1  : All trials -------------------------------------------------------
%  E1a : all
%  E1b : split contr

% col#01 = split1: NaN / Contrast steps (1-6)
% col#02 = split2: NaN
% col#03 = split3: NaN
% col#04 = split4: NaN
% col#05 = split5: NaN
% col#06 = performance (% corr)
% col#07 = performance (dprime)
% col#08 = saccade latency (ms)
% col#09 = saccade latency variance
% col#10 = saccade amplitude (deg)
% col#11 = saccade amplitude variance
% col#12 = saccade error (deg)
% col#13 = saccade error variance
% col#14 = number of trials
% col#15 = RT

if ex1
dataFile = fileRes;

for idxE = 1:thresteps

    all.tab=[];         all.num=[];
    all.mean_perf=[];   all.mean_dprime=[];
    all.mean_sacLat=[]; all.var_sacLat=[];
    all.mean_sacAmp=[]; all.var_sacAmp=[];
    all.mean_sacErr=[]; all.var_sacErr=[];
    all.med_rt=[];
    
    switch idxE
        case 1; c_col = col77;      exType = 'E1a';
        case 2; c_col = contr_col;  exType = 'E1b';
    end
    
    for contr = unique(fileRes(:,c_col))'
        index.contr = dataFile(:,c_col) == contr;
        
        allData         =   dataFile(index.contr,:);
        val_perf        =   allData(:,res_col);
        val_sacLat      =   allData(:,sacLat_col);
        val_sacAmp      =   allData(:,sacAmp_col);
        val_sacErr      =   allData(:,sacErr_col);
        val_rt          =   allData(:,rt_col);
        
        if isempty(val_perf)
            mean_perf       =   NaN;
            mean_dprime     =   NaN;
            mean_sacLat     =   NaN;
            var_sacLat  	=   NaN;
            mean_sacAmp     =   NaN;
            var_sacAmp      =   NaN;
            mean_sacErr     =   NaN;
            var_sacErr      =   NaN;
            num             =   0;
            med_rt          =   NaN;
            tab             =   [contr];
        else
            mean_perf       =   nanmean(val_perf);
            mean_dprime     =   dprime_HFA(nanmean(val_perf),2);
            mean_sacLat     =   nanmedian(val_sacLat);
            var_sacLat  	=   nanstd(val_sacLat);
            mean_sacAmp     =   nanmedian(val_sacAmp);
            var_sacAmp      =   nanstd(val_sacAmp);
            mean_sacErr     =   nanmedian(val_sacErr);
            var_sacErr      =   nanstd(val_sacErr);
            num             =   numel(val_perf);
            med_rt          =   abs(nanmedian(val_rt));
            tab             =   nanmean([allData(:,c_col)],1);
        end
        
        all.tab             =   [all.tab;         	tab         ];
        all.mean_perf       =   [all.mean_perf;    	mean_perf   ];
        all.mean_dprime     =   [all.mean_dprime;  	mean_dprime ];
        all.mean_sacLat     =   [all.mean_sacLat;  	mean_sacLat ];
        all.var_sacLat      =   [all.var_sacLat;   	var_sacLat  ];
        all.mean_sacAmp     =   [all.mean_sacAmp;  	mean_sacAmp ];
        all.var_sacAmp      =   [all.var_sacAmp;  	var_sacAmp  ];
        all.mean_sacErr     =   [all.mean_sacErr;  	mean_sacErr ];
        all.var_sacErr      =   [all.var_sacErr;  	var_sacErr  ];
        all.num             =   [all.num;           num         ];
        all.med_rt          =   [all.med_rt;     	med_rt      ];
    end
    
    tabRes = [	nan(size(all.tab,1),5),...
                all.mean_perf,   all.mean_dprime,...
               	all.mean_sacLat, all.var_sacLat, ...
               	all.mean_sacAmp, all.var_sacAmp,...
               	all.mean_sacErr, all.var_sacErr,... 
               	all.num,         all.med_rt]; %nan(size(all.tab,1),1)];
    tabRes(1:size(all.tab,1),1:size(all.tab,2)) = all.tab;
    csvwrite(sprintf('../Extract/%s_Extr_%s.csv',sub.ini,exType),tabRes);
end
end

%% E2  : Split SAC-Match --------------------------------------------------
%  E2a : all
%  E2b : split contr 

% col#01 = split1: SAC-Match (0 = no saccade, 1 = towards, 2 = away)
% col#02 = split2: NaN / Contrast steps (1-6)
% col#03 = split3: NaN
% col#04 = split4: NaN
% col#05 = split5: NaN
% col#06 = performance (% corr)
% col#07 = performance (dprime)
% col#08 = saccade latency (ms)
% col#09 = saccade latency variance
% col#10 = saccade amplitude (deg)
% col#11 = saccade amplitude variance
% col#12 = saccade error (deg)
% col#13 = saccade error variance
% col#14 = number of trials
% col#15 = NaN

if ex2
dataFile = fileRes;

for idxE = 1:thresteps

    all.tab=[];         all.num=[];
    all.mean_perf=[];   all.mean_dprime=[];
    all.mean_sacLat=[]; all.var_sacLat=[];
    all.mean_sacAmp=[]; all.var_sacAmp=[];
    all.mean_sacErr=[]; all.var_sacErr=[];
    all.med_rt=[];
    
    switch idxE
        case 1; c_col = col77;      exType = 'E2a';
        case 2; c_col = contr_col;  exType = 'E2b';
    end
    
    for sMatch = unique(fileRes(:,sacMatch_col))'
        index.sMatch = dataFile(:,sacMatch_col) == sMatch;
    for contr = unique(fileRes(:,c_col))'
        index.contr = dataFile(:,c_col) == contr;
        
        allData         =   dataFile(index.sMatch & index.contr,:);
        val_perf        =   allData(:,res_col);
        val_sacLat      =   allData(:,sacLat_col);
        val_sacAmp      =   allData(:,sacAmp_col);
        val_sacErr      =   allData(:,sacErr_col);
        val_rt          =   allData(:,rt_col);
        
        if isempty(val_perf)
            mean_perf       =   NaN;
            mean_dprime     =   NaN;
            mean_sacLat     =   NaN;
            var_sacLat  	=   NaN;
            mean_sacAmp     =   NaN;
            var_sacAmp      =   NaN;
            mean_sacErr     =   NaN;
            var_sacErr      =   NaN;
            num             =   0;
            med_rt          =   NaN;
            tab             =   [sMatch,contr];
        else
            mean_perf       =   nanmean(val_perf);
            mean_dprime     =   dprime_HFA(nanmean(val_perf),2);
            mean_sacLat     =   nanmedian(val_sacLat);
            var_sacLat  	=   nanstd(val_sacLat);
            mean_sacAmp     =   nanmedian(val_sacAmp);
            var_sacAmp      =   nanstd(val_sacAmp);
            mean_sacErr     =   nanmedian(val_sacErr);
            var_sacErr      =   nanstd(val_sacErr);
            num             =   numel(val_perf);
            med_rt          =   abs(nanmedian(val_rt));
            tab             =   nanmean([allData(:,sacMatch_col),allData(:,c_col)],1);
        end
        
        all.tab             =   [all.tab;         	tab         ];
        all.mean_perf       =   [all.mean_perf;    	mean_perf   ];
        all.mean_dprime     =   [all.mean_dprime;  	mean_dprime ];
        all.mean_sacLat     =   [all.mean_sacLat;  	mean_sacLat ];
        all.var_sacLat      =   [all.var_sacLat;   	var_sacLat  ];
        all.mean_sacAmp     =   [all.mean_sacAmp;  	mean_sacAmp ];
        all.var_sacAmp      =   [all.var_sacAmp;  	var_sacAmp  ];
        all.mean_sacErr     =   [all.mean_sacErr;  	mean_sacErr ];
        all.var_sacErr      =   [all.var_sacErr;  	var_sacErr  ];
        all.num             =   [all.num;           num         ];
        all.med_rt          =   [all.med_rt;     	med_rt      ];
    end
    end
    
    tabRes = [	nan(size(all.tab,1),5),...
                all.mean_perf,   all.mean_dprime,...
               	all.mean_sacLat, all.var_sacLat, ...
               	all.mean_sacAmp, all.var_sacAmp,...
               	all.mean_sacErr, all.var_sacErr,... 
               	all.num,         all.med_rt]; %nan(size(all.tab,1),1)];
    tabRes(1:size(all.tab,1),1:size(all.tab,2)) = all.tab;
    csvwrite(sprintf('../Extract/%s_Extr_%s.csv',sub.ini,exType),tabRes);
end
end


%% E3  : Split TMS-Match --------------------------------------------------
%  E3a : all
%  E3b : split contr 

% col#01 = split1: TMS-Match (1 = targed stimulated, 2 = not stimulated)
% col#02 = split2: NaN / Contrast steps (1-6)
% col#03 = split3: NaN
% col#04 = split4: NaN
% col#05 = split5: NaN
% col#06 = performance (% corr)
% col#07 = performance (dprime)
% col#08 = saccade latency (ms)
% col#09 = saccade latency variance
% col#10 = saccade amplitude (deg)
% col#11 = saccade amplitude variance
% col#12 = saccade error (deg)
% col#13 = saccade error variance
% col#14 = number of trials
% col#15 = NaN

if ex3
dataFile = fileRes;

for idxE = 1:thresteps

    all.tab=[];         all.num=[];
    all.mean_perf=[];   all.mean_dprime=[];
    all.mean_sacLat=[]; all.var_sacLat=[];
    all.mean_sacAmp=[]; all.var_sacAmp=[];
    all.mean_sacErr=[]; all.var_sacErr=[];
    all.med_rt=[];
    
    switch idxE
        case 1; c_col = col77;      exType = 'E3a';
        case 2; c_col = contr_col;  exType = 'E3b';
    end
    
    for tmsMatch = unique(fileRes(:,tmsMatch_col))'
        index.tmsMatch = dataFile(:,tmsMatch_col) == tmsMatch;
    for contr = unique(fileRes(:,c_col))'
        index.contr = dataFile(:,c_col) == contr;
        
        allData         =   dataFile(index.tmsMatch & index.contr,:);
        val_perf        =   allData(:,res_col);
        val_sacLat      =   allData(:,sacLat_col);
        val_sacAmp      =   allData(:,sacAmp_col);
        val_sacErr      =   allData(:,sacErr_col);
        val_rt          =   allData(:,rt_col);
        
        if isempty(val_perf)
            mean_perf       =   NaN;
            mean_dprime     =   NaN;
            mean_sacLat     =   NaN;
            var_sacLat  	=   NaN;
            mean_sacAmp     =   NaN;
            var_sacAmp      =   NaN;
            mean_sacErr     =   NaN;
            var_sacErr      =   NaN;
            num             =   0;
            med_rt          =   NaN;
            tab             =   [tmsMatch,contr];
        else
            mean_perf       =   nanmean(val_perf);
            mean_dprime     =   dprime_HFA(nanmean(val_perf),2);
            mean_sacLat     =   nanmedian(val_sacLat);
            var_sacLat  	=   nanstd(val_sacLat);
            mean_sacAmp     =   nanmedian(val_sacAmp);
            var_sacAmp      =   nanstd(val_sacAmp);
            mean_sacErr     =   nanmedian(val_sacErr);
            var_sacErr      =   nanstd(val_sacErr);
            num             =   numel(val_perf);
            med_rt          =   abs(nanmedian(val_rt));
            tab             =   nanmean([allData(:,tmsMatch_col),allData(:,c_col)],1);
        end
        
        all.tab             =   [all.tab;         	tab         ];
        all.mean_perf       =   [all.mean_perf;    	mean_perf   ];
        all.mean_dprime     =   [all.mean_dprime;  	mean_dprime ];
        all.mean_sacLat     =   [all.mean_sacLat;  	mean_sacLat ];
        all.var_sacLat      =   [all.var_sacLat;   	var_sacLat  ];
        all.mean_sacAmp     =   [all.mean_sacAmp;  	mean_sacAmp ];
        all.var_sacAmp      =   [all.var_sacAmp;  	var_sacAmp  ];
        all.mean_sacErr     =   [all.mean_sacErr;  	mean_sacErr ];
        all.var_sacErr      =   [all.var_sacErr;  	var_sacErr  ];
        all.num             =   [all.num;           num         ];
        all.med_rt          =   [all.med_rt;     	med_rt      ];
    end
    end
    
    tabRes = [	nan(size(all.tab,1),5),...
                all.mean_perf,   all.mean_dprime,...
               	all.mean_sacLat, all.var_sacLat, ...
               	all.mean_sacAmp, all.var_sacAmp,...
               	all.mean_sacErr, all.var_sacErr,... 
               	all.num,         all.med_rt]; %nan(size(all.tab,1),1)];
    tabRes(1:size(all.tab,1),1:size(all.tab,2)) = all.tab;
    csvwrite(sprintf('../Extract/%s_Extr_%s.csv',sub.ini,exType),tabRes);
end
end


for idx_time = 1:2

    switch idx_time
        case 1; t_addTxt = '';          tVals = unique(fileRes(:,tmsTime_col))';
        case 2; t_addTxt = '_rel';      tVals = [1:size(binVec,2)+1];
    end
    
%% E4  : Split TMS-Match & TMS time ---------------------------------------
%  E4a : all
%  E4b : split contr 

% col#01 = split1: TMS-Match (1 = targed stimulated, 2 = not stimulated)
% col#02 = split2: TMS time (pulse 1=0, 2=50, 3=100, 4=150, 5=200, NaN=noTMS)
% col#03 = split3: NaN / Contrast steps (1-6)
% col#04 = split4: NaN
% col#05 = split5: NaN
% col#06 = performance (% corr)
% col#07 = performance (dprime)
% col#08 = saccade latency (ms)
% col#09 = saccade latency variance
% col#10 = saccade amplitude (deg)
% col#11 = saccade amplitude variance
% col#12 = saccade error (deg)
% col#13 = saccade error variance
% col#14 = number of trials
% col#15 = NaN

if ex4
dataFile = fileRes;

for idxE = 1:thresteps

    all.tab=[];         all.num=[];
    all.mean_perf=[];   all.mean_dprime=[];
    all.mean_sacLat=[]; all.var_sacLat=[];
    all.mean_sacAmp=[]; all.var_sacAmp=[];
    all.mean_sacErr=[]; all.var_sacErr=[];
    all.med_rt=[];
    
    switch idxE
        case 1; c_col = col77;      exType = sprintf('E4a%s',t_addTxt);
        case 2; c_col = contr_col;  exType = sprintf('E4b%s',t_addTxt);
    end
    
    for tmsMatch = unique(fileRes(:,tmsMatch_col))'
        index.tmsMatch = dataFile(:,tmsMatch_col) == tmsMatch;
    for tmsTime = tVals
        switch idx_time
            case 1; timeCol_curr = tmsTime_col;
            case 2; timeCol_curr = tmsTime2SacBIN_col+tmsTime;
        end
        index.tmsTime = dataFile(:,timeCol_curr) == tmsTime;
    for contr = unique(fileRes(:,c_col))'
        index.contr = dataFile(:,c_col) == contr;
        
        allData         =   dataFile(index.tmsMatch & index.tmsTime & index.contr,:);
        val_perf        =   allData(:,res_col);
        val_sacLat      =   allData(:,sacLat_col);
        val_sacAmp      =   allData(:,sacAmp_col);
        val_sacErr      =   allData(:,sacErr_col);
        val_rt          =   allData(:,rt_col);
        
        if isempty(val_perf)
            mean_perf       =   NaN;
            mean_dprime     =   NaN;
            mean_sacLat     =   NaN;
            var_sacLat  	=   NaN;
            mean_sacAmp     =   NaN;
            var_sacAmp      =   NaN;
            mean_sacErr     =   NaN;
            var_sacErr      =   NaN;
            num             =   0;
            med_rt          =   NaN;
            tab             =   [tmsMatch,tmsTime,contr];
        else
            mean_perf       =   nanmean(val_perf);
            mean_dprime     =   dprime_HFA(nanmean(val_perf),2);
            mean_sacLat     =   nanmedian(val_sacLat);
            var_sacLat  	=   nanstd(val_sacLat);
            mean_sacAmp     =   nanmedian(val_sacAmp);
            var_sacAmp      =   nanstd(val_sacAmp);
            mean_sacErr     =   nanmedian(val_sacErr);
            var_sacErr      =   nanstd(val_sacErr);
            num             =   numel(val_perf);
            med_rt          =   abs(nanmedian(val_rt));
            tab             =   nanmean([allData(:,tmsMatch_col),allData(:,timeCol_curr),allData(:,c_col)],1);
        end
        
        all.tab             =   [all.tab;         	tab         ];
        all.mean_perf       =   [all.mean_perf;    	mean_perf   ];
        all.mean_dprime     =   [all.mean_dprime;  	mean_dprime ];
        all.mean_sacLat     =   [all.mean_sacLat;  	mean_sacLat ];
        all.var_sacLat      =   [all.var_sacLat;   	var_sacLat  ];
        all.mean_sacAmp     =   [all.mean_sacAmp;  	mean_sacAmp ];
        all.var_sacAmp      =   [all.var_sacAmp;  	var_sacAmp  ];
        all.mean_sacErr     =   [all.mean_sacErr;  	mean_sacErr ];
        all.var_sacErr      =   [all.var_sacErr;  	var_sacErr  ];
        all.num             =   [all.num;           num         ];
        all.med_rt          =   [all.med_rt;     	med_rt      ];
    end
    end
    end
    
    tabRes = [	nan(size(all.tab,1),5),...
                all.mean_perf,   all.mean_dprime,...
               	all.mean_sacLat, all.var_sacLat, ...
               	all.mean_sacAmp, all.var_sacAmp,...
               	all.mean_sacErr, all.var_sacErr,... 
               	all.num,         all.med_rt]; %nan(size(all.tab,1),1)];
    tabRes(1:size(all.tab,1),1:size(all.tab,2)) = all.tab;
    csvwrite(sprintf('../Extract/%s_Extr_%s.csv',sub.ini,exType),tabRes);
end
end


%% E5  : Split SAC-Match & TMS time --------------------------------------
%  E5a : all
%  E5b : split contr 

% col#01 = split1: SAC-Match (0 = no saccade, 1 = towards, 2 = away)
% col#02 = split2: TMS time (pulse 1=0, 2=50, 3=100, 4=150, 5=200, NaN=noTMS)
% col#03 = split3: NaN / Contrast steps (1-6)
% col#04 = split4: NaN
% col#05 = split5: NaN
% col#06 = performance (% corr)
% col#07 = performance (dprime)
% col#08 = saccade latency (ms)
% col#09 = saccade latency variance
% col#10 = saccade amplitude (deg)
% col#11 = saccade amplitude variance
% col#12 = saccade error (deg)
% col#13 = saccade error variance
% col#14 = number of trials
% col#15 = NaN

if ex5
dataFile = fileRes;

for idxE = 1:thresteps

    all.tab=[];         all.num=[];
    all.mean_perf=[];   all.mean_dprime=[];
    all.mean_sacLat=[]; all.var_sacLat=[];
    all.mean_sacAmp=[]; all.var_sacAmp=[];
    all.mean_sacErr=[]; all.var_sacErr=[];
    all.med_rt=[];
    
    switch idxE
        case 1; c_col = col77;      exType = sprintf('E5a%s',t_addTxt);
        case 2; c_col = contr_col;  exType = sprintf('E5b%s',t_addTxt);
    end

    for sMatch = unique(fileRes(:,sacMatch_col))'
        index.sMatch = dataFile(:,sacMatch_col) == sMatch;     
    for tmsTime = tVals
        switch idx_time
            case 1; timeCol_curr = tmsTime_col;
            case 2; timeCol_curr = tmsTime2SacBIN_col+tmsTime;
        end
        index.tmsTime = dataFile(:,timeCol_curr) == tmsTime;     
    for contr = unique(fileRes(:,c_col))'
        index.contr = dataFile(:,c_col) == contr;
        
        allData         =   dataFile(index.sMatch & index.tmsTime & index.contr,:);
        val_perf        =   allData(:,res_col);
        val_sacLat      =   allData(:,sacLat_col);
        val_sacAmp      =   allData(:,sacAmp_col);
        val_sacErr      =   allData(:,sacErr_col);
        val_rt          =   allData(:,rt_col);
        
        if isempty(val_perf)
            mean_perf       =   NaN;
            mean_dprime     =   NaN;
            mean_sacLat     =   NaN;
            var_sacLat  	=   NaN;
            mean_sacAmp     =   NaN;
            var_sacAmp      =   NaN;
            mean_sacErr     =   NaN;
            var_sacErr      =   NaN;
            num             =   0;
            med_rt          =   NaN;
            tab             =   [sMatch,tmsTime,contr];
        else
            mean_perf       =   nanmean(val_perf);
            mean_dprime     =   dprime_HFA(nanmean(val_perf),2);
            mean_sacLat     =   nanmedian(val_sacLat);
            var_sacLat  	=   nanstd(val_sacLat);
            mean_sacAmp     =   nanmedian(val_sacAmp);
            var_sacAmp      =   nanstd(val_sacAmp);
            mean_sacErr     =   nanmedian(val_sacErr);
            var_sacErr      =   nanstd(val_sacErr);
            num             =   numel(val_perf);
            med_rt          =   abs(nanmedian(val_rt));
            tab             =   nanmean([allData(:,sacMatch_col),allData(:,timeCol_curr),allData(:,c_col)],1);
        end
        
        all.tab             =   [all.tab;         	tab         ];
        all.mean_perf       =   [all.mean_perf;    	mean_perf   ];
        all.mean_dprime     =   [all.mean_dprime;  	mean_dprime ];
        all.mean_sacLat     =   [all.mean_sacLat;  	mean_sacLat ];
        all.var_sacLat      =   [all.var_sacLat;   	var_sacLat  ];
        all.mean_sacAmp     =   [all.mean_sacAmp;  	mean_sacAmp ];
        all.var_sacAmp      =   [all.var_sacAmp;  	var_sacAmp  ];
        all.mean_sacErr     =   [all.mean_sacErr;  	mean_sacErr ];
        all.var_sacErr      =   [all.var_sacErr;  	var_sacErr  ];
        all.num             =   [all.num;           num         ];
        all.med_rt          =   [all.med_rt;     	med_rt      ];
    end
    end
    end
    
    tabRes = [	nan(size(all.tab,1),5),...
                all.mean_perf,   all.mean_dprime,...
               	all.mean_sacLat, all.var_sacLat, ...
               	all.mean_sacAmp, all.var_sacAmp,...
               	all.mean_sacErr, all.var_sacErr,... 
               	all.num,         all.med_rt]; %nan(size(all.tab,1),1)];
    tabRes(1:size(all.tab,1),1:size(all.tab,2)) = all.tab;
    csvwrite(sprintf('../Extract/%s_Extr_%s.csv',sub.ini,exType),tabRes);
end
end


%% E6  : Split SAC-Match & TMS-Match & TMS time ---------------------------
%  E6a : all
%  E6b : split contr 

% col#01 = split1: SAC-Match (0 = no saccade, 1 = towards, 2 = away)
% col#02 = split2: TMS-Match (1 = targed stimulated, 2 = not stimulated)
% col#03 = split3: TMS time (pulse 1=0, 2=50, 3=100, 4=150, 5=200, NaN=noTMS)
% col#04 = split4: NaN / Contrast steps (1-6)
% col#05 = split5: NaN
% col#06 = performance (% corr)
% col#07 = performance (dprime)
% col#08 = saccade latency (ms)
% col#09 = saccade latency variance
% col#10 = saccade amplitude (deg)
% col#11 = saccade amplitude variance
% col#12 = saccade error (deg)
% col#13 = saccade error variance
% col#14 = number of trials
% col#15 = NaN

if ex6
dataFile = fileRes;

for idxE = 1:thresteps

    all.tab=[];         all.num=[];
    all.mean_perf=[];   all.mean_dprime=[];
    all.mean_sacLat=[]; all.var_sacLat=[];
    all.mean_sacAmp=[]; all.var_sacAmp=[];
    all.mean_sacErr=[]; all.var_sacErr=[];
    all.med_rt=[];
    
    switch idxE
        case 1; c_col = col77;      exType = sprintf('E6a%s',t_addTxt);
        case 2; c_col = contr_col;  exType = sprintf('E6b%s',t_addTxt);
    end

    for sMatch = unique(fileRes(:,sacMatch_col))'
        index.sMatch = dataFile(:,sacMatch_col) == sMatch;     
    for tmsMatch = unique(fileRes(:,tmsMatch_col))'
        index.tmsMatch = dataFile(:,tmsMatch_col) == tmsMatch;  
    for tmsTime = tVals
        switch idx_time
            case 1; timeCol_curr = tmsTime_col;
            case 2; timeCol_curr = tmsTime2SacBIN_col+tmsTime;
        end
        index.tmsTime = dataFile(:,timeCol_curr) == tmsTime;
    for contr = unique(fileRes(:,c_col))'
        index.contr = dataFile(:,c_col) == contr;
        
        allData         =   dataFile(index.sMatch & index.tmsMatch & index.tmsTime & index.contr,:);
        val_perf        =   allData(:,res_col);
        val_sacLat      =   allData(:,sacLat_col);
        val_sacAmp      =   allData(:,sacAmp_col);
        val_sacErr      =   allData(:,sacErr_col);
        val_rt          =   allData(:,rt_col);
        
        if isempty(val_perf)
            mean_perf       =   NaN;
            mean_dprime     =   NaN;
            mean_sacLat     =   NaN;
            var_sacLat  	=   NaN;
            mean_sacAmp     =   NaN;
            var_sacAmp      =   NaN;
            mean_sacErr     =   NaN;
            var_sacErr      =   NaN;
            num             =   0;
            med_rt          =   NaN;
            tab             =   [sMatch,tmsMatch,tmsTime,contr];
        else
            mean_perf       =   nanmean(val_perf);
            mean_dprime     =   dprime_HFA(nanmean(val_perf),2);
            mean_sacLat     =   nanmedian(val_sacLat);
            var_sacLat  	=   nanstd(val_sacLat);
            mean_sacAmp     =   nanmedian(val_sacAmp);
            var_sacAmp      =   nanstd(val_sacAmp);
            mean_sacErr     =   nanmedian(val_sacErr);
            var_sacErr      =   nanstd(val_sacErr);
            num             =   numel(val_perf);
            med_rt          =   abs(nanmedian(val_rt));
            tab             =   nanmean([allData(:,sacMatch_col),allData(:,tmsMatch_col),allData(:,timeCol_curr),allData(:,c_col)],1);
        end
        
        all.tab             =   [all.tab;         	tab         ];
        all.mean_perf       =   [all.mean_perf;    	mean_perf   ];
        all.mean_dprime     =   [all.mean_dprime;  	mean_dprime ];
        all.mean_sacLat     =   [all.mean_sacLat;  	mean_sacLat ];
        all.var_sacLat      =   [all.var_sacLat;   	var_sacLat  ];
        all.mean_sacAmp     =   [all.mean_sacAmp;  	mean_sacAmp ];
        all.var_sacAmp      =   [all.var_sacAmp;  	var_sacAmp  ];
        all.mean_sacErr     =   [all.mean_sacErr;  	mean_sacErr ];
        all.var_sacErr      =   [all.var_sacErr;  	var_sacErr  ];
        all.num             =   [all.num;           num         ];
        all.med_rt          =   [all.med_rt;     	med_rt      ];
    end
    end
    end
    end
    
    tabRes = [	nan(size(all.tab,1),5),...
                all.mean_perf,   all.mean_dprime,...
               	all.mean_sacLat, all.var_sacLat, ...
               	all.mean_sacAmp, all.var_sacAmp,...
               	all.mean_sacErr, all.var_sacErr,... 
               	all.num,         all.med_rt]; %nan(size(all.tab,1),1)];
    tabRes(1:size(all.tab,1),1:size(all.tab,2)) = all.tab;
    csvwrite(sprintf('../Extract/%s_Extr_%s.csv',sub.ini,exType),tabRes);
end
end


%% E7  : Split tmssac-Match & TMS time --------------------------------------
%  E7a : all
%  E7b : split contr 

% col#01 = split1: tmssac-Match (0 = no saccade, 1 = towardsTMS, 2 = away)
% col#02 = split2: TMS time (pulse 1=0, 2=50, 3=100, 4=150, 5=200, NaN=noTMS)
% col#03 = split3: NaN / Contrast steps (1-6)
% col#04 = split4: NaN
% col#05 = split5: NaN
% col#06 = performance (% corr)
% col#07 = performance (dprime)
% col#08 = saccade latency (ms)
% col#09 = saccade latency variance
% col#10 = saccade amplitude (deg)
% col#11 = saccade amplitude variance
% col#12 = saccade error (deg)
% col#13 = saccade error variance
% col#14 = number of trials
% col#15 = NaN

if ex7
dataFile = fileRes;

for idxE = 1:thresteps

    all.tab=[];         all.num=[];
    all.mean_perf=[];   all.mean_dprime=[];
    all.mean_sacLat=[]; all.var_sacLat=[];
    all.mean_sacAmp=[]; all.var_sacAmp=[];
    all.mean_sacErr=[]; all.var_sacErr=[];
    all.med_rt=[];
    
    switch idxE
        case 1; c_col = col77;      exType = sprintf('E7a%s',t_addTxt);
        case 2; c_col = contr_col;  exType = sprintf('E7b%s',t_addTxt);
    end

    for tsMatch = unique(fileRes(:,tmssacMatch_col))'
        index.tsMatch = dataFile(:,tmssacMatch_col) == tsMatch;     
    for tmsTime = tVals
        switch idx_time
            case 1; timeCol_curr = tmsTime_col;
            case 2; timeCol_curr = tmsTime2SacBIN_col+tmsTime;
        end
        index.tmsTime = dataFile(:,timeCol_curr) == tmsTime;     
    for contr = unique(fileRes(:,c_col))'
        index.contr = dataFile(:,c_col) == contr;
        
        allData         =   dataFile(index.tsMatch & index.tmsTime & index.contr,:);
        val_perf        =   allData(:,res_col);
        val_sacLat      =   allData(:,sacLat_col);
        val_sacAmp      =   allData(:,sacAmp_col);
        val_sacErr      =   allData(:,sacErr_col);
        val_rt          =   allData(:,rt_col);
        
        if isempty(val_perf)
            mean_perf       =   NaN;
            mean_dprime     =   NaN;
            mean_sacLat     =   NaN;
            var_sacLat  	=   NaN;
            mean_sacAmp     =   NaN;
            var_sacAmp      =   NaN;
            mean_sacErr     =   NaN;
            var_sacErr      =   NaN;
            num             =   0;
            med_rt          =   NaN;
            tab             =   [tsMatch,tmsTime,contr];
        else
            mean_perf       =   nanmean(val_perf);
            mean_dprime     =   dprime_HFA(nanmean(val_perf),2);
            mean_sacLat     =   nanmedian(val_sacLat);
            var_sacLat  	=   nanstd(val_sacLat);
            mean_sacAmp     =   nanmedian(val_sacAmp);
            var_sacAmp      =   nanstd(val_sacAmp);
            mean_sacErr     =   nanmedian(val_sacErr);
            var_sacErr      =   nanstd(val_sacErr);
            num             =   numel(val_perf);
            med_rt          =   abs(nanmedian(val_rt));
            tab             =   nanmean([allData(:,tmssacMatch_col),allData(:,timeCol_curr),allData(:,c_col)],1);
        end
        
        all.tab             =   [all.tab;         	tab         ];
        all.mean_perf       =   [all.mean_perf;    	mean_perf   ];
        all.mean_dprime     =   [all.mean_dprime;  	mean_dprime ];
        all.mean_sacLat     =   [all.mean_sacLat;  	mean_sacLat ];
        all.var_sacLat      =   [all.var_sacLat;   	var_sacLat  ];
        all.mean_sacAmp     =   [all.mean_sacAmp;  	mean_sacAmp ];
        all.var_sacAmp      =   [all.var_sacAmp;  	var_sacAmp  ];
        all.mean_sacErr     =   [all.mean_sacErr;  	mean_sacErr ];
        all.var_sacErr      =   [all.var_sacErr;  	var_sacErr  ];
        all.num             =   [all.num;           num         ];
        all.med_rt          =   [all.med_rt;     	med_rt      ];
    end
    end
    end
    
    tabRes = [	nan(size(all.tab,1),5),...
                all.mean_perf,   all.mean_dprime,...
               	all.mean_sacLat, all.var_sacLat, ...
               	all.mean_sacAmp, all.var_sacAmp,...
               	all.mean_sacErr, all.var_sacErr,... 
               	all.num,         all.med_rt]; %nan(size(all.tab,1),1)];
    tabRes(1:size(all.tab,1),1:size(all.tab,2)) = all.tab;
    csvwrite(sprintf('../Extract/%s_Extr_%s.csv',sub.ini,exType),tabRes);
end
end


end


end