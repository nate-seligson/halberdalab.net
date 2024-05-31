function dprime = detect2dprime(tPres,tResp)
% ----------------------------------------------------------------------
% dprime = detect2dprime(tPres,tResp)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute dprime for a detection task using Signal Detection Theory 
% principle (dprime = hit_rate - fa_rate)
% ----------------------------------------------------------------------
% Input(s) :
% tPres : matrix containing detection target present/absent information
% tResp : matrix containing present/absent response
% ----------------------------------------------------------------------
% Output(s):
% dprime : dprime
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last update : 09 / 05 / 2020
% Project : PreSacRes
% Version : 10.0
% ----------------------------------------------------------------------

hit_rate = sum(tPres==1 & tResp==1) / sum(tPres==1);
fa_rate = sum(tPres==0 & tResp==1) / sum(tPres==0);

% avoid infinite dprime values
if hit_rate == 1; hit_rate = 0.99;
elseif hit_rate == 0; hit_rate = 0.01;
end
if fa_rate == 1; fa_rate = 0.99;
elseif fa_rate == 0; fa_rate = 0.01;
end

dprime = (norminv(hit_rate)-norminv(fa_rate));

end