function dprime = perf2dprime(pVal,testVal,respVal)
% ----------------------------------------------------------------------
% dprime = perf2dprime(pVal,testVal,respVal)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute dprime for a 2+AFC task using Signal Detection Thery principle
% dprime = Hit-FA
% ----------------------------------------------------------------------
% Input(s) :
% pVal : performance (% correct)
% testVal : actual test value
% respVal : responded value
% ----------------------------------------------------------------------
% Output(s):
% dprime : dprime
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last update : 28 / 04 / 2020
% Project :     PreSacRes
% Version :     9.0
% ----------------------------------------------------------------------

testresp = [testVal,respVal];

hit = nan(1,numel(unique(testVal)));
fa = nan(1,numel(unique(testVal)));
d = nan(1,numel(unique(testVal)));

for i = unique(testVal)'
    
    currTEST_mat = testresp(testVal==i,:);
    currRESP_mat = testresp(respVal==i,:);
    
    hit(i) = nansum(currTEST_mat(:,1) == currTEST_mat(:,2)) / size(currTEST_mat,1);
    fa(i) = nansum(currRESP_mat(:,1) ~= currRESP_mat(:,2)) / size(currRESP_mat,1);
    
    % avoid infinite dprime values
    if hit(i) == 1; hit(i) = 0.99;
    elseif hit(i) == 0; hit(i) = 0.01;
    end
    if fa(i) == 1; fa(i) = 0.99;
    elseif fa(i) == 0; fa(i) = 0.01;
    end
    
    
    d(i) = (norminv(hit(i))-norminv(fa(i)));
end

% allHit = nanmean(hit);
% allFa = nanmean(fa);
% alldprime = (norminv(allHit)-norminv(allFa));
% 
% dprime = [nanmean(d),alldprime];

dprime = nanmean(d);
end