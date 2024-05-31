function dprime = perf2dprime_2(allDat,currDat)
% ----------------------------------------------------------------------
% dprime = perf2dprime(pVal,testVal,respVal)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute dprime for a 2+AFC task using Signal Detection Thery principle
% dprime = Hit-FA
% ----------------------------------------------------------------------
% Input(s) :
% allDat : matrix containing [cuePos_col,tstPos_col,resp_col,res_col]
% combIdx :
% ----------------------------------------------------------------------
% Output(s):
% dprime : dprime
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last update : 05 / 05 / 2020
% Project :     PreSacRes
% Version :     9.0
% ----------------------------------------------------------------------
cuePos_col  = 1;
tstPos_col  = 2;
resp_col    = 3;

%currDat     = allDat(combIdx,:);

for i = unique(allDat(:,tstPos_col))' % for each test position

    currDat_pos = currDat(currDat(:,tstPos_col)==i,:);
    
    if isempty(currDat_pos)
        hit(i) = NaN;
        fa(i) = NaN;
    else
        currDat_pos_hits = currDat_pos(currDat_pos(:,3) == currDat_pos(:,2),:);
        
        % hit (resp_col==tstPos_col)
        hit(i) = size(currDat_pos_hits,1) / size(currDat_pos,1);
        
        % fa: only consider trials ...
        
        % 1) ...in which participant responded same eccentricity as in hits
        %    (i.e. hit response was in peripheri, also fa response should be in periphery)
        curr_respPos = unique(currDat_pos_hits(:,resp_col));
        idx_1 = sum(allDat(:,resp_col) == curr_respPos,2);
        
        % 2) ...with same cue&resp-match
        %    (i.e. if hit response was @cue, also fa response should be @cue)
        [curr_respcue,~,~] = unique(currDat_pos_hits(:,[cuePos_col,resp_col]), 'rows');
        for ii = 1:size(curr_respcue,1)
            idx_2(:,ii) = allDat(:,cuePos_col) == curr_respcue(ii,1) & allDat(:,resp_col) == curr_respcue(ii,2);
        end
        idx_2 = sum(idx_2,2);
        
        % 3) ...in which test is not at responded location (otherwise would be hit)
        idx_3 = allDat(:,tstPos_col) ~= allDat(:,resp_col);
        
        fa(i) = size( allDat(idx_1 & idx_2 & idx_3,:),1) / size(allDat(idx_1 & idx_2,:),1);
        
        
        % avoid infinite dprime values
        if hit(i) == 1; hit(i) = 0.99;
        elseif hit(i) == 0; hit(i) = 0.01;
        end
        if fa(i) == 1; fa(i) = 0.99;
        elseif fa(i) == 0; fa(i) = 0.01;
        end
        
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