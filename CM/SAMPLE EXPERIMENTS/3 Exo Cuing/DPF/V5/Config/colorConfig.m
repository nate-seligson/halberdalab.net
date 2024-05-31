function [scr,const]=colorConfig(scr,const)
% ----------------------------------------------------------------------
% [scr,const]=colorConfig(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Color settings
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containg previous constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% scr : window pointer
% const : struct containing all constant data.
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

% Color
scr.black           = BlackIndex(scr.scr_num);
scr.white           = WhiteIndex(scr.scr_num);
scr.gray            = GrayIndex(scr.scr_num);
const.red20         = [200   0   0];
const.gray          = [100 100 100];
const.orange        = [255,150,  0];

% Stim color
const.colViewEL  	= const.gray;
const.colBG      	= scr.gray;
const.colWaitSpace	= scr.black;

const.colFix        = scr.black;
const.colErrFix   	= const.red20;

const.colDots       = scr.black;

const.colText    	= scr.black;
const.colCue        = [255,255,255];

const.white         = [255,255,255];
const.colRespCue    = [255,255,255];

end