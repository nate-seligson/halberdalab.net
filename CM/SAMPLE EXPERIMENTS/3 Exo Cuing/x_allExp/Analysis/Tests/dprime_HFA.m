function d = dprime_HFA(p,nChoice)
% ----------------------------------------------------------------------
% d = dprime_HFA(p,nResp)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute dprime for a 4AFC task using "Hit - FalseAlarms" principle
% (Signal Detection Thery: dprime = Hit-FA)
% - HIT rate = Percentage of correct responses
% - FALSE ALARM rate = Percentage of incorrect responses devided by 
%   number of possible incorrect respose options (3 in 4AFC)
% ----------------------------------------------------------------------
% Input(s) :
% p : performance (% correct)
% nChoice : how many choices in discrimination task (e.g. 4 for 4AFC)
% ----------------------------------------------------------------------
% Output(s):
% d : dprime
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last update : 04 / 07 / 2016
% Project :     StimTest
% Version :     1.0
% ----------------------------------------------------------------------

% avoid infinite dprime values
if p == 1; p = 0.99;
elseif p == 0; p = 0.01;
end

pCorr   = p;                 % performance (%correct) == Hit rate
pIncorr = (1-p)/(nChoice-1); % performance (%incorrect) == False Alarm rate

d = (norminv(pCorr)-norminv(pIncorr));

end