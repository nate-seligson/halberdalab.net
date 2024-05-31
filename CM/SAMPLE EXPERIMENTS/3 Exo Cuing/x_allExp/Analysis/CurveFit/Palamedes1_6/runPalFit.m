function [Results, StimLevelsFineGrain, ProportionCorrectModel, probfit]= runPalFit(xvalues,yvalues,n,searchGrid,whichfitparams,nruns,ParOrNonPar,GOF,cutparam,confI,Functionname,ciopt)
%
%PAL_PFML_Demo  Demonstrates use of Palamedes functions to (1) fit a
%Psychometric Function to some data using a Maximum Likelihood criterion, 
%(2) determine standard errors of free parameters using a bootstrap
%procedure and (3) determine the goodness-of-fit of the fit.
%
%Demonstrates basic usage of Palamedes functions:
%-PAL_PFML_Fit
%-PAL_PFML_BootstrapParametric
%-PAL_PFML_BootstrapNonParametric
%-PAL_PFML_GoodnessOfFit
%secondary:
%-PAL_Logistic
%
%More information on any of these functions may be found by typing
%help followed by the name of the function. e.g., help PAL_PFML_Fit
%
%NP (08/23/2009)
% [threshold slope guess-rate lapse-rate]
tic
           
if numel(n)>1
    OutOfNum = n;
else
    OutOfNum = ones(1,size(yvalues,2)).*n;
end

%Fit a Logistic function

PF = str2func(Functionname);
% PF = @Functionname; %@PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull, 
                     %PAL_CumulativeNormal, PAL_HyperbolicSecant

%Optional:
options = PAL_minimize('options');   %type PAL_minimize('options','help') for help
options.TolFun = 1e-09;     %increase required precision on LL
options.MaxIter = 400*sum(whichfitparams);
options.MaxFunEvals = 400*sum(whichfitparams);
options.Display = 'off';    %suppress fminsearch messages
lapseLimits = [0 .05];        %limit range for lambda
maxTries = 10;
                            
%Perform fit
[paramsValues LL , xxx, yyy] = PAL_PFML_Fit(xvalues,yvalues, ...
    OutOfNum,searchGrid,whichfitparams,PF,'searchOptions',options, ...
    'lapseLimits',lapseLimits);

% Bootstrap
if ParOrNonPar == 1
    [SD paramsSim LLSim converged] = PAL_PFML_BootstrapParametric(...
        xvalues, OutOfNum, paramsValues, whichfitparams, nruns, PF, ...
        'searchOptions',options,'lapseLimits',lapseLimits,'searchGrid', ...
        searchGrid ,'maxTries',maxTries);
else
    [SD paramsSim LLSim converged] = PAL_PFML_BootstrapNonParametric(...
        xvalues, yvalues, OutOfNum, [], whichfitparams, nruns, PF,...
        'searchOptions',options,'searchGrid',searchGrid, ...
        'lapseLimits',lapseLimits,'maxTries',maxTries);
end

if GOF
    %Number of simulations to perform to determine Goodness-of-Fit
    [Dev pDev] = PAL_PFML_GoodnessOfFit(xvalues, yvalues, OutOfNum, ...
        paramsValues, whichfitparams, nruns, PF,'searchOptions',options, ...
        'searchGrid', searchGrid, 'lapseLimits',lapseLimits,'maxTries',maxTries);
    Results.GOF.Dev = Dev; % Deviance
    Results.GOF.pDev = pDev; % proportion of the B Deviance values
end

%% Get cuts
StimLevelsFineGrain=  linspace(min(xvalues),max(xvalues),1000);
ProportionCorrectModel = PF(paramsValues,StimLevelsFineGrain);
probfit = PF(paramsValues,StimLevelsFineGrain);

cuts = PF(paramsValues, cutparam, 'Inverse');

%% Get confidence interval for cuts (BCa)
% for thresholds
bootdat = paramsSim(converged == 1,:);
convB = size(bootdat,1);
bootcuts = zeros(convB,size(cutparam,2));
for b = 1:convB
    bootcuts(b,:) = PF(bootdat(b,:), cutparam, 'Inverse');
end

medC = median(bootcuts);
SEcuts = std(bootcuts);
biasC = (medC - cuts) - (.25*SEcuts);

% for slopes
slopes = paramsSim(converged == 1,2);
medS = median(slopes);
SlObs = paramsValues(2);
SEslop = std(slopes); 
biasS = (medS - SlObs) - (.25*SEslop);

%% Percentile
% for thresholds
a = confI;
if a <= 1
    a = a*100;
end

% bca
if strcmp(ciopt,'bca')
    Z = norminv(sum(bootcuts < cuts)/convB);

    % jacknif
    estmean = zeros(1,convB);
    for b = 1:convB
        estmean(b) = mean(bootcuts((1:convB) ~= b));
    end

    zp = norminv((1-(a/100))/2);
    A = ( sum( (estmean - mean(bootcuts)).^3)/( 6*sum( (estmean - mean(bootcuts)).^2))^(3/2));
    A1 = normcdf( (Z+ ( (Z - zp)/(1 - A*(Z - zp)))));
    A2 = normcdf( (Z+ ( (Z + zp)/(1 - A*(Z + zp)))));

    sortedcuts = sort(bootcuts);
    lower = A1*convB;
    upper = A2*convB;
    
    if lower<1
        lower = ceil(lower);
    else
        lower = round(lower);
    end
    if upper<1
        upper = ceil(upper);
    else
        upper = round(upper);
    end
    lower(lower<1) = 1;
    upper(upper<1) = 1;
    cCI = sortedcuts([lower,upper]);
else
    cCI = prctile(bootcuts,[50-a/2,50+a/2]);
end
% for slope
sCI = prctile(slopes,[50-a/2,50+a/2]);

% Confidence boundaries (for plot)
nruns = convB;
npoints = 1000;
bounds = zeros(nruns,npoints);
for b = 1:nruns
    bounds(b,:) = PF(bootdat(b,:),StimLevelsFineGrain);
end
conflims = prctile(bounds,[50-a/2,50+a/2]);

% hold on
% plot(StimLevelsFineGrain,probfit);
% plot(StimLevelsFineGrain,conflims(1,:),'--')
% plot(StimLevelsFineGrain,conflims(2,:),'--')
% plot(cCI,[1 1].*cutparam,'.-');
% plot(xvalues,yvalues./n,'o');
% hold off

%% Store results
Results.paramsValues = paramsValues; % fitted values and fixed values
Results.LL = LL; % Log likelihood of the fit
Results.Boot.SD = SD; % standard deviation of the parameters
Results.Boot.paramsSim = paramsSim; % fitted paramaters for B fits
Results.Boot.LLSim = LLSim; % Log likelihood associated to B fits
Results.Boot.conv = converged;
Results.bootcuts = bootcuts;
Results.cuts = cuts;
Results.SEcuts = SEcuts;
Results.ciCuts = cCI;
Results.slope = SlObs;
Results.SEslop = SEslop;
Results.ciSlop = sCI;
Results.bias = [biasC, biasS];

toc