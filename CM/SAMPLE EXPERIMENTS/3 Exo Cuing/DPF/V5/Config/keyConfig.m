function [my_key]=keyConfig
% ----------------------------------------------------------------------
% [my_key]=keyConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Return a structure containing all unified key names
% ----------------------------------------------------------------------
% Input(s) :
% const : experiment constants
% ----------------------------------------------------------------------
% Output(s):
% my_key : keyborad configuration
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

KbName('UnifyKeyNames');

my_key.escape   = KbName('Escape');
my_key.space   	= KbName('Space');

my_key.left     = KbName('LeftArrow');
my_key.right    = KbName('RightArrow');

end