% ----------------------------------------------------------------------
% [staircase, stairParams]=usePalamedesStaircase(stairParams,response)
% ----------------------------------------------------------------------
% Purpose:  Initialize and update adaptive method (best PEST or QUEST).
%           This function simply calls the Palamedes toolbox, but makes
%           it easier to set and change parameters.
%
%           If run without any input arguments, you will be asked to
%           input parameters.
%           e.g., [staircase stairParams] = usePalamedesStaircase;
%
%           Alternatively, you can create pass in a stairParams structure.
%           e.g., [staircase stairParams] = usePalamedesStaircase(stairParams);
%
%           If run with two inputs, the first input must be 'staircase'
%           (i.e., the output of initialization) and the second input must
%           be either 1 or 0 for correct and incorrect responses, respectively.
%           This will update the adaptive method.
%           e.g., staircase = usePalamedesStaircase(staircase,1);
%
% ----------------------------------------------------------------------
% Input(s)
% 1. stairParams: structure containing parameters (listed below) to control adaptive method
%     1. whichStair: 1=best PEST; 2=QUEST     (default=1)
%     2. alphaRange: vector of possible threshold stimulus values  (default=0.01:0.01:1)
%     3. fitBeta: slope of underlying psychometric function     (default=2)
%     4. fitLambda: lapse rate (i.e., 1-upper asymptote) of psychometric function (default=0.01)
%     5.  fitGamma: guess rate (i.e., lower asymptote) of psychometric function   (default=0.5)
%     6. threshPerformance: target threhsold performance (must be specified if using arbWeibull, see PF)
%     7. lastPosterior: posterior distribution from earlier run.
%                            when inputted, adaptive method will continue where previous run stopped (default=[])
%     8. PF: shape of underlying psychometric function.
%            can be: PAL_CumulativeNormal, PAL_Weibull, PAL_Quick (similar logistic), PAL_Gumbel, PAL_HyperbolicSecant, PAL_Logistic, or arbWeibull(default)
%     9. updateAfterTrial: if >0, the adaptive method will not be updated based on the posterior
%                                   until the trial number matches the input for this variable (default=0)
%     10. preUpdateLevels: stimulus levels that will be tested before the adaptive method is updated
%                                   (only works if updateAfterTrial>1)
% 2. response: 1=correct; 0=incorrect
%
% ----------------------------------------------------------------------
% Output(s)
% staircase             : structure controlling Palamedes adaptive method
% stairParams           : structure of parameters used to initialize Palamedes
% ----------------------------------------------------------------------
% Function created by Michael Jigo
% Last update : 2020-12-03
% ----------------------------------------------------------------------

function [staircase, stairParams] = usePalamedesStaircase(stairParams,response)

if nargin == 0
    error('ENTER the parameters !!!')
    
elseif nargin==1 % to initialize the staircase
    
    stairParams = validateParams(stairParams);
    staircase = initStaircase(stairParams);
    
elseif nargin==2  % to update the staircase
    stair = stairParams;
    staircase = PAL_AMRF_updateRF(stair, stair.xCurrent, response);
    
end

