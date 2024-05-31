%
%update_arbitrary_pf  Updates structure which contains settings for and 
%   results of running fit adaptive method. Based of PAL_ARMF_updateRF with
%   the added input of an expected threshold performance level
%   (threshPerformance).
%
%   syntax: RF = updateArbWeibull(RF, amplitude, response)
%
%   After having created a structure 'RF' using PAL_AMRF_setupRF, use 
%   something akin to the following loop to control stimulus intensity
%   during experimental run:
%
%   while ~RF.stop
%       
%       %Present trial here at stimulus magnitude in 'RF.xCurrent'
%       %and collect response (1: correct/greater than, 0: incorrect/
%       %smaller than)
%
%       RF = updateArbWeibull(RF, amplitude, response); %update RF 
%                                   %structure based on stimulus magnitude 
%                                   %and response                                    
%    
%   end
%
%
%Introduced: Palamedes version 1.0.0 (NP)
% Modified: Palamedes version 1.4.0, 1.6.3 (see History.m)
%
%
% ----------------------------------------------------------------------
% Function created by Michael Jigo
% Last update : 2020-12-03
% ----------------------------------------------------------------------

function RF = update_arbitrary_pf(RF, amplitude, response, threshPerformance)

trial = length(RF.response)+1;
RF.x(trial) = amplitude;
RF.response(trial) = response;

if trial == 1
    RF.xStaircase(trial) = RF.x(trial);
    if response == 1
        RF.direction = -1;        
    else
        RF.direction = 1;
    end
end

%% Update posterior distribution
% unpack parameter space for family of psychometric functions
params.alpha = RF.priorAlphaRange;
params.beta = RF.beta;
params.gamma = RF.gamma;
params.lambda = RF.lambda;

% evaluate probability of correct response at given stimulus amplitude for each psychometric function
p = RF.PF(params,amplitude,threshPerformance);

% update posterior probability distribution
if response == 1
    RF.pdf = RF.pdf.*p;
else
    RF.pdf = RF.pdf.*(1 - p);
end
RF.pdf = RF.pdf./sum(RF.pdf);

% obtain descriptive stats of posterior
[RF.mode, RF.mean, RF.sd] = PAL_AMRF_pdfDescriptives(RF.pdf, RF.priorAlphaRange);

% choose next contrast level
if strcmpi(RF.meanmode,'mean')
    if (RF.mean > RF.xCurrent && RF.direction == 1) || (RF.mean < RF.xCurrent && RF.direction == -1)
        RF.reversal(trial) = 0;
    end
    if RF.mean > RF.xCurrent && RF.direction == -1
        RF.reversal(trial) = sum(RF.reversal~=0) + 1;
        RF.direction = 1;
    end
    if RF.mean < RF.xCurrent && RF.direction == 1
        RF.reversal(trial) = sum(RF.reversal~=0) + 1;
        RF.direction = -1;
    end
    RF.xCurrent = RF.mean;
end
if strcmpi(RF.meanmode,'mode')
    if (RF.mode > RF.xCurrent && RF.direction == 1) || (RF.mode < RF.xCurrent && RF.direction == -1)
        RF.reversal(trial) = 0;
    end
    if RF.mode > RF.xCurrent && RF.direction == -1
        RF.reversal(trial) = sum(RF.reversal~=0) + 1;
        RF.direction = 1;
    end
    if RF.mode < RF.xCurrent && RF.direction == 1
        RF.reversal(trial) = sum(RF.reversal~=0) + 1;
        RF.direction = -1;
    end
    RF.xCurrent = RF.mode;
end

% add in functionality for delaying the update for a given number of trials
if isfield(RF,'updateAfterTrial')
   if numel(RF.x)<RF.updateAfterTrial
      % until the trial-update-threshold has been reached, continue presenting the custom contrast levels
      RF.xCurrent = RF.preUpdateLevels(numel(RF.x)+1);
   end
end

RF.xStaircase(trial+1) = RF.xCurrent;

if (strncmpi(RF.stopCriterion,'reversals',4) && sum(RF.reversal~=0) == RF.stopRule)||(strncmpi(RF.stopCriterion,'trials',4) && trial == RF.stopRule)
    RF.stop = 1;
    [RF.modeUniformPrior, RF.meanUniformPrior, RF.sdUniformPrior] = PAL_AMRF_pdfDescriptives(RF.pdf./RF.prior, RF.priorAlphaRange);
end
