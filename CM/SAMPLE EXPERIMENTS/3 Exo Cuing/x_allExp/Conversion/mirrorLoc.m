function newLoc = mirrorLoc(oldLoc,fixLoc)
% ----------------------------------------------------------------------
% mirrorLoc(oldLoc,fix,newLoc)
% ----------------------------------------------------------------------
% Goal of the function :
% Mirror a location.
% ----------------------------------------------------------------------
% Input(s) :
% oldLoc = location to be mirrored
% fixLoc = mirror fix location
% ----------------------------------------------------------------------
% Output(s):
% newLoc = new location (old Loc mirrored)
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last edit : 2021-01-26
% Project : -
% Version : -
% ----------------------------------------------------------------------

if ~min(size(oldLoc) ~= size(fixLoc))
    fixLoc = repmat(fixLoc,size(oldLoc));
end

newLoc = nan(size(oldLoc));
for i = 1:size(oldLoc,1)
    for ii = 1:size(oldLoc,2)
        if oldLoc(i,ii) > fixLoc(i,ii)
            newLoc(i,ii) = fixLoc(i,ii) - abs(oldLoc(i,ii)-fixLoc(i,ii));
        elseif oldLoc(i,ii) <= fixLoc(i,ii)
            newLoc(i,ii) = fixLoc(i,ii) + abs(oldLoc(i,ii)-fixLoc(i,ii));
        end
    end
end

end