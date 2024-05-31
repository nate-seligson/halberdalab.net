function [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute randomised design matrix containing all variables used in the 
% experiment.
% ----------------------------------------------------------------------
% Input(s) :
% const : experiment constants
% ----------------------------------------------------------------------
% Output(s):
% expDes : variable design configuration
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline Myers
% Last update : 2021-06-12
% Project : DPF
% Version : 3.0
% ----------------------------------------------------------------------

%% Experimental conditions


%% Experimental variables 

% Rand 1-4 : Tilt direction pos1-4
expDes.rand{1} = [-const.gabor_angle,const.gabor_angle];
expDes.rand{2} = [-const.gabor_angle,const.gabor_angle];
expDes.rand{3} = [-const.gabor_angle,const.gabor_angle];
expDes.rand{4} = [-const.gabor_angle,const.gabor_angle];
% -const.gabor_angle = LFT (50%)
%  const.gabor_angle = RGT (50%)


% Rand 5 : Target location number
if const.task == 1
    expDes.rand{5} = [1:4];
else
    expDes.rand{5} = NaN;
end

% Rand 6 : Cue condition
if const.task == 1 || const.task == 2
    expDes.rand{6} = 2;
else
    expDes.rand{6} = [1,2];
end
% 1 = valid (50%)
% 2 = neutral (50%)


%% Experimental configuration :
expDes.nb_cond =  0;
expDes.nb_var  =  0;
expDes.nb_rand =  numel(expDes.rand);
expDes.nb_list =  0;

%expDes.timeCalibMin = 15;
%expDes.timeCalib = expDes.timeCalibMin*60;


%% Experimental loop
expDes.expMat = [];
for t_trial = 1:const.trial_nb

    % random variables
    rand_r = nan(1,expDes.nb_rand);
    for idx_radn = 1:expDes.nb_rand
        rand_r(idx_radn) = expDes.rand{idx_radn}(randi(numel(expDes.rand{idx_radn})));
    end

    
      %%% condition
    expDes.expMat(t_trial,:)= [ const.fromBlock,    const.task,     t_trial,        NaN,                rand_r(1), ...
                                 rand_r(2),         rand_r(3),      rand_r(4),      rand_r(5),          rand_r(6), ...
                                 NaN,               NaN,            NaN,            NaN,                NaN, ...
                                 NaN,               NaN,            NaN,            NaN,                NaN];
end

if const.task == 2 || const.task == 3
   %rng('shuffle');
   testPos_vec = Shuffle(repmat([1,2,3,4],1,const.trial_nb/4));
   expDes.expMat(:,9) = testPos_vec';
end



if const.checkTrial
    expDes.expMat
end

%% Saving procedure :
% .mat file
save(const.design_fileMat,'expDes');