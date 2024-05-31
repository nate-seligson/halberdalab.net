% Use to initialize and update best PEST or QUEST staircase as implemented
% in the Palamedes toolbox.

function staircase = usePalamedesStaircase(stairParams,response)

%% Initialize staircase
% Initialize the parameters
if nargin==0
    % if nothing is passed in, ask experimenter for each of the parameters
    whichStair = input(['Which staircase protocol do you want to use ',...
        '(1=best PEST; 2=QUEST; default=1)? ']);
    % check that whichStair is valid
    if ~ismember(whichStair,[1 2])
        warning('Input can only be 1 or 2. Setting to default of 1.');
        whichStair = [];
    end
    % if using the QUEST staircase, specify MEAN and SD of prior (gaussian
    % distribution)
    if whichStair==2
        questMean = input('Enter the mean of prior (default=median): ');
        questSD = input('Enter the standard deviation of prior (default=1): ');
    end
    
    alphaRange = input(['Enter the range, and spacing, of the ',...
        'stimulus values (default=0.01:0.1:1): ']);
    % check that alphaRange is valid
    if length(alphaRange)==1
        warning('You must input a range of values. Setting to default.')
        alphaRange = [];
    end
    
    fitBeta = input(['Assumed slope (beta) of the ',...
        'underlying psychometric function (PF; default=2): ']);
    fitLambda = input(['Assumped upper asymptote (lambda) of the ',...
        'underlying PF (default=0.01): ']);
    fitGamma = input('Assumed lower asymptote (gamma) of the PF (default=0.5): ');
    
    perfLevel = input('Enter the expected performance level (default=0.6321): ');
    
    useMyPrior = input('Enter your initial prior: ');
    
    % set defaults
    params = {whichStair alphaRange fitBeta fitLambda fitGamma perfLevel useMyPrior};
    paramNames = {'whichStair' 'alphaRange' 'fitBeta' 'fitLambda' 'fitGamma' 'perfLevel' 'useMyPrior'};
    paramDefaults = {1 0.01:0.01:1 2 0.01 0.5 0.6321 []};
    if whichStair==2
        params = [params {questMean questSD}];
        paramNames = [paramNames {'questMean' 'questSD'}];
        paramDefaults = [paramDefaults {0.5050 1}];
    end
    defaultIdx = find(cellfun('isempty', params));
    for i = defaultIdx
        eval([eval('paramNames{i}'),'= paramDefaults{i};']);
    end
    
    % make stairParams structure
    for i = 1:length(paramNames)
        stairParams.(paramNames{i}) = eval(eval('paramNames{i}'));
    end
    
    % save stairParams structure in current folder
    fprintf(['Saving inputted parameters in the current folder. To use ',...
        'these parameters simply load the saved file and pass the ',...
        'stairParams variable as an input to this function.\n']);
    save('./stairParams.mat','stairParams');
    
    % initialize the staircase
    staircase = initStaircase(stairParams);
elseif nargin==1
    if ischar(stairParams) && strcmp(stairParams,'getPerformanceLevel')
        % Load the stairParams file and get the expected performance level
        load('./stairParams.mat');
        staircase = stairParams.perfLevel;
    else
        % Use this if a structre of parameters are passed in
        % check if all the necessary parameters are present
        paramNames = {'whichStair' 'alphaRange' 'fitBeta' 'fitLambda' 'fitGamma' 'perfLevel'};
        paramsSet = fieldnames(stairParams);
        if ~all(ismember(paramNames,paramsSet))
            error(['Not all parameters are set. Run this function without ',...
                'passing any input to set the necessary parameters.']);
        end
        if stairParams.whichStair==2
            params = [params {questMean questSD}];
            paramNames = [paramNames {'questMean' 'questSD'}];
            paramDefaults = [paramDefaults {0.5050 1}];
        end
        if ~all(ismember(paramNames,paramsSet))
            error(['Not all parameters are set. Run this function without ',...
                'passing any input to set the necessary parameters.']);
        end
        
        % initialize the staircase
        % create a file in the current folder that will store the
        % parameters of the staircase (this is essential for using
        % PAL_Weibull_anyPerfConverge, as it will let the experimenter set the
        % expected performance level
        save('./stairParams.mat','stairParams');
        staircase = initStaircase(stairParams);
    end
    elseif nargin==2
        % When there are two inputs to this function, the first is assumed to
        % be the initialized the staircase and the second is assumed to be the
        % response (0=incorrect or 1=correct) to a trial.
        
        % Update the staircase
        staircase = PAL_AMRF_updateRF(stairParams,stairParams.xCurrent,response);
end

function staircase = initStaircase(stairParams)
% Initialize the staircase
switch stairParams.whichStair
    case 1 % best PEST
        meanMode = 'mode';
        if ~isempty(stairParams.useMyPrior)
            prior = stairParams.useMyPrior;
        else
            prior = ones(1,length(stairParams.alphaRange));
            prior = prior/sum(prior); % make a uniform prior
        end
    case 2 % QUEST
        meanMode = 'mean';
        prior = PAL_pdfNormal(stairParams.alphaRange,median(stairParams.alphaRange),1);
end
staircase = PAL_AMRF_setupRF('priorAlphaRange',stairParams.alphaRange,...
    'stopcriterion','trials','stoprule',inf,'beta',stairParams.fitBeta,...
    'lambda',stairParams.fitLambda,'gamma',stairParams.fitGamma,...
    'meanmode',meanMode,'PF',@PAL_Weibull_anyPerfConverge,'prior',prior);