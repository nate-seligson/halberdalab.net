function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const]=dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 3.0
% ----------------------------------------------------------------------

%% Directory
if ~isdir(sprintf('Data/%s_data',const.sjct_name))
    mkdir(sprintf('Data/%s_data',const.sjct_name));
    cd (sprintf('Data/%s_data',const.sjct_name));
else
    cd (sprintf('Data/%s_data',const.sjct_name));
end

if const.task == 1
    const.taskName = 'Train';
elseif const.task == 2
    const.taskName = 'Thre';
elseif const.task == 3
    const.taskName = 'Main';    
end
expDir = sprintf('%s_data/Block%i',const.taskName,const.fromBlock);
if ~isdir(expDir)
    mkdir(expDir);
    cd(expDir);
else
    try
        cd(expDir);
    catch
        mkdir(expDir);
        cd(expDir);
    end
end


%% Saving Files
const.scr_fileDat =         sprintf('scr_file%s.dat',const.sjct_code);
const.scr_fileMat =         sprintf('scr_file%s.mat',const.sjct_code);
const.aud_fileMat =         sprintf('aud_file%s.mat',const.sjct_code);
const.const_fileDat =       sprintf('const_file%s.dat',const.sjct_code);
const.const_fileMat =       sprintf('const_file%s.mat',const.sjct_code);
const.expRes_fileCsv =      sprintf('expRes%s.csv',const.sjct_code);
const.expRes_fileMat =      sprintf('expRes%s.mat',const.sjct_code);
const.design_fileDat =      sprintf('design%s.dat',const.sjct_code);
const.design_fileMat =      sprintf('design%s.mat',const.sjct_code);

addpath('../../../../Stim',...
        '../../../../Config',...
        '../../../../Main',...
        '../../../../Conversion',...
        '../../../../EyeTracking',...
        '../../../../Instructions',...
        '../../../../Trials',...
        '../../../../Stim',...
        '../../../../GammaCalib',...
        '../../../../Video');
addpath(genpath('../../../../Stats'));
end