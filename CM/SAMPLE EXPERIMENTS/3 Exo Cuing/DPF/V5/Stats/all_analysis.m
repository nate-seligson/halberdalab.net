function all_analysis(subIni,domEye,expName,taskType,nbBlocks,eyeAnalysis)
% ----------------------------------------------------------------------
% all_analysis(subIni,domEye,expName,taskType,nbBlocks,eyeAnalysis)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute automaticaly results and draw curves and graphs.
% ----------------------------------------------------------------------
% Input(s) :
% subIni : subject initial
% domEye : dominant eye
% expName : experiment name
% taskType : task type
% nbBlocks : blocks to include in analysis
% eyeAnalysis : run eye movement analysis (1) or not (0)
%
% e.g. all_analysis('CM','R','DPF','Main',[1:6],1)
%
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
close all; warning ('off','all');

dirF = (which('all_analysis'));
dirD = [dirF(1:end-21),sprintf('/Data/%s_%s_data/%s_data',subIni,expName,taskType)];
cd(dirD);

addpath(genpath('../../../Stats/'));

sub.ini      	=   subIni;
sub.domEye    	=   domEye;
sub.expName   	=   expName;
sub.taskType  	=   taskType;
sub.nbBlocks    =   nbBlocks;


%% Eye tracking analysis
eyeAna_bl = [];
if eyeAnalysis
        
    edf2asc = '/Applications/Eyelink/EDF_Access_API/Example/edf2asc';

    for rep = sub.nbBlocks
        
        sub.block = rep;
        dirB = sprintf('%s/Block%i',dirD,sub.block);
        cd(dirB);
        addpath('../../../../Conversion/');
        
        eyeAna_bl = [eyeAna_bl,rep];

        
        %% Data conversion (edf2asc)
        [~,~] = system([edf2asc,' ', sprintf('%s_B%i',sub.ini,sub.block),'.edf -e -y']);
        movefile(sprintf('%s_B%i.asc',sub.ini,sub.block), sprintf('%s_B%i.msg',sub.ini,sub.block));
        [~,~] = system([edf2asc,' ', sprintf('%s_B%i',sub.ini,sub.block),'.edf -s -miss -1.0 -y']);
        movefile(sprintf('%s_B%i.asc',sub.ini,sub.block), sprintf('%s_B%i.dat',sub.ini,sub.block));

        
        %% Data extraction
        load(sprintf('scr_file%s_%s_%s.mat',sub.ini,sub.expName,sub.domEye));
        load(sprintf('const_file%s_%s_%s.mat',sub.ini,sub.expName,sub.domEye));
        
        eyeana_tab(sub);

        % Settings
        [eyeana] = eyeana_config(scr,const);

        % Fixation / saccade analysis
        [scr,const,eyeana] = eyeana_main(sub,scr,const,eyeana);
        
        % Delete / move files
        delete(sprintf('%s_B%i.msg',sub.ini,sub.block));
        delete(sprintf('%s_B%i.dat',sub.ini,sub.block));
        
        if ~isdir('../AllB');mkdir('../AllB');end;cd('../AllB');
    end
    
    if ~isempty(eyeAna_bl)
        save(sprintf('%s_scr.mat',subIni),'scr')
        save(sprintf('%s_const.mat',subIni),'const')
        save(sprintf('%s_anaEye.mat',subIni),'eyeana')
        save(sprintf('%s_sub.mat',subIni),'sub')
    else
        cd('../AllB');
    end
    
    % Collapse files
    add_file(sub);
    
    % Trial distribution
    %eyeana_trialstats(sub,const);

else
    dirF = (which('all_analysis')); dirF =dirF(1:end-20);cd([dirF,'Data/']);
    cdDir = sprintf('%s_%s_data/%s_data/AllB/',sub.ini,expName,sub.taskType);
    cd(cdDir);
    addpath(genpath('../../../../Stats/'));
    addpath('../../../../Conversion/');
    load(sprintf('%s_const.mat',subIni))
    load(sprintf('%s_scr.mat',subIni))
end


%% Extracting and plotting data

extractor(sub);

if drawFig
    % Draw bar and line plots
    draw_resMain_final(sub);
end
end