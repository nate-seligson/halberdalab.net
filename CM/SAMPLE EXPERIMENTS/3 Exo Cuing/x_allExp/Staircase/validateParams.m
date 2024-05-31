%% validateParams
function stairParams = validateParams(stairParams)


if ~isfield(stairParams,'alphaRange'),        stairParams.alphaRange = 0.01:0.01:1; end
if ~isfield(stairParams,'xMin'),              stairParams.xMin = 0;end                      %%?
if ~isfield(stairParams,'xMax'),              stairParams.xMax = 1;end                      %%?
if ~isfield(stairParams,'fitBeta'),           stairParams.fitBeta = 2; end
if ~isfield(stairParams,'fitGamma'),          stairParams.fitGamma = 0.5; end
if ~isfield(stairParams,'fitLambda'),         stairParams.fitLambda = 0.01;end
if ~isfield(stairParams,'lastPosterior'),     stairParams.lastPosterior = [];end
if ~isfield(stairParams,'threshPerformance'), stairParams.threshPerformance = []; end
if ~isfield(stairParams,'updateAfterTrial'),  stairParams.updateAfterTrial = 0; end

if ismember(stairParams.whichStair,[1 2])
    if stairParams.whichStair==2
        % check for mean and sd input of prior
        questInput = {'questMean' 'questSD'};
        questDefault = {'stairParams.alphaRange(round(length(stairParams.alphaRange)/2))' '1'};
        idx = ismember(questInput,setParams);
        if any(idx)
            % check if values are empty
            questVal = {stairParams.(questInput{1}) ...
                stairParams.(questInput{2})};
            emptyIdx = find(cellfun('isempty',questVal));
            if ~all(isnumeric([stairParams.questMean stairParams.questSD])) ...
                    && isempty(emptyIdx)
                % check that values inputted are numbers
                error('QUEST: mean and standard deviation should be numbers');
            else
                % set empty values to the default
                for q = 1:length(emptyIdx)
                    fprintf(['Setting ',questInput{emptyIdx(q)}, ' to ',...
                        questDefault{emptyIdx(q)}, ' (DEFAULT)\n']);
                    stairParams.(questInput{emptyIdx(q)}) = ...
                        eval(questDefault{emptyIdx(q)});
                end
            end
        else
            % set the empty or the non-set input to the
            % default
            fprintf(['Mean and SD of QUEST prior were not set. '...
                'Setting them to default.']);
            for q = 1:length(questInput)
                stairParams.(questInput{q}) = eval(questDefault{q});
            end
        end
    end
else
    stairParams.whichStair = 1;
    %     fprintf('whichStair: Setting to use best PEST (DEFAULT)\n');
end

if ~isfield(stairParams, 'preUpdateLevels')
    if stairParams.updateAfterTrial > 0
        stairParams.preUpdateLevels = repmat(median(stairParams.alphaRange),1,stairParams.updateAfterTrial);
    else
        stairParams.preUpdateLevels = [];
    end
elseif numel(stairParams.preUpdateLevels)~=stairParams.updateAfterTrial
    stairParams.preUpdateLevels = repmat(median(stairParams.alphaRange),1,stairParams.updateAfterTrial);
    error('# of pre-update levels need to match number of pre-update trials. Using default (median of alpha range)');
end
